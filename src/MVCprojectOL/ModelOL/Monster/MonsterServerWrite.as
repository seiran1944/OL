package MVCprojectOL.ModelOL.Monster
{
	import adobe.utils.CustomActions;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.Equipment.EquipmentDataCenter;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import MVCprojectOL.ModelOL.Stone.StoneDataCenter;
	import MVCprojectOL.ModelOL.Vo.Get.Get_Mission;
	import MVCprojectOL.ModelOL.Vo.MissionVO.MissionConditionComplete;
	import MVCprojectOL.ModelOL.Vo.PlayerMonster;
	import MVCprojectOL.ModelOL.Vo.PlayerStone;
	import MVCprojectOL.ModelOL.Vo.ReturnMonster;
	import MVCprojectOL.ModelOL.Vo.Set.Set_PlayerMonster;
	import Spark.Timers.TimeDriver;
	import strLib.commandStr.PVECommands;
	import strLib.proxyStr.ProxyMonsterStr;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author EricHuang
	 * 2013/01/28
	 * @example------本class負責資料串的寫入&& 把值寫回server-------
	 * 
	 */
	public class MonsterServerWrite 
	{
	    
		private var _dicMonster:Dictionary;
		//----sendNotify----
		private var _sendFunction:Function;
		
		//----連線回寫----
		private var _voGroupCall:Function;
		
		private const _setMonsterStr:String = "SetMonster_replyDataType";
		//---系統啟動檢查----
		private static var _systemFlag:Boolean = false;
		//---紀錄怪獸的基本屬性的改變----
		private static var _monsterData:MonsterServerWrite;
		
		//--檢查怪獸回復次數與否HP----
	    //private var _checkRecoveryHPflag:Boolean = false;
	    //--檢查怪獸回復次數與否ENG----
		//private var _checkRecoveryENGflag:Boolean = false;
		//--記錄上次更新時間HP---
		//private var _recoverHPTime:uint = 0;
		//---記錄上次更新時間ENG----
	    //private var _recoverENGTime:uint = 0;
		
		
		private var _allMonsterLen:int = 0;
		
		public function MonsterServerWrite(_fun:Function,_voCall:Function) 
		{
		    if (MonsterServerWrite._monsterData != null) throw Error("[MonsterServerWrite] build illegal!!!please,use [Singleton]");
			//MonsterServerWrite._systemFlag = true;
			this._dicMonster = new Dictionary(true);
		    this._sendFunction = _fun;
			this._voGroupCall = _voCall;
		}
		
		
		
		public static function GetMonsterServerWrite(_fun:Function=null,_voClall:Function=null):MonsterServerWrite 
		{
			if (MonsterServerWrite._monsterData == null) {
				if (_fun != null && _voClall!=null &&MonsterServerWrite._systemFlag==false) {
					MonsterServerWrite._monsterData = new MonsterServerWrite(_fun,_voClall);
				}
			}	
			
			return MonsterServerWrite._monsterData;
		}
		
		
		//----取得索引dictionary----
		public function get dicMonster():Dictionary 
		{
			return _dicMonster;
		}
		
		
		
		public function AddVoMonster(_ary:Array):void 
		{
		    var _len:int = _ary.length;
			var _sendStr:String = "";
			var _sendObject:Object;
			//if (_len>=1) {
			    if(this._dicMonster["group"]==null)this._dicMonster["group"]=new Dictionary(true);
			   for (var i:int = 0; i < _len;i++ ) {
			   this._dicMonster[_ary[i]._guid] = _ary[i];
			   if (this._dicMonster["group"][_ary[i]._gruopGuid]!=null && this._dicMonster["group"][_ary[i]._gruopGuid]!=undefined) {
				    this._dicMonster["group"][_ary[i]._gruopGuid][_ary[i]._guid] = _ary[i];
				   } else {
				    this._dicMonster["group"][_ary[i]._gruopGuid] = new Dictionary(true);
					this._dicMonster["group"][_ary[i]._gruopGuid][_ary[i]._guid] = _ary[i];
			   }
			  
		      }
			  
			  if (MonsterServerWrite._systemFlag==false) {
				 MonsterServerWrite._systemFlag = true;
				  _sendStr = ProxyMonsterStr.MosterSystem_Ready;
				  } else {
				  _sendStr = "Add_Monster_Ready";
				  
			   }
			  
			  
			//}else {
				//-----回送錯誤碼(VO物件空值)
				//trace("Error_AddVoMonster---");
				//_sendStr = "Error_AddVoMonster---";
			//}
			if (_len <=0) {
				//-----回送錯誤碼(VO物件空值)
				trace("Error_AddVoMonster---");
				//_sendStr = "Error_AddVoMonster---";
			}
			this._allMonsterLen = this._allMonsterLen + _len;
			PlayerMonsterDataCenter.GetMonsterData().SetMonsterDictionary(this._dicMonster);
			PlayerMonsterDataCenter.GetMonsterData().monsterNowNumber = this._allMonsterLen;
			this._sendFunction(_sendStr,_sendObject);
			
		}
		
		
		
		
		/*
		public function SetDicTionary(_monster:Dictionary):void 
		{
			this._dicMonster = _monster;
		}*/
		
		//----serverBack--------
		public function WriteBack(_Return:ReturnMonster):void 
		{
			//----1.EXP改變2.HP改變3.ENG改變4吃石頭後5.使用掛賣6.技能學回來7.裝備狀態改變8.其他的使用狀態
			switch(_Return._type) {
				
				
				case 1:
					 
					
				break;
				
				//-----HP改變
			    case 2:
				   if (this._dicMonster[_Return._guid]!=null && this._dicMonster[_Return._guid]!=undefined) {
					this._dicMonster[_Return._guid]._nowhpValue = _Return._HP;
				   }
				
				break;
				
				//----ENG改變
			    case 3:
				 if (this._dicMonster[_Return._guid]!=null && this._dicMonster[_Return._guid]!=undefined) {
					this._dicMonster[_Return._guid]._nowfatigueValue = _Return._ENG;
				   }
				
				break;
				//----eatStone---
			    case 4:
				  if(StoneDataCenter.GetStoneDataControl().CheckStone(_Return._stoneId))StoneDataCenter.GetStoneDataControl().RemoveStone(_Return._stoneId);
				  if (this._dicMonster[_Return._guid]!=null && this._dicMonster[_Return._guid]!=undefined) {
					  
					this._dicMonster[_Return._guid]._attack = _Return._attack;
					this._dicMonster[_Return._guid]._defense=_Return._defense;
					this._dicMonster[_Return._guid]._speed=_Return._speed;
					this._dicMonster[_Return._guid]._int=_Return._int;
					this._dicMonster[_Return._guid]._mnd = _Return._mnd;
					this._dicMonster[_Return._guid]._maxhpValue = _Return._hpMax; 
					//this._dicMonster[_Return._guid]._nowhpValue = _Return._HP; 
				   }
				  
				break;
				
				case 5:
				break;
				
			    //------技能學回來
				case 6:
				   this.AddSkill([_Return]);
				
				break;
				
				//----裝備狀態改變(穿裝備回來7)
			    case 7:
				   if (this._dicMonster[_Return._guid]!=null && this._dicMonster[_Return._guid]!=undefined) {
					  this._dicMonster[_Return._guid]._aryEquipment = _Return._aryEqu;
					  var _monsterEqu:Array = this._dicMonster[_Return._guid]._aryEquipment; 
					  //var _removeEqu:Array = _Return._removeEqu;
					   for (var i:int = 0; i < 3;i++ ) {
						  if (_monsterEqu[i]!="") {
							  var _indexEqu:int = this.getEquIndexHandler(_monsterEqu[i]._gruopGuid);
							  EquipmentDataCenter.GetEquipment().ChangeUseing(_monsterEqu[i]._gruopGuid, _monsterEqu[i]._guid,_indexEqu,3);   
						    	
							}
						  
						} 
					  
					}
				
				break;
				//---脫裝備8---
			    case 8:
				  if (this._dicMonster[_Return._guid]!=null && this._dicMonster[_Return._guid]!=undefined) {
					  this._dicMonster[_Return._guid]._aryEquipment = _Return._aryEqu;
					  var _removeEqu:Object = _Return._removeEqu;
					  if (_removeEqu!=null) {
						  var _indexEquRemove:int = this.getEquIndexHandler(_removeEqu._gruopGuid);
						   EquipmentDataCenter.GetEquipment().ChangeUseing(_removeEqu._gruopGuid,_removeEqu._guid,_indexEquRemove,1); 
						  
					   }
					  
					  
					}
				
				break;
				
				//---monster HP/ENG CD 回復
			    case 10:
				  if (this._dicMonster[_Return._guid]!=null && this._dicMonster[_Return._guid]!=undefined) {
					  
					  /*
					  if (this._checkRecoveryHPflag == false || this._checkRecoveryENGflag==false) {  
						 
						  var _nowTimes:uint=ServerTimework.GetInstance().ServerTime;
						  var _checkTimes:uint;
						  var _functionTarget:Function;
						  if (this._checkRecoveryHPflag == false) {
							   this._checkRecoveryHPflag = true;
							   _checkTimes = (PlayerDataCenter.GetMonsterHPTimes()-(this._recoverHPTime-_nowTimes))*1000;
							  _functionTarget = this.RecoveryHPHandler;
							   
							}else if(this._checkRecoveryENGflag==false){
								this._checkRecoveryENGflag = true;
								_checkTimes = (PlayerDataCenter.GetMonsterFatigueTimes()-(this._recoverENGTime-_nowTimes))*1000;
								_functionTarget = this.RecoveryFatigueHandler;
							}
						  
						  TimeDriver.ChangeDrive(_functionTarget,_checkTimes);
						 
					  }
					  */
					  if ( _Return._HP != 0)  this._dicMonster[_Return._guid]._nowhpValue = _Return._HP; 
					  if ( _Return._ENG != -1)this._dicMonster[_Return._guid]._nowfatigueValue = _Return._ENG; 
					  trace("returnBack");
					 } 
				
				
				break;
				
				
				
			   case 11:
				   if (this._dicMonster[_Return._guid]!=null && this._dicMonster["group"][_Return._gruopGuid][_Return._guid]!=null) {
					   this._dicMonster[_Return._guid]._arySkill[1] = _Return._skillId;
					   this._dicMonster["group"][_Return._gruopGuid][_Return._guid]._arySkill[1] = _Return._skillId;
					   //---技能回寫完成..送出請求
					   //this._sendFunction(ProxyPVEStrList.MonsterEvolution_changeSkill);
					   this._sendFunction(ProxyPVEStrList.MonsterEvolution_EvoListReady,{evoObj:null,_type:4,_evoSkill:_Return._skillId}); 
				   }
				   
			   break;	
			}
			//var _objMonster:Object = PlayerMonsterDataCenter.GetMonsterData().GetMonsterList(_Return._guid);
			this._sendFunction(PVECommands.MONSTER_VauleCHANGE);
		}
		
		
		//---暫時把裝備穿上去-------
		public function AddEqu(_equGroupID:String,_equID:String,_monsterID:String):void 
		{
			
			var _index:int = this.getEquIndexHandler(_equGroupID);
			var _aryOld:Array = this._dicMonster[_monsterID]._aryEquipment;
			if (_index!=-1 && _aryOld[_index]!="") {
				//---替換裝備
				var _oldGroup:String = this._dicMonster[_monsterID]._aryEquipment[_index]._gruopGuid;
				var _oldGuid:String=this._dicMonster[_monsterID]._aryEquipment[_index]._guid;
				EquipmentDataCenter.GetEquipment().ChangeUseing(_oldGroup,_oldGuid,_index,1);
				//----2013/2/20---直接刪掉回送server---
				//this._voGroupCall(new Set_PlayerMonster(this._setMonsterStr, { _type:7, _guid:_monsterID, _equID:_oldGuid,_equType:1} ));
				
				}
			//----使用裝備*---
			EquipmentDataCenter.GetEquipment().ChangeUseing(_equGroupID, _equID, _index, 3,_monsterID);
			//_returnStatus = 1;
		    this._dicMonster[_monsterID]._aryEquipment[_index]={_gruopGuid:_equGroupID,_guid:_equID}
            //---call server(連線)----
			//---使用裝備
			this._voGroupCall(ProxyMonsterStr.Monster_voGroup,new Set_PlayerMonster(this._setMonsterStr, { _type:7, _guid:_monsterID, _equID:_equID} ));
		}
		
		
		//---刪除怪獸身上的裝備(單一)
		public function RemoveMonsterEquSingle(_monsterID:String,_equID:String):void 
		{
			//----需要回傳怪獸的改變後數值
			if (this._dicMonster[_monsterID]!=null && this._dicMonster[_monsterID]!=undefined) {
				var _target:Array = this._dicMonster[_monsterID]._aryEquipment;
				for (var i:int = 0; i < 3;i++ ) { 
					//EquVauleObject 
					if (_target[i]!="") {
						
					  if (_target[i]._guid==_equID) {
						EquipmentDataCenter.GetEquipment().ChangeUseing(_target[i]._gruopGuid,_target[i]._guid,i,1);
						_target[i] = "";
			            //---脫裝備
			            this._voGroupCall(ProxyMonsterStr.Monster_voGroup,new Set_PlayerMonster(this._setMonsterStr, { _type:8, _guid:_monsterID, _equID:_equID} ));
						break;
					   }	
					}
					
				}
				
			}
			
		}
		
		//---改變怪獸狀態處理(煉金/拍賣)---脫裝備
		private function dissolveMonsterHandler(_monsterID:String):void 
		{
			var _aryEqu:Array = this._dicMonster[_monsterID]._aryEquipment;
			for (var i:int = 0; i < 3;i++ ) {
				if (_aryEqu[i]!="") {
					EquipmentDataCenter.GetEquipment().ChangeUseing(_aryEqu[i]._gruopGuid,_aryEqu[i]._guid,i,1);
				}	
			}
		}
		
		
		
		//---取得群組的index------
		private function getEquIndexHandler(_group:String):int 
		{
			var _strIndex:String = _group.slice(0,3);
		    var _equType:int=-1;
			if (_strIndex == "WPN")_equType = 0;
			if (_strIndex == "AMR")_equType = 1;
			if (_strIndex == "ACY")_equType = 2;
			
			return _equType;
		}
		
		
		
		//---暫時更動monster的狀態(吃石頭)
		public function eatMonsterVauleHandler(_monsterID:String,_stoneID:String):void 
		{
			if (this._dicMonster[_monsterID]!=null && this._dicMonster[_monsterID]!=undefined) {
			  //var _stone:Object = StoneDataCenter.GetStoneDataControl().GetStone(_stoneID);
			  var _stone:PlayerStone = StoneDataCenter.GetStoneDataControl().GetStoneClass(_stoneID);
				if (_stone!=null) {
					var _monster:PlayerMonster = this._dicMonster[_monsterID];
					var _stoneVaule:int;
					_monster._eatStoneRange += 1;
					//_stoneVaule = _stone._hP;
					_stoneVaule = _stone._HP;
					/*
					_monster._attack = _monster._attack+int(_stone._atk);
					_monster._defense =_monster._defense+int(_stone._def);
					_monster._speed =_monster._speed+int(_stone._speed);
					_monster._int=_monster._int+int(_stone._Int);
					_monster._mnd =_monster._mnd+int(_stone._mnd);
					_monster._maxhpValue =_monster._maxhpValue+ _stoneVaule;
					*/
					_monster._attack = _monster._attack+int(_stone._attack);
					_monster._defense =_monster._defense+int(_stone._defense);
					_monster._speed =_monster._speed+int(_stone._speed);
					_monster._int=_monster._int+int(_stone._int);
					_monster._mnd =_monster._mnd+int(_stone._mnd);
					_monster._maxhpValue =_monster._maxhpValue+ _stoneVaule;
					//---改變stone的狀態---//---1=正常/2=掛賣/0=使用狀態(server尚未回寫)
					StoneDataCenter.GetStoneDataControl().ChangeStoneType(_stoneID,0);
					//----連線
					this._voGroupCall(ProxyMonsterStr.Monster_voGroup,new Set_PlayerMonster(this._setMonsterStr, { _type:4, _guid:_monsterID, _stoneId:_stoneID } ));
					var _missionHave:MissionConditionComplete= new MissionConditionComplete(); 
					_missionHave._missionType = ProxyPVEStrList.MISSION_Cal_MONSTER_EAT;
					_missionHave._missionGuid = _monsterID;
					this._voGroupCall(ProxyMonsterStr.Monster_voGroup,new Get_Mission([_missionHave]));
				}
			}
			
		}
		
		
		
		
		
		//----刪除怪物角色------
		public function RemoveMonster(_index:String):void 
		{
			if (this._dicMonster[_index]!=null && this._dicMonster[_index]!=undefined) {
			  //-----變更角色上面的裝備狀態
			  
			  //if (this._dicVoMonster[_index]._aryEquipment.length>=1) {
				var _aryEqu:Array = this._dicMonster[_index]._aryEquipment;  
				for (var i:int = 0; i < 3;i++ ) {
					if (_aryEqu[i]!="") {
					 EquipmentDataCenter.GetEquipment().ChangeUseing(_aryEqu[i]._gruopGuid,_aryEqu[i]._guid,i,1);
					}
				}  
				  
			   //}
			  this._dicMonster["group"][this._dicMonster[_index]._gruopGuid][_index] = null;
			  delete this._dicMonster["group"][this._dicMonster[_index]._gruopGuid][_index];
			  var _flag:int = 0;
			  for (var j:String in this._dicMonster["group"][this._dicMonster[_index]._gruopGuid]) {
				   _flag = 1;
				   break;
			   }
			  if(_flag==0)delete this._dicMonster["group"][this._dicMonster[_index]._gruopGuid];
			  this._dicMonster[_index] = null;
			  this._allMonsterLen = (this._allMonsterLen > 0)?this._allMonsterLen - 1:0;
			  PlayerMonsterDataCenter.GetMonsterData().monsterNowNumber = this._allMonsterLen;
			  delete this._dicMonster[_index] ;
			  //PlayerMonsterDataCenter.GetMonsterData().SetMonsterDictionary(this._dicMonster);
			}else {
				//---ErrorEvent需要送出去---
				trace("Error_Removemonster---");
			}	
			
		}
		
		//---12/06---選擇要覆蓋的技能
		/*
		public function SetChangeSkill(_monsterID:String,_key:String):void 
		{
			if (this._dicMonster[_monsterID]!=null && this._dicMonster[_monsterID]!=undefined && _key!="") {
			    this._dicMonster[_monsterID]._chageSkill = _key;
			   }else {
				
				trace("error_monster_找不到該怪獸");
				
			}
		}*/
		
		//----添加/附蓋掉新技能//-----2013/2/22更改
		private function AddSkill(_ary:Array,_type:int=6):void 
		{
			
			//_skillKey:String,_monsterID:String
			
			if (this._dicMonster[_ary[0]._guid]!=null && this._dicMonster[_ary[0]._guid]!=undefined) {
				var _index:int = (_type==6)?0:1;
				this._dicMonster[_ary[0]._guid]._arySkill[_index] = _ary[0]._skillId;
				this._dicMonster[_ary[0]._guid]._useing = 1;
				} else {
			    //---error----
				//----找不到該怪獸----
				trace("error_monster_找不到該怪獸");	
			}
				
			/*
			var _len:int = _ary.length;
			for (var i:int = 0; i < _len;i++ ) {
				
				if (this._dicMonster[_ary[i]._guid]!=null && this._dicMonster[_ary[i]._guid]!=undefined) {
			   
				if (_ary[i]._chageSkill=="") {
					this._dicMonster[_ary[i]._guid]._arySkill.push(_ary[i]._skillId);
					} else {
					
					var _index:int =this._dicMonster[_ary[i]._guid]._arySkill.indexOf(_ary[i]._chageSkill);	
					this._dicMonster[_ary[i]._guid]._arySkill[_index] = _ary[i]._skillId;
				}
				
				} else {
				//---error----
				//----找不到該怪獸----
				trace("error_monster_找不到該怪獸");
			}
					
			}
			*/
			
		}
		
		//-----setmonster的學習群組
		public function SetMonsterSkillLearn(_monster:String,_skill:int):void 
		{
			if (this._dicMonster[_monster]!=null && this._dicMonster[_monster]!=undefined) {
			    this._dicMonster[_monster]._nowLearning = _skill;	
			}
			
		}
		
		
		
		//_Key:String,_Hp:int,_Exp:int,_Eng:int
		public function CalculateMonster(_ary:Array):Array 
		{
			
			var _returnAry:Array = [];
			if (_ary!=null) {
				var _len:int = _ary.length;
				for (var i:int = 0; i < _len;i++ ) {
					//----
					var _obj:Object = {_Key:null,_Hp:null,_Exp:null,_Enp:null };
					if (this._dicMonster[_ary[i]._Key]!=null && this._dicMonster[_ary[i]._Key]!=undefined) {
						var _monster:PlayerMonster = this._dicMonster[_ary[i]._Key];
						_obj._Key = _ary[i]._Key;
						_obj._Hp = this.getMonsterCalculateVauleHandler(_monster, 0, _obj._Hp);
						_obj._Exp = this.getMonsterCalculateVauleHandler(_monster, 1, _obj._Exp);
						_obj._Eng = this.getMonsterCalculateVauleHandler(_monster, 2, _obj._Eng);
						
					}else {
						_obj=null
						
					}
					
					_returnAry.push(_obj);
				}
					
			}
			
			return _returnAry;
			
			
		}
		
		//----探索回來---
		public function ExploreBack(_ary:Array):Array 
		{
			
			var _aryReturn:Array = [];
			if (_ary!=null) {
				var _len:int = _ary.length;
				for (var i:int = 0; i < _len;i++ ) {
					
				   if (this._dicMonster[_ary[i]._guid]!=null && this._dicMonster[_ary[i]._guid]!=undefined) {
                       var _exp:int=_ary[i]._nowExp-this._dicMonster[_ary[i]._guid]._nowExp;
					   var _hp:int=_ary[i]._nowHp-this._dicMonster[_ary[i]._guid]._nowhpValue;
					   var _lvUP:Boolean = (_ary[i]._lv>this._dicMonster[_ary[i]._guid]._nowlvValue)?true:false;
					    this._dicMonster[_ary[i]._guid]._nowExp = _ary[i]._nowExp;
						this._dicMonster[_ary[i]._guid]._upNextExp = _ary[i]._upNextExp;
                        this._dicMonster[_ary[i]._guid]._nowhpValue = _ary[i]._nowHp;
                        this._dicMonster[_ary[i]._guid]._nowlvValue=_ary[i]._lv;
		                if (this._dicMonster["group"][this._dicMonster[_ary[i]._guid]._gruopGuid][_ary[i]._guid]!=null) {
							this._dicMonster["group"][this._dicMonster[_ary[i]._guid]._gruopGuid][_ary[i]._guid]._nowExp = _ary[i]._nowExp;
							this._dicMonster["group"][this._dicMonster[_ary[i]._guid]._gruopGuid][_ary[i]._guid]._nowhpValue=_ary[i]._nowHp;
							this._dicMonster["group"][this._dicMonster[_ary[i]._guid]._gruopGuid][_ary[i]._guid]._nowlvValue=_ary[i]._lv;	
						} 
					}	
					_aryReturn.push({_id:_ary[i]._guid,_exp:_exp,_hp:_hp,_lvUP:_lvUP});
				}
			}
			//var _testDic:Dictionary=PlayerMonsterDataCenter.GetMonsterData().GetDicMonster();
			return _aryReturn;
		}
		
		private function getMonsterCalculateVauleHandler(_monster:PlayerMonster,_type:int,_vauleMonster:int):int 
		{
			var _vaule:int = 0;
			switch(_type) {
				//---hp
				case 0:
					_vaule=_vauleMonster - _monster._nowhpValue;
					if (_vauleMonster - _monster._nowhpValue >= _monster._maxhpValue) {
						_monster._nowhpValue =  _monster._maxhpValue;
						} else if(_vauleMonster - _monster._nowhpValue <= 0){
						
						_monster._nowhpValue = 0;
					}else {
						_monster._nowhpValue = _vaule;
					}
					
					
				break;	
				//----exp
			    case 1:
				   _vaule = _vauleMonster - _monster._nowExp;
				   _monster._nowExp = _vauleMonster;
				break;	
				//---eng
			    case 2:
				  _vaule = _vauleMonster - _monster._nowfatigueValue;
				  if (_vauleMonster - _monster._nowfatigueValue >= _monster._maxfatigueValue) { 
					  _monster._nowfatigueValue =  _monster._maxfatigueValue;
					  
					  } else if(_vauleMonster - _monster._nowfatigueValue <= 0){
					  
					   _monster._nowfatigueValue = 0;
					  
					}else {
					  _monster._nowfatigueValue = _vaule;
					}
				  
				  
				break;
				
				
			}
			
			return _vaule;
		}
		
		
		
		
		//---改變經驗值--
		public function ChangeEXP(_monster:String,_exp:int):void 
		{
			
			//var _len:int = _ary.length;
			//for (var i:int = 0; i < _len;i++ ) {
			if (this._dicMonster[_monster]!=null && this._dicMonster[_monster]!=undefined) {
			    this._dicMonster[_monster]._nowExp += _exp;
				if (this._dicMonster[_monster]._upNextExp-this._dicMonster[_monster]._nowExp<=0) { 
					//---符合升級條件---
					//---寫資料庫---
					} else {
					//----改變show出的資訊----
					
				}
				
			}	
			//}
			
			
		}
		
		
		//----疲勞值改變//---_flag=是否要整筆更新到VOgroup裡面
		public function SetFatigueValue(_ary:Array):void 
		{
			
			var _len:int = _ary.length;
			for (var i:int = 0; i < _len;i++ ) {
			var _expVaule:int;	
			if (this._dicMonster[_ary[i]._key]!=null && this._dicMonster[_ary[i]._key]!=undefined) {
			   
				if (this._dicMonster[_ary[i]._key]._maxfatigueValue<=(this._dicMonster[_ary[i]._key]._nowfatigueValue+_ary[i]._vaule)) {
					
					//----到達使用極限------
				    this._dicMonster[_ary[i]._key]._nowfatigueValue =  this._dicMonster[_ary[i]._key]._maxfatigueValue;
					//_expVaule = _ary[i]._vaule;
					//---接後續處理
					
					} else {
				    //-----尚未到達極限使用狀態----	
				   	this._dicMonster[_ary[i]._key]._nowfatigueValue+=_ary[i]._vaule;
				   	//_expVaule = _ary[i]._vaule;
					//this._dicMonster[_ary[i]._key]._nowfatigueValue=(this._dicMonster[_ary[i]._key]._maxfatigueValue<this._dicMonster[_ary[i]._key]._nowfatigueValue+_ary[i]._vaule)?this._dicMonster[_ary[i]._key]._nowfatigueValue+_ary[i]._vaule:this._dicMonster[_ary[i]._key]._maxfatigueValue;
				}
				_expVaule = _ary[i]._vaule
				//this._voGroupCall(new Set_PlayerMonster(this._setMonsterStr, { _type:3, _guid:_ary[i], _ENG:_expVaule} ));
			 }else {
				
			    trace("error_monster查無索引[SetFatigueValue]");	
			 }	
			}
		}
		
		
		
		
		//----生命值改變(送進來的是物建陣列)--obj{_key:string,_vaule:int}
	    
		public function SetHpValue(_ary:Array):void 
		{
			
			var _len:int = _ary.length;
			for (var i:int = 0; i < _len;i++ ) {
				var _hpVaule:int;
				if (this._dicMonster[_ary[i]._key]!=null && this._dicMonster[_ary[i]._key]!=undefined) {
			   
				  if (this._dicMonster[_ary[i]._key]._maxhpValue-(this._dicMonster[_ary[i]._key]._nowhpValue+_ary[i]._vaule)) {
					  
					   this._dicMonster[_ary[i]._key]._nowhpValue = 0;
					   _hpVaule = 0;
					  
					  } else {
					  
					  this._dicMonster[_ary[i]._key]._nowhpValue = (this._dicMonster[_ary[i]._key]._maxhpValue<this._dicMonster[_ary[i]._key]._nowhpValue+_ary[i]._vaule)?this._dicMonster[_ary[i]._key]._maxhpValue:this._dicMonster[_ary[i]._key]._nowhpValue+_ary[i]._vaule;
				      _hpVaule = this._dicMonster[_ary[i]._key]._nowhpValue;
				  }
					
				   //this._voGroupCall(new Set_PlayerMonster(this._setMonsterStr, { _type:2, _guid:_ary[i], _HP:_hpVaule} ));
				   
				  
			     }else {
			  trace("Error_[SetHpValue]查無索引");	
				
			}
				
				
			}
			
		}
		
		
		
		
		
		//----寫入怪獸加入組隊
		public function SetMonsterTeam(_index:String,_team:String):void 
		{
			if (this._dicMonster[_index] != null && this._dicMonster[_index] != undefined) {
			//this.SetMonsterStates(_index,2);	
			  this._dicMonster[_index]._teamGroup = _team;  
			} 

		}
		
		
		
		
		
		
		//----改變怪獸狀態----
		public function SetMonsterStates(_index:String,_type:int):void 
		{
			if (this._dicMonster[_index] != null && this._dicMonster[_index] != undefined) {
				this._dicMonster[_index]._useing = _type;	
				//this._dicVoMonster[_index]._registerTime = _times;
			}else {
				
			    trace("Error_Monster[SetMonsterStates]查無索引");		
			}
		}
		
		//---註冊怪獸使用的時間(要把怪獸掛進去時間管理裡面)(回復使用)
		//----使用狀態-0.刪除, 1.閒置（在巢穴）, 2.溶解中, 3.學習中, 4.戰鬥中, 5.掛賣中-----
		public function RegisterUseMonster(_index:String,_times:uint,_status:int=2):void 
		{
			if (this._dicMonster[_index] != null && this._dicMonster[_index] != undefined) {
				this._dicMonster[_index]._useing = _status;	
				this._dicMonster[_index]._registerTime = _times;
				if (_status == 2 || _status == 5) this.dissolveMonsterHandler(_index);
			}else {
				
			 trace("Error_Monster[RegisterUseMonster]查無索引");		
			}
		}
		
		
		//----從註冊列表裡面拿掉
		public function UnRegisterMonster(_index:String):void 
		{
	        if (this._dicMonster[_index] != null && this._dicMonster[_index] != undefined) {
				this._dicMonster[_index]._useing = 1;	
				this._dicMonster[_index]._registerTime = 1;
			}else {
				trace("Error_Monster[UnRegisterMonster]查無索引");
			}	
		}
		
		//---回覆改怪獸的疲勞值(先行計算)
		/*
		private function RecoveryFatigueHandler():void 
		{
			
			if (this._checkRecoveryENGflag==true) {
				var _realregTimes:uint = PlayerDataCenter.GetMonsterFatigueTimes() * 1000;
				TimeDriver.ChangeDrive(this.RecoveryFatigueHandler,_realregTimes);
				this._checkRecoveryENGflag = false;
			}
			
			
			for each(var i:PlayerMonster in this._dicMonster) {
		   	   
				if (i._useing==1) {
					i._nowfatigueValue = (i._nowfatigueValue > 0)? i._nowfatigueValue--:0;
					//---要再判斷出征的疲勞值限制檢查,達到最低門檻就送訊息	
				}
			}
			//---check是否異動時間跟全域的對不起來
			
		}*/
		
		//---回覆改怪獸的生命值(先行計算)
		/*
		private function RecoveryHPHandler():void 
		{
			
			if (this._checkRecoveryHPflag==true) {
				var _realregTimes:uint = PlayerDataCenter.GetMonsterHPTimes() * 1000;
				TimeDriver.ChangeDrive(this.RecoveryHPHandler,_realregTimes);
				this._checkRecoveryHPflag = false;
			}
			
			for each(var i:PlayerMonster in this._dicMonster) {
		   	   
				if (i._useing==1) {
					i._nowhpValue = (i._nowfatigueValue < i._maxhpValue)? i._nowfatigueValue+i._rehpValue:i._maxhpValue;
					//---要再判斷出征的疲勞值限制檢查,達到最低門檻就送訊息	
				}
			}
		}
		*/
		//-----取得要註冊的function
		/*
		public function GetRegistTimeFun(_str:String):Function 
		{
			var _return:Function = (_str=="HP")?this.RecoveryHPHandler:this.RecoveryFatigueHandler;
			return _return;
		}*/
		//---回覆改怪獸的HP/疲勞值(先行計算)
		
		//----暫時改變的
		/*
		public function ChangeMonsterStatus():void 
		{
			
		}
		*/
		
		
		
		
	}
	
}