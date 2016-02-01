package MVCprojectOL.ViewOL.MonsterView 
{
	import com.greensock.easing.Elastic;
	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ViewOL.MainView.MianViewCenter;
	import MVCprojectOL.ViewOL.SharedMethods.AskPanel;
	//import MVCprojectOL.ModelOL.ShowSideSys.SendTips;
	import MVCprojectOL.ModelOL.SkillDisplayModel.SkillDisplay;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ViewOL.TipsView.TipsCenterView;
	import Spark.coreFrameWork.View.ViewCtrl;
	import Spark.Utils.Text;
	import strLib.commandStr.MonsterCageStrLib;
	import strLib.commandStr.PVECommands;
	import strLib.commandStr.UICmdStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewStrLib;
	/**
	 * ...
	 * @author brook
	 */
	public class MoonsterViewCtrl extends ViewCtrl
	{
		
		private var _BGObj:Object;
		private var _MonsterDisplay:Vector.<MonsterDisplay>;
		private var _CtrlPageNum:int = 0;
		private var _PageList:Array;
		
		private var _Weapon:ItemDisplay;
		private var _Armor:ItemDisplay;
		private var _Accessories:ItemDisplay;
		private var _Skill:Vector.<SkillDisplay> = new Vector.<SkillDisplay>;
		
		private var _AssemblyMonsterInfo:AssemblyMonsterInfo = new AssemblyMonsterInfo();
		private var _AskPanel:AskPanel = new AskPanel();
		private var _CurrentDiamond:String;
		
		public function MoonsterViewCtrl(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			super( _InputViewName , _InputConter );
		}
		
		public function AddElement(_GlobalObj:Object):void
		{
			this._BGObj = _GlobalObj;
			
			this._AskPanel.AddElement(this._viewConterBox, this._BGObj);
		}
		
		//惡魔
		public function MonsterElement(_InputMonsterDisplayList:Vector.<MonsterDisplay>):void
		{
			this._MonsterDisplay = _InputMonsterDisplayList;
			/*this._MonsterDisplay = new Vector.<MonsterDisplay>;
			for (var i:int = 0; i < _InputMonsterDisplayList.length; i++) {
				(_InputMonsterDisplayList[i].MonsterData._useing == 2 )?null:this._MonsterDisplay.push(_InputMonsterDisplayList[i]);
			}*/
			
			var _AddMonsterMenu:Object = new Object();
				_AddMonsterMenu["Monster"] = this._MonsterDisplay;
				_AddMonsterMenu["BGObj"] = this._BGObj;
			this.SendNotify( UICmdStrLib.AddMonsterMenu, _AddMonsterMenu);
		}
		
		//組裝惡魔資訊面板
		public function AssemblyMonsterInformation(_InputMD:MonsterDisplay):void
		{
			//for (var i:int = 0; i < this._MonsterDisplay.length; i++) this._MonsterDisplay[i].Alive = false;//停止惡魔動畫
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			for (var i:int = 0; i < 2; i++) 
			{
				if (Sprite(_Panel.getChildByName("MonsterInformation")) != null && Sprite(_Panel.getChildByName("MonsterInformation")).getChildByName("Skill" + i) != null) this.RemoveMouseEffect(Sprite(Sprite(_Panel.getChildByName("MonsterInformation")).getChildByName("Skill" + i)));
			}
			
			if (_InputMD == null) { 
				this.AddMonsterInformation(_InputMD);
			}else {
				var _Equ:Object = new Object();
					_Equ["Monster"] = _InputMD;
					if (_InputMD.MonsterData._Equ[0] != "")_Equ["Weapon"] = _InputMD.MonsterData._Equ[0];
					if (_InputMD.MonsterData._Equ[1] != "")_Equ["Armor"] = _InputMD.MonsterData._Equ[1];
					if (_InputMD.MonsterData._Equ[2] != "")_Equ["Accessories"] = _InputMD.MonsterData._Equ[2];
				this.SendNotify( MonsterCageStrLib.Equ, _Equ );
			}
		}
		public function AddMonsterInformation(_InputMD:MonsterDisplay, _InputWeapon:ItemDisplay = null, _InputArmor:ItemDisplay = null, _InputAccessories:ItemDisplay = null, _InputSkill:Vector.<SkillDisplay> = null):void
		{
			var _Panel:Sprite = Sprite(this._viewConterBox.getChildByName("Panel"));
			if (_Panel.getChildByName("MonsterInformation") != null)_Panel.removeChild(_Panel.getChildByName("MonsterInformation"));
			
			var _MonsterInformation:Sprite = this._AssemblyMonsterInfo.AddMonsterInfo(this._BGObj, _InputMD, _InputWeapon, _InputArmor, _InputAccessories, _InputSkill);
				_MonsterInformation.x = 525;
				_MonsterInformation.y = 130;
				//_MonsterInformation.alpha = 0;
				_MonsterInformation.name = "MonsterInformation";
				
			_Panel.addChild(_MonsterInformation);
			//TweenLite.to(_MonsterInformation, 1, { x:510, alpha:1 } );
			
			if (_MonsterInformation.getChildByName("Weapon") != null) this.AddMouseEffect(Sprite(_MonsterInformation.getChildByName("Weapon")));
			if (_MonsterInformation.getChildByName("Armor") != null) this.AddMouseEffect(Sprite(_MonsterInformation.getChildByName("Armor")));
			if (_MonsterInformation.getChildByName("Accessories") != null) this.AddMouseEffect(Sprite(_MonsterInformation.getChildByName("Accessories")));
			this._Weapon = _InputWeapon;
			this._Armor = _InputArmor;
			this._Accessories = _InputAccessories;
			
			if (_InputSkill != null) {
				for (var i:int = 0; i < _InputSkill.length; i++) 
				{
					if (_MonsterInformation.getChildByName("Skill" + i) != null) this.AddMouseEffect(Sprite(_MonsterInformation.getChildByName("Skill" + i)));
					this._Skill[i] = _InputSkill[i];
				}
			}
			
		}
		
		public function AddInform():void 
		{
			this._AskPanel.AddInform();
		}
		//商城
		public function GetPay(_Price:uint, _TypeName:String):void 
		{
			this._CurrentDiamond = _TypeName;
			var _Name:String;
			(_TypeName == "Skill")?_Name = "技能":(_TypeName == "hp")?_Name = "生命值":_Name = "精力值";
			var _Msg:String;
			(_TypeName == "Skill")?_Msg = " 更換" + _Name + "需要支付" + _Price + "晶鑽":_Msg = " 快速恢復" + _Name + "需要支付" + _Price + "晶鑽";
			this._AskPanel.AddMsgText(_Msg, 65);
			this._viewConterBox.addEventListener(MouseEvent.CLICK, PayClickHand);
			//if (_TypeName == "Skill") this._AssemblyMonsterInfo.RemoveSkill();
		}
		//商城是否加速
		private function PayClickHand(e:MouseEvent):void
		{
			var _Panel:Sprite = this._viewConterBox.getChildByName("Panel") as Sprite;
			var _MonsterInformation:Sprite = _Panel.getChildByName("MonsterInformation") as Sprite;
			switch(e.target.name)
			{
				case "Make0"://yes
					Sprite((_MonsterInformation.getChildByName(this._CurrentDiamond))).visible = false;
					var _CurrentObj:Object = { Diamond:this._CurrentDiamond };
					this.SendNotify(UICmdStrLib.Consumption, _CurrentObj);
					this.RemoveInform();
				break;
				case "Make1"://no
					TweenLite.to(this._viewConterBox.getChildByName("Inform"), 0.3, { x:393, y:255, scaleX:0.5, scaleY:0.5 , onComplete:RemoveInform } );
				break;
			}
		}
		public function RemoveInform():void
		{
			this._viewConterBox.removeEventListener(MouseEvent.CLICK, PayClickHand);
			this._AskPanel.RemovePanel();
		}
		
		/*public function UpdataMonster(_Value:int, _Type:int, MonsterGuid:String):void 
		{
			var _Panel:Sprite = this._viewConterBox.getChildByName("Panel") as Sprite;
			var _MonsterInformation:Sprite = _Panel.getChildByName("MonsterInformation") as Sprite;
			if (_Type == 2) _MonsterInformation.removeChild(_MonsterInformation.getChildByName("hp"));
			if (_Type == 3) _MonsterInformation.removeChild(_MonsterInformation.getChildByName("fatigue"));
			this._AssemblyMonsterInfo.UpdataMonster(_Value, _Type);
		}*/
		
		public function UpdataSkill(_Skill:SkillDisplay):void 
		{
			var _Panel:Sprite = this._viewConterBox.getChildByName("Panel") as Sprite;
			var _MonsterInformation:Sprite = _Panel.getChildByName("MonsterInformation") as Sprite;
			Sprite((_MonsterInformation.getChildByName(this._CurrentDiamond))).visible = true;
			this._AssemblyMonsterInfo.UpdataSkill(_Skill);
			this._Skill[1] = _Skill;
			this.AddMouseEffect(Sprite(_MonsterInformation.getChildByName("Skill1")));
		}
		
		private function AddMouseEffect(_Btn:Sprite):void 
		{
			_Btn.addEventListener(MouseEvent.ROLL_OVER, BtnHandler);
			_Btn.addEventListener(MouseEvent.ROLL_OUT, BtnHandler);
		}
		private function BtnHandler(e:MouseEvent):void 
		{
			switch (e.type) 
			{
				case "rollOver":
					if (e.currentTarget.name == "Weapon") this.Equipment(Sprite(e.currentTarget));
					if (e.currentTarget.name == "Armor") this.Equipment(Sprite(e.currentTarget));
					if (e.currentTarget.name == "Accessories") this.Equipment(Sprite(e.currentTarget));
					if (e.currentTarget.name == "Skill0") this.Skill(Sprite(e.currentTarget), 0);
					if (e.currentTarget.name == "Skill1") this.Skill(Sprite(e.currentTarget), 1);
				break;
				case "rollOut":
					TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();
				break;
			}
			
		}
		private function RemoveMouseEffect(_Btn:Sprite):void 
		{
			_Btn.removeEventListener(MouseEvent.ROLL_OVER, BtnHandler);
			_Btn.removeEventListener(MouseEvent.ROLL_OUT, BtnHandler);
		}
		
		private function Equipment(_CurrentTarget:Sprite):void 
		{
			if (_CurrentTarget.name == "Weapon") this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Monster", ProxyPVEStrList.TIP_STRBASIC, "SysTip_WPN", PlaySystemStrLab.Package_Weapon, { _guid:this._Weapon.ItemData._guid, _type:this._Weapon.ItemData._type, _group:this._Weapon.ItemData._groupGuid }, 548, 413 ));
			if (_CurrentTarget.name == "Armor") this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Monster", ProxyPVEStrList.TIP_STRBASIC, "SysTip_WPN", PlaySystemStrLab.Package_Weapon, { _guid:this._Armor.ItemData._guid, _type:this._Armor.ItemData._type, _group:this._Armor.ItemData._groupGuid }, 608, 413 ));
			if (_CurrentTarget.name == "Accessories") this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Monster", ProxyPVEStrList.TIP_STRBASIC, "SysTip_WPN", PlaySystemStrLab.Package_Weapon, { _guid:this._Accessories.ItemData._guid, _type:this._Accessories.ItemData._type, _group:this._Accessories.ItemData._groupGuid }, 668, 413 ));
		}
		private function Skill(_CurrentTarget:Sprite, _Num:int):void 
		{
			this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Monster", ProxyPVEStrList.TIP_STRBASIC, "SysTip_SKL", ProxyPVEStrList.LIBRARY_SKILLTips, this._Skill[_Num].Data._guid , 650 , (_Num == 0)?325:355 ));
		}
		
		override public function onRemoved():void 
		{
			//---2013/06/-12-死小孩要共用模組之前請先想清楚同樣的指令會不會用在流程上被送兩次的可能~冏
			//--你在Storage裡面用了這個模組~在Storage被移除的時候送了下面的指令~你移除這個模組的時候~又再度onRemoved又送一次相同的指令..
			//--欠打
			//this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
			//MianViewCenter(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER)).LockAndUnlock(true);
		}
		
	}
}