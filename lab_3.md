# Lab 3
```sql
# funkcja zwróci ilość znaków dla każdego imienia w tabeli pracownik
SELECT length(imie) FROM pracownik;

# funkcja zwróci pierwszą literę imienia i pierwszą literę nazwiska
SELECT substring(imie, 1, 1), substring(nazwisko, 1, 1) FROM pracownik;

# wynikiem będzie pojedyncza kolumna
SELECT concat(imie," ", nazwisko) FROM pracownik;


-- Funkcja lower() i upper()
-- Funkcje lower(teskt) i upper(tekst) odpowiednio zwraca postać tekstu małymi i dużymi literami.
SELECT upper(nazwa_towaru) FROM towar;

-- Funkcja reverse()
-- Funkcja reverse(tekst) zwraca tekst w postaci odwróconej.
SELECT reverse(imie) FROM pracownik;

# zwróci aktualną datę i czas
SELECT CURRENT_TIMESTAMP;

# zwróci wartość '2008-05-17'
SELECT DATE('2008-05-17 11:31:31') as data;

# zwraca aktualną datę systemową
SELECT curdate();

# zostanie zwrócona data o 14 większa niż data zapisana w kolumnie termin_platnosci
SELECT ADDDATE(termin_platnosci, INTERVAL 14 DAY) FROM faktura;

# zwraca numer miesiąca, w którym się urodził dany pracownik
SELECT month(data_urodzenia) FROM pracownik WHERE id_pracownika=1;

-- Funkcja datediff zwraca różnicę podaną w dniach, między dwiema datami. 
-- W zależności od tego, która z nich będzie 'nowsza' wynik będzie liczbą dodatnią lub ujemną.
SELECT datediff(data_urodzenia, now()) FROM pracownik WHERE id_pracownika=1;

-- Funkcja week zwraca numer tygodnia w zależności od wybranego trybu (patrz link pod przykładem).
SELECT week(data_zamowienia) FROM zamowienie ORDER BY id_zamowienia DESC LIMIT 1;

# zwraca liczbę rekordów w tabeli pracownik
SELECT count(*) FROM pracownik;

# zwraca unikalne wartości w kolumnie nazwisko
SELECT DISTINCT nazwisko FROM pracownik;
# lub
SELECT distinct(nazwisko) FROM pracownik;

# a jeżeli interesuje nas liczba unikalnych wartości
SELECT count(distinct(nazwisko)) from pracownik;

# zwraca liczbę rekordów w tabeli pracownik

#Grupowania
SELECT imie, nazwisko, dzial FROM pracownik GROUP BY dzial;

SELECT imie, nazwisko, dzial FROM pracownik ORDER BY id_pracownika ASC, dzial ASC;

SELECT imie, nazwisko, dzial, count(dzial) FROM pracownik GROUP BY dzial;

SELECT imie, nazwisko, dzial, count(dzial) FROM pracownik GROUP BY dzial;

#Średnia
SELECT avg(cena_zakupu) FROM towar;

SELECT zamowienie, group_concat(towar) FROM pozycja_zamowienia GROUP BY zamowienie;

SELECT zamowienie, group_concat(towar separator ' oraz ') FROM pozycja_zamowienia GROUP BY zamowienie;

SELECT dzial, count(dzial) FROM pracownik GROUP BY dzial HAVING count(dzial) > 2;

# agregacja i grupowanie

select sum(ilosc * cena) from pozycja_zamowienia;

select zamowienie, sum(ilosc * cena) from pozycja_zamowienia
group by zamowienie;

select zamowienie, count(*), sum(ilosc * cena), avg(ilosc * cena)
from pozycja_zamowienia
group by zamowienie;
```

# Zadania 3 część 1
## Zadanie 1
```sql
-- Wyświetl imię i nazwisko każdego pracownika i jego rok urodzenia.
select imie, nazwisko, year(data_urodzenia) from pracownik;
```
## Zadanie 2
```sql
-- Wyświetl imię i nazwisko pracowników oraz ich wiek w latach (bez uwzględniania miesiąca i dnia urodzenia).
# dodane sortowanie po aliasu wieku
select
	imie,
    nazwisko,
    year(data_urodzenia),
    year(now()) - year(data_urodzenia) as wiek
from pracownik order by wiek desc;
```
## Zadanie 3
```sql
-- Wyświetl nazwę działu i liczbę pracowników przypisanych do każdego z nich.
SELECT d.nazwa, COUNT(p.id_pracownika) AS liczba_pracownikow
FROM dzial d
LEFT JOIN pracownik p ON d.id = p.dzial
GROUP BY d.nazwa;
```
## Zadanie 4
```sql
-- Wyświetl nazwę kategorii oraz liczbę produktów w każdej z nich.
select k.nazwa_kategori, count(t.nazwa_towaru)
from kategoria k
inner join  towar t on t.kategoria=k.id_kategori
group by k.id_kategori;
```
## Zadanie 5
```sql
-- Wyświetl nazwę kategorii i w kolejnej kolumnie listę wszystkich produktów należącej do każdej z nich.

select nazwa_kategori, group_concat(nazwa_towaru) from towary_full_info group by nazwa_kategori;
```
## Zadanie 6
```sql
-- Wyświetl średnie zarobki pracowników za zaokrągleniem do 2 miejsc po przecinku.
select round(avg(pensja),2) as 'Srednie zarobki' from pracownik;
```
## Zadanie 7
```sql
-- Wyświetl średnie zarobki pracowników, którzy pracują co najmniej od 5 lat.
select round(avg(pensja),2) as 'Srednie zarobki' from __firma_zti.pracownik where TIMESTAMPDIFF(YEAR, data_zatrudnienia, CURDATE()) > 5;
```
## Zadanie 8
```sql
-- Wyświetl 10 najczęściej sprzedawanych produktów.
SELECT towar.nazwa_towaru, ROUND(SUM(pozycja_zamowienia.ilosc)) as zamowienia
FROM pozycja_zamowienia
JOIN towar ON pozycja_zamowienia.towar = towar.id_towaru
GROUP BY towar.nazwa_towaru
ORDER BY zamowienia DESC
LIMIT 10;
```
## Zadanie 9
```sql
-- Wyświetl numer zamówienia, jego wartość (suma wartości wszystkich jego pozycji) zarejestrowanych w pierwszym kwartale 2017 roku.
select 
    zamowienie.numer_zamowienia,
    sum(pozycja_zamowienia.ilosc * pozycja_zamowienia.cena)
from zamowienie
inner join pozycja_zamowienia 
    on zamowienie.id_zamowienia = pozycja_zamowienia.zamowienie
where year(zamowienie.data_zamowienia) = 2017
  and quarter(zamowienie.data_zamowienia) = 1
group by zamowienie.numer_zamowienia;
```
## Zadanie 10
```sql
-- Wyświetl imie, nazwisko i sumę wartości zamówień, które dany pracownik dodał. Posortuj malejąco po sumie.
SELECT 
  p.imie,
  p.nazwisko,
  round(SUM(pz.ilosc * pz.cena),2) AS suma_zamowien
FROM pracownik p
JOIN zamowienie z ON p.id_pracownika = z.pracownik_id_pracownika
JOIN pozycja_zamowienia pz ON z.id_zamowienia = pz.zamowienie
GROUP BY p.imie, p.nazwisko
ORDER BY suma_zamowien DESC;
```
# Zadania 3 część 2
## Zadanie 1
```sql
-- Wyświetl nazwę działu i minimalną, maksymalną i średnią wartość pensji w każdym dziale.

SELECT d.nazwa, MIN(p.pensja) as "Min pensja", MAX(p.pensja) as "Max pensja", round(AVG(p.pensja),2) as "Srednia pensja"
FROM dzial d
JOIN pracownik p ON d.id_dzialu = p.dzial
GROUP BY d.nazwa;
```
## Zadanie 2
```sql
-- Wyświetl pełną nazwę klienta, wartość zamówienia dla 10 najwyższych wartości zamówienia.
SELECT 
  k.pelna_nazwa, 
  round(SUM(pz.ilosc * pz.cena),2) AS wartosc_zamowienia
FROM klient k
JOIN zamowienie z ON k.id_klienta = z.klient
JOIN pozycja_zamowienia pz ON z.id_zamowienia = pz.zamowienie
GROUP BY k.pelna_nazwa
ORDER BY wartosc_zamowienia DESC
LIMIT 10;
```
## Zadanie 3
```sql
-- Wyświetl wartość przychodu dla każdego roku. Dane posortuj malejąco według sumy wartości zamówień.
SELECT 
    EXTRACT(YEAR FROM z.data_zamowienia) AS Year,
    round(SUM(pz.ilosc * pz.cena),2) AS "Przychód"
FROM 
    zamowienie z join pozycja_zamowienia pz on z.id_zamowienia = pz.zamowienie
WHERE z.status_zamowienia = 5
GROUP BY 
    EXTRACT(YEAR FROM z.data_zamowienia)
ORDER BY 
    "Przychód" DESC;
```
## Zadanie 5
```sql
-- Wyświetl liczbę zamówień i sumę zamówień dla każdego miasta z podstawowego adresu klientów.
SELECT 
    a.miejscowosc,
    COUNT(z.id_zamowienia) AS "Liczba zamówień",
    ROUND(SUM(pz.ilosc * pz.cena), 2) AS "Suma wartości zamówień"
FROM 
    adres_klienta a
JOIN 
    klient k ON a.klient = k.id_klienta
JOIN 
    zamowienie z ON z.klient = k.id_klienta
JOIN 
    pozycja_zamowienia pz ON z.id_zamowienia = pz.zamowienie
GROUP BY 
    a.miejscowosc
ORDER BY 
    SUM(pz.ilosc * pz.cena) DESC;
```
## zadanie 6
```sql
-- Wyświetl dotychczasowy dochód firmy biorąc pod uwagę tylko zamówienia zrealizowane.
# bez tabeli status_zamowienia
SELECT 
    SUM(pz.ilosc * pz.cena) AS dochod
FROM zamowienie z
JOIN pozycja_zamowienia pz ON z.id_zamowienia = pz.zamowienie
WHERE z.status_zamowienia = 5;
```
```sql
# z tabelą status_zamowienia
SELECT 
    SUM(pz.ilosc * pz.cena) AS dochod
FROM zamowienie z
JOIN pozycja_zamowienia pz ON z.id_zamowienia = pz.zamowienie
JOIN status_zamowienia sz on z.status_zamowienia=sz.id_statusu_zamowienia
WHERE sz.nazwa_statusu_zamowienia = 'zrealizowane';
```
## Zadanie 7
```sql
-- Policz i wyświetl dochód (przychód z zamówień - cena zakupu towaru) w każdym roku działalności firmy.
SELECT 
    EXTRACT(YEAR FROM z.data_zamowienia) AS rok,
    ROUND(SUM(pz.ilosc * pz.cena) - SUM(pz.ilosc * t.cena_zakupu), 2) AS dochod
FROM 
    zamowienie z
JOIN 
    pozycja_zamowienia pz ON z.id_zamowienia = pz.zamowienie
JOIN 
    towar t ON pz.towar = t.id_towaru
GROUP BY 
    EXTRACT(YEAR FROM z.data_zamowienia)
ORDER BY 
    dochod DESC;
```

## zadanie 8
```sql
# Wyświetl wartość aktualnego stanu magazynowego z podziałem na kategorię produktów.
# stan_magazynowy.ilosc * towar.cena_zakupu
select 
	kategoria.nazwa_kategori,
    round(sum(stan_magazynowy.ilosc * towar.cena_zakupu),2)
from towar
inner join stan_magazynowy on towar.id_towaru=stan_magazynowy.towar
inner join kategoria on kategoria.id_kategori=towar.kategoria
group by kategoria.id_kategori;
# gdyby interesowały mnie również nazwy towarów
select 
	kategoria.nazwa_kategori,
    round(sum(stan_magazynowy.ilosc * towar.cena_zakupu),2),
    group_concat(towar.nazwa_towaru)
from towar
inner join stan_magazynowy on towar.id_towaru=stan_magazynowy.towar
inner join kategoria on kategoria.id_kategori=towar.kategoria
group by kategoria.id_kategori;
```sql
# z sumami częściowymi (with rollup), grupowanie po roku i kwartale
select
	year(zamowienie.data_zamowienia),
    quarter(zamowienie.data_zamowienia),
	-- zamowienie.numer_zamowienia,
    sum(pozycja_zamowienia.ilosc * pozycja_zamowienia.cena) as wartosc
from zamowienie
inner join pozycja_zamowienia 
on zamowienie.id_zamowienia=pozycja_zamowienia.zamowienie
group by year(zamowienie.data_zamowienia), 
quarter(zamowienie.data_zamowienia) with rollup;
```
## Zadanie 9
```sql
-- Przygotuj zapytanie, które wyświetli dane w poniższej postaci 
-- (policz ilu pracowników urodziło się w danym miesiącu - uwaga na porządek sortowania).
SET lc_time_names = 'pl_PL';
SELECT 
    MONTHNAME(data_urodzenia) AS Miesiąc,
    COUNT(*) AS "Liczba pracowników"
FROM 
    pracownik
GROUP BY 
    MONTH(data_urodzenia), MONTHNAME(data_urodzenia)
ORDER BY 
    MONTH(data_urodzenia);
```    
## Zadanie 10 *
```sql
-- Wyświetl imię i nazwisko pracownika i koszt jaki poniósł pracodawca od momentu jego zatrudnienia.
-- Nie aż tak trudne jak poszukać odpowiedniej funkcji operującej na datach.

SELECT 
    imie,
    nazwisko,
    TIMESTAMPDIFF(MONTH, data_zatrudnienia, CURDATE()) AS przepracowane_miesiace,
    ROUND(pensja * TIMESTAMPDIFF(MONTH, data_zatrudnienia, CURDATE()), 2) AS koszt_dla_pracodawcy
FROM 
    pracownik;
```
