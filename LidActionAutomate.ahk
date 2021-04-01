;Event to capture
OnMessage(0x219, "LidActionChanger")

LidActionChanger(wParam)
{
    SysGet, ScreenCount, MonitorCount
    
    ;Lid Options:
    ; 1 -> Sleep Mode
    ; 0 -> Do Nothing Mode
    Mode = -1
    if (ScreenCount == 1){
        Mode = 1
    }
    else if (ScreenCount >= 2){
        Mode = 0
    }
    else {
        MsgBox Design Error, force exit
        return 
    }

    if (wParam = 7) {
        ; Set the new lid action 
        RunWait, powercfg -setdcvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 %Mode% ,,Hide
        RunWait, powercfg -setacvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 %Mode% ,,Hide
        RunWait, powercfg -SetActive SCHEME_CURRENT ,,Hide
    } Else {
        MsgBox Something Went Wrong. probably disconnected.
    }
    TrayTip Monitor Change Detected, Lid action changed to %Mode%!

}
