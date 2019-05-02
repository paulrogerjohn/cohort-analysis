Question 1
===========================================================================================================================
create table retentiontable as 
select count(distinct r.customer_id) as retentioncount
,strftime('%W',c.shipment_date) as weekcohort 
,strftime('%W',r.shipment_date) as acquisitiondate
,(strftime('%W',c.shipment_date) - strftime('%W',r.shipment_date)) as diff
from orders r
join orders c
on r.customer_id = c.customer_id
where r.order_number = 1 and (strftime('%W',c.shipment_date) - strftime('%W',r.shipment_date)) <>0
group by strftime('%W',c.shipment_date) 
,strftime('%W',r.shipment_date)
,(strftime('%W',c.shipment_date) - strftime('%W',r.shipment_date))
order by (strftime('%W',c.shipment_date) - strftime('%W',r.shipment_date)) asc;

create table cohortsize as
select count(distinct r.customer_id) as weekcount
,strftime('%W',c.shipment_date) as weekcohort
,strftime('%W',r.shipment_date) as acquisitiondate
,(strftime('%W',c.shipment_date) - strftime('%W',r.shipment_date)) as diff
from orders r
join orders c
on r.customer_id = c.customer_id
where r.order_number = 1 and (strftime('%W',c.shipment_date) - strftime('%W',r.shipment_date))=0
group by strftime('%W',c.shipment_date)
,strftime('%W',r.shipment_date)
,(strftime('%W',c.shipment_date) - strftime('%W',r.shipment_date))
order by (strftime('%W',c.shipment_date) - strftime('%W',r.shipment_date)) asc;

create table q1table as 
select a.acquisitiondate as 'AcquisitionDate'
,a.weekcohort as 'WeekCohort'
,a.diff as 'Interval'
,((retentioncount*1.00)/(weekcount*1.00))*100 as 'RetentionValue' 
from retentiontable a
join cohortsize b
on a.acquisitiondate=b.acquisitiondate
group by a.acquisitiondate,
a.weekcohort,
a.diff,
retentioncount,
weekcount;

Question 2
===========================================================================================================================

create table q2table as 
select acquisitiondate,diff,sum(retentioncount) as 'RetentionCount',
sum(proposedretentioncount) as 'ProposedRetentionCount',sum(retentionrevenue) as 'RetentionRevenue',
sum(proposedretentionrevenue) as 'ProposedRetentionRevenue' 
from (
select count(distinct r.customer_id) as retentioncount
,count(distinct r.customer_id)+((count(distinct r.customer_id)*1.00*5)/100) as proposedretentioncount
,strftime('%W',r.shipment_date) as acquisitiondate
,(strftime('%W',c.shipment_date) - strftime('%W',r.shipment_date)) as diff
,sum(cast(SUBSTR(c.order_value,2,length(c.order_value)) as numeric(5,2)))/count(distinct c.customer_id) as retentionrevenue
,(sum(cast(SUBSTR(c.order_value,2,length(c.order_value)) as numeric(5,2)))/count(distinct c.customer_id) + 3) as proposedretentionrevenue
from orders r
join orders c
on r.customer_id = c.customer_id
where r.order_number = 1 and (strftime('%W',c.shipment_date) - strftime('%W',r.shipment_date)) <>0
group by strftime('%W',r.shipment_date),
(strftime('%W',c.shipment_date) - strftime('%W',r.shipment_date))
) a
group by 1,2
order by diff asc;