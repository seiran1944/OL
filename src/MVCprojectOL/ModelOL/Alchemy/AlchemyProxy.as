package MVCprojectOL.ModelOL.Alchemy
{
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Building.BuildingProxy;
	import MVCprojectOL.ModelOL.Vo.Get.Get_Recipe;
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
	public class AlchemyProxy extends ProxY 
	{
		
		private var _AlchemyDataCenter:AlchemyDataCenter;
		private var _netConnect:AmfConnector; 
		private var _aryVoClall:Array;
		
		private var _buildLV:int = 0;
		private var _buildGuid:String = "";
		private var _getfunBuildLv:Function;
		public function AlchemyProxy() 
		{
			super(ProxyPVEStrList.ALCHEMY_PROXY,this);
		}
		
		//1.大廳（魔法陣）, 2.巢穴 3.溶解所, 4.圖書館, 5.儲藏室, 6.煉金所, 7.牢房, 8.英靈室;
		override public function onRegisteredProxy():void 
		{
			
			//---掛監聽EventExpress
			
			this._AlchemyDataCenter = AlchemyDataCenter.GetAlchemy(this.SendNotifyHandler);
			//---取得建築物的GUID----
			this._buildGuid=BuildingProxy.GetInstance().GetBuildingGuid(6);
			this._AlchemyDataCenter.SetBuild(this._buildGuid,6);
			this._getfunBuildLv = BuildingProxy.GetInstance().GetBuildLV;
			EventExpress.AddEventRequest( NetEvent.NetResult , this.SetNetResultHandler ,this );
			this._netConnect = AmfConnector.GetInstance();
			//----需要再擴增
			this._aryVoClall = [Get_Recipe];
			//this.ConnectVOCall(ProxyPVEStrList.ALCHEMY_RecipeCHANGE);
			
			this.SendNotifyHandler(ProxyPVEStrList.ALCHEMY_PROXYReady);
			
		}
		
		
		//----sendNotify
		private function SendNotifyHandler(_str:String,_obj:Object=null):void 
		{
			this.SendNotify(_str,_obj);
		}
		
		private function SetNetResultHandler(_Result:EventExpressPackage):void 
		{
			var _netResultPack:NetResultPack =  _Result.Content as NetResultPack;
			//---switch case-------
			switch(_Result.Status) {
				case "PlayerRecipe":
				// this.AddStone(_netResultPack._result as Array);	
				var _ary:Array = _netResultPack._result as Array;
				if(_ary.length>0)this._AlchemyDataCenter.AddRecipeVO(_ary);   
				break;	
			}
		}
		
		//----連線(持續擴增)
		public function ConnectVOCall(_type:String):void 
		{
			var _class:Class;
			
			switch(_type) {
				
				//---取得配方表
				case ProxyPVEStrList.ALCHEMY_RecipeCHANGE:	
					
					_class = this._aryVoClall[0];
					this._netConnect.VoCall(new _class);
					//this._netConnect.ConnectMode = "Manual";
					//this._netConnect.VoCall(new Get_PlayerMonster());
					//this._netConnect.StartQueue();
				break;
			}
		}
		
		//---2013/06/12-檢查配方表是否需要更新----
		public function CheckAlchemyList():Boolean 
		{
		    var _flag:Boolean;
			var _nowBuildLV:int = int(this._getfunBuildLv(_buildGuid));
			if (this._buildLV != _nowBuildLV) {
			   	_flag = false;
				this._buildLV = _nowBuildLV;
			}else {
				_flag = true;	
			}
			
			return _flag;
		}
		
		
		public function GetNewRecipeList():void 
		{
			this.ConnectVOCall(ProxyPVEStrList.ALCHEMY_RecipeCHANGE);
		}
		
		//----取得鍊金配方清單
		public function GetRecipeList():Dictionary 
		{
			/*
			var _dic:Dictionary;
			
			var _nowBuildLV:int = int(this._getfunBuildLv(_buildGuid));
			if (this._buildLV!=_nowBuildLV) {
				this.ConnectVOCall(ProxyPVEStrList.ALCHEMY_RecipeCHANGE);
				this._buildLV = _nowBuildLV;
			}else {
				_dic=this._AlchemyDataCenter.GetRecipeList();
			}*/
			return this._AlchemyDataCenter.GetRecipeList();;
		}
		
		//---check配方數量是否齊全----配方表的key塞進來-----
		public function GetCheckRecipe(_key:String):Object 
		{
			return this._AlchemyDataCenter.GetCheckRecipe(_key);
			//--{_useFlag:_singleFlag,_aryInfo:_arySourceInfo}
			//---_useFlag>這個配方目前是否可以鍊(true/false)
			//---_aryInfo>生產細項(_ary-物件陣列)
			//---{_use:該單像是否足夠(true/false),_need:需要的數量,_player:玩家持有}
		}
		
		//---取得時間排程
		public function GetLine():Array 
		{
			return this._AlchemyDataCenter.GetLine();
		}
		
		//----開始鍛造(符合條件下_key=配方表的KEY)
		public function StarForging(_key:String):Array 
		{
			return this._AlchemyDataCenter.StarForging(_key);
		}
		
	}
	
}