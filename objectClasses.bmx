


'-----------------------------------------------------------------------
'Hauptklasse für Entitys
Type tEntity
  	Field x:Float,y:Float
  	Field height:Float
  	Field rotation:Int
 	 Field speed:Float = 1

 	Method Update() Abstract
  	Method DrawBody() Abstract
  	Method DrawShadow() Abstract
	'Zum überprüfen wer hinter wem steht(ZOrder), um somit falsches einzeichnen der Objekte zu verhindern
	'Siehe Function UpdateObjects()
	'Methode muss den Namen "Compare" haben!
	Method Compare:Int(other:Object)
		If other=Null Return 0
		If y = tEntity(other).y Return 0
		If y < tEntity(other).y Then Return 1 Else Return -1
	End Method
EndType
'-----------------------------------------------------------------------



'-----------------------------------------------------------------------
'Klasse für Player

Type tPlayer Extends tEntity
	Field frame:Int = 0
  	Field frmSpeed:Int = 1
  	Field frmTimer:Int = 0
  	Field direction:Int = 0
  	Field life:Int
	Field animType:Int '0 = stand, 1 = walk
	Field shootTimer:Int = 0, shootDelay:Int = 5, canShoot:Int = 0
	Field canPlayStepSound:Int, stepSoundTimer:Int, stepSoundDelay:Int = 7
	
	Method Update()	'Abgeleitete Methode von der Klasse tEntity
    		UpdateFrames()
		UpdateDirection()	
		UpdateShootDelay()
		destroy()
		UpdatePlayStepSoundDelay()
		If MouseDown_Left = True And canShoot = 1
			Shoot(0)
			canShoot = 0
		EndIf
  	EndMethod


	'Regelt wie schnell der Gegner hintereinander schiessen kann
	Method UpdatePlayStepSoundDelay()
		stepSoundTimer:+1
    		If stepSoundTimer > stepSoundDelay
      		stepSoundTimer = 0
      		canPlayStepSound = 1
		EndIf
	EndMethod
	

	'Checkt und setzt die Animationsgeschwindigkeit der Spielerbilder
	Method UpdateFrames()
		frmTimer:+1
    		If frmTimer > frmSpeed
      		frmTimer = 0
      		frame = frame +2
      		If frame >= 19
				frame = 0
    			EndIf
		EndIf
	EndMethod
	
	Method UpdateDirection()
		If KeyDown_W Or KeyDown_UP
			y = y + speed
			animType = 1
			PlayPlayerStepSound()
		ElseIf KeyDown_S Or KeyDown_DOWN
			y = y - speed
			animType = 1
			PlayPlayerStepSound()
		EndIf
		If KeyDown_A Or KeyDown_LEFT
			x = x + speed
			animType = 1
			PlayPlayerStepSound()
		ElseIf KeyDown_D Or KeyDown_RIGHT
			x = x - speed
			animType = 1
			PlayPlayerStepSound()
		EndIf
		
		If Not KeyDown_W And Not KeyDown_A And Not KeyDown_S And Not KeyDown_D And Not KeyDown_UP And Not KeyDown_DOWN And Not KeyDown_LEFT And Not KeyDown_RIGHT
			animType = 0
		EndIf

		rotation = GetAngle((ScreenMidX - MouseXVal), (ScreenMidY - MouseYVal))
		
		direction = rotation / 45
		If Self.x > WorldSize Or Self.x < -WorldSize Or y > WorldSize Or y < -WorldSize
			SetRotation GetAngle( Self.x - (1), Self.y - (1) )+90
			SetBlend LIGHTBLEND
			SetColor 255,255,255
			SetAlpha 0.5
			SetScale 1,1
			DrawImage Img_WrongWayArrow, ScreenMidX + ((Self.x) - MapX), ScreenMidY + ((Self.y) - MapY)
		EndIf
	EndMethod
	
	
	Method PlayPlayerStepSound()
		If canPlayStepSound = 1
			Local soundRandomizer:Int = Rand(1,2)
			If soundRandomizer = 1
				PlaySound(Sfx_PlayerStep1, Chn_PlayerSteps)
			ElseIf soundRandomizer = 2
				PlaySound(Sfx_PlayerStep2, Chn_PlayerSteps)
			EndIf
			canPlayStepSound = 0
		EndIf
	EndMethod
	
	
	' Erstellen eines Schusses (siehe Type tShot)
	Method Shoot(typ:Int)
		PlaySound(Sfx_PlayerShot1, Chn_PlayerShot)
		tShot.Create:tShot(ScreenMidX + (Self.x - MapX), ScreenMidY + ((Self.y-25) - MapY), 50, typ)
	EndMethod
	
	
	'Regelt wie schnell der Spieler schiessen kann
	Method UpdateShootDelay()
		shootTimer:+1
    		If shootTimer > shootDelay
      		shootTimer = 0
      		canShoot = 1
		EndIf
	EndMethod
	
	'Zeichnet den Schatten
	Method DrawShadow()'Abgeleitete Methode von der Klasse tEntity
    		SetBlend ALPHABLEND
    		SetColor 0,0,0
    		SetAlpha 0.5
			SetScale 1, 1
    		SetRotation -30
		If Self.animType = 0
			DrawImage Img_PlayerStand[direction], ScreenMidX + ((Self.x-20) - MapX), ScreenMidY + ((Self.y-2) - MapY), frame
			
		Else
			DrawImage Img_PlayerRun[direction], ScreenMidX + ((Self.x-20) - MapX), ScreenMidY + ((Self.y-2) - MapY), frame
		EndIf
  	EndMethod
	
	'Zeichnet das eigentliche Bild
	Method DrawBody()'Abgeleitete Methode von der Klasse tEntity
		SetBlend ALPHABLEND
		SetColor 255,255,255
		SetAlpha 1
		SetScale 1,1
    		SetRotation 0
    		If Self.animType = 0
			DrawImage Img_PlayerStand[direction], ScreenMidX + (Self.x - MapX), ScreenMidY + (Self.y - MapY), frame
    		Else
			DrawImage Img_PlayerRun[direction], ScreenMidX + (Self.x - MapX), ScreenMidY + (Self.y - MapY), frame
		EndIf
  	EndMethod
	
	
	' Getter Methoden
	Method getX:Float()
		Return Self.x
	EndMethod
	
	Method getY:Float()
		Return Self.y
	EndMethod
	
	Method getLife:Int()
		Return Self.life
	EndMethod
	
	Method getRot:Int()
		Return Self.rotation
	EndMethod
	
	' Setter Methoden
	Method setLife(life:Int)
		Self.life = life
	EndMethod
	
	Method setRot(rot:Int)
		Self.rotation = rot
	EndMethod
	
	'Create
	Function Create:tPlayer(x:Float,y:Float,speed:Float, life:Int)
    		Local p:tPlayer = New tPlayer
    		p.x=x
    		p.y=y
    		p.speed = speed
    		p.height = 0
    		p.life = life
    		Lst_ObjectList.AddLast p
    		Return p
  	EndFunction
	
	'Destroy
	Method destroy()
		If life <= 0
			PlaySound(Sfx_PlayerDie,Chn_PlayerDie)
			Lst_ObjectList.Remove Self
		EndIf
	End Method
EndType
'-----------------------------------------------------------------------


'-----------------------------------------------------------------------
'Klasse für Enemy
'typ 0 = Crawler, 1 = crawlerElite, 2 = , 3 = 

Type tEnemy Extends tEntity
	Field typ:Int = 0
	Field dmg:Int = 10
	Field frame:Int = 0, frmSpeed:Int = 1, frmTimer:Int = 0, maxFrames:Int = 20
  	Field direction:Int = 0, canChangeDirection:Int, changeDirectionDelay:Int = 10, changeDirectionTimer:Int, canFollow:Int
  	Field life:Int
	Field imageWalk:Timage[8], imageAttack:Timage[8], imageCorpse:Timage
	Field animType:Int '0 = walk, 1 = attack
	Field canPlaySound:Int, playSoundTimer:Int, playSoundDelay:Int = 6
	
	Method Update() 'Abgeleitete Methode von der Klasse tEntity
    		UpdateFrames()
		UpdateChangeDirectionDelay()
		UpdateDirection()	
		UpdateCollisions()
		UpdateDealdDamage()
		UpdatePlaySoundDelay()
  	EndMethod

	'Überprüft auf Kollisionen
	Method UpdateCollisions()
		If canChangeDirection = 1
			' Self und andere Gegner
			For Local e:tEnemy = EachIn Lst_Objectlist
				If e.getX() <> Self.x And e.getY() <> Self.y
					If checkDistance(e.x, e.y, Self.x, Self.y) < 80
						canFollow = 0
						If e.getX() < Self.x Self.x:+3 Else Self.x:-3
						If e.getY() < Self.y Self.y:+3 Else Self.y:-3
						canChangeDirection = 0
					EndIf
				EndIf
			Next
			'Self und Spieler
			'Wenn Gegner mit Spieler Kollidiert -> Schaden austeilen
			For Local p:tPlayer = EachIn Lst_Objectlist
				If p.getX() <> Self.x And p.getY() <> Self.y
					If checkDistance(p.x, p.y, Self.x, Self.y) < 80
						canFollow = 0
						If p.getX() < Self.x Self.x:+3 Else Self.x:-3
						If p.getY() < Self.y Self.y:+3 Else Self.y:-3
						canChangeDirection = 0
						animType = 1 '(attack)
					Else
						animType = 0 '(walk)
					EndIf
				EndIf
			Next
		EndIf
	EndMethod
	
	' Wenn die Attack-animation die mitte erreicht hat -> schaden austeilen
	Method UpdateDealdDamage()
		For Local p:tPlayer = EachIn Lst_Objectlist
			If animType = 1 '(attack)
				'Mitte der Angriffsanimation
				If Self.frame > 7 And Self.frame < 9
					p.setLife(p.getLife()-Self.dmg)
					If canPlaySound = 1
						Local soundRandomize:Int = Rand(1,3)
						If soundRandomize = 1
							PlaySound(Sfx_PlayerGetHitten1,Chn_PlayerGetHitten)
						ElseIf soundRandomize = 2
							PlaySound(Sfx_PlayerGetHitten2,Chn_PlayerGetHitten)
						ElseIf soundRandomize = 3
							PlaySound(Sfx_PlayerGetHitten3,Chn_PlayerGetHitten)
						EndIf
						ShakeScreenCounter = 1
						tBloodSpatter.Create:tBloodSpatter(Rand(32,ScreenWidth-32), Rand(32,ScreenHeight-32), Rand(0,359), Rnd(1,5), Rnd(1,5),1)
						soundRandomize = Rand(0,8)
						If soundRandomize >= 4
							soundRandomize = Rand(1,4)
							If soundRandomize = 1
								PlaySound(Sfx_PlayerGasp1,Chn_PlayerBreathing)
							ElseIf soundRandomize = 2
								PlaySound(Sfx_PlayerGasp2,Chn_PlayerBreathing)
							ElseIf soundRandomize = 3
								PlaySound(Sfx_PlayerBreath1,Chn_PlayerBreathing)
							ElseIf soundRandomize = 3
								PlaySound(Sfx_PlayerBreath2,Chn_PlayerBreathing)
							EndIf
						EndIf
						canPlaySound = 0
					EndIf
				EndIf
			EndIf
		Next
	EndMethod
	
	'Überprüft und setzt die Animationsgeschwindigkeit der Gegnerbilder
	Method UpdateFrames()
		frmTimer:+1
    		If frmTimer > frmSpeed
      		frmTimer = 0
      		frame:+1
      		If frame = maxFrames 
				frame = 0
    			EndIf
		EndIf
	EndMethod
	
	
	'Regelt wie schnell der Gegner hintereinander seine Richtung ändern kann
	Method UpdateChangeDirectionDelay()
		changeDirectionTimer:+1
    		If changeDirectionTimer > changeDirectionDelay
      		changeDirectionTimer = 0
      		canChangeDirection = 1
			canFollow = 1
		EndIf
	EndMethod
	
	
	'Regelt wie schnell ein Sound hintereinander abgespielt werden kann
	Method UpdatePlaySoundDelay()
		playSoundTimer:+1
    		If playSoundTimer > playSoundDelay
      		playSoundTimer = 0
      		canplaySound = 1
		EndIf
	EndMethod
	
	
	Method UpdateDirection()
	If animType <> 1
		' Distanz zwischen Self und Spieler prüfen
		For Local p:tPlayer = EachIn Lst_ObjectList
			If checkDistance(p.x, p.y, Self.x, Self.y) < 400 And canFollow = 1
				'Wenn kleiner als 350, dann dreht sich Gegner zum Spieler und läuft auf ihn zu
				rotation = GetAngle(Self.x - p.x, Self.y - p.y)
				x=x+(speed*Cos(rotation-90))
    				y=y+(speed*Sin(rotation-90))
			Else
				'Andernfalls läuft Gegner ziellos im Kreis herum
				If canChangeDirection = 1
					rotation:+10
					canChangeDirection = 0
				EndIf
				If rotation < 0 rotation:+360
    				If rotation >= 360 rotation:-360
				x=x+(speed*Cos(rotation-90))
    				y=y+(speed*Sin(rotation-90))
				
			EndIf
		Next
	EndIf
	direction = rotation / 45
	If x>WorldSize x=-WorldSize
    	If x<-WorldSize x=WorldSize
    	If y>WorldSize y=-WorldSize
    	If y<-WorldSize y=WorldSize
EndMethod
	
	
	'Zeichnet den Schatten
	Method DrawShadow() 'Abgeleitete Methode von der Klasse tEntity
    		SetBlend ALPHABLEND
    		SetColor 0,0,0
		SetImageHandle Self.imageWalk[direction], ImageWidth(Self.imageWalk[direction])/2, ImageHeight(Self.imageWalk[direction]) - (ImageHeight(Self.imageWalk[direction])/4)
		SetImageHandle Self.imageAttack[direction], ImageWidth(Self.imageWalk[direction])/2, ImageHeight(Self.imageWalk[direction]) - (ImageHeight(Self.imageWalk[direction])/4)
    		SetAlpha 0.15
    		SetRotation GetAngle((MapX - Self.x) , (MapY - Self.y ))+180
		For Local p:tPlayer = EachIn Lst_ObjectList
			SetScale 1,checkDistance(p.x, p.y, Self.x, Self.y)/70
			If checkDistance(p.x, p.y, Self.x, Self.y) < 450
				If p.rotation < Self.rotation + 40 And p.rotation > Self.rotation - 40
					SetColor 0,0,0
					SetAlpha 1
				EndIf
			EndIf
		Next
		If animType = 0 'Walk
    			DrawImage Self.imageWalk[direction], (MapX-(Self.x)) + ScreenMidX, (MapY-(Self.y-40)) + ScreenMidY, frame
		ElseIf animType = 1 'Attack
			DrawImage Self.imageAttack[direction], (MapX-(Self.x)) + ScreenMidX, (MapY-(Self.y-40)) + ScreenMidY, frame
		EndIf
  	EndMethod
	
	'Zeichnet das eigentliche Bild
	Method DrawBody() 'Abgeleitete Methode von der Klasse tEntity
		SetBlend ALPHABLEND
		SetImageHandle Self.imageWalk[direction], ImageWidth(Self.imageWalk[direction])/2, ImageHeight(Self.imageWalk[direction])/2
		SetImageHandle Self.imageAttack[direction], ImageWidth(Self.imageWalk[direction])/2, ImageHeight(Self.imageWalk[direction])/2
		SetScale 1,1
		SetColor 40,40,40
		SetAlpha 0.8
		For Local p:tPlayer = EachIn Lst_ObjectList
			If checkDistance(p.x, p.y, Self.x, Self.y) < 450
				If p.rotation < Self.rotation + 40 And p.rotation > Self.rotation - 40
					SetColor 255,255,255
					SetAlpha 1
					DrawHealthBar()
				EndIf
			EndIf
		Next
    		SetRotation 0
    		If animType = 0 'Walk
    			DrawImage Self.imageWalk[direction],(MapX-Self.x) + ScreenMidX, (MapY-Self.y) + ScreenMidY, frame
		ElseIf animType = 1 'Attack
			DrawImage Self.imageAttack[direction],(MapX-Self.x) + ScreenMidX, (MapY-Self.y) + ScreenMidY, frame
		ElseIf animType = 2 'Wounded
			'DrawImage Img_EnemySkeletonWounded[direction],x, y, frame
		EndIf
  	EndMethod
	
	'Zeichnet die Healthbar des Gegners über seinen Kopf ein (siehe DrawBody())
	Method DrawHealthBar()
		SetScale life/2,1
		DrawImage Img_Health,(MapX-Self.x) + ScreenMidX, (MapY-(Self.y+64)) + ScreenMidY
		SetScale 1,1
	EndMethod
	
	
	' Getter Methoden
	Method getX:Float()
		Return Self.x
	EndMethod
	
	Method getY:Float()
		Return Self.y
	EndMethod
	Rem
	Method getImage:Timage()
		Return Self.image[direction]
	EndMethod
	EndRem
	Method getFrame:Int()
		Return Self.frame
	EndMethod
	
	Method getLife:Int()
		Return Self.life
	EndMethod
	
	Method getRot:Int()
		Return Self.rotation
	EndMethod
	
	' Setter Methoden
	Method setLife(life:Int)
		Self.life = life
	EndMethod
	
	Method setRot(rot:Int)
		Self.rotation = rot
	EndMethod


	Method setEnemyType()
		If Self.typ = 0 ' Crawler
			For Local i:Int = 0 To 7
				Self.imageWalk[i] = Img_EnemyCrawlerWalk[i]
				Self.imageAttack[i] = Img_EnemyCrawlerAttack[i]
				Self.imageCorpse = Img_EnemyCrawlerCorpse
				Self.dmg = 5
				Self.life = 40
				Self.speed = Rand(4,6)
			Next
		ElseIf Self.typ = 1 ' CrawlerElite
			For Local i:Int = 0 To 7
				Self.imageWalk[i] = Img_EnemyCrawlerEliteWalk[i]
				Self.imageAttack[i] = Img_EnemyCrawlerEliteAttack[i]
				Self.imageCorpse = Img_EnemyCrawlerEliteCorpse
				Self.dmg = 10
				Self.life = 100
				Self.speed = Rand(6,9)
			Next
		EndIf
	EndMethod


	'Create
	Function Create:tEnemy(x:Float,y:Float, typ:Int)
    		Local e:tEnemy = New tEnemy
    		e.x=x
    		e.y=y
    		e.rotation = Rand(0,360)
		e.typ = typ
		e.setEnemyType()
    		Lst_ObjectList.AddLast e
    		Return e
  	EndFunction
	
	'Destroy
	Method destroy()
		ShakeScreenCounter = 1
		tBloodSpatter.Create:tBloodSpatter(Rand(32,ScreenWidth-32), Rand(32,ScreenHeight-32), Rand(0,359), Rnd(0.5,3), Rnd(0.5,3), 2)
		PlaySound(Sfx_CrawlerDie, Chn_CrawlerDie)
		tDeathSpatter.Create:tDeathSpatter(Self.x , Self.y , Rand(0,360), 2)
		tCorpse.Create:tCorpse(Self.x , Self.y , Rand(0,360), Self.imageCorpse)
		If Self.typ = 0 tEnemy.Create:tEnemy(Rand(-WorldSize,WorldSize),Rand(-WorldSize,WorldSize),0) Else tEnemy.Create:tEnemy(Rand(-WorldSize,WorldSize),Rand(-WorldSize,WorldSize),1)
		Lst_ObjectList.Remove Self
	End Method
	
EndType
'-----------------------------------------------------------------------





'-----------------------------------------------------------------------
'Klasse für den Schuss
' typ 0 = normaler Schuss, typ 1 = Rakete

Type tShot Extends tEntity

	Field typ:Int, dmg:Int, setDirection:Float = 1
	Field image:Timage
	'0 = up, 1 = down
	Field direction:Int 
	
	
	
	Method Update()	
		UpdateDirection()	
		UpdateCollisions()
  	EndMethod


	Method UpdateDirection()
		If setDirection = 1
			
			Local rot:Int = ATan((Self.x - MouseXVal) / (Self.y - MouseYVal))
			If rot <> 90 And rot <> -90 rotation = rot
			If Self.y > MouseYVal
				direction = 1
			ElseIf Self.y < MouseYVal
				direction = 0
			EndIf
			setDirection = 0
		EndIf
		If direction = 1
			x=x+(speed*Cos(rotation+90))
    			y=y-(speed*Sin(rotation+90))
		ElseIf direction = 0
			x=x-(speed*Cos(rotation+90))
    			y=y+(speed*Sin(rotation+90))
		EndIf
		
		If Self.x < 0 Then Self.destroy()
		If Self.x > ScreenWidth Then Self.destroy()
		If Self.y < 0 Then Self.destroy()
		If Self.y > ScreenHeight Then Self.destroy()	
	EndMethod
	
	Method UpdateCollisions()
		' Self mit Enemy 
		For Local e:tEnemy = EachIn Lst_ObjectList
			If checkDistance(Self.x , Self.y , (MapX-e.x) + ScreenMidX , (MapY-e.y) + ScreenMidY ) < 50
				e.setLife(e.getLife() - Self.dmg)
				If e.getlife() <= 0 e.destroy()
				Self.destroy()
			EndIf
		Next
	EndMethod
	
	
	'Überprüft und gibt die Distanz zwischen 2 Punkten zurück
	Method checkDistance:Float(x1:Float, y1:Float, x2:Float, y2:Float)
		Return Sqr((x1 - x2)^2 + (y1-y2)^2)
	EndMethod
	
	
	'Zeichnet den Schatten
	Method DrawShadow()
    		SetBlend ALPHABLEND
    		SetColor 0,0,0
		SetScale 1,1
    		SetAlpha 0.5
    		SetRotation -30
		If typ = 0
    			DrawImage Self.image,x-15, y-2
		Else
			'DrawImage Img_Missile,x-15, y-2
		EndIf
  	EndMethod
	
	'Zeichnet das eigentliche Bild
	Method DrawBody()
		SetBlend ALPHABLEND
		SetColor 255,255,255
		SetScale 1,1
		SetAlpha 1
    		SetRotation 0
    		DrawImage Self.image,x, y
  	EndMethod
	
	'Getter Methoden
	Method getX:Float()
		Return Self.x
	EndMethod
	
	Method getY:Float()
		Return Self.y
	EndMethod
	
	Method getDmg:Int()
		Return Self.dmg
	EndMethod
	
	Method getImage:Timage()
		Return Self.image
	EndMethod

	' Create
	Function Create:tShot(x:Float,y:Float,speed:Float, typ:Int)
		SeedRnd MilliSecs()
    		Local s:tShot = New tShot
    		s.x=x
    		s.y=y
    		s.speed = speed
		s.typ = typ
    		s.height = 0
		s.dmg = 10
		If typ = 0
    			s.image = Img_Shot
		Else
			's.image = Img_Missile
		EndIf
    		Lst_ObjectList.AddLast s
    		Return s
  	EndFunction

	' Destroy
	Method destroy()
		Lst_ObjectList.Remove Self
	End Method

EndType









