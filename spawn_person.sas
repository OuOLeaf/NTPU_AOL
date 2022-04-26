%let libData = D:\Dropbox\Andy\AOL�ҵ{���q\�p�⭱�V����\��F�B�]�F�B����\data;
%include 'func.sas';
proc import datafile = "&libData./104�ǥͭ׽Ҹ��.xlsx" out = score104 replace;
run;

data libTable.score_data;
set score104;
/* ���X�T�t��� */
depid = substr(left(id), 5, 2);
if depid in (72, 75, 76);
if level = '�Ǥh�Z';


if depid = 76 then department = "realest";
else if depid = 75 then department = "finan";
else if depid = 72 then department = "policy";

call streaminit(123);

/* ���ƥثe�S�� �H�H���覡���� */
pr = pr + 0.5;
score = round(quantile('Normal', pr/100.0, 70, 15), 1);

/* ����b 60-100 ���� */
if score > 100 then score = 100;
else if score < 60 then score  = 60;


keep id year coursename score department;
run;
/*/* �C�X�ǥͤH�� */*/
/*proc sql noprint;*/
/*select count(distinct id) into :n_stu*/
/*from libTable.score_data;*/
/*quit;*/
/**/
/*/* �C�X�ǥ;Ǹ� */*/
/*proc sql; */
/*select distinct id as stuid format=10. into :stu_id_list separated by ',' notrim */
/*from libTable.score_data;*/
/*quit;*/
;


%person_score();


/* �C�X�Ҧ��ǥ;Ǹ� */
/*proc sql;*/
/*create table student_id as */
/*select distinct id */
/*from libTable.score_data;*/
/*quit;*/
/*proc transpose data = student_id out = student_idt(drop = _name_ _label_) prefix=person;*/
/*var id;*/
/*run;*/



