package {

	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.display.*;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.utils.*;
	public class XMLfoto extends MovieClip {
		public var logoList:XML;
		public var logoContainer:MovieClip;
		public var logoLoader:URLLoader;
		public var logoTween:Tween;
		public var logoCount:Number=2;
		public var logoIncrement:Number=0;
		public var logoTimer:Timer;
		public var logoXMove:Tween;
		//Set values
		public var timerLength:Number=10000;

		public function XMLfoto() {

			var logoFeedpath:String="fotoFeed.xml";


			logoList=new XML;
			logoList.ignoreWhite=true;

			logoLoader=new URLLoader(new URLRequest(logoFeedpath));
			logoLoader.addEventListener(Event.COMPLETE,XMLLoaded);

			logoContainer=new MovieClip ;
			logoContainer.graphics.drawRect(10, 10, 270, 180);
			addChild(logoContainer);

			logoTimer=new Timer(timerLength);
			logoTimer.addEventListener("timer",logomoveNext);
			logoTimer.start();

		}

		function XMLLoaded(event:Event):void {
			logoList=XML(logoLoader.data);
			trace(logoList);

		}


		function logomoveNext(TimerEvent):void {
			var logoURL:String;
			var logoURLReq:URLRequest;
			var logoImgLoad:Loader;

			logoImgLoad=new Loader;
			logoURL=logoList.*[logoIncrement].@["preview"];
			logoURLReq=new URLRequest(logoURL);
			logoImgLoad.load(logoURLReq);
			logoContainer = MovieClip(logoImgLoad.content);

			logoXMove=new Tween(logoContainer, "x", Regular.easeOut, -300, logoContainer.x, 1, true);
			logoTween=new Tween(logoContainer, "alpha", Regular.easeInOut, 0, 1, 1, true);
			logoTimer=new Timer(timerLength,1);

			logoIncrement=(logoIncrement +1)%logoCount;

			logoTween=new Tween(logoContainer, "alpha",Regular.easeInOut, 1, 0, 1, true);
			logoXMove=new Tween(logoContainer, "x", Regular.easeOut, logoContainer.x, 300, 1, true);

		}
	}
}