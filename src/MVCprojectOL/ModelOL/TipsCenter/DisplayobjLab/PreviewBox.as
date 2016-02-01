package MVCprojectOL.ModelOL.TipsCenter.DisplayobjLab
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import MVCprojectOL.ModelOL.TipsCenter.Basic.BaseItemView;
	import MVCprojectOL.ModelOL.TipsCenter.Basic.PicAndStr;
	
	/**
	 * ...
	 * @author EricHuang
	 * 
	 */
	public class  PreviewBox extends BaseItemView
	{
		//private var _itemBox:ItemConter;
		//private var _bg:MovieClip;
		private var _text:TextField;
		//private var _picAndStr:PicAndStr;
		private var _sprPicAndStr:Sprite;
		private var _arySource:Array;
		private var _strAry:Array = ["_HP","_attack","_defense","_int","_mnd","_speed"];
		public function PreviewBox(_bgSource:MovieClip,_group:String,_guid:String,_arySource:Array) 
		{
			//this._bg = _bg;
			super(_bgSource,_guid,_group);
			//this._picAndStr = new PicAndStr();
			this._sprPicAndStr = new Sprite();
			this._arySource = _arySource;
			this._text = new TextField();
			this._text.autoSize = TextFieldAutoSize.LEFT;
			this._text.wordWrap = false;
			
			for (var i:int = 0; i < 6;i++ ) {
				//var _picIndex:int = int(_strAry[i].slice( -1));
				//var _strName:String = _strAry[i].substr(0,_strAry[i].length-1);
				var _textShow:PicAndStr = new PicAndStr(_strAry[i]);
				_textShow.AddSource(this._arySource[i]);
				this._sprPicAndStr .addChild(_textShow);
				_textShow.x = (i % 3) * (_textShow.width);
				_textShow.y = Math.floor(i / 3) * (_textShow.height);
			}
			
			this.addChild(this._sprPicAndStr);
			this.addChild(this._text);
			
			
		}
		
		public function AddTitle(_str:String):void 
		{
			this._text.htmlText = "";
			this._text.htmlText = _str;
			
		}
		
		public function ResetPicItem(_key:String):void 
		{
		  if (_key != "" && this._item != null)this._item.Reset(_key);
		}
		
		//---放入初始(怪+裝)
		public function AddOriginalStr(_obj:Object):void 
		{
			for (var i:String in _obj) {
			   var _spr:PicAndStr = this._sprPicAndStr.getChildByName(i) as PicAndStr;
				_spr.SetOriginal(_obj[i]);	
				
			}
		}
		
		//--放入(裝A-裝B)
		public function AddSetEquClothed(_obj:Object):void 
		{
			for (var i:String in _obj) {
			   var _spr:PicAndStr = this._sprPicAndStr.getChildByName(i) as PicAndStr;
				_spr.SetEquClothed(_obj[i]);		
			}
			
			this.deformbadyHandler();
		}
		
		//---變形---
		private function deformbadyHandler():void 
		{
		    this._item.x = this._item.y = 8;
			this._text.x = this._item.x+this._item.width + 10;
			this._text.y = this._item.y;
			this._sprPicAndStr.x = this._text.x;
			this._sprPicAndStr.y = this._text.y + this._text.height + 1;
			this._bg.width =this._sprPicAndStr.width+this._item.width+25;
			this._bg.height = this._text.height + this._sprPicAndStr.height+20;
			
			/*
			this._item.x = this._item.y = 8;
			this._textShow.y = this._item.y;
			this._bg.width = 286;
			this._bg.height = (this._textShow.height - (80 - 6) <= 80)?80:this._textShow.height - (80 - 6);
		    */ 
		}
		
		
		override public function CleanALL():void 
		{
			this.CleaN();
			this._sprPicAndStr.removeChildren();
			this._text = null;
			this.removeChild(this._sprPicAndStr);
			this.removeChild(this._text);
			
			
		}
		
		override public function OpenClose(_flag:Boolean):void 
		{
			this.visible = _flag;
		}
		
	}
	
}