Option Explicit

'USEUNIT Library_Common  
'USEUNIT Akreditiv_Library 
'USEUNIT Constants

'Test Case Id - 160273

Sub Akreditiv_Clicks_Test()
  Dim fDATE, sDATE, AsUstPar, Count, i, DocNum, DocType, DocLevel, FolderName
  Dim arrayWaitForDoc, arrayWaitForView, arrayWaitForModalBrowser, arrayFrmSpr
  Dim attr
        
  ''Համակարգ մուտք գործել ARMSOFT օգտագործողով
  fDATE = "20220101"
  sDATE = "20140101"
  Call Initialize_AsBank("bank", sDATE, fDATE)
  Login("ARMSOFT")
  
'--------------------------------------
  Set attr = Log.CreateNewAttributes
  attr.BackColor = RGB(255, 255, 0)
  attr.Bold = True
  attr.Italic = True
'-------------------------------------- 

  ReDim arrayWaitForDoc(19)          'պետք է բացվի Doc 
  arrayWaitForDoc = Array(c_ToEdit, c_View, c_Safety & "|" & c_AgrOpen & "|" & c_Guarantee,_
                           c_Safety & "|" & c_AgrBindNew & "|" & c_AgrBind , c_Acceptance, c_InputPrimaryContract,_
                           c_Opers & "|" & c_IntRepayment, c_Opers & "|" & c_Store & "|" & c_Store,_
                           c_Opers & "|" & c_Store & "|" & c_UnusedPartStore, c_Opers & "|" & c_Interests & "|" & c_PrcAccruing, c_Opers & "|" & c_Interests & "|" & c_AccAdjust,_
                           c_Opers & "|" & c_WriteOff & "|" & c_WriteOff, c_Opers & "|" & c_WriteOff & "|" & c_WriteOffBack, c_TermsStates & "|" & c_Dates & "|" & c_ReviewTerms, c_TermsStates & "|" & c_Risking & "|" & c_RiskCatPerRes,_
                           c_TermsStates & "|" & c_Percentages & "|" & c_Percentages, c_TermsStates & "|" & c_Percentages & "|" & c_EffRate, c_TermsStates & "|" & c_Other & "|" & c_Limit, c_TermsStates & "|" & c_StopLine)
  ReDim arrayWaitForView(18)          'պետք է բացվի View
  arrayWaitForView = Array(c_DocumentLog, c_Folders & "|" & c_ClFolder, c_Folders & "|" & c_AgrFolder,_
                            c_Folders & "|" & c_Acceptances, c_Folders & "|" & c_LiabilitiesInLC, c_Safety & "|" & c_AgrBindNew & "|" & c_LinksOfAgreement,_
                            c_OpersView, c_ViewEdit & "|" & c_Dates & "|" & c_AgrDates, c_ViewEdit & "|" & c_Dates & "|" & c_PerDates,_
                            c_ViewEdit & "|" &  c_Risking & "|" &  c_RisksPersRes, c_ViewEdit & "|" & c_Percentages & "|" & c_Percentages, c_ViewEdit & "|" & c_Percentages & "|" & c_EffRate,_
                            c_ViewEdit & "|" & c_Other & "|" & c_AccAdjust, c_ViewEdit & "|" & c_Other & "|" & c_Limits, c_ViewEdit & "|" & c_Other & "|" & c_CalcDates,_
                            c_ViewEdit & "|" & c_LineBrRec, c_AccEntries & "|" & c_ForBal, c_AccEntries & "|" & c_ForOffBal)                            
  ReDim arrayWaitForModalBrowser(2)   'պետք է բացվի ModalBrowser
  arrayWaitForModalBrowser = Array(c_Safety & "|" & c_AgrOpen & "|" & c_Mortgage, c_Safety & "|" & c_AgrBind & "|" & c_Mortgage,_
                                    c_Safety & "|" & c_AgrBind & "|" & c_Guarantee)
  ReDim arrayFrmSpr(2)        
  arrayFrmSpr = Array(c_References & "|" & c_CommView, c_References & "|" & c_CliRepaySchedule, c_References & "|" &  c_Statement)
  
  FolderName = "|ºÝÃ³Ñ³Ù³Ï³ñ·»ñ (§ÐÌ¦)|ä³ÛÙ³Ý³·ñ»ñ|î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|²Ïñ»¹ÇïÇí|"
  Call ChangeWorkspace(c_Subsystems)
  
  ''1.Ակրեդիտիվ
  Call Log.Message("Ակրեդիտիվ",,,attr)
  DocLevel = 2
  DocNum = 3758
	Call LetterOfCredit_Filter_Fill(FolderName, DocLevel, DocNum)     
  
  
  Count = 19
  For i = 0 To Count-1
    Call OnClick(arrayWaitForDoc(i), "frmASDocForm")
  Next
  
  Count = 18
  For i = 0 To Count-1
    Call OnClick(arrayWaitForView(i), "AsView")
  Next 
  
  Count = 3
  For i = 0 To Count-1
    Call OnClick(arrayWaitForModalBrowser(i), "frmModalBrowser")
  Next 
  
  Count = 3
  For i = 0 To Count-1
    Call OnClick(arrayFrmSpr(i), "FrmSpr")
  Next 
  
  'Ջնջել   
  Call OnClick(c_Delete, "frmDeleteDoc")
  
  'Պայմանագրի փակում
  Call OnClick(c_AgrClose, "frmAsUstPar")

  wMDIClient.VBObject("frmPttel").Close
  
  ''2.Ակցեպտավորման պայմանագիր
  Call Log.Message("Ակցեպտավորման պայմանագիր",,,attr)
  DocLevel = 1
  DocNum = 3758
	Call LetterOfCredit_Filter_Fill(FolderName, DocLevel, DocNum)     
  
  Count = 19  
  For i = 0 To Count-1
    If arrayWaitForDoc(i) <> c_Acceptance and arrayWaitForDoc(i) <> c_Opers & "|" & c_Store & "|" & c_UnusedPartStore and arrayWaitForDoc(i) <> c_TermsStates & "|" & c_Percentages & "|" & c_EffRate and arrayWaitForDoc(i) <> c_Opers & "|" & c_IntRepayment and arrayWaitForDoc(i) <> c_TermsStates & "|" & c_Other & "|" & c_Limit and arrayWaitForDoc(i) <> c_TermsStates & "|" & c_StopLine Then
      Call OnClick(arrayWaitForDoc(i), "frmASDocForm")
    End If  
  Next
  
  ReDim arrayWaitForDoc(5)          'պետք է բացվի Doc
  arrayWaitForDoc = Array(c_Opers & "|" & c_GiveAndBack & "|" & c_PayOffDebt, c_Opers & "|" & c_GiveAndBack & "|" & c_ReturnPrepaidInt, c_Opers & "|" & c_GiveAndBack & "|" & c_WriteOffRepay, c_Opers & "|" & c_GiveAndBack & "|" & c_FadeLCFromPercent, c_TermsStates & "|" & c_Percentages & "|" & c_BankEffRate)
  Count = 5
  For i = 0 To Count-1
    If arrayWaitForDoc(i) <> c_Acceptance Then
      Call OnClick(arrayWaitForDoc(i), "frmASDocForm")
    End If  
  Next
  
  Count = 18
  For i = 0 To Count-1
    BuiltIn.Delay(100)
    If arrayWaitForView(i) <> c_Folders & "|" & c_LiabilitiesInLC and arrayWaitForView(i) <> c_Folders & "|" & c_Acceptances and arrayWaitForView(i) <> c_ViewEdit & "|" & c_Other & "|" & c_Limits and arrayWaitForView(i) <> c_ViewEdit & "|" & c_Percentages & "|" & c_EffRate and arrayWaitForView(i) <> c_ViewEdit & "|" & c_LineBrRec Then
      Call OnClick(arrayWaitForView(i), "AsView")
    End If
  Next
  
  ReDim arrayWaitForView(4)          'պետք է բացվի View
  arrayWaitForView = Array(c_Folders & "|" & c_AgrOwnFolder , c_Folders & "|" & c_ParentAgr, c_References & "|" & c_CheckPastdueSums, c_ViewEdit & "|" & c_Percentages & "|" & c_BankEffRate)
  Count = 4
  For i = 0 To Count-1
    Call OnClick(arrayWaitForView(i), "AsView")
  Next
  
  Count = 3
  For i = 0 To Count-1
    Call OnClick(arrayWaitForModalBrowser(i), "frmModalBrowser")
  Next
  
  Count = 3
  For i = 0 To Count-1
    Call OnClick(arrayFrmSpr(i), "FrmSpr")
  Next 
  
  'Ջնջել   
  Call OnClick(c_Delete, "frmDeleteDoc")
  
  'Պայմանագրի փակում
  Call OnClick(c_AgrClose, "frmAsUstPar")

  wMDIClient.VBObject("frmPttel").Close
     
  Call Close_AsBank()                   
End Sub 