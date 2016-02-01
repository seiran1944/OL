package MVCprojectOL.ModelOL.TipsCenter
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.TipsCenter.TipsDataCenter.TipsCtrlCenter;
	import MVCprojectOL.ModelOL.TipsCenter.TipsLab.TipsDataLab;
	//import MVCprojectOL.ModelOL.TIPDate.TipsData;
	import MVCprojectOL.ModelOL.Vo.Get.Get_TipsData;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author EricHuang
	 * TIPS/completeInfo/LineInfo
	 * 12/27
	 */
	public class TipsInfoProxy extends ProxY
	{
		//private var _getTipCenter:TipCreatCenter;
		//private var _TipsData:TipsDataLab;
		private var _netConnect:AmfConnector;
		//private var _aryVoClal:Array;
		
		private var _tipsCtrlCenter:TipsCtrlCenter;
		public function TipsInfoProxy() 
		{
			super(ProxyPVEStrList.TIP_PROXY, this);
			
		}
		
		//private const _aryTipsBG:Array = [["Complete_bg","TipBox","tipsQua1","tipsQua2"],];
		
		override public function onRegisteredProxy():void 
		{
			this._tipsCtrlCenter =new TipsCtrlCenter(this.SendNotify);
			//this._TipsData = TipsDataLab.GetTipsData(this.SendNotify);
			//-----取素材(底圖/擷取數字)----
			var _ary:Array = PlayerDataCenter.GetInitUiKey("SysUI_All");
			var _classBg:Class = SourceProxy.GetInstance().GetMaterialSWP(_ary[0], "Complete_bg");
			
			
			var _aryNum:Array = PlayerDataCenter.GetInitUiKey("SysUI_Number");
			
			
			var _picNumber:BitmapData = BitmapData(SourceProxy.GetInstance().GetMaterialSWP(_aryNum[0], "timerBasic", true));
			
			
			var _numberAry:Array = SourceProxy.GetInstance().CutImgaeHandler(_picNumber, 32, 32, "timerBasic");
			_numberAry.splice(12,_numberAry.length - 12);
			var _skillPIC:BitmapData = BitmapData(SourceProxy.GetInstance().GetMaterialSWP(_ary[0], "skillPIC", true));
			
			
			
			var _arySki:Array = SourceProxy.GetInstance().CutImgaeHandler(_skillPIC, 25, 25, "skillPIC");
			
			var _strTipsSource:MovieClip = MovieClip(SourceProxy.GetInstance().GetMaterialSWP(_ary[0], "TipBox", true));
			
			//---- 新增的品質替代TIPS
			var _strQuaOneSource:Sprite= Sprite(SourceProxy.GetInstance().GetMaterialSWP(_ary[0], "tipsQua1", true));
			var _strQuaTwoSource:Sprite= Sprite(SourceProxy.GetInstance().GetMaterialSWP(_ary[0], "tipsQua2", true));
			
			//---分割屬性圖片----
			var _equClass:MovieClip=(SourceProxy.GetInstance().GetMaterialSWP(_ary[0],"Property",true)) as MovieClip;
			var _aryProperty:Array = SourceProxy.GetInstance().GetMovieClipHandler(_equClass, false, "PropertyImages");
			
			//---creat timeBar source----
			var _vecStr:Vector.<String> =new <String>["TimerBg","TimerBar"];
			var _barObj:Object = SourceProxy.GetInstance().GetMaterialSWP(_ary[0],_vecStr);
			
			
			
			this._tipsCtrlCenter.sourceCenter={ 
			_qua1:_classBg,
			_number:_numberAry, 
			_skill:_arySki,
			_qua2:_strTipsSource,
			_qua3:_strQuaOneSource,
			_qua4:_strQuaTwoSource,
			_property:_aryProperty,
			_timeBar:_barObj.TimerBar,
			_timeBarBG:_barObj.TimerBg
			
			}; 
			
			
			EventExpress.AddEventRequest( NetEvent.NetResult , this.SetNetResultHandler ,this );
			
			this._netConnect = AmfConnector.GetInstance();
			
			this._netConnect.VoCall(new Get_TipsData());
			//---測試先回送
			//this.SendNotify(ProxyPVEStrList.TIP_PROXYReady);
		  	
			//--------取公用系統TIPS的VO-----------
			
			/*
			EventExpress.AddEventRequest( NetEvent.NetResult ,this.SetNetResultHandler,this );
			this._netConnect = AmfConnector.GetInstance();
			this._aryVoClal = [];
			this.CallConnect(ProxyPVEStrList.TIP_Call);
			*/	
		}
		/*
		private function getRealSwpHandler(_keyValue:String , _InputClassNameList:* , _NewComponent:Boolean = false):* 
		{
			//var _ary:Array = [];
			
			
			
		}*/
		
		private function SetNetResultHandler(_Result:EventExpressPackage):void 
		{
			var _netResultPack:NetResultPack =  _Result.Content as NetResultPack;
			//---switch case-------
			switch(_Result.Status) {
				case "Get_TipsData":
				var _ary:Array = _netResultPack._result as Array;
				if (_ary.length > 0 && _ary != null) {
				  this._tipsCtrlCenter.AddTips(_ary);	
				 EventExpress.RevokeAddressRequest(this.SetNetResultHandler);
				//--要整個移除掉TIPS的proxy---給commands做
				
				}
				break;	
			}
			
			
		}
		
		/*
		public function CallConnect(_type:String):void 
		{
			switch(_type) {
				case ProxyPVEStrList.TIP_Call:
					var _class:Class = this._aryVoClal[0];
					this._netConnect.VoCall(new _class);
				break;
			
			}
			
		}
		
		public function SetNetResultHandler(_Result:EventExpressPackage):void 
		{
		    var _netResultPack:NetResultPack = _Result.Content as NetResultPack;
			//-----這邊要把值跟素材處理灌回去-*----
			
		    EventExpress.RevokeAddressRequest(this.SetNetResultHandler);
		}
		
		
		*/
		public function SetTipData():void 
		{
			this._tipsCtrlCenter.SetTipData(TipsDataLab.GetTipsData());
		}
		
		public function GetTips(_type:String,_target:SendTips):* 
		{
			return this._tipsCtrlCenter.GetTips(_type,_target);
		}
		
		//---排程類的TIP顯示與否----
		public function SetTipsTimeLineVisible(_flag:Boolean,_system:String=ProxyPVEStrList.TIP_SCHER):void 
		{
			this._tipsCtrlCenter.SetTipsTimeLineVisible(_flag,_system);
		}
		
		
		public function RemoveTips(_groupName:String,_guid:String):void 
		{
			this._tipsCtrlCenter.RemoveTips(_groupName,_guid);
		}
	
	}
	
}