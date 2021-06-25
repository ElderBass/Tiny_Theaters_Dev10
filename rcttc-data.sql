use rcttc;

-- insert into province_state (province_state_name)
-- 	select distinct host_state as state
-- 	from all_reservations
-- 	union    
-- 	select distinct guest_state as state
-- 	from all_reservations
-- 	order by state;

insert into customer (first_name, last_name, customer_email, customer_phone, customer_address)
	select distinct customer_first as first_name, customer_last as last_name, customer_email, customer_phone, customer_address
    from rcttc_data;

select * from customer;
    
--     	theater_id int primary key auto_increment,
--     theater_name varchar(40) not null,
--     theater_email varchar(30) not null,
--     theater_phone varchar(15) not null,
--     theater_address varchar(40) not null
    
insert into theater (theater_name, theater_email, theater_phone, theater_address)
	select distinct theater, theater_email, theater_phone, theater_address
    from rcttc_data;

select * from theater;
    
--     	show_id int primary key auto_increment,
--     show_name varchar(50) not null,
--     theater_id int not null,
--     constraint fk_show_theater_id
-- 		foreign key (theater_id)
--         references theater(theater_id)

-- insert into user (first_name, last_name, email, phone, province_state_id)
-- 	select distinct host_first_name, host_last_name, host_email, host_phone, ps.province_state_id
-- 	from all_reservations ar
-- 	join province_state ps on ps.province_state_name = ar.host_state;

insert into `show` (show_name, theater_id)
	select distinct rc.`show`, t.theater_id
    from rcttc_data rc
    join theater t on t.theater_name = rc.theater;
    
select * from `show`;

-- 	ticket_id int primary key auto_increment,
--     seat varchar(4) not null,
--     price decimal(5, 2) not null,
--     `date` date not null,
--     show_id int not null,
--     customer_id int not null,
--     constraint fk_ticket_show_id
-- 		foreign key (show_id)
--         references `show`(show_id),
-- 	constraint fk_ticket_customer_id
-- 		foreign key (customer_id)
--         references customer(customer_id)

insert into ticket (seat, price, `date`, show_id, customer_id)
	select distinct rc.seat, rc.ticket_price, rc.`date`, s.show_id, c.customer_id
    from rcttc_data rc
    join `show` s on s.show_name = rc.`show`
    join customer c on c.customer_email = rc.customer_email;
    