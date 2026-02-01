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


-- Арабские цифры
-- 1
-- Изменить название и город детали с максимальным весом на указанные значения.
update p
set name = 'Максимальный', city = 'Большой'
where weight = (
    select max(weight)
    from p
);

-- 2
-- Вывести информацию о деталях, поставки которых были осуществлены для указанного изделия.
select d1.id, d1.name, d1.city, d1.color, d1.weight
from p d1
join spj s1 on d1.id = s1.p_id
where s1.j_id = 'S1';

select *
from p;

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
where city = 'Лондон';

create schema detail_schema;

create table details_schema.s(
    id varchar(6) primary key not null,
    surname varchar(20) not null,
    raiting int not null,
    city varchar(20) not null
);

create table details_schema.p (
    id varchar(6) primary key not null,
    name varchar(20) not null,
    color varchar(20) not null,
    city varchar(20) not null,
    weight int not null
);

create table  details_schema.j (
    id varchar(6) primary key not null,
    name varchar(20) not null,
    city varchar(20) not null
);

create table details_schema.spj (
    s_id varchar(6) not null,
    p_id varchar(6) not null,
    j_id varchar(6) not null,
    quantity int not null,
    primary key (s_id, p_id, j_id),
    foreign key (s_id) references details_schema.s(id),
    foreign key (p_id) references details_schema.p(id),
    foreign key (j_id) references details_schema.j(id)
);
\dn
SET search_path TO details_schema, public;