-- drop database if exists rcttc;
-- create database rcttc;
use rcttc;

create table customer (
	customer_id int primary key auto_increment,
    first_name varchar(20) not null,
    last_name varchar(30) not null,
    customer_email varchar(30) not null,
    customer_phone varchar(15) null,
    customer_address varchar(100) null
);

create table theater (
	theater_id int primary key auto_increment,
    theater_name varchar(40) not null,
    theater_email varchar(30) not null,
    theater_phone varchar(15) not null,
    theater_address varchar(100) not null
);

create table `show` (
	show_id int primary key auto_increment,
    show_name varchar(50) not null
);

create table ticket (
	ticket_id int primary key auto_increment,
    seat varchar(4) not null,
    price decimal(5, 2) not null,
    `date` date not null,
    show_id int not null,
    customer_id int not null,
    theater_id int not null,
    constraint fk_ticket_show_id
		foreign key (show_id)
        references `show`(show_id),
	constraint fk_ticket_customer_id
		foreign key (customer_id)
        references customer(customer_id),
	constraint fk_ticket_theater_id
		foreign key (theater_id)
        references theater(theater_id)
);


