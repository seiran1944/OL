package MVCprojectOL.ViewOL.MainView
{
	import flash.display.DisplayObjectContainer;
	import Spark.coreFrameWork.View.ViewCtrl;
	import strLib.vewStr.ViewStrLib;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class MianViewCenter extends ViewCtrl 
	{
		private const MAIN_VIEW:String = ViewStrLib.MAIN_VIEWCENTER;//--main_viewCenter
		private var _displayConter:DisplayObjectContainer;
		//---
		private var _MainView:MainViewSpr; 
		private var _setSwitch:String = "";
		public function MianViewCenter(_conter:DisplayObjectContainer) 
		{
		    this._displayConter = _conter;
			super(this.MAIN_VIEW,_conter);
		}
		
		public function AddSource(_ary:Array):void 
		{
			//var _sprtest:Sprite = new _obj();
			//this._sprShowPlayerInfo.AddSource(_obj);
			if (this._MainView != null) this._MainView.AddSource(_ary);
		}
		
		public function initOpenView():void 
		{
			this._MainView.InitShow();
		}
		//----解鎖---
		public function LockAndUnlock(_flag:Boolean):void 
		{
		    if (this._MainView!=null) this._MainView.LockAndUnlock(_flag);
		}
		
		override public function onRegisted():void 
		{ 
		   this._MainView = new MainViewSpr(this._displayConter,this.SendNotify);
			//this._sprShowPlayerInfo = new SprShowPlayerInfo(this._displayConter,this._funProxy,this.SendNotify);
		};
		
	    override public function onRemoved():void {
			this._MainView.RemoveHandler();
			this._MainView = null;
			this._displayConter = null;
		};
		
		public function get setSwitch():String 
		{
			var _target:String = this._setSwitch;
			this._setSwitch = "";
			return _target;
		}
		
		public function set setSwitch(value:String):void 
		{
			_setSwitch = value;
		}
	}
	
}