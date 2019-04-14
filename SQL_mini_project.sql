/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

/*Code for Q1 Answer */
SELECT * 
FROM Facilities
WHERE membercost >0

/* Answers to Q1: */
Tennis Court 1
Tennis Court 2
Massage Room 1
Massage Room 2
Squash Court

/* Q2: How many facilities do not charge a fee to members? */

/* Code for Q2 Answer */
SELECT * 
FROM Facilities
WHERE membercost =0

/* Answers to Q2: */
Badminton Court
Table Tennis
Snooker Table
Pool Table

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

/* Code for Q3: */
SELECT facid, name AS facility_name, membercost, monthlymaintenance
FROM Facilities
WHERE membercost < ( monthlymaintenance * 0.20 ) -- where member fee is less than 20% of montly maintenance cost
AND membercost >0  -- where facility charges a fee to members

/* Answers to Q3: */
Tennis Court 1
Tennis Court 2
Massage Room 1
Massage Room 2
Squash Court

/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

/* Code for Q4: */
SELECT * 
FROM  Facilities
WHERE facid
IN ( 1, 5 ) 

/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

/* Code for Q5: */
SELECT name, monthlymaintenance, 
CASE WHEN monthlymaintenance >100
THEN  'expensive' --labels all monthly maintenance over $100 as 'expensive'
ELSE  'cheap' -- Labels all others not meeting the case above as 'cheap'
END AS cost -- creates new label column "cost" to identify maintenance cost as expensive or cheap
FROM Facilities

/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

/* Code for Q6: */ 
SELECT surname, firstname, joindate
FROM Members
ORDER BY joindate DESC --Lists members by join date, with most recent date first

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

/* Code for Q7: */
SELECT DISTINCT B.memid AS mem_id, CONCAT( CONCAT( M.surname,  ' ' ) , M.firstname ) AS mem_name, B.facid, F.name AS fac_name
FROM Bookings B
JOIN Facilities F ON B.facid = F.facid -- Join Facilities name and id columns to selected columns from Bookings
JOIN Members M ON B.memid = M.memid -- Join Members id and concatenated name column to joined table
WHERE F.name =  'Tennis Court 1' -- Select for Tennis Court 1 or 2 as facility name
OR F.name =  'Tennis Court 2'
ORDER BY mem_name -- Order by member name


/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

/* Code for Q8: */
SELECT F.name AS fac_name, IF( B.memid =0, F.guestcost * B.slots, F.membercost * B.slots ) AS cost, CONCAT( CONCAT( M.surname,  ' ' ) , M.firstname ) AS mem_name
FROM Bookings B
JOIN Facilities F ON B.facid = F.facid -- Join Facilities name and id columns to selected columns from Bookings
JOIN Members M ON B.memid = M.memid -- Join Members id and concatenated name column to joined tabl
WHERE starttime >=  '2012-09-14 00:00:00' -- Filter results to only include times on 2012-09-14
AND starttime <  '2012-09-15 00:00:00'
HAVING cost >30 -- Filter results for cost above $30
ORDER BY cost DESC  -- Reorder results by cost, with highest cost first

/* Q9: This time, produce the same result as in Q8, but using a subquery. */

/* Code for Q9: */
SELECT F.name AS fac_name, IF( B.memid =0, F.guestcost * B.slots, F.membercost * B.slots ) AS cost, CONCAT( CONCAT( M.surname,  ' ' ) , M.firstname ) AS mem_name
FROM (
SELECT facid, slots, memid --subquery to select date
FROM Bookings
WHERE starttime >=  '2012-09-14 00:00:00'
AND starttime <  '2012-09-15 00:00:00'
) B
JOIN Facilities F ON B.facid = F.facid --join Facilities
JOIN Members M ON B.memid = M.memid -- join Members
HAVING cost >30 --filtering for cost greater than $30
ORDER BY cost DESC -- Reorder results by cost, with highest cost first

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

/* Code for Q10: */
SELECT F.name AS fac_name, SUM( IF( B.memid =0, F.guestcost * B.slots, F.membercost * B.slots ) ) AS total_revenue --Sum calculated revenues based on bookings
FROM Bookings B
JOIN Facilities F ON B.facid = F.facid -- Join Facilities name column to table
JOIN Members M ON B.memid = M.memid -- Join Members columns to table
GROUP BY fac_name -- Group revenue by facility name
HAVING total_revenue <1000 -- Filter results for facilities with a total revenue less than $1000
ORDER BY total_revenue -- Reorder results by total revenue
