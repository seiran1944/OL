package MVCprojectOL.ModelOL.Equipment
{
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import MVCprojectOL.ModelOL.Vo.PlayerEquipment;
	import strLib.proxyStr.ProxyPVEStrList;
	import UtilsGame.CoustomSort;
	
	/**
	 * ...
	 * @author EricHuang
	 * 裝備的處理工具
	 */
	public class EquipmentDataCenter 
	{
		
		//private var _dicVOEquipment:Dictionary;
		private var _dicWeapon:Dictionary;
		private var _dicShield:Dictionary;
		private var _dicAccessories:Dictionary;
		
		private static var _Equipment:EquipmentDataCenter;
		
		private var _aryDicGroup:Array;
		private var _sendFunction:Function; 
		private var _flag:Boolean = false;
		
		public function EquipmentDataCenter(_fun:Function) 
		{
			this._dicWeapon = new Dictionary(true);
			this._dicShield = new Dictionary(true);
			this._dicAccessories = new Dictionary(true);
			this._aryDicGroup = [this._dicWeapon,this._dicShield,this._dicAccessories];
		    this._sendFunction = _fun;
		}
		
		
		public static function GetEquipment(_fun:Function=null):EquipmentDataCenter 
		{
			
			if (EquipmentDataCenter._Equipment == null) {
				if(_fun!=null)EquipmentDataCenter._Equipment=new EquipmentDataCenter(_fun);
			}
			
			return EquipmentDataCenter._Equipment;
		}
		
		
		//----需要真正的使用鍊金在進行排序
		//---添加/重整裝被資訊
		public function AddEquipment(_ary:Array):void 
		{
			
			var _len:int = _ary.length;
			if (_len > 0) {
				for (var i:int = 0; i < _len;i++ ) {
				var _dic:Dictionary = this._aryDicGroup[_ary[i]._type];
				if (_dic[_ary[i]._gruopGuid]!=null && _dic[_ary[i]._gruopGuid]!=undefined) {
					_dic[_ary[i]._gruopGuid].push(_ary[i]);
					} else {
					_dic[_ary[i]._gruopGuid] = [_ary[i]];
				}	
			}
				
			}
			
			var _str:String = "";
			if (this._flag==false) {
				this._flag = true;
				_str = ProxyPVEStrList.EQUIPMENT_PROXYReady;
			   }else {
				_str = ProxyPVEStrList.EQUIPMENT_ADDReady;	
			}
			this._sendFunction(_str);
			
			
		}
		
		public function GetTestVO(_groupKey:String,_guidID:String):PlayerEquipment 
		{
			var _getType:int = this.getEquDicHandler(_groupKey);
			var _returnEqu:PlayerEquipment = this.GetSingleVOTips({_type:_getType,_group:_groupKey,_guid:_guidID});
			return _returnEqu;
		}
		
		//---2013/3/14-----tips專用抓取單獨的VO---
		public function GetSingleVOTips(_obj:Object):PlayerEquipment 
		{
			var _voEqu:PlayerEquipment;
			var _dic:Dictionary=this._aryDicGroup[_obj._type];
			if (_dic[_obj._group]!=null && _dic[_obj._group]!=undefined) {
				var _ary:Array = _dic[_obj._group];
				var _len:int = _ary.length;
				for (var i:int = 0; i < _len;i++ ) {
					if (_ary[i]._guid==_obj._guid) {
					 _voEqu = _ary[i];
					 break;
					}
					
				}
			
			}
			
			return _voEqu;
		}
		
		/*
		public function GetSingleEquPicItem(_groupKey:String,_guid:String):String 
		{
			
			var _type:int = this.getEquDicHandler(_groupKey);
			var _urlStr:String = "";
			if (this._aryDicGroup[_type][_groupKey]!=null && this._aryDicGroup[_type][_groupKey]!=undefined) {
				var _len:int =this._aryDicGroup[_type][_groupKey].length;
				if (_len>0) {
				   for (var i:int = 0;i < _len; i++) {
					    if (this._aryDicGroup[_type][_groupKey][i]._guid==_guid) {
						_urlStr = this._aryDicGroup[_type][_groupKey][i]._picItem;
						break;	
						}
					
				   }
					
				}
				
				
			}
			
			return _urlStr;
			
		}
		*/
		
		public function GetCompleteinfo(_type:int,_groupKey:String,_guiD:String):Array 
		{
			var _aryReturn:Array;
			if (this._aryDicGroup[_type][_groupKey]!=null && this._aryDicGroup[_type][_groupKey]!=undefined) {
				var _len:int =this._aryDicGroup[_type][_groupKey].length;
				if (_len>0) {
				   for (var i:int = 0;i < _len; i++) {
					    if (this._aryDicGroup[_type][_groupKey][i]._guid==_guiD) {
						_aryReturn = [
						this._aryDicGroup[_type][_groupKey][i]._picItem,
						this._aryDicGroup[_type][_groupKey][i]._guid,
						6,
						5+this._aryDicGroup[_type][_groupKey][i]._type,
						5
						];	
						break;	
						}
					
				   }
					
				}
				
			}
			
			return _aryReturn;
			
		}
		
		
		//----要扣除使用鍊金-----12/12
		public function UseAlchemy(_type:int,_groupID:String):String 
		{
			CoustomSort.sortType = PlaySystemStrLab.Sort_EquQuality;
			//---告知SERVER要被刪掉的物品----
			var _strGuid:String = "";
			var _dic:Dictionary = this._aryDicGroup[_type];
			//----需要濾掉我指定條件的物件
			if (_dic[_groupID]!=null && _dic[_groupID]!=undefined) {
				var _ary:Array = _dic[_groupID];
				if (_ary.length>0) { 
				    _ary.sort(CoustomSort.SortHandler);
					CoustomSort.sortType = PlaySystemStrLab.Sort_EquQuality;
					_ary.sort(CoustomSort.SortHandler);
					_strGuid = _ary[0]._guid;
					//---目前的排序是小->大
					//_ary.pop();
					//_ary.shift();
					var _len:int = _ary.length;
					for (var i:int = 0; i < _len;i++ ) {
						if (_ary[i]._useing==1) {
							_ary.splice(i,1);
							break;
						}	
					}
					
					
					if (_ary.length <= 0) {
					_dic[_groupID] = null;
					delete _dic[_groupID];	
					}
					
				}
				} else {
				
				trace("查無此物品");
				
			}
			
			return _strGuid;
		}
		
		//---//---obj>{_type:int,_guid:String,_number:int,_picItem:String,_info:String}
		
		//---check使用者在初始狀態是否有足夠的鍊金素材類
		public function CheckSourceReady(_groupID:String,_type:int,_number:int):Boolean 
		{
			
			var _dic:Dictionary = this._aryDicGroup[_type];
			var _flag:Boolean=false;
			if (_dic[_groupID]!=null && _dic[_groupID]!=undefined) {
				
				_flag = (_dic[_groupID].length>=_number)?true:false;
				
			}
			
			return _flag;
		}
		
		
		//---取得該品項裝備數量
		public function GetSingleEquSource(_group:String,_type:int):int 
		{
			
			var _sourceNumber:int;
			
			if (this._aryDicGroup[_type][_group]!=null &&this._aryDicGroup[_type][_group]!=undefined) {
				
				_sourceNumber =this._aryDicGroup[_type][_group].length;
				
				} else {
				_sourceNumber = 0;
				
			}
			
			return _sourceNumber;
		}
		
		
		//---2013/06/12-----
		public function GetAndCheckSingleEquSource(_group:String,_type:int):int 
		{
			
			var _sourceNumber:int=-1;
			
			if (this._aryDicGroup[_type][_group]!=null &&this._aryDicGroup[_type][_group]!=undefined) {
				
				var _len:int= this._aryDicGroup[_type][_group].length;
				_sourceNumber = _len;
				//---撿查有被掛賣或是被使用的情況下
				for (var i:int = 0; i < _len;i++ ) {
					if (this._aryDicGroup[_type][_group][i]._monsterID!="" || this._aryDicGroup[_type][_group][i]._useing!=1) {
						_sourceNumber -= 1;
					}
				}
				
				} else {
				_sourceNumber = 0;
				
			}
			
			return _sourceNumber;
		}
		
		
		
		
		/*
		//----取得單一分類的全部(背包專用)
		private function GetEquSingleAll(_index:String):Dictionary 
		{
			
			var _returnEqu:Dictionary;
			
			switch(_index) {	
			 case PlaySystemStrLab.Package_Weapon:
				 _returnEqu = this._dicWeapon;
			 break;	 
				
		     case PlaySystemStrLab.Package_Shield:
			    _returnEqu = this._dicShield;
			 break;
			 
		     case PlaySystemStrLab.Package_Accessories:
			   _returnEqu = this._dicAccessories;
			 break;
				
			}
			return _returnEqu;	
		}*/
		
		//---RemoveEquipment
		//---0=this._dicWeapon,1=this._dicShield,2=this._dicAccessories];
		public function RemoveEquipment(_group:String,_guid:String,_dictype:int):void 
		{
			 //var _dic:Dictionary = this.GetEquSingleAll(_type);
			 //_dic:Dictionary = this._aryDicGroup[_dictype];
			 if (this._aryDicGroup[_dictype][_group]!=null && this._aryDicGroup[_dictype][_group]!=undefined) {
				  //var _ary:Array = this._aryDicGroup[_dictype][_group];
				  var _len:int = this._aryDicGroup[_dictype][_group].length;
				  for (var i:int = 0; i < _len;i++ ) {
					if (this._aryDicGroup[_dictype][_group][i]._guid==_guid) {
						this._aryDicGroup[_dictype][_group].splice(i,1)
						if (this._aryDicGroup[_dictype][_group].length <= 0) delete this._aryDicGroup[_dictype][_group];
						break;
					}  
					 
				   }
				    
				}else {
					
				trace("error_equdata");
					
				}
			 
			
		}
		
	    //----<<舊的>>改變使用狀態(//----使用狀態-0:刪除, 1:閒置, 2:溶解 3出戰 4掛賣-----)-----
		//----0.刪除, 1.閒置（在儲藏室）, 2.消耗中（裝備素材合成、道具使用）, 3.被裝備中（只有裝備才會有這狀態，魔晶石、英靈被鑲嵌後是直接被改為刪除狀態的）, 4.掛賣中
		public function ChangeUseing(_group:String,_guid:String,_type:int,_status:int,_monsterID:String=""):void 
		{
            //var _keyType:String = this.getTypeHandler(_type);
			//var _dic:Dictionary = this.GetEquSingleAll(this.getTypeHandler(_type));
			//_dic[_index]._useing = _status;
			if (this._aryDicGroup[_type][_group]!=null && this._aryDicGroup[_type][_group]!=undefined) {
				var _len:int = this._aryDicGroup[_type][_group].length;
				var _flag:Boolean = false;
				for (var i:int = 0; i < _len;i++ ) {
					if (this._aryDicGroup[_type][_group][i]._guid==_guid) {
						this._aryDicGroup[_type][_group][i]._useing=_status;
						_flag = true;
						if (_monsterID!="" && _status==3) this._aryDicGroup[_type][_group][i]._monsterID = _monsterID;
						if (_status == 0 || _status == 1 || _status == 4) this._aryDicGroup[_type][_group][i]._monsterID = "";
						
						break;
					}
				}
				
				if (_flag == false) trace("ERROR_查無該裝備");
				
				
			}
			
			//---如果裝備被掛賣/被使用---會在回傳讓顯示清單更新-----
			
		}
		
		//---取得分類的總數量
		//----0=武器/1=防具/2=飾品
		public function GetNowNumber(_type:int):int 
		{
			var _number:int = 0;
			var _dicTarget:Dictionary = this._aryDicGroup[_type];
			for (var i:String in _dicTarget) {
				var _len:int = _dicTarget[i].length;
				_number += _len;
			}
			return _number;
		}
		
		
		
		//----特殊需求(取全部的裝備)
		public function GetEquAllPackage():Dictionary 
		{
			//----10/02特殊需求(背包)-------
			//---0=this._dicWeapon,1=this._dicShield,3=this._dicAccessories];
			var _dic:Dictionary = new Dictionary(true);
			var _len:int = this._aryDicGroup.length;
			var _aryStr:Array = [PlaySystemStrLab.Package_Weapon,PlaySystemStrLab.Package_Shield,PlaySystemStrLab.Package_Accessories];
			for (var i:int = 0; i < _len;i++ ) {
				var _aryJoin:Array = [];
				for (var j:String in this._aryDicGroup[i]) {
					var _aryLen:int = this._aryDicGroup[i][j].length;
					for (var k:int = 0; k < _aryLen;k++ ) {
						var _obj:Object = {
						_type:this._aryDicGroup[i][j][k]._type,
						_picItem:this._aryDicGroup[i][j][k]._picItem,
						_detentionMaxVaule:this._aryDicGroup[i][j][k]._detentionMaxVaule,
						_detentionNowVaule:this._aryDicGroup[i][j][k]._detentionNowVaule,
						_useing:this._aryDicGroup[i][j][k]._useing,
						_soulMaxVaule:this._aryDicGroup[i][j][k]._soulMaxVaule,
						_nowSoulVaule:this._aryDicGroup[i][j][k]._nowSoulVaule,
						_quality:this._aryDicGroup[i][j][k]._quality,
						_showInfo:this._aryDicGroup[i][j][k]._showInfo,
						_soulAtk:this._aryDicGroup[i][j][k]._soulAtk,
						_soulDef:this._aryDicGroup[i][j][k]._soulDef,
						_soulSpeed:this._aryDicGroup[i][j][k]._soulSpeed,
						_soulInt:this._aryDicGroup[i][j][k]._soulInt,
						_soulMnd:this._aryDicGroup[i][j][k]._soulMnd,
						_soulHP:this._aryDicGroup[i][j][k]._soulHP,
						_atk:this._aryDicGroup[i][j][k]._attack,
						_def:this._aryDicGroup[i][j][k]._defense,
						_speed:this._aryDicGroup[i][j][k]._speed,
						_Int:this._aryDicGroup[i][j][k]._int,
						_mnd:this._aryDicGroup[i][j][k]._mnd,
						_HP:this._aryDicGroup[i][j][k]._HP,
						_guid:this._aryDicGroup[i][j][k]._guid,
						_lvEquipment:this._aryDicGroup[i][j][k]._lvEquipment,	
						_showName:this._aryDicGroup[i][j][k]._showName,	
						_gruopGuid:this._aryDicGroup[i][j][k]._gruopGuid,
						//---裝備目前被誰穿上了
						_monsterID:this._aryDicGroup[i][j][k]._monsterID
					  }	
						
					  _aryJoin.push(_obj);	
					}
					
					
				}
			   _dic[_aryStr[i]] = _aryJoin;
				
				//var _ary:Array = this.getEquAllHandler(i);
				//if (i == 0)_dic[PlaySystemStrLab.Package_Weapon] = _ary;
				//if (i == 1)_dic[PlaySystemStrLab.Package_Shield] = _ary;
				//if (i == 2)_dic[PlaySystemStrLab.Package_Accessories] = _ary;
			}
			return _dic;
		}
		
		
		//---取得交易所單一頁籤----
		public function GetSingleSellEqu(_type:int):Array 
		{
			var _returnAry:Array = [];
			var _dicTarget:Dictionary = this._aryDicGroup[_type];
			
			for (var i:String in _dicTarget) {
				var _aryTarget:Array = _dicTarget[i];
				var _len:int = _aryTarget.length;
			    for (var k:int = 0; k < _len;k++ ) {
				   if (_aryTarget[k]._isTradable==1 && _aryTarget[k]._monsterID=="" && _aryTarget[k]._useing==1) {
					   var _obj:Object = {
						_type:_aryTarget[k]._type,
						_picItem:_aryTarget[k]._picItem,
						//_detentionMaxVaule:_aryTarget[k]._detentionMaxVaule,
						//_detentionNowVaule:_aryTarget[k]._detentionNowVaule,
						//_useing:_aryTarget[k]._useing,
						//_soulMaxVaule:_aryTarget[k]._soulMaxVaule,
						//_nowSoulVaule:_aryTarget[k]._nowSoulVaule,
						//_quality:_aryTarget[k]._quality,
						_showInfo:_aryTarget[k]._showInfo,
						//_soulAtk:_aryTarget[k]._soulAtk,
						//_soulDef:_aryTarget[k]._soulDef,
						//_soulSpeed:_aryTarget[k]._soulSpeed,
						//_soulInt:_aryTarget[k]._soulInt,
						//_soulMnd:_aryTarget[k]._soulMnd,
						//_soulHP:_aryTarget[k]._soulHP,
						//_atk:_aryTarget[k]._attack,
						//_def:_aryTarget[k]._defense,
						//_speed:_aryTarget[k]._speed,
						//_Int:_aryTarget[k]._int,
						//_mnd:_aryTarget[k]._mnd,
						//_HP:_aryTarget[k]._HP,
						_guid:_aryTarget[k]._guid,
						//_lvEquipment:_aryTarget[k]._lvEquipment,	
						_showName:_aryTarget[k]._showName,	
						_gruopGuid:_aryTarget[k]._gruopGuid
						//---裝備目前被誰穿上了
						//_monsterID:_aryTarget[k]._monsterID
					  }	
					 _returnAry.push(_obj); 
					   
					   
					} 
		        }
				
			}
			
			return _returnAry;
			
		}
		
		
		//---取單一的類別群組出來
		
		public function GetSingleTypeEqu(_type:int):Array 
		{
			var _returnAry:Array = [];
			var _dicTarget:Dictionary = this._aryDicGroup[_type];
			
			for (var i:String in _dicTarget) {
				var _aryTarget:Array = _dicTarget[i];
				var _len:int = _aryTarget.length;
			    for (var k:int = 0; k < _len;k++ ) {
				var _obj:Object = {
						_type:_aryTarget[k]._type,
						_picItem:_aryTarget[k]._picItem,
						_detentionMaxVaule:_aryTarget[k]._detentionMaxVaule,
						_detentionNowVaule:_aryTarget[k]._detentionNowVaule,
						_useing:_aryTarget[k]._useing,
						_soulMaxVaule:_aryTarget[k]._soulMaxVaule,
						_nowSoulVaule:_aryTarget[k]._nowSoulVaule,
						_quality:_aryTarget[k]._quality,
						_showInfo:_aryTarget[k]._showInfo,
						_soulAtk:_aryTarget[k]._soulAtk,
						_soulDef:_aryTarget[k]._soulDef,
						_soulSpeed:_aryTarget[k]._soulSpeed,
						_soulInt:_aryTarget[k]._soulInt,
						_soulMnd:_aryTarget[k]._soulMnd,
						_soulHP:_aryTarget[k]._soulHP,
						_atk:_aryTarget[k]._attack,
						_def:_aryTarget[k]._defense,
						_speed:_aryTarget[k]._speed,
						_Int:_aryTarget[k]._int,
						_mnd:_aryTarget[k]._mnd,
						_HP:_aryTarget[k]._HP,
						_guid:_aryTarget[k]._guid,
						_lvEquipment:_aryTarget[k]._lvEquipment,	
						_showName:_aryTarget[k]._showName,	
						_gruopGuid:_aryTarget[k]._gruopGuid,
						//---裝備目前被誰穿上了
						_monsterID:_aryTarget[k]._monsterID
					  }	
					 _returnAry.push(_obj); 

		    }
				
				
			}
			
			return _returnAry;
			
		}
		
		//-----取得怪獸身上的裝備相關數據-----
		public function GetMonsterEqu(_ary:Array):Array 
		{
			
		   var _len:int = _ary.length;
		   var _returnAry:Array = [];
		   for (var i:int = 0; i < _len;i++ ) {
			 var _obj:*;
			 if (_ary[i]!="") {	   
			 var _dic:Dictionary = this._aryDicGroup[this.getEquDicHandler(_ary[i]._gruopGuid)];
			 //var _voObject:Object = this.getSingleEquVOHandler(_ary[i]._gruopGuid, _dic);
			 var _voEqu:PlayerEquipment = this.getSingleEquVOHandler(_ary[i]._guid, _dic);
			 var _equPlus:Object = this.getSingleEquVauleHandler(_voEqu);
			
			 //var _index:int = _ary[i]._equGID;
			    _obj= {
				_guid : _voEqu._guid,
				_showName :_voEqu._showName,
				_picItem:_voEqu._picItem,
				_groupGuid:_voEqu._gruopGuid,
				_type:_voEqu._type
				//----用Key去查找-----
				//_PicItem :_dic[_index]._index,
				//--禁錮能力
				//_detentionMaxVaule :_voEqu._detentionMaxVaule,
				//_detentionNowVaule :_voEqu._detentionNowVaule,
				//----英靈容量值
				//_soulMaxVaule : _voEqu._soulMaxVaule,
				//_nowSoulVaule :_voEqu._nowSoulVaule, 
				 
				//_attack:_voEqu._attack+_equPlus._atk,
				//_defense:_voEqu._defense+_equPlus._def,
				//_speed:_voEqu._speed+_equPlus._speed,
				//_int:_voEqu._int+_equPlus._Int,
				//_mnd:_voEqu._mnd+_equPlus._mnd,
				//_HP:_voEqu._HP + _equPlus._hp
				
				//_style:_dic[_index]._style
				 }
			   
			}else {
				_obj = "";
			}  
			 _returnAry.push(_obj);  
		   }
			return _returnAry;
			
		}
		
		
		private function getSingleEquVauleHandler(_vo:PlayerEquipment):Object 
		{
			
			//for each (var i:String in _dic) {
			   var _object:Object={};
				//var _len:int = 0;
				//for (var j:int = 0; j < _len;j++ ) {
					//if (_ary[j]._guid==_guid) {
					//_PlayerEquipment = _dic[i][j];	
					//break;
					var _flag:int =_vo._detentionNowVaule;
					_object._atk = (_flag>0)?_vo._attack +_vo._soulAtk:_vo._attack;
					_object._def = (_flag>0)?_vo._defense +_vo._soulDef:_vo._defense;
					_object._speed = (_flag>0)?_vo._speed + _vo._soulSpeed:_vo._speed;
					_object._Int = (_flag>0)?_vo._int +_vo._soulInt:_vo._int;
					_object._mnd = (_flag>0)?_vo._mnd +_vo._soulMnd:_vo._mnd;
					_object._hp = (_flag > 0)?_vo._soulHP:0;
					//break;
					
					//}
				//}	
			//}
			return _object;
			
		}
		
		
		private function getSingleEquVOHandler(_guid:String,_dic:Dictionary):PlayerEquipment 
		{
			var _PlayerEquipment:PlayerEquipment;
			for (var i:String in _dic) {
				trace("_equGIIIIIIIIII_"+i);
				var _len:int = _dic[i].length;
				for (var j:int = 0; j < _len;j++ ) {
					if (_dic[i][j]._guid==_guid) {
					//_PlayerEquipment = _dic[i][j];	
					//_PlayerEquipment = {_vo:_dic[i][j],_groupGuid:i};
					_PlayerEquipment = _dic[i][j];
					break;
					}
				}	
			}
			
			return _PlayerEquipment;
		}
		
		
		private  function getEquDicHandler(_key:String):int 
		{
			var _strIndex:String = _key.slice(0,3);
			var _equType:int;
			if (_strIndex == "WPN")_equType = 0;
			if (_strIndex == "AMR")_equType = 1;
			if (_strIndex == "ACY")_equType = 2;
			return _equType;
		}
		
		//----取得裝備等級-----
		public function GetEquLV(_group:String,_index:String):int 
		{
			var _dic:Dictionary = this._aryDicGroup[this.getEquDicHandler(_group)];
			var _ary:Array = _dic[_group];
			var _returnIndex:int = -1;
			if (_ary!=null && _ary.length>0) {
				var _len:int = _ary.length;
				for (var i:int = 0; i < _len;i++ ) {
					if (_ary[i]._guid==_index) {
				     	_returnIndex = _ary[i]._lvEquipment;	
						break;
					}	
				}
			}
			
			return _returnIndex;
		}
		
		//---取得裝備的狀態-----
		public function GetEquUseStates(_group:String,_index:String):int 
		{
			var _test:int=this.getEquDicHandler(_group)
			var _dic:Dictionary = this._aryDicGroup[_test];
			var _ary:Array = _dic[_group];
			var _returnUse:int = -1;
			if (_ary!=null && _ary.length>0) {
				var _len:int = _ary.length;
				for (var i:int = 0; i < _len;i++ ) {
					if (_ary[i]._guid==_index) {
				     	_returnUse = _ary[i]._useing;	
						break;
					}	
				}
			
				
			}
			return _returnUse;
		}
		
		
		//----將提取出來的裝被放入此暫存區域當中
		private var _arySoulEqu:Array = [];
		//---------鑲嵌靈魂石(預覽)----
		/*
		public function GetPreViewEqu(_index:String,_type:int,_soulindex:String):Object 
		{
			var _dic:Dictionary = this._aryDicGroup[_type];
			//------取回靈魂的數值
			//var _soulObj:Object=HeroSoulDetaCenter.GetHtroSoul().GetHeroSoul(_soulindex);
			//this._arySoulEqu[0] = _soulObj;
		    var _obj:Object; 	
			
				if (_dic[_index]!=null && _dic[_index]!=undefined && _soulObj!=null) {
					
			        if (_dic[_index]._nowSoulVaule+_soulObj._soulAbility>_dic[_index]._soulMaxVaule) {
						
						_obj = null;
						trace("鑲嵌失敗__"+"超過容那量");
						
						} else {
						
					_obj = {
					_atk:_soulObj._attack,
					_def:_soulObj._defense,
					_speed:_soulObj._speed,
					_Int:_soulObj._Int,
					_mnd:_soulObj._mnd,
					_hp:_soulObj._attack,
				    _nowSoulVaule:_dic[_index]._nowSoulVaule+_soulObj._soulAbility,
					_soulMaxVaule: _dic[_index]._soulMaxVaule
						
					}	
					
				}
				
			}else {
			    _obj = null;
				var _error:String = (_soulObj == null)?"查無靈魂":"無裝備";
				trace("鑲嵌失敗__"+_error);
			}
			
			return _obj;
		}
		*/
		
		
		
		//---取得怪獸身上所有的裝備加成------
		public function GetMonsterAllCalculate(_ary:Array):Object 
		{
			var _len:int = _ary.length;
			var _Object:Object = {_atk:0,_def:0,_speed:0,_Int:0,_mnd:0,_hp:0};
			for (var i:int = 0; i < _len;i++ ) {
				if (_ary[i]!="") {
					var _strIndex:String = _ary[i]._gruopGuid.slice(0,3);
				    var _equType:int;
					if (_strIndex == "WPN")_equType = 0;
					if (_strIndex == "AMR")_equType = 1;
					if (_strIndex == "ACY")_equType = 2;
					var _obj:Object = this.GetSingleEquVaule(_ary[i]._gruopGuid,_ary[i]._guid,_equType);
					_Object._atk += _obj._atk;
					_Object._def+=_obj._def;
					_Object._speed+=_obj._speed;
					_Object._Int+=_obj._Int;
					_Object._mnd+=_obj._mnd;
					_Object._hp+=_obj._hp;
					
				}
				
				
			}
			return _Object;
			
		}
		
		//----撿查替換的裝備預覽情況//////2013/01/21
	    //--//---取得裝備預覽-----怪+A裝(目前身上的)+-(|A-B|)--0520
		public function GetChangeEquStatus(_index:int,_equAry:Array,_newEauGroup:String,_newEquID:String):Object 
		{
			
			//var _equType:int=this.getEquDicHandler(_newEauGroup);
			var _equType:int = _index;
			//var _returnVaule:Array;
			var _returnVaule:Object;
			//if (_equAry[_equType]!="") {
				var _dic:Dictionary = this._aryDicGroup[_equType];
				var _oldVO:PlayerEquipment = (_equAry[_equType]!="")?this.getSinglePlayerEquipmentHandler(_dic, _equAry[_equType]._gruopGuid, _equAry[_equType]._guid):null;
				var _newVO:PlayerEquipment=this.getSinglePlayerEquipmentHandler(_dic,_newEauGroup,_newEquID);
			    var _oldVaule:Object =(_oldVO!=null)? this.getSingleEquVauleHandler(_oldVO):null;
			    var _newVaule:Object = this.getSingleEquVauleHandler(_newVO);
				/*
				var _atk:int = (_oldVaule==null)?_newVaule._atk:_newVaule._atk - _oldVaule._atk;
				var _def:int = (_oldVaule == null)? _newVaule._def:_newVaule._def - _oldVaule._def;
				var _speed:int =(_oldVaule == null)?_newVaule._speed:_newVaule._speed - _oldVaule._speed;
				var _Int:int = (_oldVaule == null)?_newVaule._int:_newVaule._int - _oldVaule._int ;
				var _mnd:int = (_oldVaule == null)?_newVaule._mnd:_newVaule._mnd - _oldVaule._mnd;
				var _hp:int = (_oldVaule == null)?_newVaule._hp:_newVaule._hp - _oldVaule._hp;
				*/
				//_returnVaule = [_atk,_def,_speed,_Int,_mnd,_hp];
				_returnVaule = {
				    _attack : (_oldVaule==null)?_newVaule._atk:_newVaule._atk - _oldVaule._atk,
					_defense:(_oldVaule == null)? _newVaule._def:_newVaule._def - _oldVaule._def,
				    _speed:(_oldVaule == null)?_newVaule._speed:_newVaule._speed - _oldVaule._speed,
				    _int:(_oldVaule == null)?_newVaule._Int:_newVaule._Int - _oldVaule._Int,
				    _mnd:(_oldVaule == null)?_newVaule._mnd:_newVaule._mnd - _oldVaule._mnd,
				    _HP:(_oldVaule == null)?_newVaule._hp:_newVaule._hp - _oldVaule._hp
					
				};
					
				//}
				
			//}
			
			return _returnVaule;
			
		}
		
	
		
		
		
		
		private function getSinglePlayerEquipmentHandler(_dic:Dictionary,_group:String,_guid:String):PlayerEquipment 
		{
			
			var _obj:PlayerEquipment;
			if (_dic[_group]!=null && _dic[_group]!=undefined) {
				var _len:int = _dic[_group].length;
				for (var i:int = 0; i < _len;i++ ) {
					if (_dic[_group][i]._guid==_guid) {
					    /*
						_obj = {
						  _attack:_dic[_group][i]._attack,	
						  _defense:_dic[_group][i]._defense,
						  _speed:_dic[_group][i]._speed,
						  _int:_dic[_group][i]._int,
						  _mnd:_dic[_group][i]._mnd,
						  _HP:_dic[_group][i]._HP
						}*/
						_obj = _dic[_group][i];
						break;
					}
					
				}	
				
			}
			
			
			return _obj;
			
			
		}
		
		
		
		
		
		//----取的裝被的屬性加成---------
		private function GetSingleEquVaule(_gruopGuid:String,_index:String,_type:int):Object
		{
			var _object:Object={};
			var _dic:Dictionary = this._aryDicGroup[_type];
			if (_dic[_gruopGuid]!=null && _dic[_gruopGuid]!=undefined) {
				var _len:int = _dic[_gruopGuid].length;
				var _check:Boolean = false;
				for (var i:int = 0; i < _len;i++ ) {
				  	
				  if (_dic[_gruopGuid][i]._guid==_index) {
					var _flag:int =_dic[_gruopGuid][i]._detentionNowVaule;
					_object._atk = (_flag>0)?_dic[_gruopGuid][i]._attack + _dic[_gruopGuid][i]._soulAtk:_dic[_gruopGuid][i]._attack;
					_object._def = (_flag>0)?_dic[_gruopGuid][i]._defense + _dic[_gruopGuid][i]._soulDef: _dic[_gruopGuid][i]._defense;
					_object._speed = (_flag>0)?_dic[_gruopGuid][i]._speed + _dic[_gruopGuid][i]._soulSpeed: _dic[_gruopGuid][i]._speed;
					_object._Int = (_flag>0)?_dic[_gruopGuid][i]._int +_dic[_gruopGuid][i]._soulInt:_dic[_gruopGuid][i]._int;
					_object._mnd = (_flag>0)?_dic[_gruopGuid][i]._mnd +_dic[_gruopGuid][i]._soulMnd:_dic[_gruopGuid][i]._mnd;
					_object._hp = (_flag > 0)?_dic[_gruopGuid][i]._soulHP:0;
					//_object._key = _index;
					_check = true;
					break;
					
				  }
					
				}
				//---查無裝備的狀態
				if(_check==false) _object = null;
				
			  }else {
				
			  //---error----	
			  _object = null;
			 
			}
			
			return _object;
			
		}
		
		
		//---改變禁錮力(增加/衰減)-----
		public function SetDetention(_group:String,_index:String,_type:int,_vaule:int):void 
		{
			
			var _dic:Dictionary = this._aryDicGroup[_type];
			if (_dic[_group]!=null && _dic[_group]!=undefined) {
			 	var _len:int = _dic[_group].length;
				for (var i:int = 0; i < _len;i++ ) {
					if (_dic[_group][i]._guid==_index) {
						
						if (_dic[_group][i]._detentionNowVaule>=1) {
						    
							if (_vaule==-99) {
								//---使用金鑽,立即回復
								_dic[_group][i]._detentionNowVaule = _dic[_group][i]._detentionMaxVaule;
								
								} else {
								_dic[_group][i]._detentionNowVaule += _vaule;
							}
							
						  
						} else {
						 //-----禁錮力=0不能再扣了---
						 //---8/30送出通知>>有裝備的怪獸數值將會改變-----
						
					    }
						
						if ( _dic[_group][i]._detentionNowVaule<=0) {
							//----禁錮力被扣乾
							_dic[_group][i]._detentionNowVaule = 0;
						}
						
						if (_dic[_group][i]._detentionNowVaule>=_dic[_group][i]._detentionMaxVaule) {
						  //----禁錮力滿點	
						  _dic[_group][i]._detentionNowVaule = _dic[_group][i]._detentionMaxVaule;
						}
						
						break;
					}
					
					
				}
				
			   	
			  }else {
			//----SendError---	
				
			}
			
		}
		
		//----添加靈魂--_group:裝背群組ID,_index:裝背個別GUID,_type:群組識別,_soulKey靈魂GUID
		/*
		public function AddSoul(_group:String,_index:String,_type:int,_soulKey:String):void 
		{
			var _dic:Dictionary = this._aryDicGroup[_type];
			if (_dic[_group]!=null && _dic[_group]!=undefined) {
				//---ps-_soul可能為一個物件裡面記錄了相關的添加值
				var _len:int = _dic[_group].length;
				for (var i:int = 0; i < _len;i++ ) {
					if (_dic[_group][i]._guid==_index) {
					//var _soulObj:Object=取英靈是的靈魂
					if (_soulObj!=null) {
					 if (_dic[_group][i]._detentionMaxVaule<(_dic[_group][i]._nowSoulVaule+_soulObj._soulAbility)) {
					  //--不符合會暴掉(滿了)
					  trace("error_超過上限");
					  
					  } else {
						_dic[_group][i]._SoulAtk += _soul._attack;
						_dic[_group][i]._SoulDef += _soul._defense;
						_dic[_group][i]._SoulSpeed += _soul._speed;
						_dic[_group][i]._SoulInt += _soul._Int;
						_dic[_group][i]._SoulMnd += _soul._mnd;
						_dic[_group][i]._SoulHP += _soul._HP;
						_dic[_group][i]._nowSoulVaule += _soul._soulAbility;
						
						//-------8/30需要在把英靈室裡面的靈魂石刪除	
						//HeroSoulDetaCenter.GetHtroSoul().RemoveSoul(_soul._key);
					    }	
						
						}else {
						trace("error_靈魂索引錯誤_查無該靈魂");
					}	
					
					}else {
					trace("error_查無該品項武器");	
						
					}
						
					
				}
				
				
				
				} else {
				trace("裝備群組索引錯誤");
				//-----error------
			}
		
		}
		*/
		
		
		
		//-------商成道具使用--回復禁錮力
		public function UseStore(_group:String,_type:int,_guid:String,_vaule:int):void 
		{
			//var _dic:Dictionary = this._aryDicGroup[_type];
			this.SetDetention(_group,_guid,_type,_vaule);
			//var _addVaule:int = (_vaule==0)?:;
		}
		
	
		
		
		
	}
	
}