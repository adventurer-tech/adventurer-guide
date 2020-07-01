# 服务 issue 产品开发发布流程

服务从 idea 到最后上线的流程

整体流程可以参考这个视频获得一个大概的了解:
https://work.weixin.qq.com/wework_admin/liveroom/v2/replay?ref=playend&roomid=6842825601326055651&version=3.0.24.6143&platform=mac

## 提出需求

由产品或者技术负责人提出需求，issue 例如:

```
## user story

实现 project crud 功能

- 可以根据 owner list
- 可以限制返回的数量 limit，和开始的位置 offset
- KanbanProjectOwner / Admin 可以修改、删除 project
- project 可以 reference 到外部资源
```

Issue Example: https://github.com/zzswang/kanban/issues/1

## 实现需求

开发领取任务后

### 1. 将需求细化成可开发步骤

用产品可以看懂的语言，将需求解析成可校验的步骤，回复在 issue 上，供讨论，这个也是 postman 上的测试用例，例如:

```
## 数据清单:

- USER_X: 一个集合内的特殊用户，id 唯一，用于测试最大创建数量
- USER: 公共用户

## 业务流程

- USER_X: 创建项目 A，此 USER 自动成为 PO
- USER_X: 根据 id 查询项目 A 的详情
- USER_X: 根据错误 id 查询项目报错
- USER_X: 成功修改项目 A
- USER_X: 创建项目 B
- USER_X: 创建项目 C
- USER: 根据 owner list 项目，offset=1, limit=1, 项目总数是 3，第二个创建的项目 B 在返回的数组中
- USER: 无法修改项目 A
- USER: 删除项目 A 报错
- USER_X: 删除项目 A
```

### 2. 定义接口

如果是新的接口，增加接口，如果是修改已有接口，则直接在原有接口的基础上修改

- 写 openapi.yml 定义接口和输入输出的数据结构
- yarn gen:postman 生成 postman.json
- yarn gen:api 生成 api 桩代码
- 可以利用 fastman 将 postman.json 导入到 postman 软件中

fastman 的使用参考文档 https://github.com/36node/sketch/blob/master/packages/fastman/README.md

### 3. 测试驱动开发

- 在 postman 上创建一个新的测试集合
- 根据 `1. 将需求细化成可开发步骤` 创建的步骤，在 postman 上写测试用例，可以参考 service template
- 从自动生成的 postman 集合中拷贝对应的用例，可以降低工作量
- 一边开发，一边推进测试用例，直到所有用例都 pass
- 在 test 目录下创建一个测试集合的目录
- 根据情况看是否需要修改 test/env.json 文件
- 将 postman 集合导出，放到上面创建的 test 测试集合的目录里
- yarn test:int 确保集成测试通过

### 4. 提交 pr

- 代码完成后创建 pr 提交
- 在 comment 中，描述所做的用例
- 描述解决的问题
- 描述部署需要考虑的环境变量

PR Example: https://github.com/zzswang/kanban/pull/3

## 验收需求

验收前需要 clone pr 的代码到本地，并启动服务；如果服务需要依赖数据库等，则通过下述命令，可以简单的将依赖启动

`docker-compose up`

docker-compose 相关教程 https://www.runoob.com/docker/docker-compose.html

- 技术验收：代码、数据结构
- 产品验收：数据的输入输出是否符合期望

### 产品验收流程

- issue: issue 上的讨论，以及查看 pr 上的用例表述，是否符合要求
- 准备代码：clone pr 代码到本地
- 准备第三方服务：docker-compose up
- build: yarn & yarn start
- 环境变量: postman 导入 test 的环境变量
- 导入测试集: fastman import "test/xxxx.json"
- 检视数据: 通过 postman 检查输入输出

### 技术验收流程

- 如有必要，也做一次产品验收流程
- 检查代码是否符合要求
- 检车架构设计是否优雅
- 有无逻辑硬伤等
