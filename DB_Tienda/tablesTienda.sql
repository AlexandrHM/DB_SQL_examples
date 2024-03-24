create table articulos(
    item_id serial PRIMARY KEY,
    nom_art varchar(30) not null,
    tipo varchar(30) not null,
    stock int not null,
    pre_comp numeric(7,2) not null,
    pre_vnta numeric(7,2)	
);
/*Creamos la tabla detalle*/
CREATE TABLE det_cat (
    id_catg serial PRIMARY KEY,
    nomb_catg varchar(30) NOT NULL,
    porc_ganancia numeric(5,2) NOT NULL
);





