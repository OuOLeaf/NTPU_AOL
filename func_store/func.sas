libname libTable 'D:\Dropbox\Andy\AOL課程評量\計算面向分數\行政、財政、不動\sas7bdat';

%macro course_ori(depname, req, elect, ori_c);
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
	kind = 'n';
	end;
	else if i > &reqCount then do;
	course = electCour{i-&reqCount};
	kind = 'm';
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

proc sort data = libTable.&depname._cour;
by kind;
run;
proc means data = libTable.&depname._cour sum;
by kind;
var r1-r&ori_c;
ods output summary = sm;
run;

title '面向檔總匯';
data smv;
set sm(drop = vname:);
/* 將面向輸入到變數中 */
array courclass [2] $3. ("m", "n");
format m1-m&ori_c n1-n&ori_c $3.;
/* retain 把第一列的變數保留到後面*/
retain m1-m&ori_c n1-n&ori_c;
k = 2*&ori_c;
array courseMN [*] $3. m1-m&ori_c n1-n&ori_c;
array oriArray [*] $3. r1_sum--r&ori_c._sum;
do i = 1 to k;
	if kind = courclass{ceil(i/3)} then  courseMN{i} = oriArray{mod((i+2), 3) + 1}; 
end;
k = 1;
/*挑最後一列和取用變數*/
if kind = 'n';
keep  m1-m&ori_c n1-n&ori_c k;
run;
proc sort data = libTable.&depname._cour;
by course;
run;


proc print data = smv;
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
%macro course_cal(id,  department, req_list, elect_list, countOri);


data courseori;
set libTable.&department._cour;
run;

data person;
set libTable.person_&id;
run;

proc sort data = courseori;
by course;
run;
proc sort data = person;
by coursename;
run;
data personCour;
merge person courseori(rename = (course = coursename));
by coursename;
k = 1;
if courseName in (&req_list) then kind = 'm';
else if courseName in (&elect_list) then kind = 'n';
if kind ^= '' and score ^='';
run;
proc print;run;
proc sort data = personCour;
by kind year;
run;

data personOri;
merge personCour smv ;
by k;
drop k;
/* 計算分數 */
array score_ori ori_1-ori_&countOri;
array haveori r1-r&countOri;
array mori m1-m&countOri;
array nori n1-n&countOri;
array mscore ms1-ms&countOri;
array nscore ns1-ns&countOri;
do i = 1 to 3;

/*n 是必修 m 是選修*/
/* 以下的程式說明 分別算出細格分數*/
mscore{i} = (score - 60)/(90 - 60)/mori{i};
nscore{i} = ((score - 60)/(90 - 60)+3)/nori{i};

/*補0方便之後計算*/
if haveori{i} = 0 then do;
mscore{i} = 0;
nscore{i} = 0;
end;

if kind = 'n' then mscore{i} = 0;
if kind = 'm' then nscore{i} = 0;

/*將必選修分別的分數放在同一欄*/
score_ori{i} = mscore{i} + nscore{i};
end;

keep year ori_1-ori_&countOri;
run;
proc print;run;

/*補上可能某幾年沒有值*/
data personOri;
set personori end = eof;
output;
array score_ori ori_1-ori_&countOri;
if eof then do;	
do j = 104, 105, 106, 107;
year = j;
do i= 1 to &countOri;
score_ori{i} = 0;
end;
output;
end;
end;


drop i j;
run;


proc sort data = personOri;
by year;
run;
proc means data = personOri sum;
by year;
var ori_1-ori_&countOri;
ods output summary = ori_score ;
run;
proc print;run;

data ori_score;
set ori_score(drop = vname:);
retain ori_1-ori_&countOri;
array arrOri ori_1-ori_&countOri;
array arrOriSum ori_1_Sum--ori_&countOri._Sum;
by year;
do i = 1 to &countOri;
arrOri{i} + arrOriSum{i};
end;

do i = 1 to &countOri;
if arrOri{i} > 5 then arrOri{i} = 5;
end;
if year>=104 and year <= 108;
keep year ori_1-ori_&countOri;
run;

proc transpose data=ori_score out=libTable.score_&id. prefix=year_ori;
by year;
var ori_1-ori_&countOri; 
run;

proc print;run;

%mend;



%macro draw_radar_to(id);
proc format;
value $ orif
ori_1 = "創意思考與問題解決"
ori_2 = "多元關懷"
ori_3 = "溝通協調";
value yearf
104 = '第一年'
105 = '第二年'
106 = '第三年'
107 = '第四年';
run;
goptions reset=all cback=white border htitle=20 pt htext = 10 pt; 
title1 f='MingLiU'"&id" height = 10 pt;

axis1 order=(0 to 5 by 1) label=(h=12pt) value=(height=2pct tick=1);
axis2 order=(0 to 5 by 1) label=(h=12pt) ;
axis3 order=(0 to 5 by 1) label=(h=12pt) ;

proc gradar data=libTable.score_&id.;
chart _NAME_ / 
sumvar = year_ori1  /*give the digits*/
overlay = year /* detach by year*/
starinradius=2
cstars=(CXFFA500 CX4682B4 CXF08080 CX2E8B57)
caxis = black /*framecolor*/
cspokes = black /* spoke 軸的顏色 */
staraxis=(axis1 axis2 axis3)
 font ='MingLiU'
 lstar = 1 1 1 1
 wstar =(3 3 3 3);
format _NAME_ $orif. year yearf.;
label
year = '修課的年度';
run;
quit;
%mend;





%macro spawn_radar_score(depart, req_list, elect_list);
proc sql noprint;
select distinct id format=10. into :stuid_list  separated by ' ' notrim
from libTable.score_data
where department = "&depart."; 
quit;
proc sql;
select count(distinct id) into :nstu
from libTable.score_data
where department = "&depart."; 
quit;
%global stu_list stu_num;
%let stu_list = &stuid_list;
%let stu_num = &nstu;

%do i = 1 %to &nstu;  
      %let mvar = %scan(&stuid_list, &i, %str( ));
      %course_cal(&mvar, &depart, &req_list, &elect_list, 3);
%end;

%mend;

%macro output_doc(depart, allStudentsNum, numberOfStudent);
ods rtf file = "D:\Dropbox\Andy\AOL課程評量\計算面向分數\行政、財政、不動\radar_to\radar_&depart..doc";
%do j = 1 %to &numberOfStudent;  
      %let mvar = %scan(&allStudentsNum, &j, %str( ));
      %draw_radar_to(&mvar);
%end;
ods rtf close;
DM log "OUT;CLEAR;LOG;CLEAR;";
dm 'odsresults; clear';
%mend;
