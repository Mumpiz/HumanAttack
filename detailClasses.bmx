

'Hauptklasse für Details
Type tDetail
  	Field x:Float,y:Float

 	Method Update() Abstract
  	Method DrawBody() Abstract
  	Method DrawShadow() Abstract
	'Zum überprüfen wer hinter wem steht(ZOrder), um somit falsches einzeichnen der Objekte zu verhindern
	'Siehe Function UpdateDetails()
	'Methode muss den Namen "Compare" haben!
	Method Compare:Int(other:Object)
		If other=Null Return 0
		If y = tDetail(other).y Return 0
		If y < tDetail(other).y Then Return 1 Else Return -1
	End Method
EndType



Type tCorpse Extends tDetail
	Field image:Timage
	Field frame:Int
	Field rotation:Int
	Field rot:Int


	Method Update() 'Abgeleitete Methode von der Klasse tDetail
	EndMethod
	
	
	Method DrawShadow()
	EndMethod
	
	'Zeichnet das eigentliche Bild
	Method DrawBody()'Abgeleitete Methode von der Klasse tDetail
    		SetRotation rotation
		SetBlend ALPHABLEND
		SetImageHandle Self.image, 64, 64
		SetScale 1,1
		SetColor 50,50,50
		SetAlpha 0.8
		For Local p:tPlayer = EachIn Lst_ObjectList
			rot = GetAngle( Self.x - p.x , Self.y - p.y )
			If checkDistance(p.x, p.y, Self.x, Self.y) < 450
				If p.rotation < Self.rot + 40 And p.rotation > Self.rot - 40
					SetColor 255,255,255
					SetAlpha 0.8
				EndIf
			EndIf
		Next
    		DrawImage Self.image, (MapX-Self.x) + ScreenMidX, (MapY-Self.y) + ScreenMidY, frame
  	EndMethod

	'Create
	Function Create:tCorpse(x:Float,y:Float,rot:Int, img:Timage)
    		Local c:tCorpse = New tCorpse
    		c.x=x
    		c.y=y
		c.image = img
    		c.rotation = rot
    		Lst_DetailList.AddLast c
    		Return c
  	EndFunction
	
	'Destroy
	Method destroy()
		Lst_DetailList.Remove Self
	End Method
EndType



Type tBloodSpatter
	Field x:Int, y:Int
	Field alpha:Float = 1.0
	Field rotation:Int
	Field scaleX:Float, scaleY:Float
	Field color:Int
	Field image:Timage
	
	
	Method Update()
		alpha:-0.005
		If alpha <=0
			Self.destroy()
		Else
			SetAlpha Self.alpha
		EndIf
	EndMethod
	
	Method Draw()
		SetBlend ALPHABLEND
		SetAlpha Self.alpha
		SetRotation Self.rotation
		SetScale Self.scaleX, Self.scaleY
		SetColor 255,255,255
		If Self.color = 1
			DrawImage Img_BloodSpatterRed, Self.x, Self.y
		ElseIf Self.color = 2
			DrawImage Img_BloodSpatterGreen, Self.x, Self.y
		ElseIf Self.color = 3
			'DrawImage Img_BloodSpatterBlue, Self.x, Self.y
		EndIf
	EndMethod
	
	Function Create:tBloodSpatter(x:Int, y:Int, rot:Int, scaleX:Float, scaleY:Float, color:Int)
		Local b:tBloodSpatter = New tBloodSpatter
		b.x = x
		b.y = y
		b.rotation = rot
		b.scaleX = scaleX
		b.scaleY = scaleY
		b.color = color
		Lst_BloodSpatterList.AddLast b
	EndFunction
	
	Method destroy()
		Lst_BloodSpatterList.remove Self
	EndMethod
EndType


Type tDeathSpatter
	Field x:Int, y:Int
	Field rotation:Int
	Field frmTimer:Int, frmSpeed:Int, frame:Int
	Field typ:Int
	Field image:Timage
	
	
	Method Update()
		UpdateFrames()
	EndMethod
	
	Method Draw()
		SetBlend ALPHABLEND
		SetRotation Self.rotation
		SetColor 255, 255, 255
		SetScale 2, 2
		DrawImage Self.image, (MapX-Self.x) + ScreenMidX, (MapY-Self.y) + ScreenMidY, frame
	EndMethod
		
	Method UpdateFrames()
		frmTimer:+1
    		If frmTimer > frmSpeed
      		frmTimer = 0
      		frame:+1
      		If frame = 10
				frame = 0
				Self.destroy()
    			EndIf
		EndIf
	EndMethod
	
	Function Create:tDeathSpatter(x:Int, y:Int, rotation:Int, typ:Int)
		Local ds:tDeathSpatter = New tDeathSpatter
		ds.x = x
		ds.y = y
		ds.rotation = rotation
		ds.typ = typ
		If ds.typ = 1
			ds.image = Img_DeathSpatterRed
		ElseIf ds.typ = 2
			ds.image = Img_DeathSpatterGreen
		ElseIf ds.typ = 3
			'ds.image = Img_DeathSpatterBlue
		EndIf
		Lst_DeathSpatterList.AddLast ds
	EndFunction
	
	Method destroy()
		Lst_DeathSpatterList.Remove Self
	EndMethod
EndType
	

Type tScannedObject
 	Field alpha:Float, x:Float, y:Float, typ:Int
  	Method Update(cx:Int, cy:Int)
    		alpha:-0.05
    		If alpha < 0
      		Lst_ScanList.Remove Self
    		Else
      		SetAlpha alpha
      		DrawRect cx+x,cy+y,3,3
    		EndIf
  	EndMethod
  	Function Create:tScannedObject(x:Int, y:Int, typ:Int )
    		Local so:tScannedObject = New tScannedObject
    		so.x=x
    		so.y=y
    		so.typ=typ
    		so.alpha=0.8
    		Lst_ScanList.AddLast so
  	EndFunction
EndType










