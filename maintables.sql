CREATE TABLE FOOD_TYPES(
ID INT PRIMARY KEY,
TYPE_NAME VARCHAR(20) UNIQUE KEY NOT NULL,
FROM_TIME TIME NOT NULL,
TO_TIME TIME NOT NULL
)

CREATE TABLE MENU_ITEMS(
ID INT PRIMARY KEY AUTO_INCREMENT,
ITEM VARCHAR(20) UNIQUE KEY NOT NULL,
RATE INT NOT NULL
)

CREATE TABLE ORDER_RECORDS(
ID INT PRIMARY KEY AUTO_INCREMENT,
ORDER_ID INT NOT NULL,
SEAT_NUMBER INT NOT NULL,
MENU_ID INT NOT NULL,
QUANTITY INT NOT NULL,
TOTAL_PRICE INT NOT NULL,
ORDER_DATE DATETIME NOT NULL,
ORDER_TRACK VARCHAR(20) NOT NULL
)

CREATE TABLE SEATS(
ID INT PRIMARY KEY,
SEAT_NO INT NOT NULL,
STATUS VARCHAR(30)
)

CREATE TABLE ITEM_SCHEDULES(
ID INT PRIMARY KEY AUTO_INCREMENT,
FOOD_ID INT,
MENU_ID INT,
QUANTITY INT,
CONSTRAINT FoodType_fk1 FOREIGN KEY(FOOD_ID)REFERENCES FOOD_TYPES(ID),
CONSTRAINT MenuType_fk2 FOREIGN KEY(MENU_ID)REFERENCES MENU_ITEMS(ID)
) 


CREATE TABLE TEMP_ORDER_GIVEN(
ID INT PRIMARY KEY AUTO_INCREMENT,
ORDER_ID INT,
ITEM VARCHAR(20)NOT NULL,
QUANTITY INT NOT NULL
)


CREATE TABLE ORDERS(
ID INT PRIMARY KEY AUTO_INCREMENT,
SEAT_NUM INT NOT NULL,
STATUS VARCHAR(20)
)


INSERT INTO FOOD_TYPES VALUES(1,'Breakfast','08:00:00','11:00:00'),(2,'Lunch','11:15:00','15:00:00'),(3,'Refreshment','15:15:00','23:00:00'),(4,'Dinner','19:00:00','23:00:00')
INSERT INTO MENU_ITEMS(ITEM,RATE)VALUES('Idly',20),('Vada',6),('Dosa',40),('Poori',35),('Pongal',45),('Coffee',20),('Tea',15),('South Indian Meals',170),('North Indian Meals',280),('Variety rice',90),('Snacks',35),('Fried rice',180),('Chappathi',25),('Chat items',34)
INSERT INTO SEATS VALUES(1,1,'AVAILABLE'),(2,2,'AVAILABLE'),(3,3,'AVAILABLE'),(4,4,'AVAILABLE'),(5,5,'AVAILABLE'),(6,6,'AVAILABLE'),(7,7,'AVAILABLE'),(8,8,'AVAILABLE'),(9,9,'AVAILABLE'),(10,10,'AVAILABLE')
INSERT INTO ITEM_SCHEDULES(FOOD_ID,MENU_ID,QUANTITY) VALUES(1,1,100),(1,2,100),(1,3,100),(1,4,100),(1,5,100),(1,6,100),(1,7,100),(2,8,75),(2,9,75),(2,10,75),(3,6,200),(3,7,200),(3,11,200),(4,12,100),(4,13,100),(4,14,100)
SELECT *FROM FOOD_TYPES
SELECT *FROM MENU_ITEMS
SELECT *FROM ORDER_RECORDS
SELECT *FROM ITEM_SCHEDULES
SELECT *FROM SEATS
SELECT *FROM ORDERS








