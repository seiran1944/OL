package MVCprojectOL.ModelOL.Alchemy
{
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Building.BuildingProxy;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.Equipment.EquipmentDataCenter;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import MVCprojectOL.ModelOL.SourceData.UserSourceCenter;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineObject;
	import MVCprojectOL.ModelOL.Vo.PlayerEquipment;
	import MVCprojectOL.ModelOL.Vo.PlayerSource;
	import MVCprojectOL.ModelOL.Vo.Recipe;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author EricHuang
	 * 煉金系統
	 * 煉金系統
	 */
	public class  AlchemyDataCenter
	{
		//----素材總表
		//private var _dicSource:Dictionary;
		//----配方總表
		private var _dicRecipe:Dictionary;
		private static var _AlchemyDataCenter:AlchemyDataCenter;
		private var _sendFunction:Function;
		private var _flag:Boolean = false;
		//----序列排程----
		//private var _dicWorking:Dictionary;
		
		//---建築物的key---(回去建築物清單查找相關的資訊)
		private var _buildGuid:String;
		private var _buildType:int;
		
		public function AlchemyDataCenter(_fun:Function) 
		{
			//----武器相關數值要來這邊拿------
			this._dicRecipe = new Dictionary(true);
			this._sendFunction = _fun;
			//this._dicSource = new Dictionary(true);
		}
		
		public static function GetAlchemy(_fun:Function=null):AlchemyDataCenter 
		{
			
			if (AlchemyDataCenter._AlchemyDataCenter == null) {
				if(_fun!=null)AlchemyDataCenter._AlchemyDataCenter=new AlchemyDataCenter(_fun);
			}
			
			return AlchemyDataCenter._AlchemyDataCenter;
		}
		
		
		public function SetBuild(_str:String,_type:int):void 
		{
			this._buildGuid = _str;
			this._buildType = _type;
		}
		
		
		//----填入基本素材
		/*
		public function AddBasicSource(_ary:Array):void 
		{
			var _len:int = _ary.length;
			for (var i:int = 0; i < _len;i++ ) {
				if (this._dicSource[_ary[i]._guid]==null && this._dicSource[_ary[i]._guid]==undefined) {
					this._dicSource[_ary[i]._guid] = _ary[i];
				}
				
			}
		}*/
		
		//-----填入配方表(隨著建築物升級而刷新)
		public function AddRecipeVO(_ary:Array):void 
		{
			var _len:int = _ary.length;
			for (var i:int = 0; i < _len;i++ ) {
				this._dicRecipe[_ary[i]._guid] = _ary[i];
			}
			/*
			var _str:String = "";
			if (this._flag==false) {
				this._flag = true;
				_str = ProxyPVEStrList.ALCHEMY_PROXYReady;
			   }else {
				_str = ProxyPVEStrList.ALCHEMY_RecipeReady;	
			}
			this._sendFunction(_str);
			*/
			this._sendFunction(ProxyPVEStrList.ALCHEMY_RecipeReady);
			
		}
		
	

		
		
		//---取得配方清單(有分類)----
		public function GetRecipeList():Dictionary
		{
			
			
			var _dicWep:Array=[];
			var _dicShield:Array=[];
			var _dicAccessories:Array = [];
			var _dicSource:Array = [];
			//---取得當前等級
			//var _nowLV:int =BuildingStock.GetBuildingStock().GetBuildLV(this._alchemyBuild);
			var _returnDic:Dictionary = new Dictionary(true);
			var _buildLV:int = BuildingProxy.GetInstance().GetBuildLV(this._buildGuid);
			
			for each(var i:Recipe in this._dicRecipe) {
				//if (_nowLV>=i._lvLock) {
				var _checkObj:Object = this.getRecipListHandler(i._aryNedSource,i._needSoul);
				var _ripFlag:Boolean = (_buildLV<i._lvLock)?false:true;
				var _obj:Object = { 
					_guid:i._guid,
					_needTimes:i._needTimes,
					_picItem:i._picItem,
					_needSoul:i._needSoul,
					_soulMaxVaule:i._soulMaxVaule,
					_detentionMaxVaule:i._detentionMaxVaule,
					_attack:i._attack,
					_defense:i._defense,
					_speed:i._speed,
					_Int:i._int,
					_mnd:i._mnd,
					_HP:i._HP,
					_showName:i._showName,
					//---_lvEquipment=0就不要秀了
					_lvEquipment:i._lvEquipment,
					//-----_lvLock
					_lvLock:i._lvLock,
					//--素材是否足夠鍊金--
					_usetype:_checkObj._useType,
					//---判別等級是否相同--
					_buildFlag:_ripFlag,
					_aryNedSource:_checkObj._ary
				};	
					
				if (i._type == 0)_dicWep.push(_obj);
				if(i._type==1)_dicShield.push(_obj);
				if(i._type==2)_dicAccessories.push(_obj);
				if(i._type==3)_dicSource.push(_obj);
				//}
				
			}
			_returnDic["wep"] = _dicWep;
			_returnDic["Shield"] = _dicShield;
			_returnDic["Accessories"] = _dicAccessories;
			_returnDic["Basic"] = _dicSource;
			
			return _returnDic;
		}
		
	
		
		//---clone AryList-----
		private function getRecipListHandler(_ary:Array,_moneySoul:int):Object 
		{
			var _len:int = _ary.length;
			var _returnAry:Array = [];
			var _soul:int = PlayerDataCenter.PlayerSoul;
			var _useing:Boolean = true;
			for (var i:int = 0; i < _len;i++ ) {
				//var _obj:Object = {_number:_ary[i]._number,_picItem:_ary[i]._picItem}
				
				//-_type//--0=武器/1=防具/2=飾品/3=素材合成
				//var _sourceNumber:int = 0;
				//var _SourcePicItem:String = "";
				var _objSource:Object = { };
				
				if (_ary[i]._type<3) {
					
					//---裝備類----
					_useing=EquipmentDataCenter.GetEquipment().CheckSourceReady(_ary[i]._guid,_ary[i]._type, _ary[i]._number);
					
					} else {
					//---素材
					if (UserSourceCenter.GetUserSourceCenter().CheckSource(_ary[i]._guid, _ary[i]._number) == false)_useing = false;
				  
				}
				//_objSource._number = _sourceNumber;
				//_objSource._picItem = _SourcePicItem;
				
				_returnAry.push({_number:_ary[i]._number,_picItem:_ary[i]._picItem,_guid:_ary[i]._guid,_type:_ary[i]._type,_info:_ary[i]._info});
			}
			//----錢不夠的狀態---
			if (_soul < _moneySoul)_useing = false;
			var _reeturnObj:Object = {_useType:_useing,_ary:_returnAry};
			
			return _reeturnObj;
			
		}
		
		
		//---check配方數量是否齊全----配方表的key塞進來-----
		public function GetCheckRecipe(_key:String):Object 
		{
			//---需回傳
			var _returnObj:Object;
			var _arySourceInfo:Array=[];
			//---再次確認該項合成列表是否可以使用(素材是否足夠)
			var _singleFlag:Boolean = true;
			if (this._dicRecipe[_key]!=null && this._dicRecipe[_key]!=undefined) {
				var _ary:Array = this._dicRecipe[_key]._aryNedSource;			
				var _len:int = _ary.length;
				for (var i:int = 0; i < _len; i++ ) 
				{
					//--玩家現有的狀態
					var _playerSourceNum:int = 0;
					var _needSourceNum:int = _ary[i]._number;
					if (_ary[i]._type<3) {
						//-----該品項是裝背
						//_playerSourceNum=EquipmentDataCenter.GetEquipment().GetSingleEquSource(_ary[i]._guid,_ary[i]._type);
						_playerSourceNum=EquipmentDataCenter.GetEquipment().GetAndCheckSingleEquSource(_ary[i]._guid,_ary[i]._type);
						} else {
						//----該品項是普通素材
						_playerSourceNum=UserSourceCenter.GetUserSourceCenter().GetSourceSingleNum(_ary[i]._guid);
					    
					}
					
					var _usetype:Boolean = (_playerSourceNum >= _needSourceNum)?true:false;
					
					if (_usetype == false)_singleFlag = false;
					
					//----回傳細項-----
				    var _obj:Object={_use:_usetype,_need:_needSourceNum,_player:_playerSourceNum}
					_arySourceInfo.push(_obj);
					
				}
				if (PlayerDataCenter.PlayerSoul < this._dicRecipe[_key]._needSoul)_singleFlag = false;
				
				if (BuildingProxy.GetInstance().GetBuildLV(this._buildGuid)<this._dicRecipe[_key]._lvLock)_singleFlag = false;
					
				
				} else {
				_singleFlag = false;
				_arySourceInfo = [];
			}
			
			//-------_singleFlag=該物件是否可生產,_arySourceInfo=生產細項
			return {_useFlag:_singleFlag,_aryInfo:_arySourceInfo};
			
		}
		
		//---取得時間排程
		public function GetLine():Array 
		{
			return TimeLineObject.GetTimeLineObject().GetAllLine(this._buildGuid);
		}
		
		//----取得單一配方的相關資訊(TIPS)專用
		public function GetSingleRecipeInfo(_guid:String):Object 
		{
			var _obj:Object;
			if (this._dicRecipe[_guid]!=null && this._dicRecipe[_guid]!=undefined) {
				_obj = {
				_picItem:this._dicRecipe[_guid]._picItem,	
				_attack:this._dicRecipe[_guid]._attack,
				_defense:this._dicRecipe[_guid]._defense,
				_speed:this._dicRecipe[_guid]._speed,
				_int:this._dicRecipe[_guid]._int,
				_mnd:this._dicRecipe[_guid]._mnd,
				_HP:this._dicRecipe[_guid]._HP
				}
			}
			
			return _obj;
		}
		
		
		
		
		//---..扣掉原本持有的
		/*
		public function ReduceSource(_Key:int):void 
		{
		    var _ary:Array = this._dicRecipe[_Key]._aryNedSource;
			var _len:int = _ary.length;
			var _UserSourceCenter:UserSourceCenter = UserSourceCenter.GetUserSourceCenter();
			for (var i:int = 0; i < _len;i++ ) {
				//---check要扣除的素材是哪一個類型的----
				if (_type==3) {
					_UserSourceCenter.UseSource(_ary[i].key, _ary[i]._number);
					} else {
					//---check裝備是否足夠
					
					
				}
				
				
				
				
			}
			//------send訊息~背包會因此修改數量
			
		}
		*/
		//---製作完成後..成功合成後(裝備回到背包裡面)
		/*
		public function CompleteAlchemy(_ary:Array):void 
		{
			//----_ary裡面裝的是物件VO(裝備的)
			EquipmentDataCenter.GetEquipment().AddEquipment(_ary);
			
			
			//----移除排程---*------
			//---server回寫資訊做相關異動
			//----server不過的情況下.....強制重整畫面
			
			
			
		}*/
		
		
		//---取得TIPS的VO----
		public function GetTipsVO(_obj:Object):* 
		{
			var _returnVO:*;
			//if (_obj._type<3) {
				//---裝備
				//_returnVO = EquipmentDataCenter.GetEquipment().GetSingleVOTips(_obj) as PlayerEquipment;
				
			//}else {
				//---素材
				//_returnVO = UserSourceCenter.GetUserSourceCenter().GetSourceTips(_obj) as PlayerSource;
		        if (this._dicRecipe[_obj._rGuid]!=null && this._dicRecipe[_obj._rGuid]!=undefined) {
					for (var i:* in this._dicRecipe[_obj._rGuid]._aryNedSource) {
						if (this._dicRecipe[_obj._rGuid]._aryNedSource[i]._guid==_obj._guid) {
						
							_returnVO = { _showName:this._dicRecipe[_obj._rGuid]._aryNedSource[i]._showName, _showInfo:this._dicRecipe[_obj._rGuid]._aryNedSource[i]._showInfo };
							
							break;
						}
						
					}
					
					
				}	
				
				
				
				
			//}
			
			return _returnVO;
			
		}
		
		
		
		//----開始鍛造(符合條件下)//-----回傳鍛造排程檢查結果--0=ok/1=排程已滿
		public function StarForging(_key:String):Array 
		{
			
			var _aryReturn:Array = [];
			if (this._dicRecipe[_key]!=null&& this._dicRecipe[_key]!=undefined) {
				var _ary:Array = this._dicRecipe[_key]._aryNedSource;
				var _len:int = _ary.length;
				if (_len>0) {
					var _serverReduce:Array = [];
					for (var i:int = 0; i < _len;i++ ) {
						if (_ary[i]._type<3) {
							//---素材為裝背
							//--把要扣除的物件guid丟給_serverReduce
							EquipmentDataCenter.GetEquipment().UseAlchemy(_ary[i]._type,_ary[i]._guid);
							
							} else {
							//----素材是普通素材
							UserSourceCenter.GetUserSourceCenter().UseSource(_ary[i]._guid, _ary[i]._number);
						}
						
						
					}
					//----扣除靈魂---
					PlayerDataCenter.addSoul(-(this._dicRecipe[_key]._needSoul));
					var _starTime:uint = ServerTimework.GetInstance().ServerTime;		
					var _needTime:uint = uint(this._dicRecipe[_key]._needTimes);
					TimeLineObject.GetTimeLineObject().AddTimeLine(this._buildGuid, _key, _starTime, _needTime, this._buildType);
					var _aryReturn:Array=TimeLineObject.GetTimeLineObject().GetAllLine(this._buildGuid);
					
				}
				
				
				
				} else {
				
				
				trace("查不到此素材配方表");
				
			}
			
			
			return _aryReturn;
			
			
			
		}
		
		
		
		//----使用現金完成--------
		/*
		public function UseCash(_key:int):void 
		{
			this.StarForging(_key);
		}
		*/
		
		
		
	}
	
}