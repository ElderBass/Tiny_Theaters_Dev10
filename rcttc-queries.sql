use rcttc;

-- Find all performances in the last quarter of 2021 (Oct. 1, 2021 - Dec. 31 2021).

select * from ticket
where `date` between "2021-08-01" and "2021-12-31"
order by `date` asc;

-- List customers without duplication.

select concat(first_name, " ", last_name) as customer_name, 
customer_email,
customer_phone, 
customer_address, 
customer_id
from customer
group by customer_name -- turns out this wasn't even necessary
order by customer_name asc;

-- Find all customers without a .com email address.

select concat(first_name, " ", last_name) as customer_name, 
customer_email,
customer_phone, 
customer_address, 
customer_id
from customer
where customer_email like "%.com"
order by customer_name asc;

-- Find the three cheapest shows.

select t.price, s.show_name from ticket t
join `show` s on t.show_id = s.show_id
group by s.show_name
order by t.price asc
limit 3;

-- List customers and the show they're attending with no duplication.

select concat(first_name, " ", last_name) as customer_name, 
customer_email,
`show`.show_name
from customer
join ticket on ticket.customer_id = customer.customer_id
join `show` on `show`.show_id = ticket.show_id
group by customer_name
order by customer_name asc;

-- List customer, show, theater, and seat number in one query.

select th.theater_name, s.show_name, concat(c.first_name, " ", c.last_name) as customer_name, ti.seat 
from customer c
join ticket ti on ti.customer_id = c.customer_id
join `show` s on s.show_id = ti.show_id
join theater th on th.theater_id = ti.theater_id
order by th.theater_name asc, s.show_name asc, ti.seat asc;

-- Find customers without an address.

select * from customer
where customer_address = "" or customer_address is null;

-- Recreate the spreadsheet data with a single query.

-- first last customer_email customer_phone	customer_address seat show ticket_price	date theater theater_address theater_phone theater_email

select c.first_name, c.last_name, c.customer_email, c.customer_phone, c.customer_address,
ti.seat, s.show_name, ti.price, ti.date,
th.theater_name, th.theater_address, th.theater_phone, th.theater_email
from customer c
join ticket ti on ti.customer_id = c.customer_id
join `show` s on s.show_id = ti.show_id
join theater th on th.theater_id = ti.theater_id
order by th.theater_name asc, s.show_name asc, ti.date asc, c.first_name asc, c.last_name asc; 

-- Count total tickets purchased per customer.

select count(*) as tickets_purchased, concat(c.first_name, " ", c.last_name) as customer_name
from ticket ti
join customer c on c.customer_id = ti.customer_id
group by customer_name
order by tickets_purchased asc;

-- Calculate the total revenue per show based on tickets sold.

select sum(ti.price) as total_revenue, s.show_name
from ticket ti
join `show` s on s.show_id = ti.show_id
group by s.show_name
order by total_revenue asc;

-- Calculate the total revenue per theater based on tickets sold. 

select th.theater_name, count(*) as tickets_sold, sum(ti.price) as total_revenue
from ticket ti
join theater th on th.theater_id = ti.theater_id
group by th.theater_name
order by total_revenue asc;

-- Who is the biggest supporter of RCTTC? Who spent the most in 2021?

select concat(c.first_name, " ", c.last_name) customer_name, count(*) tickets_purchased, sum(ti.price) total_money_spent
from customer c
join ticket ti on c.customer_id = ti.customer_id
group by customer_name
order by total_money_spent desc
limit 1;
