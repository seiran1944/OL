package MVCprojectOL.ModelOL.TipsCenter.Basic 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author EricHuang
	 * 文字並圖片& 改變累加進來的數值顏色變化
	 */
	public class PicAndStr extends Sprite
	{
		private var _showPic:Bitmap;
		private var _text:TextField;
		//-----以屬性的名稱來命名
		//private var _name:String;
		private var _fontEnd:String = '</font>';
		private var _forntUp:String = '<font color="#76EE00">';
		private var _forntDown:String ='<font color="#EE0000">';
		
		
		public function PicAndStr (_name:String) 
		{
		   this.name = _name;	
		}
		
		public function AddSource(_bitmap:BitmapData):void 
		{
			if (_bitmap != null) {
				this._showPic = new Bitmap(_bitmap);
				this._text = new TextField();
				this._text.width = 50;
				this._text.height = 24;
				//this._text.autoSize = TextFieldAutoSize.LEFT;
				this._text.wordWrap = false;
				//this._text.backgroundColor = 0x8F8F8F;
				//this._text.background = true;
				this.addChild(this._showPic);
				this.addChild(this._text);
				this._text.x = this._showPic.width+5;
				//this._text.multiline = true;
			} 
		}
		
		public function SetOriginal(_vaule:int):void 
		{
			this._text.htmlText = "";
			var _str:String = '<font color="#FFFFFF">' + _vaule + this._fontEnd;
			this._text.htmlText = _str;
		}
		
		public function SetEquClothed(_vaule:int):void 
		{
			
			//var _str:String = (_vaule > 0)?this._forntUp + _vaule:this._forntDown + _vaule;
			var _str:String = "";
			if (_vaule > 0) { 
				_str = this._forntUp + " + " + _vaule + this._fontEnd;
				
				} else if(_vaule<0){
				_str = this._forntDown + " - " + _vaule + this._fontEnd;
				
			}
			
			this._text.htmlText = '<b>'+this._text.htmlText+_str+'</b>';
		}
		
		
	}
	
}