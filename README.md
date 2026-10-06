# Villa Constitución — Asistencia

Aplicación web responsive para administrar miembros y asistencia de Villa Constitución.

## Estructura

- `index.html` — aplicación completa.
- `supabase-config.js` — Project URL y clave pública de Supabase.
- `supabase_schema.sql` — tablas, índices y políticas RLS.
- `netlify.toml` — configuración para Netlify.
- `.gitignore` — archivos locales que no deben subirse.

## Supabase

1. En Supabase abre **SQL Editor**.
2. Ejecuta todo `supabase_schema.sql`.
3. En **Authentication → Users** crea el usuario administrador.
4. Inicia sesión desde la página.

La aplicación usa Supabase Auth y RLS. La clave del frontend debe ser únicamente la **Publishable/anon key**. Nunca uses una `service_role` o `secret` key en el navegador.

## GitHub

Crea un repositorio vacío y sube **estos archivos directamente en la raíz** del repositorio. No necesitas una carpeta adicional alrededor de ellos.

## Netlify

En Netlify selecciona **Add new project → Import an existing project**, conecta GitHub y selecciona este repositorio.

- Build command: dejar vacío.
- Publish directory: `.`
- Netlify detectará `netlify.toml` automáticamente.

Cada nuevo push a la rama principal podrá generar un nuevo deploy.
