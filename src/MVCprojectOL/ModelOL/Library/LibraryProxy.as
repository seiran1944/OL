package MVCprojectOL.ModelOL.Library 
{
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Building.BuildingProxy;
	import MVCprojectOL.ModelOL.Vo.Get.Get_PlayerLibrary;
	import MVCprojectOL.ModelOL.Vo.PlayerLibrary;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class  LibraryProxy extends ProxY  
	{
		
		private var _libraryCenter:LibraryCenter;
		private var _netConnect:AmfConnector; 
		private var _aryVoClall:Array;
		//---建築物等級----
	    private var _buildLv:int = 0;
		
		private var _getfunBuildLv:Function;
		private var _buildGuid:String = "";
		public function LibraryProxy() 
		{
			super(ProxyPVEStrList.LIBRARY_PROXY);
		}
		
		
		//1.大廳（魔法陣）, 2.巢穴 3.溶解所, 4.圖書館, 5.儲藏室, 6.煉金所, 7.牢房, 8.英靈室;
		override public function onRegisteredProxy():void 
		{
			
			//---掛監聽EventExpress
			this._libraryCenter = LibraryCenter.GetLibrary(this.SendNotify);
			//---取得建築物的GUID----
			this._buildGuid=BuildingProxy.GetInstance().GetBuildingGuid(4);
			this._libraryCenter.SetbuildKey(this._buildGuid, 4);
			this._getfunBuildLv = BuildingProxy.GetInstance().GetBuildLV;
			EventExpress.AddEventRequest( NetEvent.NetResult , this.SetNetResultHandler ,this );
			this._netConnect = AmfConnector.GetInstance();
			//----需要再擴增
			this._aryVoClall = [Get_PlayerLibrary];
			//this.ConnectVOCall(ProxyPVEStrList.LIBRARY_GetSKILL);
			this.SendNotify(ProxyPVEStrList.LIBRARY_PROXYReady);
			//this.SendNotifyHandler(ProxyPVEStrList.STONE_PROXYReady);
			
		}
		
		
		
		private function SetNetResultHandler(_Result:EventExpressPackage):void 
		{
			var _netResultPack:NetResultPack =  _Result.Content as NetResultPack;
			//---switch case-------
			switch(_Result.Status) {
				case "PlayerLiabrary":
				var _ary:Array = _netResultPack._result as Array;
				//var _ary:PlayerLibrary = _netResultPack._result as PlayerLibrary;
				if (_ary.length>0 ) {	
				 this._libraryCenter.SetUseSkill(PlayerLibrary(_ary[0]));   	
				}
				//-----要移除監聽(移除連線監聽)12/19
			    //EventExpress.RevokeAddressRequest(this.SetNetResultHandler);
				break;	
			}
			
			
		}
		
		
		//----連線(持續擴增)
		public function ConnectVOCall(_type:String):void 
		{
			var _class:Class;
			
			switch(_type) {
				
				//---圖書館技能取得
				case ProxyPVEStrList.LIBRARY_GetSKILL:	
					
					_class = this._aryVoClall[0];
					this._netConnect.VoCall(new _class);
					//this._netConnect.ConnectMode = "Manual";
					//this._netConnect.VoCall(new Get_PlayerMonster());
					//this._netConnect.StartQueue();
				break;
			}
		}
		
		//---取得所有技能的KEY--
		public function GetSLibrarykill():Dictionary 
		{
		    
			var _dic:Dictionary;
			
			var _nowBuildLV:int = int(this._getfunBuildLv(_buildGuid));
			if (this._buildLv!=_nowBuildLV) {
				this.ConnectVOCall(ProxyPVEStrList.LIBRARY_GetSKILL);
				this._buildLv = _nowBuildLV;
			}else {
				_dic=this._libraryCenter.GetLibSkill();
			}
			
			return _dic;
		}
		
		
		
		
		
		//----檢查圖書館排程
		public function CheckLineIllegal():Boolean 
		{
			
			return this._libraryCenter.CheckLineIllegal();
		}
		
		//---取得時間排程
		public function GetLine():Array 
		{
			return this._libraryCenter.GetLine();
		}
		
		//----檢查怪獸學習技能的狀況
		//---0=技能以滿,詢問是否附蓋/1=技能尚有空位/2=error(沒有該怪獸的資料/怪獸不存在)/3=怪獸目前疲勞滿百無法使用/4=金錢不夠/5=怪獸目前不是閒置
		public function CheckLearnStates(_monsterID:String):int 
		{
			return this._libraryCenter.CheckLearnStates(_monsterID);
		}
		
		//---學習技能-----
		public function StarLearning(_skillGroup:String,_monsterID:String,_changeSkill:String=""):Array 
		{
			return this._libraryCenter.StarLearning(_skillGroup,_monsterID,_changeSkill);
		}
		
		
	}
	
}