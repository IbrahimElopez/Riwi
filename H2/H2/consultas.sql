-- Consultas de practica para la base de datos gestion_academica_universidad.

-- 1. Listar todos los estudiantes con sus inscripciones y cursos.
-- LEFT JOIN mantiene en el resultado a los estudiantes aunque no tengan cursos inscritos.
SELECT
    e.id AS estudiante_id,
    e.nombre || ' ' || e.apellido AS estudiante,
    i.id AS inscripcion_id,
    c.nombre AS curso,
    c.codigo AS codigo_curso,
    c.semestre,
    i.fecha_inscripcion,
    i.nota_final
FROM estudiantes e
LEFT JOIN inscripciones i ON i.estudiante_id = e.id
LEFT JOIN cursos c ON c.id = i.curso_id
ORDER BY e.id, c.semestre, c.nombre;

-- 2. Listar cursos dictados por docentes con mas de 5 años de experiencia.
-- INNER JOIN une cursos con docentes y WHERE filtra solo los docentes que cumplen la condicion.
SELECT
    c.id AS curso_id,
    c.nombre AS curso,
    c.codigo,
    c.creditos,
    c.semestre,
    d.nombre || ' ' || d.apellido AS docente,
    d.años_experiencia
FROM cursos c
INNER JOIN docentes d ON d.id = c.docente_id
WHERE d.años_experiencia > 5
ORDER BY d.años_experiencia DESC, c.nombre;

-- 3. Obtener promedio de calificaciones por curso.
-- GROUP BY agrupa las inscripciones por curso y AVG calcula el promedio de nota_final.
SELECT
    c.id AS curso_id,
    c.nombre AS curso,
    c.codigo,
    COUNT(i.id) AS total_inscripciones,
    ROUND(AVG(i.nota_final), 2) AS promedio_calificacion
FROM cursos c
INNER JOIN inscripciones i ON i.curso_id = c.id
GROUP BY c.id, c.nombre, c.codigo
ORDER BY promedio_calificacion DESC;

-- 4. Mostrar estudiantes inscritos en mas de un curso.
-- HAVING filtra despues de agrupar; WHERE filtra antes de agrupar.
SELECT
    e.id AS estudiante_id,
    e.nombre || ' ' || e.apellido AS estudiante,
    COUNT(i.id) AS cursos_inscritos
FROM estudiantes e
INNER JOIN inscripciones i ON i.estudiante_id = e.id
GROUP BY e.id, e.nombre, e.apellido
HAVING COUNT(i.id) > 1
ORDER BY cursos_inscritos DESC, estudiante;

-- 5. ALTER TABLE: agregar columna estado_academico a estudiantes.
-- IF NOT EXISTS evita error si la columna ya fue creada en una ejecucion anterior.
ALTER TABLE estudiantes
ADD COLUMN IF NOT EXISTS estado_academico VARCHAR(30) DEFAULT 'Activo'
CHECK (estado_academico IN ('Activo', 'Inactivo', 'Graduado', 'Suspendido'));

-- Verificacion rapida de la nueva columna agregada.
SELECT
    id,
    nombre || ' ' || apellido AS estudiante,
    estado_academico
FROM estudiantes
ORDER BY id;

-- 6. Eliminar un docente y observar el efecto en cursos.
-- La FK cursos.docente_id tiene ON DELETE RESTRICT, por eso un docente con cursos asociados no se puede eliminar.
SELECT
    d.id AS docente_id,
    d.nombre || ' ' || d.apellido AS docente,
    COUNT(c.id) AS cursos_asociados
FROM docentes d
LEFT JOIN cursos c ON c.docente_id = d.id
GROUP BY d.id, d.nombre, d.apellido
ORDER BY d.id;

-- Prueba segura en PostgreSQL: intenta eliminar el docente 1, captura el error de FK y no detiene el script.
DO $$
DECLARE
    filas_eliminadas INT;
BEGIN
    BEGIN
        DELETE FROM docentes
        WHERE id = 1;

        GET DIAGNOSTICS filas_eliminadas = ROW_COUNT;
        RAISE EXCEPTION 'rollback_demo';
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'ON DELETE RESTRICT evita eliminar el docente porque tiene cursos asociados.';
        WHEN raise_exception THEN
            RAISE NOTICE 'Prueba revertida. Filas que se habrian eliminado: %', filas_eliminadas;
    END;
END $$;

-- 7. Consultar cursos con mas de 2 estudiantes inscritos.
-- COUNT cuenta inscripciones por curso y HAVING deja solo los cursos con mas de 2 estudiantes.
SELECT
    c.id AS curso_id,
    c.nombre AS curso,
    c.codigo,
    COUNT(i.estudiante_id) AS total_estudiantes_inscritos
FROM cursos c
INNER JOIN inscripciones i ON i.curso_id = c.id
GROUP BY c.id, c.nombre, c.codigo
HAVING COUNT(i.estudiante_id) > 2
ORDER BY total_estudiantes_inscritos DESC, curso;

-- 8. Estudiantes cuya calificacion promedio sea mayor al promedio general.
-- La subconsulta calcula el promedio general y el HAVING compara cada promedio individual contra ese valor.
SELECT
    e.id AS estudiante_id,
    e.nombre || ' ' || e.apellido AS estudiante,
    ROUND(AVG(i.nota_final), 2) AS promedio_estudiante
FROM estudiantes e
INNER JOIN inscripciones i ON i.estudiante_id = e.id
GROUP BY e.id, e.nombre, e.apellido
HAVING AVG(i.nota_final) > (
    SELECT AVG(nota_final)
    FROM inscripciones
    WHERE nota_final IS NOT NULL
)
ORDER BY promedio_estudiante DESC;

-- 9. Nombres de carreras con estudiantes inscritos en cursos del semestre >= 2.
-- EXISTS devuelve verdadero cuando encuentra al menos una inscripcion que cumple la condicion.
SELECT DISTINCT
    e.carrera
FROM estudiantes e
WHERE EXISTS (
    SELECT 1
    FROM inscripciones i
    INNER JOIN cursos c ON c.id = i.curso_id
    WHERE i.estudiante_id = e.id
      AND c.semestre >= 2
)
ORDER BY e.carrera;

-- 10. Usar ROUND, SUM, MAX, MIN y COUNT para obtener indicadores generales.
-- Las subconsultas evitan mezclar tablas y duplicar conteos por accidente.
SELECT
    (SELECT COUNT(*) FROM estudiantes) AS total_estudiantes,
    (SELECT COUNT(*) FROM docentes) AS total_docentes,
    (SELECT COUNT(*) FROM cursos) AS total_cursos,
    (SELECT COUNT(*) FROM inscripciones) AS total_inscripciones,
    (SELECT SUM(creditos) FROM cursos) AS total_creditos_ofertados,
    (SELECT ROUND(AVG(nota_final), 2) FROM inscripciones WHERE nota_final IS NOT NULL) AS promedio_general,
    (SELECT MAX(nota_final) FROM inscripciones) AS nota_maxima,
    (SELECT MIN(nota_final) FROM inscripciones) AS nota_minima;

-- 11. Simular actualizacion de calificaciones usando transacciones.
-- BEGIN inicia una transaccion: los cambios no quedan definitivos hasta ejecutar COMMIT.
BEGIN;

-- Esta actualizacion queda dentro de la transaccion y se conservara al hacer COMMIT.
UPDATE inscripciones
SET nota_final = 4.75
WHERE id = 1;

-- SAVEPOINT crea un punto de retorno dentro de la misma transaccion.
SAVEPOINT antes_de_segunda_actualizacion;

-- Esta segunda actualizacion sera revertida con ROLLBACK TO SAVEPOINT.
UPDATE inscripciones
SET nota_final = 2.50
WHERE id = 2;

-- Consulta de verificacion temporal: en este punto ambas actualizaciones se ven dentro de la transaccion.
SELECT
    id,
    estudiante_id,
    curso_id,
    nota_final
FROM inscripciones
WHERE id IN (1, 2)
ORDER BY id;

-- ROLLBACK TO SAVEPOINT deshace solo los cambios realizados despues del savepoint.
ROLLBACK TO SAVEPOINT antes_de_segunda_actualizacion;

-- COMMIT confirma los cambios restantes: se guarda la nota de id = 1 y se descarta la de id = 2.
COMMIT;

-- Verificacion final despues del COMMIT.
SELECT
    id,
    estudiante_id,
    curso_id,
    nota_final
FROM inscripciones
WHERE id IN (1, 2)
ORDER BY id;

-- 12. Crear vista del historial academico.
-- Una vista guarda una consulta con nombre; luego se puede consultar como si fuera una tabla.
CREATE OR REPLACE VIEW vista_historial_academico AS
SELECT
    e.nombre || ' ' || e.apellido AS estudiante,
    c.nombre AS curso,
    d.nombre || ' ' || d.apellido AS docente,
    c.semestre,
    i.nota_final AS calificacion_final
FROM inscripciones i
INNER JOIN estudiantes e ON e.id = i.estudiante_id
INNER JOIN cursos c ON c.id = i.curso_id
INNER JOIN docentes d ON d.id = c.docente_id;

-- Consulta de ejemplo sobre la vista creada.
SELECT *
FROM vista_historial_academico
ORDER BY estudiante, semestre, curso;
