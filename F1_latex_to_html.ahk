; Convert selected LaTeX to html LaTeX with tth
; https://github.com/MasterHowToLearn/

#SingleInstance force
#NoEnv
#IfWinActive ahk_exe sm19.exe
#Include %A_LineFile%\..\Clip.ahk
DetectHiddenWindows On
SendMode Input
SetWorkingDir, C:\Program Files\tth_exe

; press F1 to trigger execution
F1::
Clipped := Clip() ; assign selected text to var Clipped
Clipped := StrReplace(Clipped, "\vec{x}", "\overrightarrow{x}")
Clipped := StrReplace(Clipped, "\vec{y}", "\overrightarrow{y}")
Clipped := StrReplace(Clipped, "\vec{z}", "\overrightarrow{z}")
Clipped := StrReplace(Clipped, "\mathbb{R}", "\special{html:&#8477;}")
Clipped := StrReplace(Clipped, "\mathbb{N}", "\special{html:&#8469;}")
Clipped := StrReplace(Clipped, "\mathbb{C}", "\special{html:&#8450;}")
Clipped := StrReplace(Clipped, "\vdash", "\special{html:&#8866;}")
Clipped := StrReplace(Clipped, "\mathfrak{F}", "\special{html:&#8465;}")
Clipped := StrReplace(Clipped, "\mathfrak{E}", "\special{html:&#322;}")

; 1. write clipboard to file
output := FileOpen("C:\Program Files\tth_exe\test.tex", "w")
if !IsObject(output)
{
    MsgBox Can't open "%FileName%" for writing.
    return
}
output.write(Clipped)
output.close()

; 2. run cmd in ahk
; input: test.tex
; output: test.html
command = tth -L test.tex -r
Run %ComSpec%,, Hide, pid
WinWait ahk_pid %pid%
DllCall("AttachConsole", "UInt", pid)
WshShell := ComObjCreate("Wscript.Shell")
WshShell.Exec(command)
DllCall("FreeConsole")
Process Close, %pid%

; 3. read tth output
FileRead, Contents, C:\Program Files\tth_exe\test.html
if not ErrorLevel
{
; trim leading whitespace; for some reason whitespace is generated.
trimmedContents := regexreplace(Contents, "^\s+")

}

; Send result to clipbord and then re-selects it
Clip(trimmedContents, True)
Sleep, 200
Send, ^+{1} ; parse html in SuperMemo
return
