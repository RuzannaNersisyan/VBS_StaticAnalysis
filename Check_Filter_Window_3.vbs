'USEUNIT Mem_Order_Library
'USEUNIT Library_Common
'USEUNIT Constants
'USEUNIT DAHK_Library_Filter
'USEUNIT Payment_Except_Library
'USEUNIT SWIFT_International_Payorder_Library
'USEUNIT Library_Colour
Option Explicit
'Test Case ID 183249

Dim filter(2), strQuote, sDATE, eDATE, path(3), pathExp(3), savePath, i, j, k, TDBGridFilter

Sub Check_Filter_Window_3_Test()
    Call Test_Initialize_Filter_3 ()

    'Մուտք ծրագիր ARMSOFT Օգտագործողով
    Call Initialize_AsBank("bank", sDATE, eDATE)
    Call Login ("ARMSOFT")
    Call ChangeWorkspace(c_ChiefAcc)
    Call OpenAccauntsFolder ("|¶ÉË³íáñ Ñ³ßí³å³ÑÇ ²Þî|Ð³ßÇíÝ»ñ","1","","","","","","","","",0,"","","","","",0,0,0,"","","","","","ACCS","0")
    BuiltIn.Delay(3000)
    
'----------------Առաջին ֆիլտրում------------------------------------------------------
    Log.Message "Առաջին ֆիլտրում",,,MessageColor
    Call Pttel_Filtering (filter(0), "frmPttel")
    BuiltIn.Delay(4000)
    'Աղյուսակի դասավորվածություն ըստ Հաշիվներ սյան
    wMDIClient.VBObject("frmPttel").Keys("[Hold]" & "^" & "2")
    'Դիտել թղթապանակը գործողության կատարում
    wMDIClient.VBObject("frmPttel").VBObject("TDBGView").Keys("^[F5]")
    BuiltIn.Delay(4000)
    'Թղթապանակի դիտելու ձևի համեմատում օրինակի հետ
    Call SaveDoc(savePath, "Check_Filter_AccActual_1")
    Call Compare_Files(path(0), pathExp(0), "")
    Call Close_Window(wMDIClient, "FrmSpr" )
     
    
'----------------Երկրորդ ֆիլտրում-------------------------------------------------------
    Log.Message "Երկրորդ ֆիլտրում",,,MessageColor
    If Not wMDIClient.VBObject("frmPttel").VBObject("CmdConditionEdit").Visible Then 
       wMDIClient.VBObject("frmPttel").Keys ("^f")
    End If
    BuiltIn.Delay(1000)   
    wMDIClient.VBObject("frmPttel").VBObject("CmdConditionEdit").Click
    If asbank.waitVBObject("frmPttelFilter",1000).exists Then
       Do 
         asbank.VBObject("frmPttelFilter").VBObject("FilterControl").VBObject("ToolbarFilterActions").Window("msvb_lib_toolbar", "", 1).ClickItem(2)     
       Loop Until asbank.VBObject("frmPttelFilter").VBObject("FilterControl").VBObject("TDBGridFilter").ApproxCount = 0
       For i = 0 to filter(1).condCount - 1
         asbank.VBObject("frmPttelFilter").VBObject("FilterControl").VBObject("ToolbarFilterActions").Window("msvb_lib_toolbar", "", 1).ClickItem(1)
       Next 
       Set TDBGridFilter = asbank.VBObject("frmPttelFilter").VBObject("FilterControl").VBObject("TDBGridFilter")
       For j = 0 to filter(1).condCount - 1  
          TDBGridFilter.Keys("[Home]")
          'Եվ/ կամ սյան լրացում
          If j <> 0 Then
             With TDBGridFilter
                  .row = j
                  .col = 1
                  .Keys ("~[Down]")
                  k = 0
                  Do Until k = filter(1).andOr(j)
                     .Keys ("[Down]")
                     k = k+1
                  Loop   
                  .Keys ("[Enter]")
             End With  
             TDBGridFilter.Keys ("[Right]")
          End If
         'Սյան անվանում սյան լրացում
          With TDBGridFilter
                  .row = j
                  .col = 2
                  .Keys ("~[Down]")
                  k = 0
                  Do Until k = filter(1).colName(j)
                     .Keys ("[Down]")
                     k = k+1
                  Loop   
                  .Keys ("[Enter]")
          End With
          'Պայման սյան լրացում
          With TDBGridFilter
                  .row = j
                  .col = 3
                  .Keys ("~[Down]")
                  k = 0
                  Do Until k = filter(1).cond(j) 
                     .Keys ("[Down]")
                     k = k+1
                  Loop   
                  .Keys ("[Enter]")
          End With
          'Արժեք սյան լրացում 
          With TDBGridFilter
                  .row = j
                  .col = 4
                  .Keys (filter(1).val(j) & "[Right]")
          End With
       Next
           
       With TDBGridFilter
           .MoveLast
         If Trim(.Columns.Item(4).Value) = "" Then
            asbank.VBObject("frmPttelFilter").VBObject("FilterControl").VBObject("ToolbarFilterActions").Window("msvb_lib_toolbar", "", 1).ClickItem(2)
         End If  
         'Առաջին երկու տողերի ընդգծում և համակարգում
         .row = 1
         .col = 0
         .Keys ("![PageUp]")
       End With
       asbank.VBObject("frmPttelFilter").VBObject("FilterControl").VBObject("ToolbarFilterActions").Window("msvb_lib_toolbar", "", 1).ClickItem(3)
       Call ClickCmdButton (7, "Î³ï³ñ»É")
    Else 
        Log.Error "Filter window doesn't exists",,,ErrorColor
    End If
    'Դիտել թղթապանակը գործողության կատարում
    wMDIClient.VBObject("frmPttel").VBObject("TDBGView").Keys("^[F5]")
    BuiltIn.Delay(4000)
    'Թղթապանակի դիտելու ձևի համեմատում օրինակի հետ
    Call SaveDoc(savePath, "Check_Filter_AccActual_2")
    Call Compare_Files(path(1), pathExp(1), "")
    Call Close_Window(wMDIClient, "FrmSpr" )
    
    
'----------------Համախմբման չեղարկում------------------------------------------------------------
    Log.Message "Համախմբման չեղարկում",,,MessageColor
    wMainForm.MainMenu.Click(c_Opers & "|" & c_Folder & "|" & c_Filter)
    If asbank.waitVBObject("frmPttelFilter",1000).exists Then
        With TDBGridFilter
            .row = 1
            .col = 0
            .Keys ("![PageUp]")
        End With
        asbank.VBObject("frmPttelFilter").VBObject("FilterControl").VBObject("ToolbarFilterActions").Window("msvb_lib_toolbar", "", 1).ClickItem(4)
        Call ClickCmdButton (7, "ÎÇñ³é»É")
        Call ClickCmdButton (7, "¸³¹³ñ»óÝ»É")   
    Else
        Log.Error "Filter window doesn't exists",,,ErrorColor
    End If 
    'Դիտել թղթապանակը գործողության կատարում
    wMainForm.MainMenu.Click(c_Opers & "|" & c_Folder & "|" & c_ViewFold)
    BuiltIn.Delay(4000)
    'Թղթապանակի դիտելու ձևի համեմատում օրինակի հետ
    Call SaveDoc(savePath, "Check_Filter_AccActual_3")
    Call Compare_Files(path(2), pathExp(2), "")
    Call Close_Window(wMDIClient, "FrmSpr" )
    
    
'----------------Երրորդ ֆիլտրում-----------------------------------------------------------------
    Log.Message "Երրորդ ֆիլտրում",,,MessageColor
    Call Pttel_Filtering (filter(2), "frmPttel")
    'Դիտել թղթապանակը գործողության կատարում
    wMDIClient.VBObject("frmPttel").VBObject("TDBGView").Keys("^[F5]")
    'Թղթապանակի դիտելու ձևի համեմատում օրինակի հետ
    BuiltIn.Delay(4000)
    Call SaveDoc(savePath, "Check_Filter_AccActual_4")
    Call Compare_Files(path(3), pathExp(3), "")
    Call Close_Window(wMDIClient, "FrmSpr" )
    
    
    Call Close_Window(wMDIClient, "frmPttel" )
    Call Close_AsBank()
End Sub

Sub Test_Initialize_Filter_3 ()  
    
    sDate = "20050101"
    eDate = "20260101"
    strQuote = Chr(34)
    Set filter(0) = New_Filter_Pttel(5)
    With filter(0)      
         .colName (0) = 1 'Հաշիվ         
         .cond (0) = 6 '~
         .val (0) = "7779###1011"
         .andOr (1) = 1 'կամ
         .colName (1) = 5 'Տիպ
         .cond (1) = 2 '<
         .val (1) = "03"
         .andOr (2) =  0 'և       
         .colName (2) = 1 'Հաշիվ
         .cond (2) = 10 'Ցուցակից չէ
         .val (2) =   "77798311011 " & strQuote & "," & strQuote & " 77798151011"
         .andOr (3) =  0 'և       
         .colName (3) = 6 'Բացման ամս
         .cond (3) = 8 'Միջև
         .val (3) =   "15/06/15"
         .valEnd(3) = "10/09/20"
         .andOr (4) =  0 'և       
         .colName (4) = 3 'Անվանում
         .cond (4) = 7 '՛~
         .val (4) = "²Û?"  
    End With
    
    
    Set filter(1) = New_Filter_Pttel(5)
    With filter(1)      
         .colName (0) = 17 'Բաժին 
         .cond (0) = 1 '<>
         .val (0) = "1"
         .andOr (1) = 1 'կամ
         .colName (1) = 7 'Փակման ամսաթիվ
         .cond (1) = 3 '<=
         .val (1) = "01/09/07" 
         .andOr (2) = 0 'և   
         .colName (2) = 5 'Տիպ
         .cond (2) = 5 '>=
         .val (2) =  20 
         .andOr (3) = 0 'և
         .colName (3) = 4  'Արժ
         .cond (3) = 4 ' >
         .val (3) = "009"  
         .andOr (4) = 0  'և
         .colName (4) = 14 'Հաճախորդ 
         .cond (4) = 9 'Ցուցակից է
         .val (4) = "00000105" & strQuote & "," & strQuote & "00000115"
         .condCount = 5
    End With
    
    Set filter(2) = New_Filter_Pttel(6)
    With filter(2)      
         .colName (0) = 5 'Տիպ 
         .cond (0) = 11 '=[Սյուն]
         .val (0) = "ACSTYPE"
         .andOr (1) = 0 'և
         .colName (1) = 17 'Բաժին 
         .cond (1) = 12 '<>[Սյուն]
         .val (1) = "FROZEN" 
         .andOr (2) = 0 'և
         .colName (2) = 10 'Սառեցված
         .cond (2) = 14 '<=[Սյուն]
         .val (2) = "ACSDEPART" 
         .andOr (3) = 0 'և
         .colName (3) = 18 'Հասան-ն տիպ 
         .cond (3) = 15 '>[Սյուն]
         .val (3) = "ACCTYPE" 'Տիպ
         .andOr (4) = 1 'կամ
         .colName (4) = 17 'Բաժին
         .cond (4) = 16 '>=[Սյուն]
         .val (4) = "FROZEN" 
         .andOr (5) = 0 'և
         .colName (5) = 5 'Տիպ
         .cond (5) = 13 '<[Սյուն]
         .val (5) = "ACCNOTE"
    End With
    
    
    
    savePath = Project.Path &  "Stores\FilterCheck\Actual\"
    path(0) = savePath & "Check_Filter_AccActual_1.txt"
    pathExp(0) = Project.Path &  "Stores\FilterCheck\Expected\Check_Filter_AccExpected_1.txt"
    path(1) = savePath & "Check_Filter_AccActual_2.txt"
    pathExp(1) = Project.Path &  "Stores\FilterCheck\Expected\Check_Filter_AccExpected_2.txt"
    path(2) = savePath & "Check_Filter_AccActual_3.txt"
    pathExp(2) = Project.Path &  "Stores\FilterCheck\Expected\Check_Filter_AccExpected_3.txt"
    path(3) = savePath & "Check_Filter_AccActual_4.txt"
    pathExp(3) = Project.Path &  "Stores\FilterCheck\Expected\Check_Filter_AccExpected_4.txt"
    
End Sub