DROP TABLE IF EXISTS comentarios;
DROP TABLE IF EXISTS publicaciones;
DROP TABLE IF EXISTS usuarios;

--creacion de la tabla en esta parte
CREATE TABLE usuarios (
    id serial PRIMARY KEY,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255)NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

CREATE TABLE publicaciones (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    contenido TEXT NOT NULL,
    url_imagen VARCHAR(255),
    id_usuario INTEGER NOT NULL REFERENCES usuarios(id),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--creacion de la tabla de publicaciones
CREATE TABLE comentarios (
    id serial PRIMARY key, 
    comentario TEXT NOT NULL,
    id_publicacion TINTEGER NOT NULL REFERENCES publicaciones(id),
    id_usuarios INTEGER NOT NULL REFERENCES usuarios(id),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
   
);

INSERT INTO publicaciones (titulo, contenido, id_usuario) VALUES
INSERT INTO publicaciones (titulo, contenido, id_usuario) VALUES
('Windows 11: ¿La Mejor Versión Hasta Ahora? Un Análisis Detallado', 'Desde su lanzamiento, Windows 11 ha generado una gran cantidad de debate entre los usuarios de PC. Prometiendo una interfaz renovada, mejoras en el rendimiento y nuevas funcionalidades, la pregunta que muchos se hacen es si realmente se trata de la mejor versión de Windows hasta la fecha.\n\nUna de las características más notables de Windows 11 es su **interfaz de usuario rediseñada**. El menú de inicio centrado y la apariencia más moderna, con esquinas redondeadas y una estética más limpia, buscan ofrecer una experiencia más intuitiva y agradable. Sin embargo, este cambio también ha generado críticas por parte de usuarios acostumbrados al diseño tradicional de Windows.\n\nEn cuanto al **rendimiento**, Windows 11 introduce optimizaciones en la gestión de recursos y la eficiencia energética. Para los gamers, la integración de tecnologías como DirectStorage promete tiempos de carga más rápidos en juegos compatibles. Sin embargo, la mejora real en el rendimiento puede variar dependiendo del hardware de cada equipo.\n\nWindows 11 también se enfoca en la **productividad**, con funciones como los grupos de escritorio mejorados y un sistema de acoplamiento y desacoplamiento de ventanas más flexible. La integración con Microsoft Teams busca facilitar la comunicación y la colaboración.\n\nA pesar de sus novedades, Windows 11 también ha enfrentado **desafíos y controversias**. Los requisitos de hardware más estrictos han dejado fuera a algunos equipos más antiguos, y ciertas decisiones de diseño han sido objeto de críticas por parte de la comunidad.\n\nEn conclusión, Windows 11 ofrece una experiencia fresca y moderna con algunas mejoras significativas en rendimiento y productividad. Sin embargo, la decisión de si es la "mejor" versión dependerá de las necesidades y preferencias de cada usuario, así como de la compatibilidad con su hardware actual.', 1),
('Windows vs. Mac vs. Linux: ¿Cuál es el mejor sistema operativo para ti?', 'Elegir un sistema operativo no es tarea fácil, especialmente cuando hay tres gigantes dominando el mercado: Windows, macOS y Linux. Cada uno tiene características únicas que los hacen ideales para distintos tipos de usuarios. Mientras que Windows es el más utilizado en el mundo, macOS es la elección favorita de los creativos, y Linux es el preferido por programadores y entusiastas de la tecnología. Pero, ¿cuál es el mejor para ti? Vamos a compararlos en diferentes aspectos clave.', 2),
('Rendimiento y estabilidad', 'Windows, con su interfaz amigable y compatibilidad con una gran cantidad de hardware, es un sistema flexible, pero a veces sufre problemas de rendimiento con el tiempo debido a la acumulación de archivos y procesos en segundo plano.
macOS, en cambio, está optimizado para los dispositivos de Apple, lo que le permite ofrecer un rendimiento más estable y fluido en el tiempo, aunque con menos opciones de personalización.
Linux destaca por su estabilidad y eficiencia, consumiendo menos recursos que Windows y macOS. Muchas distribuciones pueden funcionar en equipos antiguos sin problemas, lo que lo convierte en una opción ideal para quienes buscan rendimiento sin sacrificar estabilidad.', 2),
('Gaming en Linux: ¿Ha Llegado el Momento de Abandonar Windows?', 'Analizamos el estado actual de los videojuegos en Linux, la compatibilidad con hardware y las opciones disponibles para gamers.', 1),
('Productividad en macOS: Herramientas y Flujos de Trabajo para Aumentar tu Eficiencia', 'Consejos y aplicaciones para aprovechar al máximo tu Mac en tareas de productividad, organización y colaboración.', 2),
('Personalización Extrema en Linux: Cómo Adaptar tu Sistema Operativo a tu Gusto', 'Sumérgete en el mundo de la personalización de Linux, desde los entornos de escritorio hasta los temas y las configuraciones avanzadas.', 3),
('Seguridad Comparada: Windows, macOS y Linux bajo la Lupa de las Amenazas Cibernéticas', 'Evaluamos las fortalezas y debilidades de cada sistema operativo en términos de seguridad y cómo protegerte.', 1),
('Migrar de Windows a macOS: Una Guía Completa con Consejos y Consideraciones', 'Si estás pensando en cambiar de Windows a Mac, esta guía te ayudará a prepararte y realizar la transición sin problemas.', 2),
('Las Distribuciones Linux Más Populares para Desarrollo de Software en 2024', 'Un repaso a las distros de Linux preferidas por los programadores, sus herramientas y sus ventajas para el desarrollo.', 3),
('Mantenimiento Básico de tu PC con Windows: Consejos para un Rendimiento Óptimo', 'Aprende a mantener tu sistema Windows funcionando de manera fluida con tareas sencillas de limpieza y optimización.', 1),
('El Ecosistema de Apple: ¿Realmente Vale la Pena la Inversión en Varios Dispositivos?', 'Analizamos los beneficios y las limitaciones de la integración entre iPhones, iPads y Macs.', 2),
('Resolviendo los Problemas Más Comunes en Linux: Una Guía Práctica para Usuarios Novatos', 'Encuentra soluciones a los errores y desafíos más frecuentes que enfrentan los nuevos usuarios de Linux.', 3),
('La Terminal de Linux para Principiantes: Comandos Esenciales que Debes Conocer', 'Una introducción práctica a la línea de comandos de Linux, con los comandos fundamentales para navegar y gestionar tu sistema.', 3),
('Alternativas Open Source a Software Popular en Windows y macOS', 'Descubre excelentes opciones de software libre y de código abierto que puedes usar en lugar de aplicaciones comerciales.', 1),
('El Futuro de los Sistemas Operativos: Tendencias y Posibles Cambios en Windows, macOS y Linux', 'Una mirada especulativa a cómo podrían evolucionar los sistemas operativos en los próximos años.', 2);

-- Insertar comentarios de prueba
INSERT INTO comentarios (comentario, id_publicacion, id_usuario) VALUES
('Buen punto de vista sobre Windows!', 1, 2),
('Como usuario de macOS, estoy de acuerdo con este análisis.', 3, 1),
('Gracias por la guía de Linux para principiantes!', 2, 3),
('Interesante artículo sobre gaming en Windows.', 4, 1),
('Linux es genial para desarrollo.', 5, 3),
('La seguridad es clave, gracias por la comparación.', 6, 2);