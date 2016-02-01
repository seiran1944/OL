package Spark.SoarVision.interfaces
{
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 圖示播放用(多素材)
	 */
	public interface IMultiTape 
	{
		
		function VisionCmd(cmd:Object):void;
		
		function VisionOrder(cmd:String):void;
		
		function get Command():String;
		
		function get VisionThreshold():int ;
		
	}
	
}