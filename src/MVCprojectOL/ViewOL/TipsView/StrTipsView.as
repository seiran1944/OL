package MVCprojectOL.ViewOL.TipsView
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import strLib.proxyStr.ProxyPVEStrList;
	
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class StrTipsView
	{
		
		private var _bgSource:MovieClip;
		//-----各系統專用的層級
		private var _conter:DisplayObjectContainer;
		private var _text:TextField;
		private var _stageWidth:Number;
		private var _stageHeight:Number;
		private var _conterSystem:String = "";
		//---另外一層需要的容器(最上層)
		private var _menuConter:DisplayObjectContainer;
		private const _menuSystem:String = ProxyPVEStrList.SystemTIPS_CONTER;
		private const _bgBoxName:String = "Tips_BoxBG";
		private var _bgConter:Sprite;
		
		//private var _style:TextFormat; 
		public function StrTipsView(_conter:DisplayObjectContainer) 
		{
			this._text = new TextField();
			//this._style = new TextFormat();
			//this._text.setTextFormat(_style);
			this._text.wordWrap = false;
			this._text. multiline = true;
			this._text.autoSize = TextFieldAutoSize.LEFT;
			this._text.styleSheet = new StyleSheet();
			this._menuConter = _conter;
			this._bgConter = new Sprite();
		    
		}
		
		public function SetConter(_value:DisplayObjectContainer,_system:String):void 
		{
			this._conter = _value;
			this._conterSystem = _system;
			if(this._bgConter!=null)this._conter.addChild(this._bgConter);
			var _point:Point = ProjectOLFacade.GetFacadeOL().GetStageInfo();
			this._stageWidth = _point.x;
			this._stageHeight = _point.y;
		}
		
		public function RemoveTips(_system:String=""):void 
		{
			var _targetConter:DisplayObjectContainer = (_system=="")?this._menuConter:this._conter;
			_targetConter.removeChild(this._bgConter);
		}
		
		
		
		public function set bgSource(value:MovieClip):void 
		{
			if (this._bgSource == null) {
				this._bgSource = value;
				this._bgConter.name = this._bgBoxName;
				this._bgConter.addChild(this._bgSource);
				this._bgConter.addChild(this._text);
				this._text.x = 10;
				this._text.y = 5;
			}else if(this._bgConter.numChildren>0){
				//---裡面已經有的情況下(change)----
				this._bgConter.removeChildAt(0);
				this._bgSource = value;
				//this._bgConter.name = this._bgBoxName;
				this._bgConter.addChildAt(this._bgSource,0);
				
				//this._text.x = 10;
				//this._text.y = 5;
			}
		}
		
		
		
		
		
		
		
		public function TipsMove(_mouseX:Number, _mouseY:Number, _system:String = "" ):void 
		{
			
			var sx:Number=_mouseX;
			var sy:Number = _mouseY;
			var tipW:Number=this._bgSource.width;
			var tipH:Number=this._bgSource.height;
			var sW:Number=this._stageWidth;
			var sH:Number=this._stageHeight;
			
			if( sx+tipW >= sW && sy + tipH >= sH - 20 ){
				this._bgConter.x = sx - tipW;
				this._bgConter.y = sy - tipH;
			}else if(sx+tipW >= sW){
				this._bgConter.x=sx-tipW;
				this._bgConter.y=sy+20;
			}else if(sy + tipH >= sH - 20 ){
				this._bgConter.x = sx + 6;
				this._bgConter.y = sy - tipH;
			}else{
				this._bgConter.x=sx+6;
				this._bgConter.y=sy+20;
			}
			if (this._bgConter.visible == false) this._bgConter.visible = true;
			/*
			if(monsterRes){
				this.monsterResShape.x=menu.tip.x+tipW-24;
				this.monsterResShape.y=menu.tip.y+5;
			}
			*/
			
		}
		
		
		public function ChangeBox(_str:String,_mouseX:Number,_mouseY:Number,_system:String=""):void 
		{
			//this._text.htmlText = "";
			//this._text.setTextFormat(_style);
			//this._text.styleSheet.clear();
			this._text.htmlText = _str;
			
			this._bgSource.width = this._text.width + 20;//(95.5/6)*menu.tip.tip_txt.length
			this._bgSource.height = this._text.height + 14;//(31.7)*menu.tip.tip_txt.numLines
			//var _aa:Number=this._text.width;
			//var _bb:Number=this._text.height;
			//var _cc:Number=this._bgSource.width;
			//var _dd:Number=this._bgSource.height;
			
			this.TipsMove(_mouseX, _mouseY);
			var _conter:DisplayObjectContainer = (_system == "")?this._menuConter:this._conter;
		    //var _test:Sprite = _conter.getChildByName(this._bgBoxName) as Sprite;
			
			if (_conter!=null) {
				
				if (_conter.getChildByName(this._bgBoxName) == null) {
			    var _removeTarget:DisplayObjectContainer = (_conter === this._menuConter)?this._menuConter:this._conter;
				if (_removeTarget.getChildByName(this._bgBoxName) != null) {
				_removeTarget.removeChild(this._bgConter);	
				}
				_conter.addChild(this._bgConter);	
			}
			//_conter.addChild(this._bgConter);
			_conter.setChildIndex(this._bgConter, _conter.numChildren - 1);
				
				
			}
			
			/*
			var _testConter:Number = _conter.numChildren;
			var _testIndex:int = _conter.getChildIndex(this._bgConter);
			trace("yes");
			*/
		}
		
		public function CloseTips():void 
		{
		    this._bgConter.visible = false;
			this._text.htmlText = "";
		    //this._text.width = 10;//---正式要改成0--2013/1/11
			//this._text.height = 10;//---正式要改成0--2013/1/11
		}
		
		
		
	}
	
}


