package MVCprojectOL.ViewOL.TaskListView 
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.TipsCenter.TipsLab.TipsDataLab;
	import MVCprojectOL.ModelOL.Vo.MissionVO.Mission;
	import MVCprojectOL.ViewOL.MainView.MianViewCenter;
	import MVCprojectOL.ViewOL.SharedMethods.AskPanel;
	import MVCprojectOL.ViewOL.SharedMethods.BasisPanel;
	import MVCprojectOL.ViewOL.SharedMethods.SharedEffect;
	import MVCprojectOL.ViewOL.SharedMethods.SlidingControl;
	import MVCprojectOL.ViewOL.SharedMethods.SplitPageMethod;
	import MVCprojectOL.ViewOL.SharedMethods.TipsView;
	import Spark.coreFrameWork.View.ViewCtrl;
	import Spark.Utils.Text;
	import strLib.commandStr.UICmdStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.vewStr.ViewStrLib;
	/**
	 * ...
	 * @author brook
	 */
	public class TaskListViewCtrl extends ViewCtrl
	{
		private var _SharedEffect:SharedEffect = new SharedEffect();
		private var _BGObj:Object;
		private var _Panel:Sprite;
		private var _BasisPanel:BasisPanel
		private var _SlidingControl:SlidingControl;
		private var _PageList:Array;
		private var _CtrlPageNum:int = 0;
		private var _SplitPageMethod:SplitPageMethod = new SplitPageMethod();
		private var _TaskList:Vector.<Sprite>;
		private var _TextObj:Object = { _str:"", _wid:0, _hei:0, _wap:false, _AutoSize:"LEFT", _col:0xF4F0C1, _Size:14, _bold:true, _font:"Times New Roman", _leading:null };
		private var _CurrentListBoard:Sprite;
		private var _CurrentMission:Mission;
		private var _MyPage:Array;
		private var _AskPanel:AskPanel = new AskPanel();
		private var _TaskListData:Vector.<Mission>;
		private var _ItemLength:int;
		private var _NewGuid:String = "";
		private var _Pages:int;
		
		private var _TipClass:Function = TipsDataLab.GetTipsData().GetTipsDate;
		private var _TipsView:TipsView = new TipsView("TaskList");//---tip---
		
		public function TaskListViewCtrl(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			super( _InputViewName , _InputConter );
			this._viewConterBox.addEventListener(MouseEvent.CLICK, playerClickProcess);
		}
		
		public function AddElement(_InputObj:Object, _NewGuid:String):void
		{
			this._BGObj = _InputObj;
			this._NewGuid = _NewGuid;
			
			//this._AskPanel.AddElement(this._viewConterBox, this._BGObj);
			
			var _AlphaBox:Sprite; 
				_AlphaBox = this._SharedEffect.DrawRect(0, 0, 1000, 700);
				_AlphaBox.name = "AlphaBox";
				_AlphaBox.alpha = 0;
			this._viewConterBox.addChild(_AlphaBox );
			
			this._Panel = new Sprite();
			this._Panel.x = 312;
			this._Panel.y = 127;
			this._Panel.scaleX = 0.5;
			this._Panel.scaleY = 0.5;
			this._Panel.name = "Panel";
			this._viewConterBox.addChild(this._Panel);
			this._BasisPanel = new BasisPanel(this._BGObj, this._Panel);
			this._BasisPanel.AddBasisPanel("任務列表", 750, 510, 400);
			this._BasisPanel.AddPageBtn(160);
			
			this._AskPanel.AddElement(this._Panel, this._BGObj);
			
			var _TaskBg:Bitmap = new Bitmap(BitmapData(new(this._BGObj.TaskBg as Class)));
				_TaskBg.x = 345;
				_TaskBg.y = 130;
			this._Panel.addChild(_TaskBg);
			
			var _TaskTitleBg:Bitmap = new Bitmap(BitmapData(new(this._BGObj.TaskTitleBg as Class)));
				_TaskTitleBg.x = 360;
				_TaskTitleBg.y = 150;
			this._Panel.addChild(_TaskTitleBg);
			this._TextObj._col = 0x96B2BC;
			var _TitleText:Text = new Text(this._TextObj);
				_TitleText.x = 365;
				_TitleText.y = 165;
				_TitleText.name = "TitleText";
			this._Panel.addChild(_TitleText);
			
			this._TextObj._str = "完成條件";
			var _CompleteText:Text = new Text(this._TextObj);
				_CompleteText.x = 365;
				_CompleteText.y = 340;
			this._Panel.addChild(_CompleteText);
			
			this._TextObj._col = 0xFFFFFF;
			this._TextObj._wid = 340;
			this._TextObj._wap = true;
			var _MinssionInfoText:Text = new Text(this._TextObj);
				_MinssionInfoText.x = 365;
				_MinssionInfoText.y = 210;
				_MinssionInfoText.name = "MinssionInfoText";
			this._Panel.addChild(_MinssionInfoText);
			
			//this._TextObj._wap = false;
			this._TextObj._wid = 280;
			var _CompleteDescriptionText:Text = new Text(this._TextObj);
				_CompleteDescriptionText.x = 430;
				_CompleteDescriptionText.y = 340;
				_CompleteDescriptionText.name = "DescriptionText";
			this._Panel.addChild(_CompleteDescriptionText);
				
			this._TextObj._wap = false;
			this._TextObj._wid = 100;
			this._TextObj._col = 0x96B2BC;
			this._TextObj._str = "任務獎勵";
			var _TaskRewardText:Text = new Text(this._TextObj);
				_TaskRewardText.x = 365;
				_TaskRewardText.y = 375;
			this._Panel.addChild(_TaskRewardText);
			var _TaskRewardBg:Bitmap = new Bitmap(BitmapData(new(this._BGObj.TaskRewardBg as Class)));
				_TaskRewardBg.x = 360;
				_TaskRewardBg.y = 400;
			this._Panel.addChild(_TaskRewardBg);
			
			this._BasisPanel.AddGrayCheckBtn("領取", 650, 520, 85, "NoReceive");
			this._TipsView.MouseEffect(this._Panel.getChildByName("NoReceive"));
			this._BasisPanel.AddCheckBtn("領取", 650, 520, 85, "Receive");
			this._Panel.getChildByName("Receive").visible = false;
			this._TipsView.MouseEffect(this._Panel.getChildByName("Receive"));
			
			this._SlidingControl = new SlidingControl( this._Panel );
			
			this.SendNotify(UICmdStrLib.TaskListData);
		}
		
		public function GetTaskListData(_TaskListData:Vector.<Mission>):void
		{
			this._TaskListData = _TaskListData;
			this._SlidingControl.ClearStage();
			this._PageList = this._SplitPageMethod.SplitPage(this._TaskListData, 15);
			
			if (this._NewGuid != "") { 
				var _len:int = this._TaskListData.length;
				for (var i:int = 0; i < _len; i++) { 
					if (this._TaskListData[i]._guid == this._NewGuid) {
						this._CtrlPageNum = int(i / 15);
						this._Pages = int(i % 15);
						this.CtrlPage(this._CtrlPageNum, true, this._Pages);
					}
				}
			}else {
				this._PageList.length != 0?this.CtrlPage(this._CtrlPageNum, true):null;
			}
		}
		public function SelectTaskList(_NewGuid:String):void 
		{
			this._NewGuid = _NewGuid;
			var _len:int = this._TaskListData.length;
			for (var i:int = 0; i < _len; i++) { 
				if (this._TaskListData[i]._guid == this._NewGuid) {
					this._CtrlPageNum = int(i / 15);
					this._Pages = int(i % 15);
					this.CtrlPage(this._CtrlPageNum, true, this._Pages);
				}
			}
		}
		public function CtrlPage( _InputPage:int , _CtrlBoolean:Boolean, _Pages:int = 0 ):void
		{
			this.RemoveTaskContent();
			this._CtrlPageNum = _InputPage;
			this._MyPage = this._PageList[_InputPage];
			var _MyPageLength:uint = this._MyPage.length;
			this._TaskList = new Vector.<Sprite>;
			
			for (var i:int = 0; i < 15 ; i++) 
			{
				if (i < _MyPageLength) {
					this._TaskList.push(this.ListBoardMenu(_MyPage[i]));
					this._SharedEffect.MouseEffect(this._TaskList[i]);
					this._TaskList[i].addEventListener(MouseEvent.CLICK, ListBoardClickHandler);
					this._TaskList[i].name = "" + i;
				}else {
					this._TaskList.push(this.ListBoardMenu());
				}
			}
			
			this._CurrentListBoard = this._TaskList[_Pages];
			this._CurrentListBoard.name = this._TaskList[_Pages].name;
			this._CurrentListBoard.buttonMode = false;
			this._SharedEffect.RemoveMouseEffect(this._CurrentListBoard);
			TweenLite.to(this._CurrentListBoard, 0, { glowFilter: { color:0x66FF66, blurX:17, blurY:17, strength:3, alpha:.7 }} );
			this.GetItem(this._MyPage[int(this._CurrentListBoard.name)]);
			
			var _CurrentMission:Mission = this._MyPage[int(this._CurrentListBoard.name)];
			(_CurrentMission._status == 2 )?this._Panel.getChildByName("Receive").visible = true:this._Panel.getChildByName("Receive").visible = false;
			
			this._SlidingControl._Cols = 1;
			this._SlidingControl._Rows = 15;
			this._SlidingControl._MaxContains = this._SlidingControl._Cols * this._SlidingControl._Rows;
			this._SlidingControl._HorizontalInterval = 0;
			this._SlidingControl._VerticalInterval = 26;
			this._SlidingControl._RightInPosX = 0;
			this._SlidingControl._LeftInPosX = 0;
			this._SlidingControl.NextPage(this._TaskList , _CtrlBoolean);
			
			this._BasisPanel.PageData(this._PageList, this._CtrlPageNum);
		}
		
		//物件清單底板
		private function ListBoardMenu(_CurrentMission:Mission = null):Sprite
		{
			var _ListBoardMenu:Sprite = new Sprite();
			var _ReportBg:Sprite = new (this._BGObj.ReportBg as Class);
				_ReportBg.width = 275;
				_ReportBg.x = 60;
				_ReportBg.y = 130;
			_ListBoardMenu.addChild(_ReportBg);
			
			
			if (_CurrentMission != null) {
				
				var _Index:String = "mission_type_" + _CurrentMission._typeID;
				var _IndexStr:String=this._TipClass(_Index);
				this.AddText(_IndexStr, _ReportBg);
				
				_ListBoardMenu.buttonMode = true;
				
				this._TextObj._col = 0x999999;
				this._TextObj._str = _CurrentMission._title ;
				var _TitleText:Text = new Text(this._TextObj);
				_TitleText.x = 80;
				_TitleText.y = 4;
				_ReportBg.addChild(_TitleText);
				
				if (_CurrentMission._status == 2) {
					this._TextObj._col = 0xA5E51A;
					this._TextObj._str = " [ 完成 ] ";
					var _CompleteText:Text = new Text(this._TextObj);
						_CompleteText.x = _TitleText.x + _TitleText.width;
						_CompleteText.y = _TitleText.y;
					_ReportBg.addChild(_CompleteText);
				}
				
			}
			return _ListBoardMenu;
		}
		
		private function ListBoardClickHandler(e:MouseEvent):void
		{
			if (this._CurrentListBoard.name != e.currentTarget.name) {
				this.RemoveTaskContent();
				var _CurrentMission:Mission = this._MyPage[int(this._CurrentListBoard.name)];
				for (var i:int = 0; i < _CurrentMission._reward.length; i++) 
				{
					if (this._Panel.getChildByName("ItemIcon" + i) != null) this._Panel.removeChild(this._Panel.getChildByName("ItemIcon" + i));
					if (this._Panel.getChildByName("ItemText" + i) != null) this._Panel.removeChild(this._Panel.getChildByName("ItemText" + i));
				}
				
				TweenLite.to(this._CurrentListBoard, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
				this._SharedEffect.MouseEffect(this._CurrentListBoard);
				this._CurrentListBoard.buttonMode = true;
				
				TweenLite.to( e.currentTarget, 0, { glowFilter: { color:0x66FF66, blurX:17, blurY:17, strength:3, alpha:.7 }} );
				this._CurrentListBoard = Sprite(e.currentTarget);
				this._CurrentListBoard.name = e.currentTarget.name;
				this._CurrentListBoard.buttonMode = false;
				this._SharedEffect.RemoveMouseEffect(this._CurrentListBoard);
				this.GetItem(this._MyPage[int(this._CurrentListBoard.name)]);
				//_CurrentMission._status = 2;
				_CurrentMission = this._MyPage[int(this._CurrentListBoard.name)];
				(_CurrentMission._status == 2 )?this._Panel.getChildByName("Receive").visible = true:this._Panel.getChildByName("Receive").visible = false;
			}
		}
		
		private function GetItem(_CurrentMission:Mission):void 
		{
			var _GetItem:Object = [];
				_GetItem["Item"] = _CurrentMission._reward;
			this.SendNotify(UICmdStrLib.GetItem, _GetItem);
		}
		
		private function AddText(_Type:String, _ReportBg:Sprite):void 
		{
			switch (_Type) 
			{
				case "探索":
					this._TextObj._col = 0xFFF337;
				break;
				case "PVP":
					this._TextObj._col = 0x0BB8B6;
				break;
				case "導引":
					this._TextObj._col = 0xFF9C00;
				break;
				case "每日":
					this._TextObj._col = 0x00CC33;
				break;
			}
			this._TextObj._str = "[ " + _Type + " ]";
			var _Text:Text = new Text(this._TextObj);
				_Text.x = 10;
				_Text.y = 4;
				_Text.name = "Text";
			_ReportBg.addChild(_Text);
			
		}
		
		public function AddTaskContent(_Item:Vector.<ItemDisplay>):void 
		{
			var _CurrentMission:Mission = this._MyPage[int(this._CurrentListBoard.name)];
			var _CompleteStr:String = "";
			if (_CurrentMission._status == 2) _CompleteStr = " [ 完成 ] ";
			var _Index:String = "mission_type_" + _CurrentMission._typeID;
			var _IndexStr:String = this._TipClass(_Index);
			Text(this._Panel.getChildByName("TitleText")).ReSetString("[ " + _IndexStr + " ]" + _CurrentMission._title + _CompleteStr);
			
			Text(this._Panel.getChildByName("DescriptionText")).ReSetString(_CurrentMission._strCondition);
			
			Text(this._Panel.getChildByName("MinssionInfoText")).ReSetString(_CurrentMission._minssionInfo);
			
			this._ItemLength = _Item.length;
			var _CurrentItem:ItemDisplay;
			var _ItemIcon:Sprite;
			var _ItemText:Text;
			for (var i:int = 0; i < this._ItemLength; i++) 
			{
				_CurrentItem = _Item[i];
				_CurrentItem.ShowContent();
				_ItemIcon = _CurrentItem.ItemIcon;
				_ItemIcon.scaleX = 0.6;
				_ItemIcon.scaleY = 0.6;
				_ItemIcon.x = 365 + (i % 4) * 100;
				(_CurrentItem.ItemData._type == 3)?_ItemIcon.y = 413 + int(i / 4) * 45:_ItemIcon.y = 410 + int(i / 4) * 45;
				_ItemIcon.name = "ItemIcon" + i;
				this._Panel.addChild(_ItemIcon);
				
				this._TextObj._col = 0xBBB9AD;
				this._TextObj._str = _CurrentItem.ItemData._number;
				_ItemText = new Text(this._TextObj);
				(String(_CurrentItem.ItemData._number).length == 2)?_ItemText.x = _ItemIcon.x + _ItemIcon.height - 20:_ItemText.x = _ItemIcon.x + _ItemIcon.height - 12;
				_ItemText.y = _ItemIcon.y +_ItemIcon.height - 20;
				_ItemText.name = "ItemText" + i;
				this._Panel.addChild(_ItemText);
			}
		}
		private function RemoveTaskContent():void 
		{
			var _ItemIcon:Sprite;
			var _ItemText:Text;
			for (var i:int = 0; i < this._ItemLength; i++) 
			{
				_ItemIcon = this._Panel.getChildByName("ItemIcon" + i) as Sprite;
				_ItemText = this._Panel.getChildByName("ItemText" + i) as Text;
				if (_ItemIcon != null) this._Panel.removeChild(_ItemIcon);
				if (_ItemText != null) this._Panel.removeChild(_ItemText);
			}
		}
		
		private function AddAskPanel():void 
		{
			this._AskPanel.AddInform(1);
			this._AskPanel.AddMsgText("領取任務獎勵", 145, 40);
			var _X:int;
			var _ItemIcon:Sprite;
			var _ItemText:Text;
			var _CurrentMission:Mission = this._MyPage[int(this._CurrentListBoard.name)];
			(_CurrentMission._reward.length > 3)?_X = 410:_X = 430;
			for (var i:int = 0; i < _CurrentMission._reward.length; i++) 
			{
				_ItemIcon = Sprite(this._Panel.getChildByName("ItemIcon" + i));
				_ItemText = Text(this._Panel.getChildByName("ItemText" + i));
				_ItemIcon.x = _X + (i % 4) * 50;
				(_CurrentMission._reward[i]._type == 3)?_ItemIcon.y = 256 + int(i / 4) * 45:_ItemIcon.y = 250 + int(i / 4) * 45;
				_ItemIcon.alpha = 0;
				this._Panel.setChildIndex(_ItemIcon, this._Panel.numChildren - 1);
				TweenLite.to(_ItemIcon, 2, { alpha:1 } );
				(String(_CurrentMission._reward[i]._number).length == 2)?_ItemText.x = _ItemIcon.x + _ItemIcon.height - 20:_ItemText.x = _ItemIcon.x + _ItemIcon.height - 12;
				_ItemText.y = _ItemIcon.y +_ItemIcon.height - 20;
				_ItemText.alpha = 0;
				this._Panel.setChildIndex(_ItemText, this._Panel.numChildren - 1);
				TweenLite.to(_ItemText, 2, { alpha:1 } );
			}
		}
		public function RemoveInform():void
		{
			var _CurrentMission:Mission = this._MyPage[int(this._CurrentListBoard.name)];
			for (var i:int = 0; i < _CurrentMission._reward.length; i++) 
			{
				this._Panel.removeChild(this._Panel.getChildByName("ItemIcon" + i));
				this._Panel.removeChild(this._Panel.getChildByName("ItemText" + i));
			}
			this._AskPanel.RemovePanel();
		}
		
		private function playerClickProcess(e:MouseEvent):void 
		{
			var _CurrentName:String = e.target.name;
			switch (_CurrentName) 
			{
				case "Receive":
					this.AddAskPanel();
				break;
				case "Make0":
					var _TaskListGuid:Object = { };
						_TaskListGuid["Guid"] = Mission(this._MyPage[int(this._CurrentListBoard.name)])._guid;
					this.SendNotify( UICmdStrLib.GetMissionReward, _TaskListGuid );
					this.RemoveInform();
				break;
			}
		}
		
		override public function onRemoved():void 
		{
			this._viewConterBox.removeEventListener(MouseEvent.CLICK, playerClickProcess);
			this._viewConterBox.removeChild(this._viewConterBox.getChildByName("AlphaBox"));
			this._viewConterBox.removeChild(this._viewConterBox.getChildByName("Panel"));
			//this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
			//MianViewCenter(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER)).LockAndUnlock(true);
		}
		
	}
}