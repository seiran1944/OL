package MVCprojectOL.ViewOL.TipsView
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.TipsCenter.DisplayobjLab.CompleteConter;
	import MVCprojectOL.ModelOL.TipsCenter.TipsInfoProxy;
	import strLib.proxyStr.ProxyPVEStrList;
	//import MVCprojectOL.ModelOL.ShowSideSys.CompleteConter;
	//import MVCprojectOL.ModelOL.ShowSideSys.TipCreatCenter;
	import Spark.coreFrameWork.View.ViewCtrl;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.vewStr.ViewStrLib;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class TipsCenterView extends ViewCtrl 
	{
		
		private var _tipCtrl:TipCtrl;
		//private var _nowShowTipConter:DisplayObjectContainer
		private var _strTipsView:StrTipsView;
		public function TipsCenterView(_inputConter:DisplayObjectContainer) 
		{
			
			super(ViewStrLib.TIP_VIEWCTRL, _inputConter);
			this._strTipsView = new StrTipsView(_inputConter);
			
		}
	    
		//------重設文字TIPS的合法容器-----
		public function SetTipsConter(_conter:DisplayObjectContainer,_str:String):void 
		{
			//this._nowShowTipConter = _conter;
			this._strTipsView.SetConter(_conter,_str);
			
		}
		
		public function StopHandler():void 
		{
			this._tipCtrl.StopHandler();
		}
		public function CloseTips():void 
		{
			this._strTipsView.CloseTips();
		}
		
		public function TipsMove(_mouseX:Number, _mouseY:Number):void 
		{
			this._strTipsView.TipsMove(_mouseX,_mouseY);
		}
		
		private var _aryBgTips:Array = [];
		private var _oldBgIndex:int = 0;
		override public function onRegisted():void {
			
			var _aryGetTips:Array = ["TipBox","Complete_bg","tipsQua1","tipsQua2"];
			this._tipCtrl = new TipCtrl(this._viewConterBox, this.removeTipsBox);
		    var _point:Point = ProjectOLFacade.GetFacadeOL().GetStageInfo();
			//this._tipCtrl.SetAdmittanceInfo(_point.x,_point.y-300,_point.x-500,_point.y-300); 
			this._tipCtrl.SetAdmittanceInfo(1000, 500, 750, 500); 
		    var _ary:Array = PlayerDataCenter.GetInitUiKey("SysUI_All");
			
			for (var i:int = 0; i < 4;i++ ) {
				var _bg:MovieClip = MovieClip(SourceProxy.GetInstance().GetMaterialSWP(_ary[0],_aryGetTips[i], true));
				this._aryBgTips.push(_bg);
			}
			
			this._strTipsView.bgSource = this._aryBgTips[0];
		     
		};
		
		
		//---檢查背景的容器是否被抽換----
		/*
		public function CheckChangeTipsBox():void 
		{
			
		}*/
		
		
		
		
		private function removeTipsBox(_groupName:String,_guid:String):void 
		{
		   
	       TipsInfoProxy(ProjectOLFacade.GetFacadeOL().GetProxy(ProxyPVEStrList.TIP_PROXY)).RemoveTips(_groupName,_guid);	
			
			//TipCreatCenter.GetTipsData().RemoveTips(_groupName,_guid);	
		}
		
		
		public function AddTips(_spr:*):void 
		{
			
			//var _booleanTest:Boolean = _spr is CompleteConter;
			switch(true) {
			   
				case _spr is CompleteConter:
					//---完成提示---
					this._tipCtrl.AddTip(_spr);
					//_spr.StarLoadingItem();
				break;
				
				
			    case _spr is Array:
				  var _index:int = (_spr.length>4)?_spr[4]-1:0;  
				
				  if (this._oldBgIndex!=_index) {
					 this._strTipsView.bgSource=this._aryBgTips[_index];
					 this._oldBgIndex = _index; 
				  }
				  this._strTipsView.ChangeBox(_spr[0],_spr[1], _spr[2], _spr[3]);
				break;
				
				
				
			}
			
			
			
		}
		
		
		
	}
	
}