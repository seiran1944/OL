package MVCprojectOL.ViewOL.ErrorInforView 
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import MVCprojectOL.ViewOL.SharedMethods.AskPanel;
	import Spark.coreFrameWork.View.ViewCtrl;
	/**
	 * ...
	 * @author brook
	 */
	public class ErrorInforView extends ViewCtrl
	{
		private var _BGObj:Object;
		private var _AskPanel:AskPanel = new AskPanel();
		
		public function ErrorInforView(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			super( _InputViewName , _InputConter );
			this._viewConterBox.addEventListener(MouseEvent.CLICK, playerClickProcess);
		}
		
		public function AddElement(_InputObj:Object):void
		{
			this._BGObj = _InputObj;
			this._AskPanel.AddElement(this._viewConterBox, this._BGObj);
			this._AskPanel.AddInform(1);
		}
		
		public function AddMsg(_serverStatus:String, _result:String, _replyDataType:String):void 
		{
			var _Msg:String = _serverStatus + "\n" + _result + "\n" + _replyDataType;
			this._AskPanel.AddMsgText(_Msg, 140, 70);
		}
		
		private function playerClickProcess(e:MouseEvent):void 
		{
			switch (e.target.name) {
				case "Make0"://yes
					TweenLite.to(this._viewConterBox.getChildByName("Inform"), 0.3, { x:393, y:255, scaleX:0.5, scaleY:0.5 , onComplete:RemoveInform } );
					ExternalInterface.call("refresh_page");
				break;
			}
		}
		
		private function RemoveInform():void
		{
			if (this._viewConterBox.getChildByName("InformBox") != null) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("InformBox"));
			if (this._viewConterBox.getChildByName("Inform") != null) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("Inform"));
		}
		
		
		override public function onRemoved():void 
		{
			if (this._viewConterBox.getChildByName("InformBox") != null) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("InformBox"));
			if (this._viewConterBox.getChildByName("Inform") != null) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("Inform"));
		}
		
	}
}