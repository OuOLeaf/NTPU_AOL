# 104年臺北大學行政、財政和不動系修課面向計算

目的要將每位學生畫一張雷達圖，每張圖有四條線，分別是每一年的面向分數，納入計算的課程不包括英文、體育、國文和通識

## 課程必選修

- 104 三系課程參考 D:\Dropbox\AOL\校務研究\104學年度入學的課程資料\104課程整理\院課程分類\104公共事務學院.sas

## 編寫的函式寫在 func.sas 

- course_ori(data, req_list, elect_list)
  
  data：生成的 sas7bdat 名稱 為 data_cour
  
  req_list：必修名稱
  
  elect_list：選修名稱