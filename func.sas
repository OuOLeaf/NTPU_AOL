libname libOri 'D:\Dropbox\Andy\AOL�ҵ{���q\�p�⭱�V����\��F�B�]�F�B����\sas7bdat';

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

data libori.&depname._cour;
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
proc print data = libori.&depname._cour;
run;
%mend;
