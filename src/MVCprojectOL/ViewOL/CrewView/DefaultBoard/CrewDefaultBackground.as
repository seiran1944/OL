package MVCprojectOL.ViewOL.CrewView.DefaultBoard
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import MVCprojectOL.ViewOL.SharedMethods.BasisPanel;
	import strLib.proxyStr.ArchivesStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class  CrewDefaultBackground extends BasisPanel
	{
		
		
		public function CrewDefaultBackground(objSource:Object,conter:Sprite):void 
		{
			super(objSource, conter);
		}
		
		override protected function RemovePanel():void
		{
			this.SendNotify(ArchivesStr.CREW_DEFAULT_REMOVE);
		}
		
		public  function AddBottomPaper(intro:String):void 
		{
			var bmWall :Bitmap = new Bitmap(new this._BGObj.WallBg());
			bmWall.x = 40;
			bmWall.y = 100;
			this._Panel.addChildAt(bmWall,1);
			
			var spIntro:Sprite = new Sprite();
			var bmIntro:BitmapData = new this._BGObj.InfoBg();
			var txtIntro:TextField = new TextField();
			var tfIntro:TextFormat = new TextFormat("微軟正黑體", 12, 0xCCCCCC);
			tfIntro.letterSpacing = 1.75;
			
			txtIntro.x = 42;
			txtIntro.y = 25;
			spIntro.addChild(txtIntro);
			txtIntro.width = bmIntro.width - txtIntro.x*2;
			
			txtIntro.defaultTextFormat = tfIntro;
			txtIntro.autoSize = TextFieldAutoSize.LEFT;
			txtIntro.wordWrap = true;
			txtIntro.selectable = false;
			txtIntro.text = intro;
			
			spIntro.graphics.beginBitmapFill(bmIntro);
			spIntro.graphics.drawRect(0, 0, bmIntro.width, bmIntro.height);
			spIntro.graphics.endFill();
			
			
			spIntro.x = 40;
			spIntro.y = 480;
			this._Panel.addChild(spIntro);
		}
		
		public function get ObjSource():Object
		{
			return this._BGObj;
		}
		
	}
	
}