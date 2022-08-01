/* PRIMER PROBLEMATICA */

/* Crear en la base datos los tipos de cliente, cuenta y marcas de tarjeta */
ALTER TABLE cliente
ADD COLUMN CLienteType TEXT

CREATE TABLE TypeClient(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tipo TEXT NOT NULL
);

INSERT INTO `TypeClient` (`tipo`)
VALUES
  ("GOLD"),
  ("CLASSIC"),
  ("CLASSIC"),
  ("GOLD"),
  ("GOLD"),
  ("BLACK"),
  ("CLASSIC"),
  ("BLACK"),
  ("GOLD"),
  ("GOLD");
/* A modo demostracion se incluye el codigo de 10 datos generado aleatoriamente. */

UPDATE cliente SET ClientType = (SELECT tipo FROM TypeClient ty WHERE ty.id = cliente.customer_id)

DROP TABLE TypeClient   

CREATE TABLE tarjeta(
   card_id INTEGER primary key AUTOINCREMENT,
   card_number VARCHAR(20) NOT NULL UNIQUE,
   card_expire_date INTEGER NOT NULL,
   card_given_date INTEGER NOT NULL,
   card_cvv INTEGER NOT NULL,
   card_type TEXT NOT NULL,
   customer_id INTEGER NOT NULL,
   FOREIGN KEY (customer_id) REFERENCES  cliente (customer_id)
);

/* Los INSERT se realizan en otro archivo con nombre TARJETA_GENERACION*/

CREATE TABLE marca_tarjeta(
   brand_card_id INTEGER PRIMARY KEY AUTOINCREMENT,
   brand_name TEXT NOT NULL,
   card_id INTEGER NOT NULL,
   FOREIGN KEY (card_id) REFERENCES  tarjeta (card_id)
);

/* Los INSERT se realizan en otro archivo con nombre MARCA_TARJETA_GENERACION*/

CREATE TABLE tipo_cuenta(
   account_type_id INTEGER PRIMARY KEY AUTOINCREMENT,
   account_type_description TEXT NOT NULL,
   account_id INTEGER default NULL,
   FOREIGN KEY (account_id) REFERENCES cuenta (account_id)
);

/* Los INSERT se realizan en otro archivo con nombre TIPO_CUENTA_GENERACION*/


CREATE TABLE `direcciones` (
	direccion_id INTEGER PRIMARY KEY AUTOINCREMENT,
	calle TEXT NOT NULL,
	numero INTEGER NOT NULL,
	prov TEXT NOT NULL,
	ciudad TEXT NOT NULL,
	pais TEXT NOT NULL
);
