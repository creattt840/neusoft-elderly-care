<template>
  <div class="ai-chat-fab" @click="openPanel" v-show="!visible">
    <el-icon :size="24" color="white"><ChatDotRound /></el-icon>
    <span v-if="unread > 0" class="fab-badge">{{ unread }}</span>
  </div>

  <div :class="['ai-chat-panel', { fullscreen: isFullscreen, 'panel-enter': panelEnter, 'panel-leave': panelLeave }]"
       v-show="panelVisible">
    <div class="panel-header">
      <div class="header-avatar">
        <el-icon :size="18" color="white"><FirstAidKit /></el-icon>
      </div>
      <div class="header-info">
        <span class="header-title">东软颐养中心</span>
        <span class="header-sub"><i class="online-dot" />智能客服在线</span>
      </div>
      <div class="header-actions">
        <el-icon class="action-icon" @click="clearMessages"><Delete /></el-icon>
        <el-icon class="action-icon" @click="toggleFullscreen">
          <FullScreen v-if="!isFullscreen" />
          <Aim v-else />
        </el-icon>
        <el-icon class="action-icon" @click.stop="closePanel"><Close /></el-icon>
      </div>
    </div>

    <div class="suggest-bar" v-if="messages.length <= 1">
      <span v-for="s in SUGGESTIONS" :key="s" class="suggest-tag" @click="sendSuggestion(s)">
        {{ s }}
      </span>
    </div>

    <div class="message-list" ref="messageListRef">
      <div v-for="(msg, index) in messages" :key="index" :class="['msg-row', msg.role]">
        <div class="msg-avatar" :class="msg.role">
          <el-icon v-if="msg.role === 'assistant'"><FirstAidKit /></el-icon>
          <el-icon v-else><User /></el-icon>
        </div>
        <div v-if="msg.role === 'assistant'" class="bubble assistant">
          <span v-html="renderMd(msg.content)"></span>
          <span v-if="index === messages.length - 1 && streaming" class="cursor-blink">|</span>
        </div>
        <div v-else class="bubble user">
          {{ msg.content }}
        </div>
      </div>
      <div class="msg-row assistant" v-if="waiting">
        <div class="msg-avatar assistant"><el-icon><FirstAidKit /></el-icon></div>
        <div class="bubble assistant typing-bubble">
          <span class="dot" /><span class="dot" /><span class="dot" />
        </div>
      </div>
    </div>

    <div class="input-area">
      <el-input
          v-model="inputText"
          type="textarea"
          :autosize="{ minRows: 1, maxRows: 4 }"
          placeholder="输入消息，Enter 发送"
          resize="none"
          @keydown.enter.exact.prevent="sendMessage"
          :disabled="streaming || waiting"
          class="chat-input"
      />
      <el-button
          :icon="Promotion"
          circle
          :disabled="!inputText.trim() || streaming || waiting"
          @click="sendMessage"
          class="send-btn"
      />
    </div>
  </div>
</template>

<script setup>
import { ref, nextTick } from 'vue'
import { ChatDotRound, Delete, Close, User, Promotion, FullScreen, Aim, FirstAidKit } from '@element-plus/icons-vue'
import MarkdownIt from 'markdown-it'

const API_URL = (import.meta.env.VITE_BASE_URL || '') + '/api/chat/stream'
const GREETING = '您好！我是东软颐养中心的智能客服小智，有什么可以帮您的吗？'
const SUGGESTIONS = ['护理服务介绍', '入住流程咨询', '膳食安排', '联系工作人员']
const SESSION_ID = crypto.randomUUID()

const visible = ref(false)
const panelVisible = ref(false)
const panelEnter = ref(false)
const panelLeave = ref(false)
const isFullscreen = ref(false)
const inputText = ref('')
const streaming = ref(false)
const waiting = ref(false)
const unread = ref(0)
const messageListRef = ref(null)
const messages = ref([{ role: 'assistant', content: GREETING }])
const md = new MarkdownIt()

function toggleFullscreen() {
  isFullscreen.value = !isFullscreen.value
  nextTick(scrollToBottom)
}

function openPanel() {
  visible.value = true
  panelVisible.value = true
  unread.value = 0
  nextTick(() => {
    panelEnter.value = true
    panelLeave.value = false
    nextTick(scrollToBottom)
  })
}

function closePanel() {
  visible.value = false
  panelEnter.value = false
  panelLeave.value = true
  setTimeout(() => {
    panelVisible.value = false
    panelLeave.value = false
    isFullscreen.value = false
    visible.value = false
  }, 200)
}

function clearMessages() {
  messages.value = [{ role: 'assistant', content: GREETING }]
}

function sendSuggestion(text) {
  inputText.value = text
  sendMessage()
}

async function sendMessage() {
  const text = inputText.value.trim()
  if (!text || streaming.value || waiting.value) return

  messages.value.push({ role: 'user', content: text })
  inputText.value = ''
  waiting.value = true
  await nextTick(scrollToBottom)

  const es = new EventSource(
      `${API_URL}?message=${encodeURIComponent(text)}&sessionId=${SESSION_ID}`
  )

  messages.value.push({ role: 'assistant', content: '' })
  const lastIdx = messages.value.length - 1
  waiting.value = false
  streaming.value = true

  es.onmessage = async ({ data }) => {
    messages.value[lastIdx].content += data
    await nextTick(scrollToBottom)
  }

  es.onerror = () => {
    es.close()
    streaming.value = false
    if (!visible.value) unread.value++
  }
}

function scrollToBottom() {
  if (messageListRef.value)
    messageListRef.value.scrollTop = messageListRef.value.scrollHeight
}

function renderMd(content) {
  return md.render(content || '')
}
</script>

<style scoped>
:root {
  --care-primary: #2d7a72;
  --care-primary-dark: #1a4f4a;
  --care-primary-light: #3d9a90;
  --care-gold: #f0c060;
  --care-bg: #f4f6f5;
}

.ai-chat-fab {
  position: fixed;
  bottom: 28px;
  right: 28px;
  width: 54px;
  height: 54px;
  border-radius: 50%;
  background: linear-gradient(135deg, #2d7a72, #1a4f4a);
  box-shadow: 0 4px 20px rgba(45, 122, 114, .45);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  z-index: 9997;
  transition: transform .2s, box-shadow .2s;
}

.ai-chat-fab:hover {
  transform: scale(1.1);
  box-shadow: 0 6px 28px rgba(45, 122, 114, .6);
}

.fab-badge {
  position: absolute;
  top: 0;
  right: 0;
  min-width: 18px;
  height: 18px;
  padding: 0 4px;
  border-radius: 9px;
  background: #f56c6c;
  border: 2px solid white;
  font-size: 11px;
  color: white;
  font-weight: 600;
  display: flex;
  align-items: center;
  justify-content: center;
}

.ai-chat-panel {
  position: fixed;
  bottom: 96px;
  right: 28px;
  width: 380px;
  height: 540px;
  background: white;
  border-radius: 16px;
  box-shadow: 0 8px 48px rgba(26, 79, 74, .18);
  display: flex;
  flex-direction: column;
  overflow: hidden;
  z-index: 9998;
  transform: scale(0.6) translateY(30px);
  opacity: 0;
  transform-origin: bottom right;
  pointer-events: none;
  transition: width .3s ease, height .3s ease, bottom .3s ease,
  right .3s ease, border-radius .3s ease;
}

.ai-chat-panel.panel-enter {
  animation: chatPopIn .28s cubic-bezier(.34, 1.56, .64, 1) forwards;
  pointer-events: auto;
}

.ai-chat-panel.panel-leave {
  animation: chatPopOut .2s ease-in forwards;
  pointer-events: none;
}

.ai-chat-panel.fullscreen {
  bottom: 0;
  right: 0;
  width: 100vw;
  height: 100vh;
  border-radius: 0;
}

@keyframes chatPopIn {
  from {
    transform: scale(.6) translateY(30px);
    opacity: 0;
    transform-origin: bottom right;
  }
  to {
    transform: scale(1) translateY(0);
    opacity: 1;
    transform-origin: bottom right;
  }
}

@keyframes chatPopOut {
  from {
    transform: scale(1) translateY(0);
    opacity: 1;
    transform-origin: bottom right;
  }
  to {
    transform: scale(.6) translateY(20px);
    opacity: 0;
    transform-origin: bottom right;
  }
}

.panel-header {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 14px 16px;
  flex-shrink: 0;
  background: linear-gradient(135deg, #1a4f4a 0%, #2d7a72 60%, #3d9a90 100%);
}

.header-avatar {
  width: 38px;
  height: 38px;
  border-radius: 10px;
  background: rgba(255, 255, 255, .12);
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  color: #f0c060;
  font-size: 20px;
}

.header-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 3px;
}

.header-title {
  font-size: 15px;
  font-weight: 600;
  color: white;
  font-family: 'Noto Serif SC', serif;
  letter-spacing: 1px;
}

.header-sub {
  font-size: 11px;
  color: rgba(255, 255, 255, .7);
  display: flex;
  align-items: center;
  gap: 4px;
}

.online-dot {
  display: inline-block;
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: #67c23a;
  box-shadow: 0 0 5px #67c23a;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 8px;
}

.action-icon {
  color: rgba(255, 255, 255, .75);
  cursor: pointer;
  font-size: 16px;
  transition: color .15s;
}

.action-icon:hover {
  color: white;
}

.suggest-bar {
  display: flex;
  gap: 6px;
  padding: 10px 14px;
  overflow-x: auto;
  background: #f0f5f4;
  border-bottom: 1px solid #dce8e6;
  flex-shrink: 0;
}

.suggest-bar::-webkit-scrollbar {
  display: none;
}

.suggest-tag {
  font-size: 12px;
  padding: 5px 12px;
  white-space: nowrap;
  border: 1px solid #c5dbd8;
  border-radius: 14px;
  color: #2d7a72;
  cursor: pointer;
  background: white;
  transition: border-color .15s, color .15s, background .15s;
}

.suggest-tag:hover {
  border-color: #2d7a72;
  background: #e8f2f0;
  color: #1a4f4a;
}

.message-list {
  flex: 1;
  overflow-y: auto;
  padding: 14px 14px;
  display: flex;
  flex-direction: column;
  gap: 12px;
  background: #f4f6f5;
}

.message-list::-webkit-scrollbar {
  width: 4px;
}

.message-list::-webkit-scrollbar-thumb {
  background: #c5dbd8;
  border-radius: 2px;
}

.msg-row {
  display: flex;
  align-items: flex-end;
  gap: 8px;
}

.msg-row.user {
  flex-direction: row-reverse;
}

.msg-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  font-size: 14px;
}

.msg-avatar.assistant {
  background: linear-gradient(135deg, #1a4f4a, #2d7a72);
  color: #f0c060;
  border-radius: 10px;
}

.msg-avatar.user {
  background: #e8f2f0;
  color: #2d7a72;
}

.bubble {
  max-width: min(600px, 65%);
  padding: 10px 14px;
  font-size: 13px;
  line-height: 1.6;
  word-break: break-word;
}

.bubble.assistant {
  background: white;
  color: #303133;
  border-radius: 4px 14px 14px 14px;
  box-shadow: 0 1px 6px rgba(26, 79, 74, .08);
}

.bubble.user {
  background: linear-gradient(135deg, #2d7a72, #1a4f4a);
  color: white;
  border-radius: 14px 4px 14px 14px;
}

.typing-bubble {
  display: flex;
  align-items: center;
  gap: 5px;
  padding: 12px 16px;
}

.dot {
  display: inline-block;
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: #c5dbd8;
  animation: dotBounce 1.4s infinite ease-in-out;
}

.dot:nth-child(2) { animation-delay: .16s; }
.dot:nth-child(3) { animation-delay: .32s; }

@keyframes dotBounce {
  0%, 80%, 100% { transform: translateY(0); background: #c5dbd8; }
  40% { transform: translateY(-7px); background: #2d7a72; }
}

.cursor-blink {
  color: #2d7a72;
  animation: cursorBlink .7s infinite;
}

@keyframes cursorBlink {
  0%, 100% { opacity: 1; }
  50% { opacity: 0; }
}

.input-area {
  display: flex;
  align-items: flex-end;
  gap: 8px;
  padding: 10px 14px;
  border-top: 1px solid #dce8e6;
  background: white;
  flex-shrink: 0;
}

.chat-input { flex: 1; }

.chat-input :deep(.el-textarea__inner) {
  border-radius: 10px;
  font-size: 13px;
  line-height: 1.5;
  padding: 8px 12px;
  resize: none;
  border-color: #c5dbd8;
}

.chat-input :deep(.el-textarea__inner:focus) {
  border-color: #2d7a72;
  box-shadow: 0 0 0 2px rgba(45, 122, 114, .12);
}

.send-btn {
  flex-shrink: 0;
  width: 36px;
  height: 36px;
  background: linear-gradient(135deg, #2d7a72, #1a4f4a);
  border: none;
  color: white;
}

.send-btn:hover {
  background: linear-gradient(135deg, #3d9a90, #2d7a72);
}

.send-btn:disabled {
  background: #c5dbd8;
  color: white;
}

@media (max-width: 480px) {
  .ai-chat-panel {
    right: 0;
    bottom: 0;
    width: 100vw;
    height: 70vh;
    border-radius: 16px 16px 0 0;
  }
  .ai-chat-fab {
    bottom: 20px;
    right: 20px;
  }
}

.bubble.assistant :deep(p) {
  margin: 0;
}
</style>