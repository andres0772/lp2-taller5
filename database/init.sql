DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'blog') THEN
        CREATE DATABASE blog;
    END IF;
END$$;

\c blog;

-- Crear la tabla de usuarios
CREATE TABLE  IF NOT EXISTS usuarios (
    id SERIAL PRIMARY KEY,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

-- Crear la tabla de publicaciones
CREATE TABLE IF NOT EXISTS publicaciones (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    contenido TEXT NOT NULL,
    url_imagen VARCHAR(255),
    id_usuario INT REFERENCES usuarios(id) ON DELETE CASCADE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear la tabla de comentarios
CREATE TABLE IF NOT EXISTS comentarios (
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
('mario_king', 'Mario Rodríguez', 'mario_king@example.com', 'hashed_password5')
ON CONFLICT (usuario) DO NOTHING;

-- Insertar publicaciones de prueba
INSERT INTO publicaciones (titulo, contenido, url_imagen, id_usuario) VALUES
('Sistemas Operativos: Windows, iOS y Linux', 'Un sistema operativo (SO) es el software principal que gestiona los recursos de hardware y proporciona servicios a los programas informáticos. Existen diversos sistemas operativos, pero entre los más conocidos y utilizados se encuentran Windows, iOS y Linux. Cada uno tiene características particulares que lo hacen ideal para distintos tipos de usuarios y dispositivos.', NULL, 1),
('Windows', 'Desarrollado por Microsoft, Windows es uno de los sistemas operativos más populares a nivel mundial, especialmente en entornos de escritorio y portátiles. Su primera versión se lanzó en 1985 y, desde entonces, ha evolucionado con múltiples actualizaciones, siendo Windows 11 la versión más reciente (hasta abril de 2025). Es conocido por su interfaz gráfica amigable, compatibilidad con una amplia gama de software y facilidad de uso. Windows es ampliamente utilizado tanto en hogares como en empresas debido a su versatilidad y soporte para juegos, programas de oficina, y más.', NULL, 2),
('iOS', 'OS es el sistema operativo desarrollado por Apple Inc. para sus dispositivos móviles, como el iPhone, el iPad y el iPod Touch. Se lanzó por primera vez en 2007 junto con el primer iPhone. Es un sistema cerrado, lo que significa que Apple controla rigurosamente tanto el hardware como el software, garantizando una alta seguridad, rendimiento estable y una integración fluida entre dispositivos. iOS destaca por su diseño intuitivo, su tienda de aplicaciones (App Store) bien curada y su enfoque en la privacidad del usuario.', NULL, 3),
('Linux', 'Linux es un sistema operativo de código abierto, lo que significa que su código fuente está disponible para que cualquier persona lo use, modifique y distribuya. Fue creado en 1991 por Linus Torvalds y se basa en el sistema Unix. A diferencia de Windows e iOS, Linux se presenta en múltiples "distribuciones" (o distros), como Ubuntu, Fedora, Debian, entre muchas otras. Es muy apreciado por desarrolladores, administradores de sistemas y entusiastas de la informática debido a su flexibilidad, seguridad y eficiencia. Aunque es menos común en computadoras de escritorio, Linux es ampliamente utilizado en servidores, supercomputadoras y dispositivos integrados.', NULL, 4),
('Windows', 'Desarrollado por Microsoft, es el sistema operativo más utilizado en computadoras personales. Destaca por su interfaz amigable, compatibilidad con una gran cantidad de software y facilidad de uso. Es muy común en hogares, oficinas y escuelas. La última versión es Windows 11.', NULL, 5)
('iOS', 'Es el sistema operativo móvil de Apple, exclusivo para dispositivos como iPhone y iPad. Se caracteriza por su alto nivel de seguridad, su diseño elegante y su excelente integración con otros productos de Apple. Solo puede usarse en dispositivos fabricados por la misma compañía.', NULL, 3),
('Linux', 'Es un sistema operativo libre y de código abierto, usado principalmente por programadores, desarrolladores y empresas. Se presenta en múltiples versiones llamadas distribuciones (como Ubuntu, Debian o Fedora). Aunque no es tan común en usuarios promedio, es muy estable y seguro, especialmente útil en servidores y sistemas especializados.', NULL, 4),
('Windows – El sistema más popular', 'Windows es el sistema operativo más utilizado en el mundo. Su interfaz es familiar para la mayoría y es compatible con la mayoría de aplicaciones y juegos. Es ideal para oficinas, estudiantes y gamers. Sin embargo, sufre más ataques de virus y puede volverse lento con el tiempo si no se mantiene bien. Requiere licencia, pero viene preinstalado en muchas computadoras. Sus actualizaciones pueden ser molestas, pero trae mejoras constantes. Si buscas versatilidad y compatibilidad, Windows es una opción confiable para casi cualquier usuario, desde lo más básico hasta lo más avanzado.', NULL, 2),
('macOS – Elegancia y productividad', 'macOS es el sistema operativo de Apple. Su diseño elegante, estabilidad y seguridad lo hacen ideal para diseñadores, editores de video y usuarios creativos. Está optimizado para el hardware Apple, lo que garantiza una experiencia fluida y sin errores. Su principal desventaja es el precio: solo funciona en dispositivos Apple, que suelen ser costosos. También tiene menos variedad de software en comparación con Windows. Sin embargo, si trabajas en el ecosistema Apple, macOS es una experiencia de alta calidad, confiable y enfocada en la productividad. Una excelente elección para quienes valoran el diseño y el rendimiento.', NULL, 3),
('Linux – Potencia y libertad', 'Linux es un sistema operativo libre y de código abierto, ideal para programadores, desarrolladores y entusiastas de la tecnología. Existen muchas distribuciones, como Ubuntu, Debian o Fedora, adaptadas a distintos niveles de experiencia. Linux es ligero, estable y seguro, perfecto para revivir computadoras antiguas o usar en servidores. No necesita antivirus y es altamente personalizable. Sin embargo, tiene una curva de aprendizaje, y algunos programas populares no están disponibles. Si te interesa aprender más sobre cómo funciona tu sistema o quieres control total de tu equipo, Linux es una excelente opción.', NULL, 4),
('¿Cuál es el más seguro?', 'En términos de seguridad, Linux y macOS suelen ser más seguros que Windows. Linux, al ser de código abierto y usado por expertos, tiene menos vulnerabilidades explotadas. macOS está muy cerrado y controlado por Apple, lo que evita la mayoría de amenazas. Windows es más vulnerable porque es el sistema más usado, y por eso es el principal objetivo de virus y malware. Aun así, Windows ha mejorado su seguridad con Windows Defender. Si buscas máxima protección, Linux es ideal, seguido de macOS. Pero con buenos hábitos, todos pueden ser seguros para el uso diario.', NULL, 1),
('Rendimiento y consumo de recursos', 'Linux es el rey del rendimiento en equipos de bajos recursos. Corre muy bien incluso en computadoras antiguas. Windows, aunque compatible con casi todo, consume más RAM y CPU debido a sus procesos en segundo plano. macOS está muy optimizado para los dispositivos Apple, por lo que ofrece un buen rendimiento, pero no se puede instalar en cualquier equipo. Si tienes una PC nueva, Windows o Linux pueden ser buena opción. Si tienes un Mac, macOS será lo mejor. Para computadoras viejas o servidores, Linux gana en eficiencia y velocidad.', NULL, 1),
('¿Cuál elegir según tu perfil?', 'Si eres gamer o usuario general, Windows es tu mejor opción por compatibilidad. Si trabajas con diseño, edición o multimedia, macOS ofrece estabilidad y herramientas profesionales. Si eres programador, estudiante de informática o usuario curioso, Linux te dará libertad y control total. La elección depende de lo que haces con tu computadora. No hay un sistema mejor que otro en términos absolutos, todo depende de tus necesidades. ¿Quieres rendimiento, estabilidad o personalización? Con esa respuesta, sabrás cuál elegir: Windows, macOS o Linux.', NULL, 2),
('Facilidad de uso para principiantes', 'Cuando hablamos de facilidad de uso, Windows y macOS lideran. Windows es intuitivo y familiar para la mayoría, con menús accesibles y una gran comunidad de soporte. macOS tiene una interfaz pulida, fácil de navegar, ideal para quienes no quieren complicaciones. Por otro lado, Linux puede ser desafiante para principiantes, aunque distribuciones como Ubuntu o Linux Mint lo hacen más accesible. Aun así, algunos comandos y configuraciones pueden ser intimidantes al inicio. Si estás empezando con computadoras, Windows o macOS te ofrecerán una experiencia más sencilla. Linux es ideal si te interesa aprender y explorar.', NULL, 4),
('Actualizaciones y mantenimiento', 'Las actualizaciones son clave para mantener el sistema seguro y eficiente. Windows suele forzar actualizaciones automáticas, lo que puede ser molesto para muchos usuarios. macOS maneja las actualizaciones de forma más silenciosa y estable, con menos interrupciones. En Linux, el usuario decide cuándo y qué actualizar, lo cual da más control, pero requiere conocimiento. Además, Linux casi no necesita mantenimiento adicional. Windows, por su parte, puede requerir limpieza de disco, antivirus y optimizaciones. Si quieres olvidarte del mantenimiento, macOS o Linux son opciones tranquilas. Para quienes prefieren control total, Linux es el rey.', NULL, 4),

ON CONFLICT DO NOTHING;

-- Insertar comentarios de prueba
INSERT INTO comentarios (comentario, id_publicacion, id_usuario) VALUES
('¡Muy interesante!', 1, 2),
('Gracias por la información.', 2, 3),
('Prefiero Windows, pero buen análisis.', 3, 4),
('Voy a probar esto en mi proyecto.', 4, 1),
('Me encantó la guía para principiantes.', 5, 2)
ON CONFLICT DO NOTHING;


