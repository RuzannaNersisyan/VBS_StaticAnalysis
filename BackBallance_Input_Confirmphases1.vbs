Option Explicit
'USEUNIT Library_Common
'USEUNIT Payment_Order_ConfirmPhases_Library
'USEUNIT Online_PaySys_Library
'USEUNIT Currency_Exchange_Confirmphases_Library
'USEUNIT CashInput_Confirmphases_Library
'USEUNIT BackBallance_Input_Confirmphases_Library 
'USEUNIT Constants  

'Test case ID - 165387

Sub BackBallance_Input_Allverify_Test()
    BuiltIn.Delay(20000)
    
    Dim fDATE, startDATE , docNumber, summa, fISN, draft, nbAcc, aim,data
    Dim confInput, confPath, docExist, isDel, rCount
    
    data = aqConvert.DateTimeToStr(aqDateTime.Today)
    Utilities.ShortDateFormat = "yyyymmdd"
    startDATE = "20030101"
    fDATE = "20250101"
    confPath = "X:\Testing\BackBallance_Input confirm phases\BackBallance_Input_Allverify.txt"
    nbAcc = "999998/900002"
    summa = "250000"
    draft = True
    aim = "All verify"
    
    BuiltIn.Delay(20000)
       
    'Test StartUp 
    Call Initialize_AsBank("bank", startDATE, fDATE)
    
    'Î³ñ·³íáñáõÙÝ»ñÇ Ý»ñÙáõÍáõÙ
    confInput = Input_Config(confPath)
    If Not confInput Then
        Log.Error("The configuration doesn't input")
    End If
    
    Call ChangeWorkspace(c_CustomerService)
    Call Online_PaySys_Go_To_Agr_WorkPapers("|Ð³×³Ëáñ¹Ç ëå³ë³ñÏáõÙ ¨ ¹ñ³Ù³ñÏÕ |²ßË³ï³Ýù³ÛÇÝ ÷³ëï³ÃÕÃ»ñ", data, data)
    
    'ì×³ñÙ³Ý Ñ³ÝÓÝ³ñ³ñ·ñÇ ëï»ÕÍáõÙ
    Call BackBallance_Input_Doc_Fill(docNumber, nbAcc, summa, aim, fISN, draft) 
    
    'îå»Éáõ Ó¨ å³ïáõÑ³ÝÇ ÷³ÏáõÙ
    BuiltIn.Delay(1000)
    wMDIClient.VBObject("frmPttel").Close
    
    'ö³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ ë¨³·ñ»ñ ÃÕÃ³å³Ý³ÏáõÙ
    Call ChangeWorkspace(c_CustomerService)
    docExist = Online_PaySys_Check_Doc_In_Drafts(fISN)
    If Not docExist Then
        Log.Error("The document with number " & docNumber & " doesn't exist in drafts folder")
        Exit Sub
    End If
    
    Call CashInput_Verify_Doc_From_Drafts()
    
    BuiltIn.Delay(1000)
    wMDIClient.VBObject("FrmSpr").Close
    BuiltIn.Delay(1000)
    wMDIClient.VBObject("frmPttel").Close
    
    BuiltIn.Delay(6000)
    docExist = Online_PaySys_Check_Doc_In_Workpapers(docNumber, data, data)
    If Not docExist Then
        Log.Error("The document with number " & docNumber & " doesn't exist in workpapers folder")
        Exit Sub
    End If
    
    'ö³ëï³ÃÕÃÇ áõÕ³ñÏáõÙ Ñ³ëï³ïÙ³Ý
    Call PaySys_Send_To_Verify()
    
    'ö³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ 1-ÇÝ Ñ³ëï³ïáÕÇ Ùáï
    Login("VERIFIER")
    docExist = Online_PaySys_Check_Doc_In_Verifier(docNumber, data, data)
    If Not docExist Then
        Log.Error("The document with number " & docNumber & " doesn't exist in 1st verify documents")
        Exit Sub
    End If
    
    'ö³ëï³ÃÕÃÇ í³í»ñ³óáõÙ 1-ÇÝ Ñ³ëï³áïÕÇ ÏáÕÙÇó
    Call PaySys_Verify(True)
    
    'ö³ëï³ÃÕÃÇ í³í»ñ³óáõÙ ²ßË³ï³Ýù³ÛÇÝ ÷³ëï³ÃÕÃ»ñ ÃÕÃ³å³Ý³ÏÇó
    Login("ARMSOFT")

    '¶ÉË³íáñ Ñ³ßí³å³ÑÇ Ñ³ßí³ñí³Í »ïÑ³ßí»Ïßé³ÛÇÝ ÷³ëï³ÃÕÃ»ñ ÃÕÃ³å³Ý³ÏáõÙ ÷³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ
    Call ChangeWorkspace(c_ChiefAcc)
    docExist = Check_Doc_In_RegBackBallance_Workpaper(docNumber)
    If Not docExist Then
        Log.Error("The document with number " & fISN & " must exist in general view folder")
        Exit Sub
    End If
    
    BuiltIn.Delay(6000)
    'ö³ëï³ÃÕÃÇ Ñ»é³óáõÙ
    Call Online_PaySys_Delete_Agr()
    
    'Test CleanUp 
    Call Close_AsBank()
End Sub