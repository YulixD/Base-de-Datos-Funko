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
    INDEX IDX_MODULO_edoSuc (edoSuc)

);

INSERT INTO Sucursal VALUES
(1, "Sucursal1", "calle", "colonia", 1, 1, 76148, "estado", "municipio"),
(2, "Sucursal2", "calle", "colonia", 1, 1, 76148, "estado", "municipio");




create table Usuario 
(
    IdUsu int,                                    
    PassUs varchar(32) NOT NULL,
    CorreoUs varchar(35) NOT NULL, 
    CONSTRAINT pk1 PRIMARY key (IdUsu),
    INDEX IDX_MODULO_PassUs (PassUs)
);

INSERT INTO Usuario VALUES
(1, "pass", "correo");

create table Categoria 
(
    IdCat int,
    nomCat varchar (25) NOT NULL UNIQUE,
    CONSTRAINT pk8 PRIMARY KEY(IdCat)
);

INSERT INTO Categoria VALUES
(1, "Categoria1");


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
    tipoEmp varchar (25) NOT NULL, 
    idUsu int NOT NULL UNIQUE,
    CONSTRAINT pk2 PRIMARY KEY (IdEmp),
    CONSTRAINT fk1 FOREIGN key (idUsu) REFERENCES usuario(IdUsu) ON DELETE NO ACTION ON UPDATE CASCADE
);


create table Cliente 
(
    idCli int ,
    nomCli varchar (25) NOT NULL,
    apmCli varchar (25) NOT NULL,
    appCli varchar (25) NOT NULL,
    correoCli TEXT NOT NULL,
    passCli varchar(12) NOT NULL,
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
   CONSTRAINT pk3 PRIMARY KEY(idCli),
   CONSTRAINT fk2 FOREIGN key (Usuario) REFERENCES  Usuario(idUsu) ON DELETE NO ACTION ON UPDATE CASCADE,
   INDEX IDX_MODULO_cpCli (cpCli),
   INDEX IDX_MODULO_telCli (telCli)

);

INSERT INTO Cliente VALUES
(1, "Cliente1", "apellido", "apellido2", "correo", "4424878733", "RFC", "muni", "calle", "col", "edo", "cp", 1, 1, 20200607, 1);

create table Articulo 
(
    IdArt int,
    nomArt varchar (25) NOT NULL UNIQUE,
    precArt float (10,2) NOT NULL DEFAULT 0,
    costoArt float (10,2) NOT NULL DEFAULT 0,
    IdCat int,
    CONSTRAINT pk10 PRIMARY KEY(IdArt),
    CONSTRAINT fk10 FOREIGN key (IdCat) REFERENCES Categoria(IdCat) ON DELETE SET NULL ON UPDATE CASCADE

);

INSERT INTO Articulo VALUES
(1, "Funko1", 100, 50, 1),
(2, "Funko2", 200, 100, 1);

create table Inventario
(
    idSuc int NOT NULL,
    IdArt int NOT NULL,
    cantInv int(9) NOT NULL,
    CONSTRAINT pk6 PRIMARY KEY(IdSuc, idArt),
    CONSTRAINT fk5 FOREIGN key (idSuc) REFERENCES Sucursal(IdSuc) ON DELETE NO ACTION ON UPDATE CASCADE,
    CONSTRAINT fk6 FOREIGN key (IdArt) REFERENCES Articulo(IdArt) ON DELETE NO ACTION ON UPDATE CASCADE

);

INSERT INTO Inventario VALUES
(1, 1, 100),
(1, 2, 100),
(2, 1, 100),
(2, 2, 100);


CREATE table Venta
(
   IdVent int,
   IdCli int NOT NULL,
   folioVent int (10) NOT NULL,
   fechaFac date NOT NULL,
   fechVent date NOT NULL,
   totalVent float (10,2) NOT NULL,
   CONSTRAINT pk4 PRIMARY KEY(IdVent),
   CONSTRAINT fk3 FOREIGN key (IdCli) REFERENCES  Cliente(idCli),
   /*UNIQUE INDEX IDX_MODULO_FolioVent (totalVent), */
   INDEX IDX_MODULO_fechVent (fechVent)
);

INSERT INTO Venta VALUES
(1, 1, 1000000, 20200607, 20200607, 1),
(2, 1, 1000000, 20200607, 20200607, 0);

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

/*------------------------Trigger que resta al inventario, calcula subtotal, actualiza el total de venta----------------------------------*/
DROP TRIGGER IF EXISTS disparadorInven;
DELIMITER //
CREATE TRIGGER disparadorInven BEFORE INSERT ON Det_venta
FOR EACH ROW
BEGIN
    DECLARE cantidad INT;
    DECLARE total FLOAT;

    SET cantidad = (SELECT cantInv FROM Inventario WHERE idArt = new.idArt AND idSuc = new.idSuc);
    SET total = (SELECT totalVent FROM Venta WHERE idVent = new.idVent);
    IF new.cantDetv <= cantidad THEN
        UPDATE Inventario SET cantInv = cantidad - new.cantDetv WHERE idSuc = new.idSuc AND idArt = new.idArt;
        SET new.SubDet = new.cantDetv * (SELECT precArt FROM Articulo WHERE idArt = new.idArt);
        UPDATE Venta SET totalVent = total + new.SubDet WHERE idVent = new.idVent;
    ELSE
        SET new.idDetv = NULL;
    END IF;
END//
DELIMITER ;
/*-----------------------------------------------------------------------------------------------------------------------------------------*/

INSERT INTO Det_venta VALUES
(1, 5, 1, 1, 1, 1000),
(2, 5, 1, 2, 1, 1000),
(3, 5, 2, 1, 2, 1000),
(4, 5, 2, 2, 2, 1000);

SELECT *, SUM(SubDet) as t FROM Det_Venta
GROUP BY idArt ORDER BY t DESC LIMIT 1;


