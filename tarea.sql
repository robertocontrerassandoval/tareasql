-- creacion base de datos
CREATE DATABASE 'desafio3_Roberto_Contreras_Sandoval_123';

-- cración de tablas usuarios
CREATE TABLE usuarios(id serial  primary key , email varchar(50), nombre varchar(50), apellido varchar(50), rol varchar);

-- ingreso de datos a tabla usuarios
INSERT INTO usuarios (email, nombre, apellido, rol) VALUES
('claudio@algo.com ', 'Claudio','Ferrada', 'administrador'),
('josue@algo.com ', 'Josue','Contreras', 'usuario'),
('antonia@algo.com ', 'Antonia','Contreras', 'usuario'),
('vero@algo.com ', 'Veronica','Sobarzo', 'usuario'),
('juan@algo.com ', 'Juan','Sobarzo', 'usuario');

-- cración de tablas Post
CREATE TABLE post (id serial  primary key, titulo varchar , contenido  text, fecha_creacion timestamp, fecha_actualizacion timestamp, destacado boolean, usuario_id bigint);

-- ingreso de datos a tabla post
INSERT INTO post (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES
('prueba1', 'contenido_prueba1','2023-05-10', '2023-05-11','true', 1),
('prueba2', 'contenido_prueba2','2023-05-12', '2023-05-13','false', 1),
('trabajo1', 'contenido_trabajo1','2023-05-14', '2023-05-15','true', 2),
('trabajo2', 'contenido_trabajo2','2023-05-16', '2023-05-17','true', 3),
('ejercicio1', 'contenido_ejercicio1','2023-05-18', '2023-05-19','true',null);

-- cración de tablas 
CREATE TABLE comentarios (id serial  primary key, contenido text, fecha_creacion timestamp, usuario_id bigint, post_id bigint);

-- ingreso de datos a tabla comentarios
INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES
('comentario1','2023-05-10', 1 , 1),
('comentario2','2023-05-11', 2 , 1),
('comentario3','2023-05-12', 3 , 1),
('comentario4','2023-05-13', 1 , 2),
('comentario5','2023-05-14', 2 , 2);


-- 2. Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas: nombre y email del usuario junto al título y contenido del post.
SELECT usuarios.nombre, usuarios.email, post.titulo, post.contenido
FROM usuarios 
JOIN post   ON usuarios.id = post.usuario_id;

-- 3. Muestra el id, título y contenido de los posts de los administradores.
-- a. El administrador puede ser cualquier id.
SELECT post.id, post.titulo, post.contenido
FROM post 
JOIN usuarios  ON post.usuario_id = usuarios.id
WHERE usuarios.rol = 'administrador';

-- 4. Cuenta la cantidad de posts de cada usuario.
-- a. La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario.
SELECT usuarios.id, usuarios.email, COUNT(post.id) AS cantidad_posts
FROM usuarios 
LEFT JOIN post  ON usuarios.id = post.usuario_id
GROUP BY usuarios.id, usuarios.email;

-- 5. Muestra el email del usuario que ha creado más posts.
-- a. Aquí la tabla resultante tiene un único registro y muestra solo el email.
SELECT usuarios.email
FROM usuarios 
JOIN (
    SELECT usuario_id, COUNT(*) AS cantidad_posts
    FROM post
    GROUP BY usuario_id
    ORDER BY cantidad_posts DESC
	LIMIT 1
) AS mas_posts ON usuarios.id = mas_posts.usuario_id;

-- 6. Muestra la fecha del último post de cada usuario.

SELECT usuarios.nombre, mas_posts.fecha_ultimo_post
FROM usuarios 
LEFT JOIN (
    SELECT usuario_id, MAX(fecha_creacion) AS fecha_ultimo_post
    FROM post
    GROUP BY usuario_id
) AS mas_posts ON usuarios.id = mas_posts.usuario_id;

-- 7. Muestra el título y contenido del post (artículo) con más comentarios.

SELECT post.titulo, post.contenido
FROM post 
JOIN (
    SELECT post_id, COUNT(*) AS cantidad_comentarios
    FROM comentarios
    GROUP BY post_id
    ORDER BY cantidad_comentarios DESC
    LIMIT 1
) AS mas_comentarios ON post.id = mas_comentarios.post_id;

-- 8. Muestra en una tabla el título de cada post, el contenido de cada post 
-- y el contenido de cada comentario asociado a los posts mostrados, junto con el email del usuario que lo escribió.
SELECT 
    post.titulo AS titulo_post, 
    post.contenido AS contenido_post, 
    comentarios.contenido AS contenido_comentario, 
    usuarios.email AS email_usuario
FROM  post 
JOIN comentarios  ON post.id = comentarios.post_id
JOIN usuarios  ON comentarios.usuario_id = usuarios.id;

-- 9. Muestra el contenido del último comentario de cada usuario.


-- 10. Muestra los emails de los usuarios que no han escrito ningún comentario.
SELECT email
FROM usuarios
LEFT JOIN comentarios ON usuarios.id = comentarios.usuario_id
GROUP BY usuarios.id, usuarios.email
HAVING COUNT(comentarios.id) = 0;


