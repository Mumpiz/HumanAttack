


Function UpdateObjects()
	'Sortiert die Objektliste nach der grösse der y-Koordinate der Objekte ( siehe Type tEntity Method Compare )
	SortList(Lst_ObjectList,True)
  	For Local e:tEntity = EachIn Lst_ObjectList
    		e.Update()
  	Next
EndFunction

Function DrawObjects()
  	'Draw Shadows
  	For Local e:tEntity=EachIn Lst_ObjectList
    		e.DrawShadow()
	Next
  	'Draw objects without shadows
  	For Local e:tEntity=EachIn Lst_ObjectList
    		e.DrawBody()
  	Next
EndFunction


Function UpdateDetails()
  	For Local d:tDetail=EachIn Lst_DetailList
    		d.Update()
  	Next

	For Local b:tBloodSpatter = EachIn Lst_BloodSpatterList
    		b.Update()
  	Next

	For Local b:tBloodSpatter = EachIn Lst_BloodSpatterList
    		b.Draw()
	Next

	For Local ds:tDeathSpatter = EachIn Lst_DeathSpatterList
		ds.Update()
	Next
EndFunction

Function DrawDetails()
  	'Draw Shadows
  	For Local d:tDetail=EachIn Lst_DetailList
    		d.DrawShadow()
	Next
  	'Draw Detail without shadows
  	For Local d:tDetail=EachIn Lst_DetailList
    		d.DrawBody()
  	Next

	For Local ds:tDeathSpatter = EachIn Lst_DeathSpatterList
		ds.Draw()
	Next
EndFunction



Function ShakeScreen:Int()
	If ShakeScreenCounter > 0
		ShakeScreenCounter:+4
		If ShakeScreenCounter > 20
			ShakeScreenCounter = 0
			SetOrigin 0,0
			Return 0
		EndIf
		If ShakeScreenCounter > 0 And ShakeScreenCounter <= 5
			ShakeScreenOffset:+20
		ElseIf ShakeScreenCounter > 5 And ShakeScreenCounter <= 15
			ShakeScreenOffset:-20
		ElseIf ShakeScreenCounter > 15 And ShakeScreenCounter <= 20
			ShakeScreenOffset:+20
		EndIf
		SetOrigin ShakeScreenOffset, -ShakeScreenOffset
	EndIf
EndFunction


Function DrawLevel(p:tPlayer)
 	MapX = p.x
	MapY = p.y
	SetBlend SOLIDBLEND
	SetColor 80,80,80
	SetScale 1,1
	TileImage Img_Ground1, MapX, MapY
EndFunction


'Zeichnet den Lichtradius des Spielers
Function DrawPlayerLightRadius()
	For Local p:tPlayer = EachIn Lst_Objectlist
		SetBlend LIGHTBLEND
  		SetColor 150,150,150
		SetScale 1.8,1.8
		SetAlpha 0.3
		SetRotation p.rotation
		DrawImage Img_LightRadius,ScreenMidX, ScreenMidY
		SetRotation 0
		DrawPlayerHealthBar(ScreenMidX, ScreenMidY , p.life)
	Next
EndFunction

'Zeichnet die Healthbar des Spielers über seinen Kopf ein
Function DrawPlayerHealthBar(x:Float, y:Float, life:Int)
	SetBlend SOLIDBLEND
  	SetColor 255,255,255
	SetScale life/2,1.5
	DrawImage Img_Health,x, y-64
EndFunction

Function CreateEnemys(count1:Int, count2:Int)
	For Local i:Int = 0 To count1 -1
		tEnemy.Create:tEnemy(Rand(-WorldSize+50, WorldSize-50),Rand(-WorldSize+50,WorldSize-50),0)
	Next
	For Local i:Int = 0 To count2 -1
		tEnemy.Create:tEnemy(Rand(-WorldSize+50, WorldSize-50),Rand(-WorldSize+50,WorldSize-50),1)
	Next
End Function

Function CreatePlayer:tPlayer(x:Float,y:Float,speed:Int, life:Int)
	Return tPlayer.Create:tPlayer(x,y,speed,life)
EndFunction


Function DrawScanner(p:tPlayer) 'according to a certain player
  	SetBlend LightBlend
  	SetColor 255,255,255
  	SetAlpha 0.1
	SetScale ScannerScale,ScannerScale
	DrawImage Img_Scan1,ScannerX,ScannerY
  	SetRotation ScannerRot+90
  	ScannerRot:-8
  	If ScannerRot < 0 ScannerRot:+360
	SetAlpha 0.4
  	DrawImage Img_Scan,ScannerX,ScannerY
  	Local e:tEnemy
  	Local so:tScannedObject

  	For e=EachIn Lst_ObjectList
    		Local distanceX:Int = p.x - e.x
		Local distanceY:Int = p.y - e.y
    		If checkDistance(p.x, p.y, e.x, e.y) < 1500
      		Local angle:Int = GetAngle(p.x-e.x, p.y-e.y)
      		If angle < 0 angle = 360 + angle
      		If Abs(angle-(ScannerRot))<20
        			'add a new dot on the scanner
        			tScannedObject.Create(distanceX/11.5, distanceY/11.5, 0 )
      		EndIf
    		EndIf
  	Next
  	SetBlend LightBlend
  	SetAlpha 0.5
  	SetColor 50,50,20
  	SetRotation 0
  	DrawOval ScannerX-128,ScannerY-128,256,256
  	SetColor 0,150,0
  	For so=EachIn Lst_ScanList
    		so.Update(ScannerX,ScannerY)
  	Next
EndFunction


Function CheckKeyEvents()	
	MouseXVal 		= MouseX()
	MouseYVal 		= MouseY()
	
	MouseDown_Left 	= MouseDown(1)
	MouseDown_Right 	= MouseDown(2)
	MouseDown_Mid 	= MouseDown(3)
	
	KeyDown_W 		= KeyDown(KEY_W)
	KeyDown_A 		= KeyDown(KEY_A)
	KeyDown_S 		= KeyDown(KEY_S)
	KeyDown_D 		= KeyDown(KEY_D)

	KeyDown_UP		= KeyDown(KEY_UP)
	KeyDown_Left 	= KeyDown(KEY_LEFT)
	KeyDown_Down 	= KeyDown(KEY_DOWN)
	KeyDown_Right 	= KeyDown(KEY_RIGHT)
End Function


Function GetAngle:Int(x:Int, y:Int)
	Local angle:Int = -ATan2(x,y)
	If angle < 0 angle:+360
	If angle >= 360 angle:-360
	Return angle
EndFunction

'Überprüft und gibt die Distanz zwischen 2 Punkten zurück
Function checkDistance:Float(x1:Float, y1:Float, x2:Float, y2:Float)
	Return Sqr((x1 - x2)^2 + (y1-y2)^2)
EndFunction


Function Loadassets()
	Graphics 1024,768,0,32
	SetAudioDriver("OpenAL")
	AutoImageFlags MASKEDIMAGE|FILTEREDIMAGE|MIPMAPPEDIMAGE
	AutoMidHandle True
	
	'Images
	
	Img_EnemyCrawlerWalk[5] =  LoadAnimImage("incbin::assets/img/anim/crawlerWalk45.png", 100, 100, 0, 20)
	Img_EnemyCrawlerWalk[6] =  LoadAnimImage("incbin::assets/img/anim/crawlerWalk90.png", 100, 100, 0, 20)
	Img_EnemyCrawlerWalk[7] =  LoadAnimImage("incbin::assets/img/anim/crawlerWalk135.png", 100, 100, 0, 20)
	Img_EnemyCrawlerWalk[0] =  LoadAnimImage("incbin::assets/img/anim/crawlerWalk180.png", 100, 100, 0, 20)
	Img_EnemyCrawlerWalk[1] =  LoadAnimImage("incbin::assets/img/anim/crawlerWalk225.png", 100, 100, 0, 20)
	Img_EnemyCrawlerWalk[2] =  LoadAnimImage("incbin::assets/img/anim/crawlerWalk270.png", 100, 100, 0, 20)
	Img_EnemyCrawlerWalk[3] =  LoadAnimImage("incbin::assets/img/anim/crawlerWalk315.png", 100, 100, 0, 20)
	Img_EnemyCrawlerWalk[4] =  LoadAnimImage("incbin::assets/img/anim/crawlerWalk0.png", 100, 100, 0, 20)
	
	Img_EnemyCrawlerAttack[5] =  LoadAnimImage("incbin::assets/img/anim/crawlerAttack45.png", 100, 100, 0, 20)
	Img_EnemyCrawlerAttack[6] =  LoadAnimImage("incbin::assets/img/anim/crawlerAttack90.png", 100, 100, 0, 20)
	Img_EnemyCrawlerAttack[7] =  LoadAnimImage("incbin::assets/img/anim/crawlerAttack135.png", 100, 100, 0, 20)
	Img_EnemyCrawlerAttack[0] =  LoadAnimImage("incbin::assets/img/anim/crawlerAttack180.png", 100, 100, 0, 20)
	Img_EnemyCrawlerAttack[1] =  LoadAnimImage("incbin::assets/img/anim/crawlerAttack225.png", 100, 100, 0, 20)
	Img_EnemyCrawlerAttack[2] =  LoadAnimImage("incbin::assets/img/anim/crawlerAttack270.png", 100, 100, 0, 20)
	Img_EnemyCrawlerAttack[3] =  LoadAnimImage("incbin::assets/img/anim/crawlerAttack315.png", 100, 100, 0, 20)
	Img_EnemyCrawlerAttack[4] =  LoadAnimImage("incbin::assets/img/anim/crawlerAttack0.png", 100, 100, 0, 20)
	
	Img_EnemyCrawlerDie[5] =  LoadAnimImage("incbin::assets/img/anim/crawlerDie45.png", 100, 100, 0, 10)
	Img_EnemyCrawlerDie[6] =  LoadAnimImage("incbin::assets/img/anim/crawlerDie90.png", 100, 100, 0, 10)
	Img_EnemyCrawlerDie[7] =  LoadAnimImage("incbin::assets/img/anim/crawlerDie135.png", 100, 100, 0, 10)
	Img_EnemyCrawlerDie[0] =  LoadAnimImage("incbin::assets/img/anim/crawlerDie180.png", 100, 100, 0, 10)
	Img_EnemyCrawlerDie[1] =  LoadAnimImage("incbin::assets/img/anim/crawlerDie225.png", 100, 100, 0, 10)
	Img_EnemyCrawlerDie[2] =  LoadAnimImage("incbin::assets/img/anim/crawlerDie270.png", 100, 100, 0, 10)
	Img_EnemyCrawlerDie[3] =  LoadAnimImage("incbin::assets/img/anim/crawlerDie315.png", 100, 100, 0, 10)
	Img_EnemyCrawlerDie[4] =  LoadAnimImage("incbin::assets/img/anim/crawlerDie0.png", 100, 100, 0, 10)
	
	Img_EnemyCrawlerCorpse =  LoadImage("incbin::assets/img/anim/crawlerCorpse.png")
	
	
	Img_EnemyCrawlerEliteWalk[4] =  LoadAnimImage("incbin::assets/img/anim/crawlerEliteWalk45.png", 200, 200, 0, 20)
	Img_EnemyCrawlerEliteWalk[5] =  LoadAnimImage("incbin::assets/img/anim/crawlerEliteWalk90.png", 200, 200, 0, 20)
	Img_EnemyCrawlerEliteWalk[6] =  LoadAnimImage("incbin::assets/img/anim/crawlerEliteWalk135.png", 200, 200, 0, 20)
	Img_EnemyCrawlerEliteWalk[7] =  LoadAnimImage("incbin::assets/img/anim/crawlerEliteWalk180.png", 200, 200, 0, 20)
	Img_EnemyCrawlerEliteWalk[0] =  LoadAnimImage("incbin::assets/img/anim/crawlerEliteWalk225.png", 200, 200, 0, 20)
	Img_EnemyCrawlerEliteWalk[1] =  LoadAnimImage("incbin::assets/img/anim/crawlerEliteWalk270.png", 200, 200, 0, 20)
	Img_EnemyCrawlerEliteWalk[2] =  LoadAnimImage("incbin::assets/img/anim/crawlerEliteWalk315.png", 200, 200, 0, 20)
	Img_EnemyCrawlerEliteWalk[3] =  LoadAnimImage("incbin::assets/img/anim/crawlerEliteWalk0.png", 200, 200, 0, 20)
	
	Img_EnemyCrawlerEliteAttack[4] =  LoadAnimImage("incbin::assets/img/anim/crawlerEliteAttack45.png", 200, 200, 0, 20)
	Img_EnemyCrawlerEliteAttack[5] =  LoadAnimImage("incbin::assets/img/anim/crawlerEliteAttack90.png", 200, 200, 0, 20)
	Img_EnemyCrawlerEliteAttack[6] =  LoadAnimImage("incbin::assets/img/anim/crawlerEliteAttack135.png", 200, 200, 0, 20)
	Img_EnemyCrawlerEliteAttack[7] =  LoadAnimImage("incbin::assets/img/anim/crawlerEliteAttack180.png", 200, 200, 0, 20)
	Img_EnemyCrawlerEliteAttack[0] =  LoadAnimImage("incbin::assets/img/anim/crawlerEliteAttack225.png", 200, 200, 0, 20)
	Img_EnemyCrawlerEliteAttack[1] =  LoadAnimImage("incbin::assets/img/anim/crawlerEliteAttack270.png", 200, 200, 0, 20)
	Img_EnemyCrawlerEliteAttack[2] =  LoadAnimImage("incbin::assets/img/anim/crawlerEliteAttack315.png", 200, 200, 0, 20)
	Img_EnemyCrawlerEliteAttack[3] =  LoadAnimImage("incbin::assets/img/anim/crawlerEliteAttack0.png", 200, 200, 0, 20)
	
	Img_EnemyCrawlerEliteDie[5] =  LoadAnimImage("incbin::assets/img/anim/crawlerEliteDie45.png", 200, 200, 0, 10)
	Img_EnemyCrawlerEliteDie[6] =  LoadAnimImage("incbin::assets/img/anim/crawlerEliteDie90.png", 200, 200, 0, 10)
	Img_EnemyCrawlerEliteDie[7] =  LoadAnimImage("incbin::assets/img/anim/crawlerEliteDie135.png", 200, 200, 0, 10)
	Img_EnemyCrawlerEliteDie[0] =  LoadAnimImage("incbin::assets/img/anim/crawlerEliteDie180.png", 200, 200, 0, 10)
	Img_EnemyCrawlerEliteDie[1] =  LoadAnimImage("incbin::assets/img/anim/crawlerEliteDie225.png", 200, 200, 0, 10)
	Img_EnemyCrawlerEliteDie[2] =  LoadAnimImage("incbin::assets/img/anim/crawlerEliteDie270.png", 200, 200, 0, 10)
	Img_EnemyCrawlerEliteDie[3] =  LoadAnimImage("incbin::assets/img/anim/crawlerEliteDie315.png", 200, 200, 0, 10)
	Img_EnemyCrawlerEliteDie[4] =  LoadAnimImage("incbin::assets/img/anim/crawlerEliteDie0.png", 200, 200, 0, 10)
	
	Img_EnemyCrawlerEliteCorpse =  LoadImage("incbin::assets/img/anim/crawlerEliteCorpse.png")
	
	
	Img_PlayerRun[1] = LoadAnimImage("incbin::assets/img/anim/playerWalk45.png",128, 128, 0, 20)
	Img_PlayerRun[2] = LoadAnimImage("incbin::assets/img/anim/playerWalk90.png",128, 128, 0, 20)
	Img_PlayerRun[3] = LoadAnimImage("incbin::assets/img/anim/playerWalk135.png",128, 128, 0, 20)
	Img_PlayerRun[4] = LoadAnimImage("incbin::assets/img/anim/playerWalk180.png",128, 128, 0, 20)
	Img_PlayerRun[5] = LoadAnimImage("incbin::assets/img/anim/playerWalk225.png",128, 128, 0, 20)
	Img_PlayerRun[6] = LoadAnimImage("incbin::assets/img/anim/playerWalk270.png",128, 128, 0, 20)
	Img_PlayerRun[7] = LoadAnimImage("incbin::assets/img/anim/playerWalk315.png",128, 128, 0, 20)
	Img_PlayerRun[0] = LoadAnimImage("incbin::assets/img/anim/playerWalk0.png",128, 128, 0, 20)
	
	Img_PlayerStand[1] = LoadAnimImage("incbin::assets/img/anim/playerStand45.png",128, 128, 0, 20)
	Img_PlayerStand[2] = LoadAnimImage("incbin::assets/img/anim/playerStand90.png",128, 128, 0, 20)
	Img_PlayerStand[3]= LoadAnimImage("incbin::assets/img/anim/playerStand135.png",128, 128, 0, 20)
	Img_PlayerStand[4]= LoadAnimImage("incbin::assets/img/anim/playerStand180.png",128, 128, 0, 20)
	Img_PlayerStand[5]= LoadAnimImage("incbin::assets/img/anim/playerStand225.png",128, 128, 0, 20)
	Img_PlayerStand[6]= LoadAnimImage("incbin::assets/img/anim/playerStand270.png",128, 128, 0, 20)
	Img_PlayerStand[7]= LoadAnimImage("incbin::assets/img/anim/playerStand315.png",128, 128, 0, 20)
	Img_PlayerStand[0]= LoadAnimImage("incbin::assets/img/anim/playerStand0.png",128, 128, 0, 20)
	
	
	Img_DeathSpatterGreen = LoadAnimImage("incbin::assets/img/anim/deathSpatterGreen.png",128, 128, 0, 10)
	
	Img_Ground1 = LoadImage("incbin::assets/img/detail/ground1.png")
	Img_Health = LoadImage("incbin::assets/img/detail/health.png")
	Img_WrongWayArrow = LoadImage("incbin::assets/img/detail/wrongWayArrow.png")
	
	Img_Shot = LoadImage("incbin::assets/img/detail/shot.png")
	Img_LightRadius = LoadImage("incbin::assets/img/detail/lightRadius.png")

	Img_Scan = LoadImage("incbin::assets/img/detail/scan.png")
	Img_Scan1 = LoadImage("incbin::assets/img/detail/scan1.png")
	Img_BloodSpatterRed = LoadImage("incbin::assets/img/detail/bloodSpatterRed.png")
	Img_BloodSpatterGreen = LoadImage("incbin::assets/img/detail/bloodSpatterGreen.png")
	
	
	'SFX
	Sfx_PlayerDie 		= LoadSound("incbin::assets/sfx/playerDie.wav")
	Sfx_PlayerGetHitten1 	= LoadSound("incbin::assets/sfx/playerGetHitten1.wav")
	Sfx_PlayerGetHitten2 	= LoadSound("incbin::assets/sfx/playerGetHitten2.wav")
	Sfx_PlayerGetHitten3 	= LoadSound("incbin::assets/sfx/playerGetHitten3.wav")
	Sfx_PlayerShot1 		= LoadSound("incbin::assets/sfx/playerShot1.wav")
	SetChannelVolume Chn_PlayerShot, 0 
	
	Sfx_PlayerGasp1 		= LoadSound("Incbin::assets/sfx/playerGasp1.wav")
	Sfx_PlayerGasp2		= LoadSound("Incbin::assets/sfx/playerGasp2.wav")
	Sfx_PlayerBreath1		= LoadSound("Incbin::assets/sfx/playerBreathe1.wav")
	Sfx_PlayerBreath2		= LoadSound("Incbin::assets/sfx/playerBreathe2.wav")
	Sfx_PlayerStep1		= LoadSound("Incbin::assets/sfx/playerStep1.wav")
	Sfx_PlayerStep2		= LoadSound("Incbin::assets/sfx/playerStep2.wav")
	SetChannelVolume Chn_PlayerSteps, 0.3 

	Sfx_CrawlerDie = LoadSound("incbin::assets/sfx/crawlerDie.wav")
	
End Function


