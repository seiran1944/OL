package MVCprojectOL.ViewOL.BuildingUpgradeView 
{
	import com.greensock.easing.Elastic;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import MVCprojectOL.ModelOL.TipsCenter.DisplayobjLab.SingleTimerBar;
	import MVCprojectOL.ModelOL.Vo.Building;
	import MVCprojectOL.ViewOL.MainView.MianViewCenter;
	import MVCprojectOL.ViewOL.MallBtn.MallBtn;
	import MVCprojectOL.ViewOL.SharedMethods.AskPanel;
	import MVCprojectOL.ViewOL.SharedMethods.BasisPanel;
	import MVCprojectOL.ViewOL.SharedMethods.SlidingControl;
	import MVCprojectOL.ViewOL.SharedMethods.SplitPageMethod;
	import Spark.coreFrameWork.View.ViewCtrl;
	import Spark.Utils.Text;
	import strLib.commandStr.UICmdStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.vewStr.ViewStrLib;
	/**
	 * ...
	 * @author brook
	 */
	public class BuildingUpViewCtrl extends ViewCtrl
	{
		private var _BGObj:Object;
		private var _BuildingObj:Object;
		private var _Panel:Sprite;
		private var _BasisPanel:BasisPanel
		private var _SlidingControl:SlidingControl;
		private var _PageList:Array;
		private var _CtrlPageNum:int = 0;
		private var _BuildingMenu:Vector.<Sprite>;
		private var _BuildingMenuP:BuildingMenu;
		private var _TimeLine:Object = [];
		private var _SplitPageMethod:SplitPageMethod = new SplitPageMethod();
		private var _AskPanel:AskPanel = new AskPanel();
		
		public function BuildingUpViewCtrl(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			super( _InputViewName , _InputConter );
		}
		
		public function AddElement(_InputObj:Object, _BuildingObj:Object):void
		{
			this._BGObj = _InputObj;
			this._BuildingObj = _BuildingObj;
			
			this._AskPanel.AddElement(this._viewConterBox, this._BGObj);
			
			var _AlphaBox:Sprite; 
			_AlphaBox = this.DrawRect(0, 0, 1000, 700);
			_AlphaBox.name = "AlphaBox";
			_AlphaBox.alpha = 0;
			this._viewConterBox.addChild(_AlphaBox );
			
			this._Panel = new Sprite();
			this._Panel.x = 373;
			this._Panel.y = 153;
			this._Panel.scaleX = 0.5;
			this._Panel.scaleY = 0.5;
			this._Panel.name = "Panel";
			this._viewConterBox.addChild(this._Panel);
			this._BasisPanel = new BasisPanel(this._BGObj, this._Panel);
			this._BasisPanel.AddBasisPanel("建築升級", 430, 510, 256);
			this._BasisPanel.AddPageBtn(195);
			
			this._SlidingControl = new SlidingControl( this._Panel );
				
			this.SendNotify(UICmdStrLib.BuildingData);
		}
		
		//建築升級面板
		public function GetBuildingData(_BuildingData:Array):void
		{
			this._SlidingControl.ClearStage();
			this._PageList = this._SplitPageMethod.SplitPage(_BuildingData, 3);
			
			this._PageList.length != 0?this.CtrlPage(this._CtrlPageNum, true):null;
		}
		//更新建築物資訊
		public function UpDataBuilding(_BuildingData:Array):void 
		{
			this._PageList = this._SplitPageMethod.SplitPage(_BuildingData, 3);
			var _MyPage:Array = this._PageList[this._CtrlPageNum];
			var _MyPageLength:uint = _MyPage.length;
			var _BuildingMenu:Sprite;
			var _CurrentBuilding:Object;
			for (var i:int = 0; i < _MyPageLength ; i++) 
			{
				_CurrentBuilding = _MyPage[i];
				_BuildingMenu = this._Panel.getChildByName(_CurrentBuilding._building._guid) as Sprite;
				if (_BuildingMenu.getChildByName(_CurrentBuilding._building._guid) != null) _BuildingMenu.removeChild(_BuildingMenu.getChildByName(_CurrentBuilding._building._guid));
				this._BuildingMenuP.BuildingMenuUpData(_CurrentBuilding._building, _BuildingMenu, _CurrentBuilding._upgradable );
			}
		}
		public function CtrlPage( _InputPage:int , _CtrlBoolean:Boolean ):void
		{
			this._CtrlPageNum = _InputPage;
			var _MyPage:Array = this._PageList[_InputPage];
			var _MyPageLength:uint = _MyPage.length;
			this._BuildingMenu = new Vector.<Sprite>;
			if (this._BuildingMenuP == null) this._BuildingMenuP = new BuildingMenu();
			
			for (var i:int = 0; i < _MyPageLength ; i++) 
			{
				this._BuildingMenu.push(this._BuildingMenuP.CreatBuildingMenu(this._BGObj, this._BuildingObj, _MyPage[i]));
			}
			
			this._SlidingControl._Cols = 1;
			this._SlidingControl._Rows = 3;
			this._SlidingControl._MaxContains = this._SlidingControl._Cols * this._SlidingControl._Rows;
			this._SlidingControl._HorizontalInterval = 0;
			this._SlidingControl._VerticalInterval = 140;
			this._SlidingControl._RightInPosX = 0;
			this._SlidingControl._LeftInPosX = 0;
			this._SlidingControl.NextPage(this._BuildingMenu , _CtrlBoolean);
			
			this._BasisPanel.PageData(this._PageList, this._CtrlPageNum);
			
			(this._TimeLine.length == 0)?this.CheckGetTimeLine():this.SetTimeBar();
		}
		//記錄升級
		public function RecordCheck(_Num:int, _BuildingName:String):void
		{
			if (_Num == 1) this._BuildingMenuP.RecordCheck(_BuildingName);
		}
		//
		private function AddDiamondBtn(_BuildingName:String):void 
		{
			var _BuildingMenu:Sprite = this._Panel.getChildByName(_BuildingName) as Sprite;
			//商城按鈕
			var _DiamondBtn:Sprite;
			var _Diamond:Bitmap;
			var _MallBtn:MallBtn = new MallBtn();
			
			_DiamondBtn = new Sprite();
			_Diamond = new Bitmap(BitmapData(new (this._BGObj.Diamond as Class)));
			_DiamondBtn.addChild(_Diamond);
			_DiamondBtn.x = 285;
			_DiamondBtn.y = 215;
			_DiamondBtn.scaleX = 0.6;
			_DiamondBtn.scaleY = 0.6;
			for (var j:String in this._TimeLine) 
			{
				if (this._TimeLine[j] != null && this._TimeLine[j]._target == _BuildingName) _DiamondBtn.name = "" + j;
			}
			_BuildingMenu.addChild(_DiamondBtn);
			_MallBtn.AddMallBtn(_DiamondBtn);
		}
		//完成排程更新
		public function UpData(_NewBuildingData:Building, _Num:int):void
		{
			var _PageList:Array;
			var _PageNum:int;
			var _BuildingMenu:Sprite = this._Panel.getChildByName(_NewBuildingData._guid) as Sprite;
			if (_NewBuildingData._type < 5) { 
				_PageList = this._PageList[0];
				_PageNum = 0;
			}
			if (_NewBuildingData._type > 4 && _NewBuildingData._type < 11) { 
				_PageList = this._PageList[1];
				_PageNum = 1;
			}
			/*if (_NewBuildingData._type > 6) { 
				_PageList = this._PageList[2];
				_PageNum = 2;
			}*/
			if (_PageNum == this._CtrlPageNum) {	
				SingleTimerBar(_BuildingMenu.getChildByName("Building" + _NewBuildingData._type)).Remove();
				_BuildingMenu.removeChild(_BuildingMenu.getChildByName("Building" + _NewBuildingData._type));
				this._BuildingMenuP.BuildingMenuUpData(_NewBuildingData, _BuildingMenu, _Num);
			}
			for (var i:int = 0; i < _PageList.length; i++) {
				if (_PageList[i]._building._guid == _NewBuildingData._guid) {
					_PageList[i]._building = _NewBuildingData;
					_PageList[i]._upgradable = _Num;
					this._BuildingMenuP.RecordCheck(_NewBuildingData._guid, true);
				}
			}
			for (var j:String in this._TimeLine) 
			{
				if (this._TimeLine[j] != null && this._TimeLine[j]._target == _NewBuildingData._guid ) this._TimeLine[j] = null;
				if (_BuildingMenu != null) if (_BuildingMenu.getChildByName("" +j ) != null) _BuildingMenu.removeChild(_BuildingMenu.getChildByName("" +j ));
			}
		}
		//取得排程
		public function AddTimeLine(_TimeLine:Array):void 
		{
			for (var i:int = 0; i < _TimeLine.length; i++) 
			{
				this._TimeLine[_TimeLine[i]._buildType] = _TimeLine[i];
			}
			this.SetTimeBar();
		}
		//設定排程時間
		private function SetTimeBar():void 
		{
			var _BuildingType:uint;
			for (var i:String in this._TimeLine) 
			{
				if (this._TimeLine[i] != null ) {_BuildingType = this._TimeLine[i]._buildType;
					switch ( this._CtrlPageNum ) {
						case 0:
							(_BuildingType < 5)?this.SendNotify(UICmdStrLib.SetTimeBar, this._TimeLine[i]):this.StopTimeBar(this._TimeLine[i]._target, this._TimeLine[i]._buildType);
						break;
						case 1:
							(_BuildingType > 4 && _BuildingType < 11)?this.SendNotify(UICmdStrLib.SetTimeBar, this._TimeLine[i]):this.StopTimeBar(this._TimeLine[i]._target, this._TimeLine[i]._buildType);
						break;
						case 2:
							//(_BuildingType > 6)?this.SendNotify(UICmdStrLib.SetTimeBar, this._TimeLine[i]):this.StopTimeBar(this._TimeLine[i]._target, this._TimeLine[i]._buildType);
						break;
					}
				}
			}
		}
		//加入排程時間
		public function AddTimeBar(_InputSpr:Sprite, _BuildingName:String, _BuildingType:uint):void
		{
			var _BuildingMenu:Sprite = this._Panel.getChildByName(_BuildingName) as Sprite;
			if (_BuildingMenu.getChildByName("Building" + _BuildingType) == null){
				_InputSpr.x = 90;
				_InputSpr.y = 210;
				_InputSpr.name = "Building" + _BuildingType;
				_BuildingMenu.addChild(_InputSpr );
				SingleTimerBar(_InputSpr).StarTimes();
				this.AddDiamondBtn(_BuildingName);
			}
		}
		//停止排程時間
		private function StopTimeBar(_BuildingName:String, _BuildingType:uint):void 
		{
			var _BuildingMenu:Sprite = this._Panel.getChildByName(_BuildingName) as Sprite;
			if (this._Panel.getChildByName(_BuildingName) != null) SingleTimerBar(_BuildingMenu.getChildByName("Building" + _BuildingType)).Close();
		}
		//
		private function CloseTimeBar():void 
		{
			var _BuildingType:uint;
			for (var i:String in this._TimeLine) 
			{
				if (this._TimeLine[i] != null ) {_BuildingType = this._TimeLine[i]._buildType;
					switch ( this._CtrlPageNum ) {
						case 0:
							if(_BuildingType < 5) this.StopTimeBar(this._TimeLine[i]._target, this._TimeLine[i]._buildType);
						break;
						case 1:
							if(_BuildingType > 4 && _BuildingType < 11) this.StopTimeBar(this._TimeLine[i]._target, this._TimeLine[i]._buildType);
						break;
						case 2:
							//if(_BuildingType > 6)this.StopTimeBar(this._TimeLine[i]._target, this._TimeLine[i]._buildType);
						break;
					}
				}
			}
		}
		//詢問有無排程
		public function CheckGetTimeLine():void
		{
			this.SendNotify(UICmdStrLib.GetTimeLine);
		}
		//
		public function AddInform():void 
		{
			this._AskPanel.AddInform();
		}
		//商城
		public function GetPay(_Price:uint):void 
		{
			this._AskPanel.AddMsgText(" 快速完成排程需要支付" + _Price + "晶鑽", 65);
			this._viewConterBox.addEventListener(MouseEvent.CLICK, PayClickHand);
		}
		private function PayClickHand(e:MouseEvent):void
		{
			switch(e.target.name)
			{
				case "Make0"://yes
					this.SendNotify(UICmdStrLib.Consumption);
					this.RemoveInform();
				break;
				case "Make1"://no
					TweenLite.to(this._viewConterBox.getChildByName("Inform"), 0.3, { x:393, y:255, scaleX:0.5, scaleY:0.5 , onComplete:RemoveInform } );
					this.SendNotify( UICmdStrLib.RecoverBtn );
				break;
			}
		}
		public function RemoveInform():void
		{
			this._viewConterBox.removeEventListener(MouseEvent.CLICK, PayClickHand);
			this._AskPanel.RemovePanel();
		}
		
		private function DrawRect(_LocationX:int, _LocationY:int, _Width:int, _Height:int):Sprite 
		{
			var _sp:Sprite = new Sprite ();
				_sp.graphics.beginFill(0x000000);
				_sp.graphics.drawRect(_LocationX,_LocationY,_Width,_Height);
			return _sp;
		}
		
		override public function onRemoved():void 
		{
			this.CloseTimeBar();
			this._viewConterBox.removeChild(this._viewConterBox.getChildByName("AlphaBox"));
			this._viewConterBox.removeChild(this._viewConterBox.getChildByName("Panel"));
			//this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
			//MianViewCenter(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER)).LockAndUnlock(true);
		}
		
	}
}