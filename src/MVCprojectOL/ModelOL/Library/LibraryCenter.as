package MVCprojectOL.ModelOL.Library 
{
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Building.BuildingProxy;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.Monster.MonsterServerWrite;
	import MVCprojectOL.ModelOL.Monster.PlayerMonsterDataCenter;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineObject;
	import MVCprojectOL.ModelOL.Vo.PlayerData;
	import MVCprojectOL.ModelOL.Vo.PlayerLibrary;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class LibraryCenter 
	{
		//----學習中的角色
		private var _dicLearning:Dictionary;
		//private var _arySkill
		//---紀錄紀能類群裡面可以學習到的技能-----
		private static var _LibraryCenter :LibraryCenter ;
		private var _buildKey:String = "";
		private var _buildType:int = 0;
		//private var _skillTime:uint = 0;
		private var _sendFunction:Function;
		private var _flag:Boolean = false;
		//---學習所需消耗疲勞度
		private var _learnFatigue:int = 0;
		//--學習需復的魂量
		private var _learnSoul:int = 0;
		//---學習時間
		private var _learnTime:int = 0;
		//----圖書館初始資料
		//private const _aryBookType:Array = ["A", "B", "C", "D"];
		//private var _LibraryVo:LibraryVo;
		
		//---建築物等級----
	    //private var _buildLv:int = 0;
		
		public function LibraryCenter (_fun:Function) 
		{
			this._dicLearning = new Dictionary(true);
			this._sendFunction = _fun;
		}
		
		
		public function  SetbuildKey(_value:String,_type:int):void {
		  this._buildKey = _value; 
		  this._buildType = _type;
		  //this._buildLv = _buildLv;
	   };
		//---設定技能學習時間
		//public function set skillTime(value:uint):void { _skillTime = value };
		
		
		public static function GetLibrary(_fun:Function=null):LibraryCenter 
		{
			if (LibraryCenter._LibraryCenter==null) {
				if (_fun != null) LibraryCenter._LibraryCenter = new LibraryCenter(_fun);
				
			}
			return LibraryCenter._LibraryCenter ;
		}
		
		//---每個大類群的skill都用dic來區隔-----(回來的陣列都不能疊加的,不然會重複)
		//--{_type:"類群",_arySkill:Array}
		public function SetUseSkill(_vo:PlayerLibrary):void 
		{
			var _len:int = _vo._ary.length;
			var _ary:Array = _vo._ary as Array;
			this._learnFatigue = _vo._learnFatigue;
			this._learnSoul = _vo._learnSoul;
			this._learnTime = _vo._learnTime;
			if (_len>0) {
				
					
			     for (var i:int = 0; i < _len;i++ ) {
				
				  //if (this._dicLearning[_ary[i]._type]!=null || this._dicLearning[_ary[i]._type]!=undefined) {
				   this._dicLearning[_ary[i]._type] = _ary[i]._ary;
					//} else {
					//this._dicLearning[_ary[i]._type].concat(_ary[i]._ary);
				  //}
		       }
				
				
				
			}
			
		
			//var _str:String = "";
			//if (this._flag==false) {
				//this._flag = true;
				
				//_str = ProxyPVEStrList.LIBRARY_PROXYReady;
				//} else {
				//_str = ProxyPVEStrList.LIBRARY_SetSKILLReady;
			//}
			
			this._sendFunction(ProxyPVEStrList.LIBRARY_SetSKILLReady);
			
		}
		
		
		//---取得所有技能----
		public function GetLibSkill():Dictionary 
		{
			
			
			
			
			var _dicReturn:Dictionary = new Dictionary(true);
			var _soul:int = PlayerDataCenter.PlayerSoul;
			for (var i:String in this._dicLearning) {
				
				var _ary:Array = this._dicLearning[i].slice(0);
				var _skillFlag:Boolean = (this._learnSoul > _soul)?false:true;
				
				var _obj:Object = { 
					_arySkill:_ary,
					//---確認目前的金錢是否夠學習技能
					_checkFlag:_skillFlag,
					//---消耗疲勞
					_learnFatigue:this._learnFatigue,
					//---消耗魂力
					_learnSoul:this._learnSoul,
					//---需要時間
					_learnTime:this._learnTime,
					//---groupNmae-----
					_groupGuid:i
				};
				
				_dicReturn[i] = _obj;	
			}
			
			return _dicReturn;	
		}
		
		
		//---減查牌成是否已滿
		public function CheckLineIllegal():Boolean 
		{
			var _flag:Boolean = ((BuildingProxy.GetInstance().GetBuildWorking(this._buildKey)).length < BuildingProxy.GetInstance().GetBuildLineMax(this._buildKey))?true:false;
			return _flag;
		}
		
		//---取得時間排程
		public function GetLine():Array 
		{
			return TimeLineObject.GetTimeLineObject().GetAllLine(this._buildKey);
		}
		
		//----檢查怪獸學習技能的狀況
		
		public function CheckLearnStates(_monsterID:String):int 
		{
			var _aryMonSkill:Array = PlayerMonsterDataCenter.GetMonsterData().GetMonsterSkill(_monsterID);
			var _checkMonsterFatigue:Boolean = PlayerMonsterDataCenter.GetMonsterData().CheckSingleFatigueValue(_monsterID);
			//---0>push/1>override/2>error
			var _returnFlag:int = 0;
			if (_aryMonSkill!=null) {
				
				//if () {
				//---技能以滿,詢問是否附蓋0///---技能尚有空位/1-------	
				if (_checkMonsterFatigue==true) {
					_returnFlag = (_aryMonSkill[0]!="")?0:1;
					
				}else {
					//---該怪獸目前累死了
					_returnFlag = 3;
				}	
				//}else {
				//---目前非閒置狀態---
				//_returnFlag = 5;		
				//}
				var _soul:int = PlayerDataCenter.PlayerSoul;
				
				//-----靈魂量不足
				if (this._dicLearning._learnSoul > _soul)_returnFlag = 4;
				
				} else {
				//----error(沒有該怪獸的資料/怪獸不存在)---
				_returnFlag = 2; 
			}
			
			
			return _returnFlag;
		}
		
	
		//-----學習技能
		//---學習技能這塊尚未完成-----
	    public function StarLearning(_skillGroup:String,_monsterID:String,_changeSkill:String=""):Array 
		{
			//-----連線~送出_arySkill,_monsterID,_LibLV
			//---PS---並且把該隻怪獸的使用狀態改成被使用-----
			//---需要在掛進去時間控制裡面--------
			//--扣除疲勞值,---soul----
			var _starTime:uint = ServerTimework.GetInstance().ServerTime;
			var _aryLibrary:Array;
			var _monsterFlag:Boolean = PlayerMonsterDataCenter.GetMonsterData().CheckSingleFatigueValue(_monsterID);
			var _nowSoul:int = PlayerDataCenter.PlayerSoul;
			if (_monsterFlag==true && this._learnSoul<=_nowSoul) {
				//---學習技能
				MonsterServerWrite.GetMonsterServerWrite().RegisterUseMonster(_monsterID, _starTime,3);
				//if (_changeSkill != "")MonsterServerWrite.GetMonsterServerWrite().SetChangeSkill(_monsterID,_changeSkill);
				//---消耗疲勞值,
				MonsterServerWrite.GetMonsterServerWrite().SetFatigueValue([{_key:_monsterID,_vaule:this._learnFatigue}]);
				//---消耗魂量的檢查
				PlayerDataCenter.addSoul(-(this._learnSoul));
				//---這邊要改要把技能的SKILL_key回送------
				//var _skillTime:int = this._dicLearning[_skillGroup]._learnTime;
				TimeLineObject.GetTimeLineObject().AddTimeLine(this._buildKey,_monsterID,_starTime,this._learnTime,this._buildType,"Library",_changeSkill,int(_skillGroup));
				_aryLibrary = TimeLineObject.GetTimeLineObject().GetAllLine(this._buildKey);
				MonsterServerWrite.GetMonsterServerWrite().SetMonsterSkillLearn(_monsterID,int(_skillGroup));
			  } else {
				trace("monster 不合法");	
				_aryLibrary = [];
				
			}
			return _aryLibrary;
			
		}
		
		
		
		
		
	}
	
}