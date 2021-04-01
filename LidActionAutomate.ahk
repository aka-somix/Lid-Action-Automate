#SingleInstance, Force

;Status variable
OldScreenCount = 0

;Event to capture
OnMessage(0x219, "ManageMonitorDetection")

OnExit("ExitRoutine")

;
; Function Definitions
;

ChangeCloseLidAction(Mode){
    RunWait, powercfg -setdcvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 %Mode% ,,Hide
    RunWait, powercfg -setacvalueindex SCHEME_CURRENT 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 %Mode% ,,Hide
    RunWait, powercfg -SetActive SCHEME_CURRENT ,,Hide
}

;Handles the Monitor Detection subroutine
ManageMonitorDetection(wParam) {
    global OldScreenCount

    SysGet, ScreenCount, MonitorCount
    
    ;Detect Change
    if (OldScreenCount == ScreenCount) {
        return 
    }
    OldScreenCount = ScreenCount

    ;Lid Options:
    ; 1 -> Sleep Mode
    ; 0 -> Do Nothing Mode
    Mode = -1
    if (ScreenCount == 1) {
        Mode = 1
    } else if (ScreenCount >= 2) {
        Mode = 0
    } else {
        MsgBox Design Error, force exit
        return 
    }

    if (wParam = 7) {
        ; Set the new lid action 
        ChangeCloseLidAction(Mode)

    } else {
        MsgBox 0x30, Error Occurred, Something Went Wrong. Probably disconnected.
    }
    TrayTip Monitor Change Detected, Lid action changed to %Mode% !

}

ExitRoutine(ExitReason, ExitCode){
    if (ExitCode == 0){
        ChangeCloseLidAction(1)
        TrayTip Quitting , Lid Close Action set to Default (Sleep).
    }
}