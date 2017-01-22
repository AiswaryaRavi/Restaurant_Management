DELIMITER $$
CREATE
   
    PROCEDURE PR_TAKEORDER(IN ITEM_LISTS MEDIUMTEXT,IN ITEM_QUANTITY MEDIUMTEXT,IN SEAT_NUMB INT,OUT MESSAGE VARCHAR(100),OUT ERR BOOLEAN)
    
    BEGIN
          DECLARE LIST1 TEXT DEFAULT NULL ;
          DECLARE LEN1 INT DEFAULT NULL;
          DECLARE VALUE1 TEXT DEFAULT NULL;
          DECLARE LIST2 TEXT DEFAULT NULL ;
          DECLARE LEN2 INT DEFAULT NULL;
          DECLARE VALUE2 TEXT DEFAULT NULL;
          DECLARE RESULT INT;
          DECLARE BILLSTATUS VARCHAR(30);
          DECLARE BILL_AMOUNT INT;
          DECLARE OID INT;
          DECLARE ORDER_STATUS VARCHAR(20);
          SET ERR=TRUE;
          TRUNCATE TABLE TEMP_ORDER_GIVEN;

          /* check the availabiliy of seats*/
          SET RESULT=FN_SEATCHECK(SEAT_NUMB);
          IF RESULT=1
          THEN
		
		/*if seat is available generate order number */
		INSERT INTO ORDERS(SEAT_NUM,STATUS)VALUES(SEAT_NUMB,'REQUESTED');
		SELECT ID INTO OID FROM ORDERS WHERE ID=LAST_INSERT_ID();
		
		/*seat is occupied*/
		UPDATE SEATS SET STATUS='UNAVAILABLE' WHERE SEAT_NO=SEAT_NUMB;
		iterator :
		
		/*checks whether the item is null*/
		LOOP    
			IF LENGTH(TRIM(ITEM_LISTS)) = 0 OR ITEM_LISTS IS NULL OR LENGTH(TRIM(ITEM_QUANTITY)) = 0 OR ITEM_QUANTITY IS NULL THEN
			LEAVE iterator;
			END IF;
  
		/*split the items given into individual items*/
		SET LIST1 = SUBSTRING_INDEX(ITEM_LISTS,',',1);
		SET LEN1 = LENGTH(LIST1);
		SET VALUE1 = TRIM(LIST1);
                		
                /*split the quantity given into individual items*/
		SET LIST2 = SUBSTRING_INDEX(ITEM_QUANTITY,',',1);
		SET LEN2 = LENGTH(LIST2);
		SET VALUE2 = TRIM(LIST2);
                
                /*checks the number of items*/ 
		CALL PR_CHECKITEMS(LIST1,LIST2,SEAT_NUMB,OID,@ITEM_CHECK,@ERROR);
		IF @ERROR
		THEN
		SELECT @ITEM_CHECK;
		END IF;
		SET ITEM_LISTS = INSERT(ITEM_LISTS,1,LEN1 + 1,'');
		SET ITEM_QUANTITY = INSERT(ITEM_QUANTITY,1,LEN2 + 1,'');
		END LOOP;
		SET ERR=FALSE;
         ELSE 
         SET MESSAGE='SEAT IS UNAVAILABLE!';
         END IF;
        
         /*if the order id is not in transaction table then the item is not ordered*/
         IF OID NOT IN(SELECT ORDER_ID FROM ORDER_RECORDS ) 
         THEN
         UPDATE ORDERS SET STATUS='NOT_ORDERED' WHERE ID=OID; 
	 ELSE
	 
	 /*the order is placed then the item is served*/
	 UPDATE ORDERS SET STATUS='SERVED' WHERE ID=OID;
	 END IF;
	 UPDATE SEATS SET STATUS='AVAILABLE' WHERE SEAT_NO=SEAT_NUMB;
	 UPDATE SEATS SET CONCURRENT_USER_STATE=FALSE WHERE SEAT_NO=SEAT_NUMB;



END $$
        
DELIMITER ;


CALL PR_TAKEORDER('South Indian Meals,IDLY','3,0',2,@MESSAGE,@ERR);
CALL MESSAGE_RETRIEVAL(@MESSAGE,@ERR);


DELIMITER &
CREATE PROCEDURE MESSAGE_RETRIEVAL(IN MESSAGE VARCHAR(100),IN ERR BOOLEAN)
BEGIN
IF ERR
THEN
SELECT MESSAGE;
END IF;
END &
DELIMITER ;

