
Type TFps   

   Field Old:Int
   Field Fps:Int

   Field count:Int
   Field time:Int
   
   Field timer:TTimer

   Function Create:TFps()
   
      Local n:TFps = New TFps
      
         n.timer = CreateTimer(1)
         
      Return n
   
   EndFunction
   
   Method Reset()
   
      time = 0
      count = 0
      fps = 0
      old = 0
   
   EndMethod
   
   Method Update()
   
   count:+ 1
   time = TimerTicks(timer) Mod 2
   
      If time <> old Then
         fps = count
         count = 0
         old = time
      EndIf
   
   EndMethod
   
   Method Get:Int()
   
      Return fps
   
   EndMethod

EndType
