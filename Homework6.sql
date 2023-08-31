use semimar_4;

-- 1. Создайте таблицу users_old, аналогичную таблице users.
-- Создайте процедуру, с помощью которой можно переместить любого (одного)
-- пользователя из таблицы users в таблицу users_old.
-- (использование транзакции с выбором commit или  rollback - обязательно)
DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old (
	id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    email VARCHAR(120) UNIQUE);
    
DROP PROCEDURE IF EXISTS remove_user;
DELIMITER //
CREATE PROCEDURE remove_user( user_id BIGINT)
BEGIN

	START TRANSACTION;

		INSERT INTO users_old(id, firstname, lastname, email)
		SELECT * FROM users WHERE id = user_id;

		DELETE FROM users WHERE id = user_id;

	COMMIT;

END //
DELIMITER ;

INSERT INTO users(id, firstname, lastname, email)
VALUES(100, 'TEST', 'TEST2', 'TEST@example.org');
CALL remove_user(100);

-- 2. Создайте хранимую функцию hello(), которая будет возвращать приветствие 
-- в зависимости от текущего времени суток.
-- С 6.00 до 12.00 функция должна возвращать фразу "Доброе утро"
-- с 12.00 до 18.00 функция должна возвращать фразу "Добрый день"
-- с 18.00 до 00.00 - "Добрый вечер"
-- с 00.00 до 6.00 - "Доброй ночи"
DROP FUNCTION IF EXISTS hello;
DELIMITER //
CREATE FUNCTION hello()
RETURNS TEXT DETERMINISTIC
BEGIN
IF (HOUR(NOW()) >= 6 AND HOUR(NOW()) < 12 ) THEN SET @reply = "Доброе утро";
END IF;
IF (HOUR(NOW()) >= 12 AND HOUR(NOW()) < 18 ) THEN SET @reply = "Добрый день";
END IF;
IF (HOUR(NOW()) >= 18 AND HOUR(NOW()) < 24 ) THEN SET @reply = "Добрый вечер";
END IF;
IF (HOUR(NOW()) = 0 AND HOUR(NOW()) < 6 ) THEN SET @reply = "Доброй ночи";
END IF;
RETURN @reply;
END//
DELIMITER ;

SELECT hello();
