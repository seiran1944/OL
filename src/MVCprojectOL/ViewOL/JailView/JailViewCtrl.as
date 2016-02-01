package MVCprojectOL.ViewOL.JailView 
{
	import com.greensock.easing.Back;
	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import MVCprojectOL.ViewOL.SharedMethods.AssemblyDevilInforPanel;
	import MVCprojectOL.ViewOL.SharedMethods.SlidingControl;
	import Spark.coreFrameWork.View.ViewCtrl;
	import strLib.commandStr.UICmdStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	/**
	 * ...
	 * @author brook
	 */
	public class JailViewCtrl extends ViewCtrl
	{
		private var _DisplayBox:DisplayObjectContainer;
		private var _BGObj:Object;
		private var _JailObj:Object;
		private var _CtrlPageNum:int = 0;
		private var _SlidingControl:SlidingControl;
		private var MonsterMenuSP:Vector.<Sprite>;
		
		private var _TortureGame:TortureGame;
		
		public function JailViewCtrl(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			super( _InputViewName , _InputConter );
			this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_REMOVE); 
			this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
			this._DisplayBox = _InputConter;
			
			var _SlidingContainer:Sprite = new Sprite();
				_SlidingContainer.name = "SlidingContainer";
				this._SlidingControl = new SlidingControl( _SlidingContainer );
			this._DisplayBox.addChild( _SlidingContainer );
		}
		
		public function BackGroundElement(_InputJailObj:Object, _InputObj:Object):void
		{
			this._BGObj = _InputObj;
			this._JailObj = _InputJailObj;
			
			this.OneLayer();
		}
		//牢房第一層
		public function OneLayer():void
		{
			var _JailLayer:Object = new Object();
				_JailLayer["Layer"] = 1;
			this.SendNotify( UICmdStrLib.JailLayer, _JailLayer);
			
			var _NPC:MovieClip = new (this._JailObj.JailNPC as Class);
				_NPC.name = "NPC";
				_NPC.x = 665;
				_NPC.y = 215;
			this._viewConterBox.addChild(_NPC);
			//TweenLite.to(_NPC, 0.7, { x:665, ease:Back.easeOut } );
			
			for (var i:int = 0; i < 2; i++) 
			{
				var pageBtnN:MovieClip = new (this._BGObj.pageBtnN as Class);
					pageBtnN.x = 56 + 589 * i;
					pageBtnN.y = 315;
					pageBtnN.name = "btn" + i;
					pageBtnN.buttonMode = true;
					pageBtnN.gotoAndStop(3);
					if (pageBtnN.name =="btn0") {
						pageBtnN.scaleX = -1;
					}
					/*if (this._PageList.length > 1) {
						pageBtnN.addEventListener(MouseEvent.CLICK, _onClickHandler , false , 0 , true );
						pageBtnN.addEventListener(MouseEvent.ROLL_OVER, _onRollOverBtnHandler , false , 0 , true );
						pageBtnN.addEventListener(MouseEvent.ROLL_OUT, _onRollOutBtnHandler , false , 0 , true );
						if (pageBtnN.name == "btn1") pageBtnN.gotoAndStop(1);
					}*/
				this._viewConterBox.addChild(pageBtnN);
			}
			
			this.CtrlPage(this._CtrlPageNum , false );
		}
		
		private function CtrlPage( _InputPage:int , _CtrlBoolean:Boolean ):void
		{
			this.MonsterMenuSP = new Vector.<Sprite>;
			
			for (var i:int = 0; i < 6 ; i++) {
				this.MonsterMenuSP.push(this.AssemblyMonsterMenu(null, null) );
				this.MonsterMenuSP[i].addEventListener(MouseEvent.CLICK, _onBoardClickHandler);
			}
			this._SlidingControl._Cols = 3;
			this._SlidingControl._Rows = 2;
			this._SlidingControl._MaxContains = this._SlidingControl._Cols * this._SlidingControl._Rows;
			this._SlidingControl._HorizontalInterval = 190;
			this._SlidingControl._VerticalInterval = 240;
			this._SlidingControl._RightInPosX = 450;
			this._SlidingControl._LeftInPosX = -50;
			this._SlidingControl.NextPage(this.MonsterMenuSP, _CtrlBoolean);
		}
		
		private function AssemblyMonsterMenu(_InputBody:Sprite = null, _InputData:Object = null):Sprite
		{
			var _DisplayMonsterMenu:Sprite = new Sprite();
			var _Board:Sprite = new (this._JailObj.Board as Class);
				_Board.x = 70;
				_Board.y = 100;
				_Board.buttonMode = true;
			_DisplayMonsterMenu.addChild(_Board);
			
			var _AssemblyElement:AssemblyDevilInforPanel = new AssemblyDevilInforPanel;
			(_InputBody != null ) ?
				_AssemblyElement.MonsterInformationPage(_Board,_InputData._showName,_InputData._lv,_InputData._atk,_InputData._def,_InputData._speed,_InputData._Int,_InputData._mnd,"",_InputData._nowHp,_InputData._maxHP,_InputData._nowEng,_InputData._maxEng,_InputData._nowExp,_InputData._maxExp)
			:
				_AssemblyElement.MonsterInformationPage(_Board, "IDLE", "", "", "", "", "", "", "", 0, 0, 0, 0, 0, 0);
			
			return _DisplayMonsterMenu;
		}
		
		private function _onBoardClickHandler(e:MouseEvent):void
		{
			this.RemoveOneLayer();
			this.SecondLayer();
		}
		private function RemoveOneLayer():void
		{
			this._viewConterBox.removeChild(this._viewConterBox.getChildByName("btn0"));
			this._viewConterBox.removeChild(this._viewConterBox.getChildByName("btn1"));
			this._viewConterBox.removeChild(this._viewConterBox.getChildByName("NPC"));
			this._SlidingControl.ClearStage(true);
		}
		
		//牢房第二層 拷打遊戲
		private function SecondLayer():void
		{
			var _JailLayer:Object = new Object();
				_JailLayer["Layer"] = 2;
			this.SendNotify( UICmdStrLib.JailLayer, _JailLayer);
			
			var _NPC:MovieClip = new (this._JailObj.TortureNPC as Class);
				_NPC.name = "NPC";
				_NPC.x = 530;
				_NPC.y = 90;
			this._viewConterBox.addChild(_NPC);
			
			this._TortureGame = new TortureGame(this._viewConterBox, this._JailObj, this._BGObj, 150);//拷打遊戲
		}
		
		public function RemoveSecondLayer():void
		{
			
		}
		
		override public function onRemoved():void 
		{
			while (this._viewConterBox.numChildren>0) 
			{
				this._viewConterBox.removeChildAt(0);
			}
			this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_CREAT);
		}
		
	}
}