package MVCprojectOL.ViewOL.MailView 
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import MVCprojectOL.ControllOL.Mail.MailStrLib;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.Vo.MailVo.Mail;
	import MVCprojectOL.ViewOL.MainView.MianViewCenter;
	import MVCprojectOL.ViewOL.SharedMethods.AskPanel;
	import MVCprojectOL.ViewOL.SharedMethods.BasisPanel;
	import MVCprojectOL.ViewOL.SharedMethods.SharedEffect;
	import MVCprojectOL.ViewOL.SharedMethods.SlidingControl;
	import MVCprojectOL.ViewOL.SharedMethods.SplitPageMethod;
	import Spark.coreFrameWork.View.ViewCtrl;
	import Spark.Utils.Text;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.vewStr.ViewStrLib;
	/**
	 * ...
	 * @author brook
	 * @version 13.06.18.11.06
	 */
	public class MailViewCtrl extends ViewCtrl
	{
		private var _TextObj:Object = { _str:"", _wid:0, _hei:0, _wap:false, _AutoSize:"LEFT", _col:0xFFFFFF, _Size:14, _bold:true, _font:"Times New Roman", _leading:null };
		private var _SharedEffect:SharedEffect = new SharedEffect();
		private var _BGObj:Object;
		private var _MailAry:Object;
		private var _Panel:Sprite;
		private var _BasisPanel:BasisPanel;
		private var _SlidingControl:SlidingControl;
		private var _PageList:Array;
		private var _CtrlPageNum:int;
		private var _SplitPageMethod:SplitPageMethod = new SplitPageMethod();
		private var _MyPage:Array;
		private var _MailList:Vector.<Sprite>;
		private var _CurrentListBoard:Sprite;
		private var _AskPanel:AskPanel = new AskPanel();
		private var _CurrentList:Mail;
		
		
		public function MailViewCtrl(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			super( _InputViewName , _InputConter );
			this._viewConterBox.addEventListener(MouseEvent.CLICK, playerClick);
		}
		
		public function AddElement(_InputObj:Object,_MailAry:Object):void
		{
			this._BGObj = _InputObj;
			this._MailAry = _MailAry;
			
			this._AskPanel.AddElement(this._viewConterBox, this._BGObj);
			
			var _AlphaBox:Sprite; 
			_AlphaBox = this._SharedEffect.DrawRect(0, 0, 1000, 700);
			_AlphaBox.name = "MailBox";
			_AlphaBox.alpha = 0;
			this._viewConterBox.addChild(_AlphaBox );
			
			this._Panel = new Sprite();
			this._Panel.x = 373;
			this._Panel.y = 153;
			this._Panel.scaleX = 0.5;
			this._Panel.scaleY = 0.5;
			this._Panel.name = "MailPanel";
			this._viewConterBox.addChild(this._Panel);
			this._BasisPanel = new BasisPanel(this._BGObj, this._Panel);
			this._BasisPanel.AddBasisPanel("交易紀錄", 430, 510, 256);
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
			
			this.GetMailListData();
		}
		
		public function GetMailListData():void
		{
			this._SlidingControl.ClearStage();
			this._PageList = this._SplitPageMethod.SplitPage(this._MailAry, 15);
			this._PageList.length != 0?this.CtrlPage(this._CtrlPageNum, true):null;
		}
		public function CtrlPage( _InputPage:int , _CtrlBoolean:Boolean ):void
		{
			this._CtrlPageNum = _InputPage;
			this._MyPage = this._PageList[_InputPage];
			var _MyPageLength:uint = this._MyPage.length;
			this._MailList = new Vector.<Sprite>;
			
			for (var i:int = 0; i < _MyPageLength ; i++) 
			{
				this._MailList.push(this.ListBoardMenu(_MyPage[i]));
				this._SharedEffect.MouseEffect(this._MailList[i]);
				this._MailList[i].addEventListener(MouseEvent.CLICK, ListBoardClickHandler);
				this._MailList[i].name = "" + i;
				this._MailList[i].buttonMode = true;
			}
			
			this._SlidingControl._Cols = 1;
			this._SlidingControl._Rows = 15;
			this._SlidingControl._MaxContains = this._SlidingControl._Cols * this._SlidingControl._Rows;
			this._SlidingControl._HorizontalInterval = 0;
			this._SlidingControl._VerticalInterval = 27;
			this._SlidingControl._RightInPosX = 0;
			this._SlidingControl._LeftInPosX = 0;
			this._SlidingControl.NextPage(this._MailList);
			
			this._BasisPanel.PageData(this._PageList, this._CtrlPageNum);
		}
		
		//物件清單底板
		private function ListBoardMenu(_CurrentList:Mail = null):Sprite
		{
			var _ListBoardMenu:Sprite = new Sprite();
				//_ListBoardMenu.name = _CurrentList._guid;
			var _ReportBg:Sprite = new (this._BGObj.ReportBg as Class);
				_ReportBg.width = 370;
				_ReportBg.x = 50;
				_ReportBg.y = 120;
				_ReportBg.name = "ReportBg";
			_ListBoardMenu.addChild(_ReportBg);
			
			if (_CurrentList != null) {
				this._TextObj._wap = false;
				this._TextObj._col = 0xFFFFFF;
				this._TextObj._str = _CurrentList._date;
				var _TimeText:Text = new Text(this._TextObj);
					_TimeText.x = 260;
					_TimeText.y = 4;
				_ReportBg.addChild(_TimeText);
				
				this.AddText(_CurrentList._mailType,_ReportBg);
				
				this._TextObj._col = 0x999999;
				_CurrentList._title="測試測試"
				this._TextObj._str = _CurrentList._title;
				var _TitleText:Text = new Text(this._TextObj);
				_TitleText.x = 60;
				_TitleText.y = 4;
				_ReportBg.addChild(_TitleText);
				
				if (_CurrentList._isReceived == false) { 
					this._TextObj._str = "[ " + _CurrentList._content._showName + " ]";
					if (_CurrentList._content._type == 0) this._TextObj._col = 0xFFC600;
					if (_CurrentList._content._type == 1) this._TextObj._col = 0xFFFFFF;
					if (_CurrentList._content._type == 2) this._TextObj._col = 0xFFFFFF;
					if (_CurrentList._content._type == 3) this._TextObj._col = 0xFFFFFF;
					if (_CurrentList._content._type == 4) this._TextObj._col = 0xA5E51A;
					var _GoodsText:Text = new Text(this._TextObj);
						_GoodsText.x = _TitleText.x + _TitleText.width;
						_GoodsText.y = 4;
						_GoodsText.name = "GoodsText";
					_ReportBg.addChild(_GoodsText);
				}
			}
			return _ListBoardMenu;
		}
		
		private function AddText(_Type:uint, _ReportBg:Sprite):void 
		{
			var _MsgStr:String;
			switch (_Type) 
			{
				case 0:
				case 1:
					this._TextObj._col = 0xFF9C00;
					_MsgStr = "[ 交易 ]";
				break;
				case 2:
					this._TextObj._col = 0x0BB8B6;
					_MsgStr = "[ 系統 ]";
				break;
			}
			this._TextObj._str = _MsgStr;
			var _Text:Text = new Text(this._TextObj);
				_Text.x = 5;
				_Text.y = 3;
			_ReportBg.addChild(_Text);
		}
		
		private function ListBoardClickHandler(e:MouseEvent):void
		{
			var _CurrentMailList:Sprite = Sprite(e.currentTarget);
			var _CurrentReportBg:Sprite = Sprite(_CurrentMailList.getChildByName("ReportBg"));
			var _CurrentList:Mail = this._MyPage[int(_CurrentMailList.name)];
			if (_CurrentList._isRead == false) _CurrentReportBg.removeChild(_CurrentReportBg.getChildByName("GoodsText"));
			this.SendNotify(MailStrLib.OpenMail, _CurrentList);
			this.SendNotify(MailStrLib.GetMailMessage, _CurrentList);
		}
		
		public function AddMsgPanel(_CurrentList:Mail, _MailMsg:String, _ItemDisplay:ItemDisplay):void 
		{
			this._CurrentList = _CurrentList;
			(this._CurrentList._isReceived == false)?this._AskPanel.AddInform(1, "領取", 210):this._AskPanel.AddInform(0);
			var _Inform:Sprite = this._viewConterBox.getChildByName("Inform") as Sprite;
			var _ReportBg:Sprite = this.ListBoardMenu(_CurrentList);
				_ReportBg.x = -20;
				_ReportBg.y = -70;
			_Inform.addChild(_ReportBg);
			
			_ItemDisplay.ShowContent();
			var _Icon:Sprite = _ItemDisplay.ItemIcon;
			_Inform.addChild(_Icon);
			this._TextObj._col = 0xF4F0C1;
			if (_CurrentList._mailType == 0) {
				_Icon.x = 270;
				_Icon.y = 170;
				this._TextObj._Size = 18;
				this._TextObj._str = "" + _CurrentList.realPrice;
				var _PriceText:Text = new Text(this._TextObj);
					_PriceText.x = 320;
					_PriceText.y = 185;
				_Inform.addChild(_PriceText);
			}else if (_CurrentList._mailType == 1) { 
				_Icon.width = 48;
				_Icon.height = 48;
				_Icon.x = 190;
				_Icon.y = 160;
			}
			
			//_MailMsg = "恭喜，您在交易黑市所掛賣的 [PRODUCT] 已經賣出！ 商品訂價為 [PRICE] ，酌收 [TAX]% 手續費為 [SERVICE_CHARGE] 實得金額為 [MONEY]";
			this._TextObj._str = _MailMsg;
			this._TextObj._Size = 14;
			this._TextObj._wap = true;
			var _MsgText:Text = new Text(this._TextObj);
				_MsgText.width = 370;
				_MsgText.x = 40;
				_MsgText.y = 85;
			_Inform.addChild(_MsgText);
		}
		
		private function playerClick(e:MouseEvent):void 
		{
			switch(e.target.name)
				{
					case "Make0"://yes
						this.SendNotify(MailStrLib.MailGet, this._CurrentList);
						this._AskPanel.RemovePanel();
					break;
					
				}
		}
		
		override public function onRemoved():void 
		{
			this._viewConterBox.removeEventListener(MouseEvent.CLICK, playerClick);
			this._viewConterBox.removeChild(this._viewConterBox.getChildByName("MailBox"));
			this._viewConterBox.removeChild(this._Panel);
			//this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
			//MianViewCenter(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER)).LockAndUnlock(true);
		}
		
	}
}