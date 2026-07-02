package com.neusoft.elderly.controller;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.client.advisor.MessageChatMemoryAdvisor;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.ai.chat.memory.InMemoryChatMemoryRepository;
import org.springframework.ai.chat.memory.MessageWindowChatMemory;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

/**
 * AI 对话接口
 * <p>
 * 对外只暴露一个接口：GET /api/chat/stream
 * 前端用 EventSource 连接，后端把大模型的回答一个字一个字地"推"过去
 * 也就是常见的"打字机效果"
 */
@RestController
@RequestMapping("/api/chat")
public class ChatController {

    // ChatClient 是 Spring AI 提供的"大模型客户端"
    // 所有跟大模型的交互都通过它来完成
    private final ChatClient chatClient;

    // 默认提示词 prompt
    private static final String BASE_SYSTEM = """
           【你的身份】
              你是"东软颐养中心"的智能客服小智，专注于为老年人及其家属提供专业的养老服务咨询。
                                         
           【你能做的】
             - 解答中心各类服务项目（日间照料、长期照护、康复护理等）
             - 介绍入住流程、收费标准、房型设施
             - 解答老年人日常健康护理、饮食营养相关问题
             - 引导家属完成预约参观、入住申请等操作
             - 解释页面上各功能模块、按钮的含义和使用方法
             - 提供常见问题的自助排查指引
             
           【你不能做的】
             - 不提供医疗诊断、处方建议或用药指导
             - 不代替医生进行健康评估
             - 不处理退款、资金转账等财务操作
             - 不泄露其他住户的个人信息
             
           【回答风格】
             - 语言通俗易懂，考虑到用户可能是老年人或其家属
             - 态度温和耐心，语气温和亲切
             - 涉及医疗相关问题时，建议咨询专业医生或联系中心护理团队
             - 回答简洁明了，避免过长段落，适当分点说明
            """;

    /**
     * 构造方法：初始化 ChatClient
     * <p>
     * Spring Boot 启动时会自动把 ChatClient.Builder 注入进来
     * Builder 会读取 application.yml 里配置的 api-key、model 等参数
     */
    public ChatController(ChatClient.Builder builder) {

        // ---- 第一步：配置对话记忆 ----
        // 大模型本身是"无状态"的，每次请求它都不知道之前说过什么
        // 所以需要我们自己把历史对话存起来，每次请求时一起带过去
        // InMemoryChatMemoryRepository = 把历史记录存在内存里（重启后清空）
        // MessageWindowChatMemory = 滑动窗口，只保留最近 N 条，避免超出 token 限制
        ChatMemory chatMemory = MessageWindowChatMemory.builder()
                .chatMemoryRepository(new InMemoryChatMemoryRepository())
                .maxMessages(20)   // 最多记住最近 20 条对话（10问10答）
                .build();

        // ---- 第二步：构建 ChatClient ----
        // MessageChatMemoryAdvisor 是一个"拦截器"
        // 它会在每次发请求前，自动把历史记录塞进去
        // 在收到回复后，自动把这轮对话存进记忆里
        // 你不需要手动管理消息列表，它全帮你做了
        this.chatClient = builder
                .defaultSystem(BASE_SYSTEM)
                .defaultAdvisors(MessageChatMemoryAdvisor.builder(chatMemory).build())
                .build();
    }

    /**
     * 流式对话接口
     * <p>
     * 请求示例：GET /api/chat/stream?message=你好&sessionId=abc123
     *
     * @param message   用户发送的消息内容
     * @param sessionId 会话ID，用来区分不同用户的对话记忆
     *                  同一个 sessionId = 同一个对话上下文
     *                  前端可以用 crypto.randomUUID() 生成，每个用户一个
     */
    @GetMapping(value = "/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    // produces = TEXT_EVENT_STREAM_VALUE 告诉浏览器：
    // 这个接口返回的是 SSE 格式（Server-Sent Events），不是普通 JSON
    // 浏览器的 EventSource 就是专门接收这种格式的
    public SseEmitter stream(
            @RequestParam String message,
            @RequestParam(defaultValue = "default") String sessionId) {

        // SseEmitter 是 Spring MVC 提供的 SSE 推送工具
        // 可以理解为一根"水管"，后端往里写数据，前端实时收到
        // 180_000L = 超时时间 180秒，超时后连接自动断开
        SseEmitter emitter = new SseEmitter(180_000L);

        chatClient.prompt()
                .user(message)    // 用户这次发送的消息内容
                // 把本次请求绑定到对应的会话 ID
                // MessageChatMemoryAdvisor 会根据这个 ID：
                //   1. 发请求前：自动把该会话的历史记录拼进去
                //   2. 收到回复后：自动把本轮对话存进记忆
                .advisors(a -> a.param(ChatMemory.CONVERSATION_ID, sessionId))
                // 开启流式模式
                // 大模型每生成一个 token 就立刻返回，而不是等全部生成完再返回
                // 这样前端才能实现"打字机"效果
                .stream()
                .content()
                // subscribe 订阅这个数据流，类似于"监听"
                // 大模型每吐出一段文字，就会触发下面对应的回调
                .subscribe(
                        // ① 每收到一个 token（一个字或几个字）就立刻推给前端
                        token -> {
                            try {
                                emitter.send(token);
                            } catch (Exception e) {
                                // 发送失败（比如用户关闭了页面），终止推送
                                emitter.completeWithError(e);
                            }
                        },
                        // ② 大模型返回报错时，把错误通知前端并关闭连接
                        emitter::completeWithError,
                        // ③ 大模型全部回答完毕，正常关闭连接
                        emitter::complete
                );

        // 立刻返回 emitter，连接保持打开
        // 后续数据会通过上面的 subscribe 回调异步推送
        return emitter;
    }
}
