Option Explicit
'USEUNIT Library_Common
'USEUNIT Payment_Order_ConfirmPhases_Library
'USEUNIT Online_PaySys_Library
'USEUNIT Currency_Exchange_Confirmphases_Library
'USEUNIT CashInput_Confirmphases_Library
'USEUNIT CashOutput_Confirmpases_Library
'USEUNIT Constants

'Test case ID 165611

Sub CashOutput_DifferConditions_Test()
    
    Dim fDATE, startDATE , docNumber, summa, fISN, draft, accTemp, data
    Dim confInput, confPath, docExist, isDel, rCount , inspDocVerify, accTemp1
    
    data = aqConvert.DateTimeToFormatStr(aqDateTime.Today(), "%d/%m/%y")
    Utilities.ShortDateFormat = "yyyymmdd"
    startDATE = "20030101"
    fDATE = "20250101"
    confPath = "X:\Testing\CashOutput confirm phases\CashOutput_DifferentConditions.txt"
    accTemp = "03485190101"
    summa = "150000"
    draft = False
    accTemp1 = "03485190103"
    
    'Test StartUp 
    Call Initialize_AsBank("bank", startDATE, fDATE)
    
    'Î³ñ·³íáñáõÙÝ»ñÇ Ý»ñÙáõÍáõÙ
    confInput = Input_Config(confPath)
    If Not confInput Then
        Log.Error("The configuration doesn't input")
    End If
    
    Call ChangeWorkspace(c_ChiefAcc)
    'ì×³ñÙ³Ý Ñ³ÝÓÝ³ñ³ñ·ñÇ ëï»ÕÍáõÙ
    Call CashOutput_Doc_Fill(docNumber, accTemp, summa, fISN, draft)
    
    'îå»Éáõ Ó¨ å³ïáõÑ³ÝÇ ÷³ÏáõÙ
    BuiltIn.Delay(1000)
    wMDIClient.vbObject("FrmSpr").Close
    BuiltIn.Delay(1000)
    wMDIClient.vbObject("frmPttel").Close
    
    Call ChangeWorkspace(c_CustomerService)
    'ö³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ ³ßË³ï³Ýù³ÛÇÝ ÷³ëï³ÃÕÃ»ñ ÃÕÃ³å³Ý³ÏáõÙ
    docExist = Online_PaySys_Check_Doc_In_Workpapers(docNumber, data, data)
    If Not docExist Then
        Log.Error("The document with number " & docNumber & " doesn't exist in workpapers folder")
        Exit Sub
    End If
    
    'ö³ëï³ÃÕÃÇ áõÕ³ñÏáõÙ Ñ³ëï³ïÙ³Ý
    Call Online_PaySys_Send_To_Verify(2)
    
    Login("VERIFIER")
    '1-ÇÝ ö³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ 1-ÇÝ Ñ³ëï³ïáÕÇ Ùáï
    docExist = Online_PaySys_Check_Doc_In_Verifier(docNumber, data, data)
    If Not docExist Then
        Log.Error("The document with number " & docNumber & " doesn't exist in 1st verify documents")
        Exit Sub
    End If
    
    '1-ÇÝ ö³ëï³ÃÕÃÇ í³í»ñ³óáõÙ 1-ÇÝ Ñ³ëï³ïáÕÇ ÏáÕÙÇó
    Call PaySys_Verify(True)
    
    Login("ARMSOFT")
    '¶ÉË³íáñ Ñ³ßí³å³ÑÇ ÁÝ¹Ñ³Ýáõñ ¹ÇïáõÙ ÃÕÃ³å³Ý³ÏáõÙ ÷³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ
    Call ChangeWorkspace(c_ChiefAcc)
    docExist = Check_Doc_In_GeneralView_Folder(fISN)
    If Not docExist Then
        Log.Error("The document with number " & fISN & " must exist in general view folder")
        Exit Sub
    End If
    
    '1-ÇÝ ö³ëï³ÃÕÃÇ Ñ»é³óáõÙ
    Call Online_PaySys_Delete_Agr()
    
    BuiltIn.Delay(1000)
    wMDIClient.vbObject("frmPttel").Close()
    
    Call ChangeWorkspace(c_ChiefAcc)
    'ì×³ñÙ³Ý Ñ³ÝÓÝ³ñ³ñ·ñÇ ëï»ÕÍáõÙ
    Call CashOutput_Doc_Fill(docNumber, accTemp1, summa, fISN, draft)
    
    'îå»Éáõ Ó¨ å³ïáõÑ³ÝÇ ÷³ÏáõÙ
    BuiltIn.Delay(1000)
    wMDIClient.vbObject("FrmSpr").Close
    BuiltIn.Delay(1000)
    wMDIClient.vbObject("frmPttel").Close
    
    Call ChangeWorkspace(c_CustomerService)
    'ö³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ ³ßË³ï³Ýù³ÛÇÝ ÷³ëï³ÃÕÃ»ñ ÃÕÃ³å³Ý³ÏáõÙ
    docExist = Online_PaySys_Check_Doc_In_Workpapers(docNumber, data, data)
    If Not docExist Then
        Log.Error("The document with number " & docNumber & " doesn't exist in workpapers folder")
        Exit Sub
    End If
    
    'ö³ëï³ÃÕÃÇ áõÕ³ñÏáõÙ Ñ³ëï³ïÙ³Ý
    Call Online_PaySys_Send_To_Verify(2)
    
    Login("VERIFIER")
    '2-ñ¹ ö³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ 1-ÇÝ Ñ³ëï³ïáÕÇ Ùáï
    docExist = Online_PaySys_Check_Doc_In_Verifier(docNumber, data, data)
    If Not docExist Then
        Log.Error("The document with number " & docNumber & " doesn't exist in 1st verify documents")
        Exit Sub
    End If
    
    '2-ñ¹  ö³ëï³ÃÕÃÇ í³í»ñ³óáõÙ 1-ÇÝ Ñ³ëï³ïáÕÇ ÏáÕÙÇó
    Call PaySys_Verify(True)
    
    Login("ARMSOFT")
    '¶ÉË³íáñ Ñ³ßí³å³ÑÇ ÁÝ¹Ñ³Ýáõñ ¹ÇïáõÙ ÃÕÃ³å³Ý³ÏáõÙ ÷³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ
    Call ChangeWorkspace(c_ChiefAcc)
    docExist = Check_Doc_In_GeneralView_Folder(fISN)
    If Not docExist Then
        Log.Error("The document with number " & fISN & " must exist in general view folder")
        Exit Sub
    End If
    
    '2-ñ¹ ÷³ëï³ÃÕÃÇ Ñ»é³óáõÙ
    Call Online_PaySys_Delete_Agr()
    
    'Test CleanUp
    Call Close_AsBank()
End Sub