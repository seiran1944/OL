package MVCprojectOL.ViewOL.TeamUI
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
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class HeadDragTool 
	{
		
		private var _mainLayer:DisplayObjectContainer;
		private var _funPort:Function;
		private var _bmDrag:Sprite;
		private var _rectLimit:Rectangle;
		private var _chooseFrom:String;
		
		public function HeadDragTool(layer:DisplayObjectContainer,port:Function):void 
		{
			this._mainLayer = layer;
			this._funPort = port;
			this.DoListener(true);
			this._rectLimit = new Rectangle(5, 90, 990, 470);
		}
		
		public function SetDragHead(head:Sprite):void 
		{
			this._bmDrag = head;
			head.mouseChildren = false;
			head.mouseEnabled = false;
			this._mainLayer.addChild(head);
			head.x = -100;
			head.y = -100;
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
		
		private function toPort(type:String, note:Object = null, sendOut:Boolean = false):void 
		{
			this._funPort(type, note, sendOut);
		}
		
		private function headChangeReport(type:String,monsterName:String,target:Object , head:Sprite=null):void
		{
			this.toPort(type, {  _monsterName : monsterName ,_target : target , _head : head , _from : this._chooseFrom} );
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
			//trace("MOUSE_MOVE", e.type , e.target.mouseX, e.target.mouseY, e.stageX, e.stageY);
			if (!this._rectLimit.containsPoint(new Point(e.stageX, e.stageY))) {
				this.removeHeadShow();
				this._bmDrag = null;
				return ;
			}
			
			if (this._bmDrag != null) {
				this._bmDrag.x = e.stageX-32;
				this._bmDrag.y = e.stageY-32;
			}
		}
		//滑鼠點放 編輯判斷
		private function dragProcess(e:MouseEvent):void
		{
			var cutName:String = e.target.name.substr(0, 3);
			//trace("MOUSE_DOWNUP", e.target.name	,cutName);
			
				switch (e.type)
				{
					case MouseEvent.MOUSE_DOWN:
						if (cutName == "Mon" || cutName == "box" ) {
							this._chooseFrom = cutName;//點選目標來源
							this.headChangeReport(cutName == "Mon" ? TeamViewCtrl.TEAM_SELECT_ADD : TeamViewCtrl.TEAM_SELECT_REMOVE,cutName == "Mon" ? e.target.guid : e.target.currentOL , e.target);
							this._mainLayer.addEventListener(MouseEvent.MOUSE_MOVE, moveProcess);
						}
					break;
					case MouseEvent.MOUSE_UP:
						this._mainLayer.removeEventListener(MouseEvent.MOUSE_MOVE,moveProcess);
						//都要移除頭像的顯示
						this.removeHeadShow();
						if (cutName == "box") {//放掉的位置是頭框
							this.headChangeReport(TeamViewCtrl.TEAM_SELECT_ON,e.target.guid , e.target , this._bmDrag);
						}
						this._bmDrag = null;
						
						//trace(e.target.name	, "i release the mosue btn to select the position");
						
					break;
			}
			
		}
		
		
		
		
		
		public function Destroy():void 
		{
			this.DoListener(false);
		}
		
	}
	
}