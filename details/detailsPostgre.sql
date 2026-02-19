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

create view task18 as
select p1.id, p1.weight, p1.city
from spj
join p p1 on spj.p_id = p1.id
order by p1.weight desc ;

select * from task18;

drop view task18;

create view task18and2 as
    select p1.id, p1.city, j1.city
    from spj spj1
    join p p1 on spj1.p_id = p1.id
    join j j1 on spj1.j_id = j1.id
    where p1.city = j1.city
    order by p1.id;

create view task19 as
    select distinct s1.id, s1.surname, s1.city, p1.id as "p1 id", p1.city as "p1 city"
    from s s1
    join spj spj1 on s1.id = spj1.s_id
    left join p p1 on spj1.p_id = p1.id
    where s1.city = p1.city;

select * from task19;
drop view task19;

update task19
set surname = 'asd'
where "p1 city" = 'Лондон';