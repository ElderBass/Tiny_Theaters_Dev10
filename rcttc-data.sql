use rcttc;

insert into customer (first_name, last_name, customer_email, customer_phone, customer_address)
	select distinct customer_first as first_name, customer_last as last_name, customer_email, customer_phone, customer_address
    from rcttc_data;

-- select * from customer;
    
insert into theater (theater_name, theater_email, theater_phone, theater_address)
	select distinct theater, theater_email, theater_phone, theater_address
    from rcttc_data;

-- select * from theater;
    
insert into `show` (show_name)
	select distinct `show` as show_name
    from rcttc_data;
    
-- select * from `show`;

insert into ticket (seat, price, `date`, show_id, customer_id, theater_id)
	select distinct rc.seat, rc.ticket_price, rc.`date`, s.show_id, c.customer_id, t.theater_id
    from rcttc_data rc
    join `show` s on s.show_name = rc.`show`
    join customer c on c.customer_email = rc.customer_email
    join theater t on t.theater_name = rc.theater;
    

select * from ticket;
    