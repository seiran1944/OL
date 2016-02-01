package MVCprojectOL.ViewOL.BattleView
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.SkillDisplayModel.CombatSkillDisplayProxy;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class InfoZone extends Sprite 
	{
		
		private var _txtInfo:TextField;
		
		
		public function InfoZone():void
		{
			this.infoInit();
		}
		
		private function infoInit():void 
		{
			//this.graphics.beginFill(0,0);
			//this.graphics.drawRoundRect(0, 0, 200, 100, 5, 5);
			//this.graphics.endFill();
			
			this._txtInfo = new TextField();
			var infoTf:TextFormat = new TextFormat(PlayerDataCenter.FontKey, 12, 0xFFFFFF, true);
			this._txtInfo.defaultTextFormat = infoTf;
			//this._txtInfo.selectable = false;
			//this._txtInfo.autoSize = TextFieldAutoSize.LEFT;
			this._txtInfo.wordWrap = true;
			this._txtInfo.multiline = true;//html use
			this._txtInfo.width = 200;
			this._txtInfo.height = 100;
			
			addChild(this._txtInfo);
			
			//增加文字框滑動時使用
			//this.createControlTool();
		}
		
		//後續可能會調成html的文框,同時可能會新增特定面向的文字變色狀況(敵我雙方的同樣動作不同色調處理)
		public function ShowInfo(word:String):void
		{
			//this._txtInfo.appendText("\n" + word);
			
			this._txtInfo.htmlText += "<p>" + word + "</p>";
			this._txtInfo.scrollV++;
		}
		
		private function createControlTool():void 
		{
			var spBox:Sprite = new Sprite();
			var spTop:Sprite = this.getSpRect(30, 30, 0xAAAAAA);
			var spBott:Sprite = this.getSpRect(30, 30, 0xAAAAAA);
			var spShift:Sprite = this.getSpRect(30, 30, 0x111111);
			
			spBox.addChild(spTop);
			
			spBox.addChild(spShift);
			spShift.y = 30;
			spBox.addChild(spBott);
			spShift.y = 100 - 30;
			
			addChild(spBox);
			spBox.x = 200;
			spBox.addEventListener(MouseEvent.MOUSE_DOWN, downMouse);
		}
		
		private function downMouse(e:MouseEvent):void 
		{
			addEventListener(MouseEvent.MOUSE_MOVE, moveM);
			addEventListener(MouseEvent.MOUSE_UP, upMouse);
		}
		
		private function upMouse(e:MouseEvent):void 
		{
			//trace("Mup");
			removeEventListener(MouseEvent.MOUSE_MOVE, moveM);
			removeEventListener(MouseEvent.MOUSE_UP, upMouse);
		}
		private function moveM(e:MouseEvent):void 
		{
			//trace("Mov");
		}
		private function getSpRect(w:int,h:int,color:uint):Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(color);
			sp.graphics.drawRect(0, 0, w, h);
			sp.graphics.endFill();
			return sp;
		}
		
		public function Destroy():void 
		{
			removeChild(this._txtInfo);
			this._txtInfo = null;
			
		}
		
		
		
		
	}
	
}