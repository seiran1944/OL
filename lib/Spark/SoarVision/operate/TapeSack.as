package Spark.SoarVision.operate
{
	import Spark.SoarVision.interfaces.ITapeInfo;
	import Spark.SoarVision.operate.TapeReader;
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.08.27.16.35
		@documentation 運行不同速率包裝處理
	 */
	public class TapeSack 
	{
		
		private var _reader:TapeReader;
		public var _tape:ITapeInfo;
		
		public function TapeSack(tape:ITapeInfo,reader:TapeReader):void
		{
			this._reader = reader;
			this._tape = tape;
		}
		
		public function Reading():void
		{
			this._reader.Read(this._tape);
		}
		
		public function Destroy():void
		{
			this._reader = null;
			this._tape = null;
		}
		
		
		
	}
	
}