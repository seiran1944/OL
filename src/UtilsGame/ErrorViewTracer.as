package UtilsGame
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	//import MVCprojectOL.ModelOL.ShowSideSys.SendTips;
	//import MVCprojectOL.ModelOL.ShowSideSys.TipCreatCenter;
	import Spark.coreFrameWork.observer.Observer;
	import Spark.coreFrameWork.View.ViewCtrl;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import Spark.Utils.Text;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.ProxyPVEStrList;
	
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class ErrorViewTracer extends ViewCtrl 
	{
		
		private var _sprConter:Sprite;
		private var _disPlayConter:Sprite;
		private var _text:Text;
		private var _strTrace:String
		public function ErrorViewTracer () 
		{
			super("DEBUG_TRACER");
		}
		
		
	    override public function onRegisted():void { 
		  
			this._disPlayConter = ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameMenuView);
			this._sprConter = new Sprite();
			this._sprConter.graphics.beginFill(0xffffff);
			this._sprConter.graphics.drawRect(0, 0, 350, 400);
			this._strTrace = "===================TRACER==================="+"\n";
			this._text = new Text({_str:"",_wid:350,_hei:380,_wap:true,_AutoSize:"LEFT",_col:0,_Size:12,_bold:true});
			this._sprConter.addChild(this._text);
			this._sprConter.mouseChildren = false;
			this._sprConter.addEventListener(MouseEvent.CLICK, Close);
			this._sprConter.visible = false;
			this._disPlayConter.addChild(this._sprConter);
			var _point:Point = ProjectOLFacade.GetFacadeOL().GetStageInfo();
			this._sprConter.x = (_point.x - this._sprConter.width)/2;
			this._sprConter.y =(_point.y - this._sprConter.height)/2;
			
			
	    }
		
		
	    public function AddTrace(_str:String):void 
		{
			this._strTrace = this._strTrace + _str + "\n";
			this.Open();
		}
		
		
		
		public function Open():void 
		{
			this._text.ReSetString(this._strTrace);
			/*
			if (this._sprConter.visible != true) this._sprConter.visible = true;
			var _spr:Sprite=TipCreatCenter.GetTipsData().GetTips(ProxyPVEStrList.TIP_MonsterEqu,new SendTips("test",ProxyPVEStrList.TIP_MonsterEqu,"ACY135841078797647","ACY00001","MOB135838403615535","00000000","ACY00001_ICO"));
			this._sprConter.addChild(_spr);
			*/
			
			
			
			/*
			var _mc:MovieClip = MovieClip(SourceProxy.GetInstance().GetMaterialSWP(PlayerDataCenter.GetInitUiKey("SysUI_All")[0], "TipBox", true));
		    this._sprConter.addChild(_mc);*/
			//new SendTips("MainViewSpr", ProxyPVEStrList.TIP_STRBASIC, "", "", this.mouseX, this.mouseY, '<br>建築效果: <b><font color="#65FF56">士兵全屬性抵抗</font>+%d</b>', ViewStrLib.MAIN_VIEWCENTER)
			// new SendTips("TimeLineProxy", ProxyPVEStrList.TIP_COMPLETE,"", _aryStone[0]._guid, 3, 4, _deleteIndex, 5)
			//---01/04_test
			//----熔解---- 
		    //var _obj:Object = {_system:3,_picItem:"MOB00104_ICO",_text:{_stoneAtk:0,_stoneDef:0,_stoneSpeed:0,_stoneInt:0,_stoneMnd:0,_stoneHP:0}};
		    //----技能----
			//var _obj:Object = {_system:4,_picItem:"MOB00104_ICO",_text:1};
			//var _spr:Sprite = TipCreatCenter.GetTipsData().GetTips(ProxyPVEStrList.TIP_SCHER,_obj);
			//this._sprConter.addChild(_spr);
			
		}
		
		
		
		private function Close(e:MouseEvent):void 
		{
			this._sprConter.visible = false;
		}
		
		
		
		
		
		
		
	}
	
}