# 104年臺北大學行政、財政和不動系修課面向計算

目的要將每位學生畫一張雷達圖，每張圖有四條線，分別是每一年的面向分數，納入計算的課程不包括英文、體育、國文和通識

## 資料來源

- 104 三系課程必選修參考 D:\Dropbox\AOL\校務研究\104學年度入學的課程資料\104課程整理\院課程分類\104公共事務學院.sas

- 臺北大學學生修課分數檔 .\data\104學生修課資料.xlsx

## 流程

- Step1: 產出課程面向檔

  用 spawn_ori.sas 可產出三個科系的面向資料

- Step2: 產出每人修課資料 
  
  北大學號代表學系
  
  76-不動
  72-公行
  75-財政
  
  用 spawn_person.sas 可產出三個科系所有學生的修課資料
  
  每人的修課資訊放在 sas7bdat 中 可用來繪製四年雷達圖
  
  
- Step3: 計算每人在四年的修課面向分數
	
  <img src="formula.png"/> 
  
- Step4: 繪製雷達圖

- Step5: 產出報表

## 編寫的函式寫在 func.sas 

- course_ori(data, req_list, elect_list, ori_c)
  
  data：生成的 sas7bdat 名稱 為 data_cour
  
  req_list：必修名稱
  
  elect_list：選修名稱
  
  ori_c：面相個數
- 