INSERT INTO docentes (id, nombre, apellido, correo_institucional, departamento_academico, años_experiencia) VALUES
(1, 'Carlos', 'Ramirez', 'carlos.ramirez@universidad.edu', 'Ingenieria de Sistemas', 12),
(2, 'Mariana', 'Lopez', 'mariana.lopez@universidad.edu', 'Ciencias Basicas', 8),
(3, 'Andres', 'Torres', 'andres.torres@universidad.edu', 'Administracion', 10),
(4, 'Sofia', 'Mendoza', 'sofia.mendoza@universidad.edu', 'Humanidades', 6),
(5, 'Javier', 'Castro', 'javier.castro@universidad.edu', 'Ingenieria Electronica', 15);

INSERT INTO estudiantes (id, nombre, apellido, correo_electronico, genero, identificacion, carrera, fecha_nacimiento, fecha_ingreso) VALUES
(1, 'Laura', 'Gomez', 'laura.gomez@correo.edu', 'Femenino', '1000000001', 'Ingenieria de Sistemas', '2002-04-15', '2021-02-01'),
(2, 'Miguel', 'Herrera', 'miguel.herrera@correo.edu', 'Masculino', '1000000002', 'Ingenieria Electronica', '2001-09-22', '2020-08-03'),
(3, 'Valentina', 'Ruiz', 'valentina.ruiz@correo.edu', 'Femenino', '1000000003', 'Administracion de Empresas', '2003-01-10', '2022-02-07'),
(4, 'Juan', 'Perez', 'juan.perez@correo.edu', 'Masculino', '1000000004', 'Ingenieria de Sistemas', '2000-11-30', '2019-08-05'),
(5, 'Camila', 'Ortega', 'camila.ortega@correo.edu', 'Femenino', '1000000005', 'Contaduria Publica', '2002-07-18', '2021-08-02'),
(6, 'Daniel', 'Moreno', 'daniel.moreno@correo.edu', 'Masculino', '1000000006', 'Matematicas', '2001-05-25', '2020-02-03'),
(7, 'Paula', 'Santos', 'paula.santos@correo.edu', 'Femenino', '1000000007', 'Psicologia', '2003-12-05', '2022-08-01'),
(8, 'Esteban', 'Vargas', 'esteban.vargas@correo.edu', 'Masculino', '1000000008', 'Ingenieria Industrial', '2000-03-14', '2019-02-04'),
(9, 'Natalia', 'Rojas', 'natalia.rojas@correo.edu', 'Femenino', '1000000009', 'Ingenieria de Sistemas', '2004-06-09', '2023-02-06'),
(10, 'Samuel', 'Diaz', 'samuel.diaz@correo.edu', 'Otro', '1000000010', 'Diseno Digital', '2002-10-28', '2021-02-01');

INSERT INTO cursos (id, nombre, codigo, creditos, semestre, docente_id) VALUES
(1, 'Programacion I', 'SIS101', 3, 1, 1),
(2, 'Bases de Datos', 'SIS204', 4, 4, 1),
(3, 'Calculo Diferencial', 'MAT101', 3, 1, 2),
(4, 'Estadistica Aplicada', 'MAT205', 3, 3, 2),
(5, 'Gestion Empresarial', 'ADM201', 3, 4, 3),
(6, 'Etica Profesional', 'HUM110', 2, 2, 4),
(7, 'Circuitos Electricos', 'ELE202', 4, 3, 5),
(8, 'Arquitectura de Computadores', 'SIS305', 4, 5, 5);

INSERT INTO inscripciones (id, estudiante_id, curso_id, fecha_inscripcion, nota_final) VALUES
(1, 1, 1, '2024-02-01', 4.50),
(2, 1, 2, '2024-08-01', 4.20),
(3, 2, 7, '2024-02-01', 3.80),
(4, 2, 8, '2024-08-01', 4.00),
(5, 3, 5, '2024-02-01', 4.60),
(6, 3, 6, '2024-02-01', 4.10),
(7, 4, 1, '2024-02-01', 3.70),
(8, 4, 2, '2024-08-01', 4.30),
(9, 5, 4, '2024-02-01', 3.90),
(10, 5, 5, '2024-08-01', 4.00),
(11, 6, 3, '2024-02-01', 4.80),
(12, 6, 4, '2024-08-01', 4.40),
(13, 7, 6, '2024-02-01', 4.70),
(14, 8, 3, '2024-02-01', 3.50),
(15, 9, 1, '2025-02-03', 4.25),
(16, 10, 6, '2025-02-03', 4.55);
