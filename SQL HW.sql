use sakila;

-- 1a. Display the first and last names of all actors from the table actor.

select first_name, last_name
From actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

select Upper(concat(first_name,' ',last_name)) as 'Actor Name'
From actor;


-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

Select * From actor;

select actor_id ,first_name, last_name
from actor
where first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:
select actor_id ,first_name, last_name
from actor
where last_name like '%Gen%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

select actor_id ,first_name, last_name
from actor
where last_name like '%LI%'
ORDER BY last_name asc, first_name asc ;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id ,country
from country
Where country in ('Afghanistan','Bangladesh','China');

/*3a. You want to keep a description of each actor.
 You don't think you will be performing queries on a description, 
 so create a column in the table actor named description and use the data type BLOB*/
 
 Select * From actor;
 
 
Alter table actor
add column description blob;

-- Delete the description column.

Alter table actor
drop description;
 
 -- List the last names of actors, as well as how many actors have that last name.
 
 select last_name ,  Count(*)
from actor
Group By last_name;

/* 4b. List last names of actors and the number of actors who have that last name, 
but only for names that are shared by at least two actors*/

select last_name ,  Count(*)
from actor
Group By last_name
Having Count(*) > 1;

/*4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
Write a query to fix the record.*/


update actor
set first_name = 'Harpo'
where first_name = 'Groucho' and last_name = 'WILLIAMS';

select actor_id ,first_name, last_name
from actor
where first_name = 'Harpo';

/*4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all!
 In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.*/

Set SQL_Safe_Updates = 0;

update actor
set first_name = 'GROUCHO'
where first_name = 'Harpo' and last_name = 'WILLIAMS';

select actor_id ,first_name, last_name
from actor
where first_name = 'GROUCHO';

Set SQL_Safe_Updates = 1;

/* 5a. You cannot locate the schema of the address table. 
Which query would you use to re-create it?*/

SHOW CREATE table address;

/*6a. Use JOIN to display the first and last names, as well as the address, 
of each staff member.
Use the tables staff and address:*/

Select staff.first_name, staff.last_name,address.address 
From address
join staff
where staff.address_id = address.address_id ;

/*6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
Use tables staff and payment.*/

Select * from payment;

Select staff.first_name, staff.last_name, Sum(payment.amount) as 'Total Amount'
From payment
inner join staff
where staff.staff_id = payment.staff_id and payment_date like '%2005-08%'
group by first_name, last_name;

/*6c. List each film and the number of actors who are listed for that film.
 Use tables film_actor and film. Use inner join.*/
 
Select film.title, count(film_actor.actor_id) as 'Number of Actors'
From film_actor
join film
where film.film_id = film_actor.film_id 
group by film.title;

/*6d. How many copies of the film Hunchback Impossible exist in the inventory system?*/

Select film.title, count(inventory.film_id) as 'Number of Copies'
From inventory
join film
where film.film_id = inventory.film_id and title ='Hunchback Impossible'
group by film.title;
 
 /*6e. Using the tables payment and customer and the JOIN command, 
 list the total paid by each customer.
 List the customers alphabetically by last name:*/
 
Select customer.first_name, customer.last_name, sum(payment.amount) as 'Total Amount Paid'
From payment
inner join customer
where customer.customer_id = payment.customer_id
group by customer.first_name,customer.last_name
order by last_name asc, first_name asc;

/*7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence.
 As an unintended consequence, films starting with the letters K and Q have also soared in popularity.
 Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.*/
 
select title 
from film
where title like 'K%' or title like 'Q%' and language_id in 
	(
		select language_id 
		from language
		where name = 'English'
	);

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

select concat(first_name,' ', last_name ) as 'Actors in Alone Trip'
		from actor
		where actor_id in

	(
		select actor_id 
		from film_actor
		where film_id in
			(
			select film_id 
			from film
			where title = 'Alone Trip'
			)
	);
    
/*7c. You want to run an email marketing campaign in Canada, 
for which you will need the names and email addresses of all Canadian customers. 
Use joins to retrieve this information.*/


select customer.first_name, customer.last_name, customer.email
From customer
join address on customer.address_id = address.address_id
Join city on address.city_id = city.city_id
Join country on city.country_id=country.country_id
where country = 'Canada';

/*7d. Sales have been lagging among young families, 
and you wish to target all family movies for a promotion. 
Identify all movies categorized as family films.*/

select film.title, category.name
From film
Join film_category on film_category.film_id = film.film_id
Join category on film_category.category_id = category.category_id
where name = 'Family';

/* Display the most frequently rented movies in descending order.*/

select film.title, count(rental.rental_id)
From film
Join inventory on film.film_id = inventory.film_id
Join rental on inventory.inventory_id = rental.inventory_id
Group by film.title
order by count(rental.rental_id) desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in.

select * From payment;

select store.store_id, Sum(payment.amount) as 'Store Revenue'
From store
Join staff on staff.store_id = store.store_id
Join payment on staff.staff_id = payment.staff_id
group by store_id;

-- 7g. Write a query to display for each store its store ID, city, and country.

select store.store_id, city.city, country.country
From store
Join address on store.address_id = address.address_id
Join city on address.city_id = city.city_id
Join country on city.country_id = country.country_id;



/*7h. List the top five genres in gross revenue in descending order. 
(Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)*/

select * from category
group by name;

select category.name, sum(payment.amount) as 'Gross Revenue' 
From category
Join film_category on category.category_id = film_category.category_id
Join inventory on film_category.film_id = inventory.film_id
Join rental on inventory.inventory_id = rental.inventory_id
Join payment on rental.rental_id = payment.rental_id
group by category.name
order by sum(payment.amount) desc
limit 5;

/*8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
Use the solution from the problem above to create a view. 
If you haven't solved 7h, you can substitute another query to create a view.*/

create view Top_Five_Genres as  
select category.name, sum(payment.amount) as 'Gross Revenue' 
From category
Join film_category on category.category_id = film_category.category_id
Join inventory on film_category.film_id = inventory.film_id
Join rental on inventory.inventory_id = rental.inventory_id
Join payment on rental.rental_id = payment.rental_id
group by category.name
order by sum(payment.amount) desc
limit 5;

select * from Top_Five_Genres;

-- 8b. How would you display the view that you created in 8a?

select * from Top_Five_Genres;

-- 8c You find that you no longer need the view top_five_genres. Write a query to delete it.

drop view Top_Five_Genres;

