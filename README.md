#### vhr 

### 项目技术栈

#### 后端技术栈

1. Spring Boot
2. Spring Security
3. MyBatis
4. MySQL
5. Redis
6. RabbitMQ
7. Spring Cache
8. WebSocket
9. ...

#### 前端技术栈

1. Vue
2. ElementUI
3. axios
4. vue-router
5. Vuex
6. WebSocket
7. vue-cli4
8. ...

### 项目效果图

首先，不同的用户在登录成功之后，根据不同的角色，会看到不同的系统菜单，完整菜单如下：

![p278](https://raw.githubusercontent.com/wiki/lenve/vhr/doc/p278.png)

不同用户登录上来之后，可能看到的会有差异，如下：

![p279](https://raw.githubusercontent.com/wiki/lenve/vhr/doc/p279.png)

每个用户的角色是由系统管理员进行分配的，系统管理员给用户分配角色的页面如下：

![p280](https://raw.githubusercontent.com/wiki/lenve/vhr/doc/p280.png)

系统管理员也可以管理不同角色可以操作的资源，页面如下：

![p281](https://raw.githubusercontent.com/wiki/lenve/vhr/doc/p281.png)

## 快速部署

1. clone 项目到本地 `git@github.com:lenve/vhr.git`
2. 数据库脚本使用 Flyway 管理，**不需要手动导入数据库脚本**，只需要提前在本地 MySQL 中创建一个空的数据库 vhr，并修改项目中关于数据的配置（resources 目录下的 application.properties 文件中）即可
3. 提前准备好 Redis，在 项目的 application.properties 文件中，将 Redis 配置改为自己的
4. 提前准备好 RabbitMQ，在项目的 application.properties 文件中将 RabbitMQ 的配置改为自己的（**注意，RabbitMQ 需要分别修改 mailserver 和 vhrserver 的配置文件**）
5. 在 IntelliJ IDEA 中打开 vhr 项目，启动 mailserver 模块
6. 运行 vhrserver 中的 vhr-web 模块

**OK，至此，服务端就启动成功了，此时我们直接在地址栏输入 `http://localhost:8081/index.html` 即可访问我们的项目，如果要做二次开发，请继续看第七、八步。**

7. 进入到vuehr目录中，在命令行依次输入如下命令：

```
# 安装依赖
npm install

# 在 localhost:8080 启动项目
npm run serve
```

由于我在 vuehr 项目中已经配置了端口转发，将数据转发到 Spring Boot 上，因此项目启动之后，在浏览器中输入 `http://localhost:8080` 就可以访问我们的前端项目了，所有的请求通过端口转发将数据传到 Spring Boot 中（注意此时不要关闭 Sprin gBoot 项目）。

8. 最后可以用 WebStorm 等工具打开 vuehr 项目，继续开发，开发完成后，当项目要上线时，依然进入到 vuehr 目录，然后执行如下命令：

```
npm run build
```

该命令执行成功之后，vuehr 目录下生成一个 dist 文件夹，将该文件夹中的两个文件 static 和 index.html 拷贝到 Spring Boot 项目中 resources/static/ 目录下，然后就可以像第 6 步那样直接访问了（关于前后端分离部署，大家也可以参考这个[使用 Nginx 部署前后端分离项目，解决跨域问题](https://mp.weixin.qq.com/s/C7PIck3SIPPTcA3NX3ELoQ)）。


**步骤 7 中需要大家对 NodeJS、NPM 等有一定的使用经验，不熟悉的小伙伴可以先自行搜索学习下，推荐 [Vue 官方教程](https://cn.vuejs.org/v2/guide/)。**

## 文档

文档是对项目开发过程中遇到的一些问题的详细记录，主要是为了帮助没有基础的小伙伴快速理解这个项目。

1. [权限数据库设计](https://github.com/lenve/vhr/wiki/1.%E6%9D%83%E9%99%90%E6%95%B0%E6%8D%AE%E5%BA%93%E8%AE%BE%E8%AE%A1)
2. [服务端环境搭建](https://github.com/lenve/vhr/wiki/2.%E6%9C%8D%E5%8A%A1%E7%AB%AF%E7%8E%AF%E5%A2%83%E6%90%AD%E5%BB%BA)
3. [动态处理角色和资源的关系](https://github.com/lenve/vhr/wiki/3.%E5%8A%A8%E6%80%81%E5%A4%84%E7%90%86%E8%A7%92%E8%89%B2%E5%92%8C%E8%B5%84%E6%BA%90%E7%9A%84%E5%85%B3%E7%B3%BB)
4. [密码加密并加盐](https://github.com/lenve/vhr/wiki/4.%E5%AF%86%E7%A0%81%E5%8A%A0%E5%AF%86%E5%B9%B6%E5%8A%A0%E7%9B%90)
5. [服务端异常的统一处理](https://github.com/lenve/vhr/wiki/5.%E6%9C%8D%E5%8A%A1%E7%AB%AF%E5%BC%82%E5%B8%B8%E7%9A%84%E7%BB%9F%E4%B8%80%E5%A4%84%E7%90%86)
6. [axios 请求封装,请求异常统一处理](https://github.com/lenve/vhr/wiki/6.axios%E8%AF%B7%E6%B1%82%E5%B0%81%E8%A3%85,%E8%AF%B7%E6%B1%82%E5%BC%82%E5%B8%B8%E7%BB%9F%E4%B8%80%E5%A4%84%E7%90%86)
7. [将请求方法挂到Vue上](https://github.com/lenve/vhr/wiki/7.%E5%B0%86%E8%AF%B7%E6%B1%82%E6%96%B9%E6%B3%95%E6%8C%82%E5%88%B0Vue%E4%B8%8A)
8. [登录状态的保存](https://github.com/lenve/vhr/wiki/8.%E7%99%BB%E5%BD%95%E7%8A%B6%E6%80%81%E7%9A%84%E4%BF%9D%E5%AD%98)
9. [登录成功后动态加载组件](https://github.com/lenve/vhr/wiki/9.%E7%99%BB%E5%BD%95%E6%88%90%E5%8A%9F%E5%90%8E%E5%8A%A8%E6%80%81%E5%8A%A0%E8%BD%BD%E7%BB%84%E4%BB%B6)
10. [角色资源关系管理](https://github.com/lenve/vhr/wiki/10.%E8%A7%92%E8%89%B2%E8%B5%84%E6%BA%90%E5%85%B3%E7%B3%BB%E7%AE%A1%E7%90%86)
11. [用户角色关系管理](https://github.com/lenve/vhr/wiki/11.%E7%94%A8%E6%88%B7%E8%A7%92%E8%89%B2%E5%85%B3%E7%B3%BB%E7%AE%A1%E7%90%86)


### 更新记录

### 2018.1.10 更新

本次更新版本：v20180110

本次更新完成了部门管理功能，页面在 **[系统管理->基础信息设置->部门管理]**

>本次更新也更新了数据库脚本，小伙伴们需要重新下载数据库脚本执行。

### 主要变更内容
1. 后端 Docker 配置 ( vhr/vhr/Dockerfile )
   
   - 使用 OpenJDK 8 环境。
   - 通过 Maven 多模块构建，打包 vhr-web 模块。
   - 配置了文件上传目录的挂载点。
2. 前端 Docker 配置 ( vuehr/Dockerfile & vuehr/nginx.conf )
   
   - 使用 Node.js 构建 Vue 项目。
   - 使用 Nginx 托管构建后的静态文件。
   - Nginx 反向代理 : 配置了 /employee , /personnel , /system 等所有后端接口转发到 vhr-backend 容器，解决了跨域问题。
3. Docker Compose 编排 ( docker-compose.yml )
   
   - 服务清单 :
     - vhr-mysql : MySQL 5.7 (密码: root123, 数据库: vhr)。
     - vhr-redis : Redis (密码: pass1234)。
     - vhr-rabbitmq : RabbitMQ 消息队列。
     - vhr-backend : 后端服务，自动关联上述中间件，并重写了文件上传路径以适应容器环境。
     - vhr-frontend : 前端服务，对外暴露 80 端口。
   - 数据持久化 : MySQL 数据挂载到 Docker Volume，上传的文件（头像、合同、视频等）挂载到项目根目录下的 vhr_data 文件夹。
### 使用方法
1. 确保本地已安装 Docker 和 Docker Compose。
2. 在项目根目录下 ( d:\projects\vhr ) 打开终端。
3. 运行以下命令启动所有服务：
   ```
   docker-compose up -d --build
   ```
4. 启动完成后，访问浏览器：
   - 前端页面: http://localhost
   - 后端接口: http://localhost:8081
系统会自动处理数据库迁移（通过 Flyway），初次启动可能需要几分钟时间等待 MySQL 初始化完成。
    limitations under the License.
 
