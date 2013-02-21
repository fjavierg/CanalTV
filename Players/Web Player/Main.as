package {

	import flash.display.*;
	import flash.net.*;
	import flash.events.*;


	public class Main extends MovieClip {

		public var xmlData:XML = new XML();
		public var loaderObject:URLLoader = new URLLoader();
		public var thisLoader:Loader = new Loader();
		public var thisMC:MovieClip = new MovieClip();

		public var clips:Array = ["RSSreader_v2.swf","Sports.swf", "Sabias.swf", "Fotos_blur.swf", "Perra.swf", "MyWeather3.swf"];
		public var index:int = 0;

		public function Main() {

			stage.addChild(thisMC);// Add empty MC initially so the nextClip function works even on first call 

			// Load the playlist.xml file.
			loaderObject.addEventListener(Event.COMPLETE, playlistHandler);
			loaderObject.load(new URLRequest("playlist.xml"));

		}

		// After the playlist xml file has loaded, 
		function playlistHandler(eventObj:Event):void {

			xmlData = XML(loaderObject.data);
			//Now start loading the first clip
			thisLoader.contentLoaderInfo.addEventListener(Event.INIT, doneLoading);
			thisLoader.load(new URLRequest(xmlData..item.link[index]));
			// Add click event for next clip
			stage.addEventListener(MouseEvent.CLICK ,boton);
			'trace (xmlData);';

		}
		// After loading the first clip add it to the stage and play
		//
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
			trace("Next Clip");
			index++;
			if (index == xmlData..item.link.length()) {
				index = 0;
			}
			thisLoader.load( new URLRequest(xmlData..item.link[index]) );
		}

		//*********Varias funciones utiles 

		function Frame(evt:Event):void {
			//trace("Current Frame is " + thisMC.currentFrame + " of total " + thisMC.totalFrames );
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