Option Explicit
'USEUNIT Library_Common
'USEUNIT Online_PaySys_Library
'USEUNIT Constants

'------------------------------------------------------------------------------
' Ð³ßíÇ ù³Õí³ÍùÇ ¹ÇïáõÙ : üáõÝÏóÇ³Ý Éñ³óÝáõÙ ¿ Ð³ßíÇ ù³Õí³Íù ýÇÉïñÁ :
'ì»ñ³¹ñÓÝáõÙ ¿ True , »Ã» ù³Õí³ÍùÁ ³éÏ³ ¿ , ¨ False` Ñ³Ï³é³Ï ¹»åùáõÙ :
'------------------------------------------------------------------------------
'startDate - Ä³Ù³Ý³Ï³Ñ³ïí³ÍÇ ëÏÇ½µ ¹³ßïÇ ³ñÅ»ù
'endDate - Ä³Ù³Ý³Ï³Ñ³ïí³ÍÇ í»ñç ¹³ßïÇ ³ñÅ»ù
'template - Ñ³ßíÇ Ó¨³ÝÙáõß
Function View_ACC_Statment (startDate, endDate, template)
    Dim isExist : isExist = False
    
    BuiltIn.Delay(3000)
    Call wMainForm.MainMenu.Click(c_AllActions)
    Call wMainForm.PopupMenu.Click(c_Statement)
    BuiltIn.Delay(1000)
    
    'Ä³Ù³Ý³Ï³Ñ³ïí³ÍÇ ëÏÇ½µ ¹³ßïÇ Éñ³óáõÙ
    Call Rekvizit_Fill("Dialog", 1, "General", "SDATE", startDate)
    'Ä³Ù³Ý³Ï³Ñ³ïí³ÍÇ í»ñç ¹³ßïÇ Éñ³óáõÙ
    Call Rekvizit_Fill("Dialog", 1, "General", "EDATE", endDate)
    'òáõÛó ï³É ·áñÍáÕáõÃÛáõÝÝ»ñÁ ËÙµ³íáñí³Í ¹³ßïÇ Éñ³óáõÙ
    Call Rekvizit_Fill("Dialog", 1, "CheckBox", "SHOWOVERDRAFTOPERS", 1)    
    'òáõÛó ï³É å³ÛÙ³ÝÝ»ñÇ ÷á÷áËáõÃÛáõÝÝ»ñÁ ¹³ßïÇ Éñ³óáõÙ
    Call Rekvizit_Fill("Dialog", 1, "CheckBox", "SHDRAFT", 1)
    'òáõÛó ï³É ÃÕÃ³ÏóáÕÇ ³Ýí³ÝáõÙÁ ¹³ßïÇ Éñ³óáõÙ
    Call Rekvizit_Fill("Dialog", 1, "CheckBox", "SHCORNAME", 0)
    'Èñ³óÝáõÙ ¿ Ð³ßíÇ Ó¨³ÝÙáõß ¹³ßïÁ
    Call Rekvizit_Fill("Dialog", 1, "General", "ACCTMP", template)
    'Î³ï³ñ»É Ïá×³ÏÇ ë»ÕÙáõÙ
    Call ClickCmdButton(2, "Î³ï³ñ»É")
    
    'ø³Õí³ÍùÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ
    If template = "" then
        If wMDIClient.vbObject("FrmSpr").Exists Then
            isExist = True
        End If
        View_ACC_Statment = isExist
    Else    
        View_ACC_Statment = True
    End If
End Function

'------------------------------------------------------------------------------
' ø³ñïÇ ù³Õí³ÍùÇ ¹ÇïáõÙ : üáõÝÏóÇ³Ý Éñ³óÝáõÙ ¿ ø³ñïÇ ù³Õí³Íù ýÇÉïñÁ :
'ì»ñ³¹ñÓÝáõÙ ¿ True , »Ã» ù³Õí³ÍùÁ ³éÏ³ ¿ , ¨ False` Ñ³Ï³é³Ï ¹»åùáõÙ :
'------------------------------------------------------------------------------
'startDate - Ä³Ù³Ý³Ï³Ñ³ïí³ÍÇ ëÏÇ½µ ¹³ßïÇ ³ñÅ»ù
'endDate - Ä³Ù³Ý³Ï³Ñ³ïí³ÍÇ í»ñç ¹³ßïÇ ³ñÅ»ù
'template - ø³ñïÇ Ó¨³ÝÙáõß
Function View_Card_Statment (startDate, endDate, template)
    Dim isExist : isExist = False
    
    BuiltIn.Delay(3000)
    Call wMainForm.MainMenu.Click(c_AllActions)
    Call wMainForm.PopupMenu.Click(c_CardStatement)
    BuiltIn.Delay(1000)
    'Ä³Ù³Ý³Ï³Ñ³ïí³ÍÇ ëÏÇ½µ ¹³ßïÇ Éñ³óáõÙ
    Call Rekvizit_Fill("Dialog", 1, "General", "SDATE", startDate)
    'Ä³Ù³Ý³Ï³Ñ³ïí³ÍÇ í»ñç ¹³ßïÇ Éñ³óáõÙ
    Call Rekvizit_Fill("Dialog", 1, "General", "EDATE", endDate)
    'òáõÛó ï³É åñáó. ãáõÕ³ñÏíáÕ ·áñÍ. ÝßÇãÇ Ñ³ÝáõÙ
    Call Rekvizit_Fill("Dialog", 1, "CheckBox", "SHOWOVERDRAFTOPERS", 0)
    'òáõÛó ï³É Ï³ï³ñáÕÇ ÝßÇãÇ Ñ³ÝáõÙ
    Call Rekvizit_Fill("Dialog", 1, "CheckBox", "SHOWSIGNATURE", 0)
    'ø³ñïÇ Ó¨³ÝÙáõßÇ ¹³ßïÇ Éñ³óáõÙ
    Call Rekvizit_Fill("Dialog", 1, "General", "CRDTMP", template)
    'Î³ï³ñ»É Ïá×³ÏÇ ë»ÕÙáõÙ
    Call ClickCmdButton(2, "Î³ï³ñ»É")
    
    BuiltIn.Delay(1000)
    If template = "" then 
        'ø³Õí³ÍùÇ ³éÏ³ÛáõÃÛ³Ý ëïáõ·áõÙ
        If wMDIClient.vbObject("FrmSpr").Exists Then
            isExist = True
        End If
        View_Card_Statment = isExist
    Else    
        View_Card_Statment = True
    End If
End Function

'------------------------------------------------------------------------------
'Ð³ßíÇíÝ»ñÇ ýÇÉïñÇ Éñ³óáõÙ :
'------------------------------------------------------------------------------
'accNumber - Ð³ßíÇ ß³µÉáÝ ¹³ßïÇ ³ñÅ»ù
Sub Go_To_Acc(accNumber)
  Call wTreeView.DblClickItem("|²¹ÙÇÝÇëïñ³ïáñÇ ²Þî|î»Õ»Ï³ïáõÝ»ñ|Ð³ßÇíÝ»ñ")
  Call Rekvizit_Fill("Dialog", 1, "General", "ACCMASK", accNumber)
  Call ClickCmdButton(2, "Î³ï³ñ»É")    
End Sub