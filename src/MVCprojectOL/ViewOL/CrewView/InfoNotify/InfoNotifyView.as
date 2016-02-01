package MVCprojectOL.ViewOL.CrewView.InfoNotify
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import MVCprojectOL.ViewOL.SharedMethods.AskPanel;
	import Spark.coreFrameWork.View.ViewCtrl;
	import strLib.proxyStr.ArchivesStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 系統提示訊息
	 */
	public class InfoNotifyView extends ViewCtrl
	{
		
		protected var _askPanel:AskPanel;
		private var _timeoutID:uint;
		
		public function InfoNotifyView(name:String ,conter:DisplayObjectContainer):void 
		{
			super(name, conter);
		}
		
		//info >> _info : string , _x : x , _y : y
		public function ShowInfo(source:Object,info:Object):void 
		{
			this._askPanel = new AskPanel();
			this._askPanel.AddElement(this._viewConterBox, source);
			this._askPanel.AddInform(info._btnNum);
			this._askPanel.AddMsgText(info._info, info._x, info._y);
			this.activeListener(true);
		}
		
		private function activeListener(add:Boolean):void 
		{
			var board:Sprite = this._viewConterBox.getChildByName("Inform") as Sprite;
			
			this.doListener(board.getChildByName("Make0"), add);
			this.doListener(board.getChildByName("Make1"), add);
			
		}
		private function doListener(btn:DisplayObject , add:Boolean):void 
		{
			if(btn) add ? btn.addEventListener(MouseEvent.CLICK, clickNotify) : btn.removeEventListener(MouseEvent.CLICK, clickNotify);
		}
		
		private function clickNotify(e:MouseEvent):void 
		{
			this.SendNotify(ArchivesStr.CREW_INFO_NOTIFY, { _active : e.target.name == "Make0" ? "CONFIRM" : "CANCEL" } );
			//this._timeoutID = setTimeout(this.Destroy, 1000);
			this.Destroy();
		}
		
		public function Destroy():void 
		{
			//clearTimeout(this._timeoutID);
			this.activeListener(false);
			this._askPanel = null;
			if (this._viewConterBox.parent) this._viewConterBox.parent.removeChild(this._viewConterBox);
			this._viewConterBox = null;
		}
		
	}
	
}