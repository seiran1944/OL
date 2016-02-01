package MVCprojectOL.ViewOL.MonsterCage 
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.TweenPlugin; 
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin; 
	import com.greensock.plugins.BlurFilterPlugin; 
	import flash.display.Shape;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MotionKeyStr;
	import MVCprojectOL.ModelOL.SkillDisplayModel.SkillDisplay;
	import MVCprojectOL.ViewOL.SharedMethods.DrawShadow;
	import MVCprojectOL.ViewOL.SharedMethods.SlidingControl;
	import MVCprojectOL.ViewOL.SharedMethods.SplitPageMethod;
	import strLib.commandStr.ViewSystem_BuildCommands;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.SpreadMethod;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.Vo.PlayerMonster;
	
	import com.greensock.easing.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import Spark.coreFrameWork.View.ViewCtrl;
	import strLib.commandStr.MonsterCageStrLib;
	
	/**
	 * ...
	 * @author brook
	 */
	public class MonsterCageView extends ViewCtrl
	{
		private var _DisplayBox:DisplayObjectContainer;
		private var _AssemblyElement:AssemblyElement = new AssemblyElement();
		private var _BGObj:Object;
		private var _MonsterDisplay:Vector.<MonsterDisplay> = new Vector.<MonsterDisplay>;
		private var _NumPerPage:int = 8;
		private var _PageList:Array = [];
		private var _SlidingControl:SlidingControl;
		private var _CtrlPageNum:int = 0;
		private var _CurrentNumerical:String;
		private var _NumericalBoxBtnBoolean:Boolean = true;
		private var _MonsterInformation:Sprite = null;
		private var _TxtFormat:TextFormat = new TextFormat();
		private var _onClickBtn:Sprite;
		private var _CurrentMonsterDetail:MonsterDisplay;
		
		public function MonsterCageView(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			TweenPlugin.activate([BlurFilterPlugin,GlowFilterPlugin]);
			//TweenPlugin.activate([GlowFilterPlugin]);
			
			var _SlidingContainer:Sprite = new Sprite();
				_SlidingContainer.name = "SlidingContainer";
			this._DisplayBox = _InputConter;
			
			
			super( _InputViewName , _InputConter );
			this._SlidingControl = new SlidingControl( _SlidingContainer );
			this._SlidingControl._Cols = 4;
			this._SlidingControl._Rows = 2;
			this._SlidingControl._MaxContains = this._SlidingControl._Cols * this._SlidingControl._Rows;
			this._SlidingControl._HorizontalInterval = 210;
			this._SlidingControl._VerticalInterval = 210;
			this._SlidingControl._RightInPosX = 1000;
			this._SlidingControl._LeftInPosX = -400;
			this._DisplayBox.addChild( _SlidingContainer );
				_SlidingContainer.x = 60;
				_SlidingContainer.y = 160;
		}
		//初始元件
		//背景
		public function BackGroundElement(_InputObj:Object):void
		{
				this._BGObj = _InputObj;
				var bg:Bitmap = new Bitmap( BitmapData( new (this._BGObj.bg1 as Class) )  );
					bg.name = "backGround";
					this._DisplayBox.addChild(bg);
				var _BackGroundSP:Sprite = this.AssemblyBG();
					_BackGroundSP.name = "BackGroundSP";
					//_BackGroundSP.addEventListener(MouseEvent.CLICK, _onClickHandler , false , 0 , true );
					this._DisplayBox.addChild(_BackGroundSP);
					this._DisplayBox.setChildIndex(bg, 0);
					//--12/24-----erichuang
					this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_REMOVE); 
					this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
		}
		//惡魔
		public function MonsterElement(_InputMonsterDisplayList:Vector.<MonsterDisplay>,_InputSortString:String):void
		{
			this._MonsterDisplay = _InputMonsterDisplayList;
			this._CurrentNumerical = _InputSortString;
			this.Record(this._MonsterDisplay);
			
			//var _QQQ:PlayerMonster = new PlayerMonster();
		}
		
		private function AssemblyBG(): Sprite
		{
			var _BackGroundSP:Sprite = new Sprite();
			
			for (var i:int = 0; i < 2; i++) 
			{
				var _pageBtnM:MovieClip = new (this._BGObj.pageBtnN as Class);
					_pageBtnM.x = 80+ 840 * i;
					_pageBtnM.y = 320;
					_pageBtnM.name = "btn" + i;
					_pageBtnM.buttonMode = true;
					_pageBtnM.gotoAndStop(3);
					//_pageBtnM.addEventListener(MouseEvent.CLICK, _onClickHandler , false , 0 , true );
					//_pageBtnM.addEventListener(MouseEvent.ROLL_OVER, _onRollOverBtnHandler , false , 0 , true );
					//_pageBtnM.addEventListener(MouseEvent.ROLL_OUT, _onRollOutBtnHandler , false , 0 , true );
					if (_pageBtnM.name =="btn0") {
						_pageBtnM.scaleX = -1;
					}
					_BackGroundSP.addChild(_pageBtnM);
			}
			return _BackGroundSP;
		}
		//頁數控制按鈕
		private function _onClickHandler(e:MouseEvent):void
		{
			this._onClickBtn = Sprite(e.currentTarget);	
			this.onClickHandler(this._onClickBtn.name);
		}
		public function onClickHandler(_InputBtnName:String):void
		{
			this._onClickBtn = MovieClip(Sprite(this._DisplayBox.getChildByName("BackGroundSP")).getChildByName(_InputBtnName));
			switch(_InputBtnName)
				{
					case "btn0":
						this._CtrlPageNum == this._PageList.length-1?MovieClip(Sprite(this._DisplayBox.getChildByName("BackGroundSP")).getChildByName("btn1")).gotoAndStop(1):null;
						this._CtrlPageNum == 1?MovieClip(this._onClickBtn).gotoAndStop(3):null;
						this._CtrlPageNum <= 0?this._CtrlPageNum = this._CtrlPageNum:(this._CtrlPageNum --) && (this.CtrlPage(this._CtrlPageNum , false , this._CurrentNumerical));
						break;
					case "btn1":
						//MovieClip(Sprite(this._DisplayBox.getChildByName("BackGroundSP")).getChildByName("btn1")).removeEventListener(MouseEvent.CLICK, _onClickHandler );
						this._CtrlPageNum == 0?MovieClip(Sprite(this._DisplayBox.getChildByName("BackGroundSP")).getChildByName("btn0")).gotoAndStop(1):null;
						this._CtrlPageNum == this._PageList.length-2?MovieClip(this._onClickBtn).gotoAndStop(3):null;
						this._CtrlPageNum ++;
						this._CtrlPageNum < this._PageList.length?this.CtrlPage(this._CtrlPageNum , true,this._CurrentNumerical ):this._CtrlPageNum --;
						break;
				}
				this.SendNotify( MonsterCageStrLib.PageTextComplete);
		}
		private function _onRollOverBtnHandler(e:MouseEvent):void
		{
			switch(e.currentTarget.name)
				{
					case "btn0":
						this._CtrlPageNum == 0?MovieClip(e.currentTarget).gotoAndStop(3):MovieClip(e.currentTarget).gotoAndStop(2);
						break;
					case "btn1":
						this._CtrlPageNum == this._PageList.length-1?MovieClip(e.currentTarget).gotoAndStop(3):MovieClip(e.currentTarget).gotoAndStop(2);
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
						this._CtrlPageNum == this._PageList.length-1?MovieClip(e.currentTarget).gotoAndStop(3):MovieClip(e.currentTarget).gotoAndStop(1);
						break;
				}
		}
		
		//儲存傳來的惡魔元件
		private function Record(_InputAry:Vector.<MonsterDisplay>):void
		{
			this._CtrlPageNum = 0;
			var _SplitPageMethod:SplitPageMethod = new SplitPageMethod();
			this._PageList = _SplitPageMethod.SplitPage(_InputAry, _NumPerPage);
			MovieClip(Sprite(this._DisplayBox.getChildByName("BackGroundSP")).getChildByName("btn0")).gotoAndStop(3);
			if (this._PageList.length > 1) {
				MovieClip(Sprite(this._DisplayBox.getChildByName("BackGroundSP")).getChildByName("btn1")).gotoAndStop(1);
				for (var i:int = 0; i < 2; i++) 
				{
					MovieClip(Sprite(this._DisplayBox.getChildByName("BackGroundSP")).getChildByName("btn" + i)).addEventListener(MouseEvent.CLICK, _onClickHandler , false , 0 , true );
					MovieClip(Sprite(this._DisplayBox.getChildByName("BackGroundSP")).getChildByName("btn" + i)).addEventListener(MouseEvent.ROLL_OVER, _onRollOverBtnHandler , false , 0 , true );
					MovieClip(Sprite(this._DisplayBox.getChildByName("BackGroundSP")).getChildByName("btn" + i)).addEventListener(MouseEvent.ROLL_OUT, _onRollOutBtnHandler , false , 0 , true );
				}
			}
			
			var _Wrap:Object = new Object();
				_Wrap["PageListLength"] = this._PageList.length;
				_Wrap["CtrlPageNum"] = this._CtrlPageNum + 1;
			this.SendNotify( MonsterCageStrLib.PageListLength, _Wrap);
			this.SendNotify( MonsterCageStrLib.PageTextComplete);
			this._PageList!=null?this.CtrlPage(this._CtrlPageNum , true , this._CurrentNumerical):this.Record(this._MonsterDisplay);
		}
		//控制顯示頁面
		private function CtrlPage( _InputPage:int , _CtrlBoolean:Boolean ,_InputNumerical:String ):void
		{
			var _Wrap:Object = new Object();
				_Wrap["PageListLength"] = this._PageList.length;
				_Wrap["CtrlPageNum"] = this._CtrlPageNum+1;
			this.SendNotify( MonsterCageStrLib.PageListLength, _Wrap);
			
			var _MyPage:Array = this._PageList[_InputPage];
			var _MyPageLength:uint = _MyPage.length;
			var _DisMonster:Vector.<Sprite> = new Vector.<Sprite>;
			var _CurrentTarget:MonsterDisplay;
			
			if ( this._SlidingControl.CurrentGuests != null ) {
				var _GuestLength:uint = this._SlidingControl.CurrentGuests.length;
				var _CurrentTargetSprite:Sprite;
				for (var j:int = 0; j < _GuestLength ; j++) {
					_CurrentTargetSprite = this._SlidingControl.CurrentGuests[j];
					_CurrentTargetSprite.removeEventListener(MouseEvent.CLICK, _onMonsterBodyClickHandler );
					_CurrentTargetSprite.removeEventListener(MouseEvent.ROLL_OVER, _onRollOverMonsterHandler );
					_CurrentTargetSprite.removeEventListener(MouseEvent.ROLL_OUT, _onRollOutMonsterHandler );
				}
			}
			for (var i:int = 0; i < _MyPageLength ; i++) {
				_CurrentTarget = _MyPage[i];
				//trace(_CurrentTarget.BodySize,13454987);
				_CurrentTarget.MonsterBody.addEventListener(MouseEvent.CLICK, _onMonsterBodyClickHandler , false , 0 , true );
				_CurrentTarget.MonsterBody.addEventListener(MouseEvent.ROLL_OVER, _onRollOverMonsterHandler , false , 0 , true );
				_CurrentTarget.MonsterBody.addEventListener(MouseEvent.ROLL_OUT, _onRollOutMonsterHandler , false , 0 , true );
				//_DisMonster.push(this.Assembly(_MyPage[i].MonsterData._showName, _MyPage[i].MonsterBody, String(_MyPage[i].MonsterData._atk)));
				_CurrentTarget.Alive = true;
				_CurrentTarget.AddStamp = true;
				_CurrentTarget.ShowContent();
				//_CurrentTarget.Motion.Act( MotionKeyStr.Statue );
				switch(_InputNumerical) 
				{
					case PlaySystemStrLab.Sort_Atk:
						_DisMonster.push(this.Assembly(_MyPage[i].MonsterData._showName, _MyPage[i].MonsterBody, String(_MyPage[i].MonsterData._atk)));
						//_CurrentTarget.ShowContent();
					break;
					case PlaySystemStrLab.Sort_Int:
						_DisMonster.push(this.Assembly(_MyPage[i].MonsterData._showName, _MyPage[i].MonsterBody, String(_MyPage[i].MonsterData._Int)));
						//_CurrentTarget.ShowContent();
					break;
					case PlaySystemStrLab.Sort_Def:
						_DisMonster.push(this.Assembly(_MyPage[i].MonsterData._showName, _MyPage[i].MonsterBody, String(_MyPage[i].MonsterData._def)));
						//_CurrentTarget.ShowContent();
					break;
					case PlaySystemStrLab.Sort_Speed:
						_DisMonster.push(this.Assembly(_MyPage[i].MonsterData._showName, _MyPage[i].MonsterBody, String(_MyPage[i].MonsterData._speed)));
						//_CurrentTarget.ShowContent();
					break;
					case PlaySystemStrLab.Sort_Mnd:
						_DisMonster.push(this.Assembly(_MyPage[i].MonsterData._showName, _MyPage[i].MonsterBody, String(_MyPage[i].MonsterData._mnd)));
						//_CurrentTarget.ShowContent();
					break;
					case PlaySystemStrLab.Sort_LV:
						_DisMonster.push(this.Assembly(_MyPage[i].MonsterData._showName, _MyPage[i].MonsterBody, String(_MyPage[i].MonsterData._lv)));
						//_CurrentTarget.ShowContent();
					break;
					case PlaySystemStrLab.Sort_HP:
						_DisMonster.push(this.Assembly(_MyPage[i].MonsterData._showName, _MyPage[i].MonsterBody, String(_MyPage[i].MonsterData._maxHP)));
						//_CurrentTarget.ShowContent();
					break;
				}	
			}
			this._SlidingControl.NextPage( _DisMonster , _CtrlBoolean );
		}
		//組裝惡魔
		private function Assembly(_InputName:String,_InputBody:Sprite,_InputNumerical:String):Sprite
		{
			var _DisplayMonster:Sprite = new Sprite();
			var _MonsterName:TextField = new TextField();
				with ( _MonsterName ) {
					this._TxtFormat.color = 0xF5C401;
					this._TxtFormat.size = 17;
					this._TxtFormat.bold = true;
					defaultTextFormat = this._TxtFormat;
					x = 70;
					y = -5;
					text = _InputName;
					autoSize = TextFieldAutoSize.CENTER;
					selectable = false;
				}
				_DisplayMonster.addChild(_MonsterName);
			var _bgBtn:Sprite = new (this._BGObj.bgBtn as Class);
				with ( _bgBtn ) {
					scaleX = 2.5;
					x = 65;
					y = 15;
				}
				_DisplayMonster.addChild(_bgBtn);
			var _MonsterNumerical:TextField = new TextField();
				with ( _MonsterNumerical ) {
					this._TxtFormat.color = 0xFFFFFF;
					this._TxtFormat.size = 17;
					this._TxtFormat.bold = true;
					defaultTextFormat = this._TxtFormat;
					x = 85;
					y = 22;
					text = _InputNumerical;
					autoSize = TextFieldAutoSize.CENTER;
					selectable = false;
				}
				_DisplayMonster.addChild(_MonsterNumerical);
			var _Property:MovieClip = new (this._BGObj.Property as Class);
				_Property.x = 85;
				_Property.y = 21;
				(this._CurrentNumerical == PlaySystemStrLab.Sort_HP)?_Property.gotoAndStop(1):null;
				(this._CurrentNumerical == PlaySystemStrLab.Sort_Def)?_Property.gotoAndStop(2):null;
				(this._CurrentNumerical == PlaySystemStrLab.Sort_Speed)?_Property.gotoAndStop(3):null;
				(this._CurrentNumerical == PlaySystemStrLab.Sort_Int)?_Property.gotoAndStop(4):null;
				(this._CurrentNumerical == PlaySystemStrLab.Sort_Mnd)?_Property.gotoAndStop(5):null;
				(this._CurrentNumerical == PlaySystemStrLab.Sort_LV)?_Property.gotoAndStop(6):null;
				(this._CurrentNumerical == PlaySystemStrLab.Sort_Atk)?_Property.gotoAndStop(7):null;
				_DisplayMonster.addChild(_Property);
			var _DrawShadow:DrawShadow = new DrawShadow();
			var _Shadow:Shape = _DrawShadow.DrawCricle(0, 0, 120, 20);
				_Shadow.x = 70;
				_Shadow.y = 185;
				_Shadow.alpha = .6;
				_DisplayMonster.addChild(_Shadow);
			TweenLite.to(_Shadow, 0, { glowFilter: { color:0x333333, blurX:5, blurY:5, strength:3, alpha:1 }} );
			var _MonsterBody:Sprite = _InputBody;
				with (_MonsterBody) {
					x = 48;
					y = 50;
					buttonMode = true;
				}
				_DisplayMonster.addChild(_MonsterBody);
			return _DisplayMonster;
		}
		//惡魔資訊面板
		private function _onMonsterBodyClickHandler(e:MouseEvent):void
		{
				var _Wrap:Object = new Object();
					_Wrap["_guid"] = e.currentTarget.name;
				this.SendNotify( MonsterCageStrLib.MonsterInformation, _Wrap );
				this.SendNotify( MonsterCageStrLib.PageTextComplete);
		}
		//組裝惡魔資訊面板
		public function AssemblyMonsterInformation(_InputMD:MonsterDisplay):void
		{
				//trace(_InputMD.MonsterData._Skill,"@@@@@");
				//_InputMD.Motion.Direction = true;//Monster轉換方向
				//trace(_InputMD.MonsterData._Equ, "+++++++++++++++++");
				for (var i:int = 0; i < this._MonsterDisplay.length; i++) this._MonsterDisplay[i].Alive = false;//停止惡魔動畫
				if (_InputMD.MonsterData._Equ == null) { 
					this.AddMonsterInformation(_InputMD);
				}else {
					//trace(_InputMD.MonsterData._Equ[0]._picItem,"@@@@@");
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
			//trace(_InputMD, _InputItem.ItemIcon, "=====");
			this._CurrentMonsterDetail = _InputMD;
			var _DetailBoard:Sprite = new (this._BGObj.DetailBoard as Class);
			var _AssemblyElement:AssemblyElement = new AssemblyElement;
				_InputMD.Alive = true;
				_InputMD.ShowContent();
			var _MonsterInformationSP:Sprite = _AssemblyElement.MonsterInformationPage(_DetailBoard, _InputMD.MonsterBody, _InputMD.MonsterData._showName, _InputMD.MonsterData._lv, _InputMD.MonsterData._atk, _InputMD.MonsterData._def, _InputMD.MonsterData._speed, _InputMD.MonsterData._Int, _InputMD.MonsterData._mnd, _InputMD.MonsterData._dissoLv, _InputMD.MonsterData._nowHp, _InputMD.MonsterData._maxHP, _InputMD.MonsterData._nowEng, _InputMD.MonsterData._maxEng, _InputMD.MonsterData._nowExp, _InputMD.MonsterData._maxExp,
												_InputMD.MonsterData._learnSkill[0], _InputMD.MonsterData._learnSkill[1], _InputMD.MonsterData._learnSkill[2], _InputMD.MonsterData._learnSkill[3], _InputMD.MonsterData._learnSkill[4], _InputMD.MonsterData._learnSkill[5], _InputMD.MonsterData._learnSkill[6], _InputMD.MonsterData._eatStoneRange, _InputMD.MonsterData._lv,
												_InputWeapon, _InputArmor, _InputAccessories, _InputSkill);
			this._MonsterInformation = _MonsterInformationSP;
			this._MonsterInformation.x = 365;
			this._MonsterInformation.y = 230;
			this._MonsterInformation.scaleX = 0.5;
			this._MonsterInformation.scaleY = 0.5;
			
			var _AlphaBox:Sprite; 
			_AlphaBox = this.DrawRect(0, 0, 1000, 700);
			_AlphaBox.name = "AlphaBox";
			_AlphaBox.alpha = 0;
			this._DisplayBox.addChild(_AlphaBox );
			TweenLite.to(this._DisplayBox.getChildByName("SlidingContainer"), 1, { blurFilter: { blurX:20,blurY:20 }} );
			TweenLite.to(this._DisplayBox.getChildByName("backGround"), 1, { blurFilter: { blurX:20, blurY:20 }} );
			TweenLite.to(this._DisplayBox.getChildByName("BackGroundSP") , 1, { blurFilter: { blurX:20, blurY:20 }} );
			
			this._DisplayBox.addChild(this._MonsterInformation );
			this.ZoomIn(this._MonsterInformation, 617, 420, 0.5);
		}
		private function ZoomIn(_InputSp:Sprite,_OriginalWidth:int,_OriginalHeight:int,_Proportion:Number):void
		{
			var _NewX:int = _InputSp.x - ((_OriginalWidth * _Proportion)) * _Proportion;
			var _NewY:int = _InputSp.y - ((_OriginalHeight * _Proportion)) * _Proportion;
			if (this._MonsterInformation != null)TweenLite.to(this._MonsterInformation, 1, { x:_NewX, y:_NewY, scaleX:1, scaleY:1 , ease:Elastic.easeOut,onComplete:ClickHandler } );//x:300-((400*0.5)*0.5)
		}
		private function ClickHandler():void
		{
			this._DisplayBox.addEventListener(MouseEvent.CLICK, _onInformationBtnClickHandler, false , 0 , true);
		}
		private function _onInformationBtnClickHandler(e:MouseEvent):void
		{
			this._DisplayBox.removeEventListener(MouseEvent.CLICK, _onInformationBtnClickHandler);
			if (this._MonsterInformation != null) {
				for (var i:int = 0; i < this._MonsterDisplay.length; i++) this._MonsterDisplay[i].Alive = true;//開始惡麼動畫
				TweenLite.to(this._MonsterInformation, 0.3, { x:365, y:230, scaleX:0.5, scaleY:0.5 ,onComplete:CompleteHandler } );
			}
		}
		//移除惡魔面板元件
		private function CompleteHandler():void
		{
			if (this._DisplayBox.getChildByName("AlphaBox") != null) this._DisplayBox.removeChild( this._DisplayBox.getChildByName("AlphaBox"));
			TweenLite.to(this._DisplayBox.getChildByName("SlidingContainer"), 0.3, { blurFilter: { blurX:0,blurY:0 }} );
			TweenLite.to(this._DisplayBox.getChildByName("backGround"),0.3, { blurFilter: { blurX:0, blurY:0 }} );
			TweenLite.to(this._DisplayBox.getChildByName("BackGroundSP")  , 0.3, { blurFilter: { blurX:0, blurY:0 }} );
			if (this._MonsterInformation != null) this._DisplayBox.removeChild( this._MonsterInformation );
			this._MonsterInformation = null;
			
			this._CurrentMonsterDetail.Clear();
			this._CurrentMonsterDetail = null;
		}
		//滑入滑出效果
		private function _onRollOverMonsterHandler(e:MouseEvent):void{
			TweenLite.to(e.currentTarget, 0, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }} );
		}
		private function _onRollOutMonsterHandler(e:MouseEvent):void{
			TweenLite.to(e.currentTarget, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
		}
		
		private function DrawRect(_LocationX:int, _LocationY:int, _Width:int, _Height:int):Sprite 
		{
			var _sp:Sprite = new Sprite ();
				_sp.graphics.beginFill(0x666cc);
				_sp.graphics.drawRect(_LocationX,_LocationY,_Width,_Height);
			return _sp;
		}
		
		/*private function RemoveSlidingControl(_InpurBody:Vector.<Sprite>):void
		{
			if ( this._SlidingControl.CurrentGuests != null ) {
				var _GuestLength:uint = this._SlidingControl.CurrentGuests.length;
				var _CurrentTargetSprite:Sprite;
				for (var j:int = 0; j < _GuestLength ; j++) {
					_CurrentTargetSprite = this._SlidingControl.CurrentGuests[j];
					_CurrentTargetSprite.removeEventListener(MouseEvent.CLICK, _onMonsterBodyClickHandler );
					_CurrentTargetSprite.removeEventListener(MouseEvent.ROLL_OVER, _onRollOverMonsterHandler );
					_CurrentTargetSprite.removeEventListener(MouseEvent.ROLL_OUT, _onRollOutMonsterHandler );
				}
			}
		}*/
		
		//清除物件
		override public function onRemoved():void 
		{
			this._SlidingControl.ClearStage(true);
			if (this._MonsterInformation != null) this.CompleteHandler();
			
			while (this._DisplayBox.numChildren>0) 
			{
			 this._DisplayBox.removeChildAt(0);
			}
			trace("conterName__"+this._DisplayBox.name);
			//this._DisplayBox.alpha = .5;
			 this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_CREAT);	
		}
		
		
		
	}//end class
}//end package
