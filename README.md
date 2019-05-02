# cohort-analysis

### Question 1 
The given data set consists of orders for customers over a timeperiod using which I am performing retention analysis considering cohorts in weekly intervals. The data set provides customer first and any subsequent orders but does not provide the acquisition or joining date. The assumption that I am making while performing this analysis is that, a customer's first order shipment date is considered as the acquisition date. The solution is present in the sql file (**Queries.sql**) and the approach is as follows - 
* Create a table, called *retentiontable*, that will calculate the retention count (*retentioncount*) i.e. the number of customers who "return" to perform a transaction for each interval of the weekly cohorts. This is done by self joining the given data set (orders) where table 'r' is the cohort sample set and table 'c' is the interval sample set. By applying the filter that r's order number is equal to 1 we map the customer to its cohort. The filter which checks the difference between shipment dates in these two tables is not equal to 0 ensures that the customer is a "returning" type.
* Create a table, called *cohortsize*, that will calculate the cohort size (*weekcount*) i.e. the number of customers that are present in each weekly cohort. To do so we use a self join, similar to the one mentioned above with a difference in the dates filter. The difference is that we check if the difference between the shipment dates is equal to 0 to ensure that we are only considering those customers who are first time buyers i.e. as per our assumption they are customers who are being acquired.
* Create a table, called *q1table*, that will calculate the retention value (*RetentionValue*) by joining the two tables described above. The formula would be (retentioncount/weekcount).
* Export the data set present in q1table to a csv file (**q1answer.csv**) that can be used to build the cohort table and evaluate the maximum drop in retention.
* Calculate the drop in retention for each weekly intervals by using the formula (**=IF(C3>1,ABS(D2-D3),0)**). This formula calculates the difference in retention between successive weekly intervals as long as the interval is not the  first one, in which case there is no drop and the value should be defaulted to 0.
* Once the individual drops have been calculated, using the max formula(**=MAX(F3:F102)**), the highest drop can be identified as the one between interval **5 and 6 for weekly cohort 22**.

### Question  2
The quesstion here is to identify which of the following two options would result in a bigger change in revenue using the cohort analysis described above - 
* Option 1: 5% increase in cohorts in 3+ bracket
* Option 2: $3 increase in average order value for cohorts in 3+ bracket

An assumption that is made here is that, 3+ bracket is understood to be non-inclusive i.e. from interval 4 onwards. The solution is present in the sql file (**Queries.sql**) and the approach is as follows -
* Create a table, called *q2table*, that will calculate the following - 
  * Retention count (*retentioncount*) similar to the description mentioned above in question 1.
  * Retention revenue (*RetentionRevenue*) i.e. the average order value for each "returning" customer.
  * Proposed retention count (*ProposedRetentionCount*) i.e. the number of customers who "return" to perform a transaction for each interval of the weekly cohorts with an increase of 5%.
  * Proposed retention revenue (*ProposedRetentionRevenue*) i.e.the average order value for each "returning" customer with an increase in $3.
* The filter conditions while creating this table is similar to the *retentiontable* table mentioned in question 1 above.
* Export the data set present in q1table to a csv file (**q2answer.csv**) that can be used to identify which option gives us a higher change in revenue.
* Calculate the following in the excel - 
  * Sum of Retention count using the formula (=IF(B3>3,C3,0)) which checks if the interval is greater than 3.
  * Sum of Proposed retention count using the formula (=IF(B3>3,D3,0)) which checks if the interval is greater than 3.
  * Sum of Retention revenue using the formula (=IF(B3>3,E3,0)) which checks if the interval is greater than 3.
  * Sum of Proposed retention revenue using the formula (=IF(B3>3,F3,0)) which checks if the interval is greater than 3.
  * Value for Option 1 is computed by multiplying proposed retention count and retention revenue i.e. (=I103*J103).
  * Value for Option 2 is computed by multiplying retention count and proposed retention revenue i.e. (=H103*K103).
  * Since the value in result of Option 2 is higher, it can be concluded that a **$3 increase in average order value for cohorts in 3+ bracket has a higher impact on revenue**.
* From past experience, I believe it is comparatively easier to impact current customers than new ones. This is so because, the cost of improving product experience or new promotional offers is often lesser compared to acquiring customers through new marketing efforts. The general idea being, existing customers have bought into the offering once and can be retained, given we change based on feedback. However, new customers are thought of as unknown and cannot be targeted if we do not know what to shoot for. The similar analogy exists in software services industry where most of the revenue for a technology consulting company is from repeat client business, whereas a new clinet acquisition is usually harder through Request for Proposal (RFP) process.


### Question 3
From the solution to question 1, we can see that there was a significant drop in retention for XXX. I believe it would be interesting to dive deep into this cohort by breaking it into further segments to identify further patterns. To do this, there are certain data elements that can be added to the analysis data set - 
* Technical roadmap - By having the technical implementation roadmap, we can see if there were any changes to the application that might have resulted in the drop.
* Marketing strategies - By having the marketing campaign data, we can determine if there were any specific campaigns that might have led to the drop in retention.
* Customer data - Having the accurate customer acquisition date would help eliminate the assumption that the first order shipment date is when the customer was acquired.

In addition to having these data sets, I would use classification algorithms like classification trees to see which attribute is significantly impacting retention values. This would help in understanding data trends that cannot be eye-balled through visual tools or are difficult to reach through queries. Also, classifying customers based on additional factors, other than acquisition date, is also an approach that can be tried. The additional factors could help in segmenting customers in a more accurate cohort. Some of these additional factors could be behavioral such as how customers react to a promotions offered, or whether they provide feedback in response to a product that they purchased.   
