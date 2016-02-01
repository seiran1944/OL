package MVCprojectOL.ViewOL.ExampleAllPanel
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import MVCprojectOL.ViewOL.AllinOnePanel;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class BasicBgPanelAAA extends AllinOnePanel
	{
		
		private var _bg:Bitmap;
		private var _conterBox:Sprite;
		private var _displayLayer:DisplayObjectContainer;
		public function BasicBgPanelAAA(_viewConter:DisplayObjectContainer,_name:String) 
		{
			this._displayLayer = _viewConter;
			this._conterBox = new Sprite();
			
			super(this._conterBox,_name);
		}
		
		
		
		override public function AddBG(_pic:*):void 
		{
			if (_pic is BitmapData) {
				this._bg = new Bitmap(_pic);
			    this._conterBox .addChild(this._bg);
			    this._displayLayer.addChild(this._conterBox);
			}
			
		}
		
		
		//----you can do anything-------
		override protected function PublicSystemHandler(_key:String,_obj:Object=null):void 
		{
			
			switch(_key) {
			   case "Exit":
				   //---use exit system-------
				   trace("---use Remove---");
			   break;
			   
			   
			   case "other":
				   //---use exit system-------
				   trace("---use Other Class---");
			   break;	   
				
			}
			
		}
		
		
		
		
		
		
		
		
		
	}
	
}