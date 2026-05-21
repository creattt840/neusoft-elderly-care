# Spring Boot 3.x + MyBatis-Plus 环境安装指南（macOS 版）

> 适用系统：macOS (Intel/Apple Silicon)  
> 目标：零基础快速搭建开发环境  
> 预计时间：30 分钟

---

## 目录

1. [环境要求](#一环境要求)
2. [一键安装脚本](#二一键安装脚本推荐)
3. [分步手动安装](#三分步手动安装)
4. [验证安装](#四验证安装)
5. [创建第一个项目](#五创建第一个-spring-boot--mybatis-plus-项目)
6. [常见问题](#六常见问题)

---

## 一、环境要求

| 组件 | 最低版本 | 说明 |
|------|----------|------|
| JDK | 17+ | Spring Boot 3.x 强制要求 JDK 17+ |
| Maven | 3.6+ | 项目构建工具 |
| MySQL | 8.0+ | 数据库 |
| IDE | - | IntelliJ IDEA 社区版（免费） |

---

## 二、一键安装脚本（推荐）

将以下内容保存为 `setup.sh`，在终端运行：

```bash
#!/bin/bash
# Spring Boot 3.x 开发环境一键安装脚本（macOS）
# 保存为 setup.sh，然后执行: chmod +x setup.sh && ./setup.sh

set -e  # 遇到错误立即退出

echo "=========================================="
echo "Spring Boot 3.x 开发环境安装脚本"
echo "=========================================="

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查是否已安装 Homebrew
if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}正在安装 Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # 将 Homebrew 添加到 PATH（根据芯片类型）
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo -e "${GREEN}Homebrew 已安装${NC}"
fi

# 安装 OpenJDK 17
echo -e "${YELLOW}正在安装 OpenJDK 17...${NC}"
brew install openjdk@17

# 创建符号链接（需要 sudo）
if [[ $(uname -m) == "arm64" ]]; then
    sudo ln -sf /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk 2>/dev/null || true
else
    sudo ln -sf /usr/local/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk 2>/dev/null || true
fi

# 配置环境变量
echo -e "${YELLOW}配置环境变量...${NC}"
if ! grep -q "openjdk@17" ~/.zshrc 2>/dev/null; then
    echo '
# Java 17
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export CPPFLAGS="-I/opt/homebrew/opt/openjdk@17/include"
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
' >> ~/.zshrc
fi

# 安装 Maven
echo -e "${YELLOW}正在安装 Maven...${NC}"
brew install maven

# 安装 MySQL 8.0
echo -e "${YELLOW}正在安装 MySQL 8.0...${NC}"
brew install mysql@8.0

# 启动 MySQL 服务
if ! brew services list | grep mysql | grep started &> /dev/null; then
    echo -e "${YELLOW}启动 MySQL 服务...${NC}"
    brew services start mysql@8.0
fi

# 安全初始化 MySQL（设置 root 密码）
echo -e "${YELLOW}初始化 MySQL 安全设置...${NC}"
echo "提示：按提示设置 root 密码，建议设置为 root 方便开发"
mysql_secure_installation 2>/dev/null || true

echo ""
echo "=========================================="
echo -e "${GREEN}基础环境安装完成！${NC}"
echo "=========================================="
echo ""
echo "接下来请安装 IntelliJ IDEA："
echo "  方式1: 官网下载 https://www.jetbrains.com/idea/download/"
echo "  方式2: brew install --cask intellij-idea-ce"
echo ""

# 验证安装
source ~/.zshrc 2>/dev/null || true

echo "环境版本信息："
echo "Java 版本:"
java -version 2>&1 | head -1

echo ""
echo "Maven 版本:"
mvn -v | head -1

echo ""
echo "MySQL 版本:"
mysql --version 2>&1 | head -1

echo ""
echo -e "${GREEN}安装完成！请重启终端或运行 'source ~/.zshrc' 使配置生效${NC}"
```

### 使用步骤：

```bash
# 1. 创建并编辑脚本文件
cd ~/Desktop
cat > setup.sh << 'EOF'
[粘贴上面的脚本内容]
EOF

# 2. 添加执行权限
chmod +x setup.sh

# 3. 运行脚本
./setup.sh

# 4. 刷新环境变量（安装完成后）
source ~/.zshrc
```

---

## 三、分步手动安装

如果一键脚本遇到问题，可按以下步骤手动安装。

### 3.1 安装 Homebrew（包管理器）

```bash
# 在终端运行
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 添加到环境变量（Apple Silicon Mac）
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Intel Mac 自动配置好，无需额外操作
```

### 3.2 安装 Java 17（JDK）

```bash
# 安装 OpenJDK 17
brew install openjdk@17

# 创建符号链接（需要管理员权限）
# Apple Silicon Mac:
sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk

# Intel Mac:
sudo ln -sfn /usr/local/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk

# 配置环境变量
echo 'export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"' >> ~/.zshrc
echo 'export JAVA_HOME=$(/usr/libexec/java_home -v 17)' >> ~/.zshrc

# 刷新配置
source ~/.zshrc
```

### 3.3 安装 Maven

```bash
brew install maven

# 验证安装
mvn -version
```

### 3.4 安装 MySQL 8.0

```bash
# 安装
brew install mysql@8.0

# 添加到环境变量
echo 'export PATH="/opt/homebrew/opt/mysql@8.0/bin:$PATH"' >> ~/.zshrc

# 刷新配置
source ~/.zshrc

# 启动 MySQL 服务
brew services start mysql@8.0

# 安全初始化（设置 root 密码等）
mysql_secure_installation

# 验证安装
mysql --version
```

### 3.5 安装 IntelliJ IDEA

```bash
# 方式1：使用 Homebrew 安装社区版（免费）
brew install --cask intellij-idea-ce

# 方式2：官网下载（推荐 Ultimate 版，学生可申请免费授权）
# https://www.jetbrains.com/idea/download/
```

---

## 四、验证安装

在终端依次运行以下命令验证：

```bash
# 验证 Java
java -version
# 期望输出：openjdk version "17.x.x"

# 验证 Maven
mvn -version
# 期望输出：Apache Maven 3.x.x

# 验证 MySQL
mysql -u root -p
# 输入密码后进入 mysql> 提示符即成功
# 退出：exit
```

---

## 五、创建第一个 Spring Boot + MyBatis-Plus 项目

### 5.1 使用 Spring Initializr 创建项目

```bash
# 方式1：使用 curl 命令快速创建项目目录结构
mkdir -p ~/Projects/elysium-center
cd ~/Projects/elysium-center

# 方式2：访问 https://start.spring.io/ 可视化创建
# 选择：
#   - Project: Maven
#   - Language: Java
#   - Spring Boot: 3.2.x
#   - Dependencies: Spring Web, MySQL Driver
```

### 5.2 添加 MyBatis-Plus 依赖

在 `pom.xml` 中添加：

```xml
<dependencies>
    <!-- Spring Boot Starter Web -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    
    <!-- MyBatis-Plus -->
    <dependency>
        <groupId>com.baomidou</groupId>
        <artifactId>mybatis-plus-spring-boot3-starter</artifactId>
        <version>3.5.5</version>
    </dependency>
    
    <!-- MySQL 驱动 -->
    <dependency>
        <groupId>com.mysql</groupId>
        <artifactId>mysql-connector-j</artifactId>
        <scope>runtime</scope>
    </dependency>
    
    <!-- Lombok（可选，简化代码） -->
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <optional>true</optional>
    </dependency>
    
    <!-- 测试 -->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
</dependencies>
```

### 5.3 配置数据库连接

创建 `src/main/resources/application.yml`：

```yaml
spring:
  application:
    name: elysium-center
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/elysium_db?serverTimezone=Asia/Shanghai&useUnicode=true&characterEncoding=utf-8
    username: root
    password: root  # 修改为你的 MySQL 密码

mybatis-plus:
  configuration:
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl  # 打印 SQL 日志
  mapper-locations: classpath*:/mapper/**/*.xml
  type-aliases-package: com.neusoft.elysium.entity

server:
  port: 8080
```

### 5.4 初始化数据库脚本

```bash
# 登录 MySQL
mysql -u root -p

# 执行以下 SQL
create database elysium_db character set utf8mb4 collate utf8mb4_unicode_ci;
use elysium_db;

# 创建测试表
CREATE TABLE customer (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    phone VARCHAR(20) NOT NULL COMMENT '手机号',
    name VARCHAR(50) NOT NULL COMMENT '姓名',
    age INT COMMENT '年龄',
    gender VARCHAR(10) COMMENT '性别',
    status VARCHAR(20) DEFAULT 'ACTIVE' COMMENT '状态',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_phone (phone)
) COMMENT='客户表';

exit
```

### 5.5 项目目录结构

```
elysium-center/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/neusoft/elysium/
│   │   │       ├── ElysiumApplication.java    # 启动类
│   │   │       ├── config/                     # 配置类
│   │   │       ├── controller/               # 控制器层
│   │   │       ├── service/                    # 服务层
│   │   │       ├── mapper/                     # 数据访问层
│   │   │       └── entity/                     # 实体类
│   │   └── resources/
│   │       ├── application.yml
│   │       └── mapper/                         # XML 映射文件
│   └── test/
├── pom.xml
└── README.md
```

### 5.6 启动类代码

```java
package com.neusoft.elysium;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.neusoft.elysium.mapper")  // 扫描 Mapper 接口
public class ElysiumApplication {
    public static void main(String[] args) {
        SpringApplication.run(ElysiumApplication.class, args);
    }
}
```

### 5.7 运行项目

```bash
# 在项目根目录执行
mvn spring-boot:run

# 或使用 IDEA 直接运行 ElysiumApplication
```

访问 http://localhost:8080 测试是否启动成功。

---

## 六、常见问题

### Q1: 提示 "JAVA_HOME not set"?

```bash
# 手动设置 JAVA_HOME
export JAVA_HOME=$(/usr/libexec/java_home -v 17)

# 添加到 ~/.zshrc 永久生效
echo 'export JAVA_HOME=$(/usr/libexec/java_home -v 17)' >> ~/.zshrc
```

### Q2: Maven 下载依赖速度慢？

```bash
# 编辑 ~/.m2/settings.xml 配置阿里云镜像
mkdir -p ~/.m2
cat > ~/.m2/settings.xml << 'EOF'
<settings>
  <mirrors>
    <mirror>
      <id>aliyunmaven</id>
      <name>阿里云公共仓库</name>
      <url>https://maven.aliyun.com/repository/public</url>
      <mirrorOf>central</mirrorOf>
    </mirror>
  </mirrors>
</settings>
EOF
```

### Q3: MySQL 无法连接？

```bash
# 检查 MySQL 服务状态
brew services list | grep mysql

# 如果未运行，手动启动
brew services restart mysql@8.0

# 检查端口
lsof -i :3306

# 重置 root 密码
mysql_secure_installation
```

### Q4: Spring Boot 启动报错 "Failed to configure a DataSource"?

检查 `application.yml` 中的数据库配置：
- 数据库名称是否正确
- 用户名密码是否正确
- MySQL 服务是否启动

### Q5: Apple Silicon Mac 安装问题

```bash
# 部分工具可能需要 Rosetta 2
softwareupdate --install-rosetta --agree-to-license

# 确保 Homebrew 路径正确
# ARM Mac: /opt/homebrew/bin
# Intel Mac: /usr/local/bin
```

---

## 附录：常用命令速查

| 命令 | 说明 |
|------|------|
| `java -version` | 查看 Java 版本 |
| `mvn -version` | 查看 Maven 版本 |
| `mvn clean install` | 清理并构建项目 |
| `mvn spring-boot:run` | 运行 Spring Boot 项目 |
| `brew services start mysql@8.0` | 启动 MySQL |
| `brew services stop mysql@8.0` | 停止 MySQL |
| `mysql -u root -p` | 登录 MySQL |

---

> 文档版本：v1.0  
> 更新日期：2025-05-19  
> 适用平台：macOS 13.0+
