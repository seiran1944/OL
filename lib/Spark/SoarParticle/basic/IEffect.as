package Spark.SoarParticle.basic
{
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation Effect basic
	 */
	public interface IEffect 
	{
		
		function Destroy():void;
		
		function Start(times:Number = 0):void;
		
		function get GetName():String;
		
		function set x(value:Number):void;//方便型態操作
		
		function set y(value:Number):void;//方便型態操作
	}
	
}