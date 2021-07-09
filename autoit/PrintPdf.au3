
;	version 1.0
;	by Jan and Sorin
;	July 09, 2021

AutoItSetOption("WinTitleMatchMode",2)	;	match string anywhere in the title of window

Func PrintPdf($faxNumber)
    Local $oPrintDialog = WinWaitActive('Print')
    Sleep(200)
    Send("{ENTER}")	;	we are using the default printer, which was set in the main script to the AccuRoute Printer

	WinWaitActive("Create Distribution")
	Sleep(200)

; Enter $faxNumber on "To" field.
	Send($faxNumber)
	Send("{TAB 3}")	; enter TAB three times to advance to the correct field for next entry
	Send("Notification From Ministry of Health - Special Authority Program")	;	add text to Subject line

; Click "Send" on page.
	ClickLink("Send")
	Sleep(1000)

;    Close the tab
    Send("^w")
    WinWaitClose("Create Distribution") ; Wait for Accuroute prompt to close when "send" is clicked.
	Sleep(200)

;    return success sending the fax (for now we expect that fax will be sent successfully)
    Return "yes"
EndFunc ;==> PrintPdf



Func ClickLink($buttonText)

    Local $accurouteWindowTitle = 'Create Distribution' ; Title of the accuroute window (substring is fine).

    Local $oAccurouteWindow = _IEAttach($accurouteWindowTitle, "title")

    Local $oLinks = _IELinkGetCollection($oAccurouteWindow)

    For $oLink In $oLinks

        Local $sLinkText = _IEPropertyGet($oLink, "innerText")

        If StringInStr($sLinkText, $buttonText) Then

            _IEAction($oLink, "click")

            ExitLoop

        EndIf

    Next

EndFunc ;==> ClickLink
