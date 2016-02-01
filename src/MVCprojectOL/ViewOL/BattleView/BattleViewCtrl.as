package MVCprojectOL.ViewOL.BattleView
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import MVCprojectOL.ModelOL.BattleImaging.BattleManager;
	import MVCprojectOL.ModelOL.Monster.MonsterProxy;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.CombatMonsterDisplayProxy;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.MotionSettings.MotionValue;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleEffect;
	import MVCprojectOL.ModelOL.Vo.Battle.BattlefieldSteps;
	import MVCprojectOL.ModelOL.Vo.Tip;
	import MVCprojectOL.ViewOL.TipsView.TipsCenterView;
	import Spark.coreFrameWork.View.ViewCtrl;
	import Spark.Timers.TimeDriver;
	import strLib.commandStr.PVECommands;
	import strLib.proxyStr.ArchivesStr;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewStrLib;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.03.18.15.44
		@documentation to use this Class....
	 */
	public class BattleViewCtrl extends ViewCtrl 
	{
		
		private var _doc:BattleManager;//PROXY取得的步驟計數順序處理器
		private var _proxyMonster:CombatMonsterDisplayProxy;
		private var _stepsCtrl:BattleStepsCtrl;//調控步驟流工具
		private var _bgLayer:CarpetLayerFull;//背景層區塊
		private var _armySide:FighterArea;//左區塊
		private var _enemySide:FighterArea;//右區塊
		private var _effectZone:EffectZone;//效果與過場動態
		private var _bloodZone:BloodZone;//扣血 / MISS 資訊專用層
		private var _iconZone:IconZone;//血條 / 增減益圖示
		private var _infoTranslator:InfoTranslator;//LOG顯示窗的內容處理
		private var _goExit:Boolean = false;//是否點擊了關閉按鈕
		private var _turbo:Boolean = false;//是true    /否false  加速
		private var _isPlaying:Boolean = true;//是true  /否false  播放中
		private var _isReady:Boolean = false;//是true  /否false  資料都有可以操控階段
		private var _explorerNotify:String;//是否為探索顯示使用 >若是則結束播放時不移除monsterProxy的註冊>關閉發送同訊號並夾"CLOSE"
		private var _vecMemory:Vector.<MemoryClip> = new Vector.<MemoryClip>();
		private var _objDeadReport:Object;//作為探索區塊運行時關閉的陣亡怪物需移除顯示清單的先行通知資料
		//20130611
		private var _rollingInTheDeep:Boolean = false;
		//20130619
		private var _shutDownID:int=-1;
		
		public function BattleViewCtrl(name:String,container:DisplayObjectContainer):void
		{
			super(name, container);
			container.addEventListener(MouseEvent.CLICK, this.mouseEventProcess, true);
			container.addEventListener(MouseEvent.ROLL_OVER, this.runForTips, true);
			container.addEventListener(MouseEvent.ROLL_OUT, this.runForTips, true);
		}
		
		private function runForTips(e:MouseEvent):void 
		{
			var name:String = e.target.name;
			var cutName:String = name.substr(0, 1);
			//trace("滑鼠狀態" + e.type , "====", e.target.name, e.currentTarget.name, cutName);
			//faster  play  pause leave 8false 
			if (e.type == "rollOver") {
				switch (cutName) 
				{
					case "f":
						this.mouseMovingAction(true,"FIGHT_LOG_FWD");
					break;
					case "p":
						this.mouseMovingAction(true,name.length == 4 ? "FIGHT_LOG_PLAY" : "FIGHT_LOG_PAUSE");
					break;
					case "l":
						if(name.length==5) this.mouseMovingAction(true,"FIGHT_LOG_CLOSE");
					break;
					case "S"://signBox
						this.mouseMovingAction(true,name.substr(7,name.length-7),true);
					break;
				}
			}else {//roll out
				if(this._rollingInTheDeep) this.mouseMovingAction(false);
			}
			
		}
		private function mouseMovingAction(add:Boolean,addWith:String="",wave:Boolean=false):void 
		{
			if (add) {
				if (wave) {
					var checkShowKey:String = this._iconZone.GetCurrentEffectName(addWith);
					if (checkShowKey == "") return;
					
					TimeDriver.AddDrive(250, 0, this.runningForEffect,[addWith,true]);
				}
				this.runningForEffect(addWith,wave);
			}else {
				if (this._rollingInTheDeep) {
					this._rollingInTheDeep = false;
					this._viewConterBox.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMovingNotify);
					if (TimeDriver.CheckRegister(this.runningForEffect)) TimeDriver.RemoveDrive(this.runningForEffect);
					TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();
				}
			}
		}
		private function mouseMovingNotify(e:MouseEvent):void 
		{
			//trace("滑鼠移動", this._viewConterBox.mouseX, this._viewConterBox.mouseY);
			TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).TipsMove(this._viewConterBox.mouseX,this._viewConterBox.mouseY);
		}
		
		private function runningForEffect(showKey:String,wave:Boolean):void 
		{
			if (!this._rollingInTheDeep) {
				this._rollingInTheDeep = true;
				this._viewConterBox.addEventListener(MouseEvent.MOUSE_MOVE, this.mouseMovingNotify);
			}
			if (wave) {
				var effectKey:String = this._iconZone.GetCurrentEffectName(showKey);
				if (effectKey == "") {
					this.mouseMovingAction(false);//正在顯示中時BUFF消失
					return;
				}
				effectKey = effectKey.substr(0 , effectKey.length - 4);
				this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Storage", ProxyPVEStrList.TIP_STRBASIC, "FIGHT_LOG_SKILLTIP", ProxyPVEStrList.LIBRARY_SKILLTips, effectKey, this._viewConterBox.mouseX, this._viewConterBox.mouseY)) 
			}else {
				this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("CrewSystem", ProxyPVEStrList.TIP_STRBASIC, showKey, "", null, this._viewConterBox.mouseX, this._viewConterBox.mouseY));
			}
		}
		
		
		//導入的背景層配置
		public function LayACarpet(carpet:Object,iconZone:IconZone):void
		{
			this._iconZone = iconZone;
			this._iconZone.NotifyPlaceHub = this.ProcessingHub;
			
			this._bgLayer = new CarpetLayerFull();
			this._bgLayer.NotifyPlaceHub = this.ProcessingHub;
			this._bgLayer.UseTheCarpet(carpet,iconZone);
			this._viewConterBox.addChild(this._bgLayer);
			
			this._infoTranslator = new InfoTranslator();
			this._infoTranslator.InSource(carpet);
			//訊息顯示物件加在下方城牆層內
			iconZone.addChild(this._infoTranslator.InfoContainer);
			var pStage:Point = ProjectOLFacade.GetFacadeOL().GetStageInfo();
			this._infoTranslator.InfoContainer.x = (pStage.x >> 1) - (this._infoTranslator.InfoContainer.width >> 1);
			this._infoTranslator.InfoContainer.y = 50;
		}
		
		//20130524 新增做LOG字串導入區塊
		public function SetLogInfoTips(vecTips:Vector.<Tip>):void 
		{
			this._infoTranslator.FeedLogMessage(vecTips);
		}
		
		//運行LOADING顯示
		public function RunLoading():void
		{
			this._effectZone.ShowLoading();
		}
		//動態播放的速度( 怪物 , 技能 , 怪物晃動)
		public function get FrameRate():uint
		{
			return this._turbo ? 80 : 100;
		}
		//動作間距的基準時間値
		public function get PeriodRate():uint
		{
			return this._turbo ? 400 : 400;
		}
		
		//加速減速設置
		public function OverRun(turbo:Boolean):void 
		{
			if (turbo == this._turbo) return;
			
			this._turbo = turbo;
			MotionValue.GetInstance().MonsterFrameRate = this.FrameRate;
			MotionValue.GetInstance().SkillFrameRate = this.FrameRate;
			this._enemySide.Period = this.PeriodRate;
			this._armySide.Period = this.PeriodRate;
			this._stepsCtrl.Period = this.PeriodRate;
		}
		
		public function SwitchPlay(isPlay:Boolean):void 
		{
			if (this._isPlaying == isPlay) return;
			//trace("切換暫停開始isPlay", isPlay);
			this._isPlaying = isPlay;
			if (isPlay) {
				this.rebackMemory();
			}
			
		}
		
		//停只LOADING運行,並且初始化面運作
		public function ToStart(explorerNotify:String):void 
		{
			this._explorerNotify = explorerNotify;
			this._effectZone.RemoveLoading();
			this._armySide.SetFighters(this._doc.Army, this._proxyMonster);
			this._enemySide.SetFighters(this._doc.Enemy, this._proxyMonster);
			this._iconZone.InDicFightBase(this._stepsCtrl.DicFighterBase);
			this._effectZone.ShowBanner(0);
			this._isReady = true;
			//var bm:Bitmap;
			//var pp:Point = ProjectOLFacade.GetFacadeOL().GetStageInfo();
			//for (var i:int = 5; i < 10; i++) 
			//{
				//bm = this._bloodZone.GetBloodImage(100*i);
				//this._viewConterBox.addChild(bm);
				//bm.x = 100*(i-5)+100;
				//bm.y = 100 * (i-5) + 100;
			//}
			//bm = this._bloodZone.GetBloodImage(100);
			//this._viewConterBox.addChild(bm);
			//bm.x = 100;
			//bm.y = 100;
		}
		
		public function InDocumentary(data:BattleManager,proxyMonster:CombatMonsterDisplayProxy):void
		{
			this._doc = data;
			data.NotifyPlaceHub = this.ProcessingHub;
			this._proxyMonster = proxyMonster;
			
			this._stepsCtrl = new BattleStepsCtrl();
			this._stepsCtrl.NotifyPlaceHub = this.ProcessingHub;
			this._stepsCtrl.Period = this.PeriodRate;
			this._stepsCtrl.InitFighters(proxyMonster, data.Army, data.Enemy, this.ProcessingHub);
			
			this._infoTranslator.InMonster(this._stepsCtrl.DicFighterBase);
		}
		
		public function InSkill(skillProxy:Object):void 
		{
			this._effectZone.InSkill(skillProxy);
			this._iconZone.InSkill(skillProxy);
			this._stepsCtrl.InSkill(skillProxy);
			this._infoTranslator.InSkill(skillProxy);
		}
		
		public function InFightArea(aryShowLayer:Array):void
		{
			this._enemySide = aryShowLayer[0];
			this._enemySide.IsRightSide = true;//************notice site
			this._enemySide.Period = this.PeriodRate;
			this._armySide = aryShowLayer[1];
			this._armySide.Period = this.PeriodRate;
			this._armySide.IsRightSide = false;//************notice site
			this._effectZone = aryShowLayer[2];
			this._effectZone.NotifyPlaceHub = this.ProcessingHub;
			//this._iconZone = aryShowLayer[3];
			this._bloodZone = aryShowLayer[3];
			this._bloodZone.NotifyPlaceHub = this.ProcessingHub;
			this._viewConterBox.addChild(this._armySide);
			this._viewConterBox.addChild(this._enemySide);
			this._armySide.x = 175;//座標各增加150/2 (scale version)
			this._enemySide.x = 675;
			this._armySide.y = this._enemySide.y = 275;
			this._viewConterBox.addChild(this._effectZone);
			this._viewConterBox.addChild(this._bloodZone);
			
			
		}
		
		//主要針對播放控制的按鈕處理
		private function mouseEventProcess(e:MouseEvent):void
		{
			//trace("點擊>>", e.target.name	, e.currentTarget.name	);
			var key:String = e.target.name	;
			switch (key) 
			{
				case "play":
					if (this._isReady) {
						this.OverRun(false);
						this.SwitchPlay(true);
						this._bgLayer.ChooseButton(e.target);
					}
				break;
				case "pause":
					this.SwitchPlay(false);
					this._bgLayer.ChooseButton(e.target);
				break;
				case "faster":
					if (this._isReady) {
						this.OverRun(true);
						this.SwitchPlay(true);
						this._bgLayer.ChooseButton(e.target);
					}
				break;
				case "leave":
					//Exit process
					this.leaveBattlefield();
				break;
			}
			
			
		}
		
		private function leaveBattlefield():void 
		{
			//if (!this._goExit) {
				//this._bgLayer.DeLeaveShine();//點擊後清除閃爍的按鈕
				//this._goExit = true;
				//this._bgLayer.BackGroundMoving(false);
				//this._viewConterBox.removeEventListener(MouseEvent.CLICK, this.mouseEventProcess);
				//}
				this.ShutDownImmediately();
		}
		
		//20130619		立即關閉戰場UI使用 need 1.5 second to buffer all of the delayer.
		public function ShutDownImmediately():void 
		{
			if (!this._goExit) {
				this._bgLayer.DeLeaveShine();//點擊後清除閃爍的按鈕
				this._goExit = true;
				this._viewConterBox.removeEventListener(MouseEvent.CLICK, this.mouseEventProcess);
				this.mouseMovingAction(false);
				this._explorerNotify = "";
				//this._shutDownID = setTimeout(this.Destroy, 1500);
				this.DestroyImmediately();
			}
		}
		
		//暫停狀態下的資料流暫存相關處理
		private function setPauseMemory(status:String,info:Object,sendOut:Boolean=false):void
		{
			this._vecMemory[this._vecMemory.length] = new MemoryClip(status, info, sendOut);
		}
		private function rebackMemory():void 
		{
			var leng:int = this._vecMemory.length;
			var memory:MemoryClip;
			for (var i:int = 0; i < leng; i++)
			{
				memory = this._vecMemory[i];
				this.ProcessingHub(memory._status,memory._info,memory._sendOut);
			}
			this._vecMemory.length = 0;
		}
		
		//private var _testTime:uint;
		private function ProcessingHub(status:String,info:Object,sendOut:Boolean=false):void
		{
			//trace("檢測延遲時間>>", status, (getTimer() - _testTime) / 1000 + "/SEC");
			//trace("ReceiveProcessing >>>> ", status, info, sendOut , "階段數>>"+this._doc.Steps);
			
			if (!this._isPlaying && !this._goExit) {
				//trace(status, "<<<<<存的訊號");
				this.setPauseMemory(status, info, sendOut);
				return;
			}
			//trace("播放的訊號>>>>", status);
			if (sendOut) this.SendNotify(ArchivesStr.BATTLEIMAGING_BRIDGE, { _status:status, _info:info } );
			if (this._goExit && status != ArchivesStr.BATTLEIMAGING_VIEW_DESTROY) return;
			
			switch (status)
			{
				case ArchivesStr.BATTLEIMAGING_VIEW_FIGHT://開場導入動態完成>>可以開始處理戰鬥流程
					this._infoTranslator.ShowThis(0, "start");
					this._iconZone.AddSpiritualInfluence(this._doc.InfoData);//先導入初始靈氣效果ICON顯示與LOG
					this._doc.StartToFight();//VO流程起始運轉
					this._bgLayer.RoundChangeTo(this._bloodZone.GetBloodImage(this._doc.Round, false));//變更顯示回合數
					//this.SwitchPlay(false);
				break;
				
				case ArchivesStr.BATTLEIMAGING_VIEW_STEPS://BattleManager收到完成單位處理通知或初始戰鬥後發送回合資訊通知
					this._stepsCtrl.SettingSteps(info as BattlefieldSteps);//steps階段內容通知
					var steps:BattlefieldSteps = info as BattlefieldSteps;
					//130419 >> 調整 施放技能type為2 為目標可能有敵我雙方> 其中補血對象為施放者自身 則會移動 施放在原位的狀況 得掃內部Effect來判斷
					if (this._stepsCtrl.checkAttackMoving(steps)) steps._userSide ? this._armySide.MonsterMoving(steps._attacker) : this._enemySide.MonsterMoving(steps._attacker);
				break;
				
				case ArchivesStr.BATTLEIMAGING_VIEW_ROUNDS://BattleManager預計收到回合段落時發送通知
					this._stepsCtrl.SettingRounds(info as Array);//rounds階段內容通知
				break;
				
				case ArchivesStr.BATTLEIMAGING_VIEW_END ://BattleManager預計全場景觀賞結束
					this._infoTranslator.ShowThis(6, this._doc.InfoData._isWin);
					this._effectZone.ShowBanner(this._doc.InfoData._isWin ? 1 : 2);
					//通知關閉按鈕閃爍提醒
					this._bgLayer.ShineTheLeave(this._explorerNotify == "" ? false : true);
					if (this._explorerNotify != "") this.leaveBattlefield();//自動跳出 >> EXIT
					//trace("觀賞結束觀賞結束觀賞結束觀賞結束觀賞結束觀賞結束觀賞結束觀賞結束觀賞結束");
				break;
				
				case ArchivesStr.BATTLEIMAGING_VIEW_SHOWEFFECT://FighterBase內部順序通知播放受到攻擊的各種效果影響
					//{ _effect :  , _place :  , _isOurSide : , _funFin : , _valueBag :  , _isSpell :  }
					
					//130318新增打空氣的處理
					if (!info._airStrike) {//不是打空氣的狀態下再處理
						if(this._stepsCtrl.checkSpoutBlood(info)) this._bloodZone.SpoutBlood(info);//場景上加入血量增減圖示 //20130603 檢測若為效果或是BUFF技能則不做血量顯示(血量應當為0)
						this._iconZone.DefenderValueProcess(info);//場景上變更血條處理		//有串接 _infoTranslator .ShowThis(3, info);
					}else {//Kick Air
						//有佈置場景上面的怪物位置才有配置座標位置//打空氣的狀態下額外的作效果位置的產生
						info._isOurSide == true ? this._armySide.GetMonsterLocate(info._place) : this._enemySide.GetMonsterLocate(info._place);
					}
					
					this._effectZone.AddShowEffect(info);//場景上加入效果動態
					
					//this._infoTranslator.ShowThis(1,info);//訊息顯示窗
				break;
				
				case ArchivesStr.BATTLEIMAGING_VIEW_SHOWMISS://BattleStepsCtrl發送攻擊判斷MISS的單位
					//{ _aryMiss : [BattleEffect]  , _allMiss : Boolean }
					this._infoTranslator.ShowThis(7, info);
					this._bloodZone.SpoutMiss(info);//場景演出MISS圖示
				break;
				
				case ArchivesStr.BATTLEIMAGING_VIEW_DONEEFFECT://FighterBase各受到攻擊單位的全效果播放完成時單獨發送通知由BattleStepsCtrl 彙整
					this._stepsCtrl.CountEffectComplete();//當次全局效果播放單位完成通知計數
				break;
				
				case ArchivesStr.BATTLEIMAGING_VIEW_CHANGEEFFECT://FighterBase內部有效果狀態增減時發送通知
					// { _isAdd : isAdd , _aryDeEffect : aryDeEffect ,_place : this._place, _isOurSide : this._isOurSide , _isSpell}
					if (!info._isDead) { // 20130607 在FigherBase多傳一個是否陣亡的判斷值 避免陣亡之後 又顯示效果增減的LOG
						this._infoTranslator.ShowThis(5, info);
						this._iconZone.DefenderEffectProcess(info);//場景上效果狀態圖示新增移除通知
					}
				break;
				
				case ArchivesStr.BATTLEIMAGING_VIEW_STEPSFIN://BattleStepsCtrl完成此單位攻擊所有效果呈現後發送//若全部為MISS則會由BloodZone動態後發送通知
					if (!this._doc.IsEnd) {
						if (info) {//info會夾帶 isRound判斷 若為回合終止資料則變更回合數
							this._infoTranslator.ShowThis(1, this._doc.Round);
							this._bgLayer.RoundChangeTo(this._bloodZone.GetBloodImage(this._doc.Round, false));
						}
						this._doc.StepsFin();//下一步驟起始
					}else {
						//20130607在戰鬥結束時最後的RoundEnd = true 但同時造成結束原因是怪物死於EFFECT 調整為播放好最後效果才結束流程
						this.ProcessingHub(ArchivesStr.BATTLEIMAGING_VIEW_END,null);
					}
				break;
				
				case ArchivesStr.BATTLEIMAGING_VIEW_LOG:
					this._infoTranslator.ShowThis(info["_type"], info);
					//{ _type : 2 , _attackType : Boolean , _valueBag : BattlefieldSteps } BattleStepsCtrl 攻擊者訊息
					//{ _type : 3 , _combineKey : combineKey , _hp : btBasic._hp } IconZone send 實際血量變化訊息
				break;
				
				case ArchivesStr.BATTLEIMAGING_VIEW_OLDEAD://IconZone處理訊息顯示層的變化(血量變更)Send ,Info為位置加上isOurSide
					//後續會加入新的模式>>怪物生命值<0 死亡動態處理時 會有被動技能之類的處理 > 復活不死 或是血量變更為XXX 之類的操作
					if(this._explorerNotify!="") this.deadReportPackage(String(info));//探索搭配才要做怪物陣亡資料準備
					this._infoTranslator.ShowThis(4, info);
					this._stepsCtrl.MonsterDead(String(info));//怪物出場的動作處理
					String(info).length > 5 ? this._enemySide.MonsterDeadShow(String(info)) : this._armySide.MonsterDeadShow(String(info));//怪物出場的效果處理
					this._iconZone.DisableMonster(String(info));//怪物陣亡時連同訊息區塊也要消失
				break;
				
				case ArchivesStr.BATTLEIMAGING_VIEW_DESTROY://CarpetLayer完成出場動態會發送移除通知
					//多區塊也需要移除時機點須多個combo計數
					//UI做出場動作時若是探索場景則發送當前怪物陣亡資料先行做顯示移除處理
					this.SendNotify(this._explorerNotify, { _status : "LEAVING" , _content : this._objDeadReport } );//直接發送通知探索區塊處理
					/*
								_status : "LEAVING" , _content : {...}
								_status : "CLOSE"    , _content : null
								_status : "READY"    , _content : null
								會收到的三種可能性 
							 */
					//
					TweenLite.to(this._viewConterBox , .5 , { alpha : 0 , onComplete : this.Destroy} );//透明化後清空資源
				break;
			}
			
			//_testTime = getTimer();
		}
		
		//先清掉顯示看的到的區塊 (上下方UI關閉處理,完畢後會發送DESTROY通知);
		public function OutOfView():void
		{
			this._bgLayer.BackGroundMoving(false);
		}
		
		//包裝怪物陣亡單位資料索引為"left" / "right" 對應 陣型位置
		private function deadReportPackage(combineKey:String):void 
		{
			var place:String = combineKey.slice(0, 1);
			var index:String = combineKey.length > 5 ? "right" : "left";
			if (this._objDeadReport == null) {
				this._objDeadReport = { };
				this._objDeadReport[index] = [place];
			}else {
				if (this._objDeadReport[index] == null) {
					this._objDeadReport[index] = [place];
				}else {
					this._objDeadReport[index].push(place);
				}
			}
		}
		
		private function DestroyImmediately():void 
		{
			this._viewConterBox.parent.removeChild(this._viewConterBox);//母層中移除自用層
			this._shutDownID = setTimeout(this.Destroy, 3000, true);
		}
		
		//動態處理完成後對資料做清除動作
		private function Destroy(bufferImmediately=false):void
		{
			if (this._shutDownID != -1) clearTimeout(this._shutDownID);
			
			if (this._doc != null) {
				this._doc.Destroy();
				this._stepsCtrl.Destroy();
				this._doc = null;
				this._stepsCtrl = null;
			}
			if(!bufferImmediately) this._viewConterBox.parent.removeChild(this._viewConterBox);//母層中移除自用層
			
			this._viewConterBox.removeEventListener(MouseEvent.ROLL_OVER, this.runForTips, true);
			this._viewConterBox.removeEventListener(MouseEvent.ROLL_OUT, this.runForTips, true);
			
			this._armySide.Destroy();
			this._enemySide.Destroy();
			this._bloodZone.Destroy();
			this._iconZone.Destroy();
			this._effectZone.Destroy();//proxySkill在此清除
			this._bgLayer.Destroy();
			//this._proxyMonster.ClearAll();
			
			this._armySide = null;
			this._enemySide = null;
			this._bloodZone = null;
			this._iconZone = null;
			this._effectZone = null;
			this._bgLayer = null;
			this._proxyMonster = null;
			this._objDeadReport = null;
			
			while (this._viewConterBox.numChildren>0)
			{
				this._viewConterBox.removeChildAt(0);
			}
			this._viewConterBox = null;
			
			this.ProcessingHub(ArchivesStr.BATTLEIMAGING_VIEW_END,this._explorerNotify, true);//此次發送直接外發不經VIEW內部case
		}
		
		
		
	}
	
}


//作為暫停操作下的資料節點暫存
class MemoryClip
{
	public var _status:String;
	public var _info:Object;
	public var _sendOut:Boolean
	
	public function MemoryClip(status:String,info:Object,sendOut:Boolean):void 
	{
		this._status = status;
		this._info = info;
		this._sendOut = sendOut;
	}
	
}