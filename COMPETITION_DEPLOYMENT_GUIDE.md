# 遗传咨询智能训练系统：比赛在线版部署说明

## 文件

- `competition_genetic_counseling_frontend.html`：比赛前端页面。
- `competition_genetic_counseling_backend.js`：比赛后端服务。
- `competition_package.json`：比赛后端依赖配置，部署前可重命名为 `package.json`。
- `render.yaml`：Render 部署参考配置。

## 推荐部署方式

### 方式一：前后端一体部署

把以下文件放到同一个部署目录：

```text
competition_genetic_counseling_frontend.html
competition_genetic_counseling_backend.js
package.json
```

其中 `package.json` 使用 `competition_package.json` 的内容。

云平台环境变量：

```text
DEEPSEEK_API_KEY=你的密钥
CHAT_MODE=ai
DEEPSEEK_MODEL=deepseek-chat
```

启动命令：

```bash
npm install
npm start
```

部署成功后，评委访问服务根地址即可试用，例如：

```text
https://your-service.onrender.com/
```

这种前后端一体部署不需要手动填写接口地址，页面会自动使用当前域名调用后端 API。

### 方式二：前端静态部署 + 后端 API 部署

后端按方式一部署，但评委访问静态前端地址。前端可通过 URL 参数指定后端：

```text
https://your-frontend.example.com/competition_genetic_counseling_frontend.html?api=https://your-backend.example.com
```

也可以打开前端后，在“后端接口地址”中填写：

```text
https://your-backend.example.com/api/chat
```

## 稳定性设计

- 页面打开后会先预加载本地 9 个病例，保证评委扫码后立刻可见、可试用。
- 若在线 AI 后端连接成功，系统会自动切换到在线 AI/Mock 接口；若后端不可用，则继续使用前端本地演示模式。
- 默认优先使用 AI 模式，后端通过环境变量安全调用 DeepSeek。
- API Key 不放在前端，避免泄露。
- 后端失败或接口不可用时，前端会自动切换到本地病例库、本地患者回复、本地检查与本地评分。
- 报告类问题和伦理高风险问题带有规则兜底，降低比赛现场不稳定回复风险。

## 健康检查

```text
https://your-backend.example.com/api/health
```

返回 `ok: true` 且 `aiReady: true` 时，说明 AI 后端已就绪。
