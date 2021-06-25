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
    
-- select * from ticket;

-- Updates
-- 	The Little Fitz's 2021-03-01 performance of The Sky Lit Up is listed with a $20 ticket price. 
-- 		The actual price is $22.25 because of a visiting celebrity actor. (Customers were notified.) 
-- 		Update the ticket price for that performance only.

select * from `show`;

update ticket set
	price = 22.25
    where `date` = DATE('2021-03-01') and show_id = 4;

select * from ticket where `date` = DATE('2021-03-01') and show_id = 4;

-- In the Little Fitz's 2021-03-01 performance of The Sky Lit Up, Pooh Bedburrow and Cullen Guirau seat reservations aren't in the same row.
--    	Adjust seating so all groups are seated together in a row. This may require updates to all reservations for that performance.
-- 		Confirm that no seat is double-booked and that everyone who has a ticket is as close to their original seat as possible.

select * from ticket
join customer on customer.customer_id = ticket.customer_id
where `date` = DATE('2021-03-01') and show_id = 4;

-- Plan = move Hashim's group (tickets 93 and 94) to A1, A2
-- 		= move Gordon from A1 to C1 (ticket 92)
-- 		= move Cullen's group to A3, A4 (tickets 99, 100)
-- 		= swap Pooh's A4 ticket for B4 (ticket 98)

update ticket set seat = "C1" where ticket_id = 92; -- Moved Gordon from A1 to C1
update ticket set seat = "A1" where ticket_id = 93; -- Moved one of Hashim's party to now empty A1 on other side of second person in party, vacating A3
update ticket set seat = "A3" where ticket_id = 100; -- Moved one of Cullen's party from B4 to now vacant A3
update ticket set seat = "A4" where ticket_id = 99; -- Moved other of Cullen's party from C1 to A4
update ticket set seat = "B4" where ticket_id = 98; -- Moved outlier in Pooh's group from A4 into B4 with rest of squad in row B

select * from ticket
join customer on customer.customer_id = ticket.customer_id
where `date` = DATE('2021-03-01') and show_id = 4
order by seat asc;
-- confirmed all parties in same rows - data looks good

-- Update Jammie Swindles's phone number from "801-514-8648" to "1-801-EAT-CAKE".


    