CREATE DATABASE blog;
\c blog;

-- Crear la tabla de usuarios
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

-- Crear la tabla de publicaciones
CREATE TABLE publicaciones (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    contenido TEXT NOT NULL,
    url_imagen VARCHAR(255),
    id_usuario INT REFERENCES usuarios(id) ON DELETE CASCADE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear la tabla de comentarios
CREATE TABLE comentarios (
    id SERIAL PRIMARY KEY,
    comentario TEXT NOT NULL,
    id_publicacion INT REFERENCES publicaciones(id) ON DELETE CASCADE,
    id_usuario INT REFERENCES usuarios(id) ON DELETE CASCADE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP


);

-- Insertar usuarios de prueba
INSERT INTO usuarios (usuario, nombre, correo, password) VALUES
('andres77', 'Andrés Pérez', 'andres77@example.com', 'hashed_password1'),
('lina89', 'Lina Gómez', 'lina89@example.com', 'hashed_password2'),
('juan23', 'Juan Martínez', 'juan23@example.com', 'hashed_password3'),
('sofia99', 'Sofía López', 'sofia99@example.com', 'hashed_password4'),
('mario_king', 'Mario Rodríguez', 'mario_king@example.com', 'hashed_password5');

-- Insertar publicaciones de prueba
INSERT INTO publicaciones (titulo, contenido, url_imagen, id_usuario) VALUES
('Primer post', 'Este es el primer artículo del blog.', NULL, 1),
('Tecnología 2025', 'Las tendencias de tecnología en 2025 incluyen...', NULL, 2),
('¿Vale la pena Linux?', 'Comparación de Windows, Mac y Linux...', NULL, 3),
('Mi experiencia con Docker', 'Configurando contenedores en mi proyecto...', NULL, 4),
('Cómo aprender a programar', 'Consejos para principiantes en programación...', NULL, 5);

-- Insertar comentarios de prueba
INSERT INTO comentarios (comentario, id_publicacion, id_usuario) VALUES
('¡Muy interesante!', 1, 2),
('Gracias por la información.', 2, 3),
('Prefiero Windows, pero buen análisis.', 3, 4),
('Voy a probar esto en mi proyecto.', 4, 1),
('Me encantó la guía para principiantes.', 5, 2);
