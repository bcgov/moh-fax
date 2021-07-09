#include <MsgBoxConstants.au3>

;
; TODO: Function must handle:
;   - selection of printer from print dialog,
;   - entering of fax number on accuroute prompt,
;   - clicking of send
; 
; If fax is successful, function must return 
;   - true - the script will mark the case as faxed afterwards 
;   - false - the script will proceed with the next row
;
Func PrintPdf($faxNumber)
    Local $oPrintDialog = WinWaitActive('Print')

    ; TODO: Select printer from list and click print on the dialog.

    WinWaitClose('Print') ; Wait for the browser print dialog to close.

    ; TODO: Get handle for Accuroute window. 
    ; e.g., Local $oAccuroutePrompt = WinWaitActive('TITLE OF ACCUROUTE WINDOW')

    ; TODO: Enter $faxNumber on "To" field.
    
    ; TODO: Click "Send" on page.
    
    WinWaitClose('TITLE OF ACCUROUTE WINDOW') ; Wait for Accuroute prompt to close when "send" is clicked.
    
    Local $success = InputBox("Fax successful?", "Yes/No") ; TODO: To be removed once accuroute printing is implemented.
    Return $success == "yes"
EndFunc ;==> PrintPdf
