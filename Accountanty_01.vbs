Option Explicit

'USEUNIT Library_Common
'USEUNIT OLAP_Library
'USEUNIT Constants
'USEUNIT Library_Colour

'Test Case ID 166017

Sub Accountanty_01_Test() 

    Dim exists, SPath, userName, Password, CurrDate, StartDate, EndDate, AccNumber, TreeLevel, CBranch, Language 
    Dim EPath1, EPath2, Thousand, RequesQuery, i, j, DB1, param, windExists, Cont, resultWorksheet(2)
 
    SPath = Project.Path & "Stores\Actual_OLAP"
    EPath1 = Project.Path & "Stores\Actual_OLAP\16600_01.xls"
    EPath2 = Project.Path & "Stores\Expected_OLAP\16600_01_28.02.2014.xls"
    For i = 1 To 2
      resultWorksheet(i) = Project.Path & "Stores\Result_Olap\Result_16600_01_sheet_" & i  & ".xls"
    Next
 '   resultWorksheet = Project.Path & "Stores\Result_Olap\Result_16600_01.xls"
 
   'Î³ï³ñáõÙ ¿ ëïáõ·áõÙ,»Ã» ÝÙ³Ý ³ÝáõÝáí ý³ÛÉ Ï³ ïñí³Í ÃÕÃ³å³Ý³ÏáõÙ ,çÝçáõÙ ¿   
    exists = aqFile.Exists(EPath1)
    If exists Then
        aqFileSystem.DeleteFile(EPath1)
    End If

    'Test StartUp start
    Call Initialize_Excel()
    'Test StartUp end
    
    Call Sys.Process("EXCEL").Window("XLMAIN", "Excel", 1).Window("FullpageUIHost").Window("NetUIHWND").Click(505, 236)
    
    Call AddOLAPAddIn ()
   
    userName = "ADMIN" 
    Password= ""
    DB1 = "bankTesting_QA"
     
    'Î³ï³ñ»É ³ßË³ï³ÝùÇ ëÏÇ½µ
    Call Start_Work(userName ,Password, DB1)
    i = 0
    j = 2
      
    '´³ó»É Ñ³ßí»ïíáõÃÛ³Ü Ó¨³ÝÙáõß ïíÛ³ÉÝ»ñÇ å³ÑáóÇó
    Call Open_Accountanty(i,j)
  
    windExists = True
    CurrDate = "28022014"
    EndDate = NULL
    StartDate = NUll
    AccNumber = "1"
    TreeLevel = "5"
    CBranch = "99997"
    Language  = "Հայերեն"
    Thousand = cbChecked
    RequesQuery = "60"
    param = "16600_01.xls"
    Cont = False
      
    'Ð³ßí³ñÏ»É Ñ³ßí»ïíáõÃÛáõÝÁ 
    Call Calculate_Report_Range(windExists,CurrDate,StartDate,EndDate,AccNumber ,TreeLevel,CBranch,Language ,Thousand,RequesQuery,param)
       
    'ä³Ñ»É ý³ÛÉÁ ACTUAL_OLAP ÃÕÃ³å³Ý³ÏáõÙ
    Call Save_To_Folder(SPath, param, Cont)

    'Ð³Ù»Ù³ï»É »ñÏáõ EXCEL ý³ÛÉ»ñ, ã»ñ¨³óáÕ sheet Ï³ 
 '   Call CompareExcelTwoWorksheets(EPath1, EPath2, 1, resultWorksheet)
   
    Call  CompareTwoExcelFiles(EPath1, EPath2, resultWorksheet)
   
    'Î³ï³ñ»É ²ßË³ï³ÝùÇ ³í³ñï
    Sys.Process("EXCEL").Window("XLMAIN", "" & param & "  [Compatibility Mode] - Excel", 1).Window("EXCEL2", "", 2).ToolBar("Ribbon").Window("MsoWorkPane", "Ribbon", 1).Window("NUIPane", "", 1).Window("NetUIHWND", "", 1).Keys("~X")
    Sys.Process("EXCEL").Window("XLMAIN", "" & param & "  [Compatibility Mode] - Excel", 1).Window("EXCEL2", "", 2).ToolBar("Ribbon").Window("MsoWorkPane", "Ribbon", 1).Window("NUIPane", "", 1).Window("NetUIHWND", "", 1).Keys("Y7")
   
    'ö³Ï»É EXCEL- Á
    Call CloseAllExcelFiles() 
  
End Sub
