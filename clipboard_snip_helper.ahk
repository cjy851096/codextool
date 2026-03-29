#Requires AutoHotkey v2.0
#SingleInstance Force

; ====== Config ======
; 修改为你自己的保存目录
global SaveDir := "D:\Snips"
global ImageExt := "png"
global _isHandlingCopy := false

if !DirExist(SaveDir) {
    DirCreate(SaveDir)
}

; Win + Shift + S: 不拦截系统热键，截图后自动保存并把路径放入剪贴板
~#+s::
{
    oldClip := ClipboardAll()
    A_Clipboard := ""

    ; 等待截图写入剪贴板（任意格式）
    if !ClipWait(15, true) {
        A_Clipboard := oldClip
        ToolTip "截图已取消或超时"
        SetTimer () => ToolTip(), -1200
        return
    }

    ; 仅当剪贴板里有图像时才保存
    if !ClipboardHasImage() {
        A_Clipboard := oldClip
        ToolTip "未检测到图像内容"
        SetTimer () => ToolTip(), -1200
        return
    }

    filePath := BuildImagePath()
    ok := SaveClipboardImageWithPowerShell(filePath)

    if !ok {
        A_Clipboard := oldClip
        ToolTip "保存截图失败"
        SetTimer () => ToolTip(), -1500
        return
    }

    ; 把路径放进剪贴板，Ctrl+V 可直接粘贴路径
    A_Clipboard := filePath
    ToolTip "截图已保存: " filePath
    SetTimer () => ToolTip(), -1500
}

; Ctrl + C: 不拦截原复制，复制完成后清洗回车换行
~^c::
{
    global _isHandlingCopy
    if _isHandlingCopy {
        return
    }
    ; 给目标程序一点时间先完成复制，再处理剪贴板
    SetTimer CleanClipboardText, -80
}

CleanClipboardText() {
    global _isHandlingCopy
    _isHandlingCopy := true
    try {
        if !ClipWait(1) {
            return
        }

        ; 文件复制/图像复制/非文本复制不处理
        if ClipboardHasFiles() || ClipboardHasImage() || !ClipboardHasText() {
            return
        }

        txt := A_Clipboard
        if (txt = "") {
            return
        }

        txt := StrReplace(txt, "`r`n", "")
        txt := StrReplace(txt, "`n", "")
        txt := StrReplace(txt, "`r", "")
        A_Clipboard := txt
    } finally {
        _isHandlingCopy := false
    }
}

BuildImagePath() {
    global SaveDir, ImageExt
    ts := FormatTime(, "yyyyMMdd_HHmmss")
    ; 避免同一秒多次截图重名
    ms := Mod(A_TickCount, 1000)
    return SaveDir "\snip_" ts "_" Format("{:03}", ms) "." ImageExt
}

ClipboardHasImage() {
    ; CF_BITMAP=2, CF_DIB=8, CF_DIBV5=17
    return DllCall("IsClipboardFormatAvailable", "UInt", 2, "Int")
        || DllCall("IsClipboardFormatAvailable", "UInt", 8, "Int")
        || DllCall("IsClipboardFormatAvailable", "UInt", 17, "Int")
}

ClipboardHasText() {
    ; CF_UNICODETEXT=13
    return DllCall("IsClipboardFormatAvailable", "UInt", 13, "Int")
}

ClipboardHasFiles() {
    ; CF_HDROP=15
    return DllCall("IsClipboardFormatAvailable", "UInt", 15, "Int")
}

SaveClipboardImageWithPowerShell(filePath) {
    escaped := StrReplace(filePath, "'", "''")
    ps := "$ErrorActionPreference='Stop';" .
        "Add-Type -AssemblyName System.Windows.Forms;" .
        "Add-Type -AssemblyName System.Drawing;" .
        "$img=[Windows.Forms.Clipboard]::GetImage();" .
        "if($null -eq $img){exit 2};" .
        "$img.Save('" escaped "', [Drawing.Imaging.ImageFormat]::Png);" .
        "exit 0;"

    cmd := "powershell.exe -NoProfile -NonInteractive -STA -Command " . Chr(34) . ps . Chr(34)
    RunWait(cmd, , "Hide")
    return FileExist(filePath) ? true : false
}

; 手动测试热键（可选）：Win+Shift+Alt+S
#+!s::
{
    ToolTip "脚本正在运行"
    SetTimer () => ToolTip(), -800
}
