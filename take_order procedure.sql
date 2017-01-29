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
          CALL PR_SEATCHECK(SEAT_NUMB,@FLAG,@SEAT_MSG);
          IF (@SEAT_MSG=1)
           THEN
         
          UPDATE SEATS SET STATUS="UNAVAILABLE" WHERE SEAT_NO=SEAT_NUMB;		
		


			
		/*if seat is available generate order number */
		INSERT INTO ORDERS(SEAT_NUM,STATUS)VALUES(SEAT_NUMB,'REQUESTED');
		SELECT ID INTO OID FROM ORDERS WHERE ID=LAST_INSERT_ID();
		IF (SELECT STATUS FROM ORDERS WHERE ID=OID)='REQUESTED'
		THEN
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
                
		SELECT STATUS INTO ORDER_STATUS FROM ORDERS WHERE ID=OID;
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
        
        
         /*if the order id is not in transaction table then the item is not ordered*/
         IF OID NOT IN(SELECT ORDER_ID FROM ORDER_RECORDS ) 
         THEN
         UPDATE ORDERS SET STATUS='NOT_ORDERED' WHERE ID=OID; 
	 END IF;
	 ELSE
	 SET MESSAGE='YOUR ORDER IS CANCELLED';
	 CALL MESSAGE_RETRIEVAL(MESSAGE,ERR);

	 END IF;
	 ELSE 
	 SET MESSAGE='SEAT IS UNAVAILABLE!';
	 CALL MESSAGE_RETRIEVAL(MESSAGE,ERR);

         END IF;
	 UPDATE SEATS SET CONCURRENT_USER_STATE=NOT CONCURRENT_USER_STATE WHERE SEAT_NO=SEAT_NUMB;
	 UPDATE SEATS SET STATUS="AVAILABLE" WHERE SEAT_NO=SEAT_NUMB;		




END $$
        
DELIMITER ;


CALL PR_TAKEORDER('SOUTH INDIAN MEALS','3',1,@MESSAGE,@ERR);


DELIMITER &
CREATE PROCEDURE MESSAGE_RETRIEVAL(IN MESSAGE VARCHAR(100),IN ERR BOOLEAN)
BEGIN
IF ERR
THEN
SELECT MESSAGE;
END IF;
END &
DELIMITER ;
CALL MESSAGE_RETRIEVAL(@MESSAGE,@ERR);


DROP PROCEDURE PR_TAKEORDER