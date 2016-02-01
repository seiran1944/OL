package Spark.SoarVision.single
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import Spark.SoarVision.interfaces.ITape;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.08.23.16.50
		@documentation 使用MovieClip型態的單一素材動態處理原型
	 */
	public class  MovieClipVision extends MovieClip implements ITape
	{
		
		protected var _bmShow:Bitmap;
		protected var _arrSource:Array;
		protected var _long:int;
		protected var _position:int;
		protected var _runSpeed:uint;
		protected var _status:String;
		protected var _once:Boolean;
		protected var _reverse:Boolean;
		private var _ID:String;
		private var _runWay:Function;
		
		
		public function MovieClipVision(ID:String,pixelSnapping:String="auto",smoothing:Boolean=false):void
		{
			this._bmShow = new Bitmap(null,pixelSnapping,smoothing);
			addChild(this._bmShow);
			this._ID = ID;
		}
		
		//起始與修改時
		public function VisionContent(source:Array,status:String,once:Boolean,reverse:Boolean,motionTimes:uint):void
		{
			this.VisionInfo(status, once, reverse, motionTimes);
			if(source!=null) this.VisionImage(source);
		}
		
		public function VisionInfo(status:String,once:Boolean,reverse:Boolean,motionTimes:uint):void
		{
			this._status = status;
			this._once = once;
			this._reverse = reverse;
			this._runSpeed = motionTimes;
		}
		
		public function VisionImage(value:Array):void
		{
			this._arrSource = value;
			this._long = value.length;
			this._position = !this._reverse ? 1 : this._long ;//圖片張數
			this._bmShow.bitmapData = this._arrSource[this._position-1];//陣列位置
		}
		
		public function get VisionRunner():Object {return this._bmShow;}
			
		public function get VisionStatus():String {return this._status;}
		public function set VisionStatus(value:String):void {this._status = value;}
		
		public function get VisionID():String {return this._ID;}
		
		public function get VisionSpeed():uint { return this._runSpeed; }
		public function set VisionSpeed(value:uint):void{this._runSpeed=value;}
		
		public function get VisionRun():Function { return this._runWay; }
		public function set VisionRun(value:Function):void{this._runWay = value;}
		
		public function get VisionLong():int {return this._long;}
		public function set VisionLong(value:int):void {this._long = value;}
		
		public function get VisionPosition():int {return this._position;}
		public function set VisionPosition(value:int):void {this._position = value;}
		
		public function get VisionOnce():Boolean {return this._once;}
		public function set VisionOnce(value:Boolean):void{ this._once = value; }
		
		public function get VisionReverse():Boolean {return this._reverse;}
		public function set VisionReverse(value:Boolean):void { this._reverse = value; }
		
		public function get VisionSource():Array {return this._arrSource;}
		
		
		public function VisionDestroy():void
		{
			if(this.contains(this._bmShow)) removeChild(this._bmShow);
			this._bmShow.bitmapData = null;
			this._bmShow = null;
			this._arrSource = null;
			this._runWay = null;
		}
		
		
	}
	
}