create database details_db;

create table s(
    id varchar(6) primary key not null,
    surname varchar(20) not null,
    raiting int not null,
    city varchar(20) not null
);

create table p (
    id varchar(6) primary key not null,
    name varchar(20) not null,
    color varchar(20) not null,
    city varchar(20) not null,
    weight int not null
);

create table j (
    id varchar(6) primary key not null,
    name varchar(20) not null,
    city varchar(20) not null
);

create table spj (
    s_id varchar(6) not null,
    p_id varchar(6) not null,
    j_id varchar(6) not null,
    quantity int not null,
    primary key (s_id, p_id, j_id),
    foreign key (s_id) references s(id),
    foreign key (p_id) references p(id),
    foreign key (j_id) references j(id)
);

-- Вывести поставщиков с наибольшим количеством деталей

-- Римские цифры
-- 1
-- получить номера изделий, для которых детали полностью поставляет поставщик номером (S1).
select distinct j_id
from spj s1
where not exists (
    select 1
    from spj s2
    where s2.j_id = s1.j_id
    and s2.s_id != "S1"
);

-- 2
-- Получить общее количество деталей с указанным номером, поставляемых некоторым поставщиком (параметры - номер детали (P1), номер поставщика (S1))
select sum(quantity) as idk
from spj
where s_id = "S1"
and p_id = "P1";

-- 3
-- Выдать номера изделий, использующих только детали, поставляемые некоторым поставщиком (параметр - номер поставщика (S1)).
select distinct j_id
from spj s1
where not exists (
    select 1
    from spj s2
    where s2.j_id = s1.j_id
    and s2.s_id != "S1"
);

select s.surname, s.city
from s
where raiting > 20;

-- 4
-- Получить общее число изделий, для которых поставляет детали поставщик с указанным номером (параметр - номер поставщика (S1)).
select count(distinct j_id) as sfw
from spj
where s_id = "S1";

-- 5
-- Выдать номера изделий, детали для которых поставляет каждый поставщик, поставляющий какую-либо деталь указанного цвета (параметр - цвет детали (красный)).
select distinct s1.j_id
from spj s1
where not exists (
    select 1
    from spj s
    join p d on s.p_id = d.id
    where d.color = "красный"
    and not exists(
        select 1
        from spj s2
        where s2.j_id = s1.j_id
        and s2.s_id = s.s_id
    )
);

-- 6
-- Получить полный список деталей для всех изделий, изготавливаемых в некотором городе (параметр - название города (Лондон)).
select d1.id, d1.name, d1.color, d1.city, d1.weight
from spj s1
join j p1 on s1.j_id = p1.id
join p d1 on s1.p_id = d1.id
where p1.city = "Лондон";

-- 7
-- Выдать номера деталей, поставляемых каким-либо поставщиком из указанного города (параметр - название города (Лондон)).
select d1.id, d1.name, d1.color, d1.city, d1.weight
from spj s1
join s s2 on s1.s_id = s2.id
join p d1 on s1.p_id = d1.id
where s2.city = "Лондон";

-- 8
-- Получить список всех поставок, в которых количество деталей находится в некотором диапазоне (параметры - границы диапазона (от 300 до 750)).
select *
from spj s1
where s1.quantity between 300 and 750;

-- 9
-- Выдать номера и названия деталей, поставляемых для какого-либо изделия из указанного города (параметр - название города (Лондон)).
select d1.id, d1.name
from p d1
join spj s1 on d1.id = s1.p_id
join j p1 on s1.j_id = p1.id
where p1.city = "Лондон";

-- 10
-- Получить цвета деталей, поставляемых некоторым поставщиком (параметр - номер поставщика (S1)).
select d1.color
from p d1
join spj s1 on d1.id = s1.p_id
join s s2 on s1.s_id = s2.id
where s2.id = "S1";

-- 11
-- Выдать номера и фамилии поставщиков, поставляющих некоторую деталь для какого-либо изделия в количестве, большем среднего объема поставок данной детали для этого изделия (параметр - номер детали (P1)).
select s1.id, s1.surname
from s s1
join spj s2 on s1.id = s2.s_id
where s2.p_id = "P1"
and s2.quantity > (
    select avg(s3.quantity)
    from spj s3
    where s3.p_id = "P1"
);

-- 12
-- Получить названия изделий, для которых поставляются детали некоторым поставщиком (параметр - номер поставщика (S1)).
select distinct p1.name
from j p1
join spj s1 on p1.id = s1.j_id
where s1.s_id = "S1";

-- Арабские цифры
-- 1
-- Изменить название и город детали с максимальным весом на указанные значения.
update p
set name = "Максимальный", city = "Большой"
where weight = (
    select max(weight)
    from p
);

-- 2
-- Вывести информацию о деталях, поставки которых были осуществлены для указанного изделия.
select d1.id, d1.name, d1.city, d1.color, d1.weight
from p d1
join spj s1 on d1.id = s1.p_id
where s1.j_id = "S1";

-- 3
-- Увеличить рейтинг поставщика, выполнившего большее число поставок, на указанную величину
update s
set raiting = raiting + 10
where id = (
    select s_id
    from spj s1
    group by s_id
    having count(*) = (
        select max(cnt)
        from (
            select count(*) as cnt
            from spj
            group by s_id
        ) as counts
    )
);

-- 4
-- Увеличить вес деталей из Лондона на некоторую величину.
update p
set weight = weight + 10
where city = "Лондон";