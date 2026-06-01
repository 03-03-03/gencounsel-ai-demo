-- GenCounsel-AI 匿名研究日志表
-- 在 Supabase 控制台 SQL Editor 中执行。
-- 本表仅存匿名小组编号和训练过程事件，不建议记录姓名、学号、手机号等直接身份信息。

create table if not exists public.research_events (
  id bigserial primary key,
  created_at timestamptz not null default now(),
  timestamp timestamptz,
  session_id text not null,
  group_name text,
  case_id text,
  case_title text,
  event_type text not null,
  client_mode text,
  payload jsonb not null default '{}'::jsonb
);

create index if not exists idx_research_events_session_id
  on public.research_events (session_id);

create index if not exists idx_research_events_case_id
  on public.research_events (case_id);

create index if not exists idx_research_events_event_type
  on public.research_events (event_type);

create index if not exists idx_research_events_created_at
  on public.research_events (created_at);

-- 如果后端使用 service_role key 写入，RLS 可保持开启或关闭；
-- service_role 会绕过 RLS。不要把 service_role key 放到前端。
alter table public.research_events enable row level security;
