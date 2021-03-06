Option Explicit
'USEUNIT Payment_Order_ConfirmPhases_Library
'USEUNIT Loan_Agreements_Library
'USEUNIT Subsystems_SQL_Library
'USEUNIT Akreditiv_Library
'USEUNIT Library_Common
'USEUNIT Constants
'USEUNIT Mortgage_Library

'Test Case ID 165684

Sub Akreditiv_Non_Renewable_Test()

    Dim startDATE , fDATE ,fBASE, docNumber, clientCode, curr, accacc, summ
    Dim dategive, date_arg , restore, agrIntRate, agrIntRatePart
    Dim sector, schedule, guarante, district, paperCode
    Dim SSum,Claim_Term,Loss_Term,Loss_Persent,Department,Notifier_Bank,Settlement_Account
    Dim Exist,Doc_Level , CLSate ,Param
    Dim DocNum,DBalance,DDate,DPayment,region,result
    Dim LDate , DLimit,actionType,aim,country
    Dim Calculate_Date , Action_Date,Rdate,MainSum
    Dim isEqual,CLimit,DocN,actionExists,actionEx
    Dim queryString,sql_Value,colNum,sql_isEqual,TF ,Count, AMDCount

    startDATE = "20120101"
    fDATE = "20190101"    
    docNumber= ""
    clientCode = "00000668"
    curr  = "000"
    accacc = "33170160500"
    summ = "1000000"
    dateGive = "110515"
    date_arg = "110516"
    restore= false
    agrIntRate= "18"
    agrIntRatePart= "365"
    sector= "U2 "
    aim = "00"
    schedule= "9"
    guarante= "9"
    district= "001"
    paperCode= "123"
    country = "AM"
    region = "010000008"
     
    'Test StartUp start
    Call Initialize_AsBank("bank", startDATE, fDATE)
    
    Call Create_Connection()
    
    Call ChangeWorkspace(c_LetterOfCredit)
    Call wTreeView.DblClickItem("|²Ïñ»¹ÇïÇí|Üáñ å³ÛÙ³Ý³·ñÇ ëï»ÕÍáõÙ")
    
    'Ստեղծել Ակրեդիտիվ գլխավոր պայմանագիր
    Call  Letter_Of_Credit_Doc_Fill(fBASE, docNumber, clientCode, curr, accacc, summ, _
                                restore, dateGive, date_arg , agrIntRate, agrIntRatePart, _
                                sector, aim,schedule,country, guarante, district,region, paperCode)
               
    BuiltIn.Delay(6000)                            
    Call wMainForm.MainMenu.Click(c_AllActions)
    Call wMainForm.PopupMenu.Click(c_OtherPaySchedule)
    BuiltIn.Delay(2000)
    wMDIClient.Refresh
    BuiltIn.Delay(2000)
    Call ClickCmdButton(1, "Î³ï³ñ»É")
    
    Exist = Find_Main_Contract("²Ïñ»¹ÇïÇíÇ ·ÉË³íáñ å³ÛÙ³Ý³·Çñ- "& Trim(docNumber) & " {²ÝáõÝ ²½·³ÝáõÝÛ³Ý}")
    
    'Կատարում է ստուգում , եթե գլխավոր պայմանագիրը առկա է ,ապա ուղարկում է հաստատման, հակառակ դեպքում դուրս է բերում սխալ
    If Not Exist Then
      Log.Error("Could't find contract")
      Exit Sub
    End If     
    
        'Կատարում ենք SQL ստուգում: Պայամանգիր ստեղծելուց հետո պետք է ,որ fDGSTATE = 1
        queryString = "select * from CONTRACTS where fDGISN= '" & fBASE & "'"
        sql_Value = 1
        colNum = 13
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
    
    'Ուղարկում է պայմանագիրը հաստատման        
    Call PaySys_Send_To_Verify()
     
    'Փակում է պատուհանը
    BuiltIn.Delay(2000)
    Call Close_Pttel("frmPttel")
   
        'Կատարում ենք SQL ստուգում: Պայամանգիր հաստատման ուղարկելուց  հետո պետք է ,որ fDGSTATE = 60
        queryString = "select * from CONTRACTS where fDGISN= '" & fBASE & "'"
        sql_Value = 60
        colNum = 13
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
   
       
    Call ChangeWorkspace(c_BLVerifyer)
    Call wTreeView.DblClickItem("|§ê¨ óáõó³Ï¦ Ñ³ëï³ïáÕÇ ²Þî|Ð³ëï³ïíáÕ ï»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ ¨ »ñ³ßË³íáñáõÃÛáõÝÝ»ñ")
    'Սեղմել Կատարել կոճակը
    Call ClickCmdButton(2, "Î³ï³ñ»É")
    
	   If SearchInPttel("frmPttel",2, docNumber) Then
        'Վավերացնում է փաստաթուղթը
        Call Validate_Doc()
        BuiltIn.Delay(2000)
        Call Close_Pttel("frmPttel")
    Else
        Log.Error "Can Not find this row!",,,ErrorColor
    End If

        'Կատարում ենք SQL ստուգում: Պայամանգիր «Սև ցուցակում վավերացնելուց հետո պետք է ,որ fDGSTATE = 101
        queryString = "select * from CONTRACTS where fDGISN= '" & fBASE & "'"
        sql_Value = 101
        colNum = 13
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
          Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
   
      
    Call ChangeWorkspace(c_LetterOfCredit)
    Call wTreeView.DblClickItem("|²Ïñ»¹ÇïÇí|Ð³ëï³ïíáÕ ÷³ëï³ÃÕÃ»ñ I")
   
    'Փնտրում է պայմանագիրը
    Exist= Find_Doc(docNumber)
    If Not Exist Then
    Log.Error("Doc doesn't exist")
    Exit Sub
    End If
    'Վավերացնել փաստաթուղթը
    Call Validate_Doc()
   
        'Կատարում ենք SQL ստուգում: Պայամանգիր "Հաստատվող փաստաթղթեր I" վավերացնելուց  հետո պետք է ,որ fDGSTATE = 7
        queryString = "select * from CONTRACTS where fDGISN= '" & fBASE & "'"
        sql_Value = 7
        colNum = 13
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If 
  
    BuiltIn.Delay(2000)
    Call Close_Pttel("frmPttel")
        
    Log.Message(docNumber)     
    Call ChangeWorkspace(c_LetterOfCredit)
    Call wTreeView.DblClickItem("|²Ïñ»¹ÇïÇí|ä³ÛÙ³Ý³·ñ»ñ")
    
    'Փնտրում է պայմանագիրը    
    'Կատարում է ստուգում,եթե փաստաթուղթը առկա է,ապա այն վերականգնում ենք,հակառակ դեպքում դուրս է բերվում սխալ
    Doc_Level = "2" 
    Exist =  Goto_Doc_Check(Doc_Level,docNumber)
    If Not Exist Then
      Log.Error("Documet does't exists")
    Exit Sub
    End If  
    
    'Պայմանագրի Գծայնության վերականգնում/դադարեցում
    Param  = "|Գծայնության վերականգնում"
    CLSate = "2"
    Call  Credit_Termination_Restoration(Param,dategive,CLSate)    
    
    'Ակցեպտավորում պայմանագրի ստեղծում
    SSum = "300000"
    Claim_Term = "110116"
    Loss_Term = "110216"
    Loss_Persent = "12"
    Department = "365"
    Notifier_Bank = "00000001"
    Settlement_Account = "00000111400"
    Call Create_Acceptance( dategive,SSum,Claim_Term,Loss_Term,Loss_Persent,Department,Notifier_Bank,Settlement_Account)
    
    BuiltIn.Delay(2000)
    Call wMainForm.MainMenu.Click(c_AllActions)
    Call wMainForm.PopupMenu.Click(c_Folders & "|" & c_LiabilitiesInLC)
    BuiltIn.Delay(2000)
    Call Close_Pttel("frmPttel")
    wMainForm.Window("MDIClient", "", 1).Refresh
   
    'Պարտավորություններ Ակրեդիտիվի գծով թղթապանակից վերցնում ենք պայմանագրի համարը
    DocN = Trim(wMDIClient.vbObject("frmPttel").vbObject("tdbgView").Columns.Item(0).Text)
  
    BuiltIn.Delay(2000)
    Call Close_Pttel("frmPttel")
   
    Call ChangeWorkspace(c_Subsystems)
    Call wTreeView.DblClickItem("ä³ÛÙ³Ý³·ñ»ñ|Ü»ñ·ñ³íí³Í ÙÇçáóÝ»ñ|ä³ñï³íáñáõÃÛáõÝÝ»ñ ²Ïñ»¹ÇïÇíÇ ·Íáí|ä³ÛÙ³Ý³·ñ»ñ")
    'Փնտրում է պայմանագիրը
    Doc_Level = "1"
    Call Goto_Doc_Check(Doc_Level,DocN)
   
    BuiltIn.Delay(1000)
    Sys.Process("Asbank").Refresh
    DBalance = "300,000.00"
    DDate = "11/05/15"
    DPayment = "11/02/16"
  
    'Ստուգում է պայմանագրի արժույթի ճշտությունը
    If Not Trim(wMDIClient.VBObject("frmPttel").VBObject("tdbgView").Columns.Item(2).Text) = Trim(curr) Then
      Log.Error("Don't match")
    End If
  
    'Ստուգում է պայմանագրի մնացորդի ճշտությունը
    If Not Trim(wMDIClient.vbObject("frmPttel").vbObject("tdbgView").Columns.Item(3).Text) = Trim(DBalance) Then
      Log.Error("Don't match")
    End If
  
    'Ստուգում է ամսաթիվ դաշտը
    If Not Trim(wMDIClient.vbObject("frmPttel").vbObject("tdbgView").Columns.Item(5).Text) = Trim(DDate) Then
      Log.Error("Don't match")
    End If
  
    'Ստուգում է մարման ժամկետի ճշտւթյունը
    If Not Trim(wMDIClient.vbObject("frmPttel").vbObject("tdbgView").Columns.Item(6).Text) = Trim(DPayment) Then
      Log.Error("Don't match")
    End If
  
    BuiltIn.Delay(1000)
    Sys.Process("Asbank").Refresh
    'Ստուգում է  Հաճախորդի ճշտությունը
    If Not Trim(wMDIClient.VBObject("frmPttel").VBObject("tdbgView").Columns.Item(8).Text) = Trim(Notifier_Bank) Then
      Log.Error("Don't match")
    End If
   
    BuiltIn.Delay(2000)
    Call Close_Pttel("frmPttel")
        
    Call ChangeWorkspace(c_LetterOfCredit)
    Call wTreeView.DblClickItem("|²Ïñ»¹ÇïÇí|ä³ÛÙ³Ý³·ñ»ñ")
    
    'Ստուգում է պայմանագրի առկայությունը
    Doc_Level = "2"
    Exist = Goto_Doc_Check(Doc_Level,docNumber)
    If Not Exist Then 
    Log.Error("Doesn't match")
    End If
   
    'Կատարույ է ստուգում,եթե փաստաթուղթը առկա է,ապա այն դադարեցնում ենք,հակառակ դեպքում դուրս է բերվում սխալ
    DLimit = "1,000,000.00"    
    TF = 1
    Exist = Check_Limit( dategive,date_arg,TF, DLimit) 
    If Not Exist Then
    Log.error( "Don't match ") 
    End If
   
    'Կատարում է "Գծայնության վերականգնում/դադարեցում"
    CLSate = "1"
    LDate = "110615"
    Param  = "|Գծայնության դադարեցում"
    Call Credit_Termination_Restoration(Param, LDate,CLSate)    
  
    'Կատարում ենք ստուգում, եթե պայմանագիրը միակն է կատարում ենք տոկոսների հաշվում,հակառակ դեպքում դուրս է բերում սխալ  
    Exist= Chek_One_Doc()
    If Not Exist Then
      Log.Error("There is more than ane document")
    End If
  
    'Կատարում է Տոկոսների հաշվարկ
    Calculate_Date = "120615"
    Action_Date = "120615"
    Call Calculate_Percent(fBase , Calculate_Date , Action_Date)
   
    'Կատարում ենք տոկոսների հաշվում Ակցեպտավորողներ թղթապանակում
    Call wMainForm.MainMenu.Click(c_AllActions)
    Call wMainForm.PopupMenu.Click(c_Folders & "|" & c_Acceptances)
  
    'Կատարում է Տոկոսների հաշվարկ
    Call Calculate_Percent(fBase,Calculate_Date , Action_Date)
    log.Message(fBase)
  
        'SQL ստուգում Տոկոսների հաշվարկում փաստաթուղթ ստեղծելուց հետո
        queryString = "select Sum(fCURSUM), Sum(fSUM) from HI where fDATE = '2015-06-12' and fBASE = " & fBASE & " and fDBCR = 'C'"
        sql_Value = 9526.80
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
   
        sql_Value = 9526.80
        colNum = 1
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
    
        queryString = "select Sum(fCURSUM), Sum(fSUM) from HI where fDATE = '2015-06-12' and fBASE = " & fBASE & " and fDBCR = 'D'"
        sql_Value = 9526.80
        colNum = 0
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
   
    'Տոկոսների տրամադրում /մարում
    Count = " "
    AMDCount = " "
    RDate = "130615"
    MainSum = "1000"
    Call AkrPayment(fBASE, RDate,MainSum, Count, AMDCount)
      
    BuiltIn.Delay(5000)
    
        'SQL ստուգում: Ակրեդիտիվ պայմանագրի պարտքերի մարման հայտ ստեղծելուց հետո պետք է fSUM = 1000.00
        queryString = "select * from HI where fDATE = '2015-06-13' and fBASE = " & fBASE & " and fDBCR = 'C'"
        sql_Value = 1000.00
        colNum = 3
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
   
    
        queryString = "select * from HI where fDATE = '2015-06-13' and fBASE = " & fBASE & " and fDBCR = 'D'"
        sql_Value = 1000.00
        colNum = 3
        sql_isEqual = CheckDB_Value(queryString, sql_Value, colNum)
        If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sql_Value)
        End If
   
   
    BuiltIn.Delay(2000)
    Call Close_Pttel("frmPttel_2")
    'Վարկային գծի վերականգնում/դադարեցում
    LDate = "200615"
    CLSate = "2"
    Param = "|Գծայնության վերականգնում"
    Call Credit_Termination_Restoration(Param,LDate,CLSate)  

    'Ստուգում է ,արդյոք սահմանաչափը փոխվել է
    Climit = "999,000.00"
    isEqual = Check_Changed_Limit(dategive,date_arg,CLimit)    
    If isEqual Then
      BuiltIn.Delay(2000)
      Call Close_Pttel("frmPttel_2")
    Else
      Log.Error("The limit doesn't change") 
    End If
   
    'Ընդհանուր դիտում
    Call Watch_Contract(dategive)
   
    Log.Message "Բոլոր փաստաթղթերի ջնջում"
    
    actionType = Null
    actionExists = True
    actionEx = False
    
'    Call Close_Pttel("frmPttel")
'    Call DeleteAllActions("|²Ïñ»¹ÇïÇí|Üáñ ÷³ëï³Ã., ÃÕÃ³å³Ý³ÏÝ»ñ, Ñ³ßí»ïíáõÃÛáõÝÝ»ñ",docNumber,"010114","010116")
    
    'Հաշվարկային հաշիվ
    'Ջնջում է Գործողությունների դիտում թղթապանակի բոլոր փաստաթղթերը
    Call Delete_Actions_ByCount(dategive,date_arg,actionExists,actionType,c_OpersView,1)
    'Ջնջում է Սահմանաչափեր թղթապանակի բոլոր փաստաթղթերը
    Call Delete_Actions_ByCount(dategive,date_arg,actionEx,actionType,c_ViewEdit & "|" & c_Other & "|" & c_Limits,1)
    'Ջնջում է Հաշվարկման ամսաթվեր թղթապանակի բոլոր փաստաթղթերը
    Call Delete_Actions_ByCount(dategive,date_arg,actionEx,actionType,c_ViewEdit & "|" & c_Other & "|" & c_CalcDates,1)
    
    'Ջնջում է Գործողությունների դիտում թղթապանակի բոլոր փաստաթղթերը
    Call Delete_Actions_ByCount(dategive,date_arg,actionExists,actionType,c_OpersView,0)
    'Ջնջում է Սահմանաչափեր թղթապանակի բոլոր փաստաթղթերը
    Call Delete_Actions_ByCount(dategive,date_arg,actionEx,actionType,c_ViewEdit & "|" & c_Other & "|" & c_Limits,0)
    'Ջնջում է Հաշվարկման ամսաթվեր թղթապանակի բոլոր փաստաթղթերը
    Call Delete_Actions_ByCount(dategive,date_arg,actionEx,actionType,c_ViewEdit & "|" & c_Other & "|" & c_CalcDates,0)
    
    'Ջնջում է գլխավոր պայմանագիրը
    Call Delete_Doc()
    BuiltIn.Delay(2000)
    Call Close_Pttel("frmPttel")
  
    Call Close_AsBank()
End Sub