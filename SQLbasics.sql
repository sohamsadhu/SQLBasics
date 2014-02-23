-- sql> Connect / as sysdba;

-- Create the user.
GRANT CONNECT,RESOURCE,UNLIMITED TABLESPACE TO SCOTT IDENTIFIED BY tiger;

ALTER USER SCOTT DEFAULT TABLESPACE USERS;

ALTER USER SCOTT TEMPORARY TABLESPACE TEMP;

CONNECT SCOTT/tiger

-- Create departments DEPT and EMP. And then insert values into them.
DROP TABLE DEPT;

CREATE TABLE DEPT(DEPTNO NUMBER(2) CONSTRAINT PK_DEPT PRIMARY KEY,
	DNAME VARCHAR2(14), LOC VARCHAR2(13) ) ;
	
DROP TABLE EMP;
CREATE TABLE EMP
   (EMPNO NUMBER(4) CONSTRAINT PK_EMP PRIMARY KEY,
	ENAME VARCHAR2(10),
	JOB VARCHAR2(9),
	MGR NUMBER(4),
	HIREDATE DATE,
	SAL NUMBER(7,2),
	COMM NUMBER(7,2),
	DEPTNO NUMBER(2) CONSTRAINT FK_DEPTNO REFERENCES DEPT);
	
INSERT INTO DEPT VALUES	(10,'ACCOUNTING','NEW YORK');
INSERT INTO DEPT VALUES (20,'RESEARCH','DALLAS');
INSERT INTO DEPT VALUES	(30,'SALES','CHICAGO');
INSERT INTO DEPT VALUES	(40,'OPERATIONS','BOSTON');

INSERT INTO EMP VALUES (7369,'SMITH','CLERK',7902,to_date('17-12-1980','dd-mm-yyyy'),800,NULL,20);
INSERT INTO EMP VALUES (7499,'ALLEN','SALESMAN',7698,to_date('20-2-1981','dd-mm-yyyy'),1600,300,30);
INSERT INTO EMP VALUES (7521,'WARD','SALESMAN',7698,to_date('22-2-1981','dd-mm-yyyy'),1250,500,30);
INSERT INTO EMP VALUES (7566,'JONES','MANAGER',7839,to_date('2-4-1981','dd-mm-yyyy'),2975,NULL,20);
INSERT INTO EMP VALUES (7654,'MARTIN','SALESMAN',7698,to_date('28-9-1981','dd-mm-yyyy'),1250,1400,30);
INSERT INTO EMP VALUES (7698,'BLAKE','MANAGER',7839,to_date('1-5-1981','dd-mm-yyyy'),2850,NULL,30);
INSERT INTO EMP VALUES (7782,'CLARK','MANAGER',7839,to_date('9-6-1981','dd-mm-yyyy'),2450,NULL,10);
INSERT INTO EMP VALUES (7788,'SCOTT','ANALYST',7566,to_date('13-JUL-87')-85,3000,NULL,20);
INSERT INTO EMP VALUES (7839,'KING','PRESIDENT',NULL,to_date('17-11-1981','dd-mm-yyyy'),5000,NULL,10);
INSERT INTO EMP VALUES (7844,'TURNER','SALESMAN',7698,to_date('8-9-1981','dd-mm-yyyy'),1500,0,30);
INSERT INTO EMP VALUES (7876,'ADAMS','CLERK',7788,to_date('13-JUL-87')-51,1100,NULL,20);
INSERT INTO EMP VALUES (7900,'JAMES','CLERK',7698,to_date('3-12-1981','dd-mm-yyyy'),950,NULL,30);
INSERT INTO EMP VALUES (7902,'FORD','ANALYST',7566,to_date('3-12-1981','dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMP VALUES (7934,'MILLER','CLERK',7782,to_date('23-1-1982','dd-mm-yyyy'),1300,NULL,10);

-- Create table bonus and salgrade and then insert values into them.
DROP TABLE BONUS;
CREATE TABLE BONUS
	(
	ENAME VARCHAR2(10)	,
	JOB VARCHAR2(9)  ,
	SAL NUMBER,
	COMM NUMBER
	) ;
	
DROP TABLE SALGRADE;
CREATE TABLE SALGRADE
      ( GRADE NUMBER,
	LOSAL NUMBER,
	HISAL NUMBER );
	
INSERT INTO SALGRADE VALUES (1,700,1200);
INSERT INTO SALGRADE VALUES (2,1201,1400);
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999);

COMMIT;

--1. Display all the information of EMP Table?
SELECT * FROM EMP;

--2. Display Unique jobs from EMP table?
SELECT DISTINCT JOB FROM EMP;

--3.List the emps in asc order of their salaries?
SELECT * FROM EMP ORDER BY SAL;

--4.List the details of emps in asc order of the Dptnos and desc of Jobs?
SELECT * FROM EMP ORDER BY DEPTNO ASC, JOB DESC;

--5.Display all the unique job groups in the descending order?
SELECT DISTINCT JOB FROM EMP ORDER BY JOB DESC;

--6.Display all the details of all ‘Mgrs’?
--The question is not very clear, as to what from the column mgr is required. So have done a projection on mgr.
SELECT DISTINCT MGR FROM EMP;
--The other interpretation of the question is, show the details for all the managers.
SELECT * FROM EMP WHERE JOB = 'MANAGER';

--7.List the emps who joined before 1981?
SELECT * FROM EMP WHERE HIREDATE < '01-JAN-81';

--8.List the Empno,Ename,Sal,Daily sal of all emps in the asc order of Annsal?
SELECT EMPNO, ENAME, SAL, SAL / 30 AS DAILYSAL FROM EMP ORDER BY SAL * 12;

--9.Display the Empno,Ename,Job,Hiredate,Exp of all Mgrs?
--I have taken the liberty here of showing the experience in years and rounded to two decimal places.
SELECT EMPNO, ENAME, JOB, HIREDATE, ROUND(MONTHS_BETWEEN(SYSDATE, HIREDATE) / 12, 2)  AS EXP_IN_YEARS FROM EMP WHERE JOB='MANAGER';

--10.List the all Empno,Ename,Sal,Exp,of all emps working for mgr 7369.
SELECT EMPNO, ENAME, SAL, ROUND(MONTHS_BETWEEN(SYSDATE, HIREDATE) / 12, 2) AS EXP_IN_YEARS FROM EMP WHERE MGR=7369;

--11.Display all the Details of Emps whose Comm. is more than their Sal.
SELECT * FROM EMP WHERE COMM > SAL;

--12.List the Emps in the asc order of Designation of those Joined after the second half of 1981.
--End of second half of a year is end of year, so just making sure, that date is higher than last day of year 1981.
SELECT * FROM EMP WHERE HIREDATE > '31-DEC-81' ORDER BY JOB;

--13.List the Emps along with their Exp and Daily Sal is more than RS.100.
SELECT ENAME, ROUND(MONTHS_BETWEEN(SYSDATE, HIREDATE) / 12, 2) AS EXP_IN_YEARS FROM EMP WHERE (SAL / 30) > 100;

--14.List the Emps who are either ‘CLERK’ or ‘ANALYST’ in the desc order.
SELECT ENAME FROM EMP WHERE JOB='CLERK' OR JOB='ANALYST' ORDER BY ENAME;

--15.List the emps who joined on 1-MAY-81, 3-DEC-81,17-DEC-81,19-JAN-80 in asc order of seniority.
SELECT ENAME FROM EMP WHERE HIREDATE IN ('1-MAY-81', '3-DEC-81', '17-DEC-81', '19-JAN-80') ORDER BY HIREDATE DESC;

--16.List the emp who are working for the Deptno 10 or 20.
SELECT ENAME FROM EMP WHERE DEPTNO=10 OR DEPTNO=20;

--17.List the emps who are joined in the year in 81.
SELECT ENAME FROM EMP WHERE EXTRACT(YEAR FROM HIREDATE)=1981;

--18.List the emps who are joined in the month of Aug 1980.
SELECT ENAME FROM EMP WHERE TO_CHAR(HIREDATE, 'MONTH')='AUGUST' AND TO_CHAR(HIREDATE, 'YYYY')=1980;

--19.List the emps whose Annual sal ranging from 22000 and 45000.
SELECT ENAME FROM EMP WHERE SAL * 12 BETWEEN 22000 AND 45000;

--20.List the Enames those are having five characters in their Names.
SELECT ENAME FROM EMP WHERE LENGTH( ENAME )=5;

--21.List the Enames those are starting with ‘S’ and with 5 characters.
SELECT ENAME FROM EMP WHERE ENAME LIKE 'S%' AND LENGTH( ENAME )=5;

--22.List the Emps who are having 4 characters and 3rd character must be ‘r’.
SELECT ENAME FROM EMP WHERE LENGTH( ENAME )=4 AND ENAME LIKE '__r_';

--23.List the five charactre names strating with ‘s’ and ending with ‘h’.
SELECT ENAME FROM EMP WHERE LENGTH( ENAME )=5 AND ENAME LIKE 's%h';

--24.List the Emps who Joined in January.
SELECT ENAME FROM EMP WHERE EXTRACT(MONTH FROM HIREDATE)=1;

--25.List the Emps who joined in the month of which second character is ‘a’.
SELECT ENAME FROM EMP WHERE TO_CHAR(HIREDATE,'MONTH') LIKE '_a%';

--26. Display Unique jobs from EMP table?
SELECT DISTINCT job FROM EMP;

--27. Display all the unique job groups in the descending order?
SELECT DISTINCT job FROM EMP ORDER BY job DESC;

--28. List the Emps whose Sal is four digit number ending with Zero(0).
SELECT ENAME FROM EMP WHERE LENGTH( SAL )=4 AND MOD( SAL, 10 )=0;

--29. List the emps whose names having character set ‘LL’ together.
SELECT ENAME FROM EMP WHERE ENAME LIKE '%LL%';

--30. List the emps those who Joined in 80’s.
SELECT ENAME FROM EMP WHERE TO_CHAR( HIREDATE, 'YYYY')=1980;

--31. List the emps who does not belong to deptno 20.
SELECT ENAME FROM EMP WHERE DEPTNO <> 20;

--32. List all the emps except ‘PRESIDENT’ & ‘MGR’ in asc order of salaries.
SELECT ENAME FROM EMP WHERE JOB <> 'MANAGER' AND JOB <> 'PRESIDENT';

--33. List all the emps who joined before or after 1981.
SELECT ENAME FROM EMP WHERE TO_CHAR( HIREDATE, 'YYYY') <> 1981;

--34. List the emps whose Empno not starting with digit 78.
SELECT ENAME FROM EMP WHERE EMPNO NOT LIKE '78%';

--35. List the emps who joined in any year but not belongs to month of march.
SELECT ENAME FROM EMP WHERE TO_CHAR(HIREDATE, 'MON')<>'MAR';

--36. List all the Clerks of Deptno 20.
SELECT ENAME FROM EMP WHERE JOB='CLERK' AND DEPTNO=20;

--37. List the emps of Deptno 30 or 10 joined in the year 1981.
SELECT ENAME FROM EMP WHERE TO_CHAR(HIREDATE, 'YYYY')=1981 AND DEPTNO IN (10, 30);

--38. Display the details of ‘SMITH’.
SELECT * FROM EMP WHERE ENAME='SMITH';

--39. List the details of emps whose salaries more than BLAKE.
SELECT * FROM EMP WHERE SAL > ( SELECT SAL FROM EMP WHERE ENAME='BLAKE');

--40. List the emps whose job is same as ALLEN.
SELECT * FROM EMP WHERE JOB=( SELECT JOB FROM EMP WHERE ENAME='ALLEN');
-- This will include even Allen in the record, since we are searching for all employees with the job same as that of Allen. To remove Allen we can restructure the query with minus
SELECT * FROM EMP WHERE JOB=( SELECT JOB FROM EMP WHERE ENAME='ALLEN') MINUS SELECT * FROM EMP WHERE ENAME='ALLEN';

--41. List the emps who are senior to the KING.
SELECT ENAME FROM EMP WHERE (SELECT HIREDATE FROM EMP WHERE ENAME='KING') > HIREDATE;

--42. List the emps who are senior to their own MGRS.
SELECT E1.ENAME FROM EMP E1 WHERE E1.HIREDATE < (SELECT E2.HIREDATE FROM EMP E2 WHERE E2.EMPNO = E1.MGR);

--43. List the emps of Deptno 20 whose jobs are same as Deptno 10.
-- This is not my solution. This was provided to me by some one else.
select * from emp where job in (select job from emp where deptno = 10) and deptno = 20;

--44. List the emps whose sal is same as FORD or SMITH in desc order of sal.
SELECT ENAME FROM EMP WHERE SAL IN (SELECT SAL FROM EMP WHERE ENAME IN ('FORD', 'SMITH')) ORDER BY SAL DESC;

--45. List the emps whose jobs are same as MILLER or sal is more than ALLEN.
SELECT ENAME FROM EMP WHERE JOB=(SELECT JOB FROM EMP WHERE ENAME='MILLER') OR SAL > (SELECT SAL FROM EMP WHERE ENAME='ALLEN');

--46. List the emps whose Sal is > the total remuneration of the SALESMAN.
SELECT ENAME FROM EMP WHERE SAL > (SELECT SUM(SAL) FROM EMP GROUP BY JOB HAVING JOB='SALESMAN');

--47. List the emps whose jobs same as SMITH or ALLEN.
SELECT ENAME FROM EMP WHERE JOB IN (SELECT JOB FROM EMP WHERE ENAME IN ('SMITH', 'ALLEN')) MINUS SELECT ENAME FROM EMP WHERE ENAME IN ('SMITH', 'ALLEN');

--48. find the highest Sal of EMP TABLE.
SELECT MAX(SAL) FROM EMP;

--49. Find details of highest paid employee.
SELECT * FROM EMP WHERE SAL=(SELECT MAX(SAL) FROM EMP);

--50. Find highest paid employee of sales department.
SELECT * FROM EMP WHERE JOB='SALESMAN' AND SAL=(SELECT MAX(SAL) FROM EMP GROUP BY JOB HAVING JOB='SALESMAN');

--51. List the employees who are senior to most recently hired working under KING.
SELECT ENAME FROM EMP WHERE HIREDATE < (SELECT MAX(HIREDATE) FROM EMP WHERE MGR = (SELECT EMPNO FROM EMP WHERE ENAME LIKE 'KING'));

--52. List the details of senior employee belongs to 1981.
SELECT * FROM EMP WHERE HIREDATE=(SELECT MIN(HIREDATE) FROM EMP GROUP BY TO_CHAR(HIREDATE, 'YYYY') HAVING TO_CHAR(HIREDATE, 'YYYY')='1981');

--53. List the employeees who joined in 1981 with the job same as the most senior person of the year 1981.
SELECT ENAME FROM EMP WHERE TO_CHAR(HIREDATE, 'YYYY')='1981' AND JOB LIKE (SELECT JOB FROM EMP WHERE HIREDATE=(SELECT MIN(HIREDATE) FROM EMP GROUP BY TO_CHAR(HIREDATE, 'YYYY') HAVING TO_CHAR(HIREDATE, 'YYYY')='1981'));

--54. Find the total annual sal to distribute job wise in the year 81.
--Not sure what the question is. Have interpreted as the sum of the salary paid to the employees in year 1981 based on their joining date.
SELECT SUM(SAL * (13 - ( EXTRACT(MONTH FROM HIREDATE)))) FROM EMP WHERE TO_CHAR(HIREDATE, 'YYYY') LIKE '%1981%';

--55. Display the average salaries of all the clerks.
SELECT AVG( SAL ) FROM EMP WHERE JOB LIKE '%CLERK%';

--56. List the employee in deptno 20 whose sal is > the average sal of dept 10 emps.
SELECT ENAME FROM EMP WHERE DEPTNO=20 AND SAL > (SELECT AVG(SAL) FROM EMP WHERE DEPTNO=10);

--57. Display the number of employee for each job group deptno wise.
SELECT DEPTNO, JOB, COUNT(ENAME) AS EMPLOYEE FROM EMP GROUP BY DEPTNO, JOB ORDER BY DEPTNO;

--58. List the manager no and the number of employees working for those mgrs in the ascending Mgrno.
SELECT MGR, COUNT(ENAME) FROM EMP GROUP BY MGR;

--59. List the details of department where maximum number of emps are working.
SELECT * FROM DEPT WHERE DEPTNO = ( SELECT DEPTNO FROM (SELECT DEPTNO, COUNT(DEPTNO) FROM EMP GROUP BY DEPTNO ORDER BY COUNT(DEPTNO) DESC) WHERE ROWNUM < 2);

--60. Display the emps whose manager name is JONES.
SELECT ENAME FROM EMP WHERE MGR = (SELECT EMPNO FROM EMP WHERE ENAME LIKE 'JONES');

--61. List the emps whose sal is more than 3000 after giving 20% increment.
SELECT ENAME FROM EMP WHERE (SAL + SAL * 0.2) > 3000;

--62. List the emps with dept names.
SELECT ENAME, DNAME FROM EMP, DEPT WHERE EMP.DEPTNO = DEPT.DEPTNO;

--63. List the emps who are not working in sales dept.
SELECT ENAME, DNAME FROM EMP, DEPT WHERE EMP.DEPTNO = DEPT.DEPTNO AND DNAME NOT LIKE 'SALES';

--64. List the emps name,dept,sal and comm . For those whose sal is between 2000 and 5000 while loc is CHICAGO.
SELECT ENAME, DNAME, SAL, COMM FROM EMP, DEPT WHERE SAL BETWEEN 2000 AND 5000 AND LOC LIKE 'CHICAGO';

--65. List the emps whose sal is greater then their managers salary.
SELECT E1.ENAME FROM EMP E1, EMP E2 WHERE E1.SAL > E2.SAL AND E1.MGR = E2.EMPNO;

--66. List the grade,EMP name for the deptno 10 or deptno 30 but sal grade is not 4 while they joined the company before ’31-dec-82’.
SELECT ENAME, GRADE FROM EMP, SALGRADE WHERE SAL BETWEEN LOSAL AND HISAL AND GRADE <> 4 AND HIREDATE < '31-DEC-82' AND (DEPTNO = 10 OR DEPTNO = 30);

--67. List the name ,job ,dname,location for those who are working as MGRS.
SELECT ENAME, JOB, DNAME, LOC FROM EMP, DEPT WHERE EMP.DEPTNO=DEPT.DEPTNO AND JOB LIKE 'MANAGER';

--68. List the emps whose mgr names is jones and also list their manager name.
SELECT E1.ENAME, E2.ENAME FROM EMP E1, EMP E2 WHERE E2.ENAME LIKE 'JONES' AND E1.MGR = E2.EMPNO;

--69. List the name and salary of ford if his salary is equal to hisal of his grade
SELECT ENAME, SAL FROM EMP WHERE ENAME LIKE 'FORD' AND SAL = ANY (SELECT HISAL FROM SALGRADE);

--70. List the emps name, job who are with out manager.
SELECT ENAME, JOB FROM EMP WHERE MGR IS NULL;

--71. List the names of the emps who are getting the highest sal dept wise.
SELECT E1.ENAME FROM EMP E1, (SELECT MAX(SAL) AS SAL, DEPTNO FROM EMP GROUP BY DEPTNO) E2 WHERE E1.DEPTNO = E2.DEPTNO AND E1.SAL = E2.SAL;

--72. List the emp sal whose sal is average of max and min salaries.
SELECT ENAME FROM EMP WHERE SAL = ((SELECT MAX(SAL) FROM EMP) + ( SELECT MIN(SAL) FROM EMP)) / 2;

--73. List the most recently hired emp of grade3 belongs to location CHICAGO.
SELECT ENAME FROM  (SELECT ENAME, LOC, SAL, HIREDATE FROM EMP, DEPT WHERE EMP.DEPTNO = DEPT.DEPTNO AND LOC LIKE 'CHICAGO' AND SAL BETWEEN (SELECT LOSAL FROM SALGRADE WHERE GRADE=3) AND (SELECT HISAL FROM SALGRADE WHERE GRADE=3)) WHERE HIREDATE = (SELECT MAX(HIREDATE) FROM (SELECT ENAME, LOC, SAL, HIREDATE FROM EMP, DEPT WHERE EMP.DEPTNO = DEPT.DEPTNO AND LOC LIKE 'CHICAGO' AND SAL BETWEEN (SELECT LOSAL FROM SALGRADE WHERE GRADE=3) AND (SELECT HISAL FROM SALGRADE WHERE GRADE=3))); 

--74. List the emp whose sal<his manager but more than any other manager.
SELECT E1.ENAME FROM EMP E1, EMP E2 WHERE E1.SAL < E2.SAL AND E2.EMPNO = E1.MGR AND E1.SAL > ANY (SELECT SAL FROM EMP WHERE JOB LIKE 'MANAGER');

--75. Find out least five earners of the company.
SELECT ENAME FROM (SELECT ENAME FROM EMP ORDER BY SAL) WHERE ROWNUM <= 5;

--76. Count the no.of emps who are working as ‘Managers’(using set option).
If it was not for the condition then a normal query to get this would be 
SELECT COUNT(JOB) FROM EMP GROUP BY JOB HAVING JOB LIKE '%MANAGER%';
--However not sure, what the set option actually means. In SQLPlus set option actually does things on how to arrange or set the display format like something shown here http://ss64.com/ora/syntax-sqlplus-set.html . It has got nothing to do with DML or DQL commands, so not sure how would this work out.

--77. List the emps who joined in the company on the same date.
SELECT ENAME FROM EMP WHERE HIREDATE IN (SELECT HIREDATE FROM EMP GROUP BY HIREDATE HAVING COUNT(HIREDATE) > 1);

--78. List the managers name who is having max no.of emps working under him.
SELECT ENAME FROM EMP WHERE EMPNO = (SELECT MGR FROM (SELECT MGR FROM EMP GROUP BY MGR ORDER BY COUNT(MGR) DESC) WHERE ROWNUM < 2);

--79. Find average salary and Average total remuneration for each job type. Remember Salesman earn commission.
SELECT JOB, AVG(SAL), AVG(SAL) + AVG(COMM) AS RENUMERATION FROM EMP GROUP BY JOB;

--80. List the emps who are drawing less than 1000 Sort the output by Salary.
SELECT ENAME FROM EMP WHERE SAL < 1000 ORDER BY SAL;

--81. List the employee Name,Job,Annual Salary,deptno,Dept name and Grade who earn 36000 a year or who are not CLERKS.
SELECT ENAME, JOB, SAL * 12 AS "ANNUAL SAL", EMP.DEPTNO, DEPT.DNAME, GRADE FROM EMP, DEPT, SALGRADE  WHERE EMP.DEPTNO = DEPT.DEPTNO AND GRADE=(SELECT GRADE FROM SALGRADE WHERE SAL BETWEEN LOSAL AND HISAL) AND (JOB NOT LIKE 'CLERK' OR SAL* 12 > 36000);

--82. Find out the emps who joined in the company before their Managers.
SELECT E1.ENAME FROM EMP E1, EMP E2 WHERE E1.MGR = E2.EMPNO AND E1.HIREDATE < E2.HIREDATE;

--83. List all the emps by name and number along with their Manger’s name and number. Also List KING who has no ‘Manager’.
SELECT E1.ENAME AS "EMP NAME", E1.EMPNO AS "EMP NUMBER", E2.ENAME AS "MGR NAME", E2.EMPNO AS "MGR NO" FROM EMP E1 LEFT OUTER JOIN EMP E2 ON E1.MGR = E2.EMPNO;

--84. Find all the emps who earn the minimum Salary for each job wise in ascending order.
SELECT ENAME, JOB, SAL FROM EMP WHERE SAL IN (SELECT MIN(SAL) AS SAL FROM EMP GROUP BY JOB) ORDER BY SAL;

--85. Find out all the emps who earn highest salary in each job type. Sort in descending salary order.
SELECT ENAME, JOB, SAL FROM EMP WHERE SAL IN (SELECT MAX(SAL) AS SAL FROM EMP GROUP BY JOB) ORDER BY SAL DESC;

--86. Find out the most recently hired emps in each Dept by Hiredate.
SELECT ENAME, JOB, HIREDATE FROM EMP WHERE HIREDATE IN (SELECT MAX(HIREDATE) AS HIREDATE FROM EMP GROUP BY JOB);

--87. List the emps who joined in the month having char ‘a’.
SELECT ENAME,  HIREDATE FROM EMP WHERE TO_CHAR(HIREDATE,'MONTH') LIKE '%A%';

--88. List the emps who joined in the month having second char ‘a’.
SELECT ENAME,  HIREDATE FROM EMP WHERE TO_CHAR(HIREDATE,'MONTH') LIKE '_A%';

--89. List the emps whose salary is 4 digit number.
SELECT ENAME,  SAL FROM EMP WHERE LENGTH(SAL)=4;

--90. List the emp who joined in 80’s.
SELECT ENAME, HIREDATE FROM EMP WHERE TO_CHAR(HIREDATE, 'YYYY') LIKE '1980';

--91. List the emp who are clerks who have exp more than 8yrs.
SELECT ENAME, JOB, HIREDATE FROM EMP WHERE JOB LIKE 'CLERK' AND MONTHS_BETWEEN(SYSDATE, HIREDATE) > (8 * 12);

--92. List the mgrs of dept 10 or 20.
SELECT DISTINCT E1.ENAME FROM EMP E1, EMP E2 WHERE E1.EMPNO = E2.MGR AND (E2.DEPTNO = 10 OR E2.DEPTNO = 20);

--93. List the emps joined in jan with salary ranging from 1500 to 4000.
SELECT ENAME, HIREDATE, SAL FROM EMP WHERE TO_CHAR(HIREDATE, 'MON') LIKE 'JAN' AND SAL BETWEEN 1500 AND 4000;

--94. List the details of the emps working at CHICAGO.
SELECT ENAME FROM EMP, DEPT WHERE EMP.DEPTNO = DEPT.DEPTNO AND DEPT.LOC LIKE 'CHICAGO';

--95. List the emps working under the mgrs 7369,7890,7654,7900.
SELECT ENAME FROM EMP WHERE MGR IN (7369,7890,7654,7900);

--96. List the empno,ename,deptno,loc of all the emps.
SELECT EMPNO, ENAME, EMP.DEPTNO, LOC FROM EMP, DEPT WHERE EMP.DEPTNO = DEPT.DEPTNO;

--97. List the mgrs who are senior to KING and who are junior to SMITH.
SELECT ENAME, HIREDATE FROM EMP WHERE HIREDATE < (SELECT HIREDATE FROM EMP WHERE ENAME LIKE 'KING') AND HIREDATE > (SELECT HIREDATE FROM EMP WHERE ENAME LIKE 'SMITH');

--98. List the emps along with loc of those who belongs to dallas, newyork with sal ranging from 2000 to 5000 joined in 81.
SELECT ENAME FROM EMP WHERE TO_CHAR(HIREDATE, 'YYYY') LIKE '1981' AND SAL BETWEEN 2000 AND 5000 AND DEPTNO IN (SELECT DEPTNO FROM DEPT WHERE LOC LIKE 'DALLAS' OR LOC LIKE 'NEW YORK');

--99. List the emps with loc and grade of accounting dept or the locs dallas or chicago with the grades 3 to 5 & exp>6y.
SELECT ENAME FROM EMP, DEPT, SALGRADE WHERE EMP.DEPTNO = DEPT.DEPTNO AND (LOC LIKE 'DALLAS' OR LOC LIKE 'CHICAGO' OR DNAME LIKE 'ACCOUNTING') AND MONTHS_BETWEEN(SYSDATE, HIREDATE) > 6 * 12 AND SAL BETWEEN LOSAL AND HISAL AND GRADE BETWEEN 3 AND 5;

--100. List the highest paid emp of Chicago joined before the most recently hired emp of grade 2.
SELECT ENAME FROM (SELECT ENAME FROM EMP, DEPT WHERE EMP.DEPTNO = DEPT.DEPTNO AND LOC LIKE 'CHICAGO' AND HIREDATE < (SELECT HIREDATE FROM (SELECT HIREDATE FROM EMP, SALGRADE WHERE SAL BETWEEN LOSAL AND HISAL AND GRADE = 2 ORDER BY HIREDATE DESC) WHERE ROWNUM < 2) ORDER BY SAL DESC) WHERE ROWNUM < 2;
