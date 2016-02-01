package Spark.SoarVision.extra
{
	import flash.display.MovieClip;
	import Spark.SoarVision.interfaces.IClip;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.08.31.15.50
		@documentation MovieClip掛載影格播放-整串播放模式
	 */
	public class ExtraMovieClipVision implements IClip
	{
		
		protected var _imbedClip:MovieClip;
		protected var _long:int;
		protected var _position:int;
		protected var _runSpeed:uint;
		protected var _status:String;
		protected var _once:Boolean;
		protected var _reverse:Boolean;
		private var _ID:String;
		private var _runWay:Function;
		
		/**
		 * 建構實體
		 * @param	ID 自定義名稱
		 * @param	imbedClip 需被驅動的MovieClip影格對象掛載
		 */
		public function ExtraMovieClipVision(ID:String,imbedClip:MovieClip):void
		{
			this._ID = ID;
			this._imbedClip = imbedClip;
			this._long = imbedClip.totalFrames;
		}
		
		//寫入影格播放實體
		public function VisionClip(value:MovieClip):void 
		{
			this._imbedClip = value;
			this._long = value.totalFrames;
			this._position = !this._reverse ? 1 : this._long;
			//trace("visionClip", this._position);
			this._imbedClip.gotoAndStop(this._position);
		}
		
		//寫入INFO
		public function VisionInfo(status:String, once:Boolean, reverse:Boolean, motionTimes:uint):void
		{
			this._status = status;
			this._once = once;
			this._reverse = reverse;
			this._runSpeed = motionTimes;
			this._position = !reverse ? 1 : this._long;
			//trace("visionClip", this._position);
			
			this._imbedClip.gotoAndStop(this._position);
		}
		
		public function get VisionRunner():Object {return this._imbedClip;}
		
		public function get VisionStatus():String { return this._status; }
		public function set VisionStatus(value:String):void {this._status = value;}
		
		public function get VisionID():String {return this._ID;}
		
		public function get VisionSpeed():uint {return this._runSpeed;}
		public function set VisionSpeed(value:uint):void{this._runSpeed=value;}
		
		public function get VisionRun():Function {return this._runWay;}
		public function set VisionRun(value:Function):void{this._runWay = value;}
		
		public function get VisionLong():int {return this._long;}
		public function set VisionLong(value:int):void {this._long = value;}
		
		public function get VisionPosition():int {return this._position;}
		public function set VisionPosition(value:int):void {this._position = value;}
		
		public function get VisionOnce():Boolean { return this._once; }
		public function set VisionOnce(value:Boolean):void{ this._once = value; }
		
		public function get VisionReverse():Boolean { return this._reverse; }
		public function set VisionReverse(value:Boolean):void { this._reverse = value; }
		
		public function get VisionSource():MovieClip
		{
			return this._imbedClip;
		}
		
		public function VisionDestroy():void
		{
			this._imbedClip = null;
			this._runWay = null;
		}
		
		
	}
	
}