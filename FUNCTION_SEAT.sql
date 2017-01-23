DELIMITER &
CREATE FUNCTION FN_SEATCHECK(SEATNUM INT)RETURNS INT
BEGIN
DECLARE FLAG INT;
DECLARE SEATAVAILABILITY VARCHAR(30);
DECLARE TOGGLE_SEATS BOOLEAN;
SELECT CONCURRENT_USER_STATE INTO TOGGLE_SEATS FROM SEATS WHERE SEAT_NO=SEATNUM; 
SELECT STATUS INTO SEATAVAILABILITY FROM SEATS WHERE SEAT_NO=SEATNUM;

/*check the availability of seats*/
IF SEATAVAILABILITY='AVAILABLE' AND toggle_seats=FALSE
	THEN
		UPDATE SEATS SET CONCURRENT_USER_STATE=NOT CONCURRENT_USER_STATE WHERE SEAT_NO=SEATNUM;
		UPDATE SEATS SET STATUS='UNAVAILABLE' WHERE SEAT_NO=SEATNUM;		

		SET FLAG=1;
	ELSE
		SET FLAG=0;
END IF;
RETURN FLAG;
END &
DELIMITER ;


SELECT FN_SEATCHECK(1)
DROP FUNCTION FN_SEATCHECK