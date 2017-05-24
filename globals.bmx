


'Media Images
Global Img_EnemyCrawlerWalk:Timage[8]
Global Img_EnemyCrawlerAttack:Timage[8]
Global Img_EnemyCrawlerDie:Timage[8]
Global Img_EnemyCrawlerCorpse:Timage

Global Img_EnemyCrawlerEliteWalk:Timage[8]
Global Img_EnemyCrawlerEliteAttack:Timage[8]
Global Img_EnemyCrawlerEliteDie:Timage[8]
Global Img_EnemyCrawlerEliteCorpse:Timage

Global Img_Ground1:Timage
Global Img_Health:Timage
Global Img_WrongWayArrow:Timage

Global Img_PlayerStand:Timage[8]
Global Img_PlayerRun:Timage[8]

Global Img_Shot:Timage
Global Img_LightRadius:Timage

Global Img_Scan:Timage
Global Img_Scan1:Timage
Global Img_BloodSpatterRed:Timage
Global Img_BloodSpatterGreen:Timage
Global Img_DeathSpatterRed:Timage
Global Img_DeathSpatterGreen:Timage


'Media Sfx
'Channel
Global Chn_PlayerDie:TChannel = AllocChannel()
Global Chn_PlayerGetHitten:TChannel = AllocChannel()
Global Chn_PlayerShot:TChannel = AllocChannel()
Global Chn_CrawlerDie:TChannel = AllocChannel()
Global Chn_PlayerBreathing:TChannel = AllocChannel()
Global Chn_PlayerSteps:TChannel = AllocChannel()

'wav
Global Sfx_PlayerDie:TSound
Global Sfx_PlayerGetHitten1:TSound
Global Sfx_PlayerGetHitten2:TSound
Global Sfx_PlayerGetHitten3:TSound
Global Sfx_PlayerShot1:TSound
Global Sfx_CrawlerDie:TSound
Global Sfx_PlayerGasp1:TSound
Global Sfx_PlayerGasp2:TSound
Global Sfx_PlayerBreath1:TSound
Global Sfx_PlayerBreath2:TSound
Global Sfx_PlayerStep1:TSound
Global Sfx_PlayerStep2:TSound


'TLists
Global Lst_ObjectList:TList = New TList
Global Lst_DetailList:TList = New TList
Global Lst_ScanList:TList   = New TList
Global Lst_BloodSpatterList:TList = New TList
Global Lst_DeathSpatterList:TList = New TList

'Timer
Global Tmr_FpsTimer:Ttimer = CreateTimer(24)

' Millisecunden
Global MilliSec:Float


'Tasten
Global MouseXVal:Float
Global MouseYVal:Float
Global MouseDown_Left:Int
Global MouseDown_Right:Int
Global MouseDown_Mid:Int

Global KeyDown_W:Int
Global KeyDown_A:Int
Global KeyDown_S:Int
Global KeyDown_D:Int

Global KeyDown_UP:Int
Global KeyDown_Left:Int
Global KeyDown_Down:Int
Global KeyDown_Right:Int


'Map
Global MapX:Int, MapY:Int, WorldSize:Int = 1500
Global ShakeScreenCounter:Int, ShakeScreenOffset:Int

'Screen
Global ScreenWidth:Int = 1024, ScreenHeight:Int = 768
Global ScreenMidX:Int = ScreenWidth/2
Global ScreenMidY:Int = ScreenHeight/2


'Scanner
Global ScannerRot:Int
Global ScannerX:Float = ScreenWidth - 140
Global ScannerY:Float = 140
Global ScannerScale:Float = 1




