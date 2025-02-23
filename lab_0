#Lab_0

'''sql
create table osoba (id int);
select * from osoba;
describe osoba;
# lub
desc osoba;

select * from is_siehena.osoba;

desc is_siehena.osoba;

drop table osoba;
create table osoba (id int, plec enum('K','M') default 'K');

show create table osoba;


CREATE TABLE osoba (id INT AUTO_INCREMENT PRIMARY KEY, imie TINYTEXT NOT NULL, nazwisko TINYTEXT NOT NULL, wiek INT(3));

INSERT INTO osoba VALUES(default, 'Jan', 'Kowalski', 35);

INSERT INTO osoba VALUES
    (default, 'Jan', 'Kowalski', 35),
    (default, 'Marian', 'Bąbel', 55),
    (default, 'Alina', 'Kamińska', 44);
    
 
 update osoba set wiek=56 where nazwisko='Kowalski';
 
 
ALTER TABLE osoba ADD COLUMN data_urodzenia DATE AFTER wiek;
ALTER TABLE osoba ADD COLUMN data_urodzenia DATE FIRST wiek;
'''
