;	version 1.0
;	by Jan and Sorin
;	July 09, 2021

#include <IE.au3>
#include <Array.au3>
#include <WinAPISys.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>

;	Match string anywhere in the title of window
AutoItSetOption("WinTitleMatchMode",2)	

;	Set AccuRoute Printer as default
_WinAPI_SetDefaultPrinter ( "AccuRoute Printer" )

; Choose a salesforce environment where script executes.
Local $urlDomain = ChooseEnvironment()
If $urlDomain = "" Then Exit

Local $oIE = _IECreate($urlDomain & "apex/autofax", 1, 1, 1, 1)
If @error Then MsgBox(0,"","Problem creating the fax list")

WinWaitActive("Autofax")
Sleep(200)
WinActivate("Autofax")

Local $oCaseList = _IEGetObjById($oIE, 'caseList') ; Get reference to the HTML table.
Local $oRows = _IETagNameGetCollection($oCaseList, 'tr') ; Get list of refs to each table row.

For $oRow In $oRows
    WinActivate("Autofax")
	HandleTableRow($oRow)
Next

WinClose("Autofax")

; End Script

Func HandleTableRow($oRow)
    ; Get ref to input element containing the fax number.
    $oFaxInput = _IETagNameGetCollection($oRow, 'input', 0) 
    $faxNumber = StringReplace(StringReplace(StringReplace($oFaxInput.value,"+",""),"(",""),")","")

    ; Get ref to PDF link in row and click
    Local $oPdfLink = _IETagNameGetCollection($oRow, 'a', 0) 
    _IEAction($oPdfLink, 'click') 
    
    Sleep(3000)
    
    ; Sent "CTRL+P" to print 
    Send('^p') 

    ; Call PrintPdf()
    Local $printSuccess = PrintPdf($faxNumber)

    If $printSuccess Then
        ; Get ref to "Mark Faxed" button and click it.
        $oMarkButton = _IETagNameGetCollection($oRow, 'button', 0) 
        ClickMarkButton($oMarkButton)
    EndIf
EndFunc ;==> HandleTableRow

Func ClickMarkButton($oMarkButton)
    _IEAction($oMarkButton, 'click')
    Sleep(2000)
EndFunc ;==> ClickMarkButton

Func ChooseEnvironment()
    Local $hGUI = GUICreate("Choose environment", 280, 80)

    ; Create button controls.
    Local $btnDev = GUICtrlCreateButton("Run on Dev", 10, 30)
    Local $btnStaging = GUICtrlCreateButton("Run on Staging", 80, 30)
    Local $btnProd = GUICtrlCreateButton("Run on Production", 170, 30)
    
    ; Display the GUI.
    GUISetState(@SW_SHOW, $hGUI)

    Local $urlDomain

    ; Loop until the user exits.
    While 1
        Switch GUIGetMsg()
            Case $btnProd
                $urlDomain = "https://bchealth--c.visualforce.com/"
                ExitLoop

            Case $btnStaging
                $urlDomain = "https://bchealth--staging--c.visualforce.com/"
                ExitLoop

            Case $btnDev
                $urlDomain = "https://bchealth--fax--c.visualforce.com/"
                ExitLoop

            Case $GUI_EVENT_CLOSE
                ExitLoop
        EndSwitch
    WEnd

    ; Delete the previous GUI and all controls.
    GUIDelete($hGUI)

    Return $urlDomain
EndFunc   ;==>ChooseEnvironment


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
