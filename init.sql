CREATE PUBLIC DATABASE LINK database1 CONNECT TO system IDENTIFIED BY oracle USING 'database1';
CREATE PUBLIC DATABASE LINK database2 CONNECT TO system IDENTIFIED BY oracle USING 'database2';
CREATE PUBLIC DATABASE LINK database3 CONNECT TO system IDENTIFIED BY oracle USING 'database3';

CREATE TABLE SYSTEM.booking
( customer_id number(10) NOT NULL,
  customer_name varchar2(50) NOT NULL,
  city varchar2(50)
);
