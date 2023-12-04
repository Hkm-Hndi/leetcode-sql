
175. Combine Two Tables

/* Write your PL/SQL query statement below */
select firstName, lastName, city, state from person a left join address b on (a.personid=b.personid) 

176. Second Highest Salary
select (select salary  from (
select  salary, dense_rank() over (order by salary desc) as rnk from Employee
) aa
where rnk=2 and rownum<2) as SecondHighestSalary  from dual

185. Department Top Three Salaries
/* Write your PL/SQL query statement below */
select department, employee, salary from (
select d.name as Department, e.name as Employee, e.salary, dense_rank() over (partition by departmentId order by salary desc) as rank from Employee e inner join Department d on (e.departmentId=d.id)
)
where rank<4

177. Nth Highest Salary
CREATE FUNCTION getNthHighestSalary(N IN NUMBER) RETURN NUMBER IS
result NUMBER;
BEGIN
    /* Write your PL/SQL query statement below */
select (select salary  from (
select  salary, dense_rank() over (order by salary desc) as rnk from Employee
) aa
where rnk=N and rownum<2) as nthHighestSalary into result  from dual;

    RETURN result;
END;



1527. Patients With a Condition
select * from Patients
where conditions like 'DIAB1%' or conditions like '% DIAB1%';


180. Consecutive Numbers
select distinct num ConsecutiveNums  from
(select id, num, lag (num, 1) over (order by id) as lg1, lag (num, 2) over (order by id) as lg2
from logs) 
where num=lg1 and num=lg2;

1084. Sales Analysis III
select distinct p.product_id  , p.product_name  from Sales  s inner join Product  p on(s.product_id=p.product_id) where sale_date>='2019-01-01' and sale_date<'2019-04-01'  
and not exists(select 1 from sales ss where ss.product_id=s.product_id and 
(ss.sale_date<'2019-01-01' or ss.sale_date>'2019-03-31' ));
///
SELECT Product.product_id, Product.product_name FROM Product 
JOIN Sales 
ON Product.product_id = Sales.product_id 
GROUP BY Sales.product_id 
HAVING MIN(Sales.sale_date) >= "2019-01-01" AND MAX(Sales.sale_date) <= "2019-03-31";

178. Rank Scores
select score, dense_rank() over (order by score desc) as rank from scores
order by rank


184. Department Highest Salary
select DEPARTMENT, EMPLOYEE , salary from (select d.name as DEPARTMENT, e.name as EMPLOYEE , e.salary, rank() over (partition by e.departmentID order by salary desc) as rank from employee e inner join department d on (e.departmentid=d.id))
where rank=1

585. Investments in 2016
with cte as (
select tiv_2016,
count(tiv_2015) over(partition by tiv_2015) same_2015,
count(lat||lon) over(partition by lat||lon) same_loc
from insurance)
select sum(tiv_2016) tiv_2016 from cte where same_loc = 1 and same_2015 > 1

511. Game Play Analysis I
select player_id, min (to_char(event_date, 'YYYY-MM-DD')) as  first_login from activity
group by player_id


570. Managers with at Least 5 Direct Reports
select name from employee where id in (select managerId from  employee group by managerId having count(*)>=5)

182. Duplicate Emails
select email  from Person  group by email having count(*)>1

183. Customers Who Never Order
select name as Customers  from customers a where not exists
(select 1 from orders b where a.id=b.customerId)

196. Delete Duplicate Emails
delete from Person
where id not in (select min(id) from Person group by email)

181. Employees Earning More Than Their Managers
select e1.name as Employee  from employee e1 left join employee e2 on e1.managerId=e2.id
where e1.salary>e2.salary

197. Rising Temperature
select id from (
select id, recordDate , temperature, lag(temperature ) over(order by recordDate) as prev_temp, lag(recordDate) over(order by recordDate) as prev_date from Weather 
) where temperature> prev_temp and recordDate -prev_date=1  

577. Employee Bonus
select name, bonus from employee e left join bonus b on e.empId=b.empId
where nvl(bonus,0)<1000

608. Tree Node
select id, case when t1.p_id is null then 'Root'
when t1.p_id is not null and nvl(children,0)>0 then 'Inner '
else 'Leaf' end as type    from tree t1 left join (select p_id, count(*) children from tree group by p_id) t2 on t1.id=t2.p_id
order by 1
///
SELECT id AS id, 
    CASE 
        WHEN p_id is NULL THEN 'Root'
        WHEN id in (SELECT p_id FROM Tree) THEN 'Inner'
        ELSE  'Leaf'
    END AS type
    FROM Tree;


550. Game Play Analysis IV
SELECT ROUND(AVG(CASE WHEN DRV_DT - EVENT_DATE = 1 THEN 1 ELSE 0
END), 2) FRACTION FROM (
SELECT PLAYER_ID, 
EVENT_DATE, LEAD(EVENT_DATE, 1) OVER (PARTITION BY PLAYER_ID ORDER BY EVENT_DATE) DRV_DT,
ROW_NUMBER() OVER (PARTITION BY PLAYER_ID ORDER BY EVENT_DATE) RN
FROM ACTIVITY
)WHERE RN = 1;

1341. Movie Rating
select name as results from (select * from users u inner join (select user_id, count(*) as count_ from movierating
group by user_id) mr on (u.user_id=mr.user_id)
order by count_ desc, name asc) where rownum<2
union all
select title from (select * from Movies  m inner join (select movie_id, avg(rating) as avg_rating from movierating
where created_at>='2020-Feb-01' and created_at<'2020-Mar-01'
group by movie_id) mr on (m.movie_id=mr.movie_id)
order by avg_rating desc, title asc) where rownum<2

1045. Customers Who Bought All Products
select customer_id
from customer
group by customer_id
having count(distinct product_key)=(select count(*) from product)

1070. Product Sales Analysis III
select product_id, year as first_year, quantity, price from sales
where (product_id, year) in (select product_id, min (year) from sales
group by product_id)
//
select product_id, year as first_year, quantity, price from (select product_id, year, quantity, price, rank() over (partition by product_id order by year) as rnk from sales)
where rnk=1

1141. User Activity for the Past 30 Days I
select to_char(activity_date, 'YYYY-MM-DD') as day, count(distinct user_id) as active_users from activity
where activity_date>=to_date('20190728', 'YYYYMMDD')-30 and activity_date<'2019-07-28'
group by activity_date

1158. Market Analysis I
select user_id as buyer_id , to_char(join_date, 'YYYY-MM-DD') as join_date, nvl(orders_in_2019, 0) as orders_in_2019  from users u left join 
(select buyer_id , count(*) as orders_in_2019 from orders where to_char(order_date, 'YYYY')='2019'
group by buyer_id) o
on u.user_id=o.buyer_id

1757. Recyclable and Low Fat Products
select product_id  from Products
where low_fats='Y'
and recyclable='Y'

584. Find Customer Referee
select name from customer where nvl(referee_id, 0)<>2

595. Big Countries
select name, population, area  from World
where population>=25000000 or area>=3000000 

1148. Article Views I
select distinct author_id as id from Views 
where author_id=viewer_id
order by id

1683. Invalid Tweets
select tweet_id from Tweets
where length (content)>15

1378. Replace Employee ID With The Unique Identifier
select unique_id, name from Employees e left join EmployeeUNI eu on (e.id=eu.id)

2356. Number of Unique Subjects Taught by Each Teacher
select teacher_id , count(distinct subject_id ) as cnt  from Teacher
group by teacher_id

596. Classes More Than 5 Students
select class from courses group by class having count(*)>=5

1729. Find Followers Count
select user_id, count(*) as followers_count from Followers group by user_id order by user_id

619. Biggest Single Number
select max(num) as num  from MyNumbers  
where num in(select num from MyNumbers  group by num having count(*)=1)

1667. Fix Names in a Table
select user_id, upper(substr(name, 1,1))||lower(substr(name,2, length(name)-1)) as name from users
order by user_id

1661. Average Time of Process per Machine
select machine_id, round(avg(timestamp-start_timestamp),3) as processing_time from (
select machine_id, process_id, activity_type, timestamp, lag(timestamp) over (partition by machine_id, process_id order by activity_type desc) as start_timestamp from activity)
where activity_type ='end'
group by machine_id

1211. Queries Quality and Percentage
select query_name, round(avg(rating/position),2) as quality , round(avg(case when rating<3 then 1 else 0 end)*100,2) as poor_query_percentage  from queries
group by query_name

1068. Product Sales Analysis I
select product_name, year, price from sales left join product using (product_id)

1581. Customer Who Visited but Did Not Make Any Transactions
select customer_id, count(*) as count_no_trans  from visits v where not exists (select 1 from transactions t where v.visit_id=t.visit_id)
group by customer_id


1280. Students and Examinations
select  st.student_id, st.student_name, su.subject_name, nvl(count(e.student_id),0) as attended_exams from Students st cross join Subjects su  left join Examinations e on (st.student_id =e.student_id  and su.subject_name =e.subject_name )
group by st.student_id, st.student_name, su.subject_name
order by st.student_id, su.subject_name

1934. Confirmation Rate
select s.user_id, round(sum(case when action='confirmed' then 1 else 0 end)/count(*),2) as confirmation_rate  from Signups  s left join Confirmations  c  on (s.user_id=c.user_id )
group by s.user_id

1251. Average Selling Price
select p.product_id , round(nvl(sum(us.units*p.price)/sum(us.units),0),2)  as average_price  from unitssold us right join prices p on (us.product_id =p.product_id and us.purchase_date between p.start_date and p.end_date)
group by p.product_id 

1321. Restaurant Growth
select distinct to_char(visited_on,'YYYY-MM-DD') as visited_on, amount, average_amount from (
select visited_on, sum (amount) over(order by visited_on range between 6 preceding and current row) as amount, round(sum(amount) over (order by visited_on range between 6 preceding and current row)/7,2) as average_amount
from Customer) c1 
where 7=(select count(distinct visited_on) from customer c2
    where c2.visited_on>=c1.visited_on-6 and c2.visited_on <=c1.visited_on)
order by visited_on

620. Not Boring Movies
select * from cinema
where mod(id,2)<>0 and lower(description) not like '%boring%'
order by rating desc

1075. Project Employees I
select project_id, round(avg(experience_years),2) as average_years from project p left join employee e on (p.employee_id=e.employee_id)
group by project_id


1193. Monthly Transactions I
select to_char(trans_date, 'YYYY-MM') month, country,
count(*) trans_count, sum(case when state='approved' then 1 else 0 end) approved_count, sum(amount) trans_total_amount, sum(case when state='approved' then amount else 0 end) approved_total_amount  from Transactions
group by to_char(trans_date, 'YYYY-MM'), country

1174. Immediate Food Delivery II
select round((sum(case when order_date=customer_pref_delivery_date then 1 else 0 end)/count(*) )*100,2) immediate_percentage  from (
select customer_id, order_date, customer_pref_delivery_date, rank() over(partition by customer_id order by order_date ) rnk from Delivery)
where rnk=1

1633. Percentage of Users Attended a Contest
select contest_id, round((count(*)/(select count(*) from users))*100,2) as percentage from Register 
group by contest_id  order by percentage desc, contest_id 

1731. The Number of Employees Which Report to Each Employee
select e1.reports_to as employee_id , e2.name, count(*) as reports_count, round(avg(e1.age)) as average_age
from employees e1 left join employees e2 on e1.reports_to=e2.employee_id
where e1.reports_to is not null
group by e1.reports_to, e2.name
order by e1.reports

1789. Primary Department for Each Employee
select employee_id, department_id from(
select employee_id, count(*) over (partition by employee_id) deps, department_id, primary_flag from employee
) e where deps=1 or (deps>1 and primary_flag='Y')

610. Triangle Judgement
select x, y, z, case when x + y > z AND x + z > y AND z + y > x then 'Yes' else 'No' end as triangle
from Triangle;

1907. Count Salary Categories
select category, count(account_id) accounts_count  from
(select 'Low Salary' as category from dual
union 
select 'Average Salary' from dual
union 
select 'High Salary' from dual) a left join Accounts  on (a.category=case when income<20000 then 'Low Salary'
when income>=20000 and income<=50000 then 'Average Salary' else 'High Salary' end )
group by category

1978. Employees Whose Manager Left the Company
select employee_id from employees e1
where e1.manager_id not in  (select employee_id from employees e2)
and salary<30000
order by employee_id
//
select employee_id from employees e1
where not exists  (select 1 from employees e2 where e1.manager_id=e2.employee_id)
and salary<30000
and e1.manager_id is not null
order by employee_id

1484. Group Sold Products By The Date
select to_char(sell_date,'YYYY-MM-DD') sell_date  , count(distinct product) as num_sold, listagg( product, ',') within group (order by product) as products from (select distinct * from activities) 
group by sell_date
order by sell_date

1327. List the Products Ordered in a Period
 select product_name, sum(unit) unit
 from orders o left join products p using(product_id)
 where order_date>='2020-02-01' and order_date<'2020-03-01'
 group by product_name
 having sum(unit)>=100
 
 1517. Find Users With Valid E-Mails
 SELECT user_id, name, mail FROM Users
WHERE  REGEXP_like (mail,'^[a-zA-Z][a-zA-Z0-9_./-]*@leetcode[.]com')

602. Friend Requests II: Who Has the Most Friends
select * from (
select id, count(*) num  from (select requester_id as id from RequestAccepted union all select accepter_id  from RequestAccepted) 
group by id
order by num desc)
where rownum<2

1164. Product Price at a Given Date
select distinct p1.product_id, nvl(p2.new_price, 10) as price from products p1 left join (select product_id, new_price from (
select product_id, new_price, rank() over (partition by product_id order by change_date desc) as rnk from products
where change_date<='2019-08-16')
where rnk=1) p2 on p1.product_id=p2.product_id

1204. Last Person to Fit in the Bus
select person_name from (
select turn, person_id , person_name , weight, sum(weight) over (order by turn range between unbounded preceding and current row) running_weight  from queue
order by turn desc ) e
where running_weight<=1000
and rownum<2