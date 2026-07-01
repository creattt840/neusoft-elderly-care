# 编码规范

## 一、分层架构规则

### 1.1 Controller 层

**只做两件事：参数校验 + 调用 Service，不写任何业务逻辑。**

```java
// ✅ 正确示例
@RestController
@RequestMapping("/api/elderly")
public class ElderlyController {

    @Autowired
    private ElderlyService elderlyService;

    @GetMapping("/{id}")
    public Result<Elderly> getById(@PathVariable Long id) {
        // 仅调用 Service，不做任何业务判断
        return Result.success(elderlyService.getById(id));
    }

    @PostMapping
    public Result<Boolean> save(@RequestBody @Valid Elderly elderly) {
        // 参数校验交给 @Valid + JSR-303，Controller 只管调用
        return Result.success(elderlyService.save(elderly));
    }
}
```

```java
// ❌ 错误示例：Controller 里写业务逻辑
@PostMapping("/check-in")
public Result<Boolean> checkIn(@RequestBody Elderly elderly, @RequestParam Long bedId) {
    // 错误：业务判断不应该出现在 Controller
    if (bedService.getById(bedId).getStatus() == 1) {
        return Result.fail("床位已被占用");
    }
    elderlyService.checkIn(elderly, bedId);
    return Result.success(true);
}
```

**Controller 允许的操作：**
- `@Valid` / `@NotNull` / `@NotBlank` 等 JSR-303 注解校验
- 调用一个或多个 Service 方法组合返回数据
- 绑定请求参数到 DTO

**Controller 禁止的操作：**
- 任何 if/else 业务判断
- 直接调用 Mapper
- 操作数据库
- 抛出业务异常以外的异常处理逻辑

---

### 1.2 Service 层

**所有业务逻辑必须写在 Service 实现类中。** Service 层采用「接口 + 实现类」模式：

- **接口** 放在 `service/` 包，继承 MyBatis-Plus 的 `IService<T>`，声明自定义方法签名
- **实现类** 放在 `service/impl/` 包，继承 `ServiceImpl<Mapper, Entity>` 并实现对应接口，写全部业务逻辑

```java
// ✅ 正确示例：接口只声明方法
public interface ElderlyService extends IService<Elderly> {
    void checkIn(Elderly elderly, Long bedId);
    void checkOut(Long elderlyId);
    Long countActiveElderly();
    Long countCheckedOutElderly();
}
```

```java
// ✅ 正确示例：实现类写全部业务逻辑
@Service
public class ElderlyServiceImpl extends ServiceImpl<ElderlyMapper, Elderly> implements ElderlyService {

    @Autowired
    private BedService bedService;   // 注入其他模块 Service 接口

    @Override
    @Transactional
    public void checkIn(Elderly elderly, Long bedId) {
        Bed bed = bedService.getById(bedId);           // 通过 Service 接口调用
        Assert.notNull(bed, "床位不存在");

        if (bed.getStatus() != null && bed.getStatus() == 1) {
            throw new BusinessException("该床位已被占用");
        }

        elderly.setBedId(bedId);
        elderly.setStatus(1);
        baseMapper.insert(elderly);

        bed.setStatus(1);
        bed.setElderlyId(elderly.getId());
        bedService.updateById(bed);                    // 通过 Service 接口更新
    }
}
```

**Service 允许的操作：**
- 所有业务逻辑判断
- 调用本方 Mapper 操作数据库（`baseMapper` 或注入的自身模块 Mapper）
- 调用其他 Service（通过 `@Autowired` 注入的 Service **接口**）
- 事务管理（`@Transactional`）
- 抛出业务异常

---

### 1.3 跨模块调用规则 ⚠️

**跨模块调用必须走 Service，严禁直接引用其他模块的 Mapper 或 Entity。**

| 调用方式 | 是否允许 | 说明 |
|---------|---------|------|
| `thisService` → `otherService` | ✅ 允许 | 正确方式 |
| `thisService` → `otherMapper` | ❌ 禁止 | 绕过业务逻辑 |
| `thisService` → `otherEntity`（直接操作） | ❌ 禁止 | 破坏封装 |
| `thisController` → `otherService` | ✅ 允许 | Controller 可组合多个 Service |

```java
// ❌ 错误示例（已修复）
@Service
public class ElderlyServiceImpl extends ServiceImpl<ElderlyMapper, Elderly> implements ElderlyService {

    @Autowired
    private BedMapper bedMapper;  // ❌ 禁止：直接注入其他模块的 Mapper

    public void checkIn(Elderly elderly, Long bedId) {
        bedMapper.selectById(bedId);      // ❌ 绕过 BedService
        bedMapper.updateById(bed);         // ❌ 直接操作其他模块数据
    }
}
```

```java
// ✅ 正确方式
@Service
public class ElderlyServiceImpl extends ServiceImpl<ElderlyMapper, Elderly> implements ElderlyService {

    @Autowired
    private BedService bedService;  // ✅ 注入 Service 接口

    public void checkIn(Elderly elderly, Long bedId) {
        bedService.getById(bedId);        // ✅ 通过接口获取
        bedService.updateById(bed);       // ✅ 通过接口更新
    }
}
```

**原因：**
- 其他模块的 Mapper 可能包含隐藏的业务规则（如状态校验、级联操作），直接调用 Mapper 会绕过这些规则
- 保持模块边界清晰，降低耦合
- 方便后续做缓存、权限控制等横向增强

---

### 1.4 Mapper 层

**Mapper 只做数据访问，不写业务逻辑。** 每个 Mapper 只操作自己对应的表。

```java
// ✅ 正确示例
@Mapper
public interface ElderlyMapper extends BaseMapper<Elderly> {

    // 自定义查询也应该是纯数据操作
    @Select("SELECT COUNT(*) FROM elderly WHERE status = 1")
    Long countActiveElderly();
}
```

**Mapper 禁止的操作：**
- 任何业务判断逻辑
- 直接操作不属于自己管理的表
- 抛出业务异常（应返回空/0/null，由 Service 判断）

---

## 二、包结构与职责

```
com.neusoft.elderly
├── common/          # 公共工具类、基类、全局异常处理、通用返回对象
│   ├── Result.java
│   ├── PageResult.java
│   ├── BusinessException.java
│   ├── AuthTokenUtils.java     # 从请求头解析 Bearer Token
│   ├── UserContext.java        # 当前登录用户 ThreadLocal
│   └── GlobalExceptionHandler.java
├── config/          # 配置类（Spring Security、MyBatis-Plus、Redis 缓存、拦截器等）
│   ├── AuthInterceptor.java    # 登录 Token 校验拦截器
│   ├── RedisCacheConfig.java   # Spring Cache + Redis
│   ├── WebMvcConfig.java       # 拦截器注册
│   └── SecurityConfig.java     # 密码加密等安全配置
├── controller/      # 控制器（只做参数校验 + 调用 Service）
├── dto/             # 数据传输对象（请求/响应专用，区别于 Entity）
├── entity/          # 数据库实体（与表一一对应）
├── mapper/          # 数据访问层（MyBatis Mapper 接口）
├── service/         # 业务逻辑接口
│   ├── PageCacheService.java           # 分页缓存整区清除
│   ├── RelatedRecordCleanupService.java # 删除前关联数据清理
│   └── impl/        # 业务逻辑实现类
└── vo/              # 视图对象（前端展示用，区别于 Entity）
```

### 2.1 `common` 包规则

**以下内容必须放在 `common` 包：**

| 类型 | 示例 | 说明 |
|------|------|------|
| 统一返回对象 | `Result<T>` | 所有接口统一返回格式 |
| 分页返回对象 | `PageResult<T>` | 分页查询统一返回格式 |
| 全局异常处理 | `GlobalExceptionHandler` | `@ControllerAdvice` 全局异常拦截 |
| 业务异常类 | `BusinessException` | 自定义业务异常 |
| 公共工具类 | `DateUtils`, `StringUtils` | 通用静态工具方法 |
| 公共常量 | `Constants` | 全局常量定义 |
| 公共枚举 | `StatusEnum` 等 | 跨模块使用的枚举 |

**`common` 包不保存的内容：**
- 与特定业务模块相关的工具类（放对应模块的 service 包）
- 配置类（放 `config` 包）

---

## 三、历史违规修复记录

以下违规已在 2026-06-03 修复：

| 文件 | 问题 | 修复方式 |
|------|------|----------|
| `ElderlyService.java` | 直接注入 `BedMapper`，绕过 `BedService` | 改为注入 `BedService`，所有调用走 Service |
| `AuthController.java` | 注册/登录中写业务逻辑（手机号校验、密码加密、状态检查） | 业务逻辑下沉到 `UserService.register()` / `UserService.login()` |
| `OutingController.java` | `returnOuting()` 中直接操作 Entity 状态 | 封装到 `OutingService.returnOuting()` |
| `ServiceController.java` | `list()` 中直接构造 lambdaQuery 条件 | 封装到 `ServiceInfoService.getActiveByType()` |
| `common/` | 缺少 `BusinessException` | 新建 `BusinessException` 并注册到 `GlobalExceptionHandler` |
| 认证模块 | 使用 JWT 无状态 Token | 改为 Redis 存储 Token + `AuthInterceptor` 拦截校验，Token 默认 24 小时过期 |
| `AuthController.java` | Controller 内 VO 转换、Token 解析与登录编排 | 下沉到 `UserService`，Token 解析抽到 `AuthTokenUtils` |
| Controller 可选参数分支 | `ServiceController`/`CareController`/`CareRecordController` 内 if/else | 合并为 Service 单一入口方法 |
| 接口返回 Entity / MyBatis Page | 列表与详情接口直接返回 Entity，分页返回 `Page<T>` | 查询接口统一返回 VO，分页统一返回 `PageResult<T>` |

---

## 四、缓存与删除规范

### 4.1 分页列表缓存

- 分页/列表查询方法使用 `@Cacheable`，缓存名定义在 `CacheNames`
- 带筛选条件的接口，key 必须包含全部查询参数（`CacheKeyUtils.pageKey`）
- 写操作（`save` / `updateById` / `removeById` 或业务方法）成功后调用 `PageCacheService.clear*()` 整区清除
- 不使用 `@CacheEvict`，统一走 `PageCacheService` 便于跨模块级联

### 4.2 删除与关联数据

- 存在外键约束时，必须在 Service 层先清理关联记录或抛出 `BusinessException` 阻止删除
- 关联清理逻辑集中在 `RelatedRecordCleanupService`，避免在 Controller 中处理
- 删除方法加 `@Transactional(rollbackFor = Exception.class)`
- 前端 axios 拦截器校验 `code === 200`；删除操作使用 `utils/message.js` 的 `runWithMessage` 统一提示

---

## 五、开发检查清单

在提交代码前，确认以下事项：

- [ ] Controller 是否只做了参数校验和 Service 调用？有没有业务 if/else？
- [ ] 业务逻辑是否全部在 Service 中？
- [ ] 有没有在 Service 中直接注入其他模块的 Mapper？（搜索 `@Autowired` + 非本模块 Mapper）
- [ ] 新加的公共工具类、基类是否放在了 `common` 包？
- [ ] 跨模块的数据操作是否都通过对应的 Service？
- [ ] 分页查询是否包含完整缓存 key？写操作是否清除对应缓存？
- [ ] 删除操作是否处理了外键关联数据？

---

## 六、规范执行

- **Code Review 时**，重点检查上述四条分层规则
- **新代码** 必须严格遵守
- **存量违规** 见到就改，不专门安排大规模重构
