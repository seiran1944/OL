package MVCprojectOL.ModelOL.Monster 
{
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Equipment.EquipmentDataCenter;
	import MVCprojectOL.ModelOL.TipsCenter.Basic.MonsterEatStone;
	//import MVCprojectOL.ModelOL.ShowSideSys.MonsterEatStone;
	import MVCprojectOL.ModelOL.Stone.StoneDataCenter;
	import strLib.proxyStr.ProxyMonsterStr;
	//import MVCprojectOL.ModelOL.EquVauleObject;
	import MVCprojectOL.ModelOL.Vo.PlayerMonster;
	import UtilsGame.CoustomSort;
	
	/**
	 * ...
	 * @author EricHuang
	 * //----2003/01/28----取得怪獸的數值與檢查相對應的
	 */
	public class PlayerMonsterDataCenter 
	{
		
		//--紀錄怪獸相關數值的操控-----
		//private var _dicMonsterVaule:Dictionary;
		private var _dicVoMonster:Dictionary;
		//---紀錄有改變的怪獸VO-------
		//private var _aryChange:Array;
		private var _sendFunction:Function;
		private var _monsterBuildGuid:String = "";
		private var _monsterBuildType:int = 0;
		//---系統啟動檢查----
		private static var _systemFlag:Boolean = false;
		//---紀錄怪獸的基本屬性的改變----
		private static var _monsterData:PlayerMonsterDataCenter;
		//-------8/28需要思考資料回送的問題,非即時性的資料可紀錄改變的ID,一口氣把改變資料的VO灌回要寫回的資料中
		//-------8/28需要再補寫HP/疲勞值的寫回連線機制
		//-------8/28遊戲心跳需要寫入[添加偵測怪物一使用的計算回復,當回復到達顛峰時,計時器需要移除]
		//-------8/28需要思考回送給獸欄的資料是否要給原本紀錄完整的VO
		
		//--怪獸的數量----
		private var _monsterNowNumber:int = 0;
		
		public function PlayerMonsterDataCenter() 
		{
			if (PlayerMonsterDataCenter._monsterData != null) throw Error("[PlayerMonsterDataCenter] build illegal!!!please,use [Singleton]");
			//this._dicVoMonster = new Dictionary(true);
			//this._dicMonsterVaule = new Dictionary(true);
			//this._aryChange = [];
			//this._sendFunction = _fun;
			
		}
		
		public function SetBuildGuid(_str:String,_type:int):void 
		{
			this._monsterBuildGuid = _str;
			this._monsterBuildType = _type;
		}
		
		
		public function get monsterBuildGuid():String 
		{
			return _monsterBuildGuid;
		}
		
		public function get monsterBuildType():int 
		{
			return _monsterBuildType;
		}
		
		//---怪獸的數量
		
		public function get monsterNowNumber():int 
		{
			return _monsterNowNumber;
		}
		
		public function set monsterNowNumber(value:int):void 
		{
			_monsterNowNumber = value;
		}
		
		public function SetMonsterDictionary(_dic:Dictionary):void 
		{
			this._dicVoMonster = _dic;
		}
		
		//---0503testcheck---
		public function GetDicMonster():Dictionary 
		{
			return this._dicVoMonster ;
		}
		
		public static function GetMonsterData():PlayerMonsterDataCenter 
		{
			if (PlayerMonsterDataCenter._monsterData == null) {
				//if (_fun != null &&PlayerMonsterDataCenter._systemFlag==false) {
					PlayerMonsterDataCenter._monsterData = new PlayerMonsterDataCenter();
				//}
			}
	
			return PlayerMonsterDataCenter._monsterData;
		}
		
		
		
		//---check monster 儲存狀態----
		public function CheckMonster(_index:String):int 
		{
			var _flag:int = (this._dicVoMonster[_index] != null && this._dicVoMonster[_index] != undefined && this._dicVoMonster[_index]._useing==1)?1: -1;
		    return _flag;
		}
		
		
		//---check monster useingtype(取得怪獸的使用狀態)
		public function CheckUseInfo(_guid:String):int 
		{
			var _flag:int=-1;
			if (this._dicVoMonster[_guid]!=null && this._dicVoMonster[_guid]!=undefined) {
				
				_flag = (this._dicVoMonster[_guid]._useing!=1)?-2:1;
				
			}
			
			return _flag;
		}
		
		//----取得怪獸溶解等級----
		public function GetMonsterDisLV(_index:String):int 
		{
			var _lv:int = -1;
			if (this._dicVoMonster[_index]!=null && this._dicVoMonster[_index]!=undefined) {
				
				_lv = this._dicVoMonster[_index]._dissolvedValue;
			}
			return _lv;
		}
		
		//---取得單一怪獸的名稱--
		
		public function GetMonsterName(_index:String):String
		{
			var _name:String = "undefind";
			if (this._dicVoMonster[_index]!=null && this._dicVoMonster[_index]!=undefined) {
				
				_name = this._dicVoMonster[_index]._showName;
			}
			return _name;
		}
		
		
		
		//----取得怪獸的溶解時間
		public function GetDissolvedTimes(_index:String):int 
		{
			var _times:int = -1;
			if (this._dicVoMonster[_index]!=null && this._dicVoMonster[_index]!=undefined) {
				
			   _times = this._dicVoMonster[_index]._dissolvedTimes;
				
			}
			return _times;
		}
		
		
		
		//-----回傳怪物圖片(小圖)
		public function getSinglePicItem(_key:String):String 
		{
			var _str:String = "";
			if (this._dicVoMonster[_key]!=null && this._dicVoMonster[_key]!=undefined) {
				//--測是避免空值的情況
				_str = (this._dicVoMonster[_key]._picItem=="")?"MOB00104_ICO":this._dicVoMonster[_key]._picItem;
			}
			return _str;
		}
		
		//----取回熔解需要的數值------
		public function GetTipsTimeLinne(_key:String,_type:int=3):Object 
		{
		    var _obj:Object = (_type==3)?this.GetMonsterStone(_key):{};
			//var _stone:Object = this.GetMonsterStone(_key);
		    _obj._picItem = this.getSinglePicItem(_key);
			return _obj;
		}
		
		
		//----取得怪獸的熔解結果預覽數值
		public function GetMonsterStone(_key:String):Object 
		{
			var _obj:Object;
			if (this._dicVoMonster[_key]!=null && this._dicVoMonster[_key]!=undefined) {
				
				_obj = {_attack:this._dicVoMonster[_key]._stoneAtk,_defense:this._dicVoMonster[_key]._stoneDef,_speed:this._dicVoMonster[_key]._stoneSpeed,_int:this._dicVoMonster[_key]._stoneInt,_mnd:this._dicVoMonster[_key]._stoneMnd,_HP:this._dicVoMonster[_key]._stoneHP };
			}
			return _obj;
		}
		
		
		//-------獸欄使用------9/21
		//----載入需要的排序指令------*----
		public function GetMonsterList(_str:String,_vaule:int=1):Array 
		{
		   //return this._dicVoMonster;	
		   //---看資料操作需要什麼東西------
		   
		   //---改變排序情況(預設1>小>大,-1--大>小)
		   CoustomSort.ChangeSortVaule(_vaule);
		   var _ary:Array = [];
		  
		   for (var i:String in this._dicVoMonster) {
			   if (i!="group") {
				//-----取裝備>>>
			   var _aryEqu:Array = EquipmentDataCenter.GetEquipment().GetMonsterEqu(this._dicVoMonster[i]._aryEquipment);
			   //var _arySkill:Array = SkillWarehouse.GetInstance().GetMonsterSkill(i._arySkill);
			   //var _objSkill:Object = this.SkillCalculateHansler(_arySkill);
			   var _objEqu:Object = EquipmentDataCenter.GetEquipment().GetMonsterAllCalculate(this._dicVoMonster[i]._aryEquipment);
			   //----技能要再補
			   var _obj:Object = {
				  _size:this._dicVoMonster[i]._scaleRate,
				  _rank:this._dicVoMonster[i]._rank,
				  _sortIndex:int(this._dicVoMonster[i]._guid.substr(3,this._dicVoMonster[i]._guid.length)),
				  _group:this._dicVoMonster[i]._gruopGuid,
				  _guid:this._dicVoMonster[i]._guid,
				  _maxHP:this._dicVoMonster[i]._maxhpValue+_objEqu._hp,
				  _nowHp:this._dicVoMonster[i]._nowhpValue,
				  _nowExp:this._dicVoMonster[i]._nowExp,
				  _maxExp:this._dicVoMonster[i]._upNextExp,
				  _nowEng:this._dicVoMonster[i]._nowfatigueValue,
				  _maxEng:this._dicVoMonster[i]._maxfatigueValue,
				  _lv:this._dicVoMonster[i]._nowlvValue,
				  _showName:this._dicVoMonster[i]._showName,
				  _motionItem:this._dicVoMonster[i]._motionItem,
				  _teamGroup:this._dicVoMonster[i]._teamGroup,
				  //---怪獸狀態
				  //----使用狀態-0:刪除, 1:閒置, 2:溶解 3出戰 4掛賣----
				  _useing:this._dicVoMonster[i]._useing,
				  
				  //---職業名稱
				  _jobName:this._dicVoMonster[i]._jobName,
				  //---職業圖片
				  _jobPic:this._dicVoMonster[i]._jobPic,
				  
				  _atk:this._dicVoMonster[i]._attack+_objEqu._atk,
				  _def:this._dicVoMonster[i]._defense+_objEqu._def,
				  _speed:this._dicVoMonster[i]._speed+_objEqu._speed,
				  _Int:this._dicVoMonster[i]._int+_objEqu._Int,
				  _mnd:this._dicVoMonster[i]._mnd + _objEqu._mnd,
				  _eatStoneRange:this._dicVoMonster[i]._eatStoneRange,
				  
				  //----溶解階級
				  _dissoLv:this._dicVoMonster[i]._dissolvedValue,
				  _dissoTimes:this._dicVoMonster[i]._dissolvedTimes,
				  _dissoSoul:this._dicVoMonster[i]._dissolvedSoul,
				  //----裝備各別顯示
				  _Equ:_aryEqu,
				  //---技能各別顯示
				  _Skill:this._dicVoMonster[i]._arySkill,
				  _learnSkill:this._dicVoMonster[i]._learnSkill.split("")
				}
			     _ary.push(_obj);    
				   
				   
			   }
			   
			   
			   
		   }
		   
		 
		   if (_str != "") {
			  CoustomSort.sortType =PlaySystemStrLab.Sort_Index;
			   _ary.sort(CoustomSort.SortHandler); 
			  CoustomSort.sortType = _str;
			  _ary.sort(CoustomSort.SortHandler); 
			  
			}
		   return _ary;
		}
		
		
		//-----取得要掛賣的怪獸6/10------
		
		public function GetSellMonste():Array 
		{
		  
		   var _ary:Array = [];
		   for (var i:String in this._dicVoMonster) {
			   if (i!="group" && this._dicVoMonster[i]._useing==1 && this._dicVoMonster[i]._teamGroup=="") {
				//-----取裝備>>>
			   var _aryEqu:Array = EquipmentDataCenter.GetEquipment().GetMonsterEqu(this._dicVoMonster[i]._aryEquipment);
			   //var _arySkill:Array = SkillWarehouse.GetInstance().GetMonsterSkill(i._arySkill);
			   //var _objSkill:Object = this.SkillCalculateHansler(_arySkill);
			   //var _objEqu:Object = EquipmentDataCenter.GetEquipment().GetMonsterAllCalculate(this._dicVoMonster[i]._aryEquipment);
			   //----技能要再補
			   var _obj:Object = {
				  //_size:this._dicVoMonster[i]._scaleRate,
				  _rank:this._dicVoMonster[i]._rank,
				  //_sortIndex:int(this._dicVoMonster[i]._guid.substr(3,this._dicVoMonster[i]._guid.length)),
				  //_group:this._dicVoMonster[i]._gruopGuid,
				  _picItem:this._dicVoMonster[i]._picItem,
				  _guid:this._dicVoMonster[i]._guid,
				  //_maxHP:this._dicVoMonster[i]._maxhpValue,
				  //_nowHp:this._dicVoMonster[i]._nowhpValue,
				  //_nowExp:this._dicVoMonster[i]._nowExp,
				  //_maxExp:this._dicVoMonster[i]._upNextExp,
				  //_nowEng:this._dicVoMonster[i]._nowfatigueValue,
				  //_maxEng:this._dicVoMonster[i]._maxfatigueValue,
				  //_lv:this._dicVoMonster[i]._nowlvValue,
				  //_showName:this._dicVoMonster[i]._showName,
				  //_motionItem:this._dicVoMonster[i]._motionItem,
				  //_teamGroup:this._dicVoMonster[i]._teamGroup,
				  //---怪獸狀態
				  //----使用狀態-0:刪除, 1:閒置, 2:溶解 3出戰 4掛賣----
				  //_useing:this._dicVoMonster[i]._useing,
				  
				  //---職業名稱
				  //_jobName:this._dicVoMonster[i]._jobName,
				  //---職業圖片
				  //_jobPic:this._dicVoMonster[i]._jobPic,
				  
				 // _atk:this._dicVoMonster[i]._attack,
				 // _def:this._dicVoMonster[i]._defense,
				 // _speed:this._dicVoMonster[i]._speed,
				 // _Int:this._dicVoMonster[i]._int,
				  //_mnd:this._dicVoMonster[i]._mnd,
				  //_eatStoneRange:this._dicVoMonster[i]._eatStoneRange,
				  
				  //----溶解階級
				  //_dissoLv:this._dicVoMonster[i]._dissolvedValue,
				  //_dissoTimes:this._dicVoMonster[i]._dissolvedTimes,
				  //_dissoSoul:this._dicVoMonster[i]._dissolvedSoul,
				  //----裝備各別顯示
				  _Equ:_aryEqu,
				  //---技能各別顯示
				  _Skill:this._dicVoMonster[i]._arySkill,
				  _learnSkill:this._dicVoMonster[i]._learnSkill.split("")
				}
			     _ary.push(_obj);    
				   
				   
			   }
			   
			   
			   
		   }
		   
		 
		  
		   return _ary;
		}
		
		
		
		
		
		public function GetSingleMonster(_monsterID:String):Object 
		{
			
			var _returnObj:Object;
			if (this._dicVoMonster[_monsterID]!=null && this._dicVoMonster[_monsterID]!=undefined) {
				var _aryEqu:Array = EquipmentDataCenter.GetEquipment().GetMonsterEqu(this._dicVoMonster[_monsterID]._aryEquipment);
			    var _objEqu:Object = EquipmentDataCenter.GetEquipment().GetMonsterAllCalculate(this._dicVoMonster[_monsterID]._aryEquipment);
				//----技能要再補
			   var _returnObj:Object = {
				  _guid:this._dicVoMonster[_monsterID]._guid,
				   _size:this._dicVoMonster[_monsterID]._scaleRate,
				  //_maxHP:i._maxhpValue+_objSkill._hp+_objEqu._hp,
				  _maxHP:this._dicVoMonster[_monsterID]._maxhpValue+_objEqu._hp,
				  _nowHp:this._dicVoMonster[_monsterID]._nowhpValue,
				  _nowExp:this._dicVoMonster[_monsterID]._nowExp,
				  _maxExp:this._dicVoMonster[_monsterID]._upNextExp,
				  _nowEng:this._dicVoMonster[_monsterID]._nowfatigueValue,
				  _maxEng:this._dicVoMonster[_monsterID]._maxfatigueValue,
				  _lv:this._dicVoMonster[_monsterID]._nowlvValue,
				  _showName:this._dicVoMonster[_monsterID]._showName,
				  _motionItem:this._dicVoMonster[_monsterID]._motionItem,
				  _teamGroup:this._dicVoMonster[_monsterID]._teamGroup,
				  //---怪獸狀態
				  //----使用狀態-0:刪除, 1:閒置, 2:溶解 3出戰 4掛賣----
				  _useing:this._dicVoMonster[_monsterID]._useing,
				  //---職業名稱
				  _jobName:this._dicVoMonster[_monsterID]._jobName,
				  
				  _atk:this._dicVoMonster[_monsterID]._attack+_objEqu._atk,
				  _def:this._dicVoMonster[_monsterID]._defense+_objEqu._def,
				  _speed:this._dicVoMonster[_monsterID]._speed+_objEqu._speed,
				  _Int:this._dicVoMonster[_monsterID]._int+_objEqu._Int,
				  _mnd:this._dicVoMonster[_monsterID]._mnd + _objEqu._mnd,
				  _eatStoneRange:this._dicVoMonster[_monsterID]._eatStoneRange,
				  
				 /*
				  _atk:i._attack+_objSkill._atk+_objEqu._atk,
				  _def:i._defense+_objSkill._def+_objEqu._def,
				  _speed:i._speed+_objSkill._speed+_objEqu._speed,
				  _Int:i._Int+_objSkill._Int+_objEqu._speed,
				  _mnd:i._mnd + _objSkill._mnd +_objEqu._speed,
				  */
				  //----溶解階級
				  _dissoLv:this._dicVoMonster[_monsterID]._dissolvedValue,
				  _dissoTimes:this._dicVoMonster[_monsterID]._dissolvedTimes,
				  _dissoSoul:this._dicVoMonster[_monsterID]._dissolvedSoul,
				  //----裝備各別顯示
				  _Equ:_aryEqu,
				  //---技能各別顯示
				  _Skill:this._dicVoMonster[_monsterID]._arySkill,
				  _learnSkill:this._dicVoMonster[_monsterID]._learnSkill.split("")
				}
				
				
				
			}
			
			return _returnObj;
		}
		
		
		
		//---取得怪獸的組隊
		public function GetMonsterTeam(_guid:String):String 
		{
			var _checkMonster:String=(this._dicVoMonster[_guid]!=null && this._dicVoMonster[_guid]!=undefined)?this._dicVoMonster[_guid]._teamGroup:"";	
			return _checkMonster;
		}
		
		
		
		
		//---取回所有技能加成的數值(找尋永久加成的)
		private function SkillCalculateHansler(_arySkill:Array):Object 
		{
			
			var _len:int = _arySkill.length;
			var _Object:Object = {_atk:0,_def:0,_speed:0,_Int:0,_mnd:0,_hp:0 };
			for (var i:int = 0; i < _len;i++ ) {
				_Object._atk += (_arySkill[i]._probability!=100)?0:_arySkill[i]._attack;
				_Object._def+=(_arySkill[i]._probability!=100)?0:_arySkill[i]._defense;
				_Object._speed+=(_arySkill[i]._probability!=100)?0:_arySkill[i]._speed;
				_Object._Int+=(_arySkill[i]._probability!=100)?0:_arySkill[i]._Int;
				_Object._mnd+=(_arySkill[i]._probability!=100)?0:_arySkill[i]._mnd;
				_Object._hp += (_arySkill[i]._probability != 100)?0:_arySkill[i]._HP;
			}
			return _Object;
			
		}
		
	    
	   
		
		
		//----檢查怪獸是否可以吞石頭(true=可以/false=不可以)
		//----吃石頭就等於鑲孔...每個等級一個洞,10個等級10個洞,吃一顆就代表填滿一個洞(要增加洞數>>怪物升級)
		
		public function CheckStoneRange(_monsterID:String):Boolean 
		{
			var _return:Boolean = false;
			if (this._dicVoMonster[_monsterID]!=null && this._dicVoMonster[_monsterID]!=undefined) {
			  _return = ((this._dicVoMonster[_monsterID]._nowlvValue-this._dicVoMonster[_monsterID]._eatStoneRange) >= 1)?true:false;	
				
			}
			return _return;
		}
	
		
		public function GetPreMonstereatStone(_obj:Object):MonsterEatStone 
		{
			var _stonePre:MonsterEatStone;
			if (this._dicVoMonster[_obj._guid]!=null && this._dicVoMonster[_obj._guid]!=undefined) {
				
				_stonePre = new MonsterEatStone();
				_stonePre._eatStoneRange = this._dicVoMonster[_obj._guid]._eatStoneRange;
				_stonePre._nowlvValue = this._dicVoMonster[_obj._guid]._nowlvValue;
				_stonePre._showName = _obj._title;
				
			}
			
			return _stonePre;
		}
		
		
		//-------吃石頭的預覽------
		public function GetPreEatStone(_monsterID:String,_stoneID:String):Object 
		{
			var _returnObj:Object ;
			var _Monster:Object;
			var _objStone:Object;
			//----預設>怪獸資料錯誤
			var _Type:int = -1;
			if (this._dicVoMonster[_monsterID]!=null && this._dicVoMonster[_monsterID]!=undefined) {
				var _stone:Object = StoneDataCenter.GetStoneDataControl().GetStone(_stoneID);
				var _type:int = StoneDataCenter.GetStoneDataControl().CheckStoneStatus(_stoneID);
				if (_stone!=null && _type==1) {
				//---檢查是否可以吃----- 		
				if ((this._dicVoMonster[_monsterID]._nowlvValue-this._dicVoMonster[_monsterID]._eatStoneRange) >= 1) {
					//---可以吃的狀態
					 _Type = 99;	
				    //---石頭跟怪獸的5屬性回送-----  
				    //--GetMonsterVauleHandler(單獨拿怪獸五屬性)
					_Monster= GetMonsterVauleHandler(_monsterID);
					//_aryStone = [_stone._hp,_stone._atk,_stone._def,_stone._Int,_stone._speed,_stone._mnd];
					_objStone = {
						_attack:_stone._atk,	
						_defense:_stone._def,	
						_speed:_stone._speed,	
						_int:_stone._Int,
						_mnd:_stone._mnd,
						_HP:_stone._hp
						
					}
					
				   }else {
				   //---使用超過上限
			      _Type = -3;	
				}
				
				}else {
				//----石頭資料錯誤 
				 
				//---[-2]>石頭資料錯誤/[-4]>石頭狀態不允許
				_Type=(_stone!=null)?-4:-2;	
					
				}
				
			}
			
			_returnObj = {_type:_Type,_vaulePre:_objStone,_monster:_Monster };
			return _returnObj;
		}
		
		
		
		//---檢查怪獸的疲勞值---
		public function CheckSingleFatigueValue(_monsterID:String):Boolean 
		{
			//var _flag:Boolean = true;
			var _flag:Boolean = false;
			if (this._dicVoMonster[_monsterID]!=null && this._dicVoMonster[_monsterID]!=undefined) {
			  	_flag = (this._dicVoMonster[_monsterID]._nowfatigueValue<this._dicVoMonster[_monsterID]._maxfatigueValue)?true:false;
				//-----12/20---測試關閉(無疲勞值)
			}
			return _flag;
		}
		
		
		//-------檢查進化條件
		public function CheckEvolution(_groupGuid:String,_number:int):Boolean 
		{
			var _flag:Boolean=false
			if (this._dicVoMonster["group"][_groupGuid]!=null) {
				var _len:int = 0;
				for (var i:String in this._dicVoMonster["group"][_groupGuid]) {
					_len++;
					if (_len>=_number) {
						_flag = true;
						break;
					}
					
				}
				
			}
			
			return _flag;
			
		}
		
		
		//---檢查階級/怪獸是否存在-----
		/*
		private function getSingleEvolutionCheckHandler(_guid:String,_lvMax:int):int 
		{
			var _flag:int = 0;
			if (this._dicVoMonster[_guid]!=null && this._dicVoMonster[_guid]!=undefined) {
				
				if (this._dicVoMonster[_guid]._nowlvValue>=_lvMax) {
					_flag = 1;
						
					} else {
					//---目標接級不符合---
					_flag = -2;
				}
				
				} else {
				//---怪獸不存在
				_flag=-1
			}
			return _flag;
			
		}*/
	    
		
		//---
		public function CheckMonsterEvolution(_guid:String,_lvMax:int,_mobId:String):int 
		{
			
			var _return:int = 0;
			if (this._dicVoMonster[_guid]!=null && this._dicVoMonster[_guid]!=undefined) {
				 
				if (this._dicVoMonster[_guid]._gruopGuid==_mobId) {
				   
					_return = (this._dicVoMonster[_guid]._nowlvValue>=_lvMax)?1:-5;
					
					} else {
					
					//----原型ID不符合配方表的規定
					_return = -4;
					
				}
				
				
				} else {
				//---怪獸不存在
				_return = -1;
				
				
				
			}
		
			return _return;
			
		}
		
		//---getSingleMonster_groupID----
		public function GetMonsterGroupID(_guid:String):String 
		{
			var _mobid:String = "";
			if (this._dicVoMonster[_guid]!=null && this._dicVoMonster[_guid]!=undefined) {
				_mobid = this._dicVoMonster[_guid]._gruopGuid;	
		    }
			
			return _mobid;
		}
		
		
		//----檢查是否還具備相同的原型_mobid----
		public function CheckMobIdAry(_mobid:String):Boolean 
		{
			var _flag:Boolean =(this._dicVoMonster["group"][_mobid]!=null && this._dicVoMonster["group"][_mobid]!=undefined)?true:false;
			
			return _flag
		}
		
		
		//---2013/05/27---撿查是否可以刷進化技能---
		
		public function CheckResetSkill(_guid:String):int 
		{
			var _return:int = -1;
			if (this._dicVoMonster[_guid]!=null && this._dicVoMonster[_guid]!=undefined) {
				if (this._dicVoMonster[_guid]._useing!=1) {
					_return = -3;
					
				}else if (this._dicVoMonster[_guid]._arySkill[1]==""){
				 	_return = -2;
					
				}else {
					_return = 1;
				}
				
				
			}
			
			return _return;
		}
		
		
		
		public function GetEvoTopMonster(_guid:String):Object 
		{
			
			var _return:Object;
			if (this._dicVoMonster[_guid]!=null && this._dicVoMonster[_guid]!=undefined) {	
				//if (this._dicVoMonster[_guid]._gruopGuid==_group) {
					//var _flag:Boolean = (this._dicVoMonster[_guid]._nowlvValue>=_lvMax)?true:false;
					_return = {
					_flagEvo:true,
					_lv:this._dicVoMonster[_guid]._nowlvValue,
					_rank:this._dicVoMonster[_guid]._rank,
					_attack:this._dicVoMonster[_guid]._attack,	
					_defense:this._dicVoMonster[_guid]._defense,	
					_speed:this._dicVoMonster[_guid]._speed,	
					_int:this._dicVoMonster[_guid]._int,	
					_mnd:this._dicVoMonster[_guid]._mnd,
					_HP:this._dicVoMonster[_guid]._maxhpValue,	
					_picItem:this._dicVoMonster[_guid]._picItem,
					_useing:this._dicVoMonster[_guid]._useing,
					_guid:this._dicVoMonster[_guid]._guid,
					_gruopGuid:this._dicVoMonster[_guid]._gruopGuid,
					_skill:this._dicVoMonster[_guid]._arySkill[1]
					} 
					
				//}
				
				
			}
			
			return _return;
			
		}
		
		public function GetSingleEvoMonster(_guid:String,_group:String,_lvMax:int):Object 
		{
			var _return:Object;
			if (this._dicVoMonster[_guid]!=null && this._dicVoMonster[_guid]!=undefined) {	
				if (this._dicVoMonster[_guid]._gruopGuid==_group) {
					var _flag:Boolean = (this._dicVoMonster[_guid]._nowlvValue>=_lvMax)?true:false;
					_return = {
					_flagEvo:_flag,
					_lv:this._dicVoMonster[_guid]._nowlvValue,
					_rank:this._dicVoMonster[_guid]._rank,
					_attack:this._dicVoMonster[_guid]._attack,	
					_defense:this._dicVoMonster[_guid]._defense,	
					_speed:this._dicVoMonster[_guid]._speed,	
					_int:this._dicVoMonster[_guid]._int,	
					_mnd:this._dicVoMonster[_guid]._mnd,
					_HP:this._dicVoMonster[_guid]._maxhpValue,	
					_picItem:this._dicVoMonster[_guid]._picItem,
					_useing:this._dicVoMonster[_guid]._useing,
					_guid:this._dicVoMonster[_guid]._guid,
					_gruopGuid:this._dicVoMonster[_guid]._gruopGuid,
					_skill:this._dicVoMonster[_guid]._arySkill[1]
					} 
					
				}
				
				
			}
			
			return _return;
		}
		
		//---------進化用取怪獸的數值與檢查該怪獸是否可以進行合法的進化---
		public function CheckMonsterSingleEvolution(_groupGuid:String,_lvMax:int):Array 
		{
			var _ary:Array = [];
			
			if (this._dicVoMonster["group"][_groupGuid]!=null) {
				
				for (var i:String in this._dicVoMonster["group"][_groupGuid]) {
					
					var _flag:Boolean = (this._dicVoMonster["group"][_groupGuid][i]._nowlvValue>=_lvMax)?true:false;
					var _obj:Object = {
					_flagEvo:_flag,
					_lv:this._dicVoMonster["group"][_groupGuid][i]._nowlvValue,
					_rank:this._dicVoMonster["group"][_groupGuid][i]._rank,
					_attack:this._dicVoMonster["group"][_groupGuid][i]._attack,	
					_defense:this._dicVoMonster["group"][_groupGuid][i]._defense,	
					_speed:this._dicVoMonster["group"][_groupGuid][i]._speed,	
					_int:this._dicVoMonster["group"][_groupGuid][i]._int,	
					_mnd:this._dicVoMonster["group"][_groupGuid][i]._mnd,
					_HP:this._dicVoMonster["group"][_groupGuid][i]._maxhpValue,	
					_picItem:this._dicVoMonster["group"][_groupGuid][i]._picItem,
					_useing:this._dicVoMonster["group"][_groupGuid][i]._useing,
					_guid:this._dicVoMonster["group"][_groupGuid][i]._guid,
					_gruopGuid:this._dicVoMonster["group"][_groupGuid][i]._gruopGuid,
					_skill:this._dicVoMonster["group"][_groupGuid][i]._arySkill[1]
					} 
					_ary.push(_obj);
				}	
				
			}
			
			return _ary;
		}
		
		
		
		
		//----*特殊情況的取得怪獸身上某種值
		public function GetMonsterVauleHandler(_monsterID:String,_type:String=""):Object 
		{
			var _returnObj:Object;
			if (this._dicVoMonster[_monsterID]!=null && this._dicVoMonster[_monsterID]!=undefined) {
				if (_type=="") {
					_returnObj = {
					_attack:this._dicVoMonster[_monsterID]._attack,	
					_defense:this._dicVoMonster[_monsterID]._defense,	
					_speed:this._dicVoMonster[_monsterID]._speed,	
					_int:this._dicVoMonster[_monsterID]._int,	
					_mnd:this._dicVoMonster[_monsterID]._mnd,
					_HP:this._dicVoMonster[_monsterID]._maxhpValue
					}
					
					} else {
					
					if (_type == "_attack")_returnObj = {_attack:this._dicVoMonster[_monsterID]._attack };
					if (_type == "_defense")_returnObj = {_defense:this._dicVoMonster[_monsterID]._defense };
					if (_type == "_speed")_returnObj = {_speed:this._dicVoMonster[_monsterID]._speed };
					if (_type == "_int")_returnObj = {_int:this._dicVoMonster[_monsterID]._int };
					if (_type == "_mnd")_returnObj = {_mnd:this._dicVoMonster[_monsterID]._mnd };
					if (_type == "_HP")_returnObj = {_HP:this._dicVoMonster[_monsterID]._maxhpValue };
					
				}
			  
				
				
			
			}
			
			return _returnObj;
			
		}
		
		//---取得裝備預覽-----怪+A裝(目前身上的)+-(|A-B|)
		//---0520----
		public function GetEquPreView(_monsterID:String,_equGrup:String,_guid:String):Object 
		{
			var _checkMonsterEquStatus:Object = this.checkEquStatesHandler(_equGrup, _guid, _monsterID);
			var _returnStatus:Object;
			//var _equAry:Array;
			var _equPre:Object;
			//---預設值是可以操作的(裝備是可以穿的)
			var _error:int =99;
			if (_checkMonsterEquStatus._Flag>0) {
				//---裝備可以穿的狀態-----
				var _oldStatus:Object = this.getSingleMonsterALLHandler(_monsterID);//-(裝備+怪)
				var _aryOldEqu:Array = this._dicVoMonster[_monsterID]._aryEquipment;
				//_equAry= EquipmentDataCenter.GetEquipment().GetChangeEquStatus(_checkMonsterEquStatus._Index,_aryOldEqu, _equGrup, _guid);
				_equPre= EquipmentDataCenter.GetEquipment().GetChangeEquStatus(_checkMonsterEquStatus._Index,_aryOldEqu, _equGrup, _guid);
				
				} else {
				//---裝備無法穿戴的狀態[-1>查無裝備]/[-2>怪獸等級過高裝備無法使用]/[-3>查無怪獸]
				//--這邊填錯誤戴碼(TIPS用的)"
				//if (_checkMonsterEquStatus._Flag == -1)_error = ;
				//if (_checkMonsterEquStatus._Flag == -2)_error = "這邊填錯誤戴碼(TIPS用的)";
				//if (_checkMonsterEquStatus._Flag == -3)_error = "這邊填錯誤戴碼(TIPS用的)";
				_error=_checkMonsterEquStatus._Flag
			}
			
			_returnStatus = {_type:_error,_vaulePre:_equPre,_monster:_oldStatus};
			
			return _returnStatus;
		}
		
		
		//----取得改變裝備的怪獸數值總加成
		private function getSingleMonsterALLHandler(_monsterGuid:String):Object 
		{
			var _returnMonster:Object;
			if (this._dicVoMonster[_monsterGuid]!=null && this._dicVoMonster[_monsterGuid]!=undefined) {
				var _equAry:Array = this._dicVoMonster[_monsterGuid]._aryEquipment;
				var _objEqu:Object=EquipmentDataCenter.GetEquipment().GetMonsterAllCalculate(_equAry);
				_returnMonster = { 
				_HP:this._dicVoMonster[_monsterGuid]._maxhpValue+_objEqu._hp,	
				_attack:this._dicVoMonster[_monsterGuid]._attack+_objEqu._atk,
				_defense:this._dicVoMonster[_monsterGuid]._defense+_objEqu._def,
				_speed:this._dicVoMonster[_monsterGuid]._speed+_objEqu._speed,
				_int:this._dicVoMonster[_monsterGuid]._int+_objEqu._Int,
				_mnd:this._dicVoMonster[_monsterGuid]._mnd+_objEqu._mnd		
				};
				
			}
			
			return _returnMonster;
			
			
		}
		
		
		
		//---檢查裝備陣列(長度固定為3...)[{},{},{}];
		private function checkEquStatesHandler(_equGroupID:String,_equID:String,_monsterID:String):Object 
		{
				var _returnObject:Object;
				//----撿查狀態-*------
				var _flag:int;
				var _changeIndex:int = -1;
			    var _aryMonsterEqu:Array = (this._dicVoMonster[_monsterID]!=null && this._dicVoMonster[_monsterID]!=undefined)?this._dicVoMonster[_monsterID]._aryEquipment:null;
				
				if (_aryMonsterEqu!=null) {
				    var _index:int = this.getEquDicHandler(_equGroupID);//_ary[i]._gruopGuid.splice(0,3);
					//---裝備的使用等級
					var _equLV:int = EquipmentDataCenter.GetEquipment().GetEquLV(_equGroupID, _equID);
					//---裝備的使用狀態
					var _useStates:int = EquipmentDataCenter.GetEquipment().GetEquUseStates(_equGroupID, _equID);
					
					
					if (_useStates!=1) { 
						
						//--裝備無法使用,請檢查裝備(裝備不存在)(-1)/裝備並非閒置狀態(-2)
						_flag = (_equLV<0 || _useStates==-1)?-1:-2;
						
						} else {
						
						if (this._dicVoMonster[_monsterID]._nowlvValue<_equLV) {
							//-----裝備無法使用,怪獸等級太低
							_flag = -3;	
							} else {
							if (_index>=0) {
								if (_aryMonsterEqu[_index]!="") {
								//------該裝備準備替換---------
						        _flag = 1;
						        _changeIndex = _index;
									} else {
								//----該裝備直接穿-------
						        _flag = 2;
						        _changeIndex = _index;	
									
								}
								
								} else {
								//----裝備資料系統錯誤
								_flag = -4;	
							}
							
							
						}
						
						
					}
				
					
				}else {
					//-----怪獸資料錯誤----
					_flag = -5;
					
				}
				_returnObject = {_Flag:_flag,_Index:_changeIndex};
			return _returnObject;
		}
		
		
		private  function getEquDicHandler(_key:String):int 
		{
			var _strIndex:String = _key.slice(0,3);
			var _equType:int=-1;
			//---武器
			if (_strIndex == "WPN")_equType = 0;
			//---防具
			if (_strIndex == "AMR")_equType = 1;
			//---飾品
			if (_strIndex == "ACY")_equType = 2;
			return _equType;
		}
		
		
		//----取得怪獸的學習群
		public function GetMonsterLearning(_monster:String):int
		{
			var _learn:int =0;
			if (this._dicVoMonster[_monster]!=null && this._dicVoMonster[_monster]!=undefined) {
			    _learn=this._dicVoMonster[_monster]._nowLearning;	
			}
			return _learn
		}
		
		//----取得怪獸的技能列表
		public function GetMonsterSkill(_monsterID:String):Array 
		{
			var _ary:Array;
			if (this._dicVoMonster[_monsterID]!=null && this._dicVoMonster[_monsterID]!=undefined) {
				_ary = this._dicVoMonster[_monsterID]._arySkill.slice(0);
			}else{
			   _ary = null;
		    }
			return _ary;
		}
		
		
		//---統一取得即將替換掉的數值---
		public function TipsCenterHandler(_obj:Object):* 
		{
			//---_guid:String,_target:String,_str:String
			var _returnStr:*;
			if (this._dicVoMonster[_obj._guid] != null || this._dicVoMonster[_obj._guid] !=undefined) {
				
				_returnStr = PlayerMonster(this._dicVoMonster[_obj._guid]);
				
			}else {
				_returnStr = null; 
				
			}
			
			return _returnStr;	
		}
		
		
		
		//---移除之前必須做的對應處理
		public function OnRemoveClass():void 
		{
			
		}
		
		
		
		
	}
	
}