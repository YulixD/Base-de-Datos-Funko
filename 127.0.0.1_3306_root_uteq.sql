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
    FULLTEXT INDEX BUSQUA_Sucursal (calleSuc(4) ASC,colSuc(4) ASC)

);


create table Usuario 
(
    IdUsu int,                                    
    PassUs varchar(15) NOT NULL,
    CorreoUs varchar(35) NOT NULL, /* Agregue correo y quite tipo */
    CONSTRAINT pk1 PRIMARY key (IdUsu),
    INDEX IDX_MODULO_PassUs (PassUs)
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
    tipoAcc varchar (25) NOT NULL UNIQUE,
    CONSTRAINT pk8 PRIMARY KEY(IdAcc)
);


CREATE table Empleado 
(
    IdEmp int,
    nomEmp varchar (25) NOT NULL,
    appEmp varchar (25) NOT NULL ,
    apmEmp varchar (25) NOT NULL,
    tipoEmp varchar (25) NOT NULL, /* Agregue tipo empleado */
    idUsu int NOT NULL UNIQUE,
    CONSTRAINT pk2 PRIMARY KEY (IdEmp),
    CONSTRAINT fk1 FOREIGN key (idUsu) REFERENCES usuario(IdUsu) ON DELETE NO ACTION ON UPDATE CASCADE,
    FULLTEXT INDEX BUSQUA_Empleado (appEmp(4) ASC,apmEmp(4) ASC)
);


create table Cliente 
(
    idCli int ,
    nomCli varchar (25) NOT NULL,
    apmCli varchar (25) NOT NULL,
    appCli varchar (25) NOT NULL,
    correoCli TEXT NOT NULL,
    telCli varchar (12), /* Se cambio de int a varchar */ 
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
   CONSTRAINT pk3 PRIMARY KEY(idCli),
   CONSTRAINT fk2 FOREIGN key (Usuario) REFERENCES  Usuario(idUsu) ON DELETE NO ACTION ON UPDATE CASCADE,
   INDEX IDX_MODULO_cpCli (cpCli),
   INDEX IDX_MODULO_telCli (telCli),
   FULLTEXT INDEX BUSQUA_CLIENTE (apmCli(5) ASC,appCli(5) ASC)

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
    FULLTEXT INDEX BUSQUA_Articulo (nomArt(5) ASC)

);

create table Inventario
(
    IdInv int,
    cantInv int(9) NOT NULL,
    idSuc int NOT NULL,
    IdArt int NOT NULL,
    CONSTRAINT pk6 PRIMARY KEY(IdInv),
    CONSTRAINT fk5 FOREIGN key (idSuc) REFERENCES Sucursal(IdSuc) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk6 FOREIGN key (IdArt) REFERENCES Articulo(IdArt) ON DELETE SET NULL ON UPDATE CASCADE

);


CREATE table Venta
(
   IdVent int,
   FolioVent int (10) NOT NULL,
   fechaFac date NOT NULL,
   montoVen float(10,2) NOT NULL,
   fechVent date NOT NULL,
   totalVent float (10,2) NOT NULL,
   IdCli int NOT NULL,
   CONSTRAINT pk4 PRIMARY KEY(IdVent),
   CONSTRAINT fk3 FOREIGN key (IdCli) REFERENCES  Cliente(idCli),
   UNIQUE INDEX IDX_MODULO_FolioVent (totalVent),
   INDEX IDX_MODULO_fechVent (fechVent)
);

create table Det_venta
(
   IdDetv int,
   cantDetv int (8) NOT NULL,
   SubDet float (10,2) NOT NULL,
   IdInv int NOT NULL,
   idVent int NOT NULL,
   CONSTRAINT pk5 PRIMARY KEY(IdDetv),
   CONSTRAINT fk4 FOREIGN key (IdInv) REFERENCES Inventario (IdInv) ON DELETE NO ACTION ON UPDATE CASCADE,
   CONSTRAINT fk7 FOREIGN key (idVent) REFERENCES Venta(idVent) ON DELETE NO ACTION ON UPDATE CASCADE

);

/*--------------------------------------------------------INDEX---------------------------------------------------------------------------------------------------------------------*/
                                            /*COMMENT "MODIFICACION DE INDEX"*/
    /*1*/
    drop INDEX BUSQUA_Sucursal on Sucursal;
    ALTER TABLE Sucursal ADD  FULLTEXT INDEX BUSQUA_Sucursal(nomSuc(5)asc,calleSuc(4) ASC,colSuc(4) ASC);
    /*2*/
    DROP INDEX IDX_MODULO_PassUs ON Usuario;
    ALTER TABLE Usuario ADD  UNIQUE INDEX IDX_MODULO_PassUs (PassUs);
    /*3*/
    DROP INDEX IDX_MODULO_FolioVent  ON Venta;
    ALTER TABLE Venta ADD  INDEX IDX_MODULO_FolioVent (FolioVent);
/*--------------------------------------------------------ELIMINACION---------------------------------------------------------------------------------------------------------------------*/
    /*1*/
    drop INDEX IDX_MODULO_fechVent on Venta;
    /*2*/
    drop INDEX IDX_MODULO_telCli on Cliente;
    /*3*/
    drop INDEX IDX_MODULO_edoSuc on Sucursal;
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------Trigger para generar usuario al insertar en Empleado---------------------------------------------------------------------------------------------------------------------*/
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

    INSERT INTO Usuario VALUES(idU, pass, correo);
END//
DELIMITER ;
/*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------Trigger para generar usuario al insertar en Cliente--------------------------------------------------------------------

DELIMITER //
CREATE TRIGGER dispUsuCli BEFORE INSERT ON Cliente
FOR EACH ROW
BEGIN
    DECLARE cont int;
    DECLARE idUC int;
    DECLARE contraseña varchar(15);
    DECLARE correo text;


    SET idUC = (SELECT MAX(idUsu) FROM Usuario);
    IF idUC is NULL THEN
    SET idUC = 1;
    ELSE 
    SET idUC = idUC +1;
    END IF;
    SET contraseña = (CONCAT(
        char(round(rand()*25)+97),
        char(round(rand()*25)+97),
        char(round(rand()*25)+97),
        char(round(rand()*25)+97),
        char(round(rand()*25)+65),
        char(round(rand()*25)+65),
        char(round(rand()*25)+97),
        char(round(rand()*25)+97),
        char(round(rand()*25)+65),
        char(round(rand()*25)+97),
        char(round(rand()*25)+97),
        char(round(rand()*25)+97),
        char(round(rand()*25)+65),
        char(round(rand()*25)+97),
        char(round(rand()*25)+65)
    )
    );
    SET correo =new.correoCli;

    SET cont= (SELECT COUNT(*) 
              FROM Usuario
              WHERE Usuario.CorreoUs like correo);

    
    IF cont like 0 THEN
    INSERT INTO Usuario VALUES(idUC, contraseña, correo);
    ELSE
    SET new.idCli=null;
   END IF;

END//
DELIMITER ;

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------Procedimiento para iniciar sesion---------------------------------------------------------------------------------------------------------------------*/
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
/* CALL procedimientoSesion('Jorge.Lopez@funko.com.mx', 'cxiwKMddJiqdShH', @valido); Llamar al procedimiento*/
/* SELECT @valido; Muestra 1 si es correcto el pass y correo o un 0 si no */

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
/*--------------------------------------------------------Procedimiento para agregar un producto---------------------------------------------------------------------------------------------------------------------*/
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
  
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
 INSERT INTO Sucursal VALUES    (1,"POS'S","De Jesus","De Jesus ",112,255,20367,"Aguascalientes","Aguascalientes"),
                                (2,"POS'S","San pedrito","De Jesus ",232,755,50357,"D.F","Acambay de Ruíz Castañeda"),
                                (3,"POS'S","Santa fe","San Martín",992,2574,76280,"QUÉRETARO","Corregidora"),
                                (4,"POS'S","CIPRES_II","Venustiano",881,785,29374,"CHIAPAS","Acala"),
                                (5,"POS'S","Valles de San Jose","Setiempre-12",123,785,55895,"D.F","Acolman"),
                                (6,"POS'S","Baja california","Condominios",1412,015,99786,"Monterrey","Benito Juárez"),
                                (7,"POS'S","Valles del tesoro","Predegal",332,705,80584,"Sinaloa","Badiraguato"),
                                (8,"POS'S","Corrigidora","Bulevares",512,035,23641,"Baja california sur","Comondú"),
                                (9,"POS'S","Sobrerete","Buenos aries",752,645,38507,"Guanajuato","Apaseo el Alto"),
                                (10,"POS'S","Benito Juarez","Salazar",712,125,50373,"D.F","Aculco");

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

/* SE ELIMINO INSERT INTO USUARIO, EL TRIGGER LO RELLENA SOLO */
         

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

INSERT into Categoria VALUES    (1,"TERROR"),
                                (2,"PEQUEÑOS"),
                                (3,"PELICULAS"),
                                (4,"ACCION"),
                                (5,"GRANDES"),
                                (6,"COLECIÓN");

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

INSERT INTO ACCESOS VALUES      (1,"htpp:www.paginapirncipal.com","paginapirncipal"),
                                (2,"htpp:www.admistracion.com","admistracion"),
                                (3,"htpp:www.carrito.com","carrito"),
                                (4,"htpp:www.pago.com","pago");

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/


INSERT INTO Empleado VALUES     (1, 'Jorge', 'Lopez', 'Silva', 'Administrador', 1),
                                (2, 'Juan', 'Garcia', 'YELDAI', 'Empleado', 2),
                                (3, 'Daniel', 'Torres', 'Silva','Administrador', 3),
                                (4, 'Brandon', 'Salazr', 'VICENTE', 'Empleado', 4),
                                (6, 'YULI', 'MESA', 'SilvaS','Administrador', 5),
                                (7, 'PEDOR', 'MARCOS', 'SALAZAR', 'Empleado', 7),
                                (8, 'CIRO', 'HERNANDEZ', 'SALAZAR', 'Empleado', 8),
                                (9, 'REBECA', 'VILLA', 'SALAZAR', 'Empleado', 9);

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
INSERT INTO Cliente VALUES 
                                (1, 'Javier', 'Torres', 'Suarez', 'javier@gmail.com', 44891211, 'WE1DET1112W', 'Queretaro', 'Calle uno', 'Colonia uno', 'Queretaro', 76148, 34, 10, 19990420, 1),
                                (3, 'Peter', 'Parker', 'Suarez', 'parker@gmail.com', 4422111, 'QW34FRFRVV33', 'Queretaro', 'Calle DOS', 'Colonia DOS', 'Queretaro', 7644148, 35, 11, 19990420, 2),
                                (4, 'Gustavo', 'Mesa', 'Salazar', 'Gustavo@gmail.com', 4491211, 'QWVVFDRTT133', 'Queretaro', 'Calle TRES', 'Colonia TRES', 'Queretaro', 76141128, 36, 12, 19990520, 3),
                                (5, 'Ciro', 'Garcia', 'Ramires', 'Ciro@gmail.com', 44244451, 'QW34FRTVBN', 'Queretaro', 'Calle CUATRO', 'Colonia CAUTRO', 'Queretaro', 7336148, 37, 13, 19990620, 4),
                                (6, 'Brandon', 'Silva', 'Ordulla', 'Brandon@gmail.com', 4423341, 'QW34RRFR33', 'Queretaro', 'Calle CINCO', 'Colonia CINCO', 'Queretaro', 123546148, 38, 14, 19990720, 5),
                                (7, 'Salvador', 'Parker', 'Suarez','Salvador@gmail.com', 447211, 'QW3BGGBBTT133', 'Queretaro', 'Calle SEIS', 'Colonia SEIS', 'Queretaro', 788148, 39, 15, 19990820, 6),
                                (8, 'Perrito', 'Parker', 'Suarez', 'Perrito@gmail.com', 44331211, 'QW34WERT', 'Queretaro', 'Calle SIETE', 'Colonia SIETE', 'Queretaro', 76111, 40, 16, 19990920,7),
                                (9, 'Yuli', 'Parker', 'Suarez', 'Yuli@gmail.com', 442482889, 'QW34FXSEDE3', 'Queretaro', 'Calle OCHO', 'Colonia OCHO', 'Queretaro', 761124, 41, 17, 19991020, 8),
                                (10, 'Villas', 'Parker', 'Rodriguez', 'Villas@gmail.com', 442484551, 'QW3DEDSSE133', 'Queretaro', 'Calle NUEVE', 'Colonia NUEVE', 'Queretaro', 76445, 42, 18, 19991120,9);

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

INSERT INTO Articulo VALUES
                                (1, 'Batman del futuro', 3939.99, 1000.00, 1),
                                (2, 'Superman del futuro', 799.99, 600.00, 2),
                                (3, 'Batman ', 999.99, 600.00, 3),
                                (4, 'Superman ', 399.99, 100.00, 4),
                                (5, 'Sony', 299.99, 200.00, 5),
                                (6, 'Hulk ', 199.99, 50.00, 1),
                                (7, 'Hulk del futuro', 299.99, 100.00, 1),
                                (8, 'Capitan america', 33.99, 10.00, 2),
                                (9, 'Capitan america 2', 789.99, 600.00, 5);

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

INSERT INTO Inventario VALUES
                                (1, 150, 1, 1),
                                (2, 200, 2, 3),
                                (3, 200, 3, 4),
                                (4, 200, 4, 2),
                                (5, 200, 4, 5),
                                (6, 200, 6, 6),
                                (7, 200, 7,7),
                                (8, 200, 8, 8),
                                (9, 15, 8, 9);
/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

INSERT INTO Venta VALUES  (1, 1,20200131,0.0,2020131,1,1);
INSERT INTO Venta VALUES  (2,2,20200603,0.0,20200603,0,2);
INSERT INTO Venta VALUES  (3,3,2020730,0.0,2020730,0,3);
INSERT INTO Venta VALUES  (4,4,20200830,0.0,20200830,0,4);
INSERT INTO Venta VALUES  (5,5,20200930,0.0,20200930,0,5);

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
INSERT INTO Det_venta VALUES (1, 0, 0, 1, 1),
                            (2, 0, 0, 3, 3),
                            (3, 0, 0, 4, 4),
                            (4, 0, 0, 5, 5);

/*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/




SELECT *,(CASE
 WHEN porcentaje < 0 THEN "perdida"
 WHEN porcentaje > 0 THEN "Hay Ganancias"
 WHEN porcentaje = 0 THEN "No hay ganancias" end) AS estatus

from 
(
SELECT cantInv as Cantidad,sum(cantInv * precArt) as Total_precArt,sum(cantInv * costoArt) as Total_Costo,
(sum(cantInv * precArt)-sum(cantInv * costoArt)) as Ganancia_Maxim,
((sum(cantInv * precArt)-sum(cantInv * costoArt))-((sum(cantInv * precArt)-sum(cantInv * costoArt))*0.5)) as porcentaje
from inventario
INNER join sucursal on(inventario.idSuc=sucursal.IdSuc)
inner join articulo on(inventario.IdArt=articulo.IdArt)
GROUP BY inventario.idInv,sucursal.idSuc
)as tabla1
WHERE tabla1.Ganancia_Maxim=
(
SELECT MAX(Ganancia_Maxim) as Ganancia_Maxim
from
(
SELECT sum(cantInv) as Cantidad,sum(cantInv * precArt) as Total_precArt,sum(cantInv * costoArt) as Total_Costo,
(sum(cantInv * precArt)-sum(cantInv * costoArt)) as Ganancia_Maxim
from inventario
INNER join sucursal on(inventario.idSuc=sucursal.IdSuc)
inner join articulo on(inventario.IdArt=articulo.IdArt)
GROUP BY inventario.idInv,sucursal.idSuc
)as tabla2
)
;
