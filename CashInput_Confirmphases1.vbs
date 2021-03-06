Option Explicit
'USEUNIT Library_Common
'USEUNIT Payment_Order_ConfirmPhases_Library
'USEUNIT Online_PaySys_Library
'USEUNIT Currency_Exchange_Confirmphases_Library
'USEUNIT CashInput_Confirmphases_Library
'USEUNIT Constants


'Text case number - 165052

Sub CashInput_Allverify_Test()
  Dim fDATE, startDATE , docNumber, summa, fISN, draft, accTemp, data
  Dim confInput, confPath, docExist
  
  data = Null
  Utilities.ShortDateFormat = "yyyymmdd"
  startDATE = "20030101"
  fDATE = "20250101"
  confPath = "X:\Testing\CashInput confirm phases\CashInput_Allverify.txt"
    
  accTemp = "03485190101"
  summa = "250000"                              
  draft = True
    
  BuiltIn.Delay(20000)
  
  'Test StartUp 
  Call Initialize_AsBank("bank", startDATE, fDATE)
    
  'Î³ñ·³íáñáõÙÝ»ñÇ Ý»ñÙáõÍáõÙ
  confInput = Input_Config(confPath)
  If Not confInput Then
    Log.Error("The configuration doesn't input")
  End If
    
  'Î³ÝËÇÏ Ùáõïù ÷³ëï³ÃÕÃÇ  ëï»ÕÍáõÙ
  Call ChangeWorkspace(c_ChiefAcc)
  Call CashInput_Doc_Fill(docNumber, accTemp, summa, fISN, draft)
    
  'îå»Éáõ Ó¨ å³ïáõÑ³ÝÇ ÷³ÏáõÙ
  BuiltIn.delay(1000)
  wMDIClient.vbObject("frmPttel").Close
    
  'ö³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ ë¨³·ñ»ñ ÃÕÃ³å³Ý³ÏáõÙ
  Call ChangeWorkspace(c_CustomerService)
  docExist = Online_PaySys_Check_Doc_In_Drafts(fISN)
  If Not docExist Then
    Log.Error("The document with number " & docNumber & " doesn't exist in drafts folder")
    Exit Sub
  End If
    
  Call CashInput_Verify_Doc_From_Drafts()
    
  BuiltIn.delay(1000)
  wMDIClient.vbObject("FrmSpr").Close()
  BuiltIn.delay(1000)
  wMDIClient.vbObject("frmPttel").Close
    
  docExist = Online_PaySys_Check_Doc_In_Workpapers(docNumber, data, data)
  If Not docExist Then
    Log.Error("The document with number " & docNumber & " doesn't exist in workpapers folder")
    Exit Sub
  End If

  'ö³ëï³ÃÕÃÇ áõÕ³ñÏáõÙ Ñ³ëï³ïÙ³Ý
  Call Online_PaySys_Send_To_Verify(2)
    
  'ö³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ 1-ÇÝ Ñ³ëï³ïáÕÇ Ùáï
  Login("VERIFIER")
  docExist = Online_PaySys_Check_Doc_In_Verifier(docNumber, data, data)
  If Not docExist Then
    Log.Error("The document with number " & docNumber & " doesn't exist in 1st verify documents")
    Exit Sub
  End If
   
  'ö³ëï³ÃÕÃÇ í³í»ñ³óáõÙ 1-ÇÝ Ñ³ëï³áïÕÇ ÏáÕÙÇó
  Call PaySys_Verify(True)
    
  'ö³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛ³Ý ²ßË³ï³Ýù³ÛÇÝ ÷³ëï³ÃÕÃ»ñ ÃÕÃ³å³Ý³ÏáõÙ
  Login("ARMSOFT")
  Call ChangeWorkspace(c_CustomerService)
  BuiltIn.Delay(6000)
  docExist = Online_PaySys_Check_Doc_In_Workpapers(docNumber, null, Null)
  If Not docExist Then
    Log.Error("The document with number " & docNumber & " doesn't exist in workpaper documents")
    Exit Sub
  End If
    
  'ö³ëï³ÃÕÃÇ í³í»ñ³óáõÙ 1-ÇÝ Ñ³ëï³áïÕÇ ÏáÕÙÇó
  Call PaySys_Verify(True)
    
  BuiltIn.delay(1000)
  wMDIClient.vbObject("frmPttel").Close
    
  '¶ÉË³íáñ Ñ³ßí³å³ÑÇ ÁÝ¹Ñ³Ýáõñ ¹ÇïáõÙ ÃÕÃ³å³Ý³ÏáõÙ ÷³ëï³ÃÕÃÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ
  Call ChangeWorkspace(c_ChiefAcc)
  docExist = Check_Doc_In_GeneralView_Folder(fISN)
  If Not docExist Then
    Log.Error("The document with number " & fISN & " must exist in general view folder")
  Else 
    'ö³ëï³ÃÕÃÇ Ñ»é³óáõÙ
    Call Online_PaySys_Delete_Agr()
  End If
    
  'Test CleanUp
  Call Close_AsBank()
End Sub