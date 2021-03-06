Option Explicit
'USEUNIT Library_Common
'USEUNIT Payment_Order_ConfirmPhases_Library
'USEUNIT Subsystems_SQL_Library
'USEUNIT Online_PaySys_Library
'USEUNIT BankMail_Library
'USEUNIT BankMail_Library
'USEUNIT Library_CheckDB
'USEUNIT Constants
'USEUNIT RemoteService_Library
'USEUNIT Akreditiv_Library

' Test Case ID 165076 

Sub PayOrder_From_CBMessages_ToBankMail_DB_Test_New()
  
      Dim paramName, paramValue, confInput, confPath
      Dim  todayD, cliCode, summa, accDB, payer, accCR, receiver, aim, cur, HTType, docNum, system, messType 
      Dim workEnvName, workEnv, stRekName, endRekName, wStatus, isnRekName
      Dim param, wDocDate, fISN, childISN, wChildISN
      Dim queryString, sqlValue, colNum, sql_isEqual
      Dim colN, action, doNum, doActio, mDIClient, frmASDocForm 
      Dim direction, dirName, wState, frmPttel
      Dim status, sBody, bodyValue, wDateTime, state
      Dim startDate, fDate
     
      startDate = "20030101"
      fDate = "20250101"
      Call Initialize_AsBank("bank", startDate, fDate)
               
      ' Մուտք համակարգ ARMSOFT օգտագործողով
      Call Create_Connection()
      Login("ARMSOFT")
      
      ' Պարամետրերի արժեքների ճշգրտում   
      paramName = "BMUSEDB"
      paramValue = "1"
      Call  SetParameter(paramName, paramValue)
      
      paramName = "BMDBSERVER"
      paramValue = "qasql2017"
      Call  SetParameter(paramName, paramValue)
      
      paramName = "BMDBNAME"
      paramValue = "BankMail_Testing"
      Call  SetParameter(paramName, paramValue)
      
      ' Կարգավորումների ներմուծում
      confPath = "X:\Testing\Order confirm phases\NoVerify.txt"
      confInput = Input_Config(confPath)
      If Not confInput Then
          Log.Error("Կարգավորումները չեն ներմուծվել")
         Exit Sub
      End If
      
      ' Տվյալների ներմուծում բազա
      todayD = aqConvert.DateTimeToFormatStr(aqDateTime.Today,"%d/%m/%y") 
      cliCode =  "00000233"
      summa = "999.00"
      accDB = "7770077782963313"
      payer = "ØÇÑñ"
      accCR = "103004200012"
      receiver = "²ñ³Ù³½¹"
      aim = "î³Ý í³ñÓ"
      cur = "000"
      HTType = "100"
      
      Call Randomize()
      docNum = Int(1000 * Rnd)
      Log.Message("Փաստաթղթի համար՝ " & docNum)
    
      ' Այսօրվա տվյալների ջնջում
      queryString =  " Delete from CB_MESSAGES where FORMAT (fDATE, 'dd/MM/yy') = '" & Trim(todayD) & "' "  
      Call Execute_SLQ_Query(queryString)
      
      queryString = " Insert into CB_MESSAGES (fSYSTEM, fSTATE, fCLIENT, fMSGTYPE,fBODY,fSIGN1,fSIGN2) " _
                            & " values (2              " _
                            & "  , 8                   " _
                            & "  , '" & cliCode & "'  " _
                            & "  , 'CBPayOrd'   " _
                            & "  , char(13)+char(10)" _
                            & "      + 'PAYDATE:" & aqConvert.DateTimeToFormatStr(aqDateTime.Today,"%Y%m%d") & "' + char(13)+char(10) " _
                            & "      + 'SUMMA:" & summa & "'        + char(13)+char(10) " _
                            & "      + 'PAYERACC:" & accDB & "'    + char(13)+char(10) " _
                            & "      + 'PAYER:" & payer & "'        + char(13)+char(10) " _
                            & "      + 'RECEIVERACC:" & accCR & "' + char(13)+char(10) " _
                            & "      + 'RECEIVER:" & receiver & "' + char(13)+char(10) " _
                            & "      + 'DOCNUM:" & docNum & "'     + char(13)+char(10) " _       
                            & "      + 'AIM:" & aim & "'            + char(13)+char(10) " _ 
                            & "      + 'CURR:AMD'                   + char(13)+char(10) " _
                            & " , Cast('0x308206EA06092A864886F70D010702A08206DB308206D7020101310B300906052B0E03021A0500300B06092A864886F70D010701A08205AD308205A930820491A003020102020A12F7787F00000000000D300D06092A864886F70D0101050500305131123010060A0992268993F22C6401191602616D31173015060A0992268993F22C640119160761726D736F6674312230200603550403131941726D656E69616E20536F66747761726520526F6F74204341301E170D3034313030383035313634305A170D3035313030383035323634305A303531173015060355040A130E37373730302D3030303030323333311A301806035504031311416E61686974205368617368696B79616E30819F300D06092A864886F70D010101050003818D0030818902818100E41B109B1E9A7F5582AD3631831CC6E9EDB68408598439E53245D815198B5AF472CCC5D8F3FFA2413FAE18FF159B75A7415C5D98B7FC603BD0BAB2E4759A4F5D5CCD410893A92274939C789DC31E5D4B7C3B7FD962124AAAC92A06463F93E547DE89CDE85345054EF66DA2E203A1A36C4F9FE82C190CCC8E1E453B9DB79EEEE30203010001A38203213082031D300E0603551D0F0101FF0404030204F0304406092A864886F70D01090F04373035300E06082A864886F70D030202020080300E06082A864886F70D030402020080300706052B0E030207300A06082A864886F70D030730130603551D25040C300A06082B06010505070302301D0603551D0E0416041441998D5321E77A40E297EB511F5766692E856532301F0603551D230418301680149B946FBBC5063F443D23CFCAF2A313113D10C32E3082012D0603551D1F04820124308201203082011CA0820118A08201148681C66C6461703A2F2F2F434E3D41726D656E69616E253230536F667477617265253230526F6F7425323043412C434E3D7465726D696E616C2C434E3D4344502C434E3D5075626C69632532304B657925323053657276696365732C434E3D53657276696365732C434E3D436F6E66696775726174696F6E2C44433D61726D736F66742C44433D616D3F63657274696669636174655265766F636174696F6E4C6973743F626173653F6F626A656374436C6173733D63524C446973747269627574696F6E506F696E748649687474703A2F2F7465726D696E616C2E61726D736F66742E616D2F43657274456E726F6C6C2F41726D656E69616E253230536F667477617265253230526F6F7425323043412E63726C3082013D06082B060105050701010482012F3082012B3081BD06082B060105050730028681B06C6461703A2F2F2F434E3D41726D656E69616E253230536F667477617265253230526F6F7425323043412C434E3D4149412C434E3D5075626C69632532304B657925323053657276696365732C434E3D53657276696365732C434E3D436F6E66696775726174696F6E2C44433D61726D736F66742C44433D616D3F634143657274696669636174653F626173653F6F626A656374436C6173733D63657274696669636174696F6E417574686F72697479306906082B06010505073002865D687474703A2F2F7465726D696E616C2E61726D736F66742E616D2F43657274456E726F6C6C2F7465726D696E616C2E61726D736F66742E616D5F41726D656E69616E253230536F667477617265253230526F6F7425323043412E637274300D06092A864886F70D0101050500038201010056948359D9E1BB72F164B0159F8D89CB3AB3BA26E739F3F4AEAADCCE6DCF4FC8373ED5BC1C945686D7E7639ADF3FA0C81E3FDE71888D1F42235BA8F18DBAA73CDA0E140DD1A4B5C1366E7B44E32392A68B0BFCBBE08AF8958F66871171BFFCBE8947B0633CF09CEB4EBC94D59A0DB05F36063C6C0ADA541068BF5F30C71693B2BD0082ADD8211172E5AF9C40C12669D6ABD56EA8869D442861D52FA68EC619CDA3F63F97955906496D77FF0D7FEC264D738D660BE9DE7A827D0BE754B85AA9ECB092E0BFD498BD19E8872B6012264F4EBF9B88FFBBB812E50EBB9B03A376D325C8152D15BDBCB638AB5FF191B01D8BCFBB1884D8D3079D64E67991207C72B1563182010530820101020101305F305131123010060A0992268993F22C6401191602616D31173015060A0992268993F22C640119160761726D736F6674312230200603550403131941726D656E69616E20536F66747761726520526F6F74204341020A12F7787F00000000000D300906052B0E03021A0500300D06092A864886F70D010101050004818042A0B20247725B8580C78FCEA1412900999AF1473146B92F93E7CB917194D14744888222B3D732471EC430BF8B301C094D6E15E6C2841072ECA56169217F296C877826CE4EFE1E23C40D2C74CC9791255104743CAC2298CE174ABBCAE48619FB04F36FED9539A015663D3B90660660DC543167EA31FB421B20AB8FA4EAC75CD7' AS VARBINARY(MAX))" _
                            & " , Cast('0x308206EA06092A864886F70D010702A08206DB308206D7020101310B300906052B0E03021A0500300B06092A864886F70D010701A08205AD308205A930820491A003020102020A12F7787F00000000000D300D06092A864886F70D0101050500305131123010060A0992268993F22C6401191602616D31173015060A0992268993F22C640119160761726D736F6674312230200603550403131941726D656E69616E20536F66747761726520526F6F74204341301E170D3034313030383035313634305A170D3035313030383035323634305A303531173015060355040A130E37373730302D3030303030323333311A301806035504031311416E61686974205368617368696B79616E30819F300D06092A864886F70D010101050003818D0030818902818100E41B109B1E9A7F5582AD3631831CC6E9EDB68408598439E53245D815198B5AF472CCC5D8F3FFA2413FAE18FF159B75A7415C5D98B7FC603BD0BAB2E4759A4F5D5CCD410893A92274939C789DC31E5D4B7C3B7FD962124AAAC92A06463F93E547DE89CDE85345054EF66DA2E203A1A36C4F9FE82C190CCC8E1E453B9DB79EEEE30203010001A38203213082031D300E0603551D0F0101FF0404030204F0304406092A864886F70D01090F04373035300E06082A864886F70D030202020080300E06082A864886F70D030402020080300706052B0E030207300A06082A864886F70D030730130603551D25040C300A06082B06010505070302301D0603551D0E0416041441998D5321E77A40E297EB511F5766692E856532301F0603551D230418301680149B946FBBC5063F443D23CFCAF2A313113D10C32E3082012D0603551D1F04820124308201203082011CA0820118A08201148681C66C6461703A2F2F2F434E3D41726D656E69616E253230536F667477617265253230526F6F7425323043412C434E3D7465726D696E616C2C434E3D4344502C434E3D5075626C69632532304B657925323053657276696365732C434E3D53657276696365732C434E3D436F6E66696775726174696F6E2C44433D61726D736F66742C44433D616D3F63657274696669636174655265766F636174696F6E4C6973743F626173653F6F626A656374436C6173733D63524C446973747269627574696F6E506F696E748649687474703A2F2F7465726D696E616C2E61726D736F66742E616D2F43657274456E726F6C6C2F41726D656E69616E253230536F667477617265253230526F6F7425323043412E63726C3082013D06082B060105050701010482012F3082012B3081BD06082B060105050730028681B06C6461703A2F2F2F434E3D41726D656E69616E253230536F667477617265253230526F6F7425323043412C434E3D4149412C434E3D5075626C69632532304B657925323053657276696365732C434E3D53657276696365732C434E3D436F6E66696775726174696F6E2C44433D61726D736F66742C44433D616D3F634143657274696669636174653F626173653F6F626A656374436C6173733D63657274696669636174696F6E417574686F72697479306906082B06010505073002865D687474703A2F2F7465726D696E616C2E61726D736F66742E616D2F43657274456E726F6C6C2F7465726D696E616C2E61726D736F66742E616D5F41726D656E69616E253230536F667477617265253230526F6F7425323043412E637274300D06092A864886F70D0101050500038201010056948359D9E1BB72F164B0159F8D89CB3AB3BA26E739F3F4AEAADCCE6DCF4FC8373ED5BC1C945686D7E7639ADF3FA0C81E3FDE71888D1F42235BA8F18DBAA73CDA0E140DD1A4B5C1366E7B44E32392A68B0BFCBBE08AF8958F66871171BFFCBE8947B0633CF09CEB4EBC94D59A0DB05F36063C6C0ADA541068BF5F30C71693B2BD0082ADD8211172E5AF9C40C12669D6ABD56EA8869D442861D52FA68EC619CDA3F63F97955906496D77FF0D7FEC264D738D660BE9DE7A827D0BE754B85AA9ECB092E0BFD498BD19E8872B6012264F4EBF9B88FFBBB812E50EBB9B03A376D325C8152D15BDBCB638AB5FF191B01D8BCFBB1884D8D3079D64E67991207C72B1563182010530820101020101305F305131123010060A0992268993F22C6401191602616D31173015060A0992268993F22C640119160761726D736F6674312230200603550403131941726D656E69616E20536F66747761726520526F6F74204341020A12F7787F00000000000D300906052B0E03021A0500300D06092A864886F70D010101050004818042A0B20247725B8580C78FCEA1412900999AF1473146B92F93E7CB917194D14744888222B3D732471EC430BF8B301C094D6E15E6C2841072ECA56169217F296C877826CE4EFE1E23C40D2C74CC9791255104743CAC2298CE174ABBCAE48619FB04F36FED9539A015663D3B90660660DC543167EA31FB421B20AB8FA4EAC75CD7' AS VARBINARY(MAX)))"
        
      Call Execute_SLQ_Query(queryString)
      
      ' Մուտք Հաճախորդների սպասարկում և դրամարկղ(Ընդլայնված)
      Call ChangeWorkspace(c_RemoteSyss)
      
      ' Մուտք աշխատանքային փաստաթղթեր      
      system = "2"
      messType = "PayOrd"
      direction = "|Ð»é³Ñ³ñ Ñ³Ù³Ï³ñ·»ñ|Øß³ÏÙ³Ý »ÝÃ³Ï³ Ùáõïù³ÛÇÝ Ñ³Õáñ¹³·ñáõÃÛáõÝÝ»ñ(ÀÝ¹Ñ³Ýáõñ)"
      dirName = "Մշակման ենթակա մուտքային հաղորդագրություններ (Ընդհանուր) "
      wState =  "êïáñ³·ñáõÃÛáõÝÝ»ñÁ ×Çßï »Ý"
      state = CheckContractRemoteSystems(direction, todayD, system, cliCode, messType, summa, dirName, wState) 
      If Not state Then
            Log.Error("Սխալ՝ Մշակման ենթակա մուտքային հաղորդագրություններ (Ընդհանուր) թղթապանակ մուտք գործելիս")
            Exit Sub
      End If

      Call VerifyPaymentOrder(todayD, fISN, wDocDate)   
      Log.Message(fISN)
      
      ' Մուտք Գլխավոր հաշվապահի ԱՇՏ   
      Call ChangeWorkspace(c_ChiefAcc)
      
      ' Մուտք Հաշվառված Վճարային փաստաթղթեր թղթապանակ
      workEnvName = "|¶ÉË³íáñ Ñ³ßí³å³ÑÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|Ð³ßí³éí³Í í×³ñ³ÛÇÝ ÷³ëï³ÃÕÃ»ñ"
      workEnv = "Հաշվառված վճարային փաստաթղթեր"
      isnRekName = "DOCISN"
      wStatus = True
      stRekName = "PERN"
      endRekName = "PERK"
      state = AccessFolder(workEnvName, workEnv, stRekName, todayD, endRekName, todayD, wStatus, isnRekName, fISN)
      If Not state Then
            Log.Error("Սխալ՝ Հաշվառված վճարային փաստաթղթեր թղթապանակում")
            Exit Sub
      End If
      
     ' SQL ստուգում CB_MESSAGES աղյուսակում
      queryString = " Select fSTATE from CB_MESSAGES where fISN =" & fISN 
      sqlValue = 9
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 

      BuiltIn.Delay(1000)
      wMDIClient.VBObject("frmPttel").Close
      
      ' Մուտք Արտաքին փոխանցումների ԱՇՏ  
      Call ChangeWorkspace(c_ExternalTransfers)
      
      ' Մուտք Ուղարկվող հաձնարարագրեր թղթապանակ
      workEnvName = "|²ñï³ùÇÝ ÷áË³ÝóáõÙÝ»ñÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|àõÕ³ñÏíáÕ Ñ³ÝÓÝ³ñ³ñ³·ñ»ñ|àõÕ³ñÏíáÕ Ñ³ÝÓÝ³ñ³ñ³·ñ»ñ"
      workEnv = "Ուղարկվող հաձնարարագրեր"
      wStatus = False
      state = AccessFolder(workEnvName, workEnv, stRekName, todayD, endRekName, todayD, wStatus, isnRekName, fISN)
      If Not state Then
            Log.Error("Սխալ՝ Ուղարկվող հաձնարարագրեր թղթապանակում")
            Exit Sub
      End If
      
      ' Վճարման հանձնարարագիրն ուղարկել BankMail
      colN = 2
      action = c_SendToBM
      doNum = 5
      doActio = "²Ûá"
      state = ConfirmContractDoc(colN, docNum, action, doNum, doActio)
      If Not state Then
            Log.Message("Վճարման հանձնարարագրեր փաստաթուղթը չի գտնվել BankMail ուղարկելու համար ")
            Exit Sub
      End If
      
      BuiltIn.Delay(1000)
      wMDIClient.VBObject("frmPttel").Close
      
      ' Մուտք Ուղարկված BankMail թղթապանակ
      workEnvName = "|²ñï³ùÇÝ ÷áË³ÝóáõÙÝ»ñÇ ²Þî|ÂÕÃ³å³Ý³ÏÝ»ñ|àõÕ³ñÏí³Í  Ñ³ÝÓÝ³ñ³ñ³·ñ»ñ|àõÕ³ñÏí³Í BankMail"
      workEnv = "Ուղարկված BankMail"
      state = AccessFolder(workEnvName, workEnv, stRekName, todayD, endRekName, todayD, wStatus, isnRekName, fISN)
      If Not state Then
            Log.Error("Սխալ՝ Ուղարկված BankMail թղթապանակում")
            Exit Sub
      End If
      
      ' Ստուգում որ պայմանագիրն առկա է Ուղարկված Bank Mail թղթապանակում
      colN = 1
      state = CheckContractDoc(colN, docNum)
      If Not state Then
            Log.Error("Փաստաթուղթն առկա չէ ուղարկված BankMial թղթապանակում")
            Exit Sub
      End If
      
      Log.Message("SQL Check 1") 
     ' SQL ստուգում 18
     queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                              " AND fTYPE = '01' AND fCUR = '000' AND fCURSUM = '999.00' AND fOP = 'TRF' " & _ 
                              " AND fDBCR = 'C' AND fSUID = '77' AND fSUM = '999.00' and fBASEBRANCH = '00' AND fBASEDEPART = '1'"
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 

      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                              " AND fTYPE = '01' AND fCUR = '000'  AND fCURSUM = '999.00' AND fOP = 'TRF' " & _ 
                              " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '999.00' and fBASEBRANCH = '00' AND fBASEDEPART = '1'"
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                               " AND fTYPE = '01' AND fCUR = '000'   AND fCURSUM = '8.00' AND fOP = 'FEE' " & _ 
                               " AND fDBCR = 'D' AND fSUID = '77' AND fSUM = '8.00' and fBASEBRANCH = '00' AND fBASEDEPART = '1'"
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
              
      queryString = " SELECT COUNT(*) FROM HI WHERE fBASE= " & fISN & _
                              " AND fTYPE = '01' AND fCUR = '000' AND fCURSUM = '8.00' AND fOP = 'FEE' " & _ 
                               " AND fDBCR = 'C' AND fSUID = '77' AND fSUM = '8.00' and fBASEBRANCH = '00' AND fBASEDEPART = '1'"
      sqlValue = 1
      colNum = 0
      sql_isEqual = CheckDB_Value(queryString, sqlValue, colNum)
      If Not sql_isEqual Then
        Log.Error("Querystring = " & queryString & ":  Expected result = " & sqlValue)
      End If 
             
      BuiltIn.Delay(1000)
      wMDIClient.VBObject("frmPttel").Close
              
      ' Մուտք BANKMAIL օգտագործողով
      Login("BANKMAIL")
       
      ' Մուտք ուղարկվող փոխանցումներ  
      Call ChangeWorkspace(c_BM)
      
      ' Դիտել Վճարման հանձնարարագրի պայմանագիրն 
      status = False
      Call WiewPayOrderFromTransferSent(todayD, fISN, childISN, status, wDateTime)
      If childISN = "" Then
            Log.Error("Վճարման հանձնարարագրի պայմանագիրն առկա չէ Ուղարկվող թղթղպանակում")
            Exit Sub  
      End If 
      
      ' Ծնող զավակ կապի ստուգում  
      queryString = "SELECT fISN FROM DOCP WHERE fISN = " & childISN & " AND fPARENTISN = " & fISN
      wChildISN = Get_Query_Result(queryString)
      Log.Message("Զավակ փաստաթղթի ISN` " &childISN)
      If  Trim(wChildISN) <> Trim(childISN) Then
            Log.Error("Ծնող զավակ կապի բացակայություն")
      End If
      
      BuiltIn.Delay(1000)
      wMDIClient.VBObject("frmPttel").Close
      
      ' Մուտք ուղարկված փոխանցումներ  
      Call wTreeView.DblClickItem("|BankMail ²Þî|Ð³Õáñ¹³·ñáõÃÛáõÝÝ»ñÇ áõÕ³ñÏáõÙ|²íïáÙ³ï áõÕ³ñÏáõÙ BankMail")
      BuiltIn.Delay(2000)
      p1.VBObject("frmBMAutoSnd").VBObject("cmdSnd").Click
      BuiltIn.Delay(2000)
      p1.VBObject("frmBMAutoSnd").Close
      
      ' Մուտք ուղարկված փոխանցումներ թղթապանակ
      workEnvName = "|BankMail ²Þî|öáË³ÝóáõÙÝ»ñ|àõÕ³ñÏí³Í ÷áË³ÝóáõÙÝ»ñ"
      workEnv = "Ուղարկված փոխանցումներ"
      state = AccessFolder(workEnvName, workEnv, stRekName, todayD, endRekName, todayD, wStatus, isnRekName, fISN)
      If Not state Then
            Log.Error("Սխալ՝ ուղարկված փոխանցումներ թղթապանակում")
            Exit Sub
      End If
      
      ' Ստուգում որ պայմանագիրն առկա է Ուղարկված հաղորդագրություններ թղթապանակում
      colN = 3
      state = CheckContractDoc(colN, fISN)
      If Not state Then
            Log.Error("Փաստաթուղթն առկա չէ ուղարկված հաղորդագրություններ թղթապանակում")
            Exit Sub
      End If
      
      ' Body-ի ձևավորում ստուգման համար    
      sBody = ":20:" & fISN & vbCRLF _
                  & ":32A:" & Replace(wDocDate,"/","") & "AMD999," & vbCRLF _
                  & ":50A:" & Replace(accDB, "/", "") & vbCRLF _ 
                  & payer & vbCRLF _
                  & ":59:" & Replace(accCR, "/", "") & vbCRLF _ 
                  & receiver & vbCRLF _
                  & ":70A:" & aim    
          
      ' Տվյալների ստուգում BankMail_Testing.dbo.bmInterface աղյուսակում
      queryString = " SELECT Body FROM [qasql2017].BankMail_Testing.dbo.bmInterface WHERE AS_ISN = " & wChildISN
      bodyValue = Get_Query_Result(queryString)
      If  Trim(sBody) <> Trim(bodyValue) Then
            Log.Error("Փաստաթղթի տվյալները BankMail-ում չեն համապատասխանում dictionary-ով փոխանցվող տվյալների հետ")
      End If
      
      BuiltIn.Delay(1000)
      wMDIClient.VBObject("frmPttel").Close
      
      ' Փակել ծրագիրը
      Call Close_AsBank()
End Sub