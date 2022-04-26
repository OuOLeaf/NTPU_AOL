%let libData = D:\Dropbox\Andy\AOL課程評量\計算面向分數\行政、財政、不動\data;
%include 'func.sas';
proc import datafile = "&libData./104學生修課資料.xlsx" out = score104 replace;
run;

data libTable.score_data;
set score104;
/* 取出三系資料 */
depid = substr(left(id), 5, 2);
if depid in (72, 75, 76);
if level = '學士班';


if depid = 76 then department = "realest";
else if depid = 75 then department = "finan";
else if depid = 72 then department = "policy";

call streaminit(123);

/* 分數目前沒有 以隨機方式給予 */
pr = pr + 0.5;
score = round(quantile('Normal', pr/100.0, 70, 15), 1);

/* 控制在 60-100 之間 */
if score > 100 then score = 100;
else if score < 60 then score  = 60;


keep id year coursename score department;
run;
/*/* 列出學生人數 */*/
/*proc sql noprint;*/
/*select count(distinct id) into :n_stu*/
/*from libTable.score_data;*/
/*quit;*/
/**/
/*/* 列出學生學號 */*/
/*proc sql; */
/*select distinct id as stuid format=10. into :stu_id_list separated by ',' notrim */
/*from libTable.score_data;*/
/*quit;*/
;


%person_score();


/* 列出所有學生學號 */
/*proc sql;*/
/*create table student_id as */
/*select distinct id */
/*from libTable.score_data;*/
/*quit;*/
/*proc transpose data = student_id out = student_idt(drop = _name_ _label_) prefix=person;*/
/*var id;*/
/*run;*/



