
%include 'func.sas';



/*����b macro �� ifelse ��� countori*/
%spawn_radar_score(policy);
%spawn_radar_score(finan);
%spawn_radar_score(realest);

DM log "OUT;CLEAR;LOG;CLEAR;";
dm 'odsresults; clear';
/*%put &id_list;*/
/**/
/*proc print data = libTable.score_data;run;*/
/**/
/*%put &n_stu;*/
/*data courseori;*/
/*set libTable.policy_cour;*/
/*run;*/
/*data person;*/
/*set libTable.person_410372141;*/
/*run;*/
/*proc sort data = courseori;*/
/*by course;*/
/*run;*/
/*proc sort data = person;*/
/*by coursename;*/
/*run;*/
/*data personCour;*/
/*merge person courseori(rename = (course = coursename));*/
/*by coursename;*/
/*k = 1;*/
/*if courseName in (&req_list) then kind = 'm';*/
/*else if courseName in (&elect_list) then kind = 'n';*/
/*if kind ^= '' and score ^='';*/
/*run;*/
/**/
/*proc sort data = personCour;*/
/*by kind year;*/
/*run;*/
/**/
/*data personOri;*/
/*merge personCour smv ;*/
/*by k;*/
/*drop k;*/
/*/* �p����� */*/
/*array score_ori ori_1 ori_2 ori_3;*/
/*array haveori r1 r2 r3;*/
/*array mori m1 m2 m3;*/
/*array nori n1 n2 n3;*/
/*array mscore ms1 ms2 ms3;*/
/*array nscore ns1 ns2 ns3;*/
/*do i = 1 to 3;*/
/**/
/*/*n �O���� m �O���*/*/
/*/* �H�U���{������ ���O��X�Ӯ����*/*/
/*mscore{i} = (score - 60)/(90 - 60)/mori{i};*/
/*nscore{i} = ((score - 60)/(90 - 60)+3)/nori{i};*/
/**/
/*/*��0��K����p��*/*/
/*if haveori{i} = 0 then do;*/
/*mscore{i} = 0;*/
/*nscore{i} = 0;*/
/*end;*/
/**/
/*if kind = 'n' then mscore{i} = 0;*/
/*if kind = 'm' then nscore{i} = 0;*/
/**/
/*/*�N����פ��O�����Ʃ�b�P�@��*/*/
/*score_ori{i} = mscore{i} + nscore{i};*/
/*end;*/
/**/
/*keep year ori_1 ori_2 ori_3;*/
/*run;*/
/*proc print;run;*/
/*/*�ɤW�i��Y�X�~�S����*/*/
/*data personOri;*/
/*set personori end = eof;*/
/*output;*/
/*array score_ori ori_1-ori_3;*/
/*if eof then do;	*/
/*do j = 104, 105, 106, 107;*/
/*year = j;*/
/*do i= 1 to 3;*/
/*score_ori{i} = 0;*/
/*end;*/
/*output;*/
/*end;*/
/*end;*/
/*drop i j;*/
/*run;*/
/**/
/*proc print;run;*/
/*/*proc sql;*/*/
/*/*insert into personOri*/*/
/*/*set year = 107, ori_1 = 0, ori_2 = 0, ori_3 = 0; */*/
/*/*quit;*/*/
/*proc print; run;*/
/**/
/*proc sort data = personOri;*/
/*by year;*/
/*run;*/
/*proc means data = personOri sum;*/
/*by year;*/
/*var ori_1 ori_2 ori_3;*/
/*ods output summary = ori_score ;*/
/*run;*/
/*proc print;run;*/
/**/
/*data ori_score;*/
/*set ori_score(drop = vname:);*/
/*retain ori_1-ori_3;*/
/*array arrOri ori_1-ori_3;*/
/*array arrOriSum ori_1_Sum--ori_3_Sum;*/
/*by year;*/
/*do i = 1 to 3;*/
/*arrOri{i} + arrOriSum{i};*/
/*end;*/
/**/
/*do i = 1 to 3;*/
/*if arrOri{i} > 5 then arrOri{i} = 5;*/
/*end;*/
/*keep year ori_1 ori_2 ori_3;*/
/*run;*/
/**/
/*proc transpose data=ori_score out=radar_score prefix=year_ori;*/
/*by year;*/
/*var ori_1-ori_3; */
/*run;*/
/**/
/*proc print;run;*/
