/*Nombre de la base de datos*/
CREATE DATABASE ejercito;
/*Creacion de las tablas*/
CREATE TABLE serv_realz(
id_serv_fk INTEGER REFERENCES servicios(id_serv),
id_sol_fk INTEGER REFERENCES soldados(id_sol),
fecha_realn date NOT NULL
);

CREATE TABLE soldados (
id_sol INTEGER PRIMARY KEY,
nombre_sol VARCHAR(30) NOT NULL,
ape_sol VARCHAR(30) NOT NULL,
grado_sol VARCHAR(15) DEFAULT 'Sin_asignar',
id_crpo_fk INTEGER,
cod_crtl_fk INTEGER,
id_comp_fk INTEGER,
CONSTRAINT id_crp_fk FOREIGN KEY (id_crpo_fk) REFERENCES cuerpos(id_crpo),
CONSTRAINT id_comp_fk FOREIGN KEY (id_comp_fk) REFERENCES companias(id_comp),
CONSTRAINT cod_crtl_fk FOREIGN KEY (cod_crtl_fk) REFERENCES cuarteles(cod_crtl)
);

CREATE TABLE cuarteles (
cod_crtl INTEGER PRIMARY KEY,
id_comp_fk serial REFERENCES companias(id_comp),
nom_crtl VARCHAR(15) NOT NULL,
ubi_crtl VARCHAR(20) DEFAULT 'No_asignado'
);

CREATE TABLE companias (
id_comp INTEGER PRIMARY KEY,
act_comp VARCHAR(20) UNIQUE
);

CREATE TABLE servicios (
id_serv INTEGER PRIMARY KEY,
actividad VARCHAR(15) NOT NULL
);

CREATE TABLE cuerpos (
id_crpo INTEGER PRIMARY KEY,
deno_crpo VARCHAR(15) UNIQUE
);