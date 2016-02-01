package Spark.SoarVision.multiple
{
	//import Spark.ErrorsInfo.ErrorMessage.MessageTool;
	import Spark.ErrorsInfo.MessageTool;
	import Spark.SoarVision.interfaces.IMultiTape;
	import Spark.SoarVision.interfaces.ITape;
	import Spark.SoarVision.single.SpriteVision;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.08.23.16.50
		@documentation 使用Sprite型態的多素材動態處理原型
	 */
	public class MultiSpriteVision extends SpriteVision implements ITape ,IMultiTape
	{
		
		protected var _objCmd:Object;
		protected var _threshold:int;
		protected var _cmd:String;
		
		/**
		 * 建構新實體
		 * @param	ID 自定義名稱
		 * @param	pixelSnapping Bitmap建構時的屬性-需要可變更
		 * @param	smoothing Bitmap建構時的屬性-需要可變更
		 */
		public function MultiSpriteVision(ID:String,pixelSnapping:String="auto",smoothing:Boolean=false):void
		{
			super(ID,pixelSnapping,smoothing);
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
				this._position = !this._reverse ? this._threshold : this._long ;
				this._bmShow.bitmapData = this._arrSource[this._position-1];
			}else {//查無輸入指令
				MessageTool.InputMessageKey(805);
			}
		}
		
		//取得當前指令
		public function get Command():String
		{
			return this._cmd;
		}
		
		//取得起始圖片位置
		public function get VisionThreshold():int 
		{
			return this._threshold;
		}
		
	}
	
}