use rcttc;

-- Find all performances in the last quarter of 2021 (Oct. 1, 2021 - Dec. 31 2021).

select * from ticket
where `date` between "2021-08-01" and "2021-12-31"
order by `date` asc;

-- List customers without duplication.
-- Find all customers without a .com email address.
-- Find the three cheapest shows.
-- List customers and the show they're attending with no duplication.
-- List customer, show, theater, and seat number in one query.
-- Find customers without an address.
-- Recreate the spreadsheet data with a single query.
-- Count total tickets purchased per customer.
-- Calculate the total revenue per show based on tickets sold.
-- Calculate the total revenue per theater based on tickets sold.
-- Who is the biggest supporter of RCTTC? Who spent the most in 2021?