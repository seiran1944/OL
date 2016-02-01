package 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author EricHuang
	 * @version 12.10.23.10.22
	 * @FlashPlayer 11.4
	 * 
	 * 
	 */
	public class Preloader extends MovieClip 
	{
		
		//---測試---(需要修改flashVars接值的方式)
		//public var _flashVars:Object={uid:"124356",_doMain:"",_getWay:"http://lord1.runewaker.com/amfphp4/gateway.php"};
		
		//public var _flashVars:Object;
		private var _flashVars:Object
		public function Preloader() 
		{
			
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			//----93013482160707504-test
			//---kai-30313626267003155
			//-eric-34513696400048480
			//---kj-61713626266995474
			//--pala--90613696400042448
			//---KT--14813696400044708
			//--阿任---80013669471216599
			//var snd:Sound = new Sound(new URLRequest(""));
			//snd.play();
			//snd.close();
		    this._flashVars= { };
			this._flashVars.uid = (root.loaderInfo.parameters.uid==null)?"31213696400046243":root.loaderInfo.parameters.uid;
			this._flashVars._doMain = "";
			this._flashVars._getWay = (root.loaderInfo.parameters._getWay==null)?"http://ol.runewaker.com/amf/gateway":root.loaderInfo.parameters._getWay;
			this._flashVars._token = (root.loaderInfo.parameters._token==null)?"702638c36c582c844d375a0105a54916":root.loaderInfo.parameters._token;
			this._flashVars._serverTime = (root.loaderInfo.parameters._serverTime==null)?this.getUniTimeHandler():root.loaderInfo.parameters._serverTime;
			
			
			//this._flashVars = (root.loaderInfo.parameters.FlashVarsObj==null)?this._flashVars:root.loaderInfo.parameters._FlashVarsObj;
			
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO show loader
		}
		
		
		private function getUniTimeHandler():int 
		{
			var myDate:Date = new Date();

			trace(myDate+"_____VISION__201303011730");

			var unixTime:int = Math.round(myDate.getTime() / 1000);
			trace("Unix Time: "+unixTime);
			return unixTime;
		}
		
		private function ioError(e:IOErrorEvent):void 
		{
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void 
		{
			// TODO update loader
		}
		
		private function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void 
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO hide loader
			
			startup();
		}
		
		private function startup():void 
		{
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass(this._flashVars) as DisplayObject);
		}
		
	}
	
}