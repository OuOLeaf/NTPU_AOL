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
%macro course_cal(id,  department, countOri);
%if &department = 'policy' %then %do;
%let req_list = "社會科學研究方法" "比較政府" "公共政策" "中華民國憲法與政府" "量化研究方法（一）" 
				"量化研究方法(一)：" "量化研究方法（一）：基礎統計分析" "中國政治思想史" "財務行政" 
		"人事行政" "西洋政治思想史" "行政倫理" "地方政府"  "非營利組織管理" 
				"政治學" "行政學" "行政法";
%let elect_list = "公共事務治理導論" "法學緒論" "公共管理實習" "經濟學" "社會科學資料處理與程式設計導論" 
						"政治發展理論" "政府績效管理" "公共服務學習與社會關懷" "國際政治經濟學" "選舉與投票行為" 
						"政治哲學導論" "財政學" "官僚制度與行為" "政策執行" "政策規劃" 
						"人力資源專題" "策略管理" "媒體、企業與政治" "公共政策名著導讀" "政府與企業"
					 	"民主政治與大眾媒體" "社會創新與社會企業" "政策評估" "政治社會學" "媒體與民意" 
						"兩岸關係與國際政治" "政治哲學名著選讀" "考銓理論與實務" "民主與社會" "公益創投"
					 	"民意調查與分析" "量化研究方法（二）" "量化研究方法（二）：政策資料分析" "組織理論與行為" "非政府組織"
					 	"社會企業" "社會企業與公益創投" "電子化政府" "政策分析" "歐洲統合導論" 
						"人力資源管理" "市政學" "中國政治制度史" "大中華經濟圈" "台灣政治發展"
					 	"民法概要" "社會學" "文藝與政治" "亞洲電影與政治" "國會法案分析"
					 	"分配與重分配政策" "歐洲經濟與貨幣整合" "公共管理" "管理學" "永續發展政策" 
						"政策制定過程" "心理學" "創意思考" "比較行政" "政黨利益團體與政策"
						"立法程序" "政治經濟學" "比較政治" "行政救濟" "行政管理專題" 
						"各國人事制度" "人群關係" "議會政治" "人力資源發展" "地方財政專題" 
						"公民參與" "台灣公共行政專題" "民主政治與大眾媒體" "行政學名著選讀" "人力規劃"
					 	"公民社會導論" "分配政策與政治" "台灣公共政策專題" "全球政治經濟及公共政策" "社會科學研究方法論" 
						"組織經濟學" "質化研究方法" "總體經濟學" "當代各種主義" "政策行銷"
						"行政革新專題" "兩岸關係專題";
%end;
%else %if &department = finan %then %do;
%let req_list = "統計學" "個體經濟學" "總體經濟學" "貨幣銀行學" "所得稅理論與制度" 
				"租稅法" "微積分" "經濟學" "會計學" "商事法"
                "財政學（一）" "中級會計學" "消費稅理論與制度" "財產稅理論與制度";
%let elect_list = "民法概要" "經濟數學" "公債理論與管理" "國際金融理論與政策" "都市經濟與政策" 
						"計量經濟學" "財政學（二）"  "金融制度與實務" "成本會計" "行為財政學"
                       	"社會安全制度(一)" "投資學:理論與監理" "預算理論與制度" "財政學名著選讀" "國際租稅"
                        "賽局理論" "比較租稅制度" "公共選擇" "財務管理" "成本效益分析" 
						"財務報表分析" "地方財政" "關稅理論與制度" "財政議題與軟體應用" "醫療財政"
                        "財政大講堂" "國際金融專題" "比較租稅制度(一)" "社會安全制度與政策(一)" "比較租稅制度(二)"
                       "財政金融實務分析" "社會安全制度與政策(二)" "財政金融實習" "公共事務專題" "財政大講堂";
%end;
%else %if &department = realest %then %do;
%let req_list = "建築學概論" "統計學" "環境規劃" "土地法" "土地經濟學" 
				"地理資訊系統" "環境規劃" "不動產估價" "土地登記" "都市及區域計畫理論" 
				"土地政策" "不動產估價實務" "不動產與城鄉環境專題" "民法概要" "經濟學"
                "測量學" "都市計畫" "地籍測量" "都市土地使用及交通運輸計畫" "地籍測量";
%let elect_list = "微積分" "電腦輔助繪圖" "不動產管理" "電腦輔助繪圖" "製圖學" 
						"論文寫作方法" "自然災害與衛星資訊" "不動產行銷" "不動產經濟學" "公共設施計畫" 
						"資料庫管理系統" "不動產財務管理" "分區使用管制" "不動產行銷" "都市設計（一）"
                        "都市經濟學" "分區使用管制" "住宅問題" "規劃分析" "不動產與城鄉環境實務操作" 
						"不動產投資" "都市更新" "計畫與社會" "都市及區域政策" "不動產市場分析"
                       	"不動產經紀法規" "環境生態學" "計畫法規" "土地稅法規" "不動產投資" 
						"地圖學" "測量平差法（一）" "土地重劃與徵收" "生態台灣" "土地登記實務" 
						"不動產開發" "不動產金融" "衛星定位測量" "信託法" "地租與地稅理論"
                        "災害管理" "不動產稅務應用" "環境法" "測量平差法（二）" "城鄉社區安全與減災實務" 
						"不動產經營管理" "環境遙測" "數位影像處理" "居家風水概論" "社區發展與實務（一）"
                        "土地法實務研究（一）" "規劃實務（一）" "測量實務" "地理資訊系統實務" "規劃實務（二）" 
						"大地測量學" "航空攝影測量" "不動產財務分析" "建築企劃" "行政法"
						"都市發展" "不動產經濟分析" "大數據之概說與應用" "土地利用與環境法";
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
%let req_list = "社會科學研究方法" "比較政府" "公共政策" "中華民國憲法與政府" "量化研究方法（一）" 
				"量化研究方法(一)：" "量化研究方法（一）：基礎統計分析" "中國政治思想史" "財務行政" 
		"人事行政" "西洋政治思想史" "行政倫理" "地方政府"  "非營利組織管理" 
				"政治學" "行政學" "行政法";
%let elect_list = "公共事務治理導論" "法學緒論" "公共管理實習" "經濟學" "社會科學資料處理與程式設計導論" 
						"政治發展理論" "政府績效管理" "公共服務學習與社會關懷" "國際政治經濟學" "選舉與投票行為" 
						"政治哲學導論" "財政學" "官僚制度與行為" "政策執行" "政策規劃" 
						"人力資源專題" "策略管理" "媒體、企業與政治" "公共政策名著導讀" "政府與企業"
					 	"民主政治與大眾媒體" "社會創新與社會企業" "政策評估" "政治社會學" "媒體與民意" 
						"兩岸關係與國際政治" "政治哲學名著選讀" "考銓理論與實務" "民主與社會" "公益創投"
					 	"民意調查與分析" "量化研究方法（二）" "量化研究方法（二）：政策資料分析" "組織理論與行為" "非政府組織"
					 	"社會企業" "社會企業與公益創投" "電子化政府" "政策分析" "歐洲統合導論" 
						"人力資源管理" "市政學" "中國政治制度史" "大中華經濟圈" "台灣政治發展"
					 	"民法概要" "社會學" "文藝與政治" "亞洲電影與政治" "國會法案分析"
					 	"分配與重分配政策" "歐洲經濟與貨幣整合" "公共管理" "管理學" "永續發展政策" 
						"政策制定過程" "心理學" "創意思考" "比較行政" "政黨利益團體與政策"
						"立法程序" "政治經濟學" "比較政治" "行政救濟" "行政管理專題" 
						"各國人事制度" "人群關係" "議會政治" "人力資源發展" "地方財政專題" 
						"公民參與" "台灣公共行政專題" "民主政治與大眾媒體" "行政學名著選讀" "人力規劃"
					 	"公民社會導論" "分配政策與政治" "台灣公共政策專題" "全球政治經濟及公共政策" "社會科學研究方法論" 
						"組織經濟學" "質化研究方法" "總體經濟學" "當代各種主義" "政策行銷"
						"行政革新專題" "兩岸關係專題";
%end;
%else %if &depart = finan %then %do;
%let req_list = "統計學" "個體經濟學" "總體經濟學" "貨幣銀行學" "所得稅理論與制度" 
				"租稅法" "微積分" "經濟學" "會計學" "商事法"
                "財政學（一）" "中級會計學" "消費稅理論與制度" "財產稅理論與制度";
%let elect_list = "民法概要" "經濟數學" "公債理論與管理" "國際金融理論與政策" "都市經濟與政策" 
						"計量經濟學" "財政學（二）"  "金融制度與實務" "成本會計" "行為財政學"
                       	"社會安全制度(一)" "投資學:理論與監理" "預算理論與制度" "財政學名著選讀" "國際租稅"
                        "賽局理論" "比較租稅制度" "公共選擇" "財務管理" "成本效益分析" 
						"財務報表分析" "地方財政" "關稅理論與制度" "財政議題與軟體應用" "醫療財政"
                        "財政大講堂" "國際金融專題" "比較租稅制度(一)" "社會安全制度與政策(一)" "比較租稅制度(二)"
                       "財政金融實務分析" "社會安全制度與政策(二)" "財政金融實習" "公共事務專題" "財政大講堂";
%end;
%else %if &depart = realest %then %do;
%let req_list = "建築學概論" "統計學" "環境規劃" "土地法" "土地經濟學" 
				"地理資訊系統" "環境規劃" "不動產估價" "土地登記" "都市及區域計畫理論" 
				"土地政策" "不動產估價實務" "不動產與城鄉環境專題" "民法概要" "經濟學"
                "測量學" "都市計畫" "地籍測量" "都市土地使用及交通運輸計畫" "地籍測量";
%let elect_list = "微積分" "電腦輔助繪圖" "不動產管理" "電腦輔助繪圖" "製圖學" 
						"論文寫作方法" "自然災害與衛星資訊" "不動產行銷" "不動產經濟學" "公共設施計畫" 
						"資料庫管理系統" "不動產財務管理" "分區使用管制" "不動產行銷" "都市設計（一）"
                        "都市經濟學" "分區使用管制" "住宅問題" "規劃分析" "不動產與城鄉環境實務操作" 
						"不動產投資" "都市更新" "計畫與社會" "都市及區域政策" "不動產市場分析"
                       	"不動產經紀法規" "環境生態學" "計畫法規" "土地稅法規" "不動產投資" 
						"地圖學" "測量平差法（一）" "土地重劃與徵收" "生態台灣" "土地登記實務" 
						"不動產開發" "不動產金融" "衛星定位測量" "信託法" "地租與地稅理論"
                        "災害管理" "不動產稅務應用" "環境法" "測量平差法（二）" "城鄉社區安全與減災實務" 
						"不動產經營管理" "環境遙測" "數位影像處理" "居家風水概論" "社區發展與實務（一）"
                        "土地法實務研究（一）" "規劃實務（一）" "測量實務" "地理資訊系統實務" "規劃實務（二）" 
						"大地測量學" "航空攝影測量" "不動產財務分析" "建築企劃" "行政法"
						"都市發展" "不動產經濟分析" "大數據之概說與應用" "土地利用與環境法";
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
