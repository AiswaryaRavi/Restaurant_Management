DELIMITER $$
CREATE
   
    PROCEDURE GETORDER(IN LISTS MEDIUMTEXT,IN QUANT MEDIUMTEXT,IN SEATNOM INT)
    
    BEGIN
          DECLARE LIST1 TEXT DEFAULT NULL ;
          DECLARE NEXTLEN1 INT DEFAULT NULL;
          DECLARE VALUE1 TEXT DEFAULT NULL;
          DECLARE LIST2 TEXT DEFAULT NULL ;
          DECLARE NEXTLEN2 INT DEFAULT NULL;
          DECLARE VALUE2 TEXT DEFAULT NULL;
          DECLARE RES INT;
          TRUNCATE TABLE ORDER_GIVEN;
          SET RES=SEATCHECK1(SEATNOM);
          IF RES=1
          THEN
          INSERT INTO BILLING(SEAT_NUMBER,STATUS) VALUES(SEATNOM,'YET TO BE PAID');
          UPDATE SEAT SET SEAT_STATUS='UNAVAILABLE' WHERE SEAT_NO=SEATNOM;
          
          
         iterator :
         LOOP    
            IF LENGTH(TRIM(LISTS)) = 0 OR LISTS IS NULL OR LENGTH(TRIM(QUANT)) = 0 OR QUANT IS NULL THEN
              LEAVE iterator;
              END IF;
  
   
                 SET LIST1 = SUBSTRING_INDEX(LISTS,',',1);
                 SET NEXTLEN1 = LENGTH(LIST1);
                 SET VALUE1 = TRIM(LIST1);
                
                 SET LIST2 = SUBSTRING_INDEX(QUANT,',',1);
                 SET NEXTLEN2 = LENGTH(LIST2);
                 SET VALUE2 = TRIM(LIST2);
                 
                 CALL CHECKITEM(LIST1,LIST2,SEATNOM);
                 DO SLEEP(10);
                 
                   SET LISTS = INSERT(LISTS,1,NEXTLEN1 + 1,'');
                   SET QUANT = INSERT(QUANT,1,NEXTLEN2 + 1,'');
                   
                 

         END LOOP;
         ELSE
         SELECT'seat is unavailable';
         END IF;
         UPDATE SEAT SET SEAT_STATUS='AVAILABLE' WHERE SEAT_NO=SEATNOM;
         UPDATE BILLING SET STATUS='PAID'WHERE STATUS='YET TO BE PAID' AND SEAT_NUMBER=SEATNOM;

         END $$
        
DELIMITER ;

CALL GETORDER('Coffee,South Indian Meals','200,7',1)
DROP PROCEDURE GETORDER