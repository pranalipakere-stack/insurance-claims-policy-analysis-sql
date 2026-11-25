create database insurance_claims;
use insurance_claims;
select * from claims;
select * from adjusters;
select * from policies;
select * from policyholders;
#Q1.Find the total number of claims in the database.
select count(*) from claims;
#Q2.Display the full names of policyholders along with their policy numbers.
select ph.holder_id,p.first_name,
p.last_name,ph.policy_number
from policyholders p
inner join policies ph
on p.id = ph.holder_id;
#Q3. Find the policy with the highest annual premium.
select max(annual_premium) from policies;
#Q4.Display all policies, including policies that have never received a claim.
select p.*,c.*
from policies p
left join claims c
on p.id = c.policy_id;
#Q5.Find policyholders who hold more than two policies.
select e.first_name,p.holder_id,
count(p.policy_number)
from policyholders e
join policies p
on e.id = p.holder_id
group by e.id,e.first_name,p.holder_id
having count(p.policy_number) > 2;
#Q6. Find policies that started between January 2023 and December 2023.
select * from policies
where start_date between '2023-01-01' and '2023-12-01';
#Q7.Calculate the average number of days between the loss date and the 
#reporting date for each line of business.
select line,avg(datediff(reported_at,loss_date)) as days
from claims 
group by line;
#Q8.Find policyholders who have never made an insurance claim.
select e.*,p.*,ph.*
from policyholders p 
left join policies ph
on p.id = ph.holder_id
left join claims e
on ph.id = e.policy_id
where claim_number is NULL;
#Q9.Calculate the total settled amount for each line of business.
select line,sum(settled_amount) as total_amount
from claims
group by line;
#Q10.Display claim numbers, adjuster full names and their respective regions.
select c.claim_number,a.first_name,a.last_name,a.region
from claims c
inner join adjusters a 
on c.adjuster_id = a.id;
#Q11.Find customers who have purchased both motor and travel policies.
select holder_id,count(distinct line) 
from policies 
group by holder_id 
having count(distinct case 
when line in('motor','travel') then line 
end) = 2;
#Q12.Find claims where the claimed amount is greater than the average claimed 
#amount across all claims.
select * from claims 
where claimed_amount > (
select avg(claimed_amount) 
from claims);
#Q13.Find policies whose insured amount is greater than the average insured 
#amount of their respective business lines.
select * from policies p1
where p1.sum_insured >(
select avg(p2.sum_insured)
from policies p2 
where p2.line = p1.line);
#Q14.Find the number of policies according to their renewal outcome.
select term_outcome,
count(policy_number) as number_of_policies
from policies
group by term_outcome;
#Q15.Find the top five towns based on the number of policyholders.
select town,count(*) as number_of_policyholders
from policyholders
group by town
order by number_of_policyholders desc limit 5;
#Q16.Display each adjuster's name and the number of claims they have handled, 
#including adjusters who have handled zero claims.
select a.first_name,a.last_name,count(c.status)
from adjusters a 
left join claims c 
on a.id = c.adjuster_id
group by a.id,a.first_name,a.last_name;
#Q17.Find customers whose total annual 
#premium across all their policies is greater than €3,000.
select holder_id,sum(annual_premium) as total_annual_premium
from policies 
group by holder_id
having total_annual_premium > 3000;
#Q18.Find all claims where the settled amount is less than the claimed amount.
select claim_number,claimed_amount, settled_amount
from claims 
where settled_amount < claimed_amount;
#Q19.Generate a sequence of numbers from 1 to 12 using SQL.
with recursive countdown as(
select 1 as num
union all
select num + 1
from countdown
where num < 12)
select * from countdown;
#Q20.Find the business line with the highest average annual premium.
select line,avg(annual_premium) as average_premium 
from policies
group by line
order by average_premium desc limit 1;