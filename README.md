# freshflow_takehom
take home task
Unfortunately it took me 1.5 hours more to deliver the task than required, nonetheless I send it.

## Assumptions:
1. We dispatch order recommendations on days when the predicted `sales_quantity` is larger than `inventory`
2. We place order of items when their `delivery_day` is eariler or same day as `sales_predictions.day` - So there would be enough supply to satisfy demand

## Process
1. Determine for which items we predict a higher demand than supply for a given day through `sales_predictions` and `inventory`, call it `items_to_order`
2. Group by  `item _number` and `ordering_day`, on items that should be ordered
3. Output orders as JSON strings

## Challanges
1. Understanding how to connect the business logic to tables - it took me a while (2.5 hours) to make the connection between the `sales_prediction` and inventory, and I wasted much time trying to join each of those tables to items, instead of combining them before I join.
2. More time then I wanted was spent trying to concatenate `orderable_items.tags` and `orderable_items.extra_categories` through sqlite, finally I resorted to use python `eval`.
