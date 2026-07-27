-- =========================================================
-- سكيما منصة شراكة (Sharaka) - نفّذ هذا الملف كاملاً
-- في: Supabase Dashboard > SQL Editor > New query
-- =========================================================

-- تفعيل امتداد UUID
create extension if not exists "uuid-ossp";

-- ---------------------------------------------------------
-- جدول الملفات الشخصية (يمتد من auth.users)
-- ---------------------------------------------------------
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  email text not null,
  role text not null default 'investor' check (role in ('investor', 'project_owner', 'admin')),
  kyc_status text not null default 'not_submitted' check (kyc_status in ('not_submitted', 'pending', 'approved', 'rejected')),
  phone text,
  avatar_url text,
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

create policy "المستخدم يشوف بروفايله" on public.profiles
  for select using (auth.uid() = id);

create policy "المستخدم يعدل بروفايله" on public.profiles
  for update using (auth.uid() = id);

create policy "المستخدم ينشئ بروفايله عند التسجيل" on public.profiles
  for insert with check (auth.uid() = id);

-- ---------------------------------------------------------
-- جدول المشاريع
-- ---------------------------------------------------------
create table if not exists public.projects (
  id uuid primary key default uuid_generate_v4(),
  owner_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  description text not null,
  sector text not null,
  country text not null,
  funding_goal numeric not null check (funding_goal > 0),
  amount_raised numeric not null default 0,
  shares_offered_percentage numeric not null check (shares_offered_percentage > 0 and shares_offered_percentage <= 100),
  price_per_share_percent numeric not null default 0,
  status text not null default 'pending_review' check (status in ('pending_review', 'active', 'funded', 'rejected', 'closed')),
  image_urls text[] not null default '{}',
  document_urls text[] not null default '{}',
  deadline timestamptz,
  created_at timestamptz not null default now()
);

alter table public.projects enable row level security;

create policy "الكل يشوف المشاريع النشطة" on public.projects
  for select using (status = 'active' or owner_id = auth.uid());

create policy "صاحب المشروع يضيف مشروع" on public.projects
  for insert with check (owner_id = auth.uid());

create policy "صاحب المشروع يعدل مشروعه" on public.projects
  for update using (owner_id = auth.uid());

-- ---------------------------------------------------------
-- جدول الاستثمارات
-- ---------------------------------------------------------
create table if not exists public.investments (
  id uuid primary key default uuid_generate_v4(),
  investor_id uuid not null references public.profiles(id) on delete cascade,
  project_id uuid not null references public.projects(id) on delete cascade,
  amount numeric not null check (amount > 0),
  shares_percentage numeric not null,
  status text not null default 'pending_payment' check (status in ('pending_payment', 'completed', 'failed', 'refunded')),
  created_at timestamptz not null default now()
);

alter table public.investments enable row level security;

create policy "المستثمر يشوف استثماراته" on public.investments
  for select using (investor_id = auth.uid());

create policy "صاحب المشروع يشوف مستثمري مشروعه" on public.investments
  for select using (
    exists (select 1 from public.projects p where p.id = project_id and p.owner_id = auth.uid())
  );

create policy "المستثمر ينشئ استثمار" on public.investments
  for insert with check (investor_id = auth.uid());

-- ---------------------------------------------------------
-- جدول الإشعارات
-- ---------------------------------------------------------
create table if not exists public.notifications (
  id uuid primary key default uuid_generate_v4(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  type text not null default 'general',
  title text not null,
  body text not null,
  is_read boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.notifications enable row level security;

create policy "المستخدم يشوف إشعاراته فقط" on public.notifications
  for select using (user_id = auth.uid());

create policy "المستخدم يحدث حالة قراءة إشعاره" on public.notifications
  for update using (user_id = auth.uid());

-- ---------------------------------------------------------
-- تريغر: تحديث amount_raised تلقائياً عند اكتمال دفع استثمار
-- ---------------------------------------------------------
create or replace function public.update_project_amount_raised()
returns trigger as $$
begin
  if (new.status = 'completed' and (old.status is null or old.status <> 'completed')) then
    update public.projects
    set amount_raised = amount_raised + new.amount
    where id = new.project_id;
  end if;
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists trg_update_amount_raised on public.investments;
create trigger trg_update_amount_raised
  after insert or update on public.investments
  for each row execute function public.update_project_amount_raised();

-- ---------------------------------------------------------
-- Storage bucket لمستندات KYC (خاص، غير عام)
-- ---------------------------------------------------------
insert into storage.buckets (id, name, public)
values ('kyc-documents', 'kyc-documents', false)
on conflict (id) do nothing;

create policy "المستخدم يرفع مستنداته الخاصة فقط"
  on storage.objects for insert
  with check (bucket_id = 'kyc-documents' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "المستخدم يشوف مستنداته الخاصة فقط"
  on storage.objects for select
  using (bucket_id = 'kyc-documents' and (storage.foldername(name))[1] = auth.uid()::text);

-- ---------------------------------------------------------
-- Storage bucket لصور ومستندات المشاريع (عام للقراءة)
-- ---------------------------------------------------------
insert into storage.buckets (id, name, public)
values ('project-files', 'project-files', true)
on conflict (id) do nothing;

create policy "الكل يشوف ملفات المشاريع"
  on storage.objects for select
  using (bucket_id = 'project-files');

create policy "صاحب المشروع يرفع ملفات مشروعه"
  on storage.objects for insert
  with check (bucket_id = 'project-files' and auth.uid() is not null);
