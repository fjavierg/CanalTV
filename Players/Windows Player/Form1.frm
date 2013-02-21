VERSION 5.00
Object = "{6BF52A50-394A-11D3-B153-00C04F79FAA6}#1.0#0"; "wmp.dll"
Object = "{0E59F1D2-1FBE-11D0-8FF2-00A0D10038BC}#1.0#0"; "msscript.ocx"
Object = "{D27CDB6B-AE6D-11CF-96B8-444553540000}#1.0#0"; "FlDbg9c.ocx"
Begin VB.Form Video 
   BackColor       =   &H80000006&
   BorderStyle     =   0  'None
   Caption         =   "Video Portal"
   ClientHeight    =   12000
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   16005
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   12000
   ScaleWidth      =   16005
   ShowInTaskbar   =   0   'False
   StartUpPosition =   2  'CenterScreen
   Begin VB.Timer Timer1 
      Enabled         =   0   'False
      Left            =   1080
      Top             =   6000
   End
   Begin MSScriptControlCtl.ScriptControl ScriptControl1 
      Left            =   240
      Top             =   6000
      _ExtentX        =   1005
      _ExtentY        =   1005
   End
   Begin ShockwaveFlashObjectsCtl.ShockwaveFlash Flash1 
      Height          =   12000
      Left            =   0
      TabIndex        =   3
      Top             =   0
      Visible         =   0   'False
      Width           =   16000
      _cx             =   28222
      _cy             =   21167
      FlashVars       =   ""
      Movie           =   " "
      Src             =   " "
      WMode           =   "Window"
      Play            =   0   'False
      Loop            =   -1  'True
      Quality         =   "High"
      SAlign          =   ""
      Menu            =   -1  'True
      Base            =   ""
      AllowScriptAccess=   "always"
      Scale           =   "ShowAll"
      DeviceFont      =   0   'False
      EmbedMovie      =   0   'False
      BGColor         =   ""
      SWRemote        =   ""
      MovieData       =   ""
      SeamlessTabbing =   -1  'True
      Profile         =   -1  'True
      ProfileAddress  =   ""
      ProfilePort     =   1263748420
      AllowNetworking =   "all"
      AllowFullScreen =   "false"
   End
   Begin VB.Label Label3 
      Caption         =   "Label3"
      Height          =   375
      Left            =   0
      TabIndex        =   4
      Top             =   6960
      Width           =   3375
   End
   Begin VB.Label Label1 
      Alignment       =   2  'Center
      Height          =   375
      Left            =   -120
      TabIndex        =   0
      Top             =   8040
      Width           =   4335
   End
   Begin VB.Label Label2 
      Alignment       =   2  'Center
      Caption         =   "No caller ID available"
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   9.75
         Charset         =   204
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   0
      TabIndex        =   1
      Top             =   7440
      Width           =   4215
   End
   Begin WMPLibCtl.WindowsMediaPlayer MediaPlayer1 
      Height          =   12000
      Left            =   0
      TabIndex        =   2
      Top             =   0
      Width           =   16000
      URL             =   ""
      rate            =   1
      balance         =   0
      currentPosition =   0
      defaultFrame    =   ""
      playCount       =   1
      autoStart       =   -1  'True
      currentMarker   =   0
      invokeURLs      =   -1  'True
      baseURL         =   ""
      volume          =   50
      mute            =   0   'False
      uiMode          =   "none"
      stretchToFit    =   0   'False
      windowlessVideo =   0   'False
      enabled         =   -1  'True
      enableContextMenu=   -1  'True
      fullScreen      =   0   'False
      SAMIStyle       =   ""
      SAMILang        =   ""
      SAMIFilename    =   ""
      captioningID    =   ""
      enableErrorDialogs=   0   'False
      _cx             =   28231
      _cy             =   21167
   End
End
Attribute VB_Name = "Video"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
' *************************************************************************
'  Copyright ©2005 Jagova65 S.L., All Rights Reserved
' *************************************************************************
' *************************************************************************
Option Explicit

' Win32 API declarations
Private Declare Function PlaySound Lib "winmm.dll" Alias "PlaySoundA" (ByVal lpszName As String, ByVal hModule As Long, ByVal dwFlags As Long) As Long
Private Declare Sub keybd_event Lib "user32" (ByVal bVk As Byte, ByVal bScan As Byte, ByVal dwFlags As Long, ByVal dwExtraInfo As Long)
Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

' Module level variables...
' Playlist
Private MainState As Integer '1=Playlist, 2=VP, 3=RunApp, 4=Enter name
Private Playlist(100)
Private PlaylistState As Integer
Private PlaylistLen As Long

' VideoPortal variables
Private Type VPnode
  Parent As Integer
  Option As Integer
  Action As String
  File As String
End Type
Dim VP(100) As VPnode
Private VPState As Integer
Private VPLen As Integer

'Enter name variables
Dim KeyChar(10) As String
Dim tmpUserName As String * 9
Dim CharNb As Integer
Dim Repeat As Integer
Dim LastKey As Integer
Const NameLen = 9

' Use Variables
Public MSISDN As String
Public UserName As String
Public UserAlias As String

' Varias
Private States As String
Private first

' **************************************************************
' PlaylistInit ()
' Reads playlist.txt file and initializes players
' **************************************************************
Private Sub PlaylistInit()
    Dim MyXMLDOM, MyXpath, MyNodeList
    Dim X As Integer

    Set MyXMLDOM = CreateObject("Microsoft.XMLDOM")
    MyXMLDOM.async = False
    MyXMLDOM.Load ("playlist.xml")
    If MyXMLDOM.xml = "" Then MsgBox "Error en Playlist"
    MyXpath = "/playlist/body/media/@src"
    Set MyNodeList = MyXMLDOM.selectNodes(MyXpath)
    PlaylistLen = MyNodeList.length
    For X = 0 To MyNodeList.length - 1
        Playlist(X) = MyNodeList.Item(X).Text
    Next

    PlaylistState = 0
    MainState = 1
    PlayFile (Playlist(PlaylistState))
End Sub
Private Sub PlaylistNext()
    PlaylistState = PlaylistState + 1
    If (PlaylistState < PlaylistLen) Then
      PlayFile (Playlist(PlaylistState))
    Else
      Call PlaylistInit
    End If
End Sub

' **************************************************************
' EnterNameInit
'
' **************************************************************
Private Sub EnterNameInit()

KeyChar(0) = " "
KeyChar(1) = " "
KeyChar(2) = "ABC"
KeyChar(3) = "DEF"
tmpUserName = "---------"
CharNb = 0
Repeat = 1
LastKey = -1

MainState = 4
End Sub
' **************************************************************
' Some common functions
' **************************************************************
Private Sub PlayVideo(ByVal Fichero As String)
  If Flash1.Visible Then Flash1.Visible = False
  MediaPlayer1.URL = Fichero
' MediaPlayer1.Controls.play
End Sub

Private Sub PlayFlash(ByVal Fichero As String)
  MediaPlayer1.Close
  Flash1.Movie = Fichero
  Flash1.Visible = True
End Sub
Private Sub PlayFile(ByVal sFileName As String)
  Dim GetFileExt As String
  Dim P As Integer

  For P = Len(sFileName) To 1 Step -1
        'Find the last ocurrence of "." in the string
        If InStr(".", Mid(sFileName, P, 1)) Then Exit For
  Next
  GetFileExt = Right$(sFileName, Len(sFileName) - P) 'End Function
  If (GetFileExt = "swf") Then
    PlayFlash (sFileName)
  ElseIf (GetFileExt = "avi") Or (GetFileExt = "wmv") Or (GetFileExt = "mov") Then
    PlayVideo (sFileName)
  End If
End Sub

' **************************************************************
' Flash1_FSCommand ()
' Called by flash game when end of game
' points in args
' **************************************************************


Private Sub Flash1_FSCommand(ByVal command As String, ByVal args As String)
Label1 = "FSCOMMAND   " & command & args
      Timer1.Interval = 100
      Timer1.Enabled = True
End Sub

' **************************************************************
' Form_Load ()
' Initializes application
' **************************************************************
Private Sub Form_Load()
  Label3 = "Hello" & UserName
  Call PlaylistInit 'Inicia la reproduccion del playlist
End Sub
' **************************************************************
' Events management
'
' **************************************************************

Private Sub MediaPlayer1_PlayStateChange(ByVal newState As Long)
    States = States & Str(newState)
    Label2 = States
    If (newState = 8) Then
      Timer1.Interval = 100
      Timer1.Enabled = True
    End If

End Sub

Private Sub Timer1_Timer()
Timer1.Enabled = False
Call PlaylistNext
End Sub


