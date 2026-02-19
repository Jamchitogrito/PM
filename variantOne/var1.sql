create database HR_department;
use hr_department;

SET FOREIGN_KEY_CHECKS = 0;
SET FOREIGN_KEY_CHECKS = 1;

DROP TABLE IF EXISTS loads;
DROP TABLE IF EXISTS teachers;
DROP TABLE IF EXISTS discipline;
DROP TABLE IF EXISTS department;

create table department (
	code_department int primary key,
    name_department varchar(100),
    faculty varchar(100)
);
create table discipline (
	code_discipline int primary key,
    name_discipline varchar(100),
    course int,
    quantity_lectures int,
    number_of_seminars int,
    number_of_practical int
);
create table teachers (
	personnel_number int primary key,
    name_teacher varchar(100),
    sex char(1) not null default 'ж',
    birthday datetime,
    code_department int,
    position varchar(100),
    academic_degree varchar(100),
    academic_title varchar(100),
    foreign key (code_department) references department (code_department)
);
create table loads (
	id int primary key auto_increment,
    personnel_number int,
    code_discipline int,
    type_load varchar(100),
    foreign key (personnel_number) references teachers (personnel_number),
    foreign key (code_discipline) references discipline(code_discipline)
);


INSERT INTO department (code_department, name_department, faculty) VALUES (1, 'Математика', 'УУКСИВТ');
INSERT INTO department (code_department, name_department, faculty) VALUES (2, 'Физика', 'УУКСИВТ');
INSERT INTO department (code_department, name_department, faculty) VALUES (3, 'Информатика', 'ФИТ');

INSERT INTO discipline (code_discipline, name_discipline, course, quantity_lectures, number_of_seminars, number_of_practical) VALUES (1, 'Высшая математика', 1, 60, 30, 20);
INSERT INTO discipline (code_discipline, name_discipline, course, quantity_lectures, number_of_seminars, number_of_practical) VALUES (2, 'Квантовая физика', 2, 45, 25, 15);
INSERT INTO discipline (code_discipline, name_discipline, course, quantity_lectures, number_of_seminars, number_of_practical) VALUES (3, 'Алгоритмы и структуры данных', 3, 50, 35, 25);

INSERT INTO teachers (Personnel_number, name_teacher, sex, birthday, code_department, position, academic_degree, academic_title) VALUES (1001, 'Иванов Иван Иванович', 'м', '1980-05-15', 1, 'доцент', 'кандидат наук', 'доцент');
INSERT INTO teachers (Personnel_number, name_teacher, sex, birthday, code_department, position, academic_degree, academic_title) VALUES (1002, 'Петрова Анна Сергеевна', 'ж', '1975-11-20', 2, 'профессор', 'доктор наук', 'профессор');
INSERT INTO teachers (Personnel_number, name_teacher, sex, birthday, code_department, position, academic_degree, academic_title) VALUES (1003, 'Сидоров Петр Алексеевич', 'м', '1985-03-10', 3, 'преподаватель', 'кандидат наук', 'доцент');

INSERT INTO loads (Personnel_number, code_discipline, type_load) VALUES (1001, 1, 'лекция');
INSERT INTO loads (Personnel_number, code_discipline, type_load) VALUES (1002, 2, 'семинар');
INSERT INTO loads (Personnel_number, code_discipline, type_load) VALUES (1003, 3, 'практические занятия');

INSERT INTO teachers (personnel_number, name_teacher, sex, birthday, code_department, position, academic_degree, academic_title) VALUES (1004, 'Смирнова Мария Петровна', 'ж', '1990-07-22', 1, 'ассистент', NULL, NULL);
INSERT INTO teachers (personnel_number, name_teacher, sex, birthday, code_department, position, academic_degree, academic_title) VALUES (1005, 'Козлов Дмитрий Сергеевич', 'м', '1982-12-05', 2, 'доцент', 'кандидат наук', NULL);
INSERT INTO teachers (personnel_number, name_teacher, sex, birthday, code_department, position, academic_degree, academic_title) VALUES (1006, 'Федорова Ольга Ивановна', 'ж', '1978-09-18', 3, 'профессор', 'доктор наук', 'профессор');
INSERT INTO teachers (personnel_number, name_teacher, sex, birthday, code_department, position, academic_degree, academic_title) VALUES (1007, 'Михайлов Алексей Николаевич', 'м', '1988-04-30', 1, 'преподаватель', 'кандидат наук', NULL);
INSERT INTO teachers (personnel_number, name_teacher, sex, birthday, code_department, position, academic_degree, academic_title) VALUES (1008, 'Васильева Екатерина Владимировна', 'ж', '1983-01-15', 2, 'доцент', 'кандидат наук', 'доцент');
INSERT INTO teachers (personnel_number, name_teacher, sex, birthday, code_department, position, academic_degree, academic_title) VALUES (1009, 'Григорьев Сергей Михайлович', 'м', '1976-06-28', 3, 'старший преподаватель', 'кандидат наук', NULL);

INSERT INTO loads (personnel_number, code_discipline, type_load) VALUES (1004, 1, 'практические занятия');
INSERT INTO loads (personnel_number, code_discipline, type_load) VALUES (1005, 2, 'лекция');
INSERT INTO loads (personnel_number, code_discipline, type_load) VALUES (1006, 3, 'семинар');
INSERT INTO loads (personnel_number, code_discipline, type_load) VALUES (1007, 1, 'семинар');
INSERT INTO loads (personnel_number, code_discipline, type_load) VALUES (1008, 2, 'практические занятия');
INSERT INTO loads (personnel_number, code_discipline, type_load) VALUES (1009, 3, 'лекция');

INSERT INTO teachers (personnel_number, name_teacher, sex, birthday, code_department, position, academic_degree, academic_title) 
VALUES (1010, 'Николаева Дарья Андреевна', 'ж', '1995-02-10', 1, 'ассистент', NULL, NULL);

INSERT INTO loads (personnel_number, code_discipline, type_load) 
VALUES (1010, 1, 'лекция');

-- докторов наук с указанием названия кафедры и должности
select t.name_teacher, dep.name_department, t.position
from teachers t
join department dep on t.code_department = dep.code_department
WHERE t.academic_degree = 'доктор наук';

-- самых молодых преподавателей на каждой кафедре
select t.name_teacher, dep.name_department, t.birthday
from teachers t
join department dep on t.code_department = dep.code_department
inner join (
	select code_department, max(birthday) as birthdayMax
    from teachers
    group by code_department
) sub on t.code_department = sub.code_department and t.birthday = sub.birthdayMax
order by dep.code_department;

-- дисциплин и видов нагрузки, для которых не назначены преподаватели


-- кафедр, га которых работает менее 2-ух докторов наук
select dep.name_department, count(t.personnel_number) as 'количество докторов наук'
from department dep
left join teachers t on dep.code_department = t.code_department and t.academic_degree = 'доктор наук'
group by dep.name_department, dep.code_department
having count(t.personnel_number) < 2;

-- 2
SELECT 
    dep.name_department AS кафедра,
    t.academic_degree AS ученая_степень,
    COUNT(*) AS количество_преподавателей
FROM department dep
JOIN teachers t ON dep.code_department = t.code_department
GROUP BY dep.code_department, dep.name_department, t.academic_degree
ORDER BY dep.code_department, t.academic_degree;

-- Представление "Ассистенты читающие лекции".
create view assistent as
select t.name_teacher, t.position, l.type_load
from teachers t
join loads l on t.personnel_number = l.personnel_number
where l.type_load = "лекция" and t.position = "ассистент";

select * from assistent;

update assistent
set name_teacher = "pp"
where type_load = "лекция";

-- Второе

create view second as
select 
	d.name_discipline,
    d.quantity_lectures,
    lect.name_teacher as лектор,
    case when d.number_of_seminars > 0 then d.number_of_seminars else null end,
    sem.name_teacher as семинарник,
    case when d.number_of_practical > 0 then d.number_of_practical else null end,
	pract.name_teacher as практикант
from discipline d

left join loads l_lect on d.code_discipline = l_lect.code_discipline
	and l_lect.type_load = "лекция"
left join teachers lect on l_lect.personnel_number = lect.personnel_number

left join loads l_sem on d.code_discipline = l_sem.code_discipline
	and l_sem.type_load = "семинар"
left join teachers sem on l_sem.personnel_number = sem.personnel_number

left join loads l_pract on d.code_discipline = l_pract.code_discipline
	and l_pract.type_load = "практические занятия"
left join teachers pract on l_pract.personnel_number = pract.personnel_number;

select * from second;

update second
set name_discipline = "йй";

-- Третье

create view teacher_work as
select 
    t.name_teacher as фио_преподавателя,
    d.name_discipline as дисциплина,

    case 
        when l.type_load = 'лекция' then d.quantity_lectures * 2 
        else 0 
    end as количество_лекционных_часов,

    case 
        when l.type_load = 'семинар' then d.number_of_seminars 
        else 0 
    end as количество_семинаров,

    case 
        when l.type_load = 'практические занятия' then d.number_of_practical 
        else 0 
    end as количество_практических,

    case 
        when l.type_load = 'лекция' then d.quantity_lectures * 2
        else 0 
    end +
    case 
        when l.type_load = 'семинар' then d.number_of_seminars 
        else 0 
    end +
    case 
        when l.type_load = 'практические занятия' then d.number_of_practical 
        else 0 
    end as общее_количество_часов

from teachers t
join loads l on t.personnel_number = l.personnel_number
join discipline d on l.code_discipline = d.code_discipline
order by t.name_teacher, d.name_discipline;

select * from teacher_work;

update teacher_work 
set количество_лекционных_часов = 999
where фио_преподавателя = 'Иванов Иван Иванович';


-- Триггеры по теме: "БД Отдела кадров института"

















