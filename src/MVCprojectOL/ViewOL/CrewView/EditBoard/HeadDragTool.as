package MVCprojectOL.ViewOL.CrewView.EditBoard
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.ArchivesStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.05.22.17.30
		@documentation to use this Class....
	 */
	public class HeadDragTool 
	{
		
		private var _mainLayer:DisplayObjectContainer;
		private var _funPort:Function;
		private var _bmDrag:Sprite;
		private var _rectLimit:Rectangle;
		private var _currentDragger:String;
		
		public function HeadDragTool(layer:DisplayObjectContainer,port:Function,rectLimit:Rectangle):void 
		{
			this._mainLayer = layer;
			this._funPort = port;
			this.DoListener(true);
			this._rectLimit = rectLimit;// new Rectangle(5, 90, 990, 470);
		}
		
		public function SetDragHead(head:Sprite,name:String=""):void 
		{
			this._currentDragger = name;
			
			this._bmDrag = head;
			//resize
			head.width = 48;
			head.height = 48;
			//
			head.mouseChildren = false;
			head.mouseEnabled = false;
			this._mainLayer.addChild(head);
			head.x = -1000;
			head.y = -1000;
		}
		
		private function removeHeadShow():void 
		{
			if (this._bmDrag != null) {
				this._mainLayer.removeChild(this._bmDrag);
				this._bmDrag.mouseEnabled = true;
				this._bmDrag.mouseChildren = true;
				//this._bmDrag = null;
			}
		}
		
		private function toPort(type:String, note:Object = null):void 
		{
			this._funPort(type, note);
		}
		
		private function headChangeReport(type:String,name:String,nameOL:String="",head:Sprite=null):void
		{
			this.toPort(type, {  _name : name , _head : head ,_nameOL : nameOL } );
		}
		
		public function DoListener(open:Boolean):void 
		{
			var aryListen:Array = [ MouseEvent.MOUSE_DOWN , MouseEvent.MOUSE_UP ];
			
			for (var i:int = 0; i < 2; i++) 
			{
				open ? this._mainLayer.addEventListener(aryListen[i] , this.dragProcess) : this._mainLayer.removeEventListener(aryListen[i] , this.dragProcess);
			}
			//trace(this._mainLayer.hasEventListener(MouseEvent.MOUSE_UP), this._mainLayer.hasEventListener(MouseEvent.MOUSE_DOWN),"123456789123456789");
		}
		
		
		//滑鼠移動 ICON移動
		private function moveProcess(e:MouseEvent):void 
		{
			//trace("REC", this._rectLimit.x, this._rectLimit.y, this._rectLimit.width, this._rectLimit.height );
			//trace("MOUSE_MOVE", e.type , e.target.mouseX, e.target.mouseY, e.stageX, e.stageY, e.localX, e.localY);
			
			if (!this._rectLimit.containsPoint(new Point(e.stageX + this._mainLayer.x , e.stageY + this._mainLayer.y))) {
				this.removeHeadShow();
				this._bmDrag = null;
				return ;
			}
			
			if (this._bmDrag != null) {
				this._bmDrag.x = e.stageX - this._mainLayer.x - this._bmDrag.width / 2;
				this._bmDrag.y = e.stageY - this._mainLayer.y - this._bmDrag.height / 2;
			}
		}
		//滑鼠點放 編輯判斷
		//20130522 調整 怪物面板內有TIP需要處理 故打開mouseChildren 另外在各個怪物版面做mouseDown的監聽 抓currentTarget.name來做點選判斷
		public function dragProcess(e:MouseEvent):void
		{
			
			var name:String = (e.target.name.indexOf("MOB") == -1 && e.target.name.indexOf("box") == -1) ? e.currentTarget.name : e.target.name;
			var cutName:String = name.substr(0, 3);
			
			//trace("MOUSE_DOWNUP", e.target.name	,cutName);
			//trace("MOUSE_DOWNUP----SE", e.currentTarget.name	,cutName);
			
				switch (e.type)
				{
					case MouseEvent.MOUSE_DOWN:
						if (cutName == "MOB" || cutName == "box" ) {
							this.headChangeReport(cutName == "MOB" ? ArchivesStr.TEAM_DRAGDOWN_MONSTER: ArchivesStr.TEAM_DRAGDOWN_BOX,name);
							this._mainLayer.addEventListener(MouseEvent.MOUSE_MOVE, moveProcess);
						}
					break;
					case MouseEvent.MOUSE_UP://滑鼠放掉時皆會清空頭像,當在頭框中時才會發送特殊處理
						this._mainLayer.removeEventListener(MouseEvent.MOUSE_MOVE,moveProcess);
						//都要移除頭像的顯示
						this.removeHeadShow();
						//if (cutName == "box") {//放掉的位置是頭框
							this.headChangeReport(ArchivesStr.TEAM_DRAGUP_TOBOX,name,cutName == "box" ? this._currentDragger : "delete" ,this._bmDrag);
						//}
						this._bmDrag = null;
						this._currentDragger = "";
						//trace(e.target.name	, "i release the mosue btn to select the position");
						
					break;
			}
			
		}
		
		
		
		
		
		public function Destroy():void 
		{
			this.DoListener(false);
			this._bmDrag = null;
			this._funPort = null;
			this._mainLayer = null;
			this._rectLimit = null;
		}
		
		public function get CurrentDragger():String 
		{
			return this._currentDragger;
		}
		
	}
	
}