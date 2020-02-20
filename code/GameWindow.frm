VERSION 5.00
Begin VB.Form GameWindow 
   Appearance      =   0  'Flat
   BackColor       =   &H80000005&
   BorderStyle     =   0  'None
   Caption         =   "Focuser"
   ClientHeight    =   6672
   ClientLeft      =   12
   ClientTop       =   12
   ClientWidth     =   9660
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   556
   ScaleMode       =   3  'Pixel
   ScaleWidth      =   805
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  '屏幕中心
   Begin VB.Timer DrawTimer 
      Enabled         =   0   'False
      Interval        =   5
      Left            =   9000
      Top             =   240
   End
End
Attribute VB_Name = "GameWindow"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'==================================================
'   页面管理器
    Dim EC As GMan
    Dim o As WinShadow
'==================================================
'   在此处放置你的页面类模块声明
    Dim GamePage As GamePage
'==================================================

Private Sub DrawTimer_Timer()
    '绘制
    EC.Display
End Sub

Private Sub Form_KeyPress(KeyAscii As Integer)
    '发送字符输入
    If TextHandle <> 0 Then WaitChr = WaitChr & Chr(KeyAscii)
End Sub

Private Sub Form_Load()
    '初始化Emerald（在此处可以修改窗口大小哟~）
    StartEmerald Me.Hwnd, 150, 150
    '创建字体
    MakeFont "微软雅黑"
    '创建页面管理器
    Set EC = New GMan
    EC.Layered False
    BlurWindow Me.Hwnd, argb(120, 64, 64, 72)
    SetWindowPos Me.Hwnd, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE Or SWP_NOMOVE
    Set o = New WinShadow
    With o
        If .Shadow(Me) Then
            .Color = RGB(0, 0, 0)
            .Depth = 8
            .Transparency = 8
        End If
    End With
    
    '创建存档（可选）
    'Set ESave = New GSaving
    'ESave.Create "emerald.test", "Emerald.test"
    
    '创建音乐列表
    Set MusicList = New GMusicList
    MusicList.Create App.path & "\music"

    '开始显示
    Me.Show
    DrawTimer.Enabled = True
    
    '在此处初始化你的页面
    '=============================================
    '示例：TestPage.cls
    '     Set TestPage = New TestPage
        Set GamePage = New GamePage
    '公共部分：Dim TestPage As TestPage
    '=============================================

    '设置活动页面
    EC.ActivePage = "GamePage"
End Sub

Private Sub Form_MouseDown(button As Integer, Shift As Integer, X As Single, y As Single)
    '发送鼠标信息
    UpdateMouse X, y, 1, button
End Sub

Private Sub Form_MouseMove(button As Integer, Shift As Integer, X As Single, y As Single)
    '发送鼠标信息
    If Mouse.State = 0 Then
        UpdateMouse X, y, 0, button
    Else
        Mouse.X = X: Mouse.y = y
    End If
End Sub
Private Sub Form_MouseUp(button As Integer, Shift As Integer, X As Single, y As Single)
    '发送鼠标信息
    UpdateMouse X, y, 2, button
End Sub

Private Sub Form_Unload(Cancel As Integer)
    '终止绘制
    DrawTimer.Enabled = False
    '释放Emerald资源
    EndEmerald
End Sub
