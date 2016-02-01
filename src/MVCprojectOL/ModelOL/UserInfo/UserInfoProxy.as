package MVCprojectOL.ModelOL.UserInfo
{
	import flash.text.TextField;
	import Spark.coreFrameWork.Interface.IfProxy;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.MVCs.Models.TextDriftTool.TextDriftPool;
	import Spark.MVCs.Models.TextDriftTool.TextDriftProxy;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class  UserInfoProxy extends ProxY
	{
		private const USERINFO_PROXY:String = "userInfo_proxy";
		
		private var _textProxy:TextDriftProxy;
		private var _groupName:String = "USER_infoTEXT";
		private var _flag:Boolean;
		
		public function UserInfoProxy(_proxy:IfProxy) 
		{
			this._textProxy = TextDriftProxy(_proxy);
			super(this.USERINFO_PROXY,this);
		}
		
		
		public function GetFunction():Function 
		{
			return RegisterTextField;
		}
		
		public function RegisterTextField(_str:String,_text:TextField):void 
		{
			if (this._flag==false) {
				TextDriftPool(this._textProxy.RegisterTextPool(this._groupName)).RegisterText(_str,_text);
				this._flag = true;
				} else {
				TextDriftPool(this._textProxy.GetTextPool(this._groupName)).RegisterText(_str,_text);
			}
			
		}
		
		
		public function ChangeText(_str:String,_starVaule:int,_endVaule:int):void 
		{
			var _textPool:TextDriftPool = this._textProxy.GetTextPool(this._groupName);
			_textPool.DriftTo(_str,_starVaule,_endVaule);
		}
		
		
	}
	
}