package MVCprojectOL.ViewOL.ExploreView.WorldJourney 
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import MVCprojectOL.ModelOL.Explore.Display.ChapterDisplay;
	import MVCprojectOL.ModelOL.Vo.Explore.ExploreArea;
	import MVCprojectOL.ViewOL.MainView.MianViewCenter;
	import strLib.vewStr.ViewStrLib;
	//import MVCprojectOL.ModelOL.ShowSideSys.SingleTimerBar;
	import MVCprojectOL.ModelOL.TipsCenter.DisplayobjLab.SingleTimerBar;
	import MVCprojectOL.ViewOL.SharedMethods.AskPanel;
	import MVCprojectOL.ViewOL.SharedMethods.BasisPanel;
	import MVCprojectOL.ViewOL.SharedMethods.SharedEffect;
	import MVCprojectOL.ViewOL.SharedMethods.SlidingControl;
	import MVCprojectOL.ViewOL.SharedMethods.SplitPageMethod;
	import Spark.coreFrameWork.View.ViewCtrl;
	import Spark.Utils.Text;
	import strLib.commandStr.UICmdStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.commandStr.WorldJourneyStrLib;
	
	
	import MVCprojectOL.ViewOL.ExploreView.Display.RouteLine;
	/**
	 * ...
	 * @author brook
	 * @version 13.06.17.16.30
	 */
	public class WorldJourneyViewCtrl  extends ViewCtrl
	{
		private var _SharedEffect:SharedEffect = new SharedEffect();
		private var _BGObj:Object;
		private var _Panel:Sprite;
		private var _BasisPanel:BasisPanel;
		private var _SlidingControl:SlidingControl;
		private var _PageList:Array;
		private var _CtrlPageNum:int = 0;
		private var _SplitPageMethod:SplitPageMethod = new SplitPageMethod();
		private var _MapData:Array;
		private var _ListBoardMenuSP:Vector.<Sprite>;
		private var _TextObj:Object = { _str:"", _wid:0, _hei:0, _wap:false, _AutoSize:"CENTER", _col:0xFFFFFF, _Size:14, _bold:true, _font:"Times New Roman", _leading:null };
		private var _CurrentListBoard:Sprite;
		private var _Chapter:Vector.<ChapterDisplay>;
		private var _CurrentFightBtn:MovieClip = null;
		private var _CurrentStar:int;
		private var _CurrentChapter:ChapterDisplay;
		private var _CurrentChapterNum:int = 0;
		private var _ChapterNum:int = -1;
		private var _MaxStar:int;
		private var _AskPanel:AskPanel = new AskPanel();
		
		private var _RouteLine:RouteLine;//130613
		
		public function WorldJourneyViewCtrl(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			super( _InputViewName , _InputConter );
			this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_REMOVE);
			this._viewConterBox.addEventListener(MouseEvent.CLICK, playerClickProcess);
		}
		
		public function AddElement(_InputObj:Object):void
		{
			this._BGObj = _InputObj;
			
			this._AskPanel.AddElement(this._viewConterBox, this._BGObj);
			
			this._Panel = new Sprite();
			this._Panel.x = 230;
			this._Panel.y = 105;
			this._Panel.scaleX = 0.5;
			this._Panel.scaleY = 0.5;
			this._Panel.name = "Panel";
			this._viewConterBox.addChild(this._Panel);
			this._BasisPanel = new BasisPanel(this._BGObj, this._Panel);
			this._BasisPanel.AddBasisPanel("魔神殿探索", 1000, 700, 560);
			this._BasisPanel.AddPageBtn(115, 720);
			
			var _MonsterBox:Sprite = new (this._BGObj.MonsterBox as Class);
				_MonsterBox.width = 230;
				_MonsterBox.height = 630;
				_MonsterBox.x = 40;
				_MonsterBox.y = 100;
				_MonsterBox.name = "MonsterBox";
			this._Panel.addChild(_MonsterBox);
			
			var _PitBg:Bitmap = new Bitmap(BitmapData(new (this._BGObj.PitBg as Class)));
				_PitBg.x = 260;
				_PitBg.y = 630;
			this._Panel.addChild(_PitBg);
			
			var _MapFram:Sprite = new (this._BGObj.MapFram as Class);
				_MapFram.width = 725;
				_MapFram.height = 500;
				_MapFram.x = 265;
				_MapFram.y = 130;
				_MapFram.name = "MapFram";
			this._Panel.addChild(_MapFram);
			
			this._BasisPanel.AddFatigue(0.7, 0.7, 880, 640);
			
			this._BasisPanel.AddGrayCheckBtn("出發", 880, 680, 85, "GrayDeparture");
			this._BasisPanel.AddCheckBtn("出發", 880, 680, 85, "Departure");
			this._Panel.getChildByName("Departure").visible = false;
			
			this._SlidingControl = new SlidingControl( this._Panel );
			
			var _AlphaBox:Sprite;
			var _TitleBtn:Sprite;
			var _TitleBtnText:Text;
			for (var j:int = 0; j < 4; j++) 
			{
				_AlphaBox = this._SharedEffect.DrawRect(0, 0, 200, 140 - 5);
				_AlphaBox.x = 52;
				_AlphaBox.y = 135 + j * 140;
				_AlphaBox.alpha = 0;
				_AlphaBox.name = "AlphaBox" + j;
				this._Panel.addChild(_AlphaBox);
				
				_TitleBtn = new (this._BGObj.TitleBtn as Class);
				_TitleBtn.width = 185;
				_TitleBtn.x = 62;
				_TitleBtn.y = 250+ j * 140;
				_TitleBtn.name = "TitleBtn" + j;
				this._Panel.addChild(_TitleBtn);	
				
				_TitleBtnText = new Text(this._TextObj);
				_TitleBtnText.x = _TitleBtn.width / 2 - _TitleBtnText.width / 2 - 43;
				_TitleBtnText.name = "TitleBtnText" + j;
				_TitleBtn.addChild(_TitleBtnText);
			}
			
			this._TextObj._AutoSize = "LEFT";
			var _Info:Text = new Text(this._TextObj);
				_Info.x = 290;
				_Info.y = 640;
				_Info.name = "Info";
			this._Panel.addChild(_Info);
			
			this._RouteLine = new RouteLine( this._Panel , _InputObj["RouteEnable"] , _InputObj["RouteDisable"] );
			
			this.SendNotify(UICmdStrLib.MapData);
		}
		//
		public function UpdateTimeBar( _InputChapterID:String , _currentTarget:ExploreArea ):void 
		{
			//130606 更新據點CD狀態 _InputChapterID = 該據點所屬的章節   _InputAreaID = 該據點的ID
			//trace( _InputChapterID , _InputAreaID , "<--------------Updating-------------->" );
			var _ChapterDisplay:ChapterDisplay = this._Chapter[this._CurrentChapterNum];
			if (_ChapterDisplay.Data._guid == _InputChapterID) { 
				var _Length:int = _ChapterDisplay.Data._areaList.length;
				var _CurrentAreaList:ExploreArea;
				var _FightBtn:MovieClip;
				var _TimeBar:Sprite
				for (var i:int = 0; i < _Length; i++) 
				{
					_CurrentAreaList = this._CurrentChapter.Data._areaList[i];
					if (_CurrentAreaList._guid == _currentTarget._guid) {
						_FightBtn = this._Panel.getChildByName("FightBtn" +  (i + 1)) as MovieClip;
						_FightBtn.gotoAndStop(2);
						_FightBtn.buttonMode = true;
						this._SharedEffect.MouseEffect(_FightBtn);
						_TimeBar = this._Panel.getChildByName("TimeBar" + (i + 1)) as Sprite;
						SingleTimerBar(_TimeBar).Close();
						this._Panel.removeChild(_TimeBar);
					}
				}
			}
		}
		//
		public function AddMapData(_MapData:Array):void 
		{
			this._MapData = _MapData;
			this._PageList = this._SplitPageMethod.SplitPage(this._MapData, 4);
			this._PageList.length != 0?this.CtrlPage(this._CtrlPageNum, false):null;
		}
		public function CtrlPage( _InputPage:int , _CtrlBoolean:Boolean ):void
		{
			this._SlidingControl.ClearStage();
			this._CurrentStar = 0;
			this._ChapterNum = -1;
			if (_CtrlBoolean == true) this._CurrentChapterNum = 0;
			if (this._CurrentListBoard != null) { 
				//if (this._Panel.getChildByName("Departure") != null) this._Panel.removeChild(this._Panel.getChildByName("Departure"));
				this._Panel.getChildByName("Departure").visible = false;
				for (var k:int = 1; k < this._CurrentChapter.Data._areaList.length + 1; k++) 
				{
					this._Panel.removeChild(this._Panel.getChildByName("FightBtn" + k));
					if (this._Panel.getChildByName("TimeBar" + k)  != null) {
						SingleTimerBar(this._Panel.getChildByName("TimeBar" + k)).Close();
						this._Panel.removeChild(this._Panel.getChildByName("TimeBar" + k));
					}
				}
				if (this._Panel.getChildByName("BigMap") != null) this._Panel.removeChild(this._Panel.getChildByName("BigMap"));
				var _AlphaBox:Sprite=Sprite(this._Panel.getChildByName("AlphaBox" + this._CurrentListBoard.name));
					_AlphaBox.buttonMode = true;
					_AlphaBox.addEventListener(MouseEvent.CLICK, ListBoardClickHandler);
					_AlphaBox.addEventListener(MouseEvent.ROLL_OVER, ListBoardRollOver);
					_AlphaBox.addEventListener(MouseEvent.ROLL_OUT, ListBoardRollOut);
				var _TitleBtn:Sprite = Sprite(this._Panel.getChildByName("TitleBtn" + this._CurrentListBoard.name));
				TweenLite.to(_TitleBtn, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
			}
			
			this._CtrlPageNum = _InputPage;
			var _MyPage:Array = this._PageList[_InputPage];
			var _MyPageLength:uint = _MyPage.length;
			var _CurrentChapter:ChapterDisplay;
			this._Chapter = new Vector.<ChapterDisplay>;
			this._ListBoardMenuSP = new Vector.<Sprite>;
			
			for (var i:int = 0; i < _MyPageLength ; i++) 
			{
				_CurrentChapter = _MyPage[i];
				_CurrentChapter.ShowContent();
				this._Chapter.push(_CurrentChapter);
				this._ListBoardMenuSP.push(this.ListBoardMenu(_CurrentChapter.Cover, _CurrentChapter.Data, i));
			}
			
			this._SlidingControl._Cols = 1;
			this._SlidingControl._Rows = 4;
			this._SlidingControl._MaxContains = this._SlidingControl._Cols * this._SlidingControl._Rows;
			this._SlidingControl._HorizontalInterval = 0;
			this._SlidingControl._VerticalInterval = 140;
			this._SlidingControl._RightInPosX = 0;
			this._SlidingControl._LeftInPosX = 0;
			this._SlidingControl.NextPage(this._ListBoardMenuSP , _CtrlBoolean);
			
 			this.AddBigMap(this._Chapter[this._CurrentChapterNum].Map, this._CurrentChapterNum);
			
			this._Panel.setChildIndex(this._Panel.getChildByName("MapFram"), this._Panel.numChildren - 1);
			this._Panel.setChildIndex(this._Panel.getChildByName("MonsterBox"), this._Panel.numChildren - 1);
			
			for (var j:int = 0; j < 4; j++) 
			{
				this._Panel.setChildIndex(this._Panel.getChildByName("TitleBtn" + j), (j != 3)?this._Panel.numChildren - 1:this._Panel.numChildren - 9);
				this._Panel.setChildIndex(this._Panel.getChildByName("AlphaBox" + j), this._Panel.numChildren - 1);
			}
			
			this._CurrentListBoard = this._ListBoardMenuSP[this._CurrentChapterNum];
			this._CurrentListBoard.name = this._ListBoardMenuSP[this._CurrentChapterNum].name;
			_AlphaBox=Sprite(this._Panel.getChildByName("AlphaBox" + this._CurrentListBoard.name));
			_AlphaBox.buttonMode = false;
			_AlphaBox.removeEventListener(MouseEvent.CLICK, ListBoardClickHandler);
			_AlphaBox.removeEventListener(MouseEvent.ROLL_OVER, ListBoardRollOver);
			_AlphaBox.removeEventListener(MouseEvent.ROLL_OUT, ListBoardRollOut);
			_TitleBtn = Sprite(this._Panel.getChildByName("TitleBtn" + this._CurrentListBoard.name));
			TweenLite.to(_TitleBtn, 0, { glowFilter: { color:0x66FF66, blurX:17, blurY:17, strength:3, alpha:.7 }} );
			
			this.SetFightBtn(this._Chapter[this._CurrentChapterNum].Data._areaList.length + 1);
			
			this._BasisPanel.AddCheckBtn("編輯隊伍", 280, 580 , 135, "Team");
			
			this._BasisPanel.PageData(this._PageList, this._CtrlPageNum);
		}
		//物件清單底板
		private function ListBoardMenu(_InputIcon:Sprite, _InputData:Object, _Num:int):Sprite
		{
			var _ListBoardMenu:Sprite = new Sprite();
				_ListBoardMenu.name = "" + _Num;
				
			var _Cover:Sprite = _InputIcon;
				_Cover.x = 52;
				_Cover.y = 135;
			_ListBoardMenu.addChild(_Cover);
			
			var _AlphaBox:Sprite;
			if (_InputData._accessible == false) {
				TweenLite.to(_Cover, .5, { colorMatrixFilter: { matrix : [0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0] }} );
			}else {
				_Cover.filters = [];
				_AlphaBox= Sprite(this._Panel.getChildByName("AlphaBox" + _Num));
				_AlphaBox.buttonMode = true;
				_AlphaBox.addEventListener(MouseEvent.CLICK, ListBoardClickHandler);
				_AlphaBox.addEventListener(MouseEvent.ROLL_OVER, ListBoardRollOver);
				_AlphaBox.addEventListener(MouseEvent.ROLL_OUT, ListBoardRollOut);
			}
			
			var _TitleBtnText:Text = Text(Sprite(this._Panel.getChildByName("TitleBtn" + _Num)).getChildByName("TitleBtnText" + _Num));
				_TitleBtnText.ReSetString(_InputData._name);
			
			return _ListBoardMenu;
		}
		//
		private function AddBigMap(_BigMap:Sprite, _Num:int):void 
		{
			//this._RouteLine.ClearAll();//130613
			
			this._CurrentChapter = this._Chapter[_Num];
			
			var _CurrentBigMap:Sprite = _BigMap;
				_CurrentBigMap.width = 695;
				_CurrentBigMap.height = 465;
				_CurrentBigMap.x = 280;
				_CurrentBigMap.y = 148;
				_CurrentBigMap.name = "BigMap";
			this._Panel.addChild(_CurrentBigMap);
			
			Text(this._Panel.getChildByName("Info")).ReSetString(this._CurrentChapter.Data._info);
			
			var _BigMapPt:Sprite;
			var _FightBtn:MovieClip;
			var _CurrentAreaList:ExploreArea;
			var _NextAreaList:ExploreArea;
			var _NameTag:TextField;
			
			var _LastFightBtn:MovieClip;
			
			var _LastNode:uint;
			
			for (var i:int = 1; i <= this._CurrentChapter.Data._areaList.length; i++) {
			
				_CurrentAreaList = this._CurrentChapter.Data._areaList[i - 1];
				
				
				//if ( _CurrentAreaList._accessible == false ) break;//130614
				
				_BigMapPt = (_CurrentBigMap.getChildAt(0) as Sprite ).getChildByName("P" + i) as Sprite;
				_FightBtn = new (this._BGObj.FightBtn as Class);
				_FightBtn.x = _CurrentBigMap.x + _BigMapPt.x - 20;
				_FightBtn.y = _CurrentBigMap.y + _BigMapPt.y - 20;
				_FightBtn.alpha = 0;
				_FightBtn.name = "FightBtn" + i;
				
				
				
				
					//======================================================130614	使最後可視點閃爍
					_NextAreaList = i < this._CurrentChapter.Data._areaList.length ? this._CurrentChapter.Data._areaList[ i ] : null;//130614
				
					if ( _NextAreaList != null && _CurrentAreaList._accessible == true ) {
						if ( _NextAreaList._accessible == false ) {
							this._SharedEffect.GlowFilterBrilliant(_FightBtn, true);
						}
					}
					
					//===============================================END====130614	 使最後可視點閃爍
					
					
				
					//======================================================130606	據點名稱
					_NameTag = new TextField();
					_NameTag.height = 20;
					_NameTag.text = _CurrentAreaList._name;
					_NameTag.mouseEnabled = false;
					_NameTag.x = ( _FightBtn.width - _NameTag.width ) >> 1;
					_NameTag.y = _FightBtn.height;
					_NameTag.defaultTextFormat.size = 16;
					_FightBtn.addChildAt( _NameTag , _FightBtn.numChildren - 1 );
					//============================================END=======130606	據點名稱
					
					_FightBtn.scaleX = 0.8;
					_FightBtn.scaleY = _FightBtn.scaleX;
					
					//======================================================130613  BOSS據點顯示
					if ( i >= this._CurrentChapter.Data._areaList.length) {
						_FightBtn.gotoAndStop(3);
						if (_CurrentAreaList._accessible == true && _CurrentAreaList.CoolDown == null) { 
							_FightBtn.gotoAndStop(4);
							_FightBtn.buttonMode = true;
							this._SharedEffect.MouseEffect(_FightBtn);
						}
						
						if ( _CurrentAreaList._accessible == true ) {
							TweenLite.to(_FightBtn, 1.5, { alpha:1 } );
						}
						
					}else {
						
						if (_CurrentAreaList._accessible == true && _CurrentAreaList.CoolDown == null) { 
							_FightBtn.gotoAndStop(2);
							_FightBtn.buttonMode = true;
							this._SharedEffect.MouseEffect(_FightBtn);
						}
						
						if ( _CurrentAreaList._accessible == true ) {
							TweenLite.to(_FightBtn, 1.5, { alpha:1 } );
						}
						
					}
					//======================================================130613
					
				
				/*if (_CurrentAreaList._accessible == true && _CurrentAreaList.CoolDown == null) { 
					_FightBtn.gotoAndStop(2);
					_FightBtn.buttonMode = true;
					this._SharedEffect.MouseEffect(_FightBtn);
				}*/
				this._Panel.addChild(_FightBtn);
				//TweenLite.to(_FightBtn, 1.5, { alpha:1 } );
				
				
				
				
				
				if (_CurrentAreaList.CoolDown != null) { 
					var _CoolDown:Object = _CurrentAreaList.CoolDown;
						_CoolDown._FightBtn = i;
					this.SendNotify(UICmdStrLib.SetTimeBar, _CoolDown);
				}else {
					var _TimeBar:Sprite = this._Panel.getChildByName("TimeBar" + i) as Sprite;
					if (_TimeBar  != null) {
						SingleTimerBar(_TimeBar).Close();
						this._Panel.removeChild(_TimeBar);
					}
				}
				
				//========================================================130611		路徑線
				/*if ( _LastFightBtn != null && _CurrentAreaList._accessible == true ) {
					this._RouteLine.AddRouteLine( _LastFightBtn , _FightBtn , _CurrentAreaList._accessible );
					_LastFightBtn.parent.setChildIndex( _LastFightBtn , _LastFightBtn.parent.numChildren - 1 );
					_FightBtn.parent.setChildIndex( _FightBtn , _FightBtn.parent.numChildren - 1 );
				}
				
				_LastFightBtn = _FightBtn;*/
				//===============================================END======130611		路徑線
				
				//=======================================================130611		TimeBar圖層
					
					var _TimeBarTarget:DisplayObject = this._Panel.getChildByName( "TimeBar" + i );
					if ( _TimeBarTarget != null ) {
						//this._Panel.setChildIndex( _FightBtn , this._Panel.numChildren - 1 );
						_TimeBarTarget.parent.setChildIndex( _TimeBarTarget , _TimeBarTarget.parent.numChildren - 1 );
						//this._Panel.swapChildren( _TimeBarTarget , _FightBtn );
					}
					
				//============================================END========130611
				if ( _CurrentAreaList._accessible == true ) _LastNode = i;
			}//end for
			
			this._RouteLine.RouteFinder( _BigMap , _LastNode );
			
		}
		
		
		
		
		private function SetFightBtn(_Num:int):void 
		{
			for (var i:int = 1; i < _Num; i++) 
			{
				this._Panel.setChildIndex(this._Panel.getChildByName("FightBtn" + i), this._Panel.numChildren - 1);
			}
		}
		
		private function AddStar(_FightBtn:MovieClip):void 
		{
			//this._BasisPanel.AddCheckBtn("出發", 880, 680, 85, "Departure");
			this._Panel.getChildByName("Departure").visible = true;
			var _Num:String = String(_FightBtn.name).substr(8, 1);
			var _StarBtn:MovieClip;
			this._CurrentStar = this._CurrentChapter.Data._areaList[int(_Num) - 1]._defaultDifficulty - 1;
			this._MaxStar = this._CurrentChapter.Data._areaList[int(_Num) - 1]._MaxDifficulty - 1;
			for (var i:int = 0; i < 3; i++) 
			{
				_StarBtn= new (this._BGObj.StarBtn as Class);
				_StarBtn.x = _FightBtn.x +16;
				_StarBtn.y = _FightBtn.y;
				_StarBtn.name = "StarBtn" + i;
				this._Panel.addChild(_StarBtn);
				TweenLite.to(_StarBtn, .5, { y:_StarBtn.y - 25, onComplete:MoveStar, onCompleteParams:[i,_StarBtn] } );
			}
			if (this._CurrentStar == 0) {
				MovieClip(this._Panel.getChildByName("StarBtn0")).gotoAndStop(2);
			}else if (this._CurrentStar == 1) { 
				MovieClip(this._Panel.getChildByName("StarBtn0")).gotoAndStop(2);
				MovieClip(this._Panel.getChildByName("StarBtn1")).gotoAndStop(2);
			}else if (this._CurrentStar == 2) {
				MovieClip(this._Panel.getChildByName("StarBtn0")).gotoAndStop(2);
				MovieClip(this._Panel.getChildByName("StarBtn1")).gotoAndStop(2);
				MovieClip(this._Panel.getChildByName("StarBtn2")).gotoAndStop(2);
			}
			
			if (this._MaxStar == 1) {
				_StarBtn = this._Panel.getChildByName("StarBtn1") as MovieClip;
				_StarBtn.buttonMode = true;
				_StarBtn.addEventListener(MouseEvent.ROLL_OVER, StarBtnRollOver);
				_StarBtn.addEventListener(MouseEvent.ROLL_OUT, StarBtnRollOut);
			}else if (this._MaxStar == 2) { 
				_StarBtn = this._Panel.getChildByName("StarBtn1") as MovieClip;
				_StarBtn.buttonMode = true;
				_StarBtn.addEventListener(MouseEvent.ROLL_OVER, StarBtnRollOver);
				_StarBtn.addEventListener(MouseEvent.ROLL_OUT, StarBtnRollOut);
				_StarBtn = this._Panel.getChildByName("StarBtn2") as MovieClip;
				_StarBtn.buttonMode = true;
				_StarBtn.addEventListener(MouseEvent.ROLL_OVER, StarBtnRollOver);
				_StarBtn.addEventListener(MouseEvent.ROLL_OUT, StarBtnRollOut);
			}
			
		}
		private function MoveStar(_Num:int, _StarBtn:MovieClip):void 
		{
			if (_Num == 0) TweenLite.to(_StarBtn, .5, { x:_StarBtn.x - 30, y:_StarBtn.y + 10 } );
			if (_Num == 2) TweenLite.to(_StarBtn, .5, { x:_StarBtn.x + 30, y:_StarBtn.y + 10 } );
		}
		private function RemoveStar():void 
		{
			if (this._Panel.getChildByName("StarBtn0") != null) {
				for (var i:int = 0; i < 3; i++) 
				{
					this._Panel.removeChild(this._Panel.getChildByName("StarBtn" + i));
				}
			}
		}
		private function StarBtnRollOver(e:MouseEvent):void 
		{
			var _Num:String = String(e.target.name).substr(7, 1);
			if (this._CurrentChapter.Data._areaList[int(_Num) - 1]._defaultDifficulty == 2) {
				MovieClip(e.target).gotoAndStop(2);
			}else {
				MovieClip(this._Panel.getChildByName("StarBtn1")).gotoAndStop(2);
				MovieClip(e.target).gotoAndStop(2);
			}
		}
		private function StarBtnRollOut(e:MouseEvent):void 
		{
			var _Num:String = String(e.target.name).substr(7, 1);
			if (this._CurrentChapter.Data._areaList[int(_Num) - 1]._defaultDifficulty == 2) {
				MovieClip(e.target).gotoAndStop(1);
			}else {
				if (this._CurrentStar != 1) MovieClip(this._Panel.getChildByName("StarBtn1")).gotoAndStop(1);
				MovieClip(e.target).gotoAndStop(1);
			}
		}
		private function SetStarBtn(_Num:int, _CtrlBoolean:Boolean):void 
		{
			var _StarBtn:MovieClip;
			for (var i:int = 1; i < _Num + 1; i++) 
			{
				_StarBtn = MovieClip(this._Panel.getChildByName("StarBtn" + i));
				if (_CtrlBoolean == true) {
					_StarBtn.removeEventListener(MouseEvent.ROLL_OVER, StarBtnRollOver);
					_StarBtn.removeEventListener(MouseEvent.ROLL_OUT, StarBtnRollOut);
				}else {
					if (_Num == 2) {
						_StarBtn = MovieClip(this._Panel.getChildByName("StarBtn2"));
						_StarBtn.gotoAndStop(1);
						_StarBtn.addEventListener(MouseEvent.ROLL_OVER, StarBtnRollOver);
						_StarBtn.addEventListener(MouseEvent.ROLL_OUT, StarBtnRollOut);
					}else {
						_StarBtn.gotoAndStop(1);
						_StarBtn.addEventListener(MouseEvent.ROLL_OVER, StarBtnRollOver);
						_StarBtn.addEventListener(MouseEvent.ROLL_OUT, StarBtnRollOut);
					}
				}
			}
		}
		private function onSetStarBtn():void 
		{
			var _StarBtn:MovieClip;
			for (var i:int = 1; i < 3; i++) 
			{
				_StarBtn = MovieClip(this._Panel.getChildByName("StarBtn" + i));
				_StarBtn.gotoAndStop(1);
				_StarBtn.addEventListener(MouseEvent.ROLL_OVER, StarBtnRollOver);
				_StarBtn.addEventListener(MouseEvent.ROLL_OUT, StarBtnRollOut);
			}
		}
		
		private function ListBoardClickHandler(e:MouseEvent):void 
		{
			if (this._CurrentListBoard.name != e.currentTarget.name) {
				//if (this._Panel.getChildByName("Departure") != null) this._Panel.removeChild(this._Panel.getChildByName("Departure"));
				this._Panel.getChildByName("Departure").visible = false;
				
				for (var k:int = 1; k < this._CurrentChapter.Data._areaList.length + 1; k++) 
				{
					this._Panel.removeChild(this._Panel.getChildByName("FightBtn" + k));
					if (this._Panel.getChildByName("TimeBar" + k)  != null) {
						SingleTimerBar(this._Panel.getChildByName("TimeBar" + k)).Close();
						this._Panel.removeChild(this._Panel.getChildByName("TimeBar" + k));
					}
				}
				this._Panel.removeChild(this._Panel.getChildByName("BigMap"));
				var _AlphaBox:Sprite=Sprite(this._Panel.getChildByName("AlphaBox" + this._CurrentListBoard.name));
					_AlphaBox.buttonMode = true;
					_AlphaBox.addEventListener(MouseEvent.CLICK, ListBoardClickHandler);
					_AlphaBox.addEventListener(MouseEvent.ROLL_OVER, ListBoardRollOver);
					_AlphaBox.addEventListener(MouseEvent.ROLL_OUT, ListBoardRollOut);
				var _TitleBtn:Sprite = Sprite(this._Panel.getChildByName("TitleBtn" + this._CurrentListBoard.name));
				TweenLite.to(_TitleBtn, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
				
				this._ChapterNum = -1;
				var _Num:String = String(e.target.name).substr(8, 1);
				this._CurrentChapterNum = int(_Num);
				this.AddBigMap(this._Chapter[this._CurrentChapterNum].Map, int(this._CurrentChapterNum));
				this._CurrentListBoard = this._ListBoardMenuSP[_Num];
				this._CurrentListBoard.name = this._ListBoardMenuSP[_Num].name;
				_AlphaBox=Sprite(this._Panel.getChildByName("AlphaBox" + this._CurrentListBoard.name));
				_AlphaBox.buttonMode = false;
				_AlphaBox.removeEventListener(MouseEvent.CLICK, ListBoardClickHandler);
				_AlphaBox.removeEventListener(MouseEvent.ROLL_OVER, ListBoardRollOver);
				_AlphaBox.removeEventListener(MouseEvent.ROLL_OUT, ListBoardRollOut);
				_TitleBtn = Sprite(this._Panel.getChildByName("TitleBtn" + this._CurrentListBoard.name));
				TweenLite.to(_TitleBtn, 0, { glowFilter: { color:0x66FF66, blurX:17, blurY:17, strength:3, alpha:.7 }} );
				this._Panel.setChildIndex(this._Panel.getChildByName("Team"), this._Panel.numChildren - 1);
			}
		}
		private function ListBoardRollOver(e:MouseEvent):void
		{
			var _TitleBtn:Sprite = Sprite(this._Panel.getChildByName("TitleBtn" + String(e.target.name).substr(8, 1)));
			TweenLite.to(_TitleBtn, 0, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }} );
		}
		private function ListBoardRollOut(e:MouseEvent):void
		{
			var _TitleBtn:Sprite = Sprite(this._Panel.getChildByName("TitleBtn" + String(e.target.name).substr(8, 1)));
			TweenLite.to(_TitleBtn, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
		}
		
		//加入排程時間
		public function AddTimeBar(_InputSpr:Sprite, _FightBtnNum:int):void
		{
			var _FightBtn:Sprite = this._Panel.getChildByName("FightBtn" + _FightBtnNum) as Sprite;
				_FightBtn.buttonMode
			if (this._Panel.getChildByName("TimeBar"+ _FightBtnNum)  == null) { 
				_InputSpr.x = _FightBtn.x - 117;
				_InputSpr.y = _FightBtn.y + 53;
				_InputSpr.name = "TimeBar" + _FightBtnNum;
				this._Panel.addChildAt(_InputSpr , this._Panel.numChildren - 1 );
				//this._Panel.swapChildren( _InputSpr , _FightBtn );
				//_FightBtn.addChildAt(_InputSpr , _FightBtn.numChildren - 1 );//130613
				SingleTimerBar(_InputSpr).StarTimes();
			}else {
				this._Panel.setChildIndex(this._Panel.getChildByName("TimeBar" + _FightBtnNum), this._Panel.numChildren - 1);
				//_FightBtn.setChildIndex(_FightBtn.getChildByName("TimeBar" + _FightBtnNum), _FightBtn.numChildren - 1);
			}
		}
		public function RemoveTimeBar():void 
		{
			//var _FightBtn:Sprite;
			var _TimeBar:Sprite;
			var _CurrentChapterLengrh:int = this._CurrentChapter.Data._areaList.length;
			for (var i:int = 1; i <  _CurrentChapterLengrh + 1; i++) 
			{
				//_FightBtn = this._Panel.getChildByName("FightBtn" + i) as Sprite;
				_TimeBar = this._Panel.getChildByName("TimeBar" + i) as Sprite;
				if (_TimeBar != null) SingleTimerBar(_TimeBar).Close();
			}
		}
		
		private function playerClickProcess(e:MouseEvent):void 
		{
			var _CurrentName:String = e.target.name;
			if (_CurrentName.substr(0, 1) == "F") var _Num:String = _CurrentName.substr(8, 2);
			if (_CurrentName.substr(0, 1) == "S") var _SNum:String = _CurrentName.substr(7, 1);
			switch (_CurrentName) {
				case "Departure" :
						var _Expedition:Object = [];
							_Expedition["Guid"] = this._CurrentChapter.Data._areaList[this._ChapterNum]._guid;
							_Expedition["Star"] = this._CurrentStar + 1;
						this.SendNotify(WorldJourneyStrLib.Expedition, _Expedition);
					break;
					
				case "Team" :
						this.SendNotify( WorldJourneyStrLib.Team );
					break;
				case "FightBtn" + _Num:
					var _CurrentAreaList:Object = this._CurrentChapter.Data._areaList[int(_Num) - 1];
					if (_CurrentAreaList._accessible == true && this._ChapterNum + 1 != int(_Num) && _CurrentAreaList.CoolDown == null) { 
						if (this._CurrentFightBtn != null) {
							this._CurrentFightBtn.buttonMode = true;
							this._SharedEffect.MouseEffect(this._CurrentFightBtn);
						}
						this.RemoveStar();
						this._ChapterNum = int(_Num) - 1;
						this._CurrentFightBtn = MovieClip(e.target);
						this._CurrentFightBtn.buttonMode = false;
						TweenLite.to(this._CurrentFightBtn, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
						this._SharedEffect.RemoveMouseEffect(this._CurrentFightBtn);
						this.AddStar(this._CurrentFightBtn);
					}
					break;
				case "StarBtn" + _SNum:
					if (int(_SNum) - 1 < this._MaxStar) {  
						if (this._CurrentStar == int(_SNum)) {
							this._CurrentStar = this._CurrentStar - 1;
							this.SetStarBtn(this._CurrentStar + 1, false);
						}else {
							if (this._CurrentStar == 2 && int(_SNum) == 1) {
								this._CurrentStar = 0;
								this.onSetStarBtn();
							}else {
								this._CurrentStar = int(_SNum);
								MovieClip(this._Panel.getChildByName("StarBtn" + this._CurrentStar)).gotoAndStop(2);
								this.SetStarBtn(this._CurrentStar, true);
							}
						}
					}
					break;
				case "Make"://yes
					TweenLite.to(this._viewConterBox.getChildByName("Inform"), 0.3, { x:393, y:255, scaleX:0.5, scaleY:0.5 , onComplete:RemoveInform } );
					break;
			}
		}
		//
		public function AddErrorInfor(_CrewStatus:int):void 
		{
			this._AskPanel.AddInform(1, "確定", 180, "Make");
			var _Str:String; 
			if (_CrewStatus == 1) _Str = "惡魔疲勞中";
			if (_CrewStatus == 2) _Str = "惡魔學習中";
			if (_CrewStatus == -1) _Str = "輸入type錯誤"
			if (_CrewStatus == 3) _Str = "惡魔沒血啦";
			this._AskPanel.AddMsgText(_Str, 135);
		}
		
		private function RemoveInform():void
		{
			this._AskPanel.RemovePanel();
		}
		
		override public function onRemoved():void {
			this._RouteLine.ClearAll();
			this._viewConterBox.removeEventListener( MouseEvent.CLICK , playerClickProcess );
			var _Target:DisplayObject = this._viewConterBox.getChildByName("Panel");
				_Target != null ? this._viewConterBox.removeChild( this._viewConterBox.getChildByName("Panel") ) : null;
			//this.SendNotify( ViewSystem_BuildCommands.MAINVIEW_CREAT );
			//MianViewCenter(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER)).LockAndUnlock(true);
		}
		
		public function DisablePanel():void {
			var _Target:DisplayObject = this._viewConterBox.getChildByName("Panel");
				_Target != null ? Sprite( _Target ).visible = false : null;
		}
		
		public function EnablePanel():void {
			var _Target:DisplayObject = this._viewConterBox.getChildByName("Panel");
				_Target != null ? _Target .visible = true : null;
			_Target.parent.setChildIndex( _Target , _Target.parent.numChildren - 1 );
		}
		
	}
}