#Requires AutoHotkey v2.0

mygui := Gui()
mygui.Show()
PostMessage(0xF000,1,3,,"main.ahk")
OnMessage(0xF000,test)

test(first,second,msg,hwnd)
{
    MsgBox(first)
    MsgBox(second)
    MsgBox(msg)
    MsgBox(hwnd)
}