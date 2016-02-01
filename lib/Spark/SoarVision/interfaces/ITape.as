package Spark.SoarVision.interfaces
{
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 圖示播放用(單素材)
	 */
	public interface ITape extends ITapeInfo
	{
		
		function get VisionSource():Array;
		
		function VisionImage(value:Array):void;
		
		function VisionContent(source:Array, status:String, once:Boolean, reverse:Boolean, motionTimes:uint):void;
		
	}
	
}