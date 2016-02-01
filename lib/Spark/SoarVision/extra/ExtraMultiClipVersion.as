package Spark.SoarVision.extra
{
	import flash.display.MovieClip;
	import Spark.ErrorsInfo.ErrorMessage.MessageTool;
	import Spark.SoarVision.extra.ExtraMovieClipVision;
	import Spark.SoarVision.interfaces.IClip;
	import Spark.SoarVision.interfaces.IMultiTape;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.08.31.15.50
		@documentation MovieClip掛載影格播放-區段播放模式
	 */
		public class ExtraMultiClipVersion extends ExtraMovieClipVision implements IClip , IMultiTape
	{
		
		protected var _objCmd:Object;
		protected var _threshold:int;
		protected var _cmd:String;
		
		public function ExtraMultiClipVersion(ID:String,imbedClip:MovieClip):void
		{
			super(ID, imbedClip);
		}
		
		override public function VisionClip(value:MovieClip):void 
		{
			this._imbedClip = value;
			if (this._objCmd == null) this._long = this._imbedClip.totalFrames;
			this._position = !this._reverse ? this._objCmd == null ?  1 : this._threshold : this._long;
			//trace("visionClip", this._position);
			this._imbedClip.gotoAndStop(this._position);
		}
		
		override public function VisionInfo(status:String, once:Boolean, reverse:Boolean, motionTimes:uint):void
		{
			this._status = status;
			this._once = once;
			this._reverse = reverse;
			this._runSpeed = motionTimes;
			this._position = !reverse ? this._objCmd == null ?  1 : this._threshold : this._long ;
			//trace("VisionInfo", this._position);
			this._imbedClip.gotoAndStop(this._position);
		}
		
		//寫入指令集
		public function VisionCmd(cmd:Object):void
		{
			this._objCmd = cmd;
		}
		
		//變更指令
		public function VisionOrder(cmd:String):void
		{
			if (cmd in this._objCmd) {
				this._cmd = cmd;
				var info:Object = this._objCmd[cmd];
				this._threshold = info["op"];
				this._long = info["ed"];
				this._position = !this._reverse ? this._threshold : this._long;
				this._imbedClip.gotoAndStop(this._position);
			}else {//查無輸入指令
				MessageTool.InputMessageKey(805);
			}
		}
		
		public function get Command():String
		{
			return this._cmd;
		}
		
		public function get VisionThreshold():int
		{
			return this._threshold;
		}
		
		
	}
	
}