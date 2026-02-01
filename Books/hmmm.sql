USE db_books;

create database db_books;

SHOW CREATE DATABASE db_books;

SHOW CREATE TABLE Authors;
SHOW CREATE TABLE Books;
SHOW CREATE TABLE Publishing_house;

CREATE TABLE Authors( -- создание таблицы в бд
Code_author INT PRIMARY KEY,
 name_author CHAR(30), 
 Birthday DATETIME
 );

CREATE TABLE Publishing_house(
Code_publish INT PRIMARY KEY AUTO_INCREMENT,
 Publish CHAR(50), 
City CHAR(20)
);

CREATE TABLE Books(
Code_book INT PRIMARY KEY AUTO_INCREMENT,
 Title_book CHAR(40), 
 Code_author int,
FOREIGN KEY (Code_author) REFERENCES Authors(Code_author), 
 Pages INT, 
 Code_publish int,
   FOREIGN KEY (Code_publish) REFERENCES Publishing_house(Code_publish) 
 );

CREATE TABLE Deliveries(
Code_delivery INT PRIMARY KEY AUTO_INCREMENT,
 Name_delivery VARCHAR(50),
 Name_company VARCHAR(40),
 Address VARCHAR(100),
 Phone BIGINT,
 INN CHAR(13)
 );

CREATE TABLE Purchases(
Code_purchase INT PRIMARY KEY AUTO_INCREMENT, 
Code_book INT,
FOREIGN KEY (Code_book) REFERENCES Books(Code_book), 
Date_order DATETIME, 
Code_delivery INT,
 FOREIGN KEY (Code_delivery) REFERENCES Deliveries(Code_delivery),
 Type_purchase BIT,
 Cost FLOAT,
 Amount INT
 );




-- Простая проверка наличия данных на базе
SELECT * FROM books;
SELECT * FROM authors;
SELECT * FROM deliveries;
SELECT * FROM publishing_house;
SELECT * FROM purchases;


-- Первое задание
SELECT *
FROM books
ORDER BY Code_book;

-- Второе задание
SELECT Code_book, Title_book, Pages
FROM books
ORDER BY Title_book ASC, Pages DESC;

-- Третье задание
SELECT Name_delivery, Phone, INN
FROM deliveries
ORDER BY INN DESC;

-- Четвёртое задание
SELECT Name_delivery, INN, Phone, Address, Code_delivery
FROM deliveries;

-- Пятое задание
SELECT Publish, City, Code_publish
FROM Publishing_house;

-- Шестое задание
SELECT 
	Title_book,
    Pages,
    (SELECT name_author FROM Authors WHERE Code_author = books.Code_author) as name_author
FROM books;

-- Седьмое задание
SELECT 
	Title_book,
    Pages,
    (SELECT Name_delivery FROM deliveries WHERE Code = books.Code_author) as name_author
FROM books;

-- Восьмое задание
SELECT
	Title_book,
    Pages,
    (SELECT Publish FROM publishing_house WHERE Code_publish = books.Code_publish) AS Publish,
    (SELECT City FROM publishing_house WHERE Code_publish = books.Code_publish) AS City
FROM books;

-- Девятое задание
SELECT Name_company, Phone, INN
FROM Deliveries
WHERE Name_company LIKE 'ОАО%';

-- Десятое задание
SELECT 
    Title_book, 
    Pages, 
    (SELECT name_author FROM Authors WHERE Code_author = Books.Code_author) AS name_author
FROM Books
WHERE Title_book LIKE 'Мемуары%';

-- Одинадцатое задание
SELECT name_author
FROM Authors
WHERE name_author LIKE 'Иванов%';

-- Двенадцатое задание
SELECT Publish
FROM Publishing_house
WHERE City != 'Москва';

-- Тринадцатое задание
SELECT Title_book
FROM Books
WHERE Code_publish NOT IN (
    SELECT Code_publish 
    FROM Publishing_house 
    WHERE Publish = 'Питер-Софт'
);

-- Четырнадцатое задание
SELECT Name_author
FROM Authors
WHERE Birthday BETWEEN '1840-01-01' AND '1860-06-01';

-- Пятнадцатое задание
SELECT b.Title_book, p.Amount
FROM Books b, Purchases p
WHERE b.Code_book = p.Code_book
  AND p.Date_order BETWEEN '2003-03-12' AND '2003-06-15';
  
-- Шестнадцатое задание 
SELECT Title_book, Pages
FROM books
WHERE Pages BETWEEN 200 AND 300;

-- Семнадцатое заание
SELECT name_author
FROM authors
WHERE name_author BETWEEN 'В' AND 'Г';

-- Восемнадцатое задание
SELECT 
	(SELECT Title_book FROM books WHERE Code_book = purchases.Code_book) AS Title_book,
    Amount
FROM purchases
WHERE Code_delivery IN (3, 7, 9, 11);

-- Девятнадцатое задание
SELECT Title_book
FROM books
WHERE Title_book IN ('Питер-Софт', 'Альфа', 'Наука');

-- Двадцатое задание
SELECT 
	(SELECT Title_book FROM books WHERE Code_author = authors.Code_author) AS Title_book,
    name_author
FROM authors
WHERE name_author IN ('Толстой Л.Н', 'Достоевский Ф.М.', 'Пушкин А.С.');

-- Двадцать первое задание
SELECT name_author
FROM authors
WHERE name_author LIKE 'К%';

-- Двадцать второе задание
SELECT Publish
FROM publishing_house
WHERE Publish LIKE '%софт%';

-- Двадцать третье задание
SELECT Name_delivery
FROM deliveries
WHERE Name_delivery LIKE '%ский';
	
-- Двадцать четвёртое задание
SELECT 
	Code_delivery,
    Date_order,
    (SELECT Title_book FROM books WHERE Code_book = purchases.Code_book) AS Title_book
FROM purchases
WHERE Amount > 100 OR COST BETWEEN 200 AND 500;

-- 25 Задание
SELECT
    Code_author,
    (SELECT name_author FROM authors WHERE Code_author = books.Code_author) AS name_author,
    Title_book
FROM books
WHERE Code_publish BETWEEN 10 AND 25 AND Pages > 120;

-- 26 Задание
SELECT DISTINCT Publish
FROM publishing_house
WHERE City = 'Новосибирск'
  AND Code_publish IN (
    SELECT Code_publish FROM books WHERE Title_book LIKE 'Труды%' 
  );
  

-- 27 Задание
SELECT d.Name_company, b.Title_book
FROM Deliveries d, Purchases p, Books b
WHERE d.Code_delivery = p.Code_delivery
  AND p.Code_book = b.Code_book
  AND p.Date_order BETWEEN '2002-01-01' AND '2003-12-31';

-- 28 Задание
SELECT DISTINCT a.name_author
FROM Authors a, Books b, Publishing_house ph
WHERE a.Code_author = b.Code_author
  AND b.Code_publish = ph.Code_publish
  AND ph.Publish = 'Мир';

-- 29 Задание
SELECT DISTINCT d.Name_company
FROM Deliveries d, Purchases p, Books b, Publishing_house ph
WHERE d.Code_delivery = p.Code_delivery
  AND p.Code_book = b.Code_book
  AND b.Code_publish = ph.Code_publish
  AND ph.Publish = 'Питер';

-- 30 Задание
SELECT a.name_author, b.Title_bbooksook
FROM Authors a, Books b, Purchases p, Deliveries d
WHERE a.Code_author = b.Code_author
  AND b.Code_book = p.Code_book
  AND p.Code_delivery = d.Code_delivery
  AND d.Name_company = 'ОАО Книготорг';
  
  -- 31 Задание
  SELECT 
    p.Code_delivery,
    b.Title_book,
    SUM(p.Cost * p.Amount) AS Total_Cost
FROM 
    Purchases p
JOIN 
    Books b ON p.Code_book = b.Code_book
GROUP BY 
    p.Code_delivery, 
    b.Title_book
ORDER BY 
    p.Code_delivery, 
    b.Title_book;
    
-- 32 Задание
-- Вывести стоимость одной печатной страницы каждой книги (использовать поля Cost и Pages) и названия соответствующих книг (поле Title_book)
SELECT 
    b.Title_book,
    SUM(p.Cost / b.Pages) AS oneCost
FROM books b
JOIN purchases p ON b.Code_book = b.Code_book
GROUP BY b.Title_book;

-- 33 Задание
-- Вывести количество лет с момента рождения авторов (использовать поле Birthday) и имена соответствующих авторов (поле Name_author)
SELECT 
	name_author,
    TIMESTAMPDIFF(YEAR, Birthday, CURDATE()) AS age
FROM authors;

-- 34 Задание
-- Вывести общую сумму поставок книг (использовать поле Cost), выполненных ‘ЗАО Оптторг’ (условие по полю Name_company).
SELECT 
    SUM(p.Cost * p.Amount) AS total_sum
FROM 
    Purchases p
JOIN 
    Deliveries d ON p.Code_delivery = d.Code_delivery
WHERE 
    d.Name_company = 'ЗАО Оптторг';
    
-- 35 Задание
-- Вывести общее количество всех поставок (использовать любое по-ле из таблицы Purchases), выполненных в период с 01.01.2003 по 01.02.2003 (условие по полю Date_order).
SELECT 
	Code_purchase
FROM 
	purchases
WHERE Date_order BETWEEN '2003-01-01' AND '2003-02-01';

-- 36.	
-- Вывести среднюю стоимость (использовать поле Cost) и среднее количество экземпляров книг (использовать поле Amount) в одной поставке, где автором книги является ‘Акунин’ (условие по полю Name_author).
USE db_books;

SELECT 
    AVG(p.Cost) AS avg_cost,
    AVG(p.Amount) AS avg_amount
FROM 
    Purchases p
JOIN 
    Books b ON p.Code_book = b.Code_book
JOIN 
    Authors a ON b.Code_author = a.Code_author
WHERE 
    a.name_author = 'Акунин';

-- 37 
-- Вывести все сведения о поставке (все поля таблицы Purchases), а также название книги (поле Title_book) с минимальной общей стоимостью (использовать поля Cost и Amount).
USE db_books;

SELECT 
    p.*,
    b.Title_book
FROM 
    Purchases p
JOIN 
    Books b ON p.Code_book = b.Code_book
WHERE 
    p.Cost * p.Amount = (
        SELECT 
            MIN(Cost * Amount) 
        FROM 
            Purchases
    );
    
-- 38
-- Вывести все сведения о поставке (все поля таблицы Purchases), а также название книги (поле Title_book) с максимальной общей стоимостью (использовать поля Cost и Amount).
USE db_books;

SELECT 
    p.*,
    b.Title_book
FROM 
    Purchases p
JOIN 
    Books b ON p.Code_book = b.Code_book
WHERE 
    p.Cost * p.Amount = (
        SELECT 
            MAX(Cost * Amount) 
        FROM 
            Purchases
    );

-- 39
-- Вывести название книги (поле Title_book), суммарную стоимость партии одноименных книг (использовать поля Amount и Cost), поместив в результат в поле с названием Itogo, в поставках за период с 01.01.2002 по 01.06.2002 (условие по полю Date_order)
USE db_books;

SELECT 
    b.Title_book,
    SUM(p.Cost * p.Amount) AS Itogo
FROM 
    Purchases p
JOIN 
    Books b ON p.Code_book = b.Code_book
WHERE 
    p.Date_order >= '2002-01-01' 
    AND p.Date_order <= '2002-06-01'
GROUP BY 
    b.Title_book
ORDER BY 
    b.Title_book;
    
-- 40
-- Вывести стоимость одной печатной страницы каждой книги (использовать поля Cost и Pages), поместив результат в поле с названием One_page, и названия соответствующих книг (поле Title_book).
SELECT 
    b.Title_book,
    AVG(p.Cost) / b.Pages AS One_page
FROM 
    Books b
JOIN 
    Purchases p ON b.Code_book = p.Code_book
GROUP BY 
    b.Code_book, 
    b.Title_book, 
    b.Pages
ORDER BY 
    b.Title_book;
    
-- 41
-- Вывести общую сумму поставок книг (использовать поле Cost) и поместить результат в поле с названием Sum_cost, выполненных ‘ОАО Луч ’ (условие по полю Name_company).
SELECT 
    SUM(p.Cost * p.Amount) AS Sum_cost
FROM 
    Purchases p
JOIN 
    Deliveries d ON p.Code_delivery = d.Code_delivery
WHERE 
    d.Name_company = 'ОАО Луч';
    
-- 42
-- Изменить в таблице Books содержимое поля Pages на 300, если код автора (поле Code_author) =56 и название книги (поле Title_book) =’Мемуары’.
UPDATE Books
SET Pages = 300
WHERE Code_author = 56 AND Title_book = 'Мемуары';

-- 43
-- Изменить в таблице Deliveries содержимое поля Address на ‘нет сведений’, если значение поля является пустым.
UPDATE Deliveries
SET Address = 'нет сведений'
WHERE Address IS NULL OR Address = '';

-- 44
-- Увеличить в таблице Purchases цену (поле Cost) на 20 процентов, если заказы были оформлены в течение последнего месяца (условие по полю Date_order).
UPDATE Purchases
SET Cost = Cost * 1.20
WHERE Date_order >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH);

-- 45
-- Добавить в таблицу Purchases новую запись, причем так, чтобы код покупки (поле Code_purchase) был автоматически увеличен на единицу, а в тип закупки (поле Type_purchase) внести значение ‘опт’.
INSERT INTO Purchases (Code_book, Date_order, Code_delivery, Type_purchase, Cost, Amount)
VALUES (1, '2025-11-09', 1, 'опт', 100.0, 10);

-- 46
-- Добавить в таблицу Books новую запись, причем вместо ключевого поля поставить код (поле Code_book), автоматически увеличенный на единицу от максимального кода в таблице, вместо названия книги (поле Title_book) написать ‘Наука. Техника. Инновации’.
INSERT INTO Books (Code_book, Title_book, Code_author, Pages, Code_publish)
VALUES (
    (SELECT COALESCE(MAX(Code_book), 0) + 1 FROM Books),
    'Наука. Техника. Инновации',
    1,
    100,
    1
);

-- 47
-- Добавить в таблицу Publish_house новую запись, причем вместо ключевого поля поставить код (поле Code_publish), автоматически увеличенный на единицу от максимального кода в таблице, вместо названия города – ‘Москва’ (поле City), вместо издательства – ‘Наука’ (поле Publish).
INSERT INTO Publishing_house (Code_publish, Publish, City)
VALUES (
    (SELECT COALESCE(MAX(Code_publish), 0) + 1 FROM Publishing_house),
    'Наука',
    'Москва'
);

-- 48
-- Удалить из таблицы Purchases все записи, у которых количество книг в заказе (поле Amount) = 0.
DELETE FROM Purchases
WHERE Amount = 0;

-- 49
-- Удалить из таблицы Authors все записи, у которых нет имени автора в поле Name_Author
DELETE FROM Authors
WHERE name_author IS NULL OR name_author = '';

-- 50
-- Удалить из таблицы Deliveries все записи, у которых не указан ИНН (поле INN пустое).
DELETE FROM Deliveries
WHERE INN IS NULL OR INN = '';

-- Тренировки 

-- Вывести сведения о книге с минимальной общей стоимостью
SELECT 
	b.*
FROM 
	purchases p
JOIN books b ON p.Code_book = b.Code_book
WHERE
	p.Amount * p.Cost = (
		SELECT
			MIN(Amount * Cost)
		FROM purchases
	);
    
-- Вывести название издательства, которое продаёт самое наибольшее количество книг
SELECT
	pub.Publish
FROM publishing_house pub
JOIN books b ON pub.Code_publish = b.Code_publish
JOIN purchases pur ON b.Code_book = pur.Code_book
GROUP BY
	pub.Publish, pub.Code_publish
HAVING
	SUM(pur.Amount) = (
		SELECT
			MAX(total_books)
		FROM
			(
            SELECT
				SUM(Amount) AS total_books
			FROM
				purchases pur2
			JOIN Books b2 ON pur2.Code_book = b2.Code_book
			GROUP BY
				b2.Code_publish
		) AS subquery
	);

-- Вывести название издательства, которые выпускает наименьшее количество книг
SELECT pub.Publish
FROM publishing_house pub
JOIN books b ON pub.Code_publish = b.Code_publish
JOIN purchases pur ON b.Code_book = pur.Code_book
GROUP BY
	pub.Publish, pub.Code_publish
HAVING
	SUM(pur.Amount) = (
		SELECT
			MIN(total_books)
		FROM
		(
		SELECT
			SUM(Amount) AS total_books
		FROM
			purchases pur2
		JOIN books b2 ON pur2.Code_book = b2.Code_book
		GROUP BY
			b2.Code_publish
		) AS subquery
	);

-- Вывести название автора, книги котого наиолее покупаемые
SELECT
	a.name_author
FROM authors a
JOIN books b ON a.Code_author = b.Code_author
JOIN purchases p ON b.Code_book = p.Code_book
GROUP BY 
	a.name_author, a.Code_author
HAVING
	SUM(p.Amount) = (
		SELECT
			MAX(total_books)
		FROM (
        SELECT SUM(Amount) as total_books
        FROM purchases p2
        JOIN books b2 ON p2.Code_book = b2.Code_book
        GROUP BY 
			b2.Code_author
		) AS subquery
	);
    
-- Вывести стоимость одной печатной страницы  каждой книги в зависимости от издателя
SELECT
	pub.Publish,
    b.Title_book,
    AVG(pur.Cost) / b.Pages AS cost_per_page
FROM
	publishing_house pub
JOIN books b ON pub.Code_publish = b.Code_publish
JOIN purchases pur ON b.Code_book = pur.Code_book
GROUP BY
	pub.Code_publish, pub.Publish,
    b.Code_book, b.Title_book, b.Pages
ORDER BY
	pub.Publish, b.Title_book;


-- Какой издатель выпускает наименьшее (наибольшее) количество книг
SELECT
	pub.Publish,
    COUNT(b.Code_book) as num_books
FROM publishing_house pub
JOIN books b ON pub.Code_publish = b.Code_publish
GROUP BY
	pub.Publish, pub.Code_publish
HAVING
	num_books = (
    SELECT MIN(total_books)
    FROM(
		SELECT COUNT(Code_book) as total_books
        FROM books b2
        GROUP BY
			b2.Code_publish
		) AS subquery
	);
    
    
    
    
-- 10 вариант
-- Вывести информацию о самом поставляемом авторе
SELECT a.name_author,SUM(p.Amount) 
FROM authors a
JOIN books b ON a.Code_author = b.Code_author
JOIN purchases p ON b.Code_book = p.Code_book
GROUP BY
	a.Code_author
HAVING
	SUM(p.Amount) = (
		SELECT
			MAX(total_amount)
		FROM
		(
			SELECT
				SUM(Amount) as total_amount
			FROM
				purchases pur2
			JOIN books b2 ON pur2.Code_book = b2.Code_book
            GROUP BY
				b2.Code_author
		) AS sub
	);

-- По каждому издателю сколько книг выпускает
SELECT pub.Publish, SUM(pur.Amount) AS t_amount
FROM Publishing_house pub
JOIN Books b ON pub.Code_publish = b.Code_publish
JOIN Purchases pur ON b.Code_book = pur.Code_book
GROUP BY pub.Code_publish, pub.Publish
HAVING
    t_amount = (
		SELECT MAX(t_total)
        FROM (
			SELECT
				SUM(amount) AS t_total
			FROM purchases pur2
			JOIN books b2 ON pur2.Code_book = b2.Code_book
			GROUP BY b2.Code_publish
		) AS subquery
	);

SELECT pub.Publish, SUM(pur.Amount) AS t_amount
FROM publishing_house pub
JOIN books b ON pub.Code_publish = b.Code_publish
JOIN purchases pur ON b.Code_book = pur.Code_book
GROUP BY pub.Publish, pub.Code_publish
HAVING 
	t_amount = (
		SELECT MAX(t_total)
		FROM(
			SELECT SUM(Amount) AS t_total
			FROM purchases p2
			JOIN books b2 ON p2.Code_book = b2.Code_book
			GROUP BY b2.Code_publish
		) AS subquery
	);
    
-- Уменьшить стоимость еденицы на 50 процентов продажи которых не были последние 3 дня
UPDATE purchases p
LEFT JOIN(
	SELECT distinct Code_book
	FROM purchases
    WHERE Date_order >= DATE_SUB(CURDATE(), INTERVAL 3 DAY)
) AS recent ON p.Code_book = recent.Code_book
SET p.Cost = p.Cost * 0.5
WHERE recent.Code_book IS NULL;

-- Создайте триггер, запускаемый при занесении новой строки в таблицу Авторы. Триггер должен увеличивать счетчик числа добавленных строк.

insert Authors(Code_author, name_author, Birthday) values (998, "Анатолий", "1920-01-23");

select @authors_count;

-- Добавьте в таблицу Авторы поле Количество книг (Count_books) целого типа со значением по умолчанию 0. Создайте хранимую процедуру, 
-- которая подсчитывает количество книг по каждому автору и заносит в поле Count_books эту информацию. Создайте триггер, запускаемый 
-- после внесения новой информации о книге.

alter table Authors
add column Count_books int;

alter table Authors
drop column C
        
	
    



		


            
    
    
		
        
    



