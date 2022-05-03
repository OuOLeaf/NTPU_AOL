libname libTable 'D:\Dropbox\Andy\AOL課程評量\計算面向分數\行政、財政、不動\sas7bdat';
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

%macro draw_radar_to(id);

goptions reset=all cback=white border htitle=20 pt htext = 10 pt; 
title1 f='MingLiU'"&id" height = 10 pt;

axis1 order=(0 to 5 by 1) label=(h=12pt) value=(height=2pct tick=1);
axis2 order=(0 to 5 by 1) label=(h=12pt) ;
axis3 order=(0 to 5 by 1) label=(h=12pt) ;

proc gradar data=libTable.score_&id;
chart _NAME_ / 
sumvar = year_ori1  /*give the digits*/
overlay = year /* detach by year*/
starinradius=2
cstars=(CXFFA500 CX4682B4 CXF08080 CX2E8B57)
caxis = black /*framecolor*/
cspokes = black /* spoke 軸的顏色 */
staraxis=(axis1 axis2 axis3)
/*starfill=(solid solid solid solid)*/
/*cstarcircles=ltgray*/
/*starcircles=( .2  .6  1)*/
/*starlegend=none*/
/*starlegendlab="修課的年度"*/
 font ='MingLiU'
 lstar = 1 1 1 1
 wstar =(3 3 3 3);
/* spider; */
format _NAME_ $orif. year yearf.;
label
year = '修課的年度';
run;
quit;
%mend;

%draw_radar_to('410472123')

