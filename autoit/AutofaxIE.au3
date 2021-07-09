;	version 1.0
;	by Jan and Sorin
;	July 09, 2021

#include <IE.au3>
#include <Array.au3>
#include <PrintPdf.au3>
#include <WinAPISys.au3>

;	set AccuRoute Printer as default
_WinAPI_SetDefaultPrinter ( "AccuRoute Printer" )

Local $oIE = _IECreate("https://bchealth--fax--c.visualforce.com/apex/autofax")

If @error Then MsgBox(0,"","Problem creating the fax list")

AutoItSetOption("WinTitleMatchMode",2)	;	match string anywhere in the title of window

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
    Local $oPdfLink = _IETagNameGetCollection($oRow, 'a', 0) ; Get ref to PDF link in row.
    _IEAction($oPdfLink, 'click') ; Click PDF link.
    Sleep(3000) ; Wait for PDF to load in frame and focus.
    Send('^p') ; Sent "CTRL+P" to print

    $oFaxInput = _IETagNameGetCollection($oRow, 'input', 0) ; Get ref to input element containing the fax number.
    Local $printSuccess = PrintPdf(StringReplace(StringReplace(StringReplace($oFaxInput.value,"+",""),"(",""),")",""))

    If $printSuccess Then
        $oMarkButton = _IETagNameGetCollection($oRow, 'button', 0) ; Get ref to "Mark Faxed" button.
        ClickMarkButton($oMarkButton)
    EndIf
EndFunc ;==> HandleTableRow

Func HandlePdfLink($oPdfLink, $faxNumber)

EndFunc ;==> PrintPdf

Func ClickMarkButton($oMarkButton)
    _IEAction($oMarkButton, 'click')
    Sleep(2000)
EndFunc ;==> ClickMarkButton
