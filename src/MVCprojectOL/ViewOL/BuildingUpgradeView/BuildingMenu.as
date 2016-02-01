package MVCprojectOL.ViewOL.BuildingUpgradeView 
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ModelOL.Vo.Building;
	import MVCprojectOL.ViewOL.SharedMethods.SharedEffect;
	import MVCprojectOL.ViewOL.SharedMethods.TimeConversion;
	import MVCprojectOL.ViewOL.SharedMethods.TipsView;
	import MVCprojectOL.ViewOL.TipsView.TipsCenterView;
	import Spark.coreFrameWork.observer.Notify;
	import Spark.Utils.Text;
	import strLib.commandStr.PVECommands;
	import strLib.commandStr.UICmdStrLib;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewStrLib;
	/**
	 * ...
	 * @author brook
	 */
	public class BuildingMenu extends Notify
	{
		private var _SharedEffect:SharedEffect = new SharedEffect();
		private var _BGObj:Object;
		private var _TimeConversion:TimeConversion = new TimeConversion();	
		private var _BuildingData:Object;
		private var _BuildingMenu:Sprite;
		private var _CtrlBoolean:Boolean;
		private var _CurrentBuildingName:Vector.<String> = new Vector.<String>;
		private var _TextObj:Object = { _str:"", _wid:40, _hei:20, _wap:false, _AutoSize:"CENTER", _col:0xFFFFFF, _Size:14, _bold:true, _font:"Times New Roman", _leading:null };
		private var _TipsView:TipsView = new TipsView("Building");//---tip---
		
		public function CreatBuildingMenu(_BGObj:Object, _BuildingObj:Object, _BuildingData:Object):Sprite
		{
			this._BGObj = _BGObj;
			this._BuildingData = _BuildingData;
			
			this._BuildingMenu = new Sprite();
			this._BuildingMenu.name = this._BuildingData._building._guid;
				
			var _BgL:Sprite = new (this._BGObj.BgL as Class);
				_BgL.width = 375;
				_BgL.height = 130;
				_BgL.x = 45;
				_BgL.y = 120;
			this._BuildingMenu.addChild(_BgL);
			
			var _OptionsBg:Sprite = new (this._BGObj.OptionsBg as Class);
				_OptionsBg.width = 230;
				_OptionsBg.height = 20;
				_OptionsBg.x = 180;
				_OptionsBg.y = 125;
			this._BuildingMenu.addChild(_OptionsBg);
			this._TextObj._str = "建築等級 Lv." + _BuildingData._building._lv;
			var _BuildingLVText:Text = new Text(this._TextObj);
				_BuildingLVText.x = 185;
				_BuildingLVText.y = 125;
				_BuildingLVText.name = "BuildingLVText";
			this._BuildingMenu.addChild(_BuildingLVText);
			this._TextObj._str = "等級限制 Lv." + _BuildingData._building._maxLv;
			var _BuildingMaxLVText:Text = new Text(this._TextObj);
				_BuildingMaxLVText.x = 300;
				_BuildingMaxLVText.y = 125;
			this._BuildingMenu.addChild(_BuildingMaxLVText);
			
			var _BgD:Sprite = new (this._BGObj.BgD as Class);
				_BgD.width = 125;
				_BgD.height = 120;
				_BgD.x = 50;
				_BgD.y = 125;
			this._BuildingMenu.addChild(_BgD);	
			
			var _Building:Bitmap;
			//if (_BuildingData._building._type == 1) _Building = new Bitmap(BitmapData(new(_BuildingObj.Main_5 as Class)));
			if (_BuildingData._building._type == 2) _Building = new Bitmap(BitmapData(new(_BuildingObj.Main_8 as Class)));
			if (_BuildingData._building._type == 3) _Building = new Bitmap(BitmapData(new(_BuildingObj.Main_4 as Class)));
			if (_BuildingData._building._type == 4) _Building = new Bitmap(BitmapData(new(_BuildingObj.Main_9 as Class)));
			if (_BuildingData._building._type == 5) _Building = new Bitmap(BitmapData(new(_BuildingObj.Main_7 as Class)));
			if (_BuildingData._building._type == 6) _Building = new Bitmap(BitmapData(new(_BuildingObj.Main_3 as Class)));
			//if (_BuildingData._building._type == 7) _Building = new Bitmap(BitmapData(new(_BuildingObj.Main_1 as Class)));
			//if (_BuildingData._building._type == 8) _Building = new Bitmap(BitmapData(new(_BuildingObj.Main_2 as Class)));
			//if (_BuildingData._building._type == 9) _Building = new Bitmap(BitmapData(new(_BuildingObj.Main_2 as Class)));
			if (_BuildingData._building._type == 10) _Building = new Bitmap(BitmapData(new(_BuildingObj.Main_6 as Class)));
			//if (_BuildingData._building._type == 11) _Building = new Bitmap(BitmapData(new(_BuildingObj.Main_1 as Class)));
				_Building.width = 120;
				_Building.height = 95;
				_Building.x = 52;
				_Building.y = 130;
			this._BuildingMenu.addChild(_Building);
			//---tip---
			var _BuildingBox:Sprite = this.DrawRect(0, 0, 120, 95);
				_BuildingBox.x = 52; 
				_BuildingBox.y = 130;
				_BuildingBox.alpha = 0;
				_BuildingBox.name = "BuildingBox" + _BuildingData._building._type;
			this._BuildingMenu.addChild(_BuildingBox);
			this._TipsView.MouseEffect(_BuildingBox);
			//---tip---
			var _BuildingName:Sprite = new (this._BGObj.OptionsBg as Class);
				_BuildingName.width = 125;
				_BuildingName.height = 20;
				_BuildingName.x = 50;
				_BuildingName.y = 225;
			this._BuildingMenu.addChild(_BuildingName);
			this._TextObj._str = _BuildingData._building._name;
			var _BuildingNameText:Text = new Text(this._TextObj);
				_BuildingNameText.x = 80;
				_BuildingNameText.y = 225;
			this._BuildingMenu.addChild(_BuildingNameText);
			
			var _Wood:Bitmap = new Bitmap(BitmapData(new(this._BGObj.Wood as Class)));
				_Wood.width = _Wood.height = 32;
				_Wood.x = 180;
				_Wood.y = 145;
			this._BuildingMenu.addChild(_Wood);
			this._TextObj._str = _BuildingData._building._wood + " ";
			var _WoodNum:Text= new Text(this._TextObj);
				_WoodNum.x = 210;
				_WoodNum.y = 150;
				_WoodNum.name = "WoodNum";
			this._BuildingMenu.addChild(_WoodNum);
			var _WoodBox:Sprite = this.DrawRect(0, 0, _Wood.width, _Wood.height);
				_WoodBox.x = _Wood.x; 
				_WoodBox.y = _Wood.y;
				_WoodBox.alpha = 0;
				_WoodBox.name = "WoodBox";
			this._BuildingMenu.addChild(_WoodBox);
			this._TipsView.MouseEffect(_WoodBox);
			
			var _Ore:Bitmap = new Bitmap(BitmapData(new(this._BGObj.Ore as Class)));
				_Ore.width = _Ore.height = 32;
				_Ore.x = 260;
				_Ore.y = 145;
			this._BuildingMenu.addChild(_Ore);
			this._TextObj._str = _BuildingData._building._stone + " ";
			var _OreNum:Text= new Text(this._TextObj);
				_OreNum.x = 290;
				_OreNum.y = 150;
				_OreNum.name = "OreNum";
			this._BuildingMenu.addChild(_OreNum);
			var _OreBox:Sprite = this.DrawRect(0, 0, _Ore.width, _Ore.height);
				_OreBox.x = _Ore.x; 
				_OreBox.y = _Ore.y;
				_OreBox.alpha = 0;
				_OreBox.name = "OreBox";
			this._BuildingMenu.addChild(_OreBox);
			this._TipsView.MouseEffect(_OreBox);
			
			var _Fur:Bitmap = new Bitmap(BitmapData(new(this._BGObj.Fur as Class)));
				_Fur.width = _Fur.height = 32;
				_Fur.x = 340;
				_Fur.y = 145;
			this._BuildingMenu.addChild(_Fur);
			this._TextObj._str = _BuildingData._building._fur + " ";
			var _FurNum:Text= new Text(this._TextObj);
				_FurNum.x = 370;
				_FurNum.y = 150;
				_FurNum.name = "FurNum";
			this._BuildingMenu.addChild(_FurNum);
			var _FurBox:Sprite = this.DrawRect(0, 0, _Fur.width, _Fur.height);
				_FurBox.x = _Fur.x; 
				_FurBox.y = _Fur.y;
				_FurBox.alpha = 0;
				_FurBox.name = "FurBox";
			this._BuildingMenu.addChild(_FurBox);
			this._TipsView.MouseEffect(_FurBox);
			
			var _Fatigue:Bitmap = new Bitmap(BitmapData(new(this._BGObj.Fatigue as Class)));
				_Fatigue.width = 28;
				_Fatigue.height = 33;
				_Fatigue.x = 180;
				_Fatigue.y = 185;
			this._BuildingMenu.addChild(_Fatigue);
			this._TextObj._str = _BuildingData._building._cost + " ";
			var _FatigueNum:Text= new Text(this._TextObj);
				_FatigueNum.x = 210;
				_FatigueNum.y = 190;
				_FatigueNum.name = "FatigueNum";
			this._BuildingMenu.addChild(_FatigueNum);
			var _FatigueBox:Sprite = this.DrawRect(0, 0, _Fatigue.width, _Fatigue.height);
				_FatigueBox.x = _Fatigue.x; 
				_FatigueBox.y = _Fatigue.y;
				_FatigueBox.alpha = 0;
				_FatigueBox.name = "FatigueBox";
			this._BuildingMenu.addChild(_FatigueBox);
			this._TipsView.MouseEffect(_FatigueBox);
			
			var _Hourglass:Bitmap = new Bitmap(BitmapData(new(this._BGObj.Hourglass as Class)));
				_Hourglass.width = 24;
				_Hourglass.height = 33;
				_Hourglass.x = 262;
				_Hourglass.y = 185;
			this._BuildingMenu.addChild(_Hourglass);
			this._TextObj._str = this._TimeConversion.TimerConversion(_BuildingData._building._needUpCD) + " ";
			var _HourNum:Text= new Text(this._TextObj);
				_HourNum.x = 292;
				_HourNum.y = 190;
				_HourNum.name = "HourNum";
			this._BuildingMenu.addChild(_HourNum);
			var _HourglassBox:Sprite = this.DrawRect(0, 0, _Hourglass.width, _Hourglass.height);
				_HourglassBox.x = _Hourglass.x; 
				_HourglassBox.y = _Hourglass.y;
				_HourglassBox.alpha = 0;
				_HourglassBox.name = "HourglassBox";
			this._BuildingMenu.addChild(_HourglassBox);
			this._TipsView.MouseEffect(_HourglassBox);
			
			this._TextObj._col = 0xFFFFFF;
			var _CheckBtn:Sprite = new (this._BGObj.CheckBtn as Class);
				_CheckBtn.width = 85;
				_CheckBtn.x = 330;
				_CheckBtn.y = 210;
				_CheckBtn.name = "NoCheck";
			this._BuildingMenu.addChild(_CheckBtn);
			this._TipsView.MouseEffect(_CheckBtn);
			TweenLite.to(_CheckBtn, .5, { colorMatrixFilter: { matrix : [0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0] }} );
			this._TextObj._str = "升級";
			var _CheckBtnText:Text = new Text(this._TextObj);
				_CheckBtnText.x = 47;
				_CheckBtnText.y = 10;
			_CheckBtn.addChild(_CheckBtnText);
			
			this._CtrlBoolean = true;
			for (var k:String in this._CurrentBuildingName) 
			{
				if (this._CurrentBuildingName[k] == this._BuildingData._building._guid) {
					this._CtrlBoolean = false;
				}
			}
			if (_BuildingData._upgradable == 1 && this._CtrlBoolean == true) this.AddCheckBtn(this._BuildingData._building._guid);
				
			return _BuildingMenu;
		}
		//
		private function AddCheckBtn(_Guid:String):void
		{
			this._TextObj._col = 0xFFFFFF;
			var _CheckBtn:MovieClip = new (this._BGObj.CheckBtn as Class);
				_CheckBtn.width = 85;
				_CheckBtn.x = 330;
				_CheckBtn.y = 210;
				_CheckBtn.name = _Guid;
				_CheckBtn.gotoAndStop(1);
				_CheckBtn.buttonMode = true;
			//this._SharedEffect.MovieClipMouseEffect(_CheckBtn);
			this.MouseEffect(_CheckBtn);
			this._BuildingMenu.addChild(_CheckBtn);
			this._TextObj._str = "升級";
			var _CheckBtnText:Text = new Text(this._TextObj);
				_CheckBtnText.x = 47;
				_CheckBtnText.y = 10;
				_CheckBtnText.name = _Guid;
			_CheckBtn.addChild(_CheckBtnText);
		}
		//
		public function RecordCheck(_BuildingName:String, _CtrlBoolean:Boolean = false):void
		{
			if (_CtrlBoolean == false) {
				this._CurrentBuildingName.push(_BuildingName);
			}else {
				for (var k:String in this._CurrentBuildingName) {
					if (this._CurrentBuildingName[k] == _BuildingName) this._CurrentBuildingName[k] = null;
				}
			}
		}
		//更新建築物資訊
		public function BuildingMenuUpData(_NewBuildingData:Building, _BuildingMenu:Sprite, _Num:int):void
		{
			this._BuildingMenu = _BuildingMenu;
			Text(_BuildingMenu.getChildByName("BuildingLVText")).ReSetString("建築等級 Lv." +String(_NewBuildingData._lv));
			Text(_BuildingMenu.getChildByName("WoodNum")).ReSetString(String(_NewBuildingData._wood) + " ");
			Text(_BuildingMenu.getChildByName("OreNum")).ReSetString(String(_NewBuildingData._stone) + " ");
			Text(_BuildingMenu.getChildByName("FurNum")).ReSetString(String(_NewBuildingData._fur) + " ");
			Text(_BuildingMenu.getChildByName("FatigueNum")).ReSetString(String(_NewBuildingData._cost) + " ");
			Text(_BuildingMenu.getChildByName("HourNum")).ReSetString(this._TimeConversion.TimerConversion(int(_NewBuildingData._needUpCD)) + " ");
			if (_Num == 1) this.AddCheckBtn(_NewBuildingData._guid);
		}
		
		//滑鼠效果
		private function MouseEffect(btn:*):void
		{
			btn.addEventListener(MouseEvent.CLICK, BtnEffect);
			btn.addEventListener(MouseEvent.ROLL_OVER, BtnEffect);
			btn.addEventListener(MouseEvent.ROLL_OUT, BtnEffect);
			btn.addEventListener(MouseEvent.MOUSE_MOVE, BtnEffect);
		}
		private function BtnEffect(e:MouseEvent):void 
		{
			switch (e.type) 
			{
				case "click":
					var _CheckUpgradable:Object = new Object();
						_CheckUpgradable["Guid"] = e.target.name;
					this.SendNotify(UICmdStrLib.CheckUpgradable, _CheckUpgradable);
				break;
				case "rollOver":
					MovieClip(e.target).gotoAndStop(2);
					this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("MonsterMenu",ProxyPVEStrList.TIP_STRBASIC,"BUILDUPSYS_TIP_OK","",null,e.stageX,e.stageX));
				break;
				case "rollOut":
					MovieClip(e.target).gotoAndStop(1);
					TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();
				break;
				case "mouseMove":
					TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).TipsMove(e.stageX,e.stageY);
				break;
			}
		}
		//移除滑入滑出效果
		private function RemoveMouseEffect(btn:*):void
		{
			btn.removeEventListener(MouseEvent.CLICK, BtnEffect);
			btn.removeEventListener(MouseEvent.ROLL_OVER, BtnEffect);
			btn.removeEventListener(MouseEvent.ROLL_OUT, BtnEffect);
			btn.removeEventListener(MouseEvent.MOUSE_MOVE, BtnEffect);
		}
		
		public function DrawRect(_LocationX:int, _LocationY:int, _Width:int, _Height:int):Sprite 
		{
			var _sp:Sprite = new Sprite ();
				_sp.graphics.beginFill(0xFFFFFF);
				_sp.graphics.drawRect(_LocationX,_LocationY,_Width,_Height);
			return _sp;
		}
		
	}
}