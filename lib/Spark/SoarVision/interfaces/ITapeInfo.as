package Spark.SoarVision.interfaces
{
	
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public interface ITapeInfo extends ITapeBasic
	{
		function get VisionRunner():Object;//取得成像物
		
		function get VisionRun():Function;
		function set VisionRun(value:Function):void
		
		function get VisionLong():int;
		function set VisionLong(value:int):void;
		
		function get VisionPosition():int;
		function set VisionPosition(value:int):void;
		
		function get VisionOnce():Boolean;
		function set VisionOnce(value:Boolean):void;
		
		function get VisionReverse():Boolean;
		function set VisionReverse(value:Boolean):void;
		
		function get VisionSpeed():uint;
		function set VisionSpeed(value:uint):void;
		
		function VisionDestroy():void;
		
		function VisionInfo(status:String, once:Boolean, reverse:Boolean, motionTimes:uint):void;
	}
	
}