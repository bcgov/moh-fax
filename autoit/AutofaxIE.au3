;	version 1.0
;	by Jan and Sorin
;	July 09, 2021

#include <IE.au3>
#include <Array.au3>
#include <PrintPdf.au3>
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

;	end script

Func HandleTableRow($oRow)
    ; Get ref to PDF link in row.
    Local $oPdfLink = _IETagNameGetCollection($oRow, 'a', 0) 
    
    ; Click PDF link.
    _IEAction($oPdfLink, 'click') 
    
    ; Wait for PDF to load in frame and focus.
    Sleep(3000)
    
    ; Sent "CTRL+P" to print 
    Send('^p') 

    ; Get ref to input element containing the fax number.
    $oFaxInput = _IETagNameGetCollection($oRow, 'input', 0) 

    ; Call PrintPdf()
    Local $printSuccess = PrintPdf(StringReplace(StringReplace(StringReplace($oFaxInput.value,"+",""),"(",""),")",""))

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

