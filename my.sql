select 
t.contract_no, 
case when p.business_date> add_months(t.repayment_end_date,6) and t.oever_instalment>=7 then  
sum(p.indeed_capital)+sum(p.indeed_interest)+sum(p.indeed_instalment_fee)+sum(p.indeed_amerce)+sum(p.indeed_forfeit) 
else 0 
end as recovery_amount 
from  
(select  
contract_no, 
min(repayment_end_date) repayment_end_date, 
floor(months_between('2017-07-31',min(repayment_end_date)))+1 oever_instalment 
from dw.fact_tcsv_repayment_plan 
where (settle_flag=0 and overdue_flag = 2 and repayment_start_date<='2017-07-31') 
or (settle_flag=1 and business_date>'2017-07-31' and overdue_flag = 2 and repayment_start_date<='2017-07-31') 
group by contract_no) t 
join dw.fact_tcsv_repayment_plan p 
on t.contract_no = p.contract_no 
group by t.contract_no, 
case when p.business_date> add_months(t.repayment_end_date,6) and t.oever_instalment>=7 then  
sum(p.indeed_capital)+sum(p.indeed_interest)+sum(p.indeed_instalment_fee)+sum(p.indeed_amerce)+sum(p.indeed_forfeit) 
else 0 
end
