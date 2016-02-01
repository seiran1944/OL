package MVCprojectOL.ControllOL.UserInfo
{
	import MVCprojectOL.ModelOL.UserInfo.UserInfoProxy;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	
	/**
	 * ...
	 * @author EricHuang
	 * 11/21---
	 * 改變玩家資訊-------
	 */
	public class UserInfoCommands extends Commands
	{
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			//trace("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
			var _ary:Array = _obj.GetClass()._ary;
			if (_ary==null) {
				UserInfoProxy(this._facaed.GetProxy("userInfo_proxy")).ChangeText(_obj.GetClass()._name,_obj.GetClass()._start,_obj.GetClass()._end);
				
				} else {
				
				var _len:int = _ary.length;
				if (_len>0) {
				  for (var i:int = 0; i < _len;i++ ) {
					UserInfoProxy(this._facaed.GetProxy("userInfo_proxy")).ChangeText(_ary[i]._name,_ary[i]._start,_ary[i]._end);
				  }
					
				}else {
					
				 trace("Error_length<=0");	
				}	
			}
			
			
			
		}
	}
	
}