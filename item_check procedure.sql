DELIMITER &
CREATE PROCEDURE PR_CHECKITEMS(IN MENU_ITEM VARCHAR(20),IN QUANTS INT,IN SEATNOS INT, IN O_ID INT,OUT ITEM_CHECK VARCHAR(100),OUT ERROR BOOLEAN)
BEGIN
DECLARE MENUID INT;
DECLARE MENUCHECK INT;
DECLARE FID INT DEFAULT 0;
SET ERROR=TRUE;

/*check if the item is in the menulist*/
SET MENUCHECK=ITEM_EXISTS(MENU_ITEM);
IF MENUCHECK=1
THEN

	/*check if the hotel is currently in service*/
	IF EXISTS(SELECT ID FROM FOOD_TYPES WHERE CURTIME() BETWEEN FROM_TIME AND TO_TIME)
	THEN
		SELECT Id INTO MENUID FROM MENU_ITEMS WHERE ITEM=MENU_ITEM;
		SELECT DISTINCT(ITEM_SCHEDULES.`FOOD_ID`)INTO FID FROM ITEM_SCHEDULES INNER JOIN FOOD_TYPES WHERE ITEM_SCHEDULES.`MENU_ID`=MENUID
		AND ITEM_SCHEDULES.`FOOD_ID` IN(SELECT FOOD_TYPES.`ID` FROM FOOD_TYPES WHERE CURTIME()>=FOOD_TYPES.`FROM_TIME` AND CURTIME()<=FOOD_TYPES.`TO_TIME`);
		IF FID!=0
		THEN

			/*the order must take only 5 orders*/
			IF (SELECT COUNT(DISTINCT(ITEM))FROM TEMP_ORDER_GIVEN)<5
			THEN
				INSERT INTO TEMP_ORDER_GIVEN(ORDER_ID,ITEM,QUANTITY)VALUES(O_ID,MENU_ITEM,QUANTS);
				CALL PR_VALIDATION_ENTRY(MENU_ITEM,QUANTS,SEATNOS,FID,O_ID,@RESULT);
				SELECT @RESULT;
				SET ERROR=FALSE; 
			ELSE 
				SET ITEM_CHECK= 'SORRY YOU CAN ORDER ONLY 5 ITEMS';
			END IF;
		ELSE
			SET ITEM_CHECK='THIS ITEM IS NOT AVAILABLE AT THIS TIME';
		END IF;
	ELSE
		SET ITEM_CHECK='NO SERVICE';
	END IF;
ELSE
	SET ITEM_CHECK='THIS ITEM IS UNAVAILABLE IN THE MENU LIST';
END IF;
/*SET ITEM_CHECK=IFNULL(@ITEM_CHECK,@RESULT);*/
END &
DELIMITER ;


CALL PR_CHECKITEMS('IDLY',2,1,3,@ITEM_CHECK);
SELECT @ITEM_CHECK

DROP PROCEDURE PR_CHECKITEMS
