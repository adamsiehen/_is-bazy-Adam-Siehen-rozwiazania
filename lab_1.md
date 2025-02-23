#Lab1

```sql
-- Zadanie 1

-- Stwórz tabelę o nazwie pracownik z kolumnami:

--     id - liczba, autonumer, klucz główny
--     imie - tekst, max. 50 znaków, niepusty
--     nazwisko - tekst, max. 100 znaków, niepusty
--     data_urodzenia - typ daty
--     stanowisko - typ wyliczeniowy, dostępne wartości (sprzedawca, magazynier, księgowa)
#CTRL + / komentuje

create table pracownik (
	id int auto_increment primary key,
    imie varchar(50) not null,
    nazwisko varchar(100) not null,
    data_urodzenia date,
    stanowisko enum('sprzedawca', 'magazynier', 'księgowa')
);

describe pracownik;
show create table pracownik;

-- Zadanie 2

-- Wstaw do tabeli pracownik trzy rekordy z różnymi wartościami.

insert into pracownik values
(default, 'Jan', 'Kowalski', '1990-10-10', 'magazynier'),
(default, 'Janina', 'Kowalska', '1995-10-10', 'sprzedawca'),
(default, 'Jan', 'Nowak', '2000-10-10', 'księgowa');


select * from pracownik;

-- Zadanie 3

-- Stwórz tabelę dzial z kolumnami:

--     id - liczba, autonumer, klucz główny
--     nazwa - tekst, max. 255 znaków

create table dzial (
	id int auto_increment primary key,
    nazwa varchar(255) not null
);

-- Zadanie 4

-- Dodaj trzy działy do tabeli dzial:

--     sprzedaz
--     księgowość
--     magazyn

insert into dzial values
(default, 'sprzedaż'),
(default, 'księgowość'),
(default, 'magazyn');

select * from dzial;

-- Zadanie 5

-- Ustaw wartość domyślną kolumny stanowisko w tabeli pracownik na 'sprzedawca'.

ALTER TABLE pracownik ALTER COLUMN stanowisko SET DEFAULT 'sprzedawca';

-- Zadanie 6

-- Dodaj do tabeli pracownik kolumnę pensja jako liczba zmiennoprzecinkowa (float) 
-- z 5 miejscami całkowitymi i 2 dziesiętnymi. Uzupełnij kolumnę wartościami.
#modyfikacja struktury (podjezyk DDL)
alter table pracownik add column pensja decimal(7,2);

update pracownik set pensja = 5999.99;

-- Zadanie 7

-- Zmień w tabeli dzial nazwę kolumny nazwa na nazwa_dzialu, id na id_dzialu, w tabeli pracownik kolumnę id na id_pracownika.

ALTER TABLE dzial
RENAME COLUMN dzial TO nazwa_dzialu,
RENAME COLUMN id TO id_dzialu;

alter table pracownik
rename column id to id_pracownika;

-- Zadanie 8

-- Usuń z tabeli pracownik pracownika o najwyższej wartości pola id_pracownika.

DELETE FROM pracownik
WHERE id_pracownika = (
    SELECT id FROM (SELECT MAX(id_pracownika) AS id FROM pracownik) AS temp
);

select * from pracownik;


##Druga część

create table uczelnia (
id int auto_increment primary key,
nazwa varchar(400)
);

create table student(
indeks varchar(10) primary key,
imie tinytext, nazwisko tinytext,
uczelnia int,
FOREIGN KEY (uczelnia) REFERENCES uczelnia(id)
);

describe uczelnia;
desc student;

show create table student;

select * from uczelnia;

-- Zadanie 1
-- Do tabeli pracownik dodaj kolumnę dzial i ustaw ją jako klucz obcy do tabeli dzial. 
-- Usuwanie rekordów potomnych powinno być uniemożliwione. 
-- Sprawdź czy mechanizm spójności działa. Przypisz pracowników do działów.
ALTER TABLE pracownik
ADD COLUMN dzial INT;

ALTER TABLE pracownik
ADD CONSTRAINT fk_pracownik_dzial FOREIGN KEY (dzial)
REFERENCES dzial(id)
ON DELETE RESTRICT; 

DESCRIBE pracownik;

UPDATE pracownik SET dzial = 1 WHERE id_pracownika IN (1, 2);

DELETE FROM dzial WHERE id = 1;

SELECT * FROM pracownik;


-- Zadanie 2
-- Utwórz tabelę stanowisko z kolumnami id_stanowiska (klucz główny) oraz nazwa_stanowiska. 
-- Dodaj rekordy, które będą zawierały wartości z tabeli pracownik i kolumny stanowisko.

create table stanowisko(
id_stanowiska int primary key auto_increment,
nazwa_stanowiska varchar(100)
);

insert into stanowisko values
(default, 'sprzedaż'),
(default, 'księgowość'),
(default, 'magazyn');

select * from stanowisko;

-- Zadanie 3
-- Zmień definicję kolumny stanowisko tak aby była kluczem obcym do tabeli stanowisko. 
-- Ustaw pracownikom wartość w tej kolumnie tak, żeby odzwierciedlała wcześniejszą wartość tekstową.

select * from pracownik;
# dodamy kolumnę, która docelowo zostanie kolumną stanowisko
# aby nie utracić danych z bieżącej kolumny stanowisko

alter table pracownik add stanowisko_temp int;
alter table pracownik add foreign key (stanowisko_temp) references stanowisko(id_stanowiska);

desc pracownik;

# uzupełnie danymi zgodnie z poprzednimi wartościami w kolumnie stanowisko
update pracownik set stanowisko_temp=3 where stanowisko = 'magazynier';
update pracownik set stanowisko_temp=1 where stanowisko = 'sprzedawca';
update pracownik set stanowisko_temp=2 where stanowisko = 'księgowa';

alter table pracownik drop column stanowisko;
alter table pracownik rename column stanowisko_temp to stanowisko;

-- Zadanie 4
-- Zmień definicję klucza obcego w tabeli pracownik w kolumnie dzial tak, 
-- aby przy usunięciu działu z tabeli dzial wstawiana była wartość NULL w kolumnie dzial tabeli pracownik.

#modyfikacja definicji klucza obcego na kolumnie dzial tak, aby dodac on delete set null

alter table pracownik drop foreign key `pracownik_ibfk_1`;

-- Dodanie nowego klucza obcego z akcją ON DELETE SET NULL
alter table pracownik 
add foreign key (dzial) references dzial(id)
on delete set null;

show create table pracownik;

```
