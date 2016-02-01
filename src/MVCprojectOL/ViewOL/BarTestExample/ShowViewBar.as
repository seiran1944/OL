package MVCprojectOL.ViewOL.BarTestExample
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import Spark.coreFrameWork.View.ViewCtrl;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class ShowViewBar extends ViewCtrl 
	{
	     
		public function ShowViewBar(_conter:DisplayObjectContainer=null) 
		{
			
		     super("testBarProxy",_conter);
			
		}
		
		
		public function AddBar(_pic:DisplayObject):void 
		{
			this._viewConterBox.addChild(_pic);
		}
		
		
		
	}
	
}