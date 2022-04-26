libname libTable 'D:\Dropbox\Andy\AOL課程評量\計算面向分數\行政、財政、不動\sas7bdat';

%macro course_ori(depname, req, elect);
%let reqCount = %eval(%sysfunc(countc(&req, '\"'))/2);
%put &reqCount;
%let electCount = %eval(%sysfunc(countc(&elect, '\"'))/2);
%put &electCount;
data &depname._cour_noori;
array reqCour [*] $100. r1-r&reqCount (&req);
array electCour [*] $100. e1-e&electCount (&elect);
do i = 1 to &electCount + &reqCount;
	if i <= &reqCount then do;
	course = reqCour{i};
	kind = 'm';
	end;
	else if i > &reqCount then do;
	course = electCour{i-&reqCount};
	kind = 'n';
	end;
	output;
	end;
keep course kind ;
run;

data libTable.&depname._cour;
set &depname._cour_noori;
call streaminit(123);
r1 = rand('integer', 0, 1);
r2 = rand('integer', 0, 1);
r3 = rand('integer', 0, 1);
do while (sum(of r1 r2 r3) = 0);
	if sum(of r1 r2 r3) = 0 then do;
	r1 = rand('integer', 0, 1);
	r2 = rand('integer', 0, 1);
	r3 = rand('integer', 0, 1);
	end;
end;
run;
proc print data = libTable.&depname._cour;
run;
%mend;

%macro person_score();
/* 列出學生人數 */
proc sql noprint;
select count(distinct id) into :n_stu
from libTable.score_data;
quit;

/* 列出學生學號 */
proc sql noprint; 
select distinct id as stuid format=10. into :stu_id_list separated by ',' notrim 
from libTable.score_data;
quit;
%do stu_id = 1 %to &n_stu;
	%let n_stu = %sysfunc(compress(&n_stu));
	data person;
	set libTable.score_data;
	array id_array [*] 8. s1-s&n_stu (&stu_id_list);
	if id = id_array{&stu_id};
	call symput('sid', compress(id_array{&stu_id}));
	run;

	data libTable.person_&sid;
	set person;
	keep id year coursename department score ;
	run;
%end;
%mend;
