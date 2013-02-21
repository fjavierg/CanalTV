   package {

      import flash.display.*;
	  import flash.net.URLRequest;
	  import flash.events.*;
	  

      public class Main extends MovieClip {
            
		public var thisLoader:Loader = new Loader();
		public var thisMC:MovieClip = new MovieClip();
		public var clips:Array = ["perra.swf", "Sabias.swf", "RSSreader_v2.swf",  "MyWeather3.swf"];
		public var index:int = 0;
			
		public function Main() {

			stage.addChild(thisMC); // Add empty MC initially so the nextClip function works even on first call 

			thisLoader.contentLoaderInfo.addEventListener(Event.INIT, doneLoading);
			thisLoader.load(new URLRequest(clips[index]));

			stage.addEventListener(MouseEvent.CLICK ,boton);
			
          }
		 
		function doneLoading(e:Event):void {
			stage.removeChild(thisMC);
			thisMC = MovieClip(thisLoader.content);
			thisLoader.unload();
			stage.addChild(thisMC);
			thisMC.gotoAndPlay(1);
			thisMC.addEventListener(Event.ENTER_FRAME,Frame);
		}
		 

		function boton(evt:MouseEvent):void {
			nextClip();
		}
		 
		function nextClip():void {
			trace("Event");
			index = (index + 1)%(clips.length);
			thisLoader.load( new URLRequest(clips[index]) );
		}

		//*********Varias funciones utiles 
		

		function Frame(evt:Event):void {
			trace("Current Frame is " + thisMC.currentFrame + ".");
			if (thisMC.currentFrame == thisMC.totalFrames) {
				thisMC.removeEventListener(Event.ENTER_FRAME, Frame);
				nextClip();
			}
		 }
		 
		function showChildren(dispObj:*):void {
			for (var i:int = 0; i< dispObj.numChildren; i++) {
			var obj:DisplayObject = dispObj.getChildAt(i);
			if (obj is DisplayObjectContainer) {
			trace(obj.name, obj);
			showChildren(obj);
		         } else {
		             trace(obj);
		         }
		     }
		 }
		function info():void {
	      trace("The main movie has " + scenes.length + " scenes.");
	      trace("The current scene is '" + currentScene.name + "'.");
	      trace("It has " + currentScene.numFrames + " frame(s),");
   		  trace("  and " + currentScene.labels.length + " label(s). ");
		}

       }
  }