-- VILLA CONSTITUCIÓN · ESTRUCTURA SUPABASE
-- Ejecuta TODO este archivo en Supabase > SQL Editor.
-- La página usa Supabase Auth + RLS; no necesita service_role/secret en el navegador.

create extension if not exists pgcrypto;

create table if not exists public.miembros (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  grupo text not null default 'Miembro',
  servicio text not null default 'Servicio general',
  activo boolean not null default true,
  created_at timestamptz not null default now(),
  constraint miembros_nombre_no_vacio check (btrim(nombre) <> '')
);

-- Evita duplicar a la misma persona por diferencias de mayúsculas/minúsculas.
create unique index if not exists miembros_nombre_unico_ci
  on public.miembros (lower(btrim(nombre)));

create table if not exists public.asistencias (
  id uuid primary key default gen_random_uuid(),
  miembro_id uuid not null references public.miembros(id) on delete cascade,
  fecha date not null default current_date,
  estado text not null check (estado in ('Presente','Ausente','Justificado')),
  motivo text,
  hora timestamptz not null default now(),
  created_at timestamptz not null default now(),
  unique (miembro_id, fecha),
  constraint asistencia_motivo_justificado check (
    estado <> 'Justificado' or btrim(coalesce(motivo, '')) <> ''
  )
);

create index if not exists idx_asistencias_fecha on public.asistencias(fecha);
create index if not exists idx_asistencias_miembro on public.asistencias(miembro_id);

-- RLS: nadie puede consultar/modificar estas tablas sin iniciar sesión.
alter table public.miembros enable row level security;
alter table public.asistencias enable row level security;

drop policy if exists "miembros_auth_all" on public.miembros;
drop policy if exists "asistencias_auth_all" on public.asistencias;
drop policy if exists "miembros_authenticated_all" on public.miembros;
drop policy if exists "asistencias_authenticated_all" on public.asistencias;

create policy "miembros_authenticated_all"
  on public.miembros for all to authenticated
  using (true) with check (true);

create policy "asistencias_authenticated_all"
  on public.asistencias for all to authenticated
  using (true) with check (true);

-- Nota: la clave publishable/anon puede estar en el frontend.
-- NUNCA coloques aquí ni en index.html una service_role o secret key.
