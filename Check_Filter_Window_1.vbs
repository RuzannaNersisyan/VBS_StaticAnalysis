'USEUNIT Library_Common
'USEUNIT Library_Colour
'USEUNIT OLAP_Library
'USEUNIT Mortgage_Library
'USEUNIT SWIFT_International_Payorder_Library
'USEUNIT Constants
'USEUNIT Deposit_Contract_Library
Option Explicit

'Test Case Id - 162251

Sub Check_Filter_Window_1()
  
    Dim sDATE,fDATE
    Dim Path1, Path2
    Dim ConditionField,wTabStrip,Deposit_Attract,FilterWin
    Dim SaveAsWin,FilterLibWin,i, SortArr(1)
    SortArr(0) = "fKEY"

    'Համակարգ մուտք գործել ARMSOFT օգտագործողով
    sDATE = "20030101"
    fDATE = "20260101"
    Call Initialize_AsBank("bank_Report", sDATE, fDATE)
    Login("ARMSOFT")

    Call ChangeWorkspace(c_Deposits)
    
    Set Deposit_Attract = New_Deposit_Attracted()
        Deposit_Attract.ShowAccounts = 1

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''--- Ստուգել ֆիլտրել գործողությունը թղթապանակում --''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Ստուգել ֆիլտրել գործողությունը թղթապանակում --" ,,, DivideColor  
    
    Call GoToDeposit_Attracted(Deposit_Attract) 
    wMainForm.Keys("^f")
    BuiltIn.Delay(500)
    wMDIClient.VBObject("frmPttel").Keys("NA3118" & "[Enter]")
    
    Call CheckPttel_RowCount("frmPttel", 1)
    Path1 = Project.Path & "Stores\FilterCheck\Actual\Check_FilterActual_1.txt"
    Path2 = Project.Path & "Stores\FilterCheck\Expected\Check_FilterExpected_1.txt"
    
    'Արտահանել և Ð³Ù»Ù³ï»É »ñÏáõ TXT ý³ÛÉ»ñ
    Call ExportToTXTFromPttel("frmPttel",Path1)
    Call Compare_Files(Path2, Path1, "")
    Call Close_Pttel("frmPttel")
    
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''--- Ստուգել ֆիլտրել Պատուհանի Պայման <Tab>-ի գործողությունը --'''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Ստուգել ֆիլտրել Պատուհանի Պայման <Tab>-ի գործողությունը --" ,,, DivideColor  
    
    Call GoToDeposit_Attracted(Deposit_Attract) 
    
    BuiltIn.Delay(2000)
    'Բացել Ֆիլտրել պատուհանը
    wMainForm.Keys("^h")
           
    BuiltIn.Delay(1000)
    Set FilterWin = p1.WaitVBObject("frmPttelFilter", 2000)
    'Ստուգել Ֆիլտրել պատուհանը բացվել է թե ոչ
    If FilterWin.Exists Then
    Set ConditionField = FilterWin.VBObject("FilterControl").VBObject("TDBGridFilter")
        
        ConditionField.Row = 0
        ConditionField.Col = 4
        ConditionField.Keys("NA6166")
        
        'Սեղմել "Կատարել" կոճակը
        FilterWin.VBObject("Command5").Click       
    Else
        Log.Error "Ֆիլտրել պատուհանը չի բացվել",,,ErrorColor   
    End if
    
    Call CheckPttel_RowCount("frmPttel", 1)
    Path1 = Project.Path & "Stores\FilterCheck\Actual\Check_FilterActual_2.txt"
    Path2 = Project.Path & "Stores\FilterCheck\Expected\Check_FilterExpected_2.txt"
    
    'Արտահանել և Ð³Ù»Ù³ï»É »ñÏáõ TXT ý³ÛÉ»ñ
    Call ExportToTXTFromPttel("frmPttel",Path1)
    Call Compare_Files(Path2, Path1, "")
    Call Close_Pttel("frmPttel")

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''-- Ստուգել ֆիլտրել պատուհանի Սյուներ և Պայման <Tab>-երի գործողությունները  --''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Ստուգել ֆիլտրել պատուհանի Սյուներ և Պայման <Tab>-երի գործողությունները (1)--" ,,, DivideColor  

    Call GoToDeposit_Attracted(Deposit_Attract) 
    
    BuiltIn.Delay(2000)
    'Բացել Ֆիլտրել պատուհանը
    Call wMainForm.MainMenu.Click(c_Opers)
    Call wMainForm.PopupMenu.Click( c_Folder & "|" & c_Filter)
           
    BuiltIn.Delay(1000)
    Set FilterWin = p1.WaitVBObject("frmPttelFilter", 2000)
    'Ստուգել Ֆիլտրել պատուհանը բացվել է թե ոչ
    If FilterWin.Exists Then
        
    Set ConditionField = FilterWin.VBObject("FilterControl").VBObject("TDBGridFilter")
        
        ConditionField.Row = 0
        ConditionField.Col = 2
        ConditionField.Window("Edit", "", 1).Keys("A[Down][Down][Down][Down]")
        ConditionField.Row = 0
        ConditionField.Col = 3
        ConditionField.Window("Edit", "", 1).Keys("A[Down][Down][Down][Down][Down]")
        ConditionField.Row = 0
        ConditionField.Col = 4
        ConditionField.Keys("200000")
    
        'Անցում 2րդ տաբ
        Set wTabStrip = FilterWin.VBObject("TabStrip1")
			  wTabStrip.SelectedItem = wTabStrip.Tabs(2)
    
        FilterWin.VBObject("Frame3").VBObject("List4").Keys("[Down]")
        FilterWin.VBObject("Command4").Click   
        FilterWin.VBObject("Frame3").VBObject("List4").Keys("[Down]")
        FilterWin.VBObject("Command4").Click   
        FilterWin.VBObject("Command2").Click   
        FilterWin.VBObject("Command4").Click   
        
        If FilterWin.VBObject("Frame4").VBObject("List1").wItemCount <> "2" Or FilterWin.VBObject("Frame3").VBObject("List4").wItemCount <> "16" Then
            Log.Error "Սյան սկզբնական ցուցակ տեղափոխության սխալ!",,,ErrorColor   
        End If
        
        Log.Message "-- Ստուգել Վերականգնել կոճակի աշխատանքը --" ,,, DivideColor  
        'Սեղմել "Վերականգնել" կոճակը
        FilterWin.VBObject("Command8").Click  
        BuiltIn.Delay(1000)
        
        If FilterWin.VBObject("Frame4").VBObject("List1").wItemCount <> "0" Or FilterWin.VBObject("Frame3").VBObject("List4").wItemCount <> "18" Then
            Log.Error "Վերականգնել գործողության սխալ!",,,ErrorColor   
        End If
        
        FilterWin.VBObject("Frame3").VBObject("List4").Keys("[Down]")
        FilterWin.VBObject("Command4").Click   
        FilterWin.VBObject("Frame3").VBObject("List4").Keys("[Down]")
        FilterWin.VBObject("Command4").Click   
        
        If FilterWin.VBObject("Frame4").VBObject("List1").wItemCount <> 2 Or FilterWin.VBObject("Frame3").VBObject("List4").wItemCount <> 16 Then
            Log.Error "Սյան սկզբնական ցուցակ տեղափոխության սխալ!",,,ErrorColor   
        End If
                
        'Սեղմել "Կատարել" կոճակը
        FilterWin.VBObject("Command5").Click       
    Else
        Log.Error "Ֆիլտրել պատուհանը չի բացվել",,,ErrorColor   
    End if
    
    Call ColumnSorting(SortArr, 1, "frmPttel")
    Call CheckPttel_RowCount("frmPttel", 11)
    Path1 = Project.Path & "Stores\FilterCheck\Actual\Check_FilterActual_3.txt"
    Path2 = Project.Path & "Stores\FilterCheck\Expected\Check_FilterExpected_3.txt"
    
    'Արտահանել և Ð³Ù»Ù³ï»É »ñÏáõ TXT ý³ÛÉ»ñ
    Call ExportToTXTFromPttel("frmPttel",Path1)
    Call Compare_Files(Path2, Path1, "")
    Call Close_Pttel("frmPttel")
    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''-- Ստուգել ֆիլտրել պատուհանի Սյուներ և Պայման <Tab>-երի գործողությունները  --''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Ստուգել ֆիլտրել պատուհանի Սյուներ և Պայման <Tab>-երի գործողությունները (2)--" ,,, DivideColor   

    Call GoToDeposit_Attracted(Deposit_Attract) 
    
    BuiltIn.Delay(2000)
    'Բացել Ֆիլտրել պատուհանը
    Call wMainForm.MainMenu.Click(c_Opers)
    Call wMainForm.PopupMenu.Click( c_Folder & "|" & c_Filter)
           
    BuiltIn.Delay(1000)
    Set FilterWin = p1.WaitVBObject("frmPttelFilter", 2000)
    'Ստուգել Ֆիլտրել պատուհանը բացվել է թե ոչ
    If FilterWin.Exists Then
        
    Set ConditionField = FilterWin.VBObject("FilterControl").VBObject("TDBGridFilter")
        
        'Առաջին տող
        ConditionField.Row = 0
        ConditionField.Col = 2
        ConditionField.Window("Edit", "", 1).Keys("A[Down][Down][Down][Down]")
        ConditionField.Row = 0
        ConditionField.Col = 3
        ConditionField.Window("Edit", "", 1).Keys("A[Down][Down][Down][Down][Down]")
        ConditionField.Row = 0
        ConditionField.Col = 4
        ConditionField.Keys("5000")

        'երկրորդ տող
        ConditionField.Row = 1
        ConditionField.Col = 2
        ConditionField.Window("Edit", "", 1).Keys("A[Down][Down]")
        ConditionField.Row = 1
        ConditionField.Col = 3
        ConditionField.Window("Edit", "", 1).Keys("A[Down][Down][Down][Down]")
        ConditionField.Row = 1
        ConditionField.Col = 4
        ConditionField.Keys("000")
    
        'Անցում 2րդ տաբ
        Set wTabStrip = FilterWin.VBObject("TabStrip1")
			  wTabStrip.SelectedItem = wTabStrip.Tabs(2)
        
        FilterWin.VBObject("Frame3").Keys("[Down][Down][Down]")
        FilterWin.VBObject("Frame3").VBObject("Command9").Click
        FilterWin.VBObject("Frame3").VBObject("Command7").Click
        FilterWin.VBObject("Frame3").VBObject("Command7").Click
        FilterWin.VBObject("Frame3").VBObject("Command6").Click
        FilterWin.VBObject("Command4").Click  
        FilterWin.VBObject("Command4").Click  

        'Սեղմել "Հիշել որպես" կոճակը
        FilterWin.VBObject("Command11").Click   
        
        Set SaveAsWin = p1.WaitVBObject("frmPttelFilterSaveAs",1000)
        If SaveAsWin.Exists Then
            'Լրացնել Ֆիլտրի անվանում դաշտը
            SaveAsWin.VBObject("Frame1").VBObject("Combo1").Window("Edit", "", 1).Keys("CheckColumn")
            'Սեղմել "Հիշել" կոճակը
            SaveAsWin.VBObject("Command12").Click
            'Սեղմել "Կատարել" կոճակը
            FilterWin.VBObject("Command5").Click
        Else  
            Log.Error "Հիշել որպես պատուհանը չի բացվել",,,ErrorColor  
        End If
           
    Else
        Log.Error "Ֆիլտրել պատուհանը չի բացվել",,,ErrorColor   
    End if
    
    BuiltIn.Delay(1000)
    Call wMainForm.MainMenu.Click(c_Views & "|" & "CheckColumn")
    BuiltIn.Delay(3000)
    Call ColumnSorting(SortArr, 1, "frmPttel")
    
    Call CheckPttel_RowCount("frmPttel", 15)
    Path1 = Project.Path & "Stores\FilterCheck\Actual\Check_FilterActual_4.txt"
    Path2 = Project.Path & "Stores\FilterCheck\Expected\Check_FilterExpected_4.txt"
    
    'Արտահանել և Ð³Ù»Ù³ï»É »ñÏáõ TXT ý³ÛÉ»ñ
    Call ExportToTXTFromPttel("frmPttel",Path1)
    Call Compare_Files(Path2, Path1, "")
    Call Close_Pttel("frmPttel")
    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''-- Ստուգել բեռնել գործողությունը Դիտելու ձևի ֆիլտրերի գրադարանից --''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Ստուգել բեռնել գործողությունը Դիտելու ձևի ֆիլտրերի գրադարանից --" ,,, DivideColor  
    
    Call GoToDeposit_Attracted(Deposit_Attract) 
    
    BuiltIn.Delay(2000)
    'Բացել "Դիտելու ձևի ֆիլտրերի գրադարան" պատուհանը
    Call wMainForm.MainMenu.Click(c_Opers)
    Call wMainForm.PopupMenu.Click( c_Folder & "|" & c_FilterLib)
    
    Set FilterLibWin = P1.WaitVBObject("FrmPttBibl",1000)
    
    If FilterLibWin.Exists Then
        For i = 1 To FilterLibWin.VBObject("List1").ListCount
            If Trim(FilterLibWin.VBObject("List1").Text) = "CheckColumn" Then
                FilterLibWin.VBObject("cmdLoad").Click
                Exit For
            Else
                FilterLibWin.VBObject("List1").Keys("[Down]")
                BuiltIn.Delay(500)
            End If
        Next
    
        FilterLibWin.VBObject("cmdCancel").Click
        BuiltIn.Delay(500)
    Else
        Log.Error "Դիտելու ձևի ֆիլտրերի գրադարան պատուհանը չի բացվել",,,ErrorColor   
    End if
    
    Call ColumnSorting(SortArr, 1, "frmPttel")
    Call CheckPttel_RowCount("frmPttel", 15)
    Path1 = Project.Path & "Stores\FilterCheck\Actual\Check_FilterLibActual.txt"
    Path2 = Project.Path & "Stores\FilterCheck\Expected\Check_FilterLibExpected.txt"
    
    'Արտահանել և Ð³Ù»Ù³ï»É »ñÏáõ TXT ý³ÛÉ»ñ
    Call ExportToTXTFromPttel("frmPttel",Path1)
    Call Compare_Files(Path2, Path1, "")
    Call Close_Pttel("frmPttel")
    
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''-- Դիտելու ձևի ֆիլտրերի գրադարանից հեռացնել ստեղծված դիտելու ձևը --''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    Log.Message "-- Դիտելու ձևի ֆիլտրերի գրադարանից հեռացնել ստեղծված դիտելու ձևը --" ,,, DivideColor  
    
    Call GoToDeposit_Attracted(Deposit_Attract) 
    
    BuiltIn.Delay(2000)
    'Բացել "Դիտելու ձևի ֆիլտրերի գրադարան" պատուհանը
    Call wMainForm.MainMenu.Click(c_Opers)
    Call wMainForm.PopupMenu.Click( c_Folder & "|" & c_FilterLib)
    
    Set FilterLibWin = P1.WaitVBObject("FrmPttBibl",1000)
    
    For i = 1 To FilterLibWin.VBObject("List1").ListCount
        If Trim(FilterLibWin.VBObject("List1").Text) = "CheckColumn" Then
            FilterLibWin.VBObject("cmdDelete").Click
            Exit For
        Else
            FilterLibWin.VBObject("List1").Keys("[Down]")
            BuiltIn.Delay(500)
        End If
    Next
    FilterLibWin.Close
    Call Close_Pttel("frmPttel")
    
    Call Close_AsBank()   
End Sub    