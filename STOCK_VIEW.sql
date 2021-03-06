/*  To view the stock details */
CREATE VIEW VW_STOCK_DETAILS AS
SELECT ISC.MENU_ID,M.`ITEM` AS ITEM_NAME,FT.`TYPE_NAME` AS SCHEDULE_NAME,ISC.`QUANTITY` AS TOTAL,
IFNULL(SUM(ODR.`QUANTITY`),0)AS CONSUMED,
IFNULL(ISC.`QUANTITY`-SUM(ODR.`QUANTITY`),ISC.`QUANTITY`)AS REMAINING
FROM ITEM_SCHEDULES ISC
LEFT JOIN MENU_ITEMS M
ON M.`ID`=ISC.`MENU_ID`
LEFT JOIN FOOD_TYPES FT
ON FT.`ID`=ISC.`FOOD_ID`
LEFT JOIN ORDER_RECORDS ODR
ON ODR.`MENU_ID`=M.`ID`
AND EXISTS
(SELECT 1 FROM FOOD_TYPES WHERE FOOD_TYPES.`ID`=FT.`ID` AND TIME(ODR.`ORDER_DATE`)BETWEEN FROM_TIME AND TO_TIME)
AND DATE(ODR.`ORDER_DATE`)=CURDATE()
AND ODR.`ORDER_TRACK`='ORDER DISPATCHED'
GROUP BY ISC.`ID`


SELECT *FROM VW_STOCK_DETAILS