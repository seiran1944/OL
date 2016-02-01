package MVCprojectOL.ViewOL.MainView
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import Spark.coreFrameWork.Interface.IfProxy;
	import Spark.coreFrameWork.View.ViewCtrl;
	
	
	/**
	 * ...
	 * @author EricHuang
	 * 上方playerInfo的資訊面板----
	 */
	public class  TopUserInfoBar extends ViewCtrl
	{
		private const USERINFO_VIEW:String = "userInfoView";
		private var _sprShowPlayerInfo:SprShowPlayerInfo;
		private var _displayConter:DisplayObjectContainer;
		//---註冊textField用的function----
	    private var _funProxy:Function;
		private var _arySourceClass:Class;
		public function TopUserInfoBar(_conter:DisplayObjectContainer,_proxyFun:Function)
		{
			this._displayConter = _conter;
			this._funProxy = _proxyFun;
			super(this.USERINFO_VIEW);
			
		}
		
		public function AddSource(_obj:Class):void 
		{
			//var _sprtest:Sprite = new _obj();
			this._sprShowPlayerInfo.AddSource(_obj);
			
		}
		
		//---改變距離+-----
		public function ChangeDic():void 
		{
			this._sprShowPlayerInfo.StartInStage();
		}
		
		public function SwitchMotion(_str:String,_flag:int=-1):void 
		{
			this._sprShowPlayerInfo.MotionCommand(_str,_flag);
		}
		
		
		override public function onRegisted():void 
		{ 
		  
			this._sprShowPlayerInfo = new SprShowPlayerInfo(this._displayConter,this._funProxy,this.SendNotify);
		};
	
		
	}
	
}