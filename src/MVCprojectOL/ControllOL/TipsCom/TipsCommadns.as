package  MVCprojectOL.ControllOL.TipsCom
{
	import flash.display.Sprite;
	import MVCprojectOL.ModelOL.TipsCenter.TipsInfoProxy;
	//import MVCprojectOL.ModelOL.ShowSideSys.SendTips;
	//import MVCprojectOL.ModelOL.ShowSideSys.ShowTipsInfoProxy;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ViewOL.TipsView.TipsCenterView;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewStrLib;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class TipsCommadns extends Commands 
	{
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			var _notify:SendTips = SendTips(_obj.GetClass());
			this.checkObserverHandler(_notify);

		}
		
		
		//---{_picItem:_aryStone[0]._picItem,_strType:4,_guid:_aryStone[0]._guid,_buildType:5,_sch:_deleteIndex,_basicHouse:3}
		//----system=容器層級
		//---{_change:Str(自訂義的替換字碼),_strTips:String,_guid,_mouseX:Number,_mouseY:Number,_system:String=""}
		private function checkObserverHandler(_obj:SendTips):void 
		{
			var _view:TipsCenterView = TipsCenterView(this._facaed.GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL));
			var _proxyTips:TipsInfoProxy = TipsInfoProxy(this._facaed.GetProxy(ProxyPVEStrList.TIP_PROXY));
			var _getAnything:*;
			
			switch(_obj.tipsType) {
				
			  case ProxyPVEStrList.TIP_COMPLETE:
				  
				  //----一搬會用到右側的顯示TIPS---
				_getAnything= (_proxyTips.GetTips(ProxyPVEStrList.TIP_COMPLETE,_obj)) as Sprite;
				
			  break;	
			  
		     case ProxyPVEStrList.TIP_STRBASIC:
			  //---文字TIPS---
			  //_view.AddTips
			  _getAnything =(_proxyTips.GetTips(ProxyPVEStrList.TIP_STRBASIC,_obj)) as Array;
			  break;
			  
			}
			
			_view.AddTips(_getAnything);
			//this.sendNotifyHandler(_obj);
			
		}
		
		
		
		private function sendNotifyHandler(_notify:SendTips):void 
		{
			
			//----送出完成字串指令----
			if (_notify.scherID != null && _notify.scherID != "") {
				//---各個物件判斷接收完成的訊息
				this.SendNotify(ProxyPVEStrList.TIMELINE_COMPLETE,{_sch:_notify.scherID,_build:_notify.buildType});
			}	
			
		}
	}
	
}