Option Explicit
'USEUNIT Subsystems_SQL_Library
'USEUNIT  Library_Common
'USEUNIT Constants
'USEUNIT Library_Contracts
'USEUNIT SWIFT_International_Payorder_Library
'USEUNIT Payment_Except_Library
'USEUNIT Library_Colour

'Test Case 163099

'"Դիտել փաստաթուղթը մասերով" գործողության ստուգում Վարկեր տեղաբաշխվածից, Պայմանագրեր թղթապանակում
Sub Agreements_From_Loans_Placed()


      Dim fDATE, sDATE
      Dim ContractsFilter, ViewDocumentParts, Path1, Path2, savePath, fileName, OpenActionsView
      
      fDATE = "20250101"
      sDATE = "20030101"
      Call Initialize_AsBank("bank", sDATE, fDATE)
      
      ' Մուտք գործել համակարգ ARMSOFT օգտագործողով 
      Call Create_Connection()
      Login("ARMSOFT")
      
      ' Մուտք Ենթահամակարգեր ՀԾ
      Call ChangeWorkspace(c_Subsystems)
      
      ' Մուտք Պայմանագրեր/Տեղաբաշխված միջոցներ/Վարկեր (Տեղաբաշխված)/Պայմանագրեր/Պայամանգրեր
      Call wTreeView.DblClickItem("|ºÝÃ³Ñ³Ù³Ï³ñ·»ñ (§ÐÌ¦)|ä³ÛÙ³Ý³·ñ»ñ|î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|ì³ñÏ»ñ (ï»Õ³µ³ßËí³Í)|ä³ÛÙ³Ý³·ñ»ñ|ä³ÛÙ³Ý³·ñ»ñ")
      
      Set ContractsFilter = New_ContractsFilter()
      ContractsFilter.AgreementN = "V-001843"
      ContractsFilter.AgreementLevel = "1"
      
      Call Fill_ContractsFilter(ContractsFilter)
      BuiltIn.Delay(1500)
      
      ' Ստուգում որ պայամանագիրն առկա է թղթապանակում
      If  wMDIClient.VBObject("frmPttel").VBObject("TDBGView").ApproxCount <> 1 Then
             Log.Error"Պայմանագիրն առկա չէ Վարկային պայմանագրեր թղթապանակում" ,,,ErrorColor
             Exit Sub
      End If

      Log.Message "--- Դիտել փաստաթուղթը 'Տպել կարգադրությունը', 'Տպել հիշարար օրդերը', 'Տպել հանձնարարագիրը' նշիչներով ---" ,,, DivideColor 
      ' Մուտք"Գործողությունների դիտում" թղթապանակ
      Set OpenActionsView = New_OpenActionsView()
      With OpenActionsView
            .stDate = "010106"
            .eDate = "010110"
            .dealType = "21"
      End With
      
      Call Fill_OpenActionsView(OpenActionsView)
      
      '"Դիտել փաստաթուղթը մասերով" գործողության կատարում
      Set ViewDocumentParts = New_ViewDocumentParts()
      With ViewDocumentParts
            .wDirect = 1
            .memOrd = 1
            .payOrd = 1
      End With
      
      Call Fill_ViewDocumentParts(ViewDocumentParts)
      
      Path1 = Project.Path &  "Stores\ViewDocumentParts\Actual\ContractsAct_1.txt"
      Path2 = Project.Path &  "Stores\ViewDocumentParts\Expected\ContractsExp_1.txt"
      ' Ջնջել ContractsAct_1.txt ֆայլը
      aqFile.Delete(Path1)
      
      ' Հիշել քաղվածքը
      savePath = Project.Path & "Stores\ViewDocumentParts\Actual\"
      fileName = "ContractsAct_1"
      Call SaveDoc(savePath, fileName)

      ' Համեմատել երկու txt ֆայլերը
      Call Compare_Files(Path2, Path1, "")
      
      BuiltIn.Delay(1000)
      If  wMDIClient.WaitVBObject("FrmSpr", 1000).Exists  Then
            wMDIClient.VBObject("FrmSpr").Close
      Else 
            Log.Error "Դիտել պարամետրը չի բացվել",,,ErrorColor
      End If 
      
      Log.Message "--- Դիտել փաստաթուղթը 'Տպել կարգադրությունը' նշիչով ---" ,,, DivideColor 
      '"Դիտել փաստաթուղթը մասերով" գործողության կատարում
      Set ViewDocumentParts = New_ViewDocumentParts()
      With ViewDocumentParts
            .wDirect = 1
            .memOrd = 0
            .payOrd = 0
      End With
      
      Call Fill_ViewDocumentParts(ViewDocumentParts)
      
      Path1 = Project.Path &  "Stores\ViewDocumentParts\Actual\ContractsAct_2.txt"
      Path2 = Project.Path &  "Stores\ViewDocumentParts\Expected\ContractsExp_2.txt"
      ' Ջնջել ContractsAct_2.txt ֆայլը
      aqFile.Delete(Path1)
      
      ' Հիշել քաղվածքը
      savePath = Project.Path & "Stores\ViewDocumentParts\Actual\"
      fileName = "ContractsAct_2"
      Call SaveDoc(savePath, fileName)

      ' Համեմատել երկու txt ֆայլերը
      Call Compare_Files(Path2, Path1, "")
      
      BuiltIn.Delay(1000)
      If  wMDIClient.WaitVBObject("FrmSpr", 1000).Exists  Then
            wMDIClient.VBObject("FrmSpr").Close
      Else 
            Log.Error "Դիտել պարամետրը չի բացվել" ,,,ErrorColor
      End If

      Log.Message "--- Դիտել փաստաթուղթը 'Տպել հիշարար օրդերը' նշիչով ---" ,,, DivideColor 
      '"Դիտել փաստաթուղթը մասերով" գործողության կատարում
      Set ViewDocumentParts = New_ViewDocumentParts()
      With ViewDocumentParts
            .wDirect = 0
            .memOrd = 1
            .payOrd = 0
      End With
      
      Call Fill_ViewDocumentParts(ViewDocumentParts)
      
      Path1 = Project.Path &  "Stores\ViewDocumentParts\Actual\ContractsAct_3.txt"
      Path2 = Project.Path &  "Stores\ViewDocumentParts\Expected\ContractsExp_3.txt"
      ' Ջնջել ContractsAct_3.txt ֆայլը
      aqFile.Delete(Path1)
      
      ' Հիշել քաղվածքը
      savePath = Project.Path & "Stores\ViewDocumentParts\Actual\"
      fileName = "ContractsAct_3"
      Call SaveDoc(savePath, fileName)

      ' Համեմատել երկու txt ֆայլերը
      Call Compare_Files(Path2, Path1, "")
      
      BuiltIn.Delay(1000)
      If  wMDIClient.WaitVBObject("FrmSpr", 1000).Exists  Then
            wMDIClient.VBObject("FrmSpr").Close
      Else 
            Log.Error "Դիտել պարամետրը չի բացվել" ,,,ErrorColor
      End If
      
      Log.Message "--- Դիտել փաստաթուղթը 'Տպել հանձնարարագիրը' նշիչով ---" ,,, DivideColor 
      '"Դիտել փաստաթուղթը մասերով" գործողության կատարում
      Set ViewDocumentParts = New_ViewDocumentParts()
      With ViewDocumentParts
            .wDirect = 0
            .memOrd = 0
            .payOrd = 1
      End With
      
      Call Fill_ViewDocumentParts(ViewDocumentParts)
      
      Path1 = Project.Path &  "Stores\ViewDocumentParts\Actual\ContractsAct_4.txt"
      Path2 = Project.Path &  "Stores\ViewDocumentParts\Expected\ContractsExp_4.txt"
      ' Ջնջել ContractsAct_4.txt ֆայլը
      aqFile.Delete(Path1)
      
      ' Հիշել քաղվածքը
      savePath = Project.Path & "Stores\ViewDocumentParts\Actual\"
      fileName = "ContractsAct_4"
      Call SaveDoc(savePath, fileName)

      ' Համեմատել երկու txt ֆայլերը
      Call Compare_Files(Path2, Path1, "")
      
      If  wMDIClient.WaitVBObject("FrmSpr", 1000).Exists  Then
            wMDIClient.VBObject("FrmSpr").Close
      Else 
            Log.Error "Դիտել պարամետրը չի բացվել" ,,,ErrorColor
      End If
      
      'Փակում է ընթացիկ պատուհանը
      BuiltIn.Delay(2000)
      Call wMainForm.MainMenu.Click(c_Windows)
      Call wMainForm.PopupMenu.Click(c_ClAllWindows)
      
      
      '--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      Log.Message "---  Ավանդներ տեղաբաշխված ---" ,,, DivideColor 
      Call wTreeView.DblClickItem("|ºÝÃ³Ñ³Ù³Ï³ñ·»ñ (§ÐÌ¦)|ä³ÛÙ³Ý³·ñ»ñ|î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|î»Õ³µ³ßËí³Í ³í³Ý¹Ý»ñ|ä³ÛÙ³Ý³·ñ»ñ")
      
      Set ContractsFilter = New_ContractsFilter()
      ContractsFilter.AgreementN = "0000000002"
      ContractsFilter.AgreementLevel = "1"
      
      Call Fill_ContractsFilter(ContractsFilter)
      
      ' Ստուգում որ պայամանագիրն առկա է թղթապանակում
      If  wMDIClient.VBObject("frmPttel").VBObject("TDBGView").ApproxCount <> 1 Then
             Log.Error"Պայմանագիրն առկա չէ 'Ավանդներ տեղաբաշխված' թղթապանակում"  ,,,ErrorColor
             Exit Sub
      End If
      
      Log.Message "--- Դիտել փաստաթուղթը 'Տպել կարգադրությունը', 'Տպել հիշարար օրդերը', 'Տպել հանձնարարագիրը' նշիչներով ---" ,,, DivideColor 
      ' Մուտք"Գործողությունների դիտում" թղթապանակ
      Set OpenActionsView = New_OpenActionsView()
      With OpenActionsView
            .stDate = "010103"
            .eDate = "010106"
            .dealType = "21"
      End With
      
      Call Fill_OpenActionsView(OpenActionsView)
      
      '"Դիտել փաստաթուղթը մասերով" գործողության կատարում
      Set ViewDocumentParts = New_ViewDocumentParts()
      With ViewDocumentParts
            .wDirect = 1
            .memOrd = 1
            .payOrd = 1
      End With
      
      Call Fill_ViewDocumentParts(ViewDocumentParts)
      
      Path1 = Project.Path &  "Stores\ViewDocumentParts\Actual\DepositsPlacedAct_1.txt"
      Path2 = Project.Path &  "Stores\ViewDocumentParts\Expected\DepositsPlacedExp_1.txt"
      ' Ջնջել DepositsPlacedAct_1.txt ֆայլը
      aqFile.Delete(Path1)
      
      ' Հիշել քաղվածքը
      savePath = Project.Path & "Stores\ViewDocumentParts\Actual\"
      fileName = "DepositsPlacedAct_1"
      Call SaveDoc(savePath, fileName)

      ' Համեմատել երկու txt ֆայլերը
      Call Compare_Files(Path2, Path1, "")
      
      If  wMDIClient.WaitVBObject("FrmSpr", 1000).Exists  Then
            wMDIClient.VBObject("FrmSpr").Close
      Else 
            Log.Error "Դիտել պարամետրը չի բացվել" ,,,ErrorColor
      End If

      Log.Message "--- Դիտել փաստաթուղթը 'Տպել կարգադրությունը' նշիչով ---" ,,, DivideColor 
      '"Դիտել փաստաթուղթը մասերով" գործողության կատարում
      Set ViewDocumentParts = New_ViewDocumentParts()
      With ViewDocumentParts
            .wDirect = 1
            .memOrd = 0
            .payOrd = 0
      End With
      
      Call Fill_ViewDocumentParts(ViewDocumentParts)
      
      Path1 = Project.Path &  "Stores\ViewDocumentParts\Actual\DepositsPlacedAct_2.txt"
      Path2 = Project.Path &  "Stores\ViewDocumentParts\Expected\DepositsPlacedExp_2.txt"
      ' Ջնջել DepositsPlacedAct_2.txt ֆայլը
      aqFile.Delete(Path1)
      
      ' Հիշել քաղվածքը
      savePath = Project.Path & "Stores\ViewDocumentParts\Actual\"
      fileName = "DepositsPlacedAct_2"
      Call SaveDoc(savePath, fileName)

      ' Համեմատել երկու txt ֆայլերը
      Call Compare_Files(Path2, Path1, "")
      
      If  wMDIClient.WaitVBObject("FrmSpr", 1000).Exists  Then
            wMDIClient.VBObject("FrmSpr").Close
      Else 
            Log.Error "Դիտել պարամետրը չի բացվել" ,,,ErrorColor
      End If
      
      Log.Message "--- Դիտել փաստաթուղթը 'Տպել հիշարար օրդերը' նշիչով ---" ,,, DivideColor 
      '"Դիտել փաստաթուղթը մասերով" գործողության կատարում
      Set ViewDocumentParts = New_ViewDocumentParts()
      With ViewDocumentParts
            .wDirect = 0
            .memOrd = 1
            .payOrd = 0
      End With
      
      Call Fill_ViewDocumentParts(ViewDocumentParts)
      
      Path1 = Project.Path &  "Stores\ViewDocumentParts\Actual\DepositsPlacedAct_3.txt"
      Path2 = Project.Path &  "Stores\ViewDocumentParts\Expected\DepositsPlacedExp_3.txt"
      ' Ջնջել DepositsPlacedAct_3.txt ֆայլը
      aqFile.Delete(Path1)
      
      ' Հիշել քաղվածքը
      savePath = Project.Path & "Stores\ViewDocumentParts\Actual\"
      fileName = "DepositsPlacedAct_3"
      Call SaveDoc(savePath, fileName)

      ' Համեմատել երկու txt ֆայլերը
      Call Compare_Files(Path2, Path1, "")
      
      If  wMDIClient.WaitVBObject("FrmSpr", 1000).Exists  Then
            wMDIClient.VBObject("FrmSpr").Close
      Else 
            Log.Error "Դիտել պարամետրը չի բացվել" ,,,ErrorColor
      End If
      
      Log.Message "--- Դիտել փաստաթուղթը 'Տպել հանձնարարագիրը' նշիչով ---" ,,, DivideColor 
      '"Դիտել փաստաթուղթը մասերով" գործողության կատարում
      Set ViewDocumentParts = New_ViewDocumentParts()
      With ViewDocumentParts
            .wDirect = 0
            .memOrd = 0
            .payOrd = 1
      End With
      
      Call Fill_ViewDocumentParts(ViewDocumentParts)
      
      Path1 = Project.Path &  "Stores\ViewDocumentParts\Actual\DepositsPlacedAct_4.txt"
      Path2 = Project.Path &  "Stores\ViewDocumentParts\Expected\DepositsPlacedExp_4.txt"
      ' Ջնջել DepositsPlacedAct_4.txt ֆայլը
      aqFile.Delete(Path1)
      
      ' Հիշել քաղվածքը
      savePath = Project.Path & "Stores\ViewDocumentParts\Actual\"
      fileName = "DepositsPlacedAct_4"
      Call SaveDoc(savePath, fileName)

      ' Համեմատել երկու txt ֆայլերը
      Call Compare_Files(Path2, Path1, "")
      
      If  wMDIClient.WaitVBObject("FrmSpr", 1000).Exists  Then
            wMDIClient.VBObject("FrmSpr").Close
      Else 
            Log.Error "Դիտել պարամետրը չի բացվել" ,,,ErrorColor
      End If
      
      'Փակում է ընթացիկ պատուհանը
      BuiltIn.Delay(2000)
      Call wMainForm.MainMenu.Click(c_Windows)
      Call wMainForm.PopupMenu.Click(c_ClAllWindows)
      
      
      '--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      Log.Message "---  Ավանդներ ներգրավված ---" ,,, DivideColor 
      Call wTreeView.DblClickItem("|ºÝÃ³Ñ³Ù³Ï³ñ·»ñ (§ÐÌ¦)|ä³ÛÙ³Ý³·ñ»ñ|Ü»ñ·ñ³íí³Í ÙÇçáóÝ»ñ|²í³Ý¹Ý»ñ (Ý»ñ·ñ³íí³Í)|ä³ÛÙ³Ý³·ñ»ñ")
      
      Set ContractsFilter = New_ContractsFilter()
      ContractsFilter.AgreementN = "A-001084"
      ContractsFilter.AgreementLevel = "1"
      
      Call Fill_ContractsFilter(ContractsFilter)
      
      ' Ստուգում որ պայամանագիրն առկա է թղթապանակում
      If  wMDIClient.VBObject("frmPttel").VBObject("TDBGView").ApproxCount <> 1 Then
             Log.Error"Պայմանագիրն առկա չէ 'Ավանդներ ներգրավված' թղթապանակում" ,,,ErrorColor
             Exit Sub
      End If
      
      Log.Message "--- Դիտել փաստաթուղթը 'Տպել կարգադրությունը', 'Տպել հիշարար օրդերը', 'Տպել հանձնարարագիրը' նշիչներով ---" ,,, DivideColor 
      
      ' Մուտք"Գործողությունների դիտում" թղթապանակ
      Set OpenActionsView = New_OpenActionsView()
      With OpenActionsView
            .stDate = "010606"
            .eDate = "010606"
            .dealType = "1"
      End With
      
      Call Fill_OpenActionsView(OpenActionsView)
      
      '"Դիտել փաստաթուղթը մասերով" գործողության կատարում
      Set ViewDocumentParts = New_ViewDocumentParts()
      With ViewDocumentParts
            .wDirect = 1
            .memOrd = 1
            .payOrd = 1
      End With
      
      Call Fill_ViewDocumentParts(ViewDocumentParts)
      
      Path1 = Project.Path &  "Stores\ViewDocumentParts\Actual\DepositsInvolvAct_1.txt"
      Path2 = Project.Path &  "Stores\ViewDocumentParts\Expected\DepositsInvolvExp_1.txt"
      ' Ջնջել DepositsInvolvAct_1.txt ֆայլը
      aqFile.Delete(Path1)
      
      ' Հիշել քաղվածքը
      savePath = Project.Path & "Stores\ViewDocumentParts\Actual\"
      fileName = "DepositsInvolvAct_1"
      Call SaveDoc(savePath, fileName)

      ' Համեմատել երկու txt ֆայլերը
      Call Compare_Files(Path2, Path1, "")
      
      If  wMDIClient.WaitVBObject("FrmSpr", 1000).Exists  Then
            wMDIClient.VBObject("FrmSpr").Close
      Else 
            Log.Error "Դիտել պարամետրը չի բացվել" ,,,ErrorColor
      End If

      Log.Message "--- Դիտել փաստաթուղթը 'Տպել կարգադրությունը' նշիչով ---" ,,, DivideColor 
      '"Դիտել փաստաթուղթը մասերով" գործողության կատարում
      Set ViewDocumentParts = New_ViewDocumentParts()
      With ViewDocumentParts
            .wDirect = 1
            .memOrd = 0
            .payOrd = 0
      End With
      
      Call Fill_ViewDocumentParts(ViewDocumentParts)
      
      Path1 = Project.Path &  "Stores\ViewDocumentParts\Actual\DepositsInvolvAct_2.txt"
      Path2 = Project.Path &  "Stores\ViewDocumentParts\Expected\DepositsInvolvExp_2.txt"
      ' Ջնջել DepositsInvolvAct_2.txt ֆայլը
      aqFile.Delete(Path1)
      
      ' Հիշել քաղվածքը
      savePath = Project.Path & "Stores\ViewDocumentParts\Actual\"
      fileName = "DepositsInvolvAct_2"
      Call SaveDoc(savePath, fileName)

      ' Համեմատել երկու txt ֆայլերը
      Call Compare_Files(Path2, Path1, "")
      
      If  wMDIClient.WaitVBObject("FrmSpr", 1000).Exists  Then
            wMDIClient.VBObject("FrmSpr").Close
      Else 
            Log.Error "Դիտել պարամետրը չի բացվել" ,,,ErrorColor
      End If
       
      Log.Message "--- Դիտել փաստաթուղթը 'Տպել հիշարար օրդերը' նշիչով ---" ,,, DivideColor 
      '"Դիտել փաստաթուղթը մասերով" գործողության կատարում
      Set ViewDocumentParts = New_ViewDocumentParts()
      With ViewDocumentParts
            .wDirect = 0
            .memOrd = 1
            .payOrd = 0
      End With
      
      Call Fill_ViewDocumentParts(ViewDocumentParts)
      
      Path1 = Project.Path &  "Stores\ViewDocumentParts\Actual\DepositsInvolvAct_3.txt"
      Path2 = Project.Path &  "Stores\ViewDocumentParts\Expected\DepositsInvolvExp_3.txt"
      ' Ջնջել DepositsInvolvAct_3.txt ֆայլը
      aqFile.Delete(Path1)
      
      ' Հիշել քաղվածքը
      savePath = Project.Path & "Stores\ViewDocumentParts\Actual\"
      fileName = "DepositsInvolvAct_3"
      Call SaveDoc(savePath, fileName)

      ' Համեմատել երկու txt ֆայլերը
      Call Compare_Files(Path2, Path1, "")
      
      If  wMDIClient.WaitVBObject("FrmSpr", 1000).Exists  Then
            wMDIClient.VBObject("FrmSpr").Close
      Else 
            Log.Error "Դիտել պարամետրը չի բացվել" ,,,ErrorColor
      End If

      Log.Message "--- Դիտել փաստաթուղթը 'Տպել հանձնարարագիրը' նշիչով ---" ,,, DivideColor 
      '"Դիտել փաստաթուղթը մասերով" գործողության կատարում
      Set ViewDocumentParts = New_ViewDocumentParts()
      With ViewDocumentParts
            .wDirect = 0
            .memOrd = 0
            .payOrd = 1
      End With
      
      Call Fill_ViewDocumentParts(ViewDocumentParts)
      
      Path1 = Project.Path &  "Stores\ViewDocumentParts\Actual\DepositsInvolvAct_4.txt"
      Path2 = Project.Path &  "Stores\ViewDocumentParts\Expected\DepositsInvolvExp_4.txt"
      ' Ջնջել DepositsInvolvAct_4.txt ֆայլը
      aqFile.Delete(Path1)
      
      ' Հիշել քաղվածքը
      savePath = Project.Path & "Stores\ViewDocumentParts\Actual\"
      fileName = "DepositsInvolvAct_4"
      Call SaveDoc(savePath, fileName)

      ' Համեմատել երկու txt ֆայլերը
      Call Compare_Files(Path2, Path1, "")
      
      If  wMDIClient.WaitVBObject("FrmSpr", 1000).Exists  Then
            wMDIClient.VBObject("FrmSpr").Close
      Else 
            Log.Error "Դիտել պարամետրը չի բացվել" ,,,ErrorColor
      End If
      
      'Փակում է ընթացիկ պատուհանը
      BuiltIn.Delay(2000)
      Call wMainForm.MainMenu.Click(c_Windows)
      Call wMainForm.PopupMenu.Click(c_ClAllWindows)
      
      ' Փակել ծրագիրը
      Call Close_AsBank()   
      
End Sub


' Մուտք"Գործողությունների դիտում" թղթապանակ
Class OpenActionsView
        Public stDate
        Public eDate
        Public dealType
        
        Private Sub Class_Initialize
              stDate = ""
              eDate = ""
              dealType = ""
        End Sub
End Class

Function New_OpenActionsView()
    Set New_OpenActionsView = NEW OpenActionsView      
End Function

' Մուտք"Գործողությունների դիտում" թղթապանակ
Sub Fill_OpenActionsView(OpenActionsView)

      ' Կատարել Գործողություններ/Գործողությունների դիտում գործողությունը
      Call wMainForm.MainMenu.Click(c_AllActions) 
      Call wMainForm.PopupMenu.Click(c_OpersView)
      
      If Sys.Process("Asbank").WaitVBObject("frmAsUstPar", 2000).Exists Then
            
            ' "Ժամանակահատվածի սկիզբ" դաշտի լրացում
            Call Rekvizit_Fill("Dialog", 1, "General", "START", "^A[Del]"  & OpenActionsView.stDate)
            ' "Ժամանակահատվածի ավարտ" դաշտի լրացում
            Call Rekvizit_Fill("Dialog", 1, "General", "END", "^A[Del]"  & OpenActionsView.eDate)
            ' "Գործողության տեսակ" դաշտի լրացում
            Call Rekvizit_Fill("Dialog", 1, "General", "DEALTYPE", "^A[Del]"  & OpenActionsView.dealType)
            ' Սեղմել "Կատարել" կոճակը
            Call ClickCmdButton(2, "Î³ï³ñ»É")
            BuiltIn.Delay(2000)
            
      Else 
            Log.Error"Գործողությունների դիտում դիալոգը չի բացվել" ,,,ErrorColor
      End If
      
End Sub


'"Դիտել փաստաթուղթը մասերով" գործողության կատարում
Class ViewDocumentParts
        Public wDirect
        Public memOrd
        Public payOrd
        
        Private Sub Class_Initialize
              wDirect = 0
              memOrd = 0
              payOrd = 0
        End Sub
End Class

Function New_ViewDocumentParts()
    Set New_ViewDocumentParts = NEW ViewDocumentParts      
End Function


'"Դիտել փաստաթուղթը մասերով" գործողության կատարում
Sub Fill_ViewDocumentParts(ViewDocParts)

        ' Կատարել Գործողություններ/Դիտել փաստաթուղթը մասերով
        Call wMainForm.MainMenu.Click(c_AllActions) 
        Call wMainForm.PopupMenu.Click(c_PrintDocParts)
            
        If Sys.Process("Asbank").WaitVBObject("frmAsUstPar", 2000).Exists Then
            
              ' "Տպել կարգադրություն" չեքբոքսի լրացում
              Call Rekvizit_Fill("Dialog", 1, "CheckBox", "DIRECT", ViewDocParts.wDirect)
              ' "Տպել հիշարար օրդեր" չեքբոքսի լրացում
              Call Rekvizit_Fill("Dialog", 1, "CheckBox", "MEMORD", ViewDocParts.memOrd)
              ' "Տպել հանձնարարագիր" չեքբոքսի լրացում
              Call Rekvizit_Fill("Dialog", 1, "CheckBox", "PAYORD", ViewDocParts.payOrd)
              ' Սեղմել "Կատարել" կոճակը
              Call ClickCmdButton(2, "Î³ï³ñ»É")
                  
              If Not wMDIClient.WaitVBObject("FrmSpr",3000).Exists Then
                    Log.Error"Հաշվետվությունը չի բացվել" ,,,ErrorColor
              End If
                  
        Else
              Log.Error" 'Դիտել փաստաթուղթը' դիալոգը չի բացվել" ,,,ErrorColor
        End If
            
End Sub