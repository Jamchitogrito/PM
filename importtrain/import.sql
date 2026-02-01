create database importtrain;

drop table if exists product;
drop table if exists user;
drop table if exists pick_up_point;
drop table if exists order_items;
drop table if exists orders;

create table product(
	article varchar(6) primary key,
    product_name varchar(15),
    price int,
    supplier varchar(15),
    manufacture varchar(15),
    categry varchar(15),
    discount int,
    count int,
    description varchar(100),
    photo varchar(10)
);

create table user(
	id int primary key,
    role varchar(25),
    name varchar(35),
    login varchar(25),
    password varchar(25)
);

create table order_pick_ip_point(
	id int primary key,
    point_index varchar(6),
    city varchar(10),
    street varchar(25),
    house int
);

create table orders(
	id int primary key,
    order_article int unique,
    order_date varchar(10),
    data_of_receipt varchar(10),
    pick_up_point_id int,
    user_id int,
    recive_code int,
    order_status varchar(10),
    foreign key (user_id) references user(id),
    foreign key (pick_up_point_id) references order_pick_ip_point(id)
);
create table order_items(
	id int primary key auto_increment,
	order_article int,
    product_article varchar(6),
    count int,
    foreign key (product_article) references product(article),
    foreign key (order_article) references orders(order_article)
);


















