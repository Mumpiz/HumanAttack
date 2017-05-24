

' ------------------
'| Human Attack     |
'| by Michael Frank |
'| 03.03.2012       |
' ------------------
SuperStrict

Include "incbin.bmx"
Include "globals.bmx"
Include "objectClasses.bmx"
Include "detailClasses.bmx"
Include "functions.bmx"

LoadMedia()
CreateEnemys(40,7)

Local Player:tPlayer = CreatePlayer(500,500,8,100)


'@@@@@@@@ Main @@@@@@@@
While Not KeyHit(KEY_ESCAPE)
	Millisec = MilliSecs()
	SeedRnd Millisec
	Cls
	
	
	CheckKeyEvents()
	
	DrawLevel(Player)
	UpdateDetails()
	DrawDetails()
	
	UpdateObjects()
	DrawObjects()
	
	DrawPlayerLightRadius()
	ShakeScreen()
	DrawScanner(Player)

	Flip(1)
	WaitTimer(Tmr_FpsTimer)
Wend
End
'@@@@@@@@@@@@@@@@@@@@@@











