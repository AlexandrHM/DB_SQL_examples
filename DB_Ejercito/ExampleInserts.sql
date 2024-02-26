/*Insert en las tablas*/
INSERT INTO cuerpos values (10, 'Infanteria');
INSERT INTO cuerpos values (20, 'Artilleria');
INSERT INTO cuerpos values (30, 'Armada');
INSERT INTO cuerpos values (40, 'Caballeria');
INSERT INTO cuerpos values (50, 'Marina');

INSERT INTO servicios values (1, 'Guardia');
INSERT INTO servicios values (2, 'Cuartelero');
INSERT INTO servicios values (3, 'Instructor');
INSERT INTO servicios values (4, 'Conductor');
INSERT INTO servicios values (5, 'Comunicacion');

INSERT INTO companias values (11, 'Comp_Reconocimiento');
INSERT INTO companias values (22, 'Comp_Transporte');
INSERT INTO companias values (33, 'Comp_Inteligencia');
INSERT INTO companias values (44, 'Comp_Ope_Especiales');
INSERT INTO companias values (55, 'Comp_Ingenieria');

INSERT INTO cuarteles values (1, 11, 'Crtl_sur', 'zonasur');
INSERT INTO cuarteles values (2, 22, 'Crtl_norte', 'zona_norte');
INSERT INTO cuarteles values (3, 33, 'Crtl_este', 'zona_este');
INSERT INTO cuarteles values (4, 44, 'Crtl_oeste', 'zona_oeste');

INSERT INTO soldados values (110, 'Alejandro', 'García', 'Soldado', 10, 1, 11);
INSERT INTO soldados values (120, 'Juan ', 'Martínez', 'Cabo', 20, 2, 22);
INSERT INTO soldados values (130, 'Manuel', 'Hernandez', 'Sargento', 30, 3, 33);
INSERT INTO soldados values (140, 'Miguel', 'Lopez', 'Oficial', 40, 4, 44);
INSERT INTO soldados values (150, 'Luis', 'Rodriguez', 'General', 50, 4, 55);

INSERT INTO serv_realz values (1, 110, '2024-02-24');	
INSERT INTO serv_realz values (2, 120, '2024-02-23');
INSERT INTO serv_realz values (3, 130, '2024-02-22');
INSERT INTO serv_realz values (4, 140, '2024-02-21');
INSERT INTO serv_realz values (5, 150, '2024-02-20');

INSERT INTO serv_realz values (5, 110, '2024-02-19');	
INSERT INTO serv_realz values (5, 120, '2024-02-18');
INSERT INTO serv_realz values (4, 110, '2024-02-17');
INSERT INTO serv_realz values (4, 120, '2024-02-16');
INSERT INTO serv_realz values (3, 110, '2024-02-15');

/*Todos los datos que aparecen aquí son ficticios y no estan relacionados
a personas en la vida real, cual parecido es mera coincidencia ||
All data appearing here is fictional and unrelated to real-life individuals,
any resemblance is purely coincidental*/
