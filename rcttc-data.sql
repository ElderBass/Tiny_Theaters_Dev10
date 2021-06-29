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

-- UPDATES

-- 	The Little Fitz's 2021-03-01 performance of The Sky Lit Up is listed with a $20 ticket price. 
-- 		The actual price is $22.25 because of a visiting celebrity actor. (Customers were notified.) 
-- 		Update the ticket price for that performance only.

select * from `show` where show_name = "The Sky Lit Up"; -- ID for The Sky Lit Up = 4;
select * from theater where theater_name = "Little Fitz"; -- ID for Little Fitz theater = 2

update ticket set
	price = 22.25 -- Update with new price
    where `date` = DATE('2021-03-01') and show_id = 4 and theater_id = 2; 
    -- Have to enter date, show_id, and theater_id since in theory this show could run on multiple dates at multiple theaters

select * from ticket where `date` = DATE('2021-03-01') and show_id = 4 and theater_id = 2; -- Confirm change was made

-- In the Little Fitz's 2021-03-01 performance of The Sky Lit Up, Pooh Bedburrow and Cullen Guirau seat reservations aren't in the same row.
--    	Adjust seating so all groups are seated together in a row. This may require updates to all reservations for that performance.
-- 		Confirm that no seat is double-booked and that everyone who has a ticket is as close to their original seat as possible.

select price from ticket
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

select * from customer order by first_name asc; -- Find that Jammie's ID = 48

update customer set customer_phone = "1-801-EAT-CAKE" where customer_id = 48; -- Update Jammie's phone

select * from customer where customer_id = 48; -- Confirm change was made

-- DELETES

-- 	DELETE all single-ticket reservations at the 10 Pin. (You don't have to do it with one query.)

select * from theater where theater_name = "10 Pin"; -- ID for 10 Pin = 1

select count(*), concat(c.first_name, " ", c.last_name) as customer_name, c.customer_id
from ticket ti
join theater th on ti.theater_id = th.theater_id
join customer c on ti.customer_id = c.customer_id
where th.theater_id = 1
group by customer_name
having count(*) = 1;

-- Count   Name           customer_id
-- 1	Hertha Glendining	7
-- 1	Flinn Crowcher		8
-- 1	Lucien Playdon		10
-- 1	Brian Bake			15
-- 1	Loralie Rois		18
-- 1	Emily Duffree		19
-- 1	Giraud Bachmann		22
-- 1	Melamie Feighry		25
-- 1	Caye Treher			26

delete from ticket where theater_id = 1 and customer_id in (7, 8, 10, 15, 18, 19, 22, 25, 26); -- Delete all relevant tickets

-- Confirm no single reservations still exist
select count(*), concat(c.first_name, " ", c.last_name) as customer_name, c.customer_id
from ticket ti
join theater th on ti.theater_id = th.theater_id
join customer c on ti.customer_id = c.customer_id
where th.theater_id = 1
group by customer_name
order by count(*) asc;

-- NEW DATASET FOR 10 Pin

-- Count    Name              customer_id
-- 2	Sigvard Hammett			3
-- 2	Damara Whieldon			9
-- 2	Jayme Heberden			13
-- 2	Fernande Kincade		14
-- 2	Hannis Ruttgers			17
-- 2	Lynda Broadfield		27
-- 2	Ashly Earnshaw			28
-- 2	Kurtis Gallie			34
-- 3	Sarine Bergstrand		4
-- 3	Therine Colnett			5
-- 3	Wilt Giaomozzo			6
-- 3	Maximilianus Kasparski	11
-- 3	Briny Dalziell			20
-- 3	Thorsten Lamplugh		23
-- 3	Annice Agney			29
-- 3	Merissa Strelitzki		30
-- 3	Jordain Ceresa			31
-- 3	Frans Fleckney			32
-- 4	Lise Eles				2
-- 4	Koo Noen				12
-- 4	Jong Cosgreave			21
-- 4	Barclay Jentle			24
-- 4	Thatcher Roubay			33
-- 6	Joice Belford			1
-- 6	Roma Ingraham			16

-- 	DELETE the customer Liv Egle of Germany. It appears their reservations were an elaborate joke.

select * from customer order by first_name asc; -- Liv Egle of Germany's id = 65

delete from ticket where customer_id = 65; -- Have to delete children of Liv first (tickets she bought) before we can delete her
delete from customer where customer_id = 65; -- Now we can delete Liv from database

select * from customer order by first_name asc; -- Confrim Liv is no longer in database