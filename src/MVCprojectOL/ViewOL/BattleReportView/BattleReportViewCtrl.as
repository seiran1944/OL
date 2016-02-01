package MVCprojectOL.ViewOL.BattleReportView 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleResult;
	import MVCprojectOL.ViewOL.PVPView.ReportPanel;
	import MVCprojectOL.ViewOL.SharedMethods.BasisPanel;
	import MVCprojectOL.ViewOL.SharedMethods.SharedEffect;
	import MVCprojectOL.ViewOL.SharedMethods.SlidingControl;
	import MVCprojectOL.ViewOL.SharedMethods.SplitPageMethod;
	import Spark.coreFrameWork.View.ViewCtrl;
	import strLib.commandStr.UICmdStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	/**
	 * ...
	 * @author brook
	 */
	public class BattleReportViewCtrl extends ViewCtrl
	{
		private var _SharedEffect:SharedEffect = new SharedEffect();
		private var _BGObj:Object;
		private var _Panel:Sprite;
		private var _BasisPanel:BasisPanel;
		private var _SlidingControl:SlidingControl;
		private var _SplitPageMethod:SplitPageMethod = new SplitPageMethod();
		private var _PageList:Array;
		private var _CtrlPageNum:int;
		private var _MyPage:Array;
		
		private var _ReportPanel:ReportPanel = new ReportPanel();
		private var _ReportBasisPanel:BasisPanel;
		private var _BattleId:String;
		
		public function BattleReportViewCtrl(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			super( _InputViewName , _InputConter );
			this._viewConterBox.addEventListener(MouseEvent.CLICK, playerClick);
		}
		
		public function AddElement(_InputObj:Object):void 
		{
			this._BGObj = _InputObj;
			
			var _AlphaBox:Sprite; 
				_AlphaBox = this._SharedEffect.DrawRect(0, 0, 1000, 700);
				_AlphaBox.name = "BattleReportBox";
				_AlphaBox.alpha = 0;
			this._viewConterBox.addChild(_AlphaBox );
			
			this._Panel = new Sprite();
			this._Panel.x = 373;
			this._Panel.y = 153;
			this._Panel.scaleX = 0.5;
			this._Panel.scaleY = 0.5;
			this._Panel.name = "BattleReportPanel";
			this._viewConterBox.addChild(this._Panel);
			this._BasisPanel = new BasisPanel(this._BGObj, this._Panel);
			this._BasisPanel.AddBasisPanel("出征報告", 430, 510, 256);
			this._BasisPanel.AddPageBtn(195);
			
			this._SlidingControl = new SlidingControl( this._Panel );
			
			for (var i:int = 0; i < 15 ; i++) 
			{
				var _ReportBg:Sprite = new (this._BGObj.ReportBg as Class);
					_ReportBg.width = 370;
					_ReportBg.x = 50;
					_ReportBg.y = 120 + i * 27;
				this._Panel.addChild(_ReportBg);
			}
		}
		
		public function AddData(_Data:Object):void 
		{
			this._SlidingControl.ClearStage();
			this._PageList = this._SplitPageMethod.SplitPage(_Data, 15);
			this._PageList.length != 0?this.CtrlPage(this._CtrlPageNum, true):null;
		}
		public function CtrlPage( _InputPage:int , _CtrlBoolean:Boolean ):void
		{
			this._CtrlPageNum = _InputPage;
			this._MyPage = this._PageList[_InputPage];
			var _MyPageLength:uint = this._MyPage.length;
			var _ReportList:Vector.<Sprite> = new Vector.<Sprite>;
			
			for (var i:int = 0; i < _MyPageLength ; i++) 
			{
				_ReportList.push(this.ListBoardMenu(this._MyPage[i]));
				this._SharedEffect.MouseEffect(_ReportList[i]);
				_ReportList[i].addEventListener(MouseEvent.CLICK, ListBoardClickHandler);
				_ReportList[i].name = "" + i;
				_ReportList[i].buttonMode = true;
			}
			
			this._SlidingControl._Cols = 1;
			this._SlidingControl._Rows = 15;
			this._SlidingControl._MaxContains = this._SlidingControl._Cols * this._SlidingControl._Rows;
			this._SlidingControl._HorizontalInterval = 0;
			this._SlidingControl._VerticalInterval = 27;
			this._SlidingControl._RightInPosX = 0;
			this._SlidingControl._LeftInPosX = 0;
			this._SlidingControl.NextPage(_ReportList);
			
			this._BasisPanel.PageData(this._PageList, this._CtrlPageNum);
		}
		
		//物件清單底板
		private function ListBoardMenu(_CurrentList:Object):Sprite
		{
			var _ListBoardMenu:Sprite = new Sprite();
			
			var _ReportBg:Sprite = new (this._BGObj.ReportBg as Class);
				_ReportBg.width = 370;
				_ReportBg.x = 50;
				_ReportBg.y = 120;
			_ListBoardMenu.addChild(_ReportBg);
			
			var _infoTitleText:TextField = new TextField();
				_infoTitleText.width = 250;
				_infoTitleText.height = 20;
				_infoTitleText.x = 5;
				_infoTitleText.y = 4;
				_infoTitleText.mouseEnabled = false;
				_infoTitleText.htmlText = _CurrentList._infoTitle;
			_ReportBg.addChild(_infoTitleText);
			
			var _dateTitleText:TextField = new TextField();
				_dateTitleText.width = 100;
				_dateTitleText.height = 20;
				_dateTitleText.x = 260;
				_dateTitleText.y = 4;
				_dateTitleText.mouseEnabled = false;
				_dateTitleText.htmlText = _CurrentList._dateTitle;
			_ReportBg.addChild(_dateTitleText);
			
			return _ListBoardMenu;
		}
		
		private function ListBoardClickHandler(e:MouseEvent):void
		{
			this.SendNotify(UICmdStrLib.GetBattleData, this._MyPage[int(e.currentTarget.name)]._battleId);
		}
		
		//戰報
		public function AddReport(_BattleResult:BattleResult):void 
		{
			var _AlphaBox:Sprite; 
				_AlphaBox = this._SharedEffect.DrawRect(0, 0, 1000, 700);
				_AlphaBox.name = "ReportAlphaBox";
				_AlphaBox.alpha = 0;
			this._viewConterBox.addChild(_AlphaBox );
			
			var _Panel:Sprite = new Sprite();
				_Panel.x = 373;//265 + 215-107;
				_Panel.y = 153;//25 + 255-127;
				_Panel.scaleX = 0.5;
				_Panel.scaleY = 0.5;
				_Panel.name = "ReportPanel";
			this._viewConterBox.addChild(_Panel);
			this._ReportBasisPanel = new BasisPanel(this._BGObj, _Panel, UICmdStrLib.onRemoveALL);
			this._ReportBasisPanel.AddBasisPanel("戰鬥報告", 430, 510, 256);
			this._ReportBasisPanel.AddCheckBtn("戰鬥回想", 200, 515 , 135, "Fight");
			this._ReportBasisPanel.AddCheckBtn("確認", 335, 515 , 85, "Confirm");
			this._ReportPanel.AddReportPanel(this._BGObj, _Panel, _BattleResult);
			
			this._BattleId = _BattleResult._battleId;
		}
		public function RemoveReport():void 
		{
			this._ReportBasisPanel = null;
			this._viewConterBox.removeChild(this._viewConterBox.getChildByName("ReportAlphaBox"));
			this._viewConterBox.removeChild(this._viewConterBox.getChildByName("ReportPanel"));
		}
		
		private function playerClick(e:MouseEvent):void 
		{
			switch(e.target.name)
			{
				case "Fight":
					this.SendNotify(UICmdStrLib.Recall, this._BattleId);
				break;
				case "Confirm":
					this.RemoveReport();
				break;	
			}
		}
		
		override public function onRemoved():void 
		{
			this._viewConterBox.removeEventListener(MouseEvent.CLICK, playerClick);
			this._viewConterBox.removeChild(this._viewConterBox.getChildByName("BattleReportBox"));
			this._viewConterBox.removeChild(this._Panel);
			//this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
		}
	}
}