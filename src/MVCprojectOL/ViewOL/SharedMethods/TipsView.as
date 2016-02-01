package MVCprojectOL.ViewOL.SharedMethods 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	//import MVCprojectOL.ModelOL.ShowSideSys.SendTips;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ViewOL.TipsView.TipsCenterView;
	import Spark.coreFrameWork.observer.Notify;
	import strLib.commandStr.PVECommands;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewStrLib;
	/**
	 * ...
	 * @author brook
	 */
	public class TipsView extends Notify 
	{
		private var _Name:String;
		public function TipsView(_NameStr:String) 
		{
			this._Name = _NameStr;
		}
		
		public function MouseEffect(btn:*):void
		{
			btn.addEventListener(MouseEvent.ROLL_OVER, MouseBtnEffect);
			btn.addEventListener(MouseEvent.ROLL_OUT, MouseBtnEffect);
			btn.addEventListener(MouseEvent.MOUSE_MOVE, MouseBtnEffect);
		}
		private function MouseBtnEffect(e:MouseEvent):void 
		{
			switch (e.type) 
			{
				case "rollOver":
					//trace(e.stageX,e.stageY, "@@@@");
					//trace(e.currentTarget.name,"@@@@");
					if (this._Name == "MonsterMenu") this.TipMonsterMenu(e.currentTarget as Sprite, e.stageX, e.stageY);
					if (this._Name == "MonsterInfo") this.TipMonsterInfo(e.currentTarget as Sprite, e.stageX, e.stageY);
					if (this._Name == "Building") this.TipBuilding(e.currentTarget as Sprite, e.stageX, e.stageY);
					if (this._Name == "Storage") this.TipStorage(e.currentTarget as Sprite, e.stageX, e.stageY);
					if (this._Name == "Library") this.TipLibrary(e.currentTarget as Sprite, e.stageX, e.stageY);
					if (this._Name == "MonsterPanel") this.TipMonsterPanel(e.currentTarget as Sprite, e.stageX, e.stageY);
					if (this._Name == "Alchemy") this.TipAlchemy(e.currentTarget as Sprite, e.stageX, e.stageY);
					if (this._Name == "Evolution") this.TipEvolution(e.currentTarget as Sprite, e.stageX, e.stageY);
					if (this._Name == "TaskList") this.TipTaskList(e.currentTarget as Sprite, e.stageX, e.stageY);
					if (this._Name == "PVP") this.TipPVP(e.currentTarget as Sprite, e.stageX, e.stageY);
					if (this._Name == "Auction") this.TipAuction(e.currentTarget, e.stageX, e.stageY);
				break;
				case "rollOut":
					TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();
				break;
				case "mouseMove":
					TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).TipsMove(e.stageX,e.stageY);
				break;
			}
		}
		public function RemoveMouseEffect(btn:*):void
		{
			btn.addEventListener(MouseEvent.ROLL_OVER, MouseBtnEffect);
			btn.addEventListener(MouseEvent.ROLL_OUT, MouseBtnEffect);
			btn.addEventListener(MouseEvent.MOUSE_MOVE, MouseBtnEffect);
		}
		
		private function TipMonsterMenu(_CurrentTarget:Sprite, _stageX:int, _stageY:int):void 
		{
			switch (_CurrentTarget.name) 
			{
				case "0":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_ABL_HP","",null,_stageX,_stageY));
				break;
				case "1":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_ABL_ATK","",null,_stageX,_stageY));
				break;
				case "2":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_ABL_DEF","",null,_stageX,_stageY));
				break;
				case "3":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_ABL_INT","",null,_stageX,_stageY));
				break;
				case "4":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_ABL_MND","",null,_stageX,_stageY));
				break;
				case "5":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_ABL_SPD","",null,_stageX,_stageY));
				break;
				
				case "JOB00002_ICO":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_JOB_KNIGHT","",null,_stageX,_stageY));
				break;
				case "JOB00001_ICO":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_JOB_WARRIOR","",null,_stageX,_stageY));
				break;
				case "JOB00004_ICO":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_JOB_PALADIN","",null,_stageX,_stageY));
				break;
				case "JOB00006_ICO":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_JOB_PRIEST","",null,_stageX,_stageY));
				break;
				case "JOB00005_ICO":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_JOB_WIZARD","",null,_stageX,_stageY));
				break;
			}
		}
		
		private function TipMonsterInfo(_CurrentTarget:Sprite, _stageX:int, _stageY:int):void 
		{
			switch (_CurrentTarget.name) 
			{
				case "0":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_ABL_ATK","",null,_stageX,_stageY));
				break;
				case "1":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_ABL_DEF","",null,_stageX,_stageY));
				break;
				case "2":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_ABL_INT","",null,_stageX,_stageY));
				break;
				case "3":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_ABL_MND","",null,_stageX,_stageY));
				break;
				case "4":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_ABL_SPD","",null,_stageX,_stageY));
				break;
				
				case "Attack_mc":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_SKILL_ATK","",null,_stageX,_stageY));
				break;
				case "Gain_mc":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_SKILL_MAGICATK","",null,_stageX,_stageY));
				break;
				case "Debuff_mc":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_SKILL_DEBUFF","",null,_stageX,_stageY));
				break;
				case "Recovery_mc":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_SKILL_BUFF","",null,_stageX,_stageY));
				break;
				
				case "Value0":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_ABL_HP","",null,_stageX,_stageY));
				break;
				case "Value1":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_ABL_ENG","",null,_stageX,_stageY));
				break;
				case "Value2":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_ABL_EXP","",null,_stageX,_stageY));
				break;
				
				case "JOB00002_ICO":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_JOB_KNIGHT","",null,_stageX,_stageY));
				break;
				case "JOB00001_ICO":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_JOB_WARRIOR","",null,_stageX,_stageY));
				break;
				case "JOB00004_ICO":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_JOB_PALADIN","",null,_stageX,_stageY));
				break;
				case "JOB00006_ICO":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_JOB_PRIEST","",null,_stageX,_stageY));
				break;
				case "JOB00005_ICO":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_JOB_WIZARD","",null,_stageX,_stageY));
				break;
			}
		}
		
		private function TipBuilding(_CurrentTarget:Sprite, _stageX:int, _stageY:int):void 
		{
			switch (_CurrentTarget.name) 
			{
				/*case "BuildingBox1":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"BUILDUPSYS_TIP_BLD00001","",null,_stageX,_stageY));
				break;*/
				case "BuildingBox2":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"BUILDUPSYS_TIP_BLD00002","",null,_stageX,_stageY));
				break;
				case "BuildingBox3":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"BUILDUPSYS_TIP_BLD00003","",null,_stageX,_stageY));
				break;
				case "BuildingBox4":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"BUILDUPSYS_TIP_BLD00004","",null,_stageX,_stageY));
				break;
				case "BuildingBox5":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"BUILDUPSYS_TIP_BLD00005","",null,_stageX,_stageY));
				break;
				case "BuildingBox6":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"BUILDUPSYS_TIP_BLD00006","",null,_stageX,_stageY));
				break;
				//case "BuildingBox7":
					//this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"_attack","",null,_stageX,_stageY));
				//break;
				//case "BuildingBox8":
					//this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"_attack","",null,_stageX,_stageY));
				//break;
				/*case "BuildingBox9":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"BUILDUPSYS_TIP_BLD00009","",null,_stageX,_stageY));
				break;*/
				case "BuildingBox10":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"BUILDUPSYS_TIP_BLD00010","",null,_stageX,_stageY));
				break;
				case "WoodBox":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"BUILDUPSYS_TIP_NEED_WOOD","",null,_stageX,_stageY));
				break;
				case "OreBox":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"BUILDUPSYS_TIP_NEED_STONE","",null,_stageX,_stageY));
				break;
				case "FurBox":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"BUILDUPSYS_TIP_NEED_MOPI","",null,_stageX,_stageY));
				break;
				case "FatigueBox":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"BUILDUPSYS_TIP_NEED_MONEY","",null,_stageX,_stageY));
				break;
				case "HourglassBox":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"BUILDUPSYS_TIP_NEED_TIME","",null,_stageX,_stageY));
				break;
				case "NoCheck":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"BUILDUPSYS_TIP_OK_NO","",null,_stageX,_stageY));
				break;
			}
		}
		
		private function TipStorage(_CurrentTarget:Sprite, _stageX:int, _stageY:int):void 
		{
			switch (_CurrentTarget.name) 
			{
				case PlaySystemStrLab.Package_Stone:
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Storage",ProxyPVEStrList.TIP_STRBASIC,"PACKAGE_TIP_TAB01","",null,_stageX,_stageY));
				break;
				case PlaySystemStrLab.Package_Weapon:
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Storage",ProxyPVEStrList.TIP_STRBASIC,"PACKAGE_TIP_TAB02","",null,_stageX,_stageY));
				break;
				case PlaySystemStrLab.Package_Shield:
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Storage",ProxyPVEStrList.TIP_STRBASIC,"PACKAGE_TIP_TAB03","",null,_stageX,_stageY));
				break;
				case PlaySystemStrLab.Package_Accessories:
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Storage",ProxyPVEStrList.TIP_STRBASIC,"PACKAGE_TIP_TAB04","",null,_stageX,_stageY));
				break;
				case PlaySystemStrLab.Package_Source:
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Storage",ProxyPVEStrList.TIP_STRBASIC,"PACKAGE_TIP_TAB05","",null,_stageX,_stageY));
				break;
				case "ExplainBtn":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterPanel",ProxyPVEStrList.TIP_STRBASIC,"GLOBAL_TIP_SYS_HELP","",null,_stageX,_stageY));
				break;
				case "CloseBtn":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterPanel",ProxyPVEStrList.TIP_STRBASIC,"GLOBAL_TIP_SYS_CLOSE","",null,_stageX,_stageY));
				break;
				case "btn0":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterPanel",ProxyPVEStrList.TIP_STRBASIC,"GLOBAL_TIP_SYS_PREVIOUS","",null,_stageX,_stageY));
				break;
				case "btn1":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterPanel",ProxyPVEStrList.TIP_STRBASIC,"GLOBAL_TIP_SYS_NEXT","",null,_stageX,_stageY));
				break;
				case "PageSP":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterPanel",ProxyPVEStrList.TIP_STRBASIC,"GLOBAL_TIP_SYS_NOWPAGE","",null,_stageX,_stageY));
				break;
			}
		}
		
		private function TipLibrary(_CurrentTarget:Sprite, _stageX:int, _stageY:int):void 
		{
			switch (_CurrentTarget.name) 
			{
				case "0":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Library",ProxyPVEStrList.TIP_STRBASIC,"LIB_TIP_TAB01","",null,_stageX,_stageY));
				break;
				case "1":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Library",ProxyPVEStrList.TIP_STRBASIC,"LIB_TIP_TAB02","",null,_stageX,_stageY));
				break;
				case "2":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Library",ProxyPVEStrList.TIP_STRBASIC,"LIB_TIP_TAB03","",null,_stageX,_stageY));
				break;
				case "3":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Library",ProxyPVEStrList.TIP_STRBASIC,"LIB_TIP_TAB04","",null,_stageX,_stageY));
				break;
				case "CheckBtn":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Library",ProxyPVEStrList.TIP_STRBASIC,"LIB_TIP_OK","",null,_stageX,_stageY));
				break;
			}
		}
		
		private function TipMonsterPanel(_CurrentTarget:Sprite, _stageX:int, _stageY:int):void 
		{
			switch (_CurrentTarget.name) 
			{
				case "ExplainBtn":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterPanel",ProxyPVEStrList.TIP_STRBASIC,"GLOBAL_TIP_SYS_HELP","",null,_stageX,_stageY));
				break;
				case "CloseBtn":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterPanel",ProxyPVEStrList.TIP_STRBASIC,"GLOBAL_TIP_SYS_CLOSE","",null,_stageX,_stageY));
				break;
				case "btn0":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterPanel",ProxyPVEStrList.TIP_STRBASIC,"GLOBAL_TIP_SYS_PREVIOUS","",null,_stageX,_stageY));
				break;
				case "btn1":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterPanel",ProxyPVEStrList.TIP_STRBASIC,"GLOBAL_TIP_SYS_NEXT","",null,_stageX,_stageY));
				break;
				case "PageSP":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterPanel",ProxyPVEStrList.TIP_STRBASIC,"GLOBAL_TIP_SYS_NOWPAGE","",null,_stageX,_stageY));
				break;
			}
		}
		
		private function TipAlchemy(_CurrentTarget:Sprite, _stageX:int, _stageY:int):void 
		{
			switch (_CurrentTarget.name) 
			{
				case "wep":
				case "0":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Alchemy",ProxyPVEStrList.TIP_STRBASIC,"DISSOLVE_TIP_TAB01","",null,_stageX,_stageY));
				break;
				case "Shield":
				case "1":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Alchemy",ProxyPVEStrList.TIP_STRBASIC,"DISSOLVE_TIP_TAB02","",null,_stageX,_stageY));
				break;
				case "Accessories":
				case "2":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Alchemy",ProxyPVEStrList.TIP_STRBASIC,"DISSOLVE_TIP_TAB03","",null,_stageX,_stageY));
				break;
				case "Basic":
				case "3":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Alchemy",ProxyPVEStrList.TIP_STRBASIC,"DISSOLVE_TIP_TAB04","",null,_stageX,_stageY));
				break;
				case "ExplainBtn":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterPanel",ProxyPVEStrList.TIP_STRBASIC,"GLOBAL_TIP_SYS_HELP","",null,_stageX,_stageY));
				break;
				case "CloseBtn":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterPanel",ProxyPVEStrList.TIP_STRBASIC,"GLOBAL_TIP_SYS_CLOSE","",null,_stageX,_stageY));
				break;
				case "btn0":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterPanel",ProxyPVEStrList.TIP_STRBASIC,"GLOBAL_TIP_SYS_PREVIOUS","",null,_stageX,_stageY));
				break;
				case "btn1":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterPanel",ProxyPVEStrList.TIP_STRBASIC,"GLOBAL_TIP_SYS_NEXT","",null,_stageX,_stageY));
				break;
				case "PageSP":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterPanel",ProxyPVEStrList.TIP_STRBASIC,"GLOBAL_TIP_SYS_NOWPAGE","",null,_stageX,_stageY));
				break;
			}
		}
		
		private function TipEvolution(_CurrentTarget:Sprite, _stageX:int, _stageY:int):void 
		{
			switch (_CurrentTarget.name) 
			{
				case "0":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_ABL_HP","",null,_stageX,_stageY));
				break;
				case "1":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_ABL_ATK","",null,_stageX,_stageY));
				break;
				case "2":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_ABL_DEF","",null,_stageX,_stageY));
				break;
				case "3":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_ABL_INT","",null,_stageX,_stageY));
				break;
				case "4":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_ABL_MND","",null,_stageX,_stageY));
				break;
				case "5":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MONSTERS_TIP_ABL_SPD","",null,_stageX,_stageY));
				break;
				case "PropertyBox":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"EVO_TIP_NEEDLEVEL","",null,_stageX,_stageY));
				break;
				case "FatigueBox":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"EVO_TIP_NEEDMONEY","",null,_stageX,_stageY));
				break;
			}
		}
		
		private function TipTaskList(_CurrentTarget:Sprite, _stageX:int, _stageY:int):void 
		{
			switch (_CurrentTarget.name) 
			{
				case "NoReceive":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MIS_TIP_GO_NO","",null,_stageX,_stageY));
				break;
				case "Receive":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"MIS_TIP_GO","",null,_stageX,_stageY));
				break;
			}
		}
		
		private function TipPVP(_CurrentTarget:Sprite, _stageX:int, _stageY:int):void 
		{
			var _Num:int = int(String(_CurrentTarget.name).substr(0, 2));
			if (int(String(_CurrentTarget.name)) == 0 || _Num != 0) { 
				this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"PVP_TIP_PLAYER_LIST","",null,_stageX,_stageY));
			}
			switch (_CurrentTarget.name) 
			{
				case "Shop":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"PVP_TIP_STORE","",null,_stageX,_stageY));
				break;
				case "Reward":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"PVP_TIP_DAILY_GIFT","",null,_stageX,_stageY));
				break;
				case "Team":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"PVP_TIP_EDITGROUP","",null,_stageX,_stageY));
				break;
				case "Challenge":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"PVP_TIP_GO","",null,_stageX,_stageY));
				break;
				case "FrequencyBox":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"PVP_TIP_PVPTIMES","",null,_stageX,_stageY));
				break;
				case "MyTeam":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"PVP_TIP_YOUR_GROUP","",null,_stageX,_stageY));
				break;
				case "EnemyTeam":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"PVP_TIP_PLAYER_GROUP","",null,_stageX,_stageY));
				break;
				case "CoolingBox":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"PVP_TIP_FIGHT_CD","",null,_stageX,_stageY));
				break;
			}
		}
		
		private function TipAuction(_CurrentTarget:*, _stageX:int, _stageY:int):void 
		{
			switch (_CurrentTarget.name) 
			{
				case "level":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SORTTAB01","",null,_stageX,_stageY));
				break;
				case "health":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SORTTAB02","",null,_stageX,_stageY));
				break;
				case "attack":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SORTTAB03","",null,_stageX,_stageY));
				break;
				case "defence":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SORTTAB04","",null,_stageX,_stageY));
				break;
				case "speed":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SORTTAB07","",null,_stageX,_stageY));
				break;
				case "intelligence":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SORTTAB05","",null,_stageX,_stageY));
				break;
				case "spirit":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SORTTAB06","",null,_stageX,_stageY));
				break;
				case "money":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SORTTAB08","",null,_stageX,_stageY));
				break;
				case "Magic":
				case "Tab0":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_TAB01","",null,_stageX,_stageY));
				break;
				case "Weapon":
				case "Tab1":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_TAB02","",null,_stageX,_stageY));
				break;
				case "Armor":
				case "Tab2":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_TAB03","",null,_stageX,_stageY));
				break;
				case "Accessories":
				case "Tab3":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_TAB04","",null,_stageX,_stageY));
				break;
				case "Monster":
				case "Tab4":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_TAB05","",null,_stageX,_stageY));
				break;
				case "Search":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SEARCH","",null,_stageX,_stageY));
				break;
				case "Sell":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SELL","",null,_stageX,_stageY));
				break;
				case "BuySell":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_BUY","",null,_stageX,_stageY));
				break;
				case "NoBuy":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_BUY_GO_NO","",null,_stageX,_stageY));
				break;
				case "Buy":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_BUY_GO","",null,_stageX,_stageY));
				break;
				case "Storage":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_OPEN_BAG","",null,_stageX,_stageY));
				break;
				case "NoCheck":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SELL_GO_NO","",null,_stageX,_stageY));
				break;
				case "PriceCheck":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SELL_GO","",null,_stageX,_stageY));
				break;
				case "TextInput0":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SEARCH_NAME","",null,_stageX,_stageY));
				break;
				case "TextInput1":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SEARCH_MONEYLIMEIT","",null,_stageX,_stageY));
				break;
				case "PropertyTextInput0":
				case "PropertyTextInput1":
					var _PropertyField:Sprite = _CurrentTarget.parent as Sprite;
					if (_PropertyField.name == "PropertyField6") this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SEARCH_LEVEL","",null,_stageX,_stageY));
					if (_PropertyField.name == "PropertyField0") this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SEARCH_LIFE","",null,_stageX,_stageY));
					if (_PropertyField.name == "PropertyField1") this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SEARCH_ATK","",null,_stageX,_stageY));
					if (_PropertyField.name == "PropertyField2") this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SEARCH_DEF","",null,_stageX,_stageY));
					if (_PropertyField.name == "PropertyField3") this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SEARCH_SPD","",null,_stageX,_stageY));
					if (_PropertyField.name == "PropertyField4") this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SEARCH_INT","",null,_stageX,_stageY));
					if (_PropertyField.name == "PropertyField5") this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SEARCH_MND","",null,_stageX,_stageY));
				break;
				case "PriceTextInput":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SELL_MONEY","",null,_stageX,_stageY));
				break;
				case "BoxSellBox":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SELL_THING","",null,_stageX,_stageY));
				break;
				case "QualityM":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SEARCH_QULITY_MOB","",null,_stageX,_stageY));
				break;
				case "QualityS":
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"SHOP_TIP_SEARCH_QULITY","",null,_stageX,_stageY));
				break;
			}
		}
		
	}
}