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

UPDATE empleado 
SET employee_hire_date= (substr(employee_hire_date, 7, 4) || '-' || substr(employee_hire_date, 4, 2) || '-' || substr(employee_hire_date, 1, 2))
WHERE employee_hire_date <> ""

/* SEGUNDA PROBLEMATICA */

CREATE VIEW  vista_1 AS
SELECT DISTINCT
		cli.customer_id AS IdCliente,
		cli.customer_name AS NombreCliente,
		cli.customer_surname AS ApellidoCliente,
		cli.customer_DNI AS DNI_Cliente,
		(date('now')-cli.dob) AS edad,
		suc.branch_number AS NumeroSucursal
FROM cliente cli, sucursal suc 
WHERE suc.branch_id = cli.branch_id ;

SELECT * FROM vista_1
	WHERE EDAD > 40
ORDER BY DNI_Cliente ASC

SELECT * FROM vista_1
	WHERE NombreCliente = "Anne" or NombreCliente = "Tyler"
ORDER BY EDAD ASC

/* Insertar 5 nuevos clientes de un JSON */

INSERT INTO cliente (customer_name, customer_surname, branch_id, customer_DNI, dob) 
SELECT json_extract(json_each.value, '$.customer_name'), json_extract(json_each.value, '$.customer_surname'), json_extract(json_each.value, '$.branch_id'), json_extract(json_each.value, '$.customer_DNI'), json_extract(json_each.value, '$.customer_dob')
FROM json_each('[
    {"customer_name": "Lois", "customer_surname": "Stout", "customer_DNI": 47730534,"branch_id": 80,"customer_dob": "1984-07-07"
    },
    {"customer_name": "Hall", "customer_surname": "Mcconnell", "customer_DNI": 52055464,
    "branch_id": 45,"customer_dob": "1968-04-30"
    },
    {"customer_name": "Hilel", "customer_surname": "Mclean", "customer_DNI": 43625213,
    "branch_id": 77,"customer_dob": "1993-03-28"
    },
    {"customer_name": "Jin", "customer_surname": "Cooley", "customer_DNI": 21207908,"branch_id": 96,"customer_dob": "1959-08-24"
    },
    {"customer_name": "Gabriel", "customer_surname": "Harmon", "customer_DNI": 57063950,
    "branch_id": 27,"customer_dob": "1976-04-01"}]');

UPDATE cliente SET branch_id = 10
WHERE customer_id > 500

DELETE FROM cliente
WHERE customer_name = "Noelle"
/* No esta en la base de datos el cliente Noel David por eso borre otro */

SELECT c.customer_name, c.customer_surname, p.loan_type, p.loan_date, p.loan_total
FROM cliente c, prestamo p
WHERE c.customer_id = p.customer_id
ORDER BY p.loan_total DESC LIMIT 


/* TERCER PROBLEMATICA */

CREATE VIEW Cuenta_Saldo_Negativo AS
SELECT c.customer_name AS NombreCliente,
	   c.customer_DNI AS DNI_Cliente,
	   cue.account_id AS Numero_Cuenta,
	   cue.balance AS Saldo
FROM cliente c, cuenta cue
WHERE c.customer_id = cue.customer_id AND cue.balance < 0;

SELECT customer_name, customer_surname, (date('now') - dob) AS Edad
FROM cliente
WHERE customer_surname LIKE "%Z%" AND customer_surname LIKE "%z%";

SELECT c.customer_name as Nombre, c.customer_surname AS Apellido, (date('now')-c.dob)as Edad, s.branch_name as Nombre_sucursal
FROM cliente c, sucursal s
WHERE c.customer_name = "Brendan" AND
		c.branch_id = s.branch_id
ORDER BY s.branch_name ASC

SELECT * FROM prestamo
WHERE loan_total/100 > 80000
UNION
SELECT * FROM prestamo
WHERE loan_type = "PRENDARIO" ORDER BY loan_type DESC

SELECT *
FROM prestamo
WHERE loan_total > (SELECT avg(loan_total)
					FROM prestamo)

SELECT count(customer_name) AS Menores_50
FROM cliente WHERE (date('now') - dob) < 50


SELECT * FROM cuenta
WHERE balance/100 > 8000
ORDER BY account_id LIMIT 5

SELECT * FROM prestamo
WHERE loan_date LIKE "%-04-%" OR
	  loan_date LIKE "%-06-%" OR loan_date LIKE "%-08-%"
ORDER BY loan_total

SELECT SUM(loan_total), loan_type
FROM prestamo
GROUP BY loan_type

SELECT COUNT(c.customer_name) AS CantidadClientes, s.branch_name
FROM cliente c, sucursal s
WHERE c.branch_id = s.branch_id
GROUP BY s.branch_name
ORDER BY COUNT(c.customer_name) DESC

Nos FALTA LA CANTIDAD DE EMPLEADO POR CLIENTE EN UNA SUCURSAL COMO NUMERO REAL

SELECT count(t.card_type), s.branch_name
FROM tarjeta t, sucursal s, cliente c
WHERE t.customer_id = c.customer_id AND
		s.branch_id = c.branch_id AND
		t.card_type = "CREDITO"
GROUP BY s.branch_name
ORDER BY s.branch_name

SELECT sum(pre.loan_total) / count((pre.loan_type)), suc.branch_name
from prestamo pre, cliente cli, sucursal suc
where pre.customer_id = cli.customer_id AND cli.branch_id = suc.branch_id
GROUP BY suc.branch_name



