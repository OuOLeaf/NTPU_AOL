libname libTable 'D:\Dropbox\Andy\AOL�ҵ{���q\�p�⭱�V����\��F�B�]�F�B����\sas7bdat';

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

data smv;
set sm(drop = vname:);
/* �N���V��J���ܼƤ� */
array courclass [2] $3. ("m", "n");
format m1-m&ori_c n1-n&ori_c $3.;
/* retain ��Ĥ@�C���ܼƫO�d��᭱*/
retain m1-m&ori_c n1-n&ori_c;
k = 2*&ori_c;
array courseMN [*] $3. m1-m&ori_c n1-n&ori_c;
array oriArray [*] $3. r1_sum--r&ori_c._sum;
do i = 1 to k;
	if kind = courclass{ceil(i/3)} then  courseMN{i} = oriArray{mod((i+2), 3) + 1}; 
end;
k = 1;
/*�D�̫�@�C�M�����ܼ�*/
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
/* �C�X�ǥͤH�� */
proc sql noprint;
select count(distinct id) into :n_stu
from libTable.score_data;
quit;

/* �C�X�ǥ;Ǹ� */
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
%macro course_cal(id,  department, countOri);
%if &department = 'policy' %then %do;
%let req_list = "���|��Ǭ�s��k" "����F��" "���@�F��" "���إ���˪k�P�F��" "�q�Ƭ�s��k�]�@�^" 
				"�q�Ƭ�s��k(�@)�G" "�q�Ƭ�s��k�]�@�^�G��¦�έp���R" "����F�v��Q�v" "�]�Ȧ�F" 
		"�H�Ʀ�F" "��v�F�v��Q�v" "��F�۲z" "�a��F��"  "�D��Q��´�޲z" 
				"�F�v��" "��F��" "��F�k";
%let elect_list = "���@�ưȪv�z�ɽ�" "�k�Ǻ���" "���@�޲z���" "�g�پ�" "���|��Ǹ�ƳB�z�P�{���]�p�ɽ�" 
						"�F�v�o�i�z��" "�F���Z�ĺ޲z" "���@�A�Ⱦǲ߻P���|���h" "��ڬF�v�g�پ�" "���|�P�벼�欰" 
						"�F�v���Ǿɽ�" "�]�F��" "�x����׻P�欰" "�F������" "�F���W��" 
						"�H�O�귽�M�D" "�����޲z" "�C��B���~�P�F�v" "���@�F���W�۾�Ū" "�F���P���~"
					 	"���D�F�v�P�j���C��" "���|�зs�P���|���~" "�F������" "�F�v���|��" "�C��P���N" 
						"�⩤���Y�P��ڬF�v" "�F�v���ǦW�ۿ�Ū" "�һͲz�׻P���" "���D�P���|" "���q�Ч�"
					 	"���N�լd�P���R" "�q�Ƭ�s��k�]�G�^" "�q�Ƭ�s��k�]�G�^�G�F����Ƥ��R" "��´�z�׻P�欰" "�D�F����´"
					 	"���|���~" "���|���~�P���q�Ч�" "�q�l�ƬF��" "�F�����R" "�ڬw�ΦX�ɽ�" 
						"�H�O�귽�޲z" "���F��" "����F�v��ץv" "�j���ظg�ٰ�" "�x�W�F�v�o�i"
					 	"���k���n" "���|��" "�����P�F�v" "�Ȭw�q�v�P�F�v" "��|�k�פ��R"
					 	"���t�P�����t�F��" "�ڬw�g�ٻP�f����X" "���@�޲z" "�޲z��" "����o�i�F��" 
						"�F����w�L�{" "�߲z��" "�зN���" "�����F" "�F�ҧQ�q����P�F��"
						"�ߪk�{��" "�F�v�g�پ�" "����F�v" "��F����" "��F�޲z�M�D" 
						"�U��H�ƨ��" "�H�s���Y" "ĳ�|�F�v" "�H�O�귽�o�i" "�a��]�F�M�D" 
						"�����ѻP" "�x�W���@��F�M�D" "���D�F�v�P�j���C��" "��F�ǦW�ۿ�Ū" "�H�O�W��"
					 	"�������|�ɽ�" "���t�F���P�F�v" "�x�W���@�F���M�D" "���y�F�v�g�٤Τ��@�F��" "���|��Ǭ�s��k��" 
						"��´�g�پ�" "��Ƭ�s��k" "�`��g�پ�" "��N�U�إD�q" "�F����P"
						"��F���s�M�D" "�⩤���Y�M�D";
%end;
%else %if &department = finan %then %do;
%let req_list = "�έp��" "����g�پ�" "�`��g�پ�" "�f���Ȧ��" "�ұo�|�z�׻P���" 
				"���|�k" "�L�n��" "�g�پ�" "�|�p��" "�Өƪk"
                "�]�F�ǡ]�@�^" "���ŷ|�p��" "���O�|�z�׻P���" "�]���|�z�׻P���";
%let elect_list = "���k���n" "�g�ټƾ�" "���Ųz�׻P�޲z" "��ڪ��Ĳz�׻P�F��" "�����g�ٻP�F��" 
						"�p�q�g�پ�" "�]�F�ǡ]�G�^"  "���Ĩ�׻P���" "�����|�p" "�欰�]�F��"
                       	"���|�w�����(�@)" "����:�z�׻P�ʲz" "�w��z�׻P���" "�]�F�ǦW�ۿ�Ū" "��گ��|"
                        "�ɧ��z��" "������|���" "���@���" "�]�Ⱥ޲z" "�����įq���R" 
						"�]�ȳ�����R" "�a��]�F" "���|�z�׻P���" "�]�Fĳ�D�P�n������" "�����]�F"
                        "�]�F�j����" "��ڪ��ıM�D" "������|���(�@)" "���|�w����׻P�F��(�@)" "������|���(�G)"
                       "�]�F���Ĺ�Ȥ��R" "���|�w����׻P�F��(�G)" "�]�F���Ĺ��" "���@�ưȱM�D" "�]�F�j����";
%end;
%else %if &department = realest %then %do;
%let req_list = "�ؿv�Ƿ���" "�έp��" "���ҳW��" "�g�a�k" "�g�a�g�پ�" 
				"�a�z��T�t��" "���ҳW��" "���ʲ�����" "�g�a�n�O" "�����ΰϰ�p�e�z��" 
				"�g�a�F��" "���ʲ��������" "���ʲ��P���m���ұM�D" "���k���n" "�g�پ�"
                "���q��" "�����p�e" "�a�y���q" "�����g�a�ϥΤΥ�q�B��p�e" "�a�y���q";
%let elect_list = "�L�n��" "�q�����Uø��" "���ʲ��޲z" "�q�����Uø��" "�s�Ͼ�" 
						"�פ�g�@��k" "�۵M�a�`�P�ìP��T" "���ʲ���P" "���ʲ��g�پ�" "���@�]�I�p�e" 
						"��Ʈw�޲z�t��" "���ʲ��]�Ⱥ޲z" "���Ϩϥκި�" "���ʲ���P" "�����]�p�]�@�^"
                        "�����g�پ�" "���Ϩϥκި�" "��v���D" "�W�����R" "���ʲ��P���m���ҹ�Ⱦާ@" 
						"���ʲ����" "������s" "�p�e�P���|" "�����ΰϰ�F��" "���ʲ��������R"
                       	"���ʲ��g���k�W" "���ҥͺA��" "�p�e�k�W" "�g�a�|�k�W" "���ʲ����" 
						"�a�Ͼ�" "���q���t�k�]�@�^" "�g�a�����P�x��" "�ͺA�x�W" "�g�a�n�O���" 
						"���ʲ��}�o" "���ʲ�����" "�ìP�w����q" "�H�U�k" "�a���P�a�|�z��"
                        "�a�`�޲z" "���ʲ��|������" "���Ҫk" "���q���t�k�]�G�^" "���m���Ϧw���P��a���" 
						"���ʲ��g��޲z" "���һ���" "�Ʀ�v���B�z" "�~�a��������" "���ϵo�i�P��ȡ]�@�^"
                        "�g�a�k��Ȭ�s�]�@�^" "�W����ȡ]�@�^" "���q���" "�a�z��T�t�ι��" "�W����ȡ]�G�^" 
						"�j�a���q��" "�����v���q" "���ʲ��]�Ȥ��R" "�ؿv����" "��F�k"
						"�����o�i" "���ʲ��g�٤��R" "�j�ƾڤ������P����" "�g�a�Q�λP���Ҫk";
%end;

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
/* �p����� */
array score_ori ori_1-ori_&countOri;
array haveori r1-r&countOri;
array mori m1-m&countOri;
array nori n1-n&countOri;
array mscore ms1-ms&countOri;
array nscore ns1-ns&countOri;
do i = 1 to 3;

/*n �O���� m �O���*/
/* �H�U���{������ ���O��X�Ӯ����*/
mscore{i} = (score - 60)/(90 - 60)/mori{i};
nscore{i} = ((score - 60)/(90 - 60)+3)/nori{i};

/*��0��K����p��*/
if haveori{i} = 0 then do;
mscore{i} = 0;
nscore{i} = 0;
end;

if kind = 'n' then mscore{i} = 0;
if kind = 'm' then nscore{i} = 0;

/*�N����פ��O�����Ʃ�b�P�@��*/
score_ori{i} = mscore{i} + nscore{i};
end;

keep year ori_1-ori_&countOri;
run;
proc print;run;

/*�ɤW�i��Y�X�~�S����*/
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
keep year ori_1-ori_&countOri;
run;

proc transpose data=ori_score out=libTable.score_&id. prefix=year_ori;
by year;
var ori_1-ori_&countOri; 
run;

proc print;run;

%mend;







%macro spawn_radar_score(depart);
%if &depart = policy %then %do;
%let req_list = "���|��Ǭ�s��k" "����F��" "���@�F��" "���إ���˪k�P�F��" "�q�Ƭ�s��k�]�@�^" 
				"�q�Ƭ�s��k(�@)�G" "�q�Ƭ�s��k�]�@�^�G��¦�έp���R" "����F�v��Q�v" "�]�Ȧ�F" 
		"�H�Ʀ�F" "��v�F�v��Q�v" "��F�۲z" "�a��F��"  "�D��Q��´�޲z" 
				"�F�v��" "��F��" "��F�k";
%let elect_list = "���@�ưȪv�z�ɽ�" "�k�Ǻ���" "���@�޲z���" "�g�پ�" "���|��Ǹ�ƳB�z�P�{���]�p�ɽ�" 
						"�F�v�o�i�z��" "�F���Z�ĺ޲z" "���@�A�Ⱦǲ߻P���|���h" "��ڬF�v�g�پ�" "���|�P�벼�欰" 
						"�F�v���Ǿɽ�" "�]�F��" "�x����׻P�欰" "�F������" "�F���W��" 
						"�H�O�귽�M�D" "�����޲z" "�C��B���~�P�F�v" "���@�F���W�۾�Ū" "�F���P���~"
					 	"���D�F�v�P�j���C��" "���|�зs�P���|���~" "�F������" "�F�v���|��" "�C��P���N" 
						"�⩤���Y�P��ڬF�v" "�F�v���ǦW�ۿ�Ū" "�һͲz�׻P���" "���D�P���|" "���q�Ч�"
					 	"���N�լd�P���R" "�q�Ƭ�s��k�]�G�^" "�q�Ƭ�s��k�]�G�^�G�F����Ƥ��R" "��´�z�׻P�欰" "�D�F����´"
					 	"���|���~" "���|���~�P���q�Ч�" "�q�l�ƬF��" "�F�����R" "�ڬw�ΦX�ɽ�" 
						"�H�O�귽�޲z" "���F��" "����F�v��ץv" "�j���ظg�ٰ�" "�x�W�F�v�o�i"
					 	"���k���n" "���|��" "�����P�F�v" "�Ȭw�q�v�P�F�v" "��|�k�פ��R"
					 	"���t�P�����t�F��" "�ڬw�g�ٻP�f����X" "���@�޲z" "�޲z��" "����o�i�F��" 
						"�F����w�L�{" "�߲z��" "�зN���" "�����F" "�F�ҧQ�q����P�F��"
						"�ߪk�{��" "�F�v�g�پ�" "����F�v" "��F����" "��F�޲z�M�D" 
						"�U��H�ƨ��" "�H�s���Y" "ĳ�|�F�v" "�H�O�귽�o�i" "�a��]�F�M�D" 
						"�����ѻP" "�x�W���@��F�M�D" "���D�F�v�P�j���C��" "��F�ǦW�ۿ�Ū" "�H�O�W��"
					 	"�������|�ɽ�" "���t�F���P�F�v" "�x�W���@�F���M�D" "���y�F�v�g�٤Τ��@�F��" "���|��Ǭ�s��k��" 
						"��´�g�پ�" "��Ƭ�s��k" "�`��g�پ�" "��N�U�إD�q" "�F����P"
						"��F���s�M�D" "�⩤���Y�M�D";
%end;
%else %if &depart = finan %then %do;
%let req_list = "�έp��" "����g�پ�" "�`��g�پ�" "�f���Ȧ��" "�ұo�|�z�׻P���" 
				"���|�k" "�L�n��" "�g�پ�" "�|�p��" "�Өƪk"
                "�]�F�ǡ]�@�^" "���ŷ|�p��" "���O�|�z�׻P���" "�]���|�z�׻P���";
%let elect_list = "���k���n" "�g�ټƾ�" "���Ųz�׻P�޲z" "��ڪ��Ĳz�׻P�F��" "�����g�ٻP�F��" 
						"�p�q�g�پ�" "�]�F�ǡ]�G�^"  "���Ĩ�׻P���" "�����|�p" "�欰�]�F��"
                       	"���|�w�����(�@)" "����:�z�׻P�ʲz" "�w��z�׻P���" "�]�F�ǦW�ۿ�Ū" "��گ��|"
                        "�ɧ��z��" "������|���" "���@���" "�]�Ⱥ޲z" "�����įq���R" 
						"�]�ȳ�����R" "�a��]�F" "���|�z�׻P���" "�]�Fĳ�D�P�n������" "�����]�F"
                        "�]�F�j����" "��ڪ��ıM�D" "������|���(�@)" "���|�w����׻P�F��(�@)" "������|���(�G)"
                       "�]�F���Ĺ�Ȥ��R" "���|�w����׻P�F��(�G)" "�]�F���Ĺ��" "���@�ưȱM�D" "�]�F�j����";
%end;
%else %if &depart = realest %then %do;
%let req_list = "�ؿv�Ƿ���" "�έp��" "���ҳW��" "�g�a�k" "�g�a�g�پ�" 
				"�a�z��T�t��" "���ҳW��" "���ʲ�����" "�g�a�n�O" "�����ΰϰ�p�e�z��" 
				"�g�a�F��" "���ʲ��������" "���ʲ��P���m���ұM�D" "���k���n" "�g�پ�"
                "���q��" "�����p�e" "�a�y���q" "�����g�a�ϥΤΥ�q�B��p�e" "�a�y���q";
%let elect_list = "�L�n��" "�q�����Uø��" "���ʲ��޲z" "�q�����Uø��" "�s�Ͼ�" 
						"�פ�g�@��k" "�۵M�a�`�P�ìP��T" "���ʲ���P" "���ʲ��g�پ�" "���@�]�I�p�e" 
						"��Ʈw�޲z�t��" "���ʲ��]�Ⱥ޲z" "���Ϩϥκި�" "���ʲ���P" "�����]�p�]�@�^"
                        "�����g�پ�" "���Ϩϥκި�" "��v���D" "�W�����R" "���ʲ��P���m���ҹ�Ⱦާ@" 
						"���ʲ����" "������s" "�p�e�P���|" "�����ΰϰ�F��" "���ʲ��������R"
                       	"���ʲ��g���k�W" "���ҥͺA��" "�p�e�k�W" "�g�a�|�k�W" "���ʲ����" 
						"�a�Ͼ�" "���q���t�k�]�@�^" "�g�a�����P�x��" "�ͺA�x�W" "�g�a�n�O���" 
						"���ʲ��}�o" "���ʲ�����" "�ìP�w����q" "�H�U�k" "�a���P�a�|�z��"
                        "�a�`�޲z" "���ʲ��|������" "���Ҫk" "���q���t�k�]�G�^" "���m���Ϧw���P��a���" 
						"���ʲ��g��޲z" "���һ���" "�Ʀ�v���B�z" "�~�a��������" "���ϵo�i�P��ȡ]�@�^"
                        "�g�a�k��Ȭ�s�]�@�^" "�W����ȡ]�@�^" "���q���" "�a�z��T�t�ι��" "�W����ȡ]�G�^" 
						"�j�a���q��" "�����v���q" "���ʲ��]�Ȥ��R" "�ؿv����" "��F�k"
						"�����o�i" "���ʲ��g�٤��R" "�j�ƾڤ������P����" "�g�a�Q�λP���Ҫk";
%end;
%course_ori(&depart, &req_list, &elect_list, 3);
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
%put &stuid_list;
%do i = 1 %to &nstu;
      %let mvar = %scan(&stuid_list, &i, %str( ));
      %course_cal(&mvar, &depart, 3);
 %end;
%mend;
