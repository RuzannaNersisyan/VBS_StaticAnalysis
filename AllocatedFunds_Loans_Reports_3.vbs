'USEUNIT Subsystems_SQL_Library
'USEUNIT Library_Common
'USEUNIT Library_Contracts
'USEUNIT Constants
'USEUNIT Library_Colour
'USEUNIT OLAP_Library
'USEUNIT SWIFT_International_Payorder_Library
Option Explicit

'Test case ID 161851
'Test case ID 161859

Dim folderName, sDATE, fDATE, colName(5), param
Dim changes, scales, effectiveParent, effective, bank
Dim actualFile1, actualFile2, actualFile3, actualFile4, actualFile5
Dim expectedFile1, expectedFile2, expectedFile3, expectedFile4, expectedFile5
Dim resultFile1, resultFile2, resultFile3, resultFile4, resultFile5

Sub AllocatedFunds_Loans_Reports_3(rowLimit)
		' ºÝÃ³Ñ³Ù³Ï³ñ·»ñ (§ÐÌ¦)|ä³ÛÙ³Ý³·ñ»ñ|î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|ì³ñÏ»ñ (î»Õ³µ³ßËí³Í)
		Call Test_Initialize()

		' Համակարգ մուտք գործել ARMSOFT օգտագործողով
		Log.Message "Համակարգ մուտք գործել ARMSOFT օգտագործողով", "", pmNormal, DivideColor
  Call Test_StartUp(rowLimit) 
		
		'''''''''''''''''''''''''''''''''''''''''''''''''
		''''''''''îáÏáë³¹ñáõÛùÇ ÷á÷áËáõÃÛáõÝÝ»ñ''''''''''
		
		' Լրացնել Տոկոսադրույքի փոփոխություններ դիալոգային պատուհանը
		Log.Message "Տոկոսադրույքի փոփոխություններ", "", pmNormal, DivideColor
		Call GoTo_AgreementsCommomFilter(folderName, "îáÏáë³¹ñáõÛùÇ ÷á÷áËáõÃÛáõÝÝ»ñ", changes)
		
		if WaitForExecutionProgress() then		
				' êáñï³íáñ»É µ³óí³Í åïï»ÉÁ
				Call columnSorting(colName, 4, "frmPttel")
				' Արտահանել Excel
				Call ExportToExcel("frmPttel", actualFile1)
				' Ստուգել տողերի քանակը
				Call CheckPttel_RowCount("frmPttel", 17219)
				' Համեմատել Excel ֆայլերը
				Call CompareTwoExcelFiles(actualFile1, expectedFile1, resultFile1)
				' ö³Ï»É բոլոր Excel ֆայլերը
				Call CloseAllExcelFiles()
				' ö³Ï»É åïï»ÉÁ
				BuiltIn.Delay(3000) 
		  wMDIClient.VBObject("frmPttel").Close
		else																																	
						Log.Error "Can't open pttel window.", "", pmNormal, ErrorColor
		end if
		
		'''''''''''''''''''''''''''''''''''''''''''''''''
		''îáÏáë³¹ñáõÛùÝ»ñÇ ë³Ý¹Õ³ÏÝ»ñÇ ÷á÷áËáõÃÛáõÝÝ»ñ'''
		
		' Լրացնել Տոկոսադրույքների սանդղակների փոփոխություններ դիալոգային պատուհանը
		Log.Message "Տոկոսադրույքների սանդղակների փոփոխություններ", "", pmNormal, DivideColor
		Call GoTo_AgreementsCommomFilter(folderName, "îáÏáë³¹ñáõÛùÝ»ñÇ ë³Ý¹Õ³ÏÝ»ñÇ ÷á÷áËáõÃÛáõÝÝ»ñ", scales)
		
		if WaitForExecutionProgress() then		
				' Արտահանել, որպես txt ֆայլ
				Call ExportToTXTFromPttel("frmPttel", actualFile2)
				' Ստուգել տողերի քանակը
				Call CheckPttel_RowCount("frmPttel", 1)
				' Համեմատել txt ֆայլերը
				Call Compare_Files(actualFile2, expectedFile2, param)
				' ö³Ï»É åïï»ÉÁ
				BuiltIn.Delay(3000) 
		  wMDIClient.VBObject("frmPttel").Close
		else																																	
						Log.Error "Can't open pttel window.", "", pmNormal, ErrorColor
		end if
		
		'''''''''''''''''''''''''''''''''''''''''''''''''
		''''²ñ¹ÛáõÝ³í»ï\÷³ëï³óÇ ïáÏáë³¹ñáõÛùÝ»ñ (ÌÝáÕ)'''
		
		' Լրացնել Արդյունավետ\փաստացի տոկոսադրույքներ (Ծնող) դիալոգային պատուհանը
		Log.Message "Արդյունավետ\փաստացի տոկոսադրույքներ (Ծնող)", "", pmNormal, DivideColor
		Call GoTo_AgreementsCommomFilter(folderName, "²ñ¹ÛáõÝ³í»ï\÷³ëï³óÇ ïáÏáë³¹ñáõÛùÝ»ñ (ÌÝáÕ)", effectiveParent)
		
		if WaitForExecutionProgress() then		
				' êáñï³íáñ»É µ³óí³Í åïï»ÉÁ
				Call columnSorting(colName, 4, "frmPttel")
				' Արտահանել Excel
				Call ExportToExcel("frmPttel", actualFile3)
				' Ստուգել տողերի քանակը
				Call CheckPttel_RowCount("frmPttel", 17163)
				' Համեմատել Excel ֆայլերը
				Call CompareTwoExcelFiles(actualFile3, expectedFile3, resultFile3)
				' ö³Ï»É բոլոր Excel ֆայլերը
				Call CloseAllExcelFiles()
				' ö³Ï»É åïï»ÉÁ
				BuiltIn.Delay(3000) 
		  wMDIClient.VBObject("frmPttel").Close
		else																																	
						Log.Error "Can't open pttel window.", "", pmNormal, ErrorColor
		end if
		
		'''''''''''''''''''''''''''''''''''''''''''''''''
		'''''''²ñ¹ÛáõÝ³í»ï\÷³ëï³óÇ ïáÏáë³¹ñáõÛùÝ»ñ'''''''
		
		' Լրացնել Արդյունավետ\փաստացի տոկոսադրույքներ դիալոգային պատուհանը
		Log.Message "Արդյունավետ\փաստացի տոկոսադրույքներ", "", pmNormal, DivideColor
		Call GoTo_AgreementsCommomFilter(folderName, "²ñ¹ÛáõÝ³í»ï\÷³ëï³óÇ ïáÏáë³¹ñáõÛùÝ»ñ", effective)
		
		if WaitForExecutionProgress() then		
				' Արտահանել, որպես txt ֆայլ
				Call ExportToTXTFromPttel("frmPttel", actualFile4)
				' Ստուգել տողերի քանակը
				Call CheckPttel_RowCount("frmPttel", 1)
				' Համեմատել txt ֆայլերը
				Call Compare_Files(actualFile4, expectedFile4, param) 
				' ö³Ï»É åïï»ÉÁ
				BuiltIn.Delay(3000)
		  wMDIClient.VBObject("frmPttel").Close
		else																																	
						Log.Error "Can't open pttel window.", "", pmNormal, ErrorColor
		end if
		
		'''''''''''''''''''''''''''''''''''''''''''''''''
		''''''''´³ÝÏÇ ³ñ¹ÛáõÝ³í»ï ïáÏáë³¹ñáõÛùÝ»ñ''''''''
		
		' Լրացնել Բանկ արդյունավետ տոկոսադրույքներ դիալոգային պատուհանը
		Log.Message "Բանկ արդյունավետ տոկոսադրույքներ", "", pmNormal, DivideColor
		Call GoTo_AgreementsCommomFilter(folderName, "´³ÝÏÇ ³ñ¹ÛáõÝ³í»ï ïáÏáë³¹ñáõÛùÝ»ñ", bank)
		
		if WaitForExecutionProgress() then		
				' êáñï³íáñ»É µ³óí³Í åïï»ÉÁ
				Call columnSorting(colName, 4, "frmPttel")
				' Արտահանել Excel
				Call ExportToExcel("frmPttel", actualFile5)
				' Ստուգել տողերի քանակը
				Call CheckPttel_RowCount("frmPttel", 16054)
				' Համեմատել Excel ֆայլերը
				Call CompareTwoExcelFiles(actualFile5, expectedFile5, resultFile5)
				' ö³Ï»É բոլոր Excel ֆայլերը
				Call CloseAllExcelFiles()
				' ö³Ï»É åïï»ÉÁ
				BuiltIn.Delay(3000) 
		  wMDIClient.VBObject("frmPttel").Close
		else																																	
						Log.Error "Can't open pttel window.", "", pmNormal, ErrorColor
		end if
		
		Call Close_AsBank()		
End	Sub

Sub Test_StartUp(rowLimit)
		Call Initialize_AsBank("bank_Report", sDATE, fDATE)
  Login("ARMSOFT")
		Call SaveRAM_RowsLimit(rowLimit)
		Call ChangeWorkspace(c_Subsystems)
End	Sub

Sub Test_Initialize()
		folderName = "|ºÝÃ³Ñ³Ù³Ï³ñ·»ñ (§ÐÌ¦)|ä³ÛÙ³Ý³·ñ»ñ|î»Õ³µ³ßËí³Í ÙÇçáóÝ»ñ|ì³ñÏ»ñ (ï»Õ³µ³ßËí³Í)|¶áñÍáÕáõÃÛáõÝÝ»ñ, ÷á÷áËáõÃÛáõÝÝ»ñ|"
	
		sDATE = "20030101"
		fDATE = "20260101"  
		
		colName(0) = "fKEY"
		colName(3) = "fCOM"
		colName(1) = "fDATE"
		colName(2) = "fSUID"
		
		' îáÏáë³¹ñáõÛùÇ ÷á÷áËáõÃÛáõÝÝ»ñ
		expectedFile1 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest3\Expected\expectedFile1.xlsx"
		' îáÏáë³¹ñáõÛùÝ»ñÇ ë³Ý¹Õ³ÏÝ»ñÇ ÷á÷áËáõÃÛáõÝÝ»ñ
		expectedFile2 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest3\Expected\expectedFile2.txt"
		' ²ñ¹ÛáõÝ³í»ï\÷³ëï³óÇ ïáÏáë³¹ñáõÛùÝ»ñ (ÌÝáÕ)
		expectedFile3 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest3\Expected\expectedFile3.xlsx"
		' ²ñ¹ÛáõÝ³í»ï\÷³ëï³óÇ ïáÏáë³¹ñáõÛùÝ»ñ
		expectedFile4 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest3\Expected\expectedFile4.txt"
		' ´³ÝÏÇ ³ñ¹ÛáõÝ³í»ï ïáÏáë³¹ñáõÛùÝ»ñ
		expectedFile5 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest3\Expected\expectedFile5.xlsx"
	
  ' îáÏáë³¹ñáõÛùÇ ÷á÷áËáõÃÛáõÝÝ»ñ
		actualFile1 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest3\Actual\actualFile1.xlsx"
		' îáÏáë³¹ñáõÛùÝ»ñÇ ë³Ý¹Õ³ÏÝ»ñÇ ÷á÷áËáõÃÛáõÝÝ»ñ
		actualFile2 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest3\Actual\actualFile2.txt"
		' ²ñ¹ÛáõÝ³í»ï\÷³ëï³óÇ ïáÏáë³¹ñáõÛùÝ»ñ (ÌÝáÕ)
		actualFile3 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest3\Actual\actualFile3.xlsx"
		' ²ñ¹ÛáõÝ³í»ï\÷³ëï³óÇ ïáÏáë³¹ñáõÛùÝ»ñ
		actualFile4 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest3\Actual\actualFile4.txt"
		' ´³ÝÏÇ ³ñ¹ÛáõÝ³í»ï ïáÏáë³¹ñáõÛùÝ»ñ
		actualFile5 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest3\Actual\actualFile5.xlsx"
		
  ' îáÏáë³¹ñáõÛùÇ ÷á÷áËáõÃÛáõÝÝ»ñ
		resultFile1 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest3\Result\resultFile1.xlsx"
		' ²ñ¹ÛáõÝ³í»ï\÷³ëï³óÇ ïáÏáë³¹ñáõÛùÝ»ñ (ÌÝáÕ)
		resultFile3 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest3\Result\resultFile3.xlsx"
		' ´³ÝÏÇ ³ñ¹ÛáõÝ³í»ï ïáÏáë³¹ñáõÛùÝ»ñ
		resultFile5 = Project.Path & "Stores\Reports\Subsystems\Allocated Funds\LoansTest3\Result\resultFile5.xlsx"
		
  ' îáÏáë³¹ñáõÛùÇ ÷á÷áËáõÃÛáõÝÝ»ñ
		Set changes = New_AgreementsCommomFilter()
		with changes
				.onlyChangesExists = true
		end with
		
		' îáÏáë³¹ñáõÛùÝ»ñÇ ë³Ý¹Õ³ÏÝ»ñÇ ÷á÷áËáõÃÛáõÝÝ»ñ
		Set scales = New_AgreementsCommomFilter()
		with scales
				.startDate = "13/02/13"
				.endDate = "13/02/13"
				.agreeN = "TV16450"
				.performer = "127"
				.note = "002"
				.note2 = "06"
				.agreeOffice = "P01"
				.agreeSection = "05"
				.accessType = "C11"
				.onlyChangesExists = true
		end with
		
		' ²ñ¹ÛáõÝ³í»ï\÷³ëï³óÇ ïáÏáë³¹ñáõÛùÝ»ñ (ÌÝáÕ)
		Set effectiveParent = New_AgreementsCommomFilter()
		with effectiveParent
				.onlyChangesExists = true
		end with
		
		' ²ñ¹ÛáõÝ³í»ï\÷³ëï³óÇ ïáÏáë³¹ñáõÛùÝ»ñ
		Set effective = New_AgreementsCommomFilter()
		with effective
				.startDate = "12/12/13"
				.endDate = "12/12/13"
				.agreeN = "TV11044"
				.performer = "13"
				.note = "04"
				.agreeOffice = "P04"
				.agreeSection = "05"
				.accessType = "C11"
				.onlyChangesExists = true
				.onlyChanges = 1
		end with
		
		' ´³ÝÏÇ ³ñ¹ÛáõÝ³í»ï ïáÏáë³¹ñáõÛùÝ»ñ
		Set bank = New_AgreementsCommomFilter()
		with bank
				.onlyChangesExists = true
		end with
End Sub