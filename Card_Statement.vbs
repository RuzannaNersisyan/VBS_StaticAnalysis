'USEUNIT Library_Common
'USEUNIT Acc_Statements_Library
'USEUNIT Payment_Except_Library   
'USEUNIT Constants

'Test case ID 165658

Sub Card_Statement_Test()
    Dim fDATE, startDATE , cpath,  cardNumber , sDate, eDate, savePath, fName
    Dim docExist, fIdent , fileName1 , fileName2,template
    
    fDATE = "20250101"
    startDATE = "20030101"
    cardNumber = "9051190200005849"
    sDate = "01/01/07"
    eDate = "01/01/08"
    savePath = "\\host2\Sys\Testing\Statement_Check_140414\Card_Statement_Actual\"
    fName = "1.txt"
    fileName1 = "\\host2\Sys\Testing\Statement_Check_140414\Card_Statement_Actual\1.txt"
    fileName2 = "\\host2\Sys\Testing\Statement_Check_140414\Card_Statement_Expected\card_Expected.txt"
    template = ""
    
    'Test StartUp 
    Call Initialize_AsBank("bank", startDATE, fDATE) 
    Call ChangeWorkspace(c_CardsSV)
    
    'äÉ³ëïÇÏ ù³ñïÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ "äÉ³ëïÇÏ ù³ñï»ñ " ÃÕÃ³å³Ý³ÏáõÙ 
    docExist = Check_CardExist_In_Carsds_Folder(cardNumber)
    If Not docExist Then
        Log.Error("Card with number " & cardNumber & " isn't exist in cards folder")
        Exit Sub
    End If                      
    
    'ø³Õí³ÍùÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ 
    docExist = View_Card_Statment (sDate, eDate,template)
    If Not docExist Then
        Log.Error("Document statement doesn't exist")
        Exit Sub
    End If
    
    'ø³Õí³ÍùÇ å³ÑáõÙ
    Call SaveDoc(savePath, fName)
    
    'êå³ëíáÕ ñ ³éÏ³ ù³Õí³ÍùÝ»ñÇ Ñ³Ù»Ù³ïáõÙ 
    BuiltIn.Delay(3000)
    fIdent = Compare_Files(fileName1, fileName2, "")
    If Not fIdent Then
        Log.Error(fileName1 & "and" & fileName2 &" :Files are not identical" )
    End If
    
    'Test CleanUp 
    Call Close_AsBank()
End Sub