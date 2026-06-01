# Supabase 匿名研究日志配置说明

本功能用于把线上 Render 版的训练过程自动写入 Supabase，适合课后训练和教学论文数据收集。

## 1. 创建 Supabase 项目

进入 Supabase，新建项目。项目创建完成后，进入：

- Project Settings -> API
- 复制 `Project URL`
- 复制 `service_role` key

注意：`service_role` key 只能放在后端环境变量中，不能写入前端网页。

## 2. 建表

打开 Supabase 的 SQL Editor，执行本目录中的：

```text
SUPABASE_RESEARCH_LOG_SETUP.sql
```

默认表名为：

```text
public.research_events
```

## 3. Render 环境变量

在 Render Web Service 的 Environment 中增加：

```text
SUPABASE_URL=你的 Supabase Project URL
SUPABASE_SERVICE_ROLE_KEY=你的 service_role key
SUPABASE_RESEARCH_TABLE=research_events
RESEARCH_LOGGING=true
```

已有的 DeepSeek 变量继续保留：

```text
DEEPSEEK_API_KEY=你的 DeepSeek Key
CHAT_MODE=ai
DEEPSEEK_MODEL=deepseek-chat
```

## 4. 部署后测试

打开：

```text
https://你的-render域名/api/research/status
```

如果配置成功，应看到：

```json
{
  "ok": true,
  "enabled": true,
  "storage": "jsonl+supabase",
  "supabaseConfigured": true,
  "supabaseTable": "research_events"
}
```

然后打开网页完成一次问诊，Supabase 表中应出现多条事件记录。

## 5. 数据说明

主要事件类型：

- `session_start`：开始问诊
- `student_message`：学生发言
- `patient_reply`：患者回复
- `material_view`：查看既往报告或外院材料
- `test_run`：选择并完成检查
- `final_score`：结束问诊与五维评分

其中 `final_score` 适合做会话级分析，`student_message`、`test_run` 适合做过程分析。

## 6. 重要提醒

- 只让学生填写匿名编号，例如 `G01`、`S01`，不要填写姓名、学号、手机号。
- Render 本地 JSONL 仍会保留作为备份，但不应作为线上长期数据源。
- Supabase 后台可以直接导出 CSV，也可以后续用 SQL 汇总。
