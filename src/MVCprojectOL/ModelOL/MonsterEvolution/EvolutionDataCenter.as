package MVCprojectOL.ModelOL.MonsterEvolution
{
	import flash.net.ObjectEncoding;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.Monster.MonsterServerWrite;
	import MVCprojectOL.ModelOL.Monster.PlayerMonsterDataCenter;
	import MVCprojectOL.ModelOL.PayBill.PayBillDataCenter;
	import MVCprojectOL.ModelOL.SourceData.UserSourceCenter;
	import MVCprojectOL.ModelOL.Vo.Evolution;
	import Spark.Utils.SourceArray.ArrayTool;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class EvolutionDataCenter 
	{
		
		private var _dicEvolution:Dictionary;
		private var _sendFun:Function;
		//---vocall----
		private var _callFun:Function;
		//---該項系統--
		private static var _EvolutionDataCenter:EvolutionDataCenter;
		
		//---進化暫存---
		private var _aryQueue:Array;
		
		public function EvolutionDataCenter(_fun:Function,_call:Function)
		{
			this._dicEvolution = new Dictionary(true);
			this._sendFun = _fun;
			this._callFun = _call;
			this._aryQueue = [];
			//---取得金鑽消費的金額
			//this._systemMoney = PayBillDataCenter.GetInstance().Inquiry(_skillKey);
		}
		
		//---更新進化後舊有隊伍資訊---
		public function GetQueue(_target:String):Object 
		{
			var _len:int = this._aryQueue.length;
			var _backObj:Object;
			for (var i:int = 0; i < _len;i++ ) {
			   if (this._aryQueue[i]._name==_target) {
				_backObj = {_teamGroup:this._aryQueue[i]._teamGroup,_monster:this._aryQueue[i]._monster };
				this._aryQueue.splice(i, 1);
				break;
			   }	
				
			}
			
			return _backObj;
		}
		
		public static function GetInstance(_fun:Function=null,_call:Function=null):EvolutionDataCenter 
		{
			//var _returnEvo:EvolutionDataCenter
			if (_fun!=null && _call!=null) {
				if (EvolutionDataCenter._EvolutionDataCenter == null)EvolutionDataCenter._EvolutionDataCenter=new EvolutionDataCenter(_fun,_call);
			}
			
			return EvolutionDataCenter._EvolutionDataCenter;
		}
		
		//---type=1>
		public function AddEvolutionList(_ary:Array,_evoFlag:String="",_evoNewMonsterID:String="",_skill:String=""):void 
		{
			
			var _len:int = (_ary!=null)?_ary.length:-1;
			var _retunnEvoList:Object;
			var _checkSame:Boolean = false;
			var _evolutionObj:Object={_type:0};
			//this._dicEvolution = new Dictionary(true);
			if (_len>0) {
				for (var i:int = 0; i < _len;i++ ) {
				if(this._dicEvolution[_ary[i]._guid]==null && this._dicEvolution[_ary[i]._guid]==undefined) {
				  this._dicEvolution[_ary[i]._guid] = _ary[i];
				  _checkSame = true;
				}
			 }
				
			}else {
			   //--進化到頂點(不可再進化了)
				_evolutionObj._type = 3;	
				_evolutionObj._monster = PlayerMonsterDataCenter.GetMonsterData().GetEvoTopMonster(_evoNewMonsterID);	
				
			}
			
			 
			//{ _monster:null, _evoID:Null,_evoObj:null};
			//if(_evoFlag=="")
			if (_evoFlag != "") {
				//var _check:Boolean = false;
				var _eov:Evolution = _ary[0] as Evolution;
				if ( _checkSame==false) {
					_evolutionObj._type = 1;
					_evolutionObj. _evoID = _eov._guid;
					_evolutionObj._monster = PlayerMonsterDataCenter.GetMonsterData().GetSingleEvoMonster(_evoNewMonsterID, _eov._targetGroupID, _eov._needLv);
					
					
					} else {
				_evolutionObj._type = 2;	
				//var _eov:Evolution = _ary[0] as Evolution;
				var _checkObjA:Object = (_eov._aryNeedSourceA.length>0)?this.checkListHandler(_eov._aryNeedSourceA, _eov._soul):null;
				var _checkObjB:Object = (_eov._aryNeedSourceB.length>0)?this.checkListHandler(_eov._aryNeedSourceB, _eov._soul):null;
				var _objSourceB:Array = (_checkObjB!=null)?_checkObjB._sourceAry:null;
	            var _objSourceA:Array = (_checkObjA != null)?_checkObjA._sourceAry:null;
				//var _check:Boolean = _checkObjA._useType;
				var _check:Boolean = (_checkObjA==null && _eov._needMonsterNum>1)?true:_checkObjA._useType;
				_check = (_objSourceB!=null && _checkObjA._useType==true)?_checkObjB._useType:_check;
				//var _objFlagB:* = (_checkObjB!=null)?_checkObjB._useType:null;
				//var _objFlagA:* = (_checkObjA!=null)?_checkObjA._useType:null;
				
				   _evolutionObj.evoObj={ 
				   //---array-所有吻合進化的怪物---
				   _aryMonster:PlayerMonsterDataCenter.GetMonsterData().CheckMonsterSingleEvolution(_eov._targetGroupID,_eov._needLv),
				   _needSource_A:_objSourceA,
				   //_recipeFlag_A:_objFlagA,
				   _needSource_B:_objSourceB,
				   //_recipeFlag_B:_objFlagB,
				   _sourceFlag:_check,
				   _recipeID:_eov._guid,
				   _needMoney:_eov._soul,
				   _needColorRank:_eov._rank,
				   _needLv:_eov._needLv,
				   _preAtk:_eov._attack,
				   _preDef:_eov._defense,
				   _preSp:_eov._speed,
				   _preInt:_eov._int,
				   _preMnd:_eov._mnd,
				   _preHp:_eov._HP,
				   _prePic:_eov._picItem,
				   _showName:_eov._showName,
				   _jobName:_eov._jobName,
				   _jobPic:_eov._jobPic,
				   _motionItem:_eov._motionItem,
				   _needMonsterNum:_eov._needMonsterNum
				}	
					
					
				}

			}
			//---0527--進化技能
			if (_skill != "")_evolutionObj._evoSkill = _skill;
			this._sendFun(ProxyPVEStrList.MonsterEvolution_EvoListReady,_evolutionObj);
			//----test----
			//this.testGetEvoListHandler();
			
		}
		
		
		/*
		private function testGetEvoListHandler():void 
		{
			var _ary:Array = this.GetEvolutionList();
			
			
			
			
			trace("getEvoList");
		}*/
		//-----取回所有的清單並且檢查條件
		//------monster{_flagEvo:boolean,_attack,_defense,_speed,_int,_mnd,_HP,_picItem}
		//-色階(完成品)：1.白色, 2.綠色, 3.藍色, 4.藍色+1, 5.藍色+2, 6.藍色+3, 7.粉紅色, 8.金色

		public function GetEvolutionList():Array 
		{
			
			var _returnAry:Array = [];
			
			for each(var i:Evolution in this._dicEvolution) {
				var _check:Boolean = false;
				var _objSourceA:Array=null;
			    var _objSourceB:Array=null;
				if (i._rank == 2 || (i._rank>3 && i._rank<7)) {
					_check = true;
					} else {
				   var _checkObjA:Object = (i._aryNeedSourceA.length>0)?this.checkListHandler(i._aryNeedSourceA, i._soul):null;
				   var _checkObjB:Object = (i._aryNeedSourceB.length > 0)?this.checkListHandler(i._aryNeedSourceB, i._soul):null;
				   _objSourceA = (_checkObjA != null)?_checkObjA._sourceAry:null;
				   _objSourceB = (_checkObjB != null)?_checkObjB._sourceAry:null;
				   _check = _checkObjA._useType;
				   _check = (_objSourceB!=null && _checkObjA._useType==true)?_checkObjB._useType:_check;
				}
				
				var _evolutionObj:Object = { 
				   //---array-所有吻合進化的怪物---
				   _aryMonster:PlayerMonsterDataCenter.GetMonsterData().CheckMonsterSingleEvolution(i._targetGroupID,i._needLv),
				   _needSource_A:_objSourceA,
				   _needSource_B:_objSourceB,
		           _sourceFlag:_check,
				   _recipeID:i._guid,
				   _needMoney:i._soul,
				   _needColorRank:i._rank,
				   _needLv:i._needLv,
				   _preAtk:i._attack,
				   _preDef:i._defense,
				   _preSp:i._speed,
				   _preInt:i._int,
				   _preMnd:i._mnd,
				   _preHp:i._HP,
				   _prePic:i._picItem,
				   _showName:i._showName,
				   _jobName:i._jobName,
				   _jobPic:i._jobPic,
				   _motionItem:i._motionItem,
				   _needMonsterNum:i._needMonsterNum
				}	
				
				_returnAry.push(_evolutionObj);
			}
			
			return _returnAry;
		}
		
		
		
		
		//---check單一進化是否合法-----_groupID>犧牲掉的怪物
		//---[-1/怪物不存在/  -2目標階級不符/ -3目標顏色不符/ -4原型id不符/-5素材不夠/-6錢不夠/-99配方表查詢不到 ]
		//--_oblation>獻技
		public function checkEvolution(_targetID:String,_recipeID:String,_oblation:String=""):int 
		{
			var _flag:int=1;
			var _recipeEvolution:Evolution = this._dicEvolution[_recipeID];
			
			//---檢查靈魂是否足夠----
			if (_recipeEvolution!=null) {
				//---[-6=錢不夠]
				//_flag = (PlayerDataCenter.PlayerSoul>=_recipeEvolution._soul)?1:-6;
				if (PlayerDataCenter.PlayerSoul>=_recipeEvolution._soul) {
					//var _strIndex:String = (_recipeEvolution._targetGroupID!="")?_recipeEvolution._targetGroupID:"";
				    var _monsterCheck:int=PlayerMonsterDataCenter.GetMonsterData().CheckMonsterEvolution(_targetID,_recipeEvolution._needLv,_recipeEvolution._targetGroupID)
					//----check 獻祭
					_monsterCheck = (_oblation=="")?_monsterCheck:PlayerMonsterDataCenter.GetMonsterData().CheckMonsterEvolution(_oblation,_recipeEvolution._needLv,_recipeEvolution._targetGroupID);
					
					if (_monsterCheck>0) {
					//--_recipeEvolution._rank=2>白>綠
					//-色階(完成品)：1.白色, 2.綠色, 3.藍色, 4.藍色+1, 5.藍色+2, 6.藍色+3, 7.粉紅色, 8.金色
					if (_recipeEvolution._rank==3 || _recipeEvolution._rank>=7) {
					  
					   //---綠>max
					   var _arySourceA:Array = _recipeEvolution._aryNeedSourceA;
					   var _arySourceB:Array = (_recipeEvolution._aryNeedSourceB.length>0)?_recipeEvolution._aryNeedSourceB:null;
						//this.checkListHandler(
					   _arySourceA = (_arySourceB!=null)?ArrayTool.ObjConcat(_arySourceA,_arySourceB):_arySourceA;
					   var _len:int = _arySourceA.length;
					   for (var i:int = 0; i < _len;i++ ) {
						   
						if (UserSourceCenter.GetUserSourceCenter().CheckSource(_arySourceA[i]._groupGuid, _arySourceA[i]._number) == false) {
							//---素材不夠
							_flag = -5;
							break;
						}
						   
					   }
					    
					}
					
					
					} else {
					//---怪獸檢查不合法
					_flag = _monsterCheck;
				   }	
				   
				   
				   
				   
				   
				    }else {
					//---錢不夠
					_flag = -6;
				}
				
				} else {
				//--找不到目標配方表
				_flag = -99;
			}
			
			

			return _flag;
		}
		
		
		//----檢查進化條件(素材數量)---
		private function checkListHandler(_ary:Array,_moneySoul:int):Object 
		{
			
			var _len:int = _ary.length;
			var _soul:int = PlayerDataCenter.PlayerSoul;
			var _returnAry:Array = [];
			
			var _useing:Boolean = true;
			for (var i:int = 0; i < _len;i++ ) {
				//var _strIndex:String = _ary[i]._groupGuid.slice(0,3);
				//if (_strIndex=="MOB") {
					//-----check 怪獸是否足夠-----
					//_useing = PlayerMonsterDataCenter.GetMonsterData().CheckEvolution(_ary[i]._groupGuid,_ary[i]._number);
					//} else {
					//----素材---
				if (UserSourceCenter.GetUserSourceCenter().CheckSource(_ary[i]._groupGuid, _ary[i]._number) == false)_useing = false;
				//}
				_returnAry.push(
				{
					//---需要的數量
					_need:_ary[i]._number,
					_picItem:_ary[i]._picItem,
					_guid:_ary[i]._groupGuid,
					_info:_ary[i]._info,
					_playerNum:UserSourceCenter.GetUserSourceCenter().GetSourceSingleNum(_ary[i]._groupGuid)
					
					
				});
			}
			
			if (_soul < _moneySoul)_useing = false;
			var _returnObj:Object = { _useType:_useing, _sourceAry:_returnAry };
			return _returnObj;
			
		}
		
		//----進化-------
		//----[1=成功/-1=查無怪獸資料  -2=怪獸不是處於閒置狀態 -3=查詢不到進化表 -98需要獻技的怪物]				
		public function GetEvolution(_targetGuid:String,_evoGuid:String,_oblation:String=""):int 
		{
			var _return:int = 1;
			var _evoList:Evolution=this._dicEvolution[_evoGuid];
			//var _checkMonster:int = (_targetGuid == "")? -1:PlayerMonsterDataCenter.GetMonsterData().CheckUseInfo(_targetGuid);
			var _checkMonster:int;
			if (_evoList._needMonsterNum>1) { 
				_checkMonster = (_targetGuid == "")?-98:PlayerMonsterDataCenter.GetMonsterData().CheckUseInfo(_targetGuid);
				} else {
				_checkMonster=PlayerMonsterDataCenter.GetMonsterData().CheckUseInfo(_targetGuid);
			}	
			//---check是否獻祭
			//_checkMonster = (_oblation=="")?_checkMonster:PlayerMonsterDataCenter.GetMonsterData().CheckUseInfo(_oblation);
			var _arySourceA:Array = _evoList._aryNeedSourceA;
			var _arySourceB:Array = (_evoList._aryNeedSourceB.length>0)?_evoList._aryNeedSourceB:null;
			_arySourceA = (_arySourceB!=null)?ArrayTool.ObjConcat(_arySourceA,_arySourceB):_arySourceA;	
			if (_checkMonster>0 ) {
				if (_evoList._rank ==3 || _evoList._rank>=7) {
					var _len:int = _arySourceA.length;
					for (var i:int = 0; i < _len;i++ ) {
						//---刪除素材----
						UserSourceCenter.GetUserSourceCenter().UseSource(_arySourceA[i]._groupGuid,_arySourceA[i]._number); 
					}
					
				}
				
				var _monsterMobId:String = PlayerMonsterDataCenter.GetMonsterData().GetMonsterGroupID(_targetGuid);
				MonsterServerWrite.GetMonsterServerWrite().RemoveMonster(_targetGuid);
				
				//--獻祭
				if (_oblation != "" && _evoList._needMonsterNum > 1) {
				   
				   var _teamOtherMonster:String = PlayerMonsterDataCenter.GetMonsterData().GetMonsterTeam(_oblation);
				   if (_teamOtherMonster!="") this._aryQueue.push({_name:_targetGuid, _monster:_oblation, _teamGroup:_teamOtherMonster});
				   MonsterServerWrite.GetMonsterServerWrite().RemoveMonster(_oblation);	
				}
				//---刪除配方表----
				if (!PlayerMonsterDataCenter.GetMonsterData().CheckMobIdAry(_monsterMobId)) delete this._dicEvolution[_evoGuid];	
				
				PlayerDataCenter.addSoul(-_evoList._soul);
				//---連線--
				
				this._callFun(ProxyPVEStrList.MonsterEvolution_SetEvo,_evoGuid,_targetGuid,_oblation);
				
			}else {
				
			 _return = (_checkMonster <= 0 )?_checkMonster:-3;	
				
			}
			
			return _return;
			
			
		}
		
		//---可進行操作=true/false(撿查進化的金額是否足夠)
		/*
		--[-1]>該怪獸查詢資料錯誤>
		[ -2] > 該怪獸不是進化怪獸不能刷技能 >
		[ -3] > 該怪獸不在閒置中
		[ -4] > 玩家金鑽餘額不足 >
		[1] > 可以執行刷技能
		*/
		public function CheckMonsterStatus(_monster:String):int 
		{
			var _flag:int = 1;
			//var _flag:Boolean = (PlayerDataCenter.PlayerMony>=this._systemMoney)?true:false;
			var _monsterStatus:int = PlayerMonsterDataCenter.GetMonsterData().CheckResetSkill(_monster);
			/*
			if (_monsterStatus==1) { 
				_flag = (PlayerDataCenter.PlayerMony>=this._systemMoney)?1:-4;
				
				} else {
				_flag=_monsterStatus	
			}*/	
			return _flag;
		}
		
		//---0617----eric hunag---
		//---{_guid:進化表的ID,_list:A/B(字串),_groupGuid:需要素材的guid}
		public function GetTipsVO(_obj:Object):* 
		{
			var _returnVO:*;
			if (this._dicEvolution[_obj._guid]!=null && this._dicEvolution[_obj._guid]!=undefined) {
					
				var _targetAry:Array = (_obj._list=="A")?this._dicEvolution[_obj._guid]._aryNeedSourceA:this._dicEvolution[_obj._guid]._aryNeedSourceB;    
				var _len:int = _targetAry.length;	
				for (var i:int = 0; i < _len;i++ ) {
						if (_targetAry[i]._groupGuid==_obj._groupGuid) {
						
							_returnVO = { _showName:_targetAry[i]._showName, _showInfo:_targetAry[i]._showInfo};	
							break;
						}
						
					}
				
					
				}
			
				return _returnVO;
			
		}
		
		
		
		
		//---給monster的guid-----
		public function ReSetSkill(_guid:String):void 
		{
			//---call server----
			//---進化計能消費字串--
			//SysCost_RANDSKILL_COST
			/*
			var _monsterData:PlayerMonsterDataCenter=PlayerMonsterDataCenter.GetMonsterData();
			if (_monsterData.CheckMonster(_guid)==1) {
				PlayerDataCenter.addMoney(-this._systemMoney);
				this._callFun(ProxyPVEStrList.MonsterEvolution_changeSkill,_guid);
				
				} else {
				//---怪獸資料錯誤Error---
			}
			*/
			//this._callFun(ProxyPVEStrList.MonsterEvolution_changeSkill,_guid);
			
		}
		
		
		
	}
	
}