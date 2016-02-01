package 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import MVCprojectOL.ViewOL.TeamUI.IActionCtrl;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 預計做下往上升的動作並加入遮罩
	 */
	public class RaiseAction implements IActionCtrl
	{
		
		private var _container:DisplayObjectContainer;
		private var _basicX:Number=100;
		private var _basicY:Number=300;
		
		private var _gapWidth:Number = 300;
		
		public function RaiseAction():void 
		{
			
		}
		
		
		public function InitContainer(container:DisplayObjectContainer):void
		{
			this._container = container;
		}
		
		public function NextPage(group:Vector.<DisplayObject>):void
		{
			var leng:int = group.length;
			
			for (var i:int = 0; i < leng; i++)
			{
				
			}
			
			
		}
		
		public function PrevPage(group:Vector.<DisplayObject>):void
		{
			
		}
		
		public function Destroy():void
		{
			
		}
		
		
	}
	
}