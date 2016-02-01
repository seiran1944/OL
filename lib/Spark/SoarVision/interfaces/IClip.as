package Spark.SoarVision.interfaces
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 影格播放用
	 */
		public interface IClip extends ITapeInfo
	{
		
		function get VisionSource():MovieClip;
		
		function VisionClip(value:MovieClip):void;
		
	}
	
}