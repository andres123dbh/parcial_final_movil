SET GLOBAL log_bin_trust_function_creators = 1;

CREATE DATABASE IF NOT EXISTS parcial_movil_db;

USE parcial_movil_db;

CREATE TABLE IF NOT EXISTS users (
	id INT PRIMARY KEY AUTO_INCREMENT,
	email VARCHAR(70) NOT NULL UNIQUE KEY,
	contrasenna VARCHAR(500) NOT NULL,
	foto LONGBLOB NOT NULL,
	nombre_completo VARCHAR(500) NOT NULL,
	celular BIGINT NOT NULL,
	cargo VARCHAR(500) NOT NULL
);

CREATE TABLE IF NOT EXISTS users_devices (
	id INT PRIMARY KEY AUTO_INCREMENT,
	user_id INT NOT NULL,
	model VARCHAR(500) NOT NULL,
	device_uuid VARCHAR(50) NOT NULL UNIQUE KEY,
	token_fmc VARCHAR(500) UNIQUE KEY,
	CONSTRAINT `fk_users_device`
    FOREIGN KEY (user_id) REFERENCES users (id)
);

CREATE TABLE IF NOT EXISTS sent_messages (
	id INT PRIMARY KEY AUTO_INCREMENT,
	titulo VARCHAR(100) NOT NULL,
	cuerpo VARCHAR(800) NOT NULL,
	email_remitente VARCHAR(70) NOT NULL,
	email_destinatario VARCHAR(70) NOT NULL,
	tokens_destinatario JSON NOT NULL,
	resultado VARCHAR(100) NOT NULL
);

DELIMITER //
CREATE PROCEDURE signup 
	(IN  emailI VARCHAR(70),IN  contrasennaI VARCHAR(500),IN  fotoI LONGBLOB,IN nombre_completoI VARCHAR(500),IN celularI BIGINT,IN cargoI VARCHAR(500))
 BEGIN
  INSERT INTO users (email, contrasenna, foto, nombre_completo, celular, cargo) 
  	VALUES (emailI, SHA2(MD5(contrasennaI),256),fotoI,nombre_completoI,celularI,cargoI);
 END;
 
CREATE FUNCTION login 
	(emailI VARCHAR(70), contrasennaI VARCHAR(500)) 
		RETURNS BOOLEAN
		RETURN (
			SELECT IF (
					(SELECT us.email FROM users AS us 
					WHERE us.email = emailI AND us.contrasenna = SHA2(MD5(contrasennaI),256)) = emailI, TRUE, FALSE)
		);
		
CREATE FUNCTION get_token_user 
	(emailI VARCHAR(70),device_uuidI VARCHAR(50), modelI VARCHAR(500)) 
		RETURNS VARCHAR(500)
		RETURN (
			SELECT token_fmc FROM users_devices,users
				WHERE users_devices.user_id = (
					SELECT users.id 
						WHERE users.email = emailI
				)
				AND device_uuid = device_uuidI
				AND model = modelI
		);
		
CREATE FUNCTION get_all_tokens_user 
	(emailI VARCHAR(70)) 
		RETURNS JSON
		RETURN (
			SELECT JSON_ARRAYAGG(token_fmc) FROM users_devices,users
				WHERE users_devices.user_id = (
					SELECT users.id 
						WHERE users.email = emailI
				)
		);

CREATE PROCEDURE insert_token 
	(IN emailI VARCHAR(70),IN device_uuidI VARCHAR(50),IN modelI VARCHAR(500), IN token_fmcI VARCHAR(500))
 BEGIN
  INSERT INTO users_devices (user_id, model, device_uuid, token_fmc) 
  	VALUES ((SELECT id FROM users
					WHERE email = emailI
				)
				, modelI,device_uuidI,token_fmcI);
 END;
 
 CREATE PROCEDURE change_token_user 
	(IN  emailI VARCHAR(70),IN  device_uuidI VARCHAR(50),IN  modelI VARCHAR(500), IN token_fmcI VARCHAR(500))
 BEGIN
  UPDATE users_devices SET token_fmc = token_fmcI
	  WHERE user_id = (
						SELECT users.id FROM users
							WHERE users.email = emailI
					)
					AND device_uuid = device_uuidI
					AND model = modelI;
 END;
 
CREATE PROCEDURE save_sent_message 
	(IN  tituloI VARCHAR(100),IN  cuerpoI VARCHAR(800),IN  email_remitenteI VARCHAR(70),IN email_destinatarioI VARCHAR(70),IN tokens_destinatarioI JSON,IN resultadoI VARCHAR(100))
 BEGIN
  INSERT INTO sent_messages (titulo, cuerpo, email_remitente, email_destinatario, tokens_destinatario, resultado) 
  	VALUES (tituloI, cuerpoI,email_remitenteI,email_destinatarioI,tokens_destinatarioI,resultadoI);
 END;
 
//



-- CALL signup('andres@gmail', '1234','iVBORw0KGgoAAAANSUhEUgAAAfQAAAJPCAYAAACKMyahAAAAAXNSR0IArs4c6QA','andres bonilla',3012053104,'desempleado');

-- CALL insert_token('andres@gmail', '1414','samsung','iVBORw0KGgoAAAANSUhEUgAAAfQAAAJPCAYAAACKMyahAAAAAXNSR0IArs4c6QA');

-- CALL insert_token('andres@gmail', '1415','samsung','isVBORw0KGgoAAAANSUhEUgAAAfQAAAJPCAYAAACKMyahAAAAAXNSR0IArs4c6QA');

-- SELECT login('andres@gmail','1234');

-- SELECT get_token_user('andres@gmail','1414','samsung');

-- SELECT get_all_tokens_user('andres@gmail');

-- CALL change_token_user('andres@gmail','1414','samsung','iVBORw0KGgoAAAANSUhEUgAAAfQAAAJPCAYAAACKMyahAAAAAXNSR0IArs4c6QB');

-- CALL save_sent_message('MENSAJE','este es un mensaje','andres@gmail','dsffds@gmai',JSON_ARRAY('iVBORw0KGgoAAAANSUhEUgAAAfQAAAJPCAYAAACKMyahAAAAAXNSR0IArs4c6QB','isVBORw0KGgoAAAANSUhEUgAAAfQAAAJPCAYAAACKMyahAAAAAXNSR0IArs4c6QA'),'ENVIADO');