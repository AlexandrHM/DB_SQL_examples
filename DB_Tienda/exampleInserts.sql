/*Inserts de la tabla*/

insert into articulos (nom_art,tipo,stock,pre_comp) values('bebidaX 600ml', 'refresco', 10,12.5);
insert into articulos (nom_art,tipo,stock,pre_comp) values('bebidaY 1lt', 'refresco', 15,20);
insert into articulos (nom_art,tipo,stock,pre_comp) values('bebidaZ 3lt', 'refresco', 20,25);

insert into articulos (nom_art,tipo,stock,pre_comp) values('Roles', 'pan', 5,28);
insert into articulos (nom_art,tipo,stock,pre_comp) values('Conchas', 'pan', 10,14);
insert into articulos (nom_art,tipo,stock,pre_comp) values('Mantecadas', 'pan', 15,18.5);

insert into articulos (nom_art,tipo,stock,pre_comp) values('cigarroX', 'cigarros', 3,80);
insert into articulos (nom_art,tipo,stock,pre_comp) values('cigarroY', 'cigarros', 6,70);
insert into articulos (nom_art,tipo,stock,pre_comp) values('cigarroZ', 'cirgarros', 9,65);

insert into articulos (nom_art,tipo,stock,pre_comp) values('dulceX', 'dulces', 4,5.5);
insert into articulos (nom_art,tipo,stock,pre_comp) values('dulceY', 'dulces', 8,7.5);
insert into articulos (nom_art,tipo,stock,pre_comp) values('dulceZ', 'dulces', 12,10);

insert into articulos (nom_art,tipo,stock,pre_comp) values('galletaX', 'galletas', 2,13.5);
insert into articulos (nom_art,tipo,stock,pre_comp) values('galletaY', 'galletas', 4,16);
insert into articulos (nom_art,tipo,stock,pre_comp) values('galletaZ', 'galletas', 6,10.5);


INSERT INTO det_cat (nomb_catg, porc_ganancia) VALUES('refresco', 0.30);
INSERT INTO det_cat (nomb_catg, porc_ganancia) VALUES('galleta', 0.20);
INSERT INTO det_cat (nomb_catg, porc_ganancia) VALUES('pan', 0.50);
INSERT INTO det_cat (nomb_catg, porc_ganancia) VALUES('cigarros', 0.30);
INSERT INTO det_cat (nomb_catg, porc_ganancia) VALUES('dulces', 0.50);
