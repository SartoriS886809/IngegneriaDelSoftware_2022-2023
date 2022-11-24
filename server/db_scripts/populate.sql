CREATE EXTENSION pgcrypto;

INSERT INTO neighborhoods VALUES (1, 'neigh1', 23.45);
INSERT INTO neighborhoods VALUES (2, 'neigh2', 57.95);
INSERT INTO neighborhoods VALUES (3, 'neigh3', 62.34);

INSERT INTO users VALUES ('email1@email.com', crypt('passpass', gen_salt('bf', 8)), 'username1', 'name1', 'lastname1', '2000-06-17', 'address1', 4, 'house type', 'token', 2);
INSERT INTO users VALUES ('email2@email.com', crypt('passpass', gen_salt('bf', 8)), 'username2', 'name2', 'lastname2', '2000-06-17', 'address2', 4, 'house type', 'token', 2);
INSERT INTO users VALUES ('email3@email.com', crypt('passpass', gen_salt('bf', 8)), 'username3', 'name3', 'lastname3', '2000-06-17', 'address3', 4, 'house type', 'token', 3);

INSERT INTO reports VALUES (1, 'title1', '2000-06-17', 'email1@email.com', 1, 'category', 'address');
INSERT INTO reports VALUES (2, 'title2', '2000-06-17', 'email1@email.com', 1, 'category', 'address');

INSERT INTO services VALUES (1, 'title1', '2000-06-17', 'email2@email.com', 'desc', 'link');
INSERT INTO services VALUES (2, 'title2', '2000-06-17', 'email3@email.com', 'desc', 'link');

INSERT INTO needs VALUES (1, 'title1', '2000-06-17', 'email3@email.com', 'email1@email.com', 'address', 'desc');
INSERT INTO needs VALUES (2, 'title2', '2000-06-17', 'email2@email.com', 'email1@email.com', 'address', 'desc');
