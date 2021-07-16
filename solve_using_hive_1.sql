/*
Input
----------------------
W1,2
W1,1
W1,2
W1,2

Output is
----------------------
W1,1,4

Here output
-> 1 represents the count of 1 in col2
-> 4 represents the count of all records in the table
*/

CREATE TABLE w (w1 STRING, n INT);
INSERT INTO w VALUES ('W1', 2);
INSERT INTO w VALUES ('W1', 1);
INSERT INTO w VALUES ('W1', 2);
INSERT INTO w VALUES ('W1', 2);

SELECT
   w1
 , COUNT(1)  AS num_of_recs
 , SUM(id) AS num_of_1s
FROM
   (
      SELECT
         w1
       , CASE
            WHEN n = 1
               THEN 1
               ELSE 0
         END id
      FROM
         w
   ) w
GROUP BY
   w1
;


