package MVCprojectOL.ViewOL.BattleView
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MotionKeyStr;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleBasic;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleEffect;
	import MVCprojectOL.ModelOL.Vo.Battle.BattlefieldSteps;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleFighter;
	import strLib.proxyStr.ArchivesStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.03.18.15.44
		@documentation 播放物件線程
	 */
	public class FighterBase 
	{
		
		private var _funHub:Function;
		private var _monDisplay:MonsterDisplay;
		private var _hurtEffect:Object;
		private var _currentNum:int;
		private var _effectNum:int;
		private var _isOurSide:Boolean;
		private var _dead:Boolean = false;
		private var _place:int;
		private var _scaleAdjust:Number;//怪物縮放後的寬度
		
		public function FighterBase(hubWay:Function,monDisplay:MonsterDisplay,isOurSide:Boolean,place:int):void
		{
			this.NotifyPlaceHub = hubWay;
			this._isOurSide = isOurSide;
			this._place = place;
			//針對打空氣的處理調整130318
			if (monDisplay != null) {
				this._monDisplay = monDisplay;
				//monDisplay.MonsterData._scaleRate = (Math.random() * 10 > 5) ? .6 : 1;
				this._scaleAdjust = monDisplay.MonsterData._scaleRate;
				if (isOurSide) monDisplay.Motion.Direction = true;
			}
			//trace("MONSTER >>>>>>>>>>>>>>>>>>>>>>>>", this._scaleAdjust);
			
			this.ActionTo(MotionKeyStr.Idle);//預防怪物資料重複拿LIST清單但前場次的怪物動作停留在陣亡畫面,全部重刷動作IDLE,
		}
		
		//battleEffect>>steps狀態傳BattleEffect  /  rounds狀態傳BattleRoundEffect (skill傳"NONE")  /  檢測攻擊方的施招後附帶的效果會用 BattlefieldSteps
		public function SetFighterEffect(skill:String,battleEffect:Object):void
		{
			this._hurtEffect = battleEffect;
			this._currentNum = battleEffect is BattleEffect ? -1 : 0;//施放過技能値會先被增加故-1
			this._effectNum = !(battleEffect is BattlefieldSteps) ? battleEffect._aryEffect.length : 0;//追加給BattlefieldSteps使用
			
			//this.EffectValueTo(false, battleEffect._aryDeEffect);
			
			
			//通知有消失的效果 (20130604)調整到較先處理避免訊息卡在回合開始時顯示   (20130607)調整將BattleEffect 與 BattleRoundEffect 分開處理 回合優先處理DOT效果影響 再做效果的消失(剛好到持續回合數)
			if ((battleEffect is BattleEffect)) {
				if(battleEffect._aryDeEffect.length > 0) this.toHub(ArchivesStr.BATTLEIMAGING_VIEW_CHANGEEFFECT , this.getEffectPackage(false, battleEffect._aryDeEffect));//追加給BattlefieldSteps使用判斷式
			}
			
			
			//發送播放中招技能效果動態通知
			skill != "NONE" ? this.toHub(ArchivesStr.BATTLEIMAGING_VIEW_SHOWEFFECT, this.getInfoPackage(skill,this._hurtEffect,true)) : this.checkOthersEffect();
			
			
			//怪物動作判斷執行
			this.checkHurtAction(battleEffect);
		}
		
		//傳入當前數據判斷扣血量決定是否為損傷動作
		private function checkHurtAction(objCheck:Object):void 
		{
			if (!(objCheck is BattleBasic)) return;
			
			var checkHp:int = objCheck["_hp"];
			//有導致扣血量的技能或效果才變更損傷動作 其餘IDLE方式不處理
			if (checkHp < 0  && !this._dead) {//資料型態不符或是怪物已陣亡就略過*****須注意怪物重生的可能性調整****************************************
				this.ActionTo(MotionKeyStr.Hurt);
			}else if(checkHp > 0 && this._dead) {//回血&& 怪物陣亡狀態***********************照常SERVER傳來怪物陣亡後不會有後續相關動作,若有 作為判斷是否有重生的處理***********************************會在攻擊或屬性影響陣亡後多補一個BattleBasic(回血用)
				this._dead = false;
				this.ActionTo(MotionKeyStr.Idle);
			}
		}
		
		// valueBag >> 都會夾一個BattleBasic出去     // isSpell >> 是(true)  /  否(false) 為施放的招式而非效果顯示
		public function getInfoPackage(effect:String,valueBag:Object,isSpell:Boolean=false):Object
		{
			return { _effect : effect , _place : this._place , _isOurSide : this._isOurSide, _funFin : this.CatchEffectFin , _valueBag : valueBag , _isSpell : isSpell , _scaleAdjust : this._scaleAdjust , _airStrike : this._monDisplay != null ? !this._dead ? false : true : true };
		}
		
		// valueBag >> 會夾一個Array出去Steps階段為[key] , Round階段為[BattleBasic,BattleBasic...]   // _isSpell >> 是(true)  /  否(false)  為施展技能後消失的BUFF
		public function getEffectPackage(isAdd:Boolean,aryDeEffect:Array):Object
		{
			return { _isAdd : isAdd , _aryDeEffect : aryDeEffect ,_place : this._place, _isOurSide : this._isOurSide , _isSpell : this._hurtEffect is BattleEffect ? true : false , _isDead : this._dead};
		}
		
		//檢查夾帶影響效果陣列內的清單依序通知播放 (有效果時的發送處理)
		private function checkOthersEffect():void
		{
			//trace("檢查其他附加效果影響>>>>>>", this._currentNum, this._effectNum, this._hurtEffect, this._place, this._isOurSide,this._hurtEffect._aryEffect);
			if (this._currentNum < this._effectNum) {
				var valueBag:BattleBasic = this._hurtEffect._aryEffect[this._currentNum];//BattleBasic內的GUID(技能效果)
				
				//寫入增加的效果影響
				//this.EffectValueTo(true, [valueBag._guid]);
				//
				//通知增加的效果 會顯示帶有效果影響
				this.toHub(ArchivesStr.BATTLEIMAGING_VIEW_CHANGEEFFECT, this.getEffectPackage(true, [valueBag._guid]));
				//ShowEffect會顯示扣血量LOG
				this.toHub(ArchivesStr.BATTLEIMAGING_VIEW_SHOWEFFECT, this.getInfoPackage(valueBag._guid,valueBag));
				this.checkHurtAction(valueBag);//動作變更的判斷
				
			}else {
				//調整回合部分的狀態消失處理 在回合狀態影響處理過後操作
				if(this._hurtEffect._aryDeEffect.length > 0) this.toHub(ArchivesStr.BATTLEIMAGING_VIEW_CHANGEEFFECT , this.getEffectPackage(false, this._hurtEffect._aryDeEffect));//追加給BattlefieldSteps使用判斷式
				
				this.toHub(ArchivesStr.BATTLEIMAGING_VIEW_DONEEFFECT);
			}
		}
		
		public function set NotifyPlaceHub(hubWay:Function):void
		{
			this._funHub = hubWay;
		}
		
		private function toHub(status:String,info:Object=null):void
		{
			//if (status == ArchivesStr.BATTLEIMAGING_VIEW_SHOWEFFECT) this.ValueTo();//播放前(同時)即改變為最新數值(中招後的値)//可回寫了純通知變更//先關掉了****************************** for battlesteps
			this._funHub(status, info);
		}
		
		//收到播放物件的完成通知,或是不需要播放動態的外部回call通知
		public function CatchEffectFin(spellKey:String=""):void
		{
			//播放完後處理該個效果造成的數值影響點//this.ValueTo();
			
			//NEXT
			this._currentNum++;
			//確認下一個效果的播放
			this.checkOthersEffect();
		}
		
		//動作變更 MotionKeyStr.XXX
		public function ActionTo(actions:String):void
		{
			if(this._monDisplay!=null) if(this._monDisplay.Motion!=null) this._monDisplay.Motion.Act(actions);
			
			//trace("收到動作指令>>>", this._place, this._isOurSide ? "我方" : "敵方", actions);
		}
		
		//相關數值變更(可能會為變更値)
		public function ValueTo():void
		{
			if (this._monDisplay == null) return ;
			var battleFighter:BattleFighter = this._monDisplay.MonsterData as BattleFighter;
			var battleBasic:BattleBasic;
			if (this._currentNum == -1) {//first spell skill (有可能是steps or rounds)
				battleBasic = this._hurtEffect is BattleEffect ? this._hurtEffect as BattleBasic : this._hurtEffect._aryEffect[0];
			}else {//others effect
				battleBasic = this._hurtEffect._aryEffect[this._currentNum];
			}
			//VO夾帶的數值是變更値的狀態下
			battleFighter._agi += battleBasic._agi;
			battleFighter._atk += battleBasic._atk;
			battleFighter._def += battleBasic._def;
			battleFighter._int += battleBasic._int;
			battleFighter._mnd += battleBasic._mnd;
			battleFighter._hp += battleBasic._hp;
			battleFighter._maxHp += battleBasic._maxHp;
			//trace("寫入效果技能影響後的數值資料");
		}
		
		
		
		//新增移除 當前掛有的狀態Effect
		//public function EffectValueTo(isAdd:Boolean,aryEffectKey:Array):void
		//{
			//同樣效果不會有疊加的狀況
			//var fighter:BattleFighter = this._monDisplay.MonsterData as BattleFighter;
			//var index:int;
			//if (isAdd) {
				//index = fighter._aryEffect.indexOf(aryEffectKey[0]);
				//if (index == -1) fighter._aryEffect[fighter._aryEffect.length] = aryEffectKey[0];
			//}else {
				//var leng:int = aryEffectKey.length;
				//for (var i:int = 0; i < leng; i++)
				//{
					//index= fighter._aryEffect.indexOf(aryEffectKey[i]);
					//if (index != -1) fighter._aryEffect.splice(index, 1);
				//}
			//}
			//trace("變更增加減少的效果影響KEY記錄", isAdd, aryEffectKey);
		//}
		
		public function get MonDisplay():MonsterDisplay
		{
			return this._monDisplay;
		}
		
		//外部扣血量顯示為零時呼叫怪物出場處理
		public function MonsterDead():void 
		{
			this._dead = true;
			this.ActionTo(MotionKeyStr.Dead);
			//可外接額外的出場處理
			
			
		}
		
		
		public function Destroy():void
		{
			this._funHub = null;
			this._hurtEffect = null;
			this._monDisplay = null;
			
			
		}
		
	}
	
}