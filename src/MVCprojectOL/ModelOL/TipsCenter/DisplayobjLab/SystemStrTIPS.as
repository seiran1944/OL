package MVCprojectOL.ModelOL.TipsCenter.DisplayobjLab
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class SystemStrTIPS extends Sprite 
	{
		private var _bgPic:MovieClip;
		private var _text:TextField;
		public function SystemStrTIPS(_bg:MovieClip) 
		{
		    this._bgPic = _bg;
			this._text = new TextField();
			this._text.wordWrap = true;
			this._text.autoSize = TextFieldAutoSize.LEFT;
			this.addChild(this._bgPic);
			this.addChild(this._text);
			this._text.x = 10;
			this._text.y = 5;
			
		}
		
		
		public function SetStr(_str:String):void 
		{
			this._text.htmlText = _str;
			this._bgPic.width = this._text.width + 20;//(95.5/6)*menu.tip.tip_txt.length
			this._bgPic.height = this._text.height + 14;//(31.7)*menu.tip.tip_txt.numLines
			if (this.visible == false) this.visible = true;
		}
		
		public function OpenClose(_flag:Boolean):void 
		{
		    if (_flag==false)this._text.htmlText = "";
			this.visible = _flag;	
			
		}
		
		public function SetErrorTips(_str:String):void 
		{
			this._text.htmlText = _str;
			this._bgPic.width = this._text.width + 20;//(95.5/6)*menu.tip.tip_txt.length
			this._bgPic.height = this._text.height + 14;//(31.7)*menu.tip.tip_txt.numLines
			
		}
		
	
	}
	

	
}