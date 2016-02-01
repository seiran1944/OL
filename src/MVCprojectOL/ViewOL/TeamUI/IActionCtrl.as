package MVCprojectOL.ViewOL.TeamUI
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public interface IActionCtrl  
	{
		
		function InitContainer(container:DisplayObjectContainer):void;
		
		function NextPage(group:Vector.<DisplayObject>):void;
		
		function PrevPage(group:Vector.<DisplayObject>):void;
		
		function Destroy():void;
		
		
	}
	
}