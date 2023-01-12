CREATE EXTENSION pgcrypto;

INSERT INTO users VALUES ('mdr@gmail.com', crypt('passpass', gen_salt('bf', 8)), 'mdr', 'Mattia', 'Dei Rossi', '1998-11-02', 'Corte dei Cordami, Giudecca', 1, 'Casa singola', 'token1', 7);
INSERT INTO users VALUES ('ec@gmail.com', crypt('passpass', gen_salt('bf', 8)), 'ec', 'Edoardo', 'Cecchinato', '2000-03-01', 'Corte dei Cordami, Giudecca', 1, 'Casa singola', 'token2', 7);
INSERT INTO users VALUES ('adl@gmail.com', crypt('passpass', gen_salt('bf', 8)), 'adl', 'Andrea', 'Da Lio', '2001-08-31', 'Junghas, Giudecca', 2, 'Appartamento', 'token3', 7);
INSERT INTO users VALUES ('ss@gmail.com', crypt('passpass', gen_salt('bf', 8)), 'ss', 'Sebastiano', 'Sartori', '2002-01-05', 'Junghas, Giudecca', 2, 'Appartamento', 'token4', 7);
INSERT INTO users VALUES ('gb@gmail.com', crypt('passpass', gen_salt('bf', 8)), 'gb', 'Giovanni', 'Berto', '2001-09-23', 'Junghas, Giudecca', 2, 'Appartamento', 'token5', 7);

INSERT INTO users VALUES ('mr@gmail.com', crypt('passpass', gen_salt('bf', 8)), 'mr', 'Mario', 'Rossi', '2002-01-05', 'Calle del Vento, Dorsoduro', 3, 'Appartamento', 'token6', 2);
INSERT INTO users VALUES ('gg@gmail.com', crypt('passpass', gen_salt('bf', 8)), 'gb', 'Giacomo', 'Giusti', '2001-09-23', 'Calle del Vento, Dorsoduro', 3, 'Appartamento', 'token7', 2);

INSERT INTO reports VALUES (1000, 'Incendio', '2023-01-02', 'mdr@gmail.com', 3, 'problemi ambientali', 'Calle del forno');
INSERT INTO reports VALUES (2000, 'Furto', '2023-01-02', 'ec@gmail.com', 3, 'crimine', 'Calle Ariani');
INSERT INTO reports VALUES (3000, 'Incidente', '2023-01-02', 'adl@gmail.com', 2, 'incidente stradale', 'Calle Lardoni');
INSERT INTO reports VALUES (4000, 'Strada ghiacciata', '2023-01-02', 'ss@gmail.com', 2, 'problemi ambientali', 'Fondamenta Pescheria');
INSERT INTO reports VALUES (5000, 'Albero caduto', '2023-01-02', 'gb@gmail.com', 2, 'problemi ambientali', 'Fondamenta Pescheria');

INSERT INTO services VALUES (1000, 'Ripetizioni', '2023-01-02', 'mdr@gmail.com', 'Offro ripetizioni di Inglese e Matematica', '');
INSERT INTO services VALUES (2000, 'Spesa', '2023-01-02', 'ec@gmail.com', 'Offro aiuto per comprare e portare a casa prodotti dal supermercato', '');
INSERT INTO services VALUES (3000, 'Trasloco', '2023-01-02', 'adl@gmail.com', 'Offro aiuto per trasportare mobili', '');
INSERT INTO services VALUES (4000, 'Pedibus', '2023-01-02', 'ss@gmail.com', 'Offro servizio di pedibus', '');
INSERT INTO services VALUES (5000, 'BabySitter', '2023-01-02', 'gb@gmail.com', 'Offro disponibilità come baby sitter a tempo pieno', '');

INSERT INTO needs VALUES (1000, 'Martello', '2023-01-02', Null, 'mdr@gmail.com', 'Calle del forno', 'Necessito di un martello non appena disponibile per faccende domestiche');
INSERT INTO needs VALUES (2000, 'Accompagnare figlio a scuola', '2023-01-02', Null, 'ec@gmail.com', 'Calle Ariani', 'Cerco una persona disponibile ad accompagnare mio figlio a scuola la mattina del 20/01');
INSERT INTO needs VALUES (3000, 'Tagliaerba', '2023-01-02', Null, 'adl@gmail.com', 'Calle Lardoni', 'Necessito di un tagliaerba non appena disponibile per faccende domestiche');
INSERT INTO needs VALUES (4000, 'Compagnia', '2023-01-02', 'ec@gmail.com', 'ss@gmail.com', 'Fondamenta Pescheria', 'Necessito di compagnia per qualche pomeriggio');
INSERT INTO needs VALUES (5000, 'Spesa', '2023-01-02', 'adl@gmail.com', 'gb@gmail.com', 'Fondamenta Pescheria', 'Necessito di due baguette per stasera');
