select * 
from msk_injection mi 
limit 100;

select clinic, count(distinct clinic)
from msk_injection mi
group by clinic;

select clinic, count(distinct physician)
from msk_injection mi
group by clinic;

select
  count(*) AS total_rows,
  count(*) - count(nullif(trim(clinic), '')) AS missing_clinic,
  count(*) - count(nullif(trim(physician), '')) AS missing_physician,
  count(*) - count(nullif(trim(appointment_id), '')) AS missing_appointment_id,
  count(*) - count(revenue) AS missing_revenue,
  count(*) - count(appointment_date) AS missing_appointment_date
from msk_injection;

alter table msk_injection 
alter column appointment_date type date using appointment_date::date;

select min(appointment_date), max(appointment_date)
from msk_injection;

alter table msk_injection
add column is_last_12_months boolean;

update msk_injection
set is_last_12_months =
  (appointment_date > CURRENT_DATE - interval '12 months'
   and appointment_date <  CURRENT_DATE);

select * 
from msk_injection mi 
limit 100;

select 
	clinic,
	sum(revenue) as total_revenue
from msk_injection
where is_last_12_months is true
group by clinic 
order by total_revenue asc;

select 
	physician,
	sum(revenue) as total_revenue_by_physician
from msk_injection
where is_last_12_months is true
group by physician 
order by total_revenue_by_physician asc;

select 
	clinic,
	code,
	to_char(date_trunc('month', appointment_date), 'YYYY-MM') AS month,
	count(*) as injections, 
	sum(revenue)
from msk_injection mi 
where is_last_12_months is true
group by clinic, code, month
order by clinic, code, month;
