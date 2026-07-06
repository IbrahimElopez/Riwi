CREATE DATABASE IF NOT EXISTS gestion_academica_universidad;

USE gestion_academica_universidad;

CREATE TABLE IF NOT EXISTS estudiantes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    apellido VARCHAR(255) NOT NULL,
    correo_electronico VARCHAR(255) NOT NULL UNIQUE,
    genero VARCHAR(255) NOT NULL CHECK (genero IN ('Masculino', 'Femenino', 'Otro')),
    identificacion VARCHAR(255) NOT NULL UNIQUE CHECK (LENGTH(identificacion) = 10),
    carrera VARCHAR(255) NOT NULL,
    fecha_nacimiento DATE NOT NULL CHECK (fecha_nacimiento <= CURRENT_DATE),
    fecha_ingreso DATE NOT NULL CHECK (fecha_ingreso <= CURRENT_DATE)
);

CREATE TABLE IF NOT EXISTS docentes (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    apellido VARCHAR(255) NOT NULL,
    correo_institucional VARCHAR(255) NOT NULL UNIQUE,
    departamento_academico VARCHAR(255) NOT NULL,
    años_experiencia INT NOT NULL CHECK (años_experiencia >= 0)
);

CREATE TABLE IF NOT EXISTS cursos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    codigo VARCHAR(255) NOT NULL UNIQUE,
    creditos INT NOT NULL CHECK (creditos >= 0),
    semestre INT NOT NULL CHECK (semestre >= 1 AND semestre <= 10),
    docente_id INT NOT NULL,
    FOREIGN KEY (docente_id) REFERENCES docentes(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS inscripciones (
    id SERIAL PRIMARY KEY,
    estudiante_id INT NOT NULL,
    curso_id INT NOT NULL,
    fecha_inscripcion DATE NOT NULL CHECK (fecha_inscripcion <= CURRENT_DATE),
    nota_final DECIMAL(5, 2) CHECK (nota_final >= 0 AND nota_final <= 5.00),
    FOREIGN KEY (estudiante_id) REFERENCES estudiantes(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (curso_id) REFERENCES cursos(id) ON DELETE RESTRICT ON UPDATE CASCADE
);
