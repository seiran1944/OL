package MVCprojectOL.ViewOL.BattleView
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.SkillDisplayModel.CombatSkillDisplay;
	import MVCprojectOL.ModelOL.SkillDisplayModel.CombatSkillDisplayProxy;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleBasic;
	import MVCprojectOL.ModelOL.Vo.Battle.BattlefieldInit;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleFighter;
	import MVCprojectOL.ViewOL.IfMenuConter;
	import Spark.MVCs.Models.BarTool.BarGroup;
	import Spark.MVCs.Models.TextDriftTool.TextDriftPool;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.ArchivesStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.04.08.20.10
		@documentation 嵌到城牆內的區塊
	 */
	public class IconZone extends Sprite// implements IfMenuConter
	{
		//private var _funCallBack:Function;
		//private var _funNotify:Function;
		//private var _container:DisplayObjectContainer;
		//
		private var _funHub:Function;
		private var _barGroup:BarGroup;//BAR群組控制
		private var _dicSign:Dictionary;//ICON四格位置的配置點
		private var _objSource:Object;//素材來源
		private var _proxySkill:CombatSkillDisplayProxy;//領取狀態ICON用
		private var _spArmyArea:Sprite;
		private var _spEnemyArea:Sprite;
		private const _leftIconBasicX:int = 55;
		
		public function IconZone():void
		{
			this._dicSign = new Dictionary(true);
		}
		
		public function set NotifyPlaceHub(hubWay:Function):void
		{
			this._funHub = hubWay;
		}
		
		private function toHub(status:String,info:Object=null,sendOut:Boolean=false):void 
		{
			this._funHub(status, info, sendOut);
		}
		
		//public function onCreat(_notifyfun:Function, _publicFun:Function, _spr:DisplayObjectContainer):void
		//{
			//this._funNotify = _funNotify;
			//this._funCallBack = _publicFun;
			//this._container = _spr;
			//_spr.addChild(this);
			//var sp:Sprite = new Sprite();
			//sp.graphics.beginFill(0xFF0000);
			//sp.graphics.drawCircle(0, 0, 10);
			//sp.graphics.endFill();
			//this.addChild(sp);
		//}
		//(ViewCmd>>)
		public function AddSource(_key:String, _obj:*):void
		{
			switch (_key) 
			{
				case "barGroup":
					this._barGroup = _obj;
				break;
				case "txtGroup":
					
				break;
			default:
				this._objSource = _obj;
				this.areaBackgroundPrepare();
			}
		}
		//public function onRemove():void
		//{
			//this.Destroy();
		//}
		//public function AddVaules(_vaules:*):void { }
		
		
		//取得效果ICON用(ViewCtrl >>)
		public function InSkill(skillProxy:Object):void
		{
			this._proxySkill = skillProxy as CombatSkillDisplayProxy;
			
		}
		
		
		private function areaBackgroundPrepare():void 
		{
			var pStage:Point = ProjectOLFacade.GetFacadeOL().GetStageInfo();
			
			this._spArmyArea = new Sprite();
			this._spEnemyArea = new Sprite();
			addChild(this._spArmyArea);
			addChild(this._spEnemyArea);
			this._spArmyArea.x = 19;
			this._spEnemyArea.x = 642;
			
			
			const periodX:int = 5;
			const periodY:int = 2;
			var pLocate:Point;
			var spBg:Sprite;
			for (var i:int = 0; i < 5; i++) 
			{
				spBg  = new this._objSource["infoBoard"]();
				this._spArmyArea.addChild(spBg);
				pLocate = this.GetLocateWithFive(i, spBg.width , periodX);
				spBg.x = pLocate.x;
				spBg.y = pLocate.y;
				spBg  = new this._objSource["infoBoard"]();
				this._spEnemyArea.addChild(spBg);
				spBg.x = pLocate.x;
				spBg.y = pLocate.y;
			}
			
			this._spArmyArea.y = this._spEnemyArea.y = 55;
			
		}
		//place 0~4
		public function GetLocateWithFive(place:int,width:Number,periodX:int,initX:int=0,initY:int=0):Point
		{
			var locate:Point = new Point();
			locate.x = place * width + periodX * place + initX;
			locate.y = initY;
			return locate;
		}
		//初始怪物訊息顯示層物件
		public function InDicFightBase(dicBase:Dictionary):void
		{
			//var dicPoint:Dictionary = this.createIconPlace();
			var sBox:SignBox;
			var monDp:MonsterDisplay;
			var fighter:BattleFighter;
			var place:Point;
			var cutPlace:int;
			var countArmy:int;
			var countEnemy:int;
			const periodX:int = 103;
			const periodY:int = 43;
			
			for (var name:String in dicBase)
			{
				monDp = FighterBase(dicBase[name]).MonDisplay;
				fighter = monDp.MonsterData as BattleFighter;
				sBox = new SignBox();
				sBox.mouseChildren = false;
				//sBox.SetDicPlace(dicPoint);//丟進ICON位置清單
				sBox.name = "SignBox" + name;
				sBox.SetHeadIcon(monDp.MonsterHead);//丟進大頭
				sBox.InSource(this._objSource);//丟進素材
				//130408新增職業名(測試用)
				sBox.InitJobTitle(fighter._jobName);
				//130327新增血量顯示txt(測試用)
				sBox.SetBloodValue(fighter._hp, fighter._maxHp);
				//
				this._barGroup.AddBar(name, sBox.BarImagine, fighter._hp, fighter._maxHp, true, .4);//丟BAR進控管區
				this._dicSign[name] = sBox;
				cutPlace = int(name.substr(0, 1));
				
				if (name.length > 5) {//Enemy
					//sBox.PlaceRight( -this._leftIconBasicX);
					place = this.GetLocateWithFive(countEnemy,sBox.width,5);
					this._spEnemyArea.addChild(sBox);
					countEnemy++;
				}else {//Army
					//monDp.HeadDir = true;//轉頭
					place = this.GetLocateWithFive(countArmy,sBox.width,5);
					this._spArmyArea.addChild(sBox);
					countArmy++;
				}
				//trace(place.x, place.y, name, "MY monster info object");
				//trace("框位置", sBox.x, sBox.y, name);
				sBox.x = place.x;
				sBox.y = place.y;
				
			}
			
		}
		
		
		public function GetSignBox(combineKey:String):SignBox
		{
			return combineKey in this._dicSign ? this._dicSign[combineKey] : null;
		}
		
		//處理訊息顯示層的變化(血量變更)
		public function DefenderValueProcess(info:Object):void
		{
			//{ _effect :  , _place :  , _isOurSide : , _funFin : , _valueBag :  , _isSpell :  }
			var combineKey:String = String(info["_place"]) + String(info["_isOurSide"]);
			//var objChange:Object = this.checkChangeParams(info["_valueBag"]);
			var btBasic:BattleBasic = info["_valueBag"];
			//主要處理血條的變化
			if(btBasic._maxHp!=0 ) this._barGroup.BarReset(combineKey, false, this._barGroup.GetTotalValue(combineKey)+btBasic._maxHp);//最大値有變化時才做處理
			if (btBasic._hp != 0) {
				this._barGroup.BarRunValue(combineKey, btBasic._hp);
				this.toHub(ArchivesStr.BATTLEIMAGING_VIEW_LOG, { _type : 3 , _combineKey : combineKey , _hp : btBasic._hp } );//通知LOG顯示增減的血量變化値 //20130531改成不夾帶技能與施放與否<{ _type : 3 , _combineKey : combineKey , _hp : btBasic._hp , _isSpell : info["_isSpell"] , _effect : info["_effect"] }>
				//130327新增顯示變更的血量數值
				this.GetSignBox(combineKey).SetBloodValue(this._barGroup.GetFinalValue(combineKey),this._barGroup.GetTotalValue(combineKey));
				if (this._barGroup.GetFinalValue(combineKey) == 0) this.toHub(ArchivesStr.BATTLEIMAGING_VIEW_OLDEAD, combineKey);//通知怪物出場
			}
			
		}
		
		//怪物陣亡時連同訊息區塊也要消失
		public function DisableMonster(combineKey:String):void 
		{
			var sBox:SignBox = this.GetSignBox(combineKey);
			var container:Sprite = combineKey.length > 5 ? this._spEnemyArea : this._spArmyArea;
			
			TweenLite.to(sBox, 1, { alpha:0 , onComplete : this.decreaseComplete , onCompleteParams : [sBox, container] } );
		}
		private function decreaseComplete(target:SignBox,container:Sprite):void 
		{
			//trace(this._spArmyArea.contains(target),this._spArmyArea==container);
			//trace(this._spEnemyArea.contains(target),this._spEnemyArea==container);
			
			container.removeChild(target);
		}
		
		
		//檢測屬性是否有變更(多個屬性需要變更顯示可使用)
		//public function checkChangeParams(info:BattleBasic):Object
		//{
			//var objChange:Object = { };
			//var vecParams:Vector.<String> = Vector.<String>(["_atk", "_def", "_agi", "_int", "_mnd", "_hp", "_maxHp"]);
			//var leng:int = vecParams.length;
			//var keyPoint:String;
			//for (var i:int = 0; i < leng; i++)
			//{
				//keyPoint = vecParams[i];
				//if (info[keyPoint] != 0) objChange[keyPoint] = info[keyPoint];
			//}
			//
			//return objChange;
		//}
		
		//處理訊息顯示層的變化(效果狀態增減)
		public function DefenderEffectProcess(info:Object):void
		{
			//info["_isAdd"] , info["_aryDeEffect"]
			var aryDeEft:Array = info["_aryDeEffect"];
			var combineKey:String = String(info["_place"]) + String(info["_isOurSide"]);
			var sBox:SignBox = this.GetSignBox(combineKey);
			if (info["_isAdd"]) {
				this.AddEffectSign(sBox,aryDeEft[0]);//正常應當一次只會有一個 (FighterBase一項一項處理的)
				
			}else {
				this.RemoveEffectSign(sBox,aryDeEft);
			}
			
		}
		
		//初始檢查是否有怪物帶有靈氣加成(新增ICON的顯示)
		public function AddSpiritualInfluence(initFighter:BattlefieldInit):void 
		{
			this.checkFighterBuff(initFighter._objEnemy, false);
			this.checkFighterBuff(initFighter._objArmy, true);
		}
		private function checkFighterBuff(objMember:Object,isOurSide:Boolean):void 
		{
			var fighter:BattleFighter;
			var leng:int;
			var sBox:SignBox;
			for (var name:String in objMember) 
			{
				fighter = objMember[name];
				leng = fighter._aryEffect.length;
				if (leng > 0) {
					sBox = this.GetSignBox(name + String(isOurSide));
					for (var i:int = 0; i < leng; i++) 
					{
						this.AddEffectSign(sBox, fighter._aryEffect[i]);
					}
				}
				
			}
		}
		
		//此處呼叫的effectKey是效果的key
		private function AddEffectSign(sBox:SignBox,effectKey:String):void
		{
			var csDisplay:CombatSkillDisplay = this._proxySkill.GetCombatSkillDisplayClone(effectKey);
			
				//ItemDisplay(aryBack[i]).ItemIcon.x = Math.random() * 1000;
				//ItemDisplay(aryBack[i]).ItemIcon.y = Math.random() * 700;
			//測試用強制調整大小
			//csDisplay.Icon.width = 16;//**************************************************************************************************************
			//csDisplay.Icon.height = 16;//**************************************************************************************************************
			//
			
			sBox.AddSign(csDisplay.IconKey, csDisplay.Icon);//此處導入SignBox內的AddSign key是技能效果的 "ICON圖示的KEY"
			//trace("收到SIGN新增通知", sBox, effectKey);
			
		}
		private function RemoveEffectSign(sBox:SignBox,aryKey:Array):void
		{
			//trace("收到SIGN移除通知", sBox, aryKey);
			var leng:int = aryKey.length;
			if (leng == 0) return;
			
			var csDisplay:CombatSkillDisplay;
			for (var i:int = 0; i < leng; i++)
			{
				csDisplay = this._proxySkill.GetCombatSkillDisplay(aryKey[i]["_guid"]);//只拿ICON 的 KEY 之後可以改用非CLONE的方法使用 省去CLONE一次
				sBox.RemoveSign(csDisplay.IconKey);
			}
			
		}
		
		//20130613
		//技能輪播TIPS顯示取得當前播放效果名稱
		public function GetCurrentEffectName(boxName:String):String
		{
			return this.GetSignBox(boxName).CurrentEffectName;
		}
		
		
		//預計最大値四個左右
		//  0  1
		//  2  3
		//private function createIconPlace():Dictionary
		//{
			//var dicPoint:Dictionary = new Dictionary(true);
			//var pLocate:Point;
			//var basicX:int = 55;//大頭像基本X位置
			//var basicY:int = -7;//大頭像基本Y位置
			//var betweenX:int = 5;//間距X
			//var betweenY:int = 5;//間距Y
			//
			//for (var i:int = 0; i < 4; i++) 
			//{
				//pLocate = new Point();//行列數與ICON SIZE - 間距
				//pLocate.x =  int(i / 2 ) * (16 - 2) + betweenX * int(i / 2) + this._leftIconBasicX;
				//pLocate.y = (i % 2 ) * (16 - 3) + (i % 2 ) * betweenY + basicY;
				//dicPoint["icon" + String(i)] = pLocate;
			//}
			//return dicPoint;
		//}
		
		
		public function Destroy():void 
		{
			for each (var item:SignBox in this._dicSign) 
			{
				item.Destroy();
			}
			this._dicSign = null;
			this._funHub = null;
			this._objSource = null;
			this._proxySkill = null;
			this._spArmyArea = null;
			this._spEnemyArea = null;
			this._barGroup = null;
			while (this.numChildren>0)
			{
				this.removeChildAt(0);
			}
			
		}
		
	}
	
}