select o. order_date, o.order_id,c.first_name as customer_name, s.name as shipper, os.name as Status
from orders o 
left join order_statuses os 
on o.status = os.order_status_id
left join customers c 
on o.customer_id = c.customer_id
left join shippers s
on o.shipper_id = s.shipper_id 
order by shipper;

