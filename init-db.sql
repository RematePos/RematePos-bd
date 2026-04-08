-- RematePos Database Initialization Script
-- Crear esquemas y roles necesarios

-- Nota: la creación de usuarios y contraseñas debe gestionarse fuera de git
-- (secret manager, pipeline o script local no versionado).
DO $$ BEGIN
	CREATE ROLE rematepos_user NOLOGIN;
EXCEPTION WHEN DUPLICATE_OBJECT THEN
	NULL;
END $$;

-- Crear esquema público (si es necesario)
CREATE SCHEMA IF NOT EXISTS public;

-- Permisos en el esquema
GRANT USAGE ON SCHEMA public TO rematepos_user;
GRANT CREATE ON SCHEMA public TO rematepos_user;

-- Establecer los permisos por defecto
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO rematepos_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT USAGE, SELECT ON SEQUENCES TO rematepos_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT EXECUTE ON FUNCTIONS TO rematepos_user;

-- Comentarios
COMMENT ON SCHEMA public IS 'RematePos public schema';

