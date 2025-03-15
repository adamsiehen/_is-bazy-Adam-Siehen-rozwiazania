-- Lab 2

select * from pracownik;

select imie, nazwisko from pracownik where pensja < 6000;
select imie, nazwisko from pracownik where imie >= 'Jan';

select imie, nazwisko from pracownik where imie != 'Piotr';

describe pracownik;

alter table pracownik modify nazwisko varchar(100);

insert into pracownik values(default,'Gabriela',null,'2000-10-10',6999,1,1);

# porównanie wartości
select imie, nazwisko from pracownik where nazwisko = null;

# porównanie tożsamości (typ obiektu)
select imie, nazwisko from pracownik where nazwisko is null;

SELECT imie, nazwisko FROM pracownik ORDER BY nazwisko ASC;

SELECT imie, nazwisko FROM pracownik ORDER BY nazwisko ASC;
SELECT imie, nazwisko FROM pracownik ORDER BY 2 ASC;
# domyślnie ASC
SELECT imie, nazwisko FROM pracownik ORDER BY 2;
SELECT imie, nazwisko FROM pracownik ORDER BY 2 DESC;

SELECT imie, nazwisko FROM pracownik
WHERE imie LIKE 'A%' ORDER BY nazwisko ASC LIMIT 5;

# pobieramy imiona rozpoczynające się od litery 'A'
SELECT imie from pracownik WHERE imie LIKE 'A%';

# lub takie, które od 'A' się nie rozpoczynają
SELECT imie from pracownik WHERE imie NOT LIKE 'A%';

# imiona zawierające literę 'a'
SELECT imie from pracownik WHERE imie LIKE '%a%';

# imiona rozpoczynające się na literę 'A' mające dokładnie 4 znaki
SELECT imie from pracownik WHERE imie LIKE 'A___';

#Wyrażenia regularne
SELECT imie, nazwisko FROM pracownik 
WHERE imie regexp '^J' ORDER BY nazwisko ASC LIMIT 5;

#Kończy się na ski
SELECT imie, nazwisko FROM pracownik 
WHERE nazwisko regexp 'ski$' ORDER BY nazwisko ASC LIMIT 5;

#To zapytanie nie przenosi nam kluczy i autoinkrementacji ale pobiera dane
CREATE TABLE pracownik_kopia SELECT * FROM pracownik;

select * from pracownik_kopia;
describe pracownik_kopia;
describe pracownik;
describe pracownik_kopia_2;

#Tu klucze są ale nie ma danych
CREATE TABLE pracownik_kopia_2 like pracownik;

select * from pracownik_kopia;
select * from pracownik_kopia_2;

# Część 1
# Zadanie 1
select nazwisko from pracownik order by nazwisko ASC;

# Zadanie 2
-- Z tabeli pracownik wyświetl imie, nazwisko, pensję dla pracowników urodzonych po roku 1979.
select
	imie
	,nazwisko
	,pensja
    ,data_urodzenia
from pracownik
where year(data_urodzenia) > 1979
;
# Zadanie 3
-- Z tabeli pracownik wyświetl wszystkie informacje dla pracowników z pensją pomiędzy 3500 a 5000.
SELECT * 
FROM pracownik 
WHERE pensja BETWEEN 3500 AND 5000;

# Zadanie 4
-- Z tabeli stan_magazynowy wyświetl towary, których ilość jest większa niż 10.
select * from stan_magazynowy where ilosc > 10;

# Zadanie 5
-- Z tabeli towar wyświetl wszystkie towary, których nazwa zaczyna się od A, B lub C.
SELECT * FROM towar WHERE nazwa_towaru REGEXP '^[ABC]';

# Zadanie 6
-- Z tabeli klient wyświetl wszystkich klientów indywidualnych (nie firmy).
select * from klient where czy_firma = 0;

# ograniczenie do 5 elemtów
select * from zamowienie limit 5;
# wykorzystywanie do paginacji
select * from zamowienie limit 10, 5;

create table is_siehena.nowa_tabela as select * from zamowienie;
select * from is_siehena.nowa_tabela;

# Zadanie 7
-- Z tabeli zamowienie wyświetl 10 najnowszych zamówień.
select * from zamowienie order by data_zamowienia DESC limit 10;

# Zadanie 8
-- Z tabeli pracownik wyświetl 5 najmniej zarabiających pracowników.
select * from pracownik order by pensja ASC limit 5;

# Zadanie 9
-- Z tabeli towar wyświetl 10 najdroższych towarów, których nazwa nie zawiera litery 'a'.
SELECT * 
FROM towar 
WHERE nazwa_towaru NOT LIKE '%a%' 
ORDER BY cena_zakupu DESC 
LIMIT 10;

# Zadanie 10
-- Z tabeli towar wyświetl towar, których jednostka miary to 'szt', posortuj po nazwie (ad A do Z) następnie po cenie zakupu malejąco.
SELECT towar.nazwa_towaru, towar.cena_zakupu 
FROM towar
JOIN stan_magazynowy ON towar.id_towaru = stan_magazynowy.towar
JOIN jednostka_miary ON stan_magazynowy.jm = jednostka_miary.id_jednostki
WHERE jednostka_miary.nazwa = 'szt'
ORDER BY towar.nazwa_towaru ASC, towar.cena_zakupu DESC;

# Zadanie 11
-- Stwórz nową tabelę o nazwie towary_powyzej_100, do której wstaw towary, których cena jest większa równa 100. Użyj CREATE ... SELECT.
create table is_siehena.towary_powyzej_100 as select * FROM towar where towar.cena_zakupu > 100;

# Zadanie 12
-- Stwórz nową tabelę o nazwie pracownik_50_plus na podstawie tabeli pracownik z wykorzystaniem LIKE. Wstaw do tej tabeli 
-- wszystkie rekordy z tabeli pracownik gdzie wiek pracownika jest większy równy 50 lat.
CREATE TABLE is_siehena.pracownik_50_plus AS
SELECT * 
FROM pracownik 
WHERE data_urodzenia <= DATE_SUB(CURDATE(), INTERVAL 50 YEAR);

-- Przykłady:
SELECT imie, nazwisko, nazwa FROM pracownik INNER JOIN dzial ON dzial.id_dzialu=pracownik.dzial;

SELECT imie, nazwisko FROM pracownik LEFT JOIN zamowienie ON pracownik.id_pracownika=zamowienie.pracownik_id_pracownika WHERE pracownik_id_pracownika is NULL;


SELECT imie, nazwisko, pracownik_id_pracownika FROM pracownik LEFT JOIN zamowienie ON pracownik.id_pracownika=zamowienie.pracownik_id_pracownika;

SELECT imie, nazwisko FROM pracownik WHERE id_pracownika IN (2,3,4);

SELECT imie, nazwisko FROM pracownik WHERE id_pracownika IN (SELECT pracownik_id_pracownika FROM zamowienie);

SELECT imie, nazwisko FROM pracownik WHERE id_pracownika NOT IN (SELECT pracownik_id_pracownika FROM zamowienie);

# Część 2
# Zadanie 1
-- Wyświetl imie, nazwisko i nazwę działu każdego pracownika.
select
imie
,nazwisko
,nazwa
from pracownik p
join dzial d on p.dzial = d.id_dzialu;

select * from typ_adresu;
select * from adres_klienta;

# Zadanie 2
-- Wyświetl nazwę towaru, nazwę kategorii oraz ilość towaru i posortuj dane po kolumnie ilość malejąco.
SELECT t.nazwa_towaru, k.nazwa_kategori, s.ilosc
FROM towar t
JOIN kategoria k ON t.kategoria = k.id_kategori
JOIN stan_magazynowy s ON t.id_towaru = s.towar
ORDER BY s.ilosc DESC;

# Zadanie 3
-- Wyświetl wszystkie anulowane zamówienia.
SELECT * 
FROM zamowienie z
JOIN status_zamowienia sz ON z.status_zamowienia = sz.id_statusu_zamowienia
WHERE sz.nazwa_statusu_zamowienia = 'Anulowane';

# Zadanie 4
-- Wyświetl wszystkich klientów, których adres podstawowy znajduje się w miejscowości Olsztyn.
select *
from klient k
join adres_klienta ak on k.id_klienta = ak.klient
join typ_adresu ta on ak.typ_adresu = ta.id_typu
where ta.nazwa = 'podstawowy' and ak.miejscowosc = 'Olsztyn';

# Zadanie 5
-- Wyświetl wszystkie nazwy jednostek miary, które nie zostały nigdy wykorzystane w tabeli stan_magazynowy.
SELECT jm.nazwa
FROM jednostka_miary jm
LEFT JOIN stan_magazynowy sm ON jm.id_jednostki = sm.jm
WHERE sm.jm IS NULL;

# Zadanie 6
-- Wyświetl numer zamówienia, nazwę towaru, ilosc i cenę dla zamówień złożonych w 2018 roku.
SELECT z.numer_zamowienia, t.nazwa_towaru, pz.ilosc, pz.cena
FROM pozycja_zamowienia pz
JOIN zamowienie z ON pz.zamowienie = z.id_zamowienia
JOIN towar t ON pz.towar = t.id_towaru
WHERE YEAR(z.data_zamowienia) = 2018;

# Zadanie 7
-- Stwórz nową tabelę o nazwie towary_full_info, w której znajdą się kolumny nazwa_towaru, 
-- cena_zakupu, kategoria(nazwa),ilosc , jednostka miary(nazwa).
CREATE TABLE is_siehena.towary_full_info AS
SELECT t.nazwa_towaru, t.cena_zakupu, k.nazwa_kategori, s.ilosc, jm.nazwa AS jednostka_miary
FROM towar t
JOIN kategoria k ON t.kategoria = k.id_kategori
JOIN stan_magazynowy s ON t.id_towaru = s.towar
JOIN jednostka_miary jm ON s.jm = jm.id_jednostki;

# Zadanie 8
-- Wyświetl pozycje zamówień dla 5 najstarszych zamówień.
SELECT pz.*
FROM pozycja_zamowienia pz
JOIN zamowienie z ON pz.zamowienie = z.id_zamowienia
ORDER BY z.data_zamowienia ASC
LIMIT 5;

# Zadanie 9
-- Wyświetl wszystkie zamówienia, które mają status inny niż zrealizowane.
SELECT * 
FROM zamowienie z
JOIN status_zamowienia sz ON z.status_zamowienia = sz.id_statusu_zamowienia
WHERE sz.nazwa_statusu_zamowienia <> 'Zrealizowane';


# Zadanie 10
-- Wyświetl wszystkie adresy, których kod został niepoprawnie zapisany.
SELECT * 
FROM adres_klienta
WHERE kod NOT REGEXP '^[0-9]{2}-[0-9]{3}$';
