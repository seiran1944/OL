package Spark.SoarVision.multiple
{
	import Spark.ErrorsInfo.ErrorMessage.MessageTool;
	import Spark.SoarVision.interfaces.IMultiTape;
	import Spark.SoarVision.interfaces.ITape;
	import Spark.SoarVision.single.MovieClipVision;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version  #12.08.23.16.50
		@documentation 使用MovieClip型態的多素材動態處理原型
	 */
	public class MultiMovieClipVision extends MovieClipVision implements ITape ,IMultiTape
	{
		
		protected var _objCmd:Object;
		protected var _threshold:int;
		protected var _cmd:String;
		
		public function MultiMovieClipVision(ID:String,pixelSnapping:String="auto",smoothing:Boolean=false):void
		{
			super(ID,pixelSnapping,smoothing);
		}
		
		public function VisionCmd(cmd:Object):void
		{
			this._objCmd = cmd;
		}
		
		public function VisionOrder(cmd:String):void
		{
			if (cmd in this._objCmd) {
				this._cmd = cmd;
				var info:Object = this._objCmd[cmd];
				this._threshold = info["op"];
				this._long = info["ed"];
				this._position = !this._reverse ? this._threshold : this._long ;
				this._bmShow.bitmapData = this._arrSource[this._position-1];
			}else {//查無輸入指令
				MessageTool.InputMessageKey(123);
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