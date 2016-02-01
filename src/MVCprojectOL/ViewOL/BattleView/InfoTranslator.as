package MVCprojectOL.ViewOL.BattleView
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.SkillDisplayModel.CombatSkillDisplay;
	import MVCprojectOL.ModelOL.SkillDisplayModel.CombatSkillDisplayProxy;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleEffect;
	import MVCprojectOL.ModelOL.Vo.Tip;
	import Spark.ErrorsInfo.MessageTool;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class InfoTranslator 
	{
		
		private var _proxySkill:CombatSkillDisplayProxy;
		private var _dicMonster:Dictionary;//FighterBase dic
		private var _infoZone:InfoZone;
		//LOG文字處理部分
		private var _logRegExp:RegExp = /\^(.[^\^]*)\^/;
		private var _dicLogMessage:Dictionary;
		
		public function InfoTranslator():void 
		{
			
		}
		
		public function FeedLogMessage(vecTips:Vector.<Tip>):void 
		{
			this._dicLogMessage = new Dictionary();
			var leng:int = vecTips.length;
			var tip:Tip;
			for (var i:int = 0; i < leng; i++) 
			{
				tip = vecTips[i];
				this._dicLogMessage[tip._keyVaule] = tip._tips;
			}
		}
		
		public function InSkill(skillProxy:Object):void
		{
			this._proxySkill = skillProxy as CombatSkillDisplayProxy;
		}
		
		public function InMonster(dicMonster:Dictionary):void
		{
			this._dicMonster = dicMonster;
		}
		
		public function InSource(objSource:Object):void 
		{
			this._infoZone = new InfoZone();
			
			
		}
		
		//內部的拆解內容操作↓
		
		
		private function getMonsterName(combineKey:String):String
		{
			if (combineKey in this._dicMonster) {
				return this._dicMonster[combineKey]["MonDisplay"]["MonsterData"]["_name"];
			}else {
				MessageTool.InputMessageKey(7701);//查無此索引FighterBase
				return null;
			}
		}
		
		/* 
		_round		回合數
		_attacker		攻擊者
		_defender	防禦者
		_hp				血量
		_skill			技能
		_effect			影響的效果
		
		戰鬥開始 <> 戰鬥結束
		第 _round 回合
		_attacker 進行攻擊 //_attacker 使用技能 _skill 進行攻擊
		_defender 的生命值 _hp 
		_defender 瀕死，脫離戰鬥
		_defender 遭受 _skill 狀態  //  _defender 獲得 _skill 狀態  >簡化>  _defender 帶有 _skill 狀態 , 受效果影響 _effect (無法使用技能..之類)
		_defender 解除 _skill 狀態   ///_defender _skill 消失了
		_defender 閃避攻擊
		戰鬥贏得勝利！（或 此次戰鬥全軍覆沒！）
		*/
		
		public function ShowThis(type:int,effectInfo:Object):void
		{
			
			//var combineKey:String = String(effectInfo["_place"]) + String(effectInfo["_isOurSide"]);
			//var objMonster:Object = this.getMonsterData(combineKey);
			
			//this.writeToBoard(effectInfo["_effect"]);
			var showResult:String;
			
			switch (type) 
			{
				case 0://戰鬥開始 <> 戰鬥結束
					//String(effectInfo)//一個開始或結束字串的KEY
					//showResult = (String(effectInfo) == "start") ? "戰鬥開始" : "戰鬥結束";
					
					showResult = this.combineLogString((String(effectInfo) == "start") ? "FIGHT_LOG_STR01" : "FIGHT_LOG_STR02");
					
				break;
				case 1://第 _round 回合
					//showResult = "第" + String(effectInfo) + "回合開始";
					
					showResult = this.combineLogString("FIGHT_LOG_STR03", { _round : String(effectInfo) } );
				break;
				case 2://_attacker 進行攻擊 //_attacker 使用技能 _skill 進行攻擊  >>訊號由BattleStepsCtrl send  { _type : 2 , _attackType : Boolean , _valueBag : BattlefieldSteps } 
					var monName:String = this.getMonsterName(String(effectInfo["_valueBag"]["_attacker"])+String(effectInfo["_valueBag"]["_userSide"]));
					//showResult = effectInfo["_attackType"] ? monName + "進行攻擊" : monName + "使用技能" + this.getWhoYouAre(effectInfo["_valueBag"]["_spellSkill"], 1);
					
					showResult = effectInfo["_attackType"] ? this.combineLogString("FIGHT_LOG_STR04", { _attacker : monName } ) : this.combineLogString("FIGHT_LOG_STR05", { _attacker : monName , _skill : this.getWhoYouAre(effectInfo["_valueBag"]["_spellSkill"], 1) } );
					
				break;
				case 3://_defender 的生命值損失 _hp //_defender 因為 _skill 的影響，生命值損失 _hp >>訊號由IconZone send    { _type : 3 , _combineKey : combineKey , _hp : btBasic._hp   , _isSpell : , _effect :} 
					//effectInfo["_isSpell"]
					var monsterName:String = this.getMonsterName(effectInfo["_combineKey"]);
					
					//showResult = monsterName + "的生命値" + (effectInfo["_hp"] < 0 ? "" : "+ " ) + String(effectInfo["_hp"]);
					//showResult = effectInfo["_isSpell"] ? monsterName + "的生命値" + (effectInfo["_hp"] < 0 ? "" : "+ " ) + String(effectInfo["_hp"]) : monsterName + "受到" + this.getWhoYouAre(effectInfo["_effect"], 1) + "的影響，生命値" + (effectInfo["_hp"] < 0 ? "" : "+ " ) + effectInfo["_hp"];
					var isDecrease:Boolean = effectInfo["_hp"] < 0 ? true : false;
					showResult = this.combineLogString(isDecrease ? "FIGHT_LOG_STR07" : "FIGHT_LOG_STR06", { _defender : monsterName , _hp : (isDecrease ? "" : "+ " ) + String(effectInfo["_hp"]) } );
					
				break;
				case 4://_defender 瀕死，脫離戰鬥 >>訊號由IconZone send
					//showResult = this.getMonsterName(String(effectInfo)) + "瀕死，脫離戰鬥";
					
					showResult = this.combineLogString("FIGHT_LOG_STR08", { _defender : this.getMonsterName(String(effectInfo)) } );
				break;
				case 5:
					//_defender 遭受 _skill 狀態  //  _defender 獲得 _skill 狀態  >簡化>  _defender 帶有 _skill 狀態  , 受效果影響 _effect (無法使用技能..之類) >>訊號由ViewCtrl send
					//_defender 解除 _skill 狀態   ///_defender _skill 消失了 <= BUFF時效到了才有這個文字   >>訊號由ViewCtrl send (FighterBase內發送的ChangeEffect訊號可能要加上TYPE區分技能消失的或是回合消失的)
					// { _isAdd : isAdd , _aryDeEffect : aryDeEffect ,_place : this._place, _isOurSide : this._isOurSide , _isSpell}
					var monsterN:String = this.getWhoYouAre(effectInfo, 2);
					if (effectInfo["_isAdd"]) {
						//20130530 增加的CC效果說明
						var objValue:Object = this.getSkillClassValue(effectInfo["_aryDeEffect"][0]);//_string , _isCC
						
						//增加的一次只會傳送一個
						//showResult = effectInfo["_isSpell"] ? monsterN + "帶有" + this.getWhoYouAre(effectInfo["_aryDeEffect"][0], 1) + "狀態" : !objValue._isCC ? monsterN + "受到" + this.getWhoYouAre(effectInfo["_aryDeEffect"][0], 1) + "效果影響" : monsterN + "受到" + this.getWhoYouAre(effectInfo["_aryDeEffect"][0], 1) + "效果影響" + objValue._string; 
						var objInfo:Object = { _defender : monsterN , _skill : this.getWhoYouAre(effectInfo["_aryDeEffect"][0], 1) };
						if(objValue._isCC) objInfo._effect = this.getSkillClassValue(effectInfo["_aryDeEffect"][0]);
						
						showResult = effectInfo["_isSpell"] ? this.combineLogString("FIGHT_LOG_STR09", objInfo ) : this.combineLogString( !objInfo._isCC ? "FIGHT_LOG_STR13" : "FIGHT_LOG_STR14" , objInfo );
						
					}else {
						var skillMix:String = this.getWhoYouAre(effectInfo["_aryDeEffect"], 0);
						//showResult = effectInfo["_isSpell"] ? monsterN + "解除" + skillMix + "狀態" : monsterN + "   " + skillMix + "消失了";
						
						showResult =  this.combineLogString(effectInfo["_isSpell"] ? "FIGHT_LOG_STR10" : "FIGHT_LOG_STR11" , { _defender : monsterN , _skill : skillMix } );
						
					}
					
				break;
				case 6://戰鬥贏得勝利！（或 此次戰鬥全軍覆沒！）>>ViewCtrl 戰鬥結束或是顯示最終圖示時發送
					
					//showResult = effectInfo ? "戰鬥贏得勝利" : "戰鬥落敗";
					
					showResult = this.combineLogString(effectInfo ? "FIGHT_LOG_STR15" : "FIGHT_LOG_STR16");
				break;
				case 7://_defender 閃避攻擊 >>>>訊號由BattleStepsCtrl send
					//{ _aryMiss : [BattleEffect]  , _allMiss : Boolean }
					//showResult = this.getWhoYouAre(effectInfo, 3) + "閃避攻擊";//若要分開顯示則要另外處理
					
					showResult = this.combineLogString("FIGHT_LOG_STR12", { _defender : this.getWhoYouAre(effectInfo, 3) } );
				break;
				}
			
			this.writeToBoard(showResult);
		}
		
		//做字串掏取替換動作(重組) 
		//type >> 後台對應CLIENT 的 KEY
		//objInfo >> 自訂變數 對應實際數值 ( 做TIPS內文替換 )
		private function combineLogString(type:String,objInfo:Object=null):String 
		{
			var strMixed:String = type in this._dicLogMessage ? this._dicLogMessage[type] : "'ERROR' NO TIPS TEMPLATE";
			
			var objExec:Object = this._logRegExp.exec(strMixed);
			while (objExec!=null) 
			{
				strMixed = strMixed.replace(this._logRegExp, objInfo[objExec[1]]);
				objExec = this._logRegExp.exec(strMixed);
			}
			
			return strMixed;
		}
		
		//1單技能 / 2單怪 / 3多怪[BattleEffect]
		private function getWhoYouAre(objInfo:Object,type:int):String 
		{
			
			var reString:String="";
			
			switch (type) 
			{
				case 0://多技能
					var leng:int = objInfo.length;
					var csDisplay:CombatSkillDisplay;
					for (var i:int = 0; i < leng; i++) 
					{
						csDisplay = this._proxySkill.GetCombatSkillDisplay(objInfo[i]["_guid"]);
						reString += csDisplay.Data["_name"] + ",";
					}
				break;
				case 1:
					var cdPro2:CombatSkillDisplay = this._proxySkill.GetCombatSkillDisplay(String(objInfo));
					reString = cdPro2.Data["_name"];//**********************************************************************************************************************補技能名稱屬性
				break;
				case 2:
					reString = this.getMonsterName(String(objInfo["_place"]) + String(objInfo["_isOurSide"]));
				break;
				case 3: 
					var length:int = objInfo["_aryMiss"].length;
					var bEffect:BattleEffect;
					for (var j:int = 0; j < length; j++)
					{
						bEffect = objInfo["_aryMiss"][j];
						reString += this.getMonsterName(String(bEffect._place) + String(bEffect._ourSide)) + ",";
					}
				break;
			}
			
			//return '<font color="#FF0000">' + reString +'</font>';
			return  reString ;
			
		}
		
		//20130530 取得附加的單位影響字串
		private function getSkillClassValue(guid:String):Object
		{
			//取得BUFF技能效果TYPE cc類的 class 有 19.禁言, 20.禁武, 21.睡眠, 22.昏迷, 23.混亂, 24.無敵
			var classNum:uint = this._proxySkill.GetCombatSkillDisplay(guid).Data._class;
			//依照索引取得對應效果內文
			return {_string : this._dicLogMessage["FIGHT_LOG_STR" + String(classNum-2)] , _isCC : classNum<19 ? false : true };//視前接字串變更
		}
		
		
		
		private function writeToBoard(word:String):void
		{
			this.InfoContainer.ShowInfo(word);
		}
		
		
		public function get InfoContainer():InfoZone 
		{
			return this._infoZone;
		}
		
		public function Destroy():void 
		{
			this._dicMonster = null;
			this._infoZone.Destroy();
			this._infoZone = null;
			this._proxySkill = null;
			
		}
		
		
	}
	
}