DELIMITER &
CREATE PROCEDURE PR_ADD_ITEMS(IN ITEM_NAME VARCHAR(30),IN SESSION_NAME VARCHAR(30),IN PRICE INT)
BEGIN
DECLARE ITEM_ID INT;
DECLARE SESSION_ID INT;
DECLARE QUANT INT;
IF NOT EXISTS(SELECT ITEM FROM MENU_ITEMS WHERE ITEM=ITEM_NAME)
THEN
	INSERT INTO MENU_ITEMS(ITEM,RATE) VALUES(ITEM_NAME,PRICE);
END IF;
SELECT ID INTO ITEM_ID FROM MENU_ITEMS WHERE ITEM=ITEM_NAME;
SELECT ID INTO SESSION_ID FROM FOOD_TYPES WHERE TYPE_NAME=SESSION_NAME;
SELECT DISTINCT(QUANTITY)INTO QUANT FROM ITEM_SCHEDULES WHERE FOOD_ID=SESSION_ID;
INSERT INTO ITEM_SCHEDULES(FOOD_ID,MENU_ID,QUANTITY)VALUES(SESSION_ID,ITEM_ID,QUANT);
END &
DELIMITER ;

CALL PR_ADD_ITEMS('NAAN','BREAKFAST',50)





