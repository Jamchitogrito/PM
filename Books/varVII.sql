CREATE DATABASE db_details;
USE db_details;

CREATE TABLE suppliers (
    supplier_code VARCHAR(6) PRIMARY KEY,
    surname VARCHAR(20),
    rating INT,
    city VARCHAR(20)
);

CREATE TABLE details (
    detail_code VARCHAR(6) PRIMARY KEY,
    detail_name VARCHAR(20),
    color VARCHAR(20),
    weight INT,
    city VARCHAR(20)
);

CREATE TABLE products (
    product_code VARCHAR(6) PRIMARY KEY,
    product_name VARCHAR(20),
    city VARCHAR(20)
);

CREATE TABLE shipments (
    supplier_code VARCHAR(6),
    detail_code VARCHAR(6),
    product_code VARCHAR(6),
    quantity INT,
    FOREIGN KEY (supplier_code) REFERENCES suppliers(supplier_code),
    FOREIGN KEY (detail_code) REFERENCES details(detail_code),
    FOREIGN KEY (product_code) REFERENCES products(product_code)
);


INSERT INTO suppliers (supplier_code, surname, rating, city) VALUES ('S1', 'Смит', 20, 'Лондон');
INSERT INTO suppliers (supplier_code, surname, rating, city) VALUES ('S2', 'Джонс', 10, 'Париж');
INSERT INTO suppliers (supplier_code, surname, rating, city) VALUES ('S3', 'Блейк', 30, 'Париж');
INSERT INTO suppliers (supplier_code, surname, rating, city) VALUES ('S4', 'Кларк', 20, 'Лондон');
INSERT INTO suppliers (supplier_code, surname, rating, city) VALUES ('S5', 'Адамс', 30, 'Афины');

INSERT INTO details (detail_code, detail_name, color, weight, city) VALUES ('P1', 'Гайка', 'Красный', 12, 'Лондон');
INSERT INTO details (detail_code, detail_name, color, weight, city) VALUES ('P2', 'Болт', 'Зеленый', 17, 'Париж');
INSERT INTO details (detail_code, detail_name, color, weight, city) VALUES ('P3', 'Винт', 'Голубой', 17, 'Рим');
INSERT INTO details (detail_code, detail_name, color, weight, city) VALUES ('P4', 'Винт', 'Красный', 14, 'Лондон');
INSERT INTO details (detail_code, detail_name, color, weight, city) VALUES ('P5', 'Кулачок', 'Голубой', 12, 'Париж');
INSERT INTO details (detail_code, detail_name, color, weight, city) VALUES ('P6', 'Блюм', 'Красный', 19, 'Лондон');

INSERT INTO products (product_code, product_name, city) VALUES ('J1', 'Жесткий диск', 'Париж');
INSERT INTO products (product_code, product_name, city) VALUES ('J2', 'Перфоратор', 'Рим');
INSERT INTO products (product_code, product_name, city) VALUES ('J3', 'Считыватель', 'Афины');
INSERT INTO products (product_code, product_name, city) VALUES ('J4', 'Принтер', 'Афины');
INSERT INTO products (product_code, product_name, city) VALUES ('J5', 'Флоппи-диск', 'Лондон');
INSERT INTO products (product_code, product_name, city) VALUES ('J6', 'Терминал', 'Осло');
INSERT INTO products (product_code, product_name, city) VALUES ('J7', 'Лента', 'Лондон');

INSERT INTO shipments (supplier_code, detail_code, product_code, quantity) VALUES ('S1', 'P1', 'J1', 200);
INSERT INTO shipments (supplier_code, detail_code, product_code, quantity) VALUES ('S1', 'P1', 'J4', 700);
INSERT INTO shipments (supplier_code, detail_code, product_code, quantity) VALUES ('S2', 'P3', 'J1', 400);
INSERT INTO shipments (supplier_code, detail_code, product_code, quantity) VALUES ('S2', 'P3', 'J2', 200);
INSERT INTO shipments (supplier_code, detail_code, product_code, quantity) VALUES ('S2', 'P3', 'J3', 200);
INSERT INTO shipments (supplier_code, detail_code, product_code, quantity) VALUES ('S2', 'P3', 'J4', 500);
INSERT INTO shipments (supplier_code, detail_code, product_code, quantity) VALUES ('S2', 'P3', 'J5', 600);
INSERT INTO shipments (supplier_code, detail_code, product_code, quantity) VALUES ('S2', 'P3', 'J6', 400);
INSERT INTO shipments (supplier_code, detail_code, product_code, quantity) VALUES ('S2', 'P3', 'J7', 800);
INSERT INTO shipments (supplier_code, detail_code, product_code, quantity) VALUES ('S2', 'P5', 'J2', 100);
INSERT INTO shipments (supplier_code, detail_code, product_code, quantity) VALUES ('S3', 'P3', 'J1', 200);
INSERT INTO shipments (supplier_code, detail_code, product_code, quantity) VALUES ('S3', 'P4', 'J2', 500);
INSERT INTO shipments (supplier_code, detail_code, product_code, quantity) VALUES ('S4', 'P6', 'J3', 300);
INSERT INTO shipments (supplier_code, detail_code, product_code, quantity) VALUES ('S4', 'P6', 'J7', 300);
INSERT INTO shipments (supplier_code, detail_code, product_code, quantity) VALUES ('S5', 'P2', 'J2', 200);
INSERT INTO shipments (supplier_code, detail_code, product_code, quantity) VALUES ('S5', 'P2', 'J4', 100);
INSERT INTO shipments (supplier_code, detail_code, product_code, quantity) VALUES ('S5', 'P5', 'J5', 500);
INSERT INTO shipments (supplier_code, detail_code, product_code, quantity) VALUES ('S5', 'P5', 'J7', 100);
INSERT INTO shipments (supplier_code, detail_code, product_code, quantity) VALUES ('S5', 'P6', 'J2', 200);
INSERT INTO shipments (supplier_code, detail_code, product_code, quantity) VALUES ('S5', 'P1', 'J4', 100);
INSERT INTO shipments (supplier_code, detail_code, product_code, quantity) VALUES ('S5', 'P3', 'J4', 200);
INSERT INTO shipments (supplier_code, detail_code, product_code, quantity) VALUES ('S5', 'P4', 'J4', 800);
INSERT INTO shipments (supplier_code, detail_code, product_code, quantity) VALUES ('S5', 'P5', 'J4', 400);
INSERT INTO shipments (supplier_code, detail_code, product_code, quantity) VALUES ('S5', 'P6', 'J4', 500);

-- Получить номера изделий, для которых детали полностью поставляет поставщик с указанным номером (параметр - номер поставщика (S1)).
select product_code
from shipments 
group by product_code
having count(distinct supplier_code) = 1 and min(supplier_code) = 'S1';

-- Получить общее количество деталей с указанным номером, поставляемых некоторым поставщиком (параметры - номер детали (P1), номер поставщика (S1)).
select sum(quantity) as total
from shipments
where detail_code = 'P1' and detail_code = 'S1';

-- Выдать номера изделий, использующих только детали, поставляемые некоторым поставщиком (параметр - номер поставщика (S1)).
select product_code
from shipments
group by product_code
having count(distinct supplier_code) = 1 and min(supplier_code) = 'S1';

-- Получить общее число изделий, для которых поставляет детали поставщик с указанным номером (параметр - номер поставщика (S1)).
select count(distinct product_code) as ttl
from shipments
where supplier_code = 'S1';

-- Выдать номера изделий, детали для которых поставляет каждый поставщик, поставляющий какую-либо деталь указанного цвета (параметр - цвет детали (красный)).
select sh.product_code
from shipments sh
join details de on sh.detail_code = de.detail_code 
where de.color = 'Красный';

-- Получить полный список деталей для всех изделий, изготавливаемых в некотором городе (параметр - название города (Лондон)).
select distinct
	de.detail_code,
	de.detail_name,
    de.color,
    de.weight,
    de.city
from shipments sh
join details de on sh.detail_code = de.detail_code
join products pr on sh.product_code = pr.product_code
where pr.city = 'Лондон';

-- Выдать номера деталей, поставляемых каким-либо поставщиком из указанного города (параметр - название города (Лондон)).
select distinct de.detail_code, de.city
from shipments sh
join details de on sh.detail_code = de.detail_code
join suppliers su on sh.supplier_code = su.supplier_code
where su.city = 'Лондон';

-- Получить список всех поставок, в которых количество деталей находится в некотором диапазоне (параметры - границы диапазона (от 300 до 750)) .
select distinct supplier_code, detail_code, product_code, quantity
from shipments
where quantity between 300 and 750;

-- Выдать номера и названия деталей, поставляемых для какого-либо изделия из указанного города (параметр - название города (Лондон)).
select distinct de.detail_code, de.detail_name
from shipments sh
join details de on sh.detail_code = de.detail_code
join products pr on sh.product_code = pr.product_code
where pr.city = 'Лондон';

-- Получить цвета деталей, поставляемых некоторым поставщиком (параметр - номер поставщика (S1)).
select distinct de.color
from shipments sh
join details de on sh.detail_code = de.detail_code
join suppliers su on sh.supplier_code = su.supplier_code
where su.supplier_code = 'S1';

-- Выдать номера и фамилии поставщиков, поставляющих некоторую деталь для какого-либо изделия в количестве, большем среднего объема поставок данной детали для этого изделия (параметр - номер детали (P1)).
SELECT DISTINCT s.supplier_code, s.surname
FROM suppliers s
JOIN shipments sh ON s.supplier_code = sh.supplier_code
WHERE sh.detail_code = 'P1'
  AND sh.quantity > (
    SELECT AVG(sh2.quantity)
    FROM shipments sh2
    WHERE sh2.detail_code = 'P1'
      AND sh2.product_code = sh.product_code
  );

-- Получить названия изделий, для которых поставляются детали некоторым поставщиком (параметр - номер поставщика (S1)).
select pr.product_name
from products pr
join shipments sh on pr.product_code = sh.product_code
where sh.supplier_code = 'S1';

-- Прозвать поставщики нумерацией по коду поставщика
select supplier_code,
case 
	when supplier_code = 'S1'
		then 'Первый поставщик'
	when supplier_code = 'S2'
		then 'Второй поставщик'
	when supplier_code = 'S3'
		then 'Третий поставщик'
	when supplier_code = 'S4'
		then 'Четвёртый поставщик'
	when supplier_code = 'S5'
		then 'Пятый поставщик'
end as 'Прозв_поставщика'
from suppliers;

-- показать детали и указать выше или ниже среднего кол-во поставок
select distinct de.detail_name, de.detail_code,
case
	when sh.quantity > (
		select avg(quantity)
        from shipments)
	then 'больше среднего'
	when sh.quantity <(
		select avg(quantity)
        from shipments)
	then 'меньше среднего'
	when sh.quantity = (
		select avg(quantity)
        from shipments)
	then 'среднее значение'
end as 'Количество'
from details de
join shipments sh on de.detail_code = sh.detail_code;


















