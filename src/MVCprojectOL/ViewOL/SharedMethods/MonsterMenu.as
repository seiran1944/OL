package MVCprojectOL.ViewOL.SharedMethods 
{
	import com.greensock.plugins.BlurFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.ShowSideSys.EquAndEatStone;
	import MVCprojectOL.ModelOL.ShowSideSys.SystemStrTIPS;
	import MVCprojectOL.ViewOL.SharedMethods.AssemblyDevilInforPanel;
	import MVCprojectOL.ViewOL.SharedMethods.SlidingControl;
	import MVCprojectOL.ViewOL.SharedMethods.SplitPageMethod;
	import Spark.coreFrameWork.View.ViewCtrl;
	import strLib.commandStr.UICmdStrLib;
	/**
	 * ... 怪獸列表選單
	 * @author brook
	 */
	public class MonsterMenu extends ViewCtrl
	{
		private var _BGObj:Object;
		private var _Name:String;
		private var _PageList:Array = null;
		private var _CtrlPageNum:int;
		private var _SlidingControl:SlidingControl;
		private var _CurrentItemDisplay:ItemDisplay;
		private var _CurrentTabM:int;
		private var _ClickBoolean:Boolean;
		private var MonsterMenuSP:Vector.<Sprite>;
		private var _MonsterDisplay:Vector.<MonsterDisplay>;
		
		public function MonsterMenu(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			TweenPlugin.activate([BlurFilterPlugin]);
			
			super( _InputViewName , _InputConter );
			
			var _SlidingContainer:Sprite = new Sprite();
				_SlidingContainer.name = "SlidingContainer";
			this._SlidingControl = new SlidingControl( _SlidingContainer );
			this._viewConterBox.addChild( _SlidingContainer );
		}
		
		public function AddMonsterMenu(_InputName:String, _InputMonster:Vector.<MonsterDisplay>, _InputObj:Object, _CurrentTabM:int = -1 , _CurrentItemDisplay:ItemDisplay = null):void
		{
			this._Name = _InputName;
			this._BGObj = _InputObj;
			this._CurrentItemDisplay = _CurrentItemDisplay;
			this._CurrentTabM = _CurrentTabM;
			this._MonsterDisplay = _InputMonster;
			
			this._viewConterBox.setChildIndex( this._viewConterBox.getChildByName("SlidingContainer"), this._viewConterBox.numChildren - 1 );
			
			this._CtrlPageNum = 0;
			var _SplitPageMethod:SplitPageMethod = new SplitPageMethod();
			this._PageList = _SplitPageMethod.SplitPage(this._MonsterDisplay, 8);
			
			for (var i:int = 0; i < 2; i++) {
				var _pageBtnN:MovieClip = new (this._BGObj.pageBtnN as Class);
					_pageBtnN.x = 100 + 790 * i;
					_pageBtnN.y = 310;
					_pageBtnN.name = "btn" + i;
					_pageBtnN.buttonMode = true;
					_pageBtnN.gotoAndStop(3);
					this._viewConterBox.addChild(_pageBtnN);
					if (_pageBtnN.name == "btn0") _pageBtnN.scaleX = -1;
					_pageBtnN.addEventListener(MouseEvent.CLICK, _onClickHandler , false , 0 , true );
					_pageBtnN.addEventListener(MouseEvent.ROLL_OVER, _onRollOverBtnHandler , false , 0 , true );
					_pageBtnN.addEventListener(MouseEvent.ROLL_OUT, _onRollOutBtnHandler , false , 0 , true );
			}
				
			var _Btn0:MovieClip = MovieClip(this._viewConterBox.getChildByName("btn0"));
			var _Btn1:MovieClip = MovieClip(this._viewConterBox.getChildByName("btn1"));
			if (this._PageList.length != 0 && this._PageList.length != 1)  {
				_Btn0.buttonMode = false;
				_Btn0.gotoAndStop(3);
				_Btn1.buttonMode = true;
				_Btn1.gotoAndStop(1);
			}else {
				_Btn0.buttonMode = false;
				_Btn0.gotoAndStop(3);
				_Btn1.buttonMode = false;
				_Btn1.gotoAndStop(3);
			}	
				
			var _Wrap:Object = new Object();
				_Wrap["PageListLength"] = this._PageList.length;
				_Wrap["CtrlPageNum"] = this._CtrlPageNum + 1;
			this.SendNotify( UICmdStrLib.PageListLength, _Wrap);
			this.SendNotify( UICmdStrLib.PageTextComplete);
			this.CtrlPage(this._CtrlPageNum , true );
		}
		
		private function CtrlPage( _InputPage:int , _CtrlBoolean:Boolean ):void
		{
			var _Wrap:Object = new Object();
				_Wrap["PageListLength"] = this._PageList.length;
				_Wrap["CtrlPageNum"] = this._CtrlPageNum + 1;
			this.SendNotify( UICmdStrLib.PageListLength, _Wrap);
			
			if (this.MonsterMenuSP != null) for (var i:int = 0; i < this.MonsterMenuSP.length ; i++) this.MonsterMenuSP[i].removeEventListener(MouseEvent.CLICK, MonsterClickHandler);
			var _MyPage:Array = this._PageList[_InputPage];
			var _MyPageLength:uint = _MyPage.length;
			this.MonsterMenuSP = new Vector.<Sprite>;
			
			for (var i:int = 0; i < _MyPageLength ; i++) {
				_MyPage[i].ShowContent();
				_MyPage[i].AddStamp = true;//惡魔蓋章
				_MyPage[i].Alive = true;//惡魔動畫
				this.MonsterMenuSP.push(this.AssemblyMonsterMenu(_MyPage[i].MonsterBody,_MyPage[i].MonsterData) );
				(_MyPage[i].MonsterData._useing == 3)?null:this.MonsterMenuSP[i].addEventListener(MouseEvent.CLICK, MonsterClickHandler);
				this.MouseEffect(this.MonsterMenuSP[i]);
			}
			
			this._SlidingControl._Cols = 4;
			this._SlidingControl._Rows = 2;
			this._SlidingControl._MaxContains = this._SlidingControl._Cols * this._SlidingControl._Rows;
			this._SlidingControl._HorizontalInterval = 190;
			this._SlidingControl._VerticalInterval = 240;
			this._SlidingControl._RightInPosX = 600;
			this._SlidingControl._LeftInPosX = -50;
			this._SlidingControl.NextPage(this.MonsterMenuSP, _CtrlBoolean);
		}
		
		private function AssemblyMonsterMenu(_InputBody:Sprite,_InputData:Object):Sprite
		{
			var _DisplayMonsterMenu:Sprite = new Sprite();
				_DisplayMonsterMenu.name = _InputBody.name;
			var _olBoard:Sprite = new (this._BGObj.olBoard as Class);
			with (_olBoard) {
				x = 120;
				y = 90;
				buttonMode = true;
			}
				_DisplayMonsterMenu.addChild(_olBoard);
			var _AssemblyElement:AssemblyDevilInforPanel = new AssemblyDevilInforPanel();
				_AssemblyElement.MonsterInformationPage(_olBoard,_InputData._showName,_InputData._lv,_InputData._atk,_InputData._def,_InputData._speed,_InputData._Int,_InputData._mnd,"",_InputData._nowHp,_InputData._maxHP,_InputData._nowEng,_InputData._maxEng,_InputData._nowExp,_InputData._maxExp);
			var _MonsterBody:Sprite = _InputBody;
				with (_MonsterBody) {
					x = 15;
					y = 28;
					buttonMode = true;
				}
				_olBoard.addChild(_MonsterBody);
			return _DisplayMonsterMenu;
		}
		public function JudgeClick(_InputAny:*):void 
		{
			switch ( true ) 
			{
				case _InputAny is EquAndEatStone:
					this._ClickBoolean = true;
				break;
				case _InputAny is SystemStrTIPS:
					this._ClickBoolean = false;
				break;
			}
		}
		//點擊惡魔效果
		private function MonsterClickHandler(e:MouseEvent):void
		{
				var _CurrentMonster:Object = new Object();
				_CurrentMonster["guid"] = e.currentTarget.name;
				switch(this._Name)
				{
					case "Storage":
						_CurrentMonster["IconName"] = this._CurrentItemDisplay.ItemID;
						if (this._ClickBoolean == true) {
							this.RemoveClickHandler();
							this.SendNotify( UICmdStrLib.UseMonsterMenu, _CurrentMonster);
						}
					break;
					case "Library":
						_CurrentMonster["SkillGroup"] = this._CurrentTabM;
						this.SendNotify( UICmdStrLib.UseMonsterMenu, _CurrentMonster);
					break;
				}
			
			
		}
		//AddTip
		private function AddTip(_MonsterID:String):void
		{
			var _CurrentMonster:Object = new Object();
			switch(this._Name)
			{
				case "Storage":
					if (this._CurrentTabM == 1 || this._CurrentTabM == 2 || this._CurrentTabM == 3) {
						_CurrentMonster["CurrentTabM"] = this._CurrentTabM;
						_CurrentMonster["IconName"] = this._CurrentItemDisplay.ItemID;
						_CurrentMonster["gruopGuid"] = this._CurrentItemDisplay.ItemData._gruopGuid;
						_CurrentMonster["guid"] = _MonsterID;
						_CurrentMonster["showName"] = this._CurrentItemDisplay.ItemData._showName;
						_CurrentMonster["picItem"] = this._CurrentItemDisplay.ItemData._picItem;
						this.SendNotify( UICmdStrLib.MonsterTip, _CurrentMonster);
					}
					if (this._CurrentTabM == 0) {
						_CurrentMonster["CurrentTabM"] = this._CurrentTabM;
						_CurrentMonster["IconName"] = this._CurrentItemDisplay.ItemID;
						_CurrentMonster["guid"] = _MonsterID;
						_CurrentMonster["showName"] = this._CurrentItemDisplay.ItemData._showName;
						_CurrentMonster["picItem"] = this._CurrentItemDisplay.ItemData._picItem;
						this.SendNotify( UICmdStrLib.MonsterTip, _CurrentMonster);
					}
				break;
			}
		}
		private function RemoveTip():void
		{
			var _CurrentMonster:Object = new Object();
			switch(this._Name)
			{
				case "Storage":
					_CurrentMonster["CurrentTabM"] = this._CurrentTabM;
					this.SendNotify( UICmdStrLib.RemoveMonsterTip, _CurrentMonster);
				break;
			}
		}
		
		public function RemoveClickHandler():void
		{
			for (var i:int = 0; i <this._SlidingControl.CurrentGuests.length ; i++) 
			{
				this._MonsterDisplay[i].Alive = false;
				this._SlidingControl.CurrentGuests[i].removeEventListener(MouseEvent.CLICK, MonsterClickHandler);
				this.RemoveMouseEffect(this._SlidingControl.CurrentGuests[i]);
				TweenLite.to(this._SlidingControl.CurrentGuests[i], 1, { blurFilter: { blurX:20, blurY:20 }} );
				TweenLite.to(this._SlidingControl.CurrentGuests[i], 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
			}
			for (var j:int = 0; j < 2; j++) 
			{
				Sprite(this._viewConterBox.getChildByName("btn" + j)).removeEventListener(MouseEvent.CLICK, _onClickHandler);
				Sprite(this._viewConterBox.getChildByName("btn" + j)).removeEventListener(MouseEvent.ROLL_OVER, _onRollOverBtnHandler );
				Sprite(this._viewConterBox.getChildByName("btn" + j)).removeEventListener(MouseEvent.ROLL_OUT, _onRollOutBtnHandler );
			}
			
		}
		
		public function RecoverBtn():void
		{
			for (var i:int = 0; i <this._SlidingControl.CurrentGuests.length ; i++) 
			{
				this._MonsterDisplay[i].Alive = true;
				this._SlidingControl.CurrentGuests[i].addEventListener(MouseEvent.CLICK, MonsterClickHandler);
				this.MouseEffect(this._SlidingControl.CurrentGuests[i]);
				TweenLite.to(this._SlidingControl.CurrentGuests[i], 1, { blurFilter: { blurX:0, blurY:0 }} );
			}
			for (var j:int = 0; j < 2; j++) 
			{
				Sprite(this._viewConterBox.getChildByName("btn" + j)).addEventListener(MouseEvent.CLICK, _onClickHandler);
				Sprite(this._viewConterBox.getChildByName("btn" + j)).addEventListener(MouseEvent.ROLL_OVER, _onRollOverBtnHandler );
				Sprite(this._viewConterBox.getChildByName("btn" + j)).addEventListener(MouseEvent.ROLL_OUT, _onRollOutBtnHandler );
			}
		}
		
		//頁數控制按鈕
		private function _onClickHandler(e:MouseEvent):void
		{
			switch(e.currentTarget.name)
				{
					case "btn0":
						if (this._CtrlPageNum != 0) {
							this._CtrlPageNum == this._PageList.length-1?MovieClip(this._viewConterBox.getChildByName("btn1")).gotoAndStop(1):null;
							this._CtrlPageNum == 1?MovieClip(e.currentTarget).gotoAndStop(3):null;
							this._CtrlPageNum <= 0?this._CtrlPageNum = this._CtrlPageNum:(this._CtrlPageNum --) && (this.CtrlPage(this._CtrlPageNum , false ));
						}
						break;
					case "btn1":
						if (this._CtrlPageNum != this._PageList.length - 1 && this._PageList.length > 1) {
							this._CtrlPageNum == 0?MovieClip(this._viewConterBox.getChildByName("btn0")).gotoAndStop(1):null;
							this._CtrlPageNum == this._PageList.length-2?MovieClip(e.currentTarget).gotoAndStop(3):null;
							this._CtrlPageNum ++;
							this._CtrlPageNum < this._PageList.length?this.CtrlPage(this._CtrlPageNum , true ):this._CtrlPageNum --;
						}
						break;
				}
			this._CtrlPageNum == 0?Sprite(this._viewConterBox.getChildByName("btn0")).buttonMode = false:Sprite(this._viewConterBox.getChildByName("btn0")).buttonMode = true;
			this._CtrlPageNum== this._PageList.length-1?Sprite(this._viewConterBox.getChildByName("btn1")).buttonMode = false:Sprite(this._viewConterBox.getChildByName("btn1")).buttonMode = true;
		}
		private function _onRollOverBtnHandler(e:MouseEvent):void
		{
			switch(e.currentTarget.name)
			{
				case "btn0":
					this._CtrlPageNum == 0?MovieClip(e.currentTarget).gotoAndStop(3):MovieClip(e.currentTarget).gotoAndStop(2);
				break;
				case "btn1":
					(this._CtrlPageNum == this._PageList.length - 1 || this._PageList.length <= 1)?MovieClip(e.currentTarget).gotoAndStop(3):MovieClip(e.currentTarget).gotoAndStop(2);
				break;
			}
		}
		private function _onRollOutBtnHandler(e:MouseEvent):void
		{
			switch(e.currentTarget.name)
			{
				case "btn0":
					this._CtrlPageNum == 0?MovieClip(e.currentTarget).gotoAndStop(3):MovieClip(e.currentTarget).gotoAndStop(1);
				break;
				case "btn1":
					(this._CtrlPageNum == this._PageList.length - 1 || this._PageList.length <= 1)?MovieClip(e.currentTarget).gotoAndStop(3):MovieClip(e.currentTarget).gotoAndStop(1);
				break;
			}
		}
		//滑鼠滑入滑出效果
		private function MouseEffect(btn:*):void
		{
			btn.addEventListener(MouseEvent.ROLL_OVER, BtnEffect);
			btn.addEventListener(MouseEvent.ROLL_OUT, BtnEffect);
		}
		private function BtnEffect(e:MouseEvent):void 
		{
			switch (e.type) 
			{
				case "rollOver":
					TweenLite.to(e.target, 0, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }} );
					this.AddTip(e.currentTarget.name);
				break;
				case "rollOut":
					TweenLite.to(e.target, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
					this.RemoveTip();
				break;
			}
		}
		//移除滑入滑出效果
		private function RemoveMouseEffect(btn:*):void
		{
			btn.removeEventListener(MouseEvent.ROLL_OVER, BtnEffect);
			btn.removeEventListener(MouseEvent.ROLL_OUT, BtnEffect);
		}
		
		public function onRemove():void
		{
			for (var i:int = 0; i < this.MonsterMenuSP.length ; i++) this.MonsterMenuSP[i].removeEventListener(MouseEvent.CLICK, MonsterClickHandler);
			this._viewConterBox.setChildIndex( this._viewConterBox.getChildByName("SlidingContainer"), 0 );
			this._SlidingControl.ClearStage(true);
			for (var j:int = 0; j < 2; j++) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("btn" + j));
		}
		
		override public function onRemoved():void 
		{
			
		}
		
	}
}