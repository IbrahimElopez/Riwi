-- Permisos para el rol revisor_academico.
-- Este rol queda pensado para consultar informacion academica sin modificar datos.

-- PostgreSQL no tiene CREATE ROLE IF NOT EXISTS, por eso se usa un bloque DO.
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_roles
        WHERE rolname = 'revisor_academico'
    ) THEN
        CREATE ROLE revisor_academico;
    END IF;
END $$;

-- Permite que el rol acceda a objetos dentro del esquema public.
GRANT USAGE ON SCHEMA public TO revisor_academico;

-- Otorga permiso de solo lectura sobre la vista del historial academico.
-- GRANT SELECT permite consultar la vista con SELECT, pero no modificar datos.
GRANT SELECT ON vista_historial_academico TO revisor_academico;

-- Revoca permisos de modificacion de datos sobre la tabla inscripciones.
-- INSERT agrega filas, UPDATE modifica filas, DELETE elimina filas y TRUNCATE vacia la tabla.
REVOKE INSERT, UPDATE, DELETE, TRUNCATE
ON TABLE inscripciones
FROM revisor_academico;
