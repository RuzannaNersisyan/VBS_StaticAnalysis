Option Explicit

'USEUNIT Library_Common  
'USEUNIT Akreditiv_Library 
'USEUNIT Constants

'Test Case Id - 160286

Sub Bill_Clicks_Test()
  Dim fDATE, sDATE, Count, i, DocLevel, DocNum, FolderName, CalcAcc
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
  Call ChangeWorkspace(c_BillReceivables)
  
  ReDim arrayWaitForDoc(8)          'պետք է բացվի Doc
  arrayWaitForDoc = Array(c_ToEdit, c_View, c_Opers & "|" & c_Store,_
                           c_Opers & "|" & c_WriteOff & "|" & c_WriteOff,_
                           c_Opers & "|" & c_WriteOff & "|" & c_WriteOffBack,_
                           c_Opers & "|" & c_DebtLet,_
                           c_TermsStates & "|" & c_Risking & "|" & c_RiskCatPerRes,_
                           c_TermsStates & "|" & c_Risking & "|" & c_ObjRiskCat)
  ReDim arrayWaitForView(8)          'պետք է բացվի View
  arrayWaitForView = Array(c_DocumentLog, c_Folders & "|" & c_ClFolder, c_OpersView,_
                            c_ViewEdit & "|" &  c_Risking & "|" &  c_RisksPersRes,_
                            c_ViewEdit & "|" &  c_Risking & "|" &  c_ObjRiskCat,_
                            c_AccEntries & "|" & c_ForBal, c_AccEntries & "|" & c_ForOffBal,_
                            c_ChangeAccsView)     
  
  ''1.Դեբիտորական պարտք                            
  Call Log.Message("Դեբիտորական պարտք",,,attr)                                                      
  CalcAcc = "000047401"                          
  Call wTreeView.DblClickItem("|¸»µÇïáñ³Ï³Ý å³ñïù»ñ|ä³ÛÙ³Ý³·ñ»ñ")
  With AsBank.VBObject("frmAsUstPar")
    .VBObject("TabFrame").VBObject("AsTypeFolder").VBObject("TDBMask").Keys(CalcAcc & "[Tab]")
    .VBObject("CmdOK").ClickButton
  End With
                            
  Count = 8
  For i = 0 To Count-1
    Call OnClick(arrayWaitForDoc(i), "frmASDocForm")
  Next
  
  Count = 8
  For i = 0 To Count-1
    Call OnClick(arrayWaitForView(i), "AsView")
  Next 
  
  Call OnClick(c_References & "|" & c_CommView, "FrmSpr")
  
  'Ջնջել   
  Call OnClick(c_Delete, "frmDeleteDoc")
  
  'Պայմանագրի փակում
  Call OnClick(c_AgrClose, "frmAsUstPar")

  wMDIClient.VBObject("frmPttel").Close

  ''2.Դեբիտորական պարտք(Ետհաշվեկշռային)
  Call Log.Message("Դեբիտորական պարտք(Ետհաշվեկշռային)",,,attr)
  CalcAcc = "8100100"                          
  Call wTreeView.DblClickItem("|¸»µÇïáñ³Ï³Ý å³ñïù»ñ|ä³ÛÙ³Ý³·ñ»ñ")
  With AsBank.VBObject("frmAsUstPar")
    .VBObject("TabFrame").VBObject("ASTypeTree_2").VBObject("TDBMask").Keys(CalcAcc & "[Tab]")
    .VBObject("CmdOK").ClickButton
  End With

  Count = 8
  For i = 0 To Count-1
    If 3 > i or i > 5 Then 
      Call OnClick(arrayWaitForDoc(i), "frmASDocForm")
    End If  
  Next
  
  Count = 8
  For i = 0 To Count-1
    Call OnClick(arrayWaitForView(i), "AsView")
  Next 
  
  Call OnClick(c_References & "|" & c_CommView, "FrmSpr")
  
  'Ջնջել   
  Call OnClick(c_Delete, "frmDeleteDoc")
  
  'Պայմանագրի փակում
  Call OnClick(c_AgrClose, "frmAsUstPar")

  wMDIClient.VBObject("frmPttel").Close
  
  Call Close_AsBank()
End Sub  