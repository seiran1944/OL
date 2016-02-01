package MVCprojectOL.ViewOL.BattleView
{
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.CombatMonsterDisplayProxy;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MotionKeyStr;
	import MVCprojectOL.ModelOL.SkillDisplayModel.CombatSkillDisplayProxy;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleEffect;
	import MVCprojectOL.ModelOL.Vo.Battle.BattlefieldSteps;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleFighter;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleRound;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleRoundEffect;
	import Spark.ErrorsInfo.MessageTool;
	import Spark.Timers.TimeDriver;
	import strLib.proxyStr.ArchivesStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.03.18.15.44
		@documentation 流程內容分發器
	 */
	public class BattleStepsCtrl 
	{
		
		private var _funHub:Function;
		private var _dicFighterBase:Dictionary;
		private var _currentCompleteNum:int;
		private var _roundDivide:Boolean = false;
		private var _isRound:Boolean;//標記此次運行是否為回合階段資料
		private var _aryDivideArmy:Array = [];//不裁切原資料故
		private var _aryDivideEnemy:Array = [];//不裁切原資料故
		private var _millisecondPeriod:uint;
		private var _proxySkill:CombatSkillDisplayProxy;
		//130318//新增處理項目作為技能施放打空氣的額外播放處理
		private var _dicAirBase:Dictionary;
		
		public function BattleStepsCtrl():void
		{
			this._dicFighterBase = new Dictionary(true);
		}
		
		public function InSkill(skillProxy:Object):void
		{
			this._proxySkill = skillProxy as CombatSkillDisplayProxy;
		}
		
		public function InitFighters(proxyMon:CombatMonsterDisplayProxy,army:Object,enemy:Object,funHub:Function):void
		{
			this.buildFighterList(proxyMon, army, true,funHub);
			this.buildFighterList(proxyMon, enemy, false,funHub);
		}
		private function buildFighterList(proxy:CombatMonsterDisplayProxy,objMember:Object,isOurSide:Boolean,funHub:Function):void
		{
			var fbase:FighterBase;
			for (var name:String in objMember)
			{
				fbase = new FighterBase(funHub, proxy.GetMonsterDisplay(objMember[name]["_guid"]),isOurSide,int(name));
				this._dicFighterBase[name + isOurSide] = fbase;
			}
		}
		
		public function set Period(millisecond:uint):void 
		{
			this._millisecondPeriod = millisecond;
		}
		
		public function get DicFighterBase():Dictionary
		{
			return this._dicFighterBase;
		}
		
		public function Fighter(combineKey:String):BattleFighter
		{
			return combineKey in this._dicFighterBase ? FighterBase(this._dicFighterBase[combineKey]).MonDisplay.MonsterData as BattleFighter : null;
		}
		
		/**
		 * @param	key Place + true/false
		 * @return
		 */
		private function getFighterBase(key:String):FighterBase
		{
			if (key in this._dicFighterBase) {
				return this._dicFighterBase[key];
			}else {//沒有目標對象,有可能是SERVER位置錯誤或是打空氣的狀態 		//130318加入打空氣的處理
				if (this._dicAirBase == null) this._dicAirBase = new Dictionary(true);
				if (key in this._dicAirBase) {
					return this._dicAirBase[key];
				}else {
					var airBase:FighterBase = new FighterBase(this._funHub, null, key.length > 5 ? false : true , int(key.substr(0, 1)));
					this._dicAirBase[key] = airBase;
					return airBase;
				}
			}
			//MessageTool.InputMessageKey(7701);//查無FighterBase元件資料
			//return null;
		}
		
		public function set NotifyPlaceHub(hubWay:Function):void
		{
			this._funHub = hubWay;
		}
		
		private function toHub(status:String, info:Object = null ):void
		{
			this._funHub(status, info);
		}
		
		//判斷技能
		private function checkAttackType(spellSkill:String):Object
		{
			var objData:Object = this._proxySkill.GetCombatSkillDisplay(spellSkill).Data;
			//trace("動態攻擊種類參數>>>", this._proxySkill.GetCombatSkillDisplay(spellSkill).Data["_actType"], spellSkill);
			//_actType 0 >BUFF類型  ,  1 > 物理攻擊  ,  2 > 魔法攻擊   // 是普通攻擊(True)    或是魔法攻擊(false)
			//_attackType  此招式的類型 1 . 技能    2 . 普通攻擊
			return { _actType : objData["_actType"] == 1 ? true : false , _attackType : objData["_attackType"] == 1 ? false : true};//尚缺辨識內容型態*******************************************************************
		}
		//檢測是否需要移動的操作 // 130419加入攻擊對象的位置與敵我方 做移動細部判斷
		public function checkAttackMoving(steps:BattlefieldSteps):Boolean
		{
			//攻擊種類：1.敵方單一目標 , 2.我方單一目標, 3.敵方隊伍, 4.我方隊伍,5.自己
			//var executeType:uint = this._proxySkill.GetCombatSkillDisplay(steps._spellSkill).Data["_executeType"];
			//trace("施放技能" , steps._spellSkill , "TYPE", executeType, "============================================================================================",executeType,moving);
			//簡略處理 只做第一組的判斷處理
			//var moving:Boolean = (steps._defender[0]._ourSide == steps._userSide) ? false : true;
			//return ((executeType == 2 && moving) || executeType == 4) ? true : false;
			
			//130510調整成依照技能屬性來判斷移動方式
			//0 = 無值 , 1 = 移動到隊伍面前施放 , 2 = 原地施放
			var movingType:uint = this._proxySkill.GetCombatSkillDisplay(steps._spellSkill).Data["_movingType"];
			
			return movingType != 2 ? true : false;
			
		}
		
		//{ _effect :  , _place :  , _isOurSide : , _funFin : , _valueBag :  , _isSpell :  }
		//檢測是否需要顯示血量值
		public function checkSpoutBlood(basic:Object):Boolean 
		{
			// 技能種類：1.物理傷害類, 2.魔法傷害類, 3.增益輔助類, 4.控場減益類
			var check:Boolean = this._proxySkill.GetCombatSkillDisplay(basic._effect).Data._isShowDamage;
			
			//trace("技能名稱", this._proxySkill.GetCombatSkillDisplay(basic._effect).Data._name, this._proxySkill.GetCombatSkillDisplay(basic._effect).Data._class,basic._valueBag._hp,basic._isSpell,"check="+check);
			
			return check;
		}
		
		//接收外部的步驟通知
		public function SettingSteps(currentStep:BattlefieldSteps):void
		{
			this._isRound = false;
			var _objCheckHit:Object = this.checkDefenderHit(currentStep._defender);
			//可調整延遲時間長度
			TimeDriver.AddDrive(this._millisecondPeriod, 1, this.delayAttackerShow, [currentStep, _objCheckHit]);
		}
		//延遲攻擊方動作起始
		private function delayAttackerShow(currentStep:BattlefieldSteps,_objCheckHit:Object):void
		{
			TimeDriver.RemoveDrive(this.delayAttackerShow);
			
			//會變成需要判斷是普攻動作或是魔攻動作
			var fighterBase:FighterBase = this.getFighterBase(String(currentStep._attacker) + String(currentStep._userSide));
			
			//取得攻擊施放的種類
			var objType:Object= this.checkAttackType(currentStep._spellSkill);
			
			fighterBase.ActionTo(objType._actType ? MotionKeyStr.Attack : MotionKeyStr.MAttack);
			//發送LOG顯示訊息內容>>攻擊者資料
			this.toHub(ArchivesStr.BATTLEIMAGING_VIEW_LOG, { _type : 2 , _attackType : objType._attackType , _valueBag : currentStep } );
			
			TimeDriver.AddDrive(this._millisecondPeriod, 1, this.defenderWork, [currentStep._spellSkill, _objCheckHit["_aryHit"], _objCheckHit["_aryMiss"]]);
			
			//檢測攻擊方的攻擊後回饋效果與自身數值變化反應============================================================
			TimeDriver.AddDrive(this._millisecondPeriod * 3, 1,
			function checkAttackerEffect(currentStep:BattlefieldSteps,fighterBase:FighterBase):void//檢測攻擊方的效果與否
			{
				TimeDriver.RemoveDrive(checkAttackerEffect);
				if (currentStep._hp > 0) {
					_currentCompleteNum++;//補充播放完效果後的計數通知量避免造成不相等
					fighterBase.SetFighterEffect(currentStep._guid, currentStep);
				}
			}
			, [currentStep, fighterBase]);
			
		}
		
		//檢測攻擊方的效果與否(暫停後又重新起始會容易造成時差問題先做區域化避免)
		//private function checkAttackerEffect(currentStep:BattlefieldSteps,fighterBase:FighterBase):void
		//{
			//TimeDriver.RemoveDrive(this.checkAttackerEffect);
			//if(currentStep._hp>0) fighterBase.SetFighterEffect(currentStep._guid, currentStep);
		//}
		
		//檢測防禦方的擊中與否
		private function checkDefenderHit(defender:Array):Object
		{
			this._currentCompleteNum = 0;
			var leng:int = defender.length;
			var info:BattleEffect;
			var aryHit:Array = [];
			var aryMiss:Array = [];
			for (var i:int = 0; i < leng; i++)
			{
				info = defender[i];
				if (info._atkHit) {
					aryHit[aryHit.length] = info;
					//當前攻擊項目中被攻擊對象有擊中的數量
					this._currentCompleteNum ++;
				}else {
					aryMiss[aryMiss.length] = info;
				}
			}
			//this._effectZone.ShowEffect(defender);
			return { _aryHit : aryHit , _aryMiss : aryMiss };
		}
		
		//防禦方的動態相關處理
		private function defenderWork(skill:String,aryDefender:Array,aryMiss:Array):void
		{
			TimeDriver.RemoveDrive(this.defenderWork);
			var leng:int = aryDefender.length;
			var btEffect:BattleEffect;
			var ftBase:FighterBase;
			//var delaySystem:DelayShowSystem;
			for (var i:int = 0; i < leng; i++)
			{
				btEffect = aryDefender[i];
				ftBase = this.getFighterBase(String(btEffect._place) + String(btEffect._ourSide));
				ftBase.SetFighterEffect(skill, btEffect);
				//ftBase.ActionTo(MotionKeyStr.Hurt);
			}
			
			
			//特殊狀況 若defender為零代表沒有施放命中的任何技能與效果此時區間訊號會中斷要補在MISS圖示處理完成時發送銜接訊號
			//夾帶發送攻擊未擊中的單位顯示
			if(aryMiss.length>0) this.toHub(ArchivesStr.BATTLEIMAGING_VIEW_SHOWMISS, { _aryMiss : aryMiss , _allMiss : aryDefender.length == 0 ? true : false } );
		}
		
		//接收外部的回合中斷點通知
		public function SettingRounds(aryRound:Array,needReverse:Boolean=false):void
		{
			this._isRound = true;
			if (!this._roundDivide) {//篩選先播放敵方狀態演出( 篩選過有切兩區塊則會略過 )( 沒切兩區塊一次播完會由外部再次傳下筆資料運行 )
				this._aryDivideArmy.length = 0;
				this._aryDivideEnemy.length = 0;
				var leng:int = aryRound.length;
				var roundEt:BattleRoundEffect;
				for (var i:int = leng-1; i >= 0; i--) 
				{
					roundEt = aryRound[i];
					roundEt._ourSide ? this._aryDivideArmy.push(roundEt) : this._aryDivideEnemy.push(roundEt);
				}
				if (this._aryDivideEnemy.length != leng) this._roundDivide = true;//有切出兩區塊的話則變更狀態為有兩段式
				aryRound = this._aryDivideEnemy;//敵方先播放
			}
			
			//20130603 回合效果只有我方的狀態下 先播敵方正常 再播我方 
			//受到流程的影響會先跑進roundEffectWork的CountEffectComplete()會跑回SettingRounds()的TIMER往roundEffectWork呼叫 會受到前面尚未執行的return影響 變成斷層 不動作
			if (needReverse) this._roundDivide = false;
			if (TimeDriver.CheckRegister(this.SettingRounds)) TimeDriver.RemoveDrive(this.SettingRounds);
			
			TimeDriver.AddDrive(this._millisecondPeriod, 1, this.roundEffectWork, [aryRound]);
			
		}
		//回合效果影響播放資料通知
		private function roundEffectWork(aryRound:Array):void
		{
			//trace(TimeDriver.CheckRegister(this.roundEffectWork),"checkPre");
			TimeDriver.RemoveDrive(this.roundEffectWork);
			//trace(TimeDriver.CheckRegister(this.roundEffectWork),"checkAft");
			//回合需要清除的狀態移除其餘播放並演出
			var leng:int = this._currentCompleteNum = aryRound.length;//同時重設需要等待播放完畢的單位數量
			
			if (leng == 0) {//回合沒有效果影響的處理則往下動作
				this.CountEffectComplete();
				return;
			}
			
			var roundEft:BattleRoundEffect;
			var ftBase:FighterBase;
			for (var i:int = 0; i < leng; i++) 
			{
				roundEft = aryRound[i];
				ftBase = this.getFighterBase(String(roundEft._place) + String(roundEft._ourSide));
				ftBase.SetFighterEffect("NONE", roundEft);
				//ftBase.ActionTo(MotionKeyStr.Hurt);
			}
			
			
		}
		
		
		//須注意數量問題,基本上受到攻擊的對像運作完都會發送通知,無論有無效果顯示
		public function CountEffectComplete():void
		{
			//trace("效果播放的數量通知>>>>>>>>>>>>>>>>>>>>>>>>>", this._currentCompleteNum);
			this._currentCompleteNum--;
			if(this._currentCompleteNum<=0){
				if (this._roundDivide) {//回合類型的才會進來
					TimeDriver.AddDrive(this._millisecondPeriod, 1,this.SettingRounds ,[this._aryDivideArmy,true]);//20130603調整緩衝與roundEffectWork() return的衝突性 造成停擺
					//this._roundDivide = false;//通知播放判斷完成後改回預設値
				}else {//普通steps階段 與 兩方round效果播放完畢時
					this.toHub(ArchivesStr.BATTLEIMAGING_VIEW_STEPSFIN,this._isRound);
				}
			}
			
		}
		
		//通知怪物血量已經為零
		public function MonsterDead(combineKey:String):void
		{
			//trace(this.getFighterBase(combineKey));
			this.getFighterBase(combineKey).MonsterDead();
		}
		
		
		public function Destroy():void 
		{
			this._aryDivideArmy.length = 0;
			this._aryDivideEnemy.length = 0;
			this._aryDivideArmy = null;
			this._aryDivideEnemy = null;
			
			for each (var item:FighterBase in this._dicFighterBase)
			{
				item.Destroy();
			}
			this._dicFighterBase = null;
			this._funHub = null;
			
		}
		
		
	}
	
}
