WITH  order_table as(
    SELECT
            inv.item_number as item_number
        ,   inv.day as 'day'
        ,   inv.inventory as 'inventory_quantity'
        ,   sales.sales_quantity as 'sales_quantity'
        ,   (sales.sales_quantity - inv.inventory) AS amount_to_order
    FROM sales_predictions sales
    INNER JOIN inventory inv
        ON
            sales.item_number = inv.item_number
        AND
            sales.day = inv.day
    WHERE
        sales.sales_quantity > inv.inventory
)
SELECT 
        items.item_number as item_number
    ,   items.ordering_day as ordering_day                                                                                
    ,   items.delivery_day as delivery_day
    ,   items.suggested_retail_price AS sales_price_suggestion
    ,   ((items.suggested_retail_price/items.purchase_price-1)*100) AS profit_margin
    ,   items.purchase_price AS purchase_price
    ,   items.item_categories as item_categories
    ,   json_array(items.tags, items.extra_categories) as labels
    ,   json_object('quantity',items.case_content_quantity,'unit',items.case_content_unit) as 'case'
    ,   json_object('quantity',order_table.amount_to_order/items.case_content_quantity,'unit','CS') AS 'order'
    ,   json_object('quantity',order_table.inventory_quantity,'unit',items.case_content_unit) AS 'inventory'
FROM orderable_items AS items
LEFT JOIN order_table
    ON
        items.item_number = order_table.item_number
WHERE
    order_table.amount_to_order > 0
AND
    items.delivery_day <= order_table.day
GROUP BY items.item_number, items.ordering_day
;