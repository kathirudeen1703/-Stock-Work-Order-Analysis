
create database Project2;

use Project2;


select * from date_wise_report;
select * from order_status;

-- 1. Stock count & work_order_count

create table stock_order select order_id,count(order_type) as order_count from order_status where order_type='Stock' group by order_id;

create table work_order select order_id,count(order_type)as Work_order_count from order_status where order_type='Work_order' group by order_id;

select * from stock_order;
select * from work_order;

create table total_order_count select stock_order.order_id , stock_order.order_count,work_order.work_order_count 
from stock_order inner join work_order on stock_order.order_id=work_order.order_id;


select * from total_order_count;

-- 2. find Work_order_pending Status

create table Pending_status select *,(work_order_count-order_count) as work_order_pending_Status from total_order_count;

select * from pending_status;

-- 3 find work_order_pending &
-- 4. create new table 

create table Order_pending_status select *,
case
when work_order_pending_status <=0 then "Order_Closed"
else "Order_Pending"
end as Work_order_closed_or_Not from pending_status; 


select * from order_pending_status;

-- 5. join 2 tables
select * from order_status;
select * from date_wise_report;

create table order_supplier_report select order_status.Trans,order_status.Negative,order_status.order_type,order_status.Assembly_supplier,
order_status.Ref,order_status.Order_id,order_status.Sale_id,order_status.Description,
date_wise_report.Sale_date,date_wise_report.Qty,date_wise_report.Item_type,date_wise_report.job_status,
date_wise_report.Planner,date_wise_report.Buyer_Name,date_wise_report.Preferred_supplier,date_wise_report.safety,
date_wise_report.pre_PLT,date_wise_report.Post_PLT,date_wise_report.LT,date_wise_report.Run_Total,date_wise_report.Late,
date_wise_report.Safety_RT,date_wise_report.PO_Note,date_wise_report.Net_Neg,date_wise_report.Last_Neg,date_wise_report.Item_Category,
date_wise_report.Created_On_Date from order_status inner join date_wise_report on order_status.Sale_id=date_wise_report.Sale_id ;

select * from order_supplier_report;

-- 6. (i) 

select sale_date,count(Qty)as Date_wise_Quantity_count from order_supplier_report group by sale_date;

select Sale_date,count(order_id) as Date_wise_order_id_count from Order_supplier_report group by sale_date;

delimiter &&
create procedure final_Reports() 
begin
select * from total_order_count;
select * from pending_status;
select * from order_pending_status;
select * from order_supplier_report;

select sale_date,count(Qty)as Date_wise_Quantity_Count from order_supplier_report group by sale_date;
select Sale_date,count(order_id) as Date_wise_order_id_Count from Order_supplier_report group by sale_date;

end &&
delimiter ;

call final_Reports();


