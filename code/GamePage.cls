VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "GamePage"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'======================================
'   ҳ�������
    Dim Page As GPage
    Dim EndHour As Long, EndMinute As Long, EndPercent As Long
    Dim OtherTick As Long, FocusTick As Long, StartTime As Long
    Dim EndHwnd As Long, ForceMode As Long
    Dim Step As Long, lP As POINTAPI
'======================================

Public Sub Update()
    '��Ϸÿһ֡�Ĺ��̣����ƹ�������ڴ˴���
    
    Page.Clear argb(1, 0, 0, 0) '��ջ���

    '================================================================
    '   ʾ������������
    '   Page.Writes "��������", 20,20, Color:=argb(255, 0, 0, 0)
    '================================================================
    
    Select Case Step
        Case 0: Call Step0
        Case 1: Call Step1
        Case 2: Call Step2
        Case 3: Call Step3
        Case 4: Call Step4
    End Select
    
    If Step <> 3 Then
        If IsKeyPress(VK_ESCAPE) Then
            Unload GameWindow
            End
        End If
    End If
    
    If Step = 3 And ForceMode = 0 Then
        If IsKeyPress(VK_ESCAPE) Then
            GameWindow.Move Screen.Width / 2 - GameWindow.Width / 2, Screen.Height / 2 - GameWindow.Height / 2
            StartTime = GetTickCount: Step = 0: ECore.NewTransform transDarkTo
        End If
    End If
End Sub
Sub Step0()
    Page.Paint 0, 0, 0, GW + 1, 50, argb(40, 0, 0, 0)
    Page.Writes "רע����ʱ��", GW / 2, 10, 18, argb(255, 255, 255, 255), align:=StringAlignmentCenter, style:=FontStyleBold
    
    Page.Writes format(EndHour, "00"), 0, 60, 24, argb(200, 255, 255, 255), GW / 2 - 10, 35, align:=StringAlignmentCenter, style:=FontStyleBold
    If CheckMouse2 = mMouseUp Then EndHour = EndHour + 1
    If EndHour >= 24 Then EndHour = 0
    Page.Writes ":", GW / 2 - 10, 58, 24, argb(255, 255, 255, 255), 20, 35, align:=StringAlignmentCenter, style:=FontStyleBold
    Page.Writes format(EndMinute, "00"), GW / 2 + 10, 60, 24, argb(200, 255, 255, 255), GW / 2 - 10, 35, align:=StringAlignmentCenter, style:=FontStyleBold
    If CheckMouse2 = mMouseUp Then EndMinute = EndMinute + 5
    If EndMinute >= 60 Then EndMinute = 0
    
    Page.Paint 0, 0, GH - 39, GW + 1, 40, argb(255, 24, 180, 255)
    If CheckMouse2 = mMouseUp Then Step = 1: ECore.NewTransform transDarkTo
    Page.Writes "����", GW / 2, GH - 35, 18, argb(255, 255, 255, 255), align:=StringAlignmentCenter, style:=FontStyleBold
End Sub
Sub Step1()
    Page.Paint 0, 0, 0, GW + 1, 50, argb(40, 0, 0, 0)
    Page.Writes "רע�ٷֱ�", GW / 2, 10, 18, argb(255, 255, 255, 255), align:=StringAlignmentCenter, style:=FontStyleBold
    
    Page.Writes EndPercent & "%", 0, 60, 24, argb(200, 255, 255, 255), GW, 35, align:=StringAlignmentCenter, style:=FontStyleBold
    If CheckMouse2 = mMouseUp Then EndPercent = EndPercent + 5
    If EndPercent >= 100 Then EndPercent = 0
    
    Page.Paint 0, 0, GH - 39, GW + 1, 40, argb(255, 24, 180, 255)
    If CheckMouse2 = mMouseUp Then StartTime = GetTickCount: Step = 4: ECore.NewTransform transDarkTo
    Page.Writes "����", GW / 2, GH - 35, 18, argb(255, 255, 255, 255), align:=StringAlignmentCenter, style:=FontStyleBold
End Sub
Sub Step2()
    Page.Paint 0, 0, 0, GW + 1, 50, argb(40, 0, 0, 0)
    Page.Writes "רע����", GW / 2, 10, 18, argb(255, 255, 255, 255), align:=StringAlignmentCenter, style:=FontStyleBold
    If 6 - Int((GetTickCount - StartTime) / 1000) <= 0 Then
        Dim p As POINTAPI, Hwnd As Long
        GetCursorPos p
        Hwnd = WindowFromPoint(p.X, p.y)
        Do While GetParent(Hwnd) <> 0
            Hwnd = GetParent(Hwnd)
            DoEvents
        Loop
        EndHwnd = Hwnd
        GameWindow.Move Screen.Width - 10 * Screen.TwipsPerPixelX - GameWindow.Width, Screen.Height - 10 * Screen.TwipsPerPixelY - GameWindow.Height - GetTaskbarHeight
        StartTime = GetTickCount: Step = 3: ECore.NewTransform transDarkTo
        Exit Sub
    End If
    Page.Writes 6 - Int((GetTickCount - StartTime) / 1000) & "s������������ڵĴ���Ϊרע����", 0, 75, 14, argb(255, 255, 255, 255), GW, 35, align:=StringAlignmentCenter
End Sub
Sub Step4()
    Page.Paint 0, 0, 0, GW + 1, 50, argb(40, 0, 0, 0)
    Page.Writes "ǿ��ģʽ", GW / 2, 10, 18, argb(255, 255, 255, 255), align:=StringAlignmentCenter, style:=FontStyleBold
    Page.Writes IIf(ForceMode = 1, "ON", "OFF"), 0, 60, 24, argb(255, 255, 255, 255), GW, 35, align:=StringAlignmentCenter, style:=FontStyleBold
    If CheckMouse2 = mMouseUp Then ForceMode = IIf(ForceMode = 1, 0, 1)
    
    Page.Paint 0, 0, GH - 39, GW + 1, 40, argb(255, 24, 180, 255)
    If CheckMouse2 = mMouseUp Then StartTime = GetTickCount: Step = 2: ECore.NewTransform transDarkTo
    Page.Writes "����", GW / 2, GH - 35, 18, argb(255, 255, 255, 255), align:=StringAlignmentCenter, style:=FontStyleBold
End Sub
Public Function GetTaskbarHeight() As Integer
    Dim lRes As Long
    Dim rectVal As RECT
    lRes = SystemParametersInfo(SPI_GETWORKAREA, 0, rectVal, 0)
    GetTaskbarHeight = ((Screen.Height / Screen.TwipsPerPixelY) - rectVal.Bottom) * Screen.TwipsPerPixelY
End Function
Sub Step3()
    Dim Per As Long
    On Error Resume Next
    If GetForegroundWindow = EndHwnd Then
        Dim p As POINTAPI
        GetCursorPos p
        If WindowFromPoint(p.X, p.y) <> EndHwnd Then
            OtherTick = OtherTick + 1
        Else
            lP = p
            FocusTick = FocusTick + 1
        End If
    Else
        OtherTick = OtherTick + 1
    End If
    Per = Int(FocusTick / (FocusTick + OtherTick) * 100)
    
    Dim Ta As Long, No As Long
    Ta = Val(format(EndHour, "00") & format(EndMinute, "00"))
    No = Val(format(Hour(Now), "00") & format(Minute(Now), "00"))
    
    If No >= Ta Then
        GameWindow.Move Screen.Width / 2 - GameWindow.Width / 2, Screen.Height / 2 - GameWindow.Height / 2
        StartTime = GetTickCount: Step = 0: ECore.NewTransform transDarkTo
    End If
   
    If Per < EndPercent Then
        Page.Paint 0, 0, GH - (GH * Per / 100), GW + 1, GH * Per / 100 + 1, argb(100, 253, 86, 60)
        If ForceMode Then
            Dim l As Long
            l = EnumWindows(AddressOf EnumWindowsProc, 0)
            ShowWindow EndHwnd, SW_SHOW
            SetCursorPos lP.X, lP.y
            SetForegroundWindow EndHwnd
        End If
    ElseIf Per < EndPercent + (100 - EndPercent) / 2 Then
        Page.Paint 0, 0, GH - (GH * Per / 100), GW + 1, GH * Per / 100 + 1, argb(100, 255, 170, 49)
    Else
        Page.Paint 0, 0, GH - (GH * Per / 100), GW + 1, GH * Per / 100 + 1, argb(100, 9, 241, 117)
    End If
    Page.Writes Per & "%", 0, 60, 24, argb(255, 255, 255, 255), GW, 35, align:=StringAlignmentCenter, style:=FontStyleBold
End Sub
Public Sub Wheel(Direction As Integer, Depth As Single)
    '�������¼�
    'Direction:����Depth�����
End Sub
Public Sub AnimationMsg(id As String, msg As String)
    '������Ϣ����
End Sub
Public Sub Enter()
    'ҳ������¼�
End Sub
Public Sub Leave()
    'ҳ���뿪�¼�
End Sub
Public Sub Gotfocus()
    '����ȡ�ý����¼�
End Sub
Public Sub Lostfocus()
    '����ʧȥ�����¼�
End Sub
Public Sub AnimationDone(id As Integer)
    '�������Ž����¼�
    'id�������Ķ���ID
End Sub
Private Sub Class_Initialize()
    '����ҳ�������
    Set Page = New GPage
    Page.Create Me
    '������Ϸ��Դ
    Page.Res.NewImages App.path & "\assets"
    '����ҳ��
    ECore.Add Page, "GamePage"
    EndPercent = 85
    EndHour = Hour(Now): EndMinute = Int(Minute(Now) / 5) * 5
    '===============================================
    '   �����Ҫ���Ӷ�����������ڴ˴�
    
    '===============================================
End Sub