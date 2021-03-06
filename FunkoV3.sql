drop database UTEQ;
create database UTEQ;
USE UTEQ;

create table Sucursal 
(
    IdSuc int,
    nomSuc varchar (25) NOT NULL DEFAULT 'FUNKO',  
    calleSuc varchar (25) NOT NULL,      
    colSuc varchar (25) NOT NULL,        
    nointeSuc int (5),                   
    noextSuc int (5) NOT NULL,           
    cpSuc int(7) NOT NULL,               
    edoSuc varchar (25) NOT NULL,        
    muniSuc varchar (25) NOT NULL,       
    CONSTRAINT pk7 PRIMARY KEY(IdSuc),   
    INDEX IDX_MODULO_cpSuc (cpSuc),
    INDEX IDX_MODULO_edoSuc (edoSuc),
    INDEX IDX_MODULO_calleSuc (calleSuc),
    FULLTEXT INDEX BUSQUA_Sucursal (calleSuc(4),colSuc(4))

);


create table Usuario 
(
    IdUsu int,                                    
    PassUs varchar(32) NOT NULL,
    CorreoUs varchar(35) NOT NULL, 
    CONSTRAINT pk1 PRIMARY key (IdUsu),
    INDEX IDX_MODULO_PassUs (PassUs),
    INDEX IDX_MODULO_CorreoUs (CorreoUs)
);


create table Categoria 
(
    IdCat int,
    nomCat varchar (25) NOT NULL UNIQUE,
    CONSTRAINT pk8 PRIMARY KEY(IdCat)
);


create table ACCESOS
(
    IdAcc int,
    urlAcc TEXT NOT NULL,
    tipoAcc varchar (25) NOT NULL,
    CONSTRAINT pk8 PRIMARY KEY(IdAcc)
);

CREATE table Empleado 
(
    IdEmp int,
    nomEmp varchar (25) NOT NULL,
    appEmp varchar (25) NOT NULL ,
    apmEmp varchar (25) NOT NULL,
    tipoEmp varchar (25) NOT NULL, 
    idUsu int NOT NULL UNIQUE,
    CONSTRAINT pk2 PRIMARY KEY (IdEmp),
    CONSTRAINT fk1 FOREIGN key (idUsu) REFERENCES Usuario(IdUsu) ON DELETE NO ACTION ON UPDATE CASCADE,
    FULLTEXT INDEX BUSQUA_Empleado (appEmp(4),apmEmp(4))
);


create table Cliente 
(
    idCli int ,
    nomCli varchar (25) NOT NULL,
    apmCli varchar (25) NOT NULL,
    appCli varchar (25) NOT NULL,
    correoCli TEXT NOT NULL,
    telCli varchar (12), 
    rcfCli varchar(27) NOT NULL UNIQUE,
    muniCli varchar (20) NOT NULL,
    calleCli varchar (25) NOT NULL, 
    colCli varchar (25) NOT NULL,
    edoCli varchar (20) NOT NULL,
    cpCli varchar (20) NOT NULL,
    noiCli int(5),
    noeCli int (5) NOT NULL,
    fechCli date NOT NULL,
    Usuario int NOT NULL UNIQUE,
    passCli VARCHAR(32) NOT NULL,
   CONSTRAINT pk3 PRIMARY KEY(idCli),
   CONSTRAINT fk2 FOREIGN key (Usuario) REFERENCES  Usuario(idUsu) ON DELETE NO ACTION ON UPDATE CASCADE,
   INDEX IDX_MODULO_cpCli (cpCli),
   INDEX IDX_MODULO_telCli (telCli),
   FULLTEXT INDEX BUSQUA_CLIENTE (apmCli(5),appCli(5))

);



create table Articulo 
(
    IdArt int,
    nomArt varchar (25) NOT NULL UNIQUE,
    precArt float (10,2) NOT NULL DEFAULT 0,
    costoArt float (10,2) NOT NULL DEFAULT 0,
    IdCat int,
    CONSTRAINT pk10 PRIMARY KEY(IdArt),
    CONSTRAINT fk10 FOREIGN key (IdCat) REFERENCES Categoria(IdCat) ON DELETE SET NULL ON UPDATE CASCADE,
    FULLTEXT INDEX BUSQUA_Articulo (nomArt(5))
);


create table Inventario
(
    idSuc int NOT NULL,
    IdArt int NOT NULL,
    cantInv int(9) NOT NULL,
    CONSTRAINT pk6 PRIMARY KEY(IdSuc, idArt),
    CONSTRAINT fk5 FOREIGN key (idSuc) REFERENCES Sucursal(IdSuc) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk6 FOREIGN key (IdArt) REFERENCES Articulo(IdArt) ON DELETE NO ACTION ON UPDATE CASCADE

);


CREATE table Venta
(
   IdVent int,
   IdCli int NOT NULL,
   folioVent INT (10) NOT NULL,
   fechaFac date NOT NULL,
   fechVent date NOT NULL,
   estatus VARCHAR(15) NOT NULL DEFAULT "Pendiente",
   totalVent float (10,2) NOT NULL DEFAULT 0,
   CONSTRAINT pk4 PRIMARY KEY(IdVent),
   CONSTRAINT fk3 FOREIGN key (IdCli) REFERENCES  Cliente(idCli),
   UNIQUE INDEX IDX_MODULO_FolioVent (totalVent),
   INDEX IDX_MODULO_fechVent (fechVent)
);



create table Det_venta
(
   IdDetv int,
   cantDetv int (8) NOT NULL,
   idSuc int NOT NULL,
   IdArt int NOT NULL,
   idVent int NOT NULL,
   SubDet float (10,2) NOT NULL,
   CONSTRAINT pk5 PRIMARY KEY(IdDetv),
   CONSTRAINT fk4 FOREIGN key (IdArt) REFERENCES Inventario(IdArt) ON DELETE NO ACTION ON UPDATE CASCADE,
   CONSTRAINT fk7 FOREIGN key (idVent) REFERENCES Venta(idVent) ON DELETE NO ACTION ON UPDATE CASCADE,
   CONSTRAINT fk8 FOREIGN KEY(idSuc) REFERENCES Inventario(idSuc) ON DELETE NO ACTION ON UPDATE CASCADE
);
/*--------------------------------------------------------INDEX-----------------------------------------------------------------------*/
    /*SA*/
    /*1*/
    drop INDEX BUSQUA_Sucursal on Sucursal;
    ALTER TABLE Sucursal ADD  FULLTEXT INDEX BUSQUA_Sucursal(nomSuc(5),calleSuc(4),colSuc(4));
    /*2*/
    DROP INDEX IDX_MODULO_PassUs ON Usuario;
    ALTER TABLE Usuario ADD  UNIQUE INDEX IDX_MODULO_PassUs (PassUs);
    /*3*/
    DROP INDEX IDX_MODULO_FolioVent  ON Venta;
    ALTER TABLE Venta ADD  INDEX IDX_MODULO_FolioVent (FolioVent);
    /*DE*/
    /*1*/   
    DROP INDEX IDX_MODULO_cpSuc  ON Sucursal;
    ALTER TABLE Sucursal ADD INDEX IDX_MODULO_cpSuc (cpSuc);
    /*2*/
    drop INDEX BUSQUA_Articulo on Articulo;
    ALTER TABLE Articulo ADD FULLTEXT INDEX BUSQUA_Articulo (nomArt(5));
     /*3*/
    drop INDEX BUSQUA_CLIENTE on Cliente;
    ALTER TABLE Cliente ADD FULLTEXT INDEX BUSQUA_CLIENTE (apmCli(5),appCli(5));
                                                                            
/*--------------------------------------------------------ELIMINACION--------------------------------------------------------------------*/
    /*SA*/
    /*1*/
    drop INDEX IDX_MODULO_fechVent on Venta;
    /*2*/
    drop INDEX IDX_MODULO_telCli on Cliente;
    /*3*/
    drop INDEX IDX_MODULO_edoSuc on Sucursal;
    /*DE*/
     /*1*/
    drop INDEX  IDX_MODULO_calleSuc on Sucursal;
     /*2*/
    drop INDEX   IDX_MODULO_CorreoUs on Usuario;
                                                                            
/*------------------------------------------Trigger de Inventario--------------------------------------------------------------------------------------------*/
DROP TRIGGER IF EXISTS disparadorInven;
DELIMITER //
CREATE TRIGGER disparadorInven BEFORE INSERT ON Det_venta
FOR EACH ROW
BEGIN
    DECLARE cantidad INT;
    DECLARE total FLOAT(10,2);
    DECLARE descuento FLOAT(10,2);
    SET total = 1;
    SET cantidad = (SELECT cantInv FROM Inventario WHERE idArt = new.idArt AND idSuc = new.idSuc);
    SET total = (SELECT totalVent FROM Venta WHERE idVent = new.idVent);

    IF new.cantDetv >= 10 THEN
        SET descuento = ((new.cantDetv * (SELECT precArt FROM Articulo WHERE idArt = new.idArt)) * 50)/100;
    ELSE
        SET descuento = 0;
    END IF;
    IF new.cantDetv <= cantidad AND new.cantDetv <= 10 AND new.cantDetv > 0 THEN
        UPDATE Inventario SET cantInv = cantidad - new.cantDetv WHERE idSuc = new.idSuc AND idArt = new.idArt;
        SET new.SubDet = (new.cantDetv * (SELECT precArt FROM Articulo WHERE idArt = new.idArt)) - descuento;
        UPDATE Venta SET totalVent = total + new.SubDet WHERE idVent = new.idVent;
        UPDATE Venta SET folioVent = idVent;
    ELSE
        SET new.idDetv = NULL;
    END IF;
END//
DELIMITER ;
/*-------------------------------------Trigger que realiza registro de empleado---------------------------------------------------------*/
DELIMITER //
CREATE TRIGGER disparadorUsEmp BEFORE INSERT ON Empleado
FOR EACH ROW
BEGIN
    DECLARE idU INT;
    DECLARE pass VARCHAR(15);
    DECLARE correo VARCHAR(50);
    DECLARE correov VARCHAR(50);

    SET idU = (SELECT MAX(idUsu) FROM Usuario);
    IF idU IS NULL THEN
        SET idU = 1;
    ELSE 
        SET idU = idU +1;
    END IF;

    SET pass = (CONCAT(
        CHAR(ROUND(RAND()*25)+97),
        CHAR(ROUND(RAND()*25)+97),
        CHAR(ROUND(RAND()*25)+97),
        CHAR(ROUND(RAND()*25)+97),
        CHAR(ROUND(RAND()*25)+65),
        CHAR(ROUND(RAND()*25)+65),
        CHAR(ROUND(RAND()*25)+97),
        CHAR(ROUND(RAND()*25)+97),
        CHAR(ROUND(RAND()*25)+65),
        CHAR(ROUND(RAND()*25)+97),
        CHAR(ROUND(RAND()*25)+97),
        CHAR(ROUND(RAND()*25)+97),
        CHAR(ROUND(RAND()*25)+65),
        CHAR(ROUND(RAND()*25)+97),
        CHAR(ROUND(RAND()*25)+65)
    )
    );
    SET correo = (CONCAT(new.nomEmp, '.', new.appEmp, '@funko.com.mx'));
    SET correov = (SELECT COUNT(*) FROM Usuario WHERE CorreoUs like correo);

    IF correov > 0 THEN
        SET correo = (CONCAT(new.nomEmp, '.', new.appEmp, idU, '@funko.com.mx'));
    END IF;
    SET new.idUsu = idU;
    INSERT INTO Usuario VALUES(idU, pass, correo);
END//
DELIMITER ;
/*-------------------------------------Trigger que realiza registro de clientes--------------------------------------------------------------------------------------*/
DELIMITER //
CREATE TRIGGER dispUsuCli BEFORE INSERT ON Cliente
FOR EACH ROW
BEGIN
    DECLARE cont int;
    DECLARE idUC int;
    DECLARE contraseña varchar(32);
    DECLARE correo varchar(35);


    SET idUC = (SELECT MAX(idUsu) FROM Usuario);
    IF idUC is NULL THEN
    SET idUC = 1;
    ELSE 
    SET idUC = idUC +1;
    END IF;

    SET contraseña = (md5(new.passCli));

    SET correo =new.correoCli;

    SET cont= (SELECT COUNT(*) 
              FROM Usuario
              WHERE Usuario.CorreoUs like correo);

    
    IF cont like 0 THEN
    INSERT INTO Usuario VALUES(idUC, contraseña, correo);
    SET new.passCli=contraseña;
    SET new.Usuario=idUC;
    ELSE
    SET new.idCli=null;
   END IF;

END//
DELIMITER ;
/*------------------Insercion de datos-----------------------------------------------------------------------------------------------*/

INSERT INTO Sucursal VALUES
(1, "Sucursal1", "calle", "colonia", 1, 1, 76148, "estado", "municipio"),
(2, "Sucursal2", "calle", "colonia", 1, 1, 76148, "estado", "municipio");

INSERT INTO Categoria VALUES
(1, "Categoria1");

INSERT INTO Empleado VALUES
(1, "Hugo", "Lopez", "Gatell", "Administrador", 1);

INSERT INTO Cliente VALUES
(1, "Cliente1", "apellido", "apellido2", "correo", "4424878733", "RFC", "muni", "calle", "col", "edo", "cp", 1, 1, 20200607, 1, "pass");

INSERT INTO Articulo VALUES
(1, "Funko1", 100, 50, 1),
(2, "Funko2", 200, 100, 1);

INSERT INTO Inventario VALUES
(1, 1, 100),
(1, 2, 100),
(2, 1, 100),
(2, 2, 100);

INSERT INTO Venta VALUES
(1, 1, 1000000, 20200607, 20200607, "Pendiente", 0),
(2, 1, 1000000, 20200607, 20200607, "Pendiente", 0);

INSERT INTO Det_venta VALUES
(1, 1, 1, 1, 1, 1000),
(2, 1, 1, 2, 1, 1000),
(3, 1, 2, 1, 2, 1000),
(4, 1, 2, 2, 2, 1000);

/*---------------------Procedimiento Almacenado que agrega productos-------------------------------------------------------------------*/
DELIMITER //
  CREATE PROCEDURE agregar_producto (IN nom varchar(25), IN prec float(10,2), IN cost float(10,2), IN idCat int )
  BEGIN
  DECLARE idA int;
  SET idA=(SELECT max(IdArt) FROM Articulo);
  IF idA is null THEN 
      SET idA=1;
    ELSE
      SET idA=idA+1;
    END IF;

    INSERT INTO Articulo VALUES(idA,nom,prec,cost,idCat);

  END//
  DELIMITER ;
/*-------------------------Procedimiento que valida el inicio de sesion----------------------------------------------------------------*/
DELIMITER //
CREATE PROCEDURE procedimientoSesion (IN corr VARCHAR(50), pass VARCHAR(15), OUT valido INT)
BEGIN
    DECLARE c INT;
    SET c = (SELECT COUNT(*) FROM Usuario WHERE CorreoUs like corr AND PassUs like pass);
    IF c > 0 THEN
        SET valido = 1;
    ELSE
        SET valido = 0;
    END IF;
END//
DELIMITER ;
CALL procedimientoSesion('Jorge.Lopez@funko.com.mx', 'cxiwKMddJiqdShH', @valido);
SELECT @valido;
DROP PROCEDURE  procedimientoSesion;
/*-------------------------------Tabla derivada de descuento-------------------------------------------------------------*/
SELECT *,
CASE
WHEN tablita2.STATUS="TUVO DESCUENTO" THEN 0.15
WHEN tablita2.STATUS="NO TUVO DESCUENTO" THEN 0
END AS "DESCUENTO"
FROM(
SELECT *,
CASE
WHEN tablita.Productos_comprados>5 THEN "TUVO DESCUENTO"
WHEN tablita.Productos_comprados<=5 THEN "NO TUVO DESCUENTO"
END AS "STATUS"
FROM (
SELECT Cliente.nomCli, SUM(Det_venta.cantDetv) AS "Productos_comprados"
FROM Det_venta INNER JOIN Venta ON(Det_venta.IdVent like Venta.idVent)
INNER JOIN Cliente ON(Venta.IdCli like Cliente.IdCli)
GROUP BY Cliente.nomCli)tablita)tablita2;
/*--------------------------------------------------Vista de ganancias o perdidas al aplicar un descuento--------------------------------------------------------*/
CREATE VIEW view_por1
 AS

SELECT *,(CASE
 WHEN porcentaje < 0 THEN "perdida"
 WHEN porcentaje > 0 THEN "Hay Ganancias"
 WHEN porcentaje = 0 THEN "No hay ganancias" end) AS estatus

from 
(
SELECT  nomArt,cantInv as Cantidad,sum(cantInv * precArt) as Total_precArt,sum(cantInv * costoArt) as Total_Costo,
(sum(cantInv * precArt)-sum(cantInv * costoArt)) as Ganancia_Maxim,
((sum(cantInv * precArt)-sum(cantInv * costoArt))-((sum(cantInv * precArt)-sum(cantInv * costoArt))*0.05)) as porcentaje
from Inventario
INNER join Sucursal on(Inventario.idSuc=Sucursal.IdSuc)
inner join Articulo on(Inventario.IdArt=Articulo.IdArt)
GROUP BY Inventario.IdArt,Sucursal.idSuc
)as tabla1
WHERE tabla1.Ganancia_Maxim=
(
SELECT MAX(Ganancia_Maxim) as Ganancia_Maxim
from
(
SELECT  nomArt,sum(cantInv) as Cantidad,sum(cantInv * precArt) as Total_precArt,sum(cantInv * costoArt) as Total_Costo,
(sum(cantInv * precArt)-sum(cantInv * costoArt)) as Ganancia_Maxim
from Inventario
INNER join Sucursal on(Inventario.idSuc=Sucursal.IdSuc)
inner join Articulo on(Inventario.IdArt=Articulo.IdArt)
GROUP BY Inventario.IdArt,Sucursal.idSuc
)as tabla2
)
;
/*-------------------Cliente mas activo y menos acctivo-------------------------------------------------------------------------*/
CREATE VIEW view_por2 as
SELECT *
 from 
 (
SELECT Venta.idcli,nomcli,apmCli,appCli,muniCli as muni,sum(totalVent) as total
from Cliente 
INNER JOIN Usuario on(Cliente.Usuario=Usuario.idUsu)
INNER JOIN Venta on(Venta.idCli=Cliente.idCli)
GROUP BY idcli
)as tabla1 where tabla1.total=(

SELECT  MAX(total) as total

from (

SELECT Venta.idcli,nomcli,apmCli,appCli,muniCli as muni,sum(totalVent) as total
from Cliente 
INNER JOIN Usuario on(Cliente.Usuario=Usuario.idUsu)
INNER JOIN Venta on(Venta.idCli=Cliente.idCli)
GROUP BY idcli
)as tabla2
) or
tabla1.total=(

SELECT  min(total) as total

from (

SELECT Venta.idcli,nomcli,apmCli,appCli,muniCli as muni,sum(totalVent) as total
from Cliente 
INNER JOIN Usuario on(Cliente.Usuario=Usuario.idUsu)
INNER JOIN Venta on(Venta.idCli=Cliente.idCli)
GROUP BY idcli
)as tabla2
)
;
/*--------------------------------------------------------------------------------------------------------------------------------------*/

/*-------------------------Imprimir la factura---------------------------*/

CREATE VIEW Factura AS
SELECT Venta.folioVent AS "FOLIO", Venta.fechaFac AS "FECHA",
concat_ws(' ', Cliente.nomCli,Cliente.appCli,Cliente.apmCli) AS "CLIENTE",
Cliente.rcfCli AS "RFC", 
concat_ws(' ', Cliente.calleCli,Cliente.noeCli,Cliente.noiCli,Cliente.colCli) AS "DIRECCION",
concat_ws('/', Cliente.edoCli,Cliente.muniCli) AS "ESTADO/MUNICIPIO",
Sucursal.nomSuc AS "SUCURSAL", Articulo.nomArt AS "PRODUCTO",
Det_venta.cantDetv AS "CANTIDAD",
Det_venta.SubDet AS "SUBTOTAL"
FROM Cliente INNER JOIN Venta ON(Cliente.IdCli like Venta.idCli)
INNER JOIN Det_venta ON(Venta.idVent like Det_venta.idVent)
INNER JOIN Inventario ON (Det_venta.idSuc like Inventario.idSuc AND Det_venta.IdArt like Inventario.IdArt) 
INNER JOIN Articulo ON (Inventario.IdArt like Articulo.IdArt)
INNER JOIN Sucursal ON(Inventario.IdSuc like Sucursal.idSuc)
WHERE Venta.estatus like "Pagada"; 

/*------------------------Trigger al actualizar venta----------------------------*/

DELIMITER //
CREATE TRIGGER status AFTER UPDATE ON Venta
FOR EACH ROW
BEGIN
DECLARE dev1 int;
DECLARE dev2 int;
DECLARE can int;
DECLARE idD int;
DECLARE idA int;
DECLARE idS int;
DECLARE done int DEFAULT 0;
DECLARE status varchar(15);


DECLARE c1 CURSOR FOR SELECT cantDetv, IdDetv, Det_venta.IdArt, Det_venta.IdSuc
FROM Venta INNER JOIN Det_venta ON(Venta.IdVent like Det_venta.idVent)
WHERE Venta.idVent=old.idVent; 

DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done=1;

OPEN c1;

SET status=new.estatus;

IF status LIKE "Cancelado" THEN
REPEAT
    FETCH c1 INTO can,idD,idA,idS;
    IF NOT done THEN
    SET dev1=(SELECT cantInv
    FROM Det_venta INNER JOIN Inventario ON(Det_venta.IdSuc like Inventario.IdSuc and Det_venta.IdArt like Inventario.IdArt)
    WHERE Det_venta.IdArt=idA and Det_venta.IdSuc=idS);
    SET dev2=dev1+can;

    UPDATE Inventario SET cantInv=dev2 WHERE idSuc=idS and IdArt=idA;

    DELETE FROM Det_venta WHERE IdDetv=idD;

    END IF;
  UNTIL done END REPEAT;
  CLOSE c1;

END IF;
END;//
DELIMITER ;

/*------------------Historial de Compras---------------------------------*/

DELIMITER //
CREATE PROCEDURE Hist_Compras (IN idC int)
BEGIN
SELECT Articulo.nomArt,Articulo.precArt, Venta.fechVent
FROM Venta INNER JOIN Det_venta ON(Venta.idVent like Det_venta.IdVent)
INNER JOIN Inventario ON(Det_venta.IdArt like Inventario.IdArt and Det_venta.IdSuc like Inventario.IdSuc)
INNER JOIN Articulo ON(Inventario.IdArt like Articulo.IdArt)
WHERE Venta.IdCli=idC;
END//
DELIMITER ;

CALL Hist_Compras(1);

/*-Tabla derivada del cliente que mas a comprado y el que menos a comprado_*/

SELECT *
FROM (
SELECT Cliente.nomCli, COUNT(*) AS "Num_Compras"
FROM Venta INNER JOIN Cliente ON(Venta.idCli like Cliente.idCli)
GROUP BY Venta.IdCli)tabla1
WHERE tabla1.Num_Compras=(
SELECT MIN(tabla2.Num_Compras)
FROM(
SELECT Cliente.nomCli, COUNT(*) AS "Num_Compras"
FROM Venta INNER JOIN Cliente ON(Venta.idCli like Cliente.idCli)
GROUP BY Venta.IdCli)tabla2
) or tabla1.Num_Compras=(
SELECT max(tabla3.Num_Compras)
FROM (
SELECT Cliente.nomCli, COUNT(*) AS "Num_Compras"
FROM Venta INNER JOIN Cliente ON(Venta.idCli like Cliente.idCli)
GROUP BY Venta.IdCli)tabla3
);

/*--------------------------------------------------Vista de las personas que han canselado ----------------------------------------------------------------------------------*/
    create  VIEW view_por8 as
SELECT  DISTINCT(fechVent),IdVent as venta ,PassUs as contraseña ,CorreoUs as coorreo,CONCAT (nomCli," ",apmCli) as nombre ,telCli as telefono,rcfCli as rfc,
CASE
WHEN tabla1.estatus="canselado" THEN "Compra no exitosa"
END AS leyenda
from (

SELECT  DISTINCT(fechVent),IdVent,PassUs,CorreoUs,nomCli,apmCli,telCli,rcfCli,estatus 
 from 
 (
SELECT   DISTINCT(fechVent), Venta.IdVent as IdVent,PassUs,CorreoUs,nomCli,apmCli,telCli,rcfCli,estatus
from  Venta
INNER JOIN Cliente on(Venta.IdCli=Cliente.idCli)
INNER JOIN Usuario on(Cliente.Usuario=Usuario.idUsu)
where Venta.IdVent  in 
(
SELECT Venta.IdVent from Venta
WHERE Venta.estatus="canselado"
)

)as usuario

) as tabla1;
/*------------------------------------------------------Tabala derivada de las personas que no comparan desde hace 5 años----------------------------------------------------------------------------------------*/
   SELECT *
    FROM 
    (
   SELECT DISTINCT( Cliente.idCli) as cli,nomCli,apmCli,telCli,rcfCli
    ,DATEDIFF(fechVent,NOW()) AS diferencias_dias
    FROM Usuario 
    INNER JOIN Cliente ON(Usuario.IdUsu=Cliente.Usuario)
    INNER JOIN Venta ON(Venta.IdCli=Cliente.idCli)
     HAVING diferencias_dias<(365*5)
    )AS tabla2 where tabla2.diferencias_dias
   <=
    (
    SELECT max( tabla1.diferencias_dias) AS diferencias_dias
    FROM 
    (
   SELECT DISTINCT( Cliente.idCli) as cli,nomCli,apmCli,telCli,rcfCli
    ,DATEDIFF(fechVent,NOW()) AS diferencias_dias
    FROM Usuario 
    INNER JOIN Cliente ON(Usuario.IdUsu=Cliente.Usuario)
    INNER JOIN Venta ON(Venta.IdCli=Cliente.idCli)
     HAVING diferencias_dias<=(365*5)
    )AS tabla1
    )  
    ;
/*-------------------------------------------------------Subconsulta que permite saber que personas estan registradas pero no han realizado un venta-----------------------------------------------------------------------------------------------------*/
     
SELECT DISTINCT Usuario,PassUs,CorreoUs,nomCli,apmCli,telCli,rcfCli
from Cliente 
INNER JOIN Usuario on(Cliente.Usuario=Usuario.idUsu)

WHERE Usuario not in

(SELECT DISTINCT cli
from (

SELECT  cli,PassUs,CorreoUs,nomCli,apmCli,telCli,rcfCli
 from 
 (
SELECT DISTINCT Usuario as cli,PassUs,CorreoUs,nomCli,apmCli,telCli,rcfCli
from  Venta
INNER JOIN Cliente on(Venta.IdCli=Cliente.idCli)
INNER JOIN Usuario on(Cliente.Usuario=Usuario.idUsu)

where Venta.IdVent  in 
(
SELECT DISTINCT Venta.IdVent from  Venta

)

 )as tabla1
)x
)
;
/*----------------------------------------------------------Procedmineto que guarda las personas que han canselado una compra--------------------------------------------------------------------------------------------------*/
DROP PROCEDURE prueba;

DELIMITER //

CREATE PROCEDURE prueba()
BEGIN
DECLARE done INT DEFAULT 0;
DECLARE idVen,IdCl int;
DECLARE fechaFa date;
DECLARE folioVen int;
DECLARE fechVen date;
DECLARE totalVen decimal(10,2);
DECLARE cur1 CURSOR FOR SELECT DISTINCT idVent,Cliente.IdCli,folioVent,fechaFac,fechVent,totalVent FROM venta INNER JOIN  cliente on(Venta.idCli=Cliente.idCli )
where estatus="canselado";

DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done = 1;
OPEN cur1;

REPEAT
FETCH cur1 INTO idVen,IdCl,folioVen,fechaFa,fechVen,totalVen;
INSERT INTO Venta3 VALUES (0,idVen,IdCl,folioVen,fechaFa,fechVen,totalVen);
UNTIL done END REPEAT;
CLOSE cur1;
END//
DELIMITER ;
/*Tabla donde se guardan*/
        
CREATE table Venta3
(
  id int  AUTO_INCREMENT ,
   IdVent int,
   IdCli int ,
   folioVent int ,
   fechaFac date ,
   fechVent date ,
   totalVent float (10,2) ,
   CONSTRAINT pk13 PRIMARY KEY(id),
   CONSTRAINT fk12 FOREIGN key (IdCli) REFERENCES  Cliente(idCli)
);
/*------------------------------------------------------------------------------------------------------------------------------------------------------------*/
SELECT * FROM Det_venta;
SELECT * FROM Articulo;
SELECT * FROM Usuario;
SELECT * FROM Empleado;
SELECT * FROM Cliente;

    
    


