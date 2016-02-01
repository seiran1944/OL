package MVCprojectOL.ViewOL.ExploreView.Journey 
{
	import com.greensock.easing.Elastic;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MotionKeyStr;
	import MVCprojectOL.ModelOL.SkillDisplayModel.CombatSkillDisplay;
	import MVCprojectOL.ModelOL.Vo.PlayerSource;
	//import MVCprojectOL.ModelOL.Vo.RouteNode;
	import MVCprojectOL.ModelOL.Vo.Explore.RouteNode;
	import MVCprojectOL.ViewOL.MainView.MainSystemPanel;
	import MVCprojectOL.ViewOL.SharedMethods.AskPanel;
	import MVCprojectOL.ViewOL.SharedMethods.ParabolaMove;
	import Spark.coreFrameWork.View.ViewCtrl;
	import Spark.SoarParticle.basic.IEffect;
	import Spark.SoarParticle.ParticleCenter;
	import Spark.Timers.TimeDriver;
	import strLib.commandStr.ExploreAdventureStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.vewStr.ViewStrLib;
	/**
	 * ...
	 * @author brook 
	 * @version 13.06.17.16.30
	 */
	public class JourneyViewCtrl extends ViewCtrl
	{
		
		private var _BGObj:Object;
		private var _JourneyObj:Object;
		private var _RouteNode:RouteNode;
		private var _MyTeam:Object;
		private var _EnemyTeam:Object;
		private var _CtrlStr:Boolean = true;
		private var _WinOrLose:Boolean;
		private var _RemoveLeftTeam:Vector.<int> = new Vector.<int>;
		private var _Chestlength:int;
		private var _AskPanel:AskPanel = new AskPanel();
		private var _StageDisplay:Sprite = new Sprite();
		
		//private var _rightSide:Boolean;//是(true)  /  否(false) 為右邊
		public const _gapWid:int = 50;//左右減少間距值
		public const _gapHei:int = 60;//上下減少間距值
		public const _picSize:int = 150;//圖檔寬高值
		
		public function JourneyViewCtrl(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			TweenPlugin.activate([GlowFilterPlugin]);
			super( _InputViewName , _InputConter );
			//this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_REMOVE); 
			this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
		}
		
		//探索第一層
		public function AddMajidanClasses(_BGObj:Object, _InputJourneyObj:Object):void
		{
			this._BGObj = _BGObj;
			this._AskPanel.AddElement(this._viewConterBox, this._BGObj);
			this._JourneyObj = _InputJourneyObj;
			this._viewConterBox.addChild(this._StageDisplay);
			this._viewConterBox.addEventListener(MouseEvent.CLICK, playerClickProcess);
		}
		public function DirectionIndicator(_RouteNode:RouteNode):void
		{
			trace("探索第一層");
			this._RouteNode = _RouteNode;
			
			/*var _Instruction:Sprite;
			var _Index:Sprite;
			for (var i:int = 0; i < this._RouteNode._newRouteList.length; i++) 
			{
				_Index = new Sprite();
				_Instruction = new (this._JourneyObj.Instruction as Class);
				_Instruction.x = 810;
				if (this._RouteNode._newRouteList.length == 1) {
					_Instruction.y = 370;
				}else {
					_Instruction.y = 220 + i * 150;
					if (i == 0)_Instruction.rotation = -15;
					if (i == 2)_Instruction.rotation = 15;
				}
				_Instruction.alpha = 0;
				_Instruction.name = "Instruction" + i;
				this._StageDisplay.addChild(_Instruction);
				
				if (this._RouteNode._newRouteList[i]._type == 1) { 
					var _DevilM:Bitmap = new Bitmap( BitmapData( new (this._JourneyObj.DevilM as Class) ) );
						_DevilM.x = _Instruction.x - 50;
						_DevilM.y = _Instruction.y - 40;
					_Index.addChild(_DevilM);
				}else if (this._RouteNode._newRouteList[i]._type == 2) { 
					var _ChestM:Bitmap = new Bitmap( BitmapData( new (this._JourneyObj.ChestM as Class) ) );
						_ChestM.x = _Instruction.x - 50;
						_ChestM.y = _Instruction.y - 40;
					_Index.addChild(_ChestM);
				}else if (this._RouteNode._newRouteList[i]._type == 3) { 
					var _CampfireM:Bitmap = new Bitmap( BitmapData( new (this._JourneyObj.CampfireM as Class) ) );
						_CampfireM.x = _Instruction.x - 50;
						_CampfireM.y = _Instruction.y - 40;
					_Index.addChild(_CampfireM);
				}
				_Index.alpha = 0;
				//_Index.buttonMode = true;
				_Index.name = "" + i;
				//this.MouseEffect(_Index);
				this._StageDisplay.addChild(_Index);
			}*/
		}
		//更新背景
		public function BackGround(_BG:BitmapData):void
		{
			if (this._StageDisplay.getChildByName("BackGround") != null) this._StageDisplay.removeChild(this._StageDisplay.getChildByName("BackGround"));
			var _BackGround:Bitmap = new Bitmap(_BG);
				_BackGround.name = "BackGround";
			this._StageDisplay.addChild(_BackGround);
		}
		//更新惡魔組隊資訊
		public function MonsterTeam(_MosterObj:Object, _Num:uint, _WinOrLose:Boolean = true):void
		{
			if (this._StageDisplay.getChildByName("StrText") != null) this._StageDisplay.removeChild(this._StageDisplay.getChildByName("StrText"));
			//判斷惡魔血量
			var _CurrentMonster:MonsterDisplay;
			var _NumLength:int;
				this._MyTeam = new Object();
				for ( var k:* in _MosterObj ) {
					_CurrentMonster = _MosterObj[ k ];
					_NumLength = this._RemoveLeftTeam.length;
					if (_Num == 5) {
						if (this._RemoveLeftTeam.length != 0)for (var l:int = 0; l < _NumLength; l++) 
						{
							if ( k != int(this._RemoveLeftTeam[l]) ) {
								this._MyTeam[ k ] = _CurrentMonster;
							}else {
								this._MyTeam[ k ] = null;
								l = _NumLength;
							}
						}else {
							this._MyTeam[ k ] = _CurrentMonster;
						}
					}else {
						( _CurrentMonster.MonsterData._nowHp > 0) ?this._MyTeam[ k ] = _CurrentMonster:this._RemoveLeftTeam.push(k);
					}
				}	
			
			//_Num:0.沒事, 1.惡魔, 2.寶箱, 3.安全, 4.魔王 , 5.更新惡魔數值
			if (_Num == 5) this._StageDisplay.removeChild(this._StageDisplay.getChildByName("left"));
			var _LeftMonsterTeam:Sprite = new Sprite();
			var _MonsterBody:Sprite;
			var _MonsterBodyShadow:Bitmap;
			var _Locate:Point;
			var _MonsterBodyAry:Array = [];
				_MonsterBodyAry.push("left");
				_LeftMonsterTeam.x = 187;
				_LeftMonsterTeam.y = 275;
				_LeftMonsterTeam.name = "left";
			this._StageDisplay.addChild(_LeftMonsterTeam);
			for ( var i:* in _MyTeam ) {
				if (_MyTeam[i] == null) continue;
				_Locate = this.GetMonsterLocate( i , false );
				_CurrentMonster = _MyTeam[i];
				_CurrentMonster.Motion.Direction = true;//方向
				_CurrentMonster.Motion.Act(MotionKeyStr.Idle);
				_MonsterBody = _CurrentMonster.MonsterBody;
				_MonsterBody.scaleX = _CurrentMonster.MonsterData._size;
				_MonsterBody.scaleY =  _CurrentMonster.MonsterData._size;
				(_Num == 5)?_MonsterBody.x = _Locate.x - _MonsterBody.width / 2 - 12:_MonsterBody.x = -500;
				_MonsterBody.y = _Locate.y - _MonsterBody.height / 2;
				_MonsterBody.name = "Body" + i;
				_LeftMonsterTeam.addChild(_MonsterBody);
				if (_Num != 5) {
					for (var j:int = 0; j < 3; j++) 
					{
						_MonsterBodyShadow = this.shadowFactory(true, _MonsterBody);
						_MonsterBodyShadow.x = -30;
						_MonsterBodyShadow.name = "Shadow" + j;
						_MonsterBody.addChild(_MonsterBodyShadow);
						_MonsterBody.setChildIndex(_MonsterBodyShadow, 0);
					}
					TweenLite.to(_MonsterBody, .7, { x:_Locate.x - _MonsterBody.width / 2 , delay:0.1 * i , onComplete:RemoveShadow, onCompleteParams:[_MonsterBody] } );
				}else {
					if (_WinOrLose == true && _CurrentMonster.MonsterData._nowHp <= 0) { 
						_CurrentMonster.Motion.Act(MotionKeyStr.Dead);//惡魔死亡
						_MonsterBodyAry.push(_MonsterBody);
					}
					//this.MonsterDeadShow(_MonsterBody);//爆炸惡魔
					//TimeDriver.RemoveDrive(function);
				}
			}
			
			this.resetMonsterLayer(this._MyTeam, "left");
			//if (_Num == 0) TweenLite.to(_LeftMonsterTeam, 1.5, { x:_LeftMonsterTeam.x, onComplete:ShowIndex } );
			if (_Num == 1) TweenLite.to(_LeftMonsterTeam, 1.5, { x:_LeftMonsterTeam.x, onComplete:ShowInform } );
			//if (_Num == 2) TweenLite.to(_LeftMonsterTeam, 1.5, { x:_LeftMonsterTeam.x, onComplete:Chest } );
			//if (_Num == 3) TweenLite.to(_LeftMonsterTeam, 1.5, { x:_LeftMonsterTeam.x, onComplete:SendBackBlood } );
			if (_Num == 5) TimeDriver.AddDrive(500, 1, this.MonsterDeadShow, [_MonsterBodyAry]);//延時惡魔爆炸效果
		}
		//顯示箭頭索引
		public function ShowIndex(_CtrlBoolean:Boolean = false):void
		{
			var _Instruction:Sprite;
			var _Index:Sprite;
		//	(_CtrlBoolean == false)?this._StageDisplay.addEventListener(MouseEvent.CLICK, playerClickProcess):this._StageDisplay.removeEventListener(MouseEvent.CLICK, playerClickProcess);
			for (var i:int = 0; i < this._RouteNode._newRouteList.length; i++) 
			{
				_Instruction = Sprite(this._StageDisplay.getChildByName("Instruction" + i));
				_Index = Sprite(this._StageDisplay.getChildByName("" + i));
				if (_Instruction != null) {
					if (_CtrlBoolean == false) {
						this._StageDisplay.setChildIndex(_Instruction, this._StageDisplay.numChildren - 1);
						this._StageDisplay.setChildIndex(_Index, this._StageDisplay.numChildren - 1);
						_Instruction.alpha = 1;
						_Index.alpha = 1;
						_Index.buttonMode = true;
						this.MouseEffect(_Index);
					}else {
						_Instruction.alpha = 0;
						_Index.alpha = 0;
					}
				}
			}
		}
		//判斷勝負結果
		public function WinOrLose(_WinOrLose:Boolean):void
		{
			//trace(_WinOrLose, "@@@@@@@@@");
			this._WinOrLose = _WinOrLose;
			var _MonsterBodyAry:Array = [];
			if (_WinOrLose == false) {
				_MonsterBodyAry.push("left");
				for ( var j:* in this._MyTeam ) {
					if (this._MyTeam[j] == null) continue;
					_MonsterBodyAry.push(this._MyTeam[j].MonsterBody);
				}
				(_MonsterBodyAry.length > 1)?this.RightMonsterDeadShow(_MonsterBodyAry):this.EndNode();
			}else {
				_MonsterBodyAry.push("right");
				for ( var i:* in this._EnemyTeam ) _MonsterBodyAry.push(this._EnemyTeam[i].MonsterBody);
				(_MonsterBodyAry.length == 1)?this.NextNode():this.RightMonsterDeadShow(_MonsterBodyAry);
			}
			this.SendNotify(ExploreAdventureStrLib.Chest);
		}
		//是否觀看戰鬥詢問面板
		private function ShowInform():void
		{
			this._AskPanel.AddInform();
			this._AskPanel.AddMsgText("是否觀看戰鬥畫面!?", 115);
		}
		
		private function playerClickProcess(e:MouseEvent):void
		{
			switch(e.target.name)
			{
				case "Make0":
					this.SendNotify( ExploreAdventureStrLib.BattleStart);
					this.RemoveInform("Yes");
				break;
				case "Make1":
					TweenLite.to(this._viewConterBox.getChildByName("Inform"), 0.3, { x:385, y:195, scaleX:0.5, scaleY:0.5 , onComplete:RemoveInform } );
				break;
			}
		}
		
		//敵人隊伍
		public function EnemyMonsterTeam(_MosterObj:Object, _Str:String):void
		{
			var _StrText:TextField = new TextField();
				_StrText.text = _Str;
				_StrText.width = 500;
				_StrText.x = 500;
				_StrText.y = 550;
				_StrText.name = "StrText";
			this._StageDisplay.addChild(_StrText);
			
			var _Index:Sprite;
			for (var j:int = 0; j < this._RouteNode._newRouteList.length; j++) 
			{
				_Index = Sprite(this._StageDisplay.getChildByName("" + j));
				_Index.buttonMode = false;
				this.RemoveMouseEffect(_Index);
			}
			
			var _RightMonsterTeam:Sprite = new Sprite();
			var _CurrentMonster:MonsterDisplay;
			var _MonsterBody:Sprite;
			var _Locate:Point;
			this._EnemyTeam = _MosterObj;
			for ( var i:* in _MosterObj ) {
				_CurrentMonster = _MosterObj[i];
				_CurrentMonster.ShowContent();
				_CurrentMonster.Motion.Direction = false;//方向
				_MonsterBody = _CurrentMonster.MonsterBody;
				_MonsterBody.scaleX = _CurrentMonster.MonsterData._scaleRate;
				_MonsterBody.scaleY = _CurrentMonster.MonsterData._scaleRate;
				_Locate = this.GetMonsterLocate( i , true );
				_MonsterBody.x = _Locate.x - _MonsterBody.width / 2;
				_MonsterBody.y = _Locate.y - _MonsterBody.height / 2;
				_MonsterBody.name = "Body" + i;
				_RightMonsterTeam.addChild(_MonsterBody);
			}
			_RightMonsterTeam.x = 675;
			_RightMonsterTeam.y = 275;
			_RightMonsterTeam.name = "right";
			this._StageDisplay.addChild(_RightMonsterTeam);
			this.resetMonsterLayer(_MosterObj, "right");
			//TimeDriver.AddDrive(1000, 1, this.RightMonsterDeadShow, [_MonsterBodyAry]);
			//TweenLite.to(_RightMonsterTeam, 1, { x:920 } );
		}
		//戰鬥死亡移除
		public function MonsterDead(_MonsterObj:Object):void
		{ 
			this._CtrlStr = true;
			var _RightTeam:Sprite = Sprite(this._StageDisplay.getChildByName("right"));
			var _LeftTeam:Sprite = Sprite(this._StageDisplay.getChildByName("left"));
			if (_MonsterObj != null && _MonsterObj["right"] != null) {
				for (var i:int = 0; i < _MonsterObj["right"].length; i++) { 
					delete this._EnemyTeam[ String(_MonsterObj["right"][i]) ];
					_RightTeam.removeChild(_RightTeam.getChildByName("Body" + String(_MonsterObj["right"][i])));
				}	
			}
			if (_MonsterObj != null && _MonsterObj["left"] != null) {
				for (var j:int = 0; j < _MonsterObj["left"].length; j++) { 
					//delete this._MyTeam[ String(_MonsterObj["left"][j]) ];
					//this._MyTeam[ String(_MonsterObj["left"][j]) ] = null;
					_LeftTeam.removeChild(_LeftTeam.getChildByName("Body" + String(_MonsterObj["left"][j])));
					this._RemoveLeftTeam.push(int(_MonsterObj["left"][j]));
				}
			}
		}
		//移除
		public function RemoveInform(_InputStr:String = "No", _CtrlBoolean:Boolean = true):void
		{
			this._AskPanel.RemovePanel();
			var _NotifyPack:Object = { };
				_NotifyPack._status = "CLOSE";
			if (_CtrlBoolean == true) (_InputStr == "Yes")?/*this.ShowIndex(true)*/null:this.SendNotify( ExploreAdventureStrLib.ExploreBattleEvent, _NotifyPack );
		}
		
		// 6		3		0 // 0		3		6
		// 7		4		1 // 1		4		7
		// 8		5		2 // 2		5		8
		//左右兩邊皆可
		//此為容器內的怪物位置,容器放置於大場景上的位置要另外控制
		private function GetMonsterLocate(place:int , _rightOrLeft:Boolean = false ):Point
		{
			var locate:Point = new Point();
			var xShift:int = !_rightOrLeft ? 2 - int(place / 3 ) : int(place / 3 );
			locate.x =  xShift * (this._picSize-this._gapWid);
			locate.y = (place % 3 ) * (this._picSize - this._gapHei);
			return locate;	
		}
		//	6		3		0
		//	7		4		1
		//	8		5		2
		//怪物body的實體name有特例化處理會帶有該惡魔位置
		private function resetMonsterLayer(_MonsterTeamDisplay:Object, _TeamName:String):void 
		{
			var monster:DisplayObject;
			var count:int;
			var aryPosition:Array= [6, 3, 0, 7, 4, 1, 8, 5, 2];//可自訂調整低至高LAYER
			
			//(_TeamName == "LeftTeam")?aryPosition = [6, 3, 0, 7, 4, 1, 8, 5, 2]:aryPosition = [0, 3, 6, 1, 4, 7, 2, 5, 8];
			
			var _currentContainer:Sprite = Sprite(this._StageDisplay.getChildByName(_TeamName));
			for (var i:int = 0; i < aryPosition.length; i++)
			{
				count = aryPosition[ i ];
				monster = ( _MonsterTeamDisplay[ count ] != null ) ? _MonsterTeamDisplay[ count ].MonsterBody : null;
				if (monster != null) _currentContainer.setChildIndex(monster, _currentContainer.numChildren - 1 );
			}
		}
		
		//調整過的殘影產生器
		//rightSide為是(TRUE) / 否(FALSE) 為場景右邊面向
		//monsterBody為怪物Display.Body (實體)
		//移動前先把移動實體匯入 會回傳殘影圖檔
		//移動時殘影圖像可生成在實體影像後方跟著移動
		//移動結束後將殘影圖像移除即可
		private function shadowFactory(rightSide:Boolean , monsterBody:DisplayObject):Bitmap 
		{
			var bmBody:Bitmap;
			
			var bmdShadow:BitmapData = new BitmapData(monsterBody.width, monsterBody.height, true, 0);

				var mx:Matrix = new Matrix(1, 0, 0, 1, 0, 0);

				var colorTf:ColorTransform = new ColorTransform(1, 1, 1, .25);

				bmdShadow.draw(monsterBody, mx, colorTf, null);

				mx.tx = rightSide ? 20 : -20;

				bmdShadow.draw(monsterBody, mx, colorTf, null);

				mx.tx = rightSide ? 40 : -40;

				bmdShadow.draw(monsterBody, mx, colorTf, null);

				bmBody = new Bitmap(bmdShadow);
				
			return bmBody;
		}
		private function RemoveShadow(_MonsterBody:Sprite):void 
		{
			for (var i:int = 0; i < 3; i++) _MonsterBody.removeChild(_MonsterBody.getChildByName("Shadow" + i));
			//this.MonsterDeadShow(_MonsterBody);
		}
		//放入需要被爆破的實體
		//可先將場景實體隱藏,並將其實體匯入此function
		//會直接在原實體同位置壓上炸裂效果
		//炸裂後視狀況處理場景上的實體與效果物件移除相關操作
		//若需等待炸裂完成後動作 則須在通知處做接續動作處理
		private function MonsterDeadShow(monsterBody:Array):void 
		{
			var _TeamName:Sprite = Sprite(this._StageDisplay.getChildByName(String(monsterBody[0])));
				
			for (var i:int = 1; i < monsterBody.length; i++) 
			{
				
				var monsterPic:BitmapData = new BitmapData(monsterBody[i].width, monsterBody[i].height, true, 0);
				
				monsterPic.draw(monsterBody[i], new Matrix(monsterBody[i].scaleX, 0, 0, monsterBody[i].scaleY));

				var smashParticle:IEffect = ParticleCenter.GetInstance().GetParticleByKey("0002", monsterPic);

				_TeamName.removeChild(monsterBody[i]);
				
				this._StageDisplay.addChild(smashParticle as DisplayObject);

				smashParticle.x = _TeamName.x + monsterBody[i].x;

				smashParticle.y = _TeamName.y + monsterBody[i].y;

				smashParticle.Start();
				
			}
			//炸裂結束後的通知註冊,視需要而定
			//if (monsterBody.length > 1) ParticleCenter.GetInstance().RegisterParticle(smashParticle, smashParticleFin);
		}
		//炸裂結束後的通知
		private function smashParticleFin(target:DisplayObject = null):void
		{
			this.NextNode();
		}
		
		private function NextNode():void
		{
			if (this._CtrlStr == true){
				if (this._WinOrLose == false) {
					
				}else {
					var _CurrentTarget:DisplayObject = this._StageDisplay.getChildByName("right");//130307 KJ ARIS
						_CurrentTarget != null ? this._StageDisplay.removeChild( _CurrentTarget ) : null;//130307 KJ ARIS
				}
				//this.ShowIndex(false);
				this.SendNotify( ExploreAdventureStrLib.NextNode );
			}
			this._CtrlStr = false;
		}
		public function EndNode():void
		{
			this.SendNotify( ExploreAdventureStrLib.NextNode );
		}
		
		private function RightMonsterDeadShow(monsterBody:Array):void 
		{
			var _TeamName:Sprite = Sprite(this._StageDisplay.getChildByName(String(monsterBody[0])));
				
			for (var i:int = 1; i < monsterBody.length; i++) 
			{
				var monsterPic:BitmapData = new BitmapData(monsterBody[i].width, monsterBody[i].height, true, 0);

				monsterPic.draw(monsterBody[i], new Matrix(monsterBody[i].scaleX, 0, 0, monsterBody[i].scaleY));

				var smashParticle:IEffect = ParticleCenter.GetInstance().GetParticleByKey("0002", monsterPic);

				_TeamName.removeChild(monsterBody[i]);
				
				this._StageDisplay.addChild(smashParticle as DisplayObject);

				smashParticle.x = _TeamName.x + monsterBody[i].x;

				smashParticle.y = _TeamName.y + monsterBody[i].y;

				smashParticle.Start();
			}
			//炸裂結束後的通知註冊,視需要而定
			if (monsterBody.length > 1) ParticleCenter.GetInstance().RegisterParticle(smashParticle, smashParticleFin);
			
			setTimeout( this.smashParticleFin , 2000 );	//130614 強制跳出戰鬥表
		}
		//升級效果
		public function LvUpData(_DataAry:Array):void 
		{
			var _CurrentMonster:Object;
				for (var j:int = 0; j < _DataAry.length; j++) {
					if ( this._MyTeam != null ) {//130611 K.J. Aris
						for ( var i:* in _MyTeam ) {
							if (MonsterDisplay(this._MyTeam[i]).MonsterData._guid == _DataAry[j]) {
								_CurrentMonster= new Object();
								_CurrentMonster["Monster"] = this._MyTeam[i];
								_CurrentMonster["Property"] = 2;
								this.SendNotify(ExploreAdventureStrLib.BackBlood, _CurrentMonster);
							}
						}
					}
				}
		}
		
		//寶箱
		private function Chest():void
		{
			this.SendNotify(ExploreAdventureStrLib.Chest);
		}
		public function ShowChest(_ChestAry:Array):void
		{
			this._Chestlength = _ChestAry.length;
			var _CurrentItem:ItemDisplay;
			var Icon:Sprite;
			if (_ParabolaMove == null) var _ParabolaMove:ParabolaMove = new ParabolaMove();
			for (var i:int = 0; i < _ChestAry.length; i++) 
			{
				_CurrentItem = _ChestAry[i];
				_CurrentItem.ShowContent();
				Icon = _CurrentItem.ItemIcon;
				Icon.scaleX = 0.7;
				Icon.scaleY = 0.7;
				Icon.x = 600;
				Icon.y = 350;
				this._StageDisplay.addChild(Icon);
				( _CurrentItem.ItemData is PlayerSource ) ?
					_ParabolaMove.AddElement(Icon, _CurrentItem.ItemData._buildSourceType, this._Chestlength)
					:
					_ParabolaMove.AddElement(Icon, 9 , this._Chestlength);
				
				setTimeout( Icon.dispatchEvent , 800 , new MouseEvent( MouseEvent.ROLL_OVER ) );
			}
		}
		public function RemoveChest():void
		{
			for (var i:int = 0; i < 4; i++) if (this._StageDisplay.getChildByName("Icon" + i) != null) this._StageDisplay.removeChild(this._StageDisplay.getChildByName("Icon" + i));
		}
		
		//回血
		private function SendBackBlood():void
		{
			var _CurrentMonster:Object;
			for ( var j:* in this._MyTeam ) {
				_CurrentMonster= new Object();
				_CurrentMonster["Monster"] = this._MyTeam[j];
				_CurrentMonster["Property"] = 1;
				this.SendNotify(ExploreAdventureStrLib.BackBlood, _CurrentMonster);
			}
		}
		public function ShowBackBlood(_CurrentMonster:MonsterDisplay, _CombatSkillDisplay:CombatSkillDisplay):void
		{
			var _LeftTeam:Sprite = this._StageDisplay.getChildByName("left") as Sprite;
			if ( _CombatSkillDisplay != null ) {
				var _currentEffectBody:Sprite = _CombatSkillDisplay.Body as Sprite;
				this._StageDisplay.addChild(_currentEffectBody);
				_currentEffectBody.scaleX = 0.6;
				_currentEffectBody.scaleY = 0.6;
				_currentEffectBody.x = _LeftTeam.x + _CurrentMonster.MonsterBody.x;
				_currentEffectBody.y = _LeftTeam.y + _CurrentMonster.MonsterBody.y - ((_currentEffectBody.height - _CurrentMonster.MonsterBody.height) / 2);
				_CombatSkillDisplay.Motion != null ? _CombatSkillDisplay.Motion.Act() : null;//130614
			}
			
			//this.ShowIndex();
		}
		
		//滑鼠效果
		private function MouseEffect(btn:*):void
		{
			btn.addEventListener(MouseEvent.ROLL_OVER, BtnEffect);
			btn.addEventListener(MouseEvent.ROLL_OUT, BtnEffect);
			if (Sprite(btn).name != "YesBtn" && Sprite(btn).name != "NoBtn")btn.addEventListener(MouseEvent.CLICK, BtnEffect);
		}
		private function BtnEffect(e:MouseEvent):void 
		{
			switch (e.type) 
			{
				case "rollOver":
					TweenLite.to(e.target, 0, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }} );
				break;
				case "rollOut":
					TweenLite.to(e.target, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
				break;
				/*case "click":
					var _Index:Sprite;
					for (var j:int = 0; j < this._RouteNode._newRouteList.length; j++) 
					{
						_Index = Sprite(this._StageDisplay.getChildByName("" + j));
						_Index.buttonMode = false;
						this.RemoveMouseEffect(_Index);
					}
					this.onRemove();
					this._RemoveLeftTeam.length = 0;
					this._CtrlStr = true;
					if (int(e.currentTarget.name) != 0) {
						this.SendNotify( ExploreAdventureStrLib.NextNode );
					}
					var _RouteNode:Object = new Object();
						_RouteNode["SelectedNode"] = this._RouteNode._newRouteList[int(e.currentTarget.name)];
					this.SendNotify(ExploreAdventureStrLib.ExploreAdventureView_SelectRoute, _RouteNode);
				break;*/
			}
		}
		private function RemoveMouseEffect(btn:*):void
		{
			btn.removeEventListener(MouseEvent.ROLL_OVER, BtnEffect);
			btn.removeEventListener(MouseEvent.ROLL_OUT, BtnEffect);
			btn.removeEventListener(MouseEvent.CLICK, BtnEffect);
		}
		
		public function onRemove():void
		{
			for (var i:int = 0; i < this._RouteNode._newRouteList.length; i++) {
				this._StageDisplay.removeChild(this._StageDisplay.getChildByName("Instruction" + i));
				this._StageDisplay.removeChild(this._StageDisplay.getChildByName("" + i));
			}
			this._StageDisplay.removeChild(this._StageDisplay.getChildByName("left"));
			
			//while (this._StageDisplay.numChildren>0) this._StageDisplay.removeChildAt(0);
		}
		
		override public function onRemoved():void 
		{	
			this._RemoveLeftTeam.length = 0;
			this._viewConterBox.removeEventListener(MouseEvent.CLICK, playerClickProcess);
			//while (this._StageDisplay.numChildren > 0) this._StageDisplay.removeChildAt(0);
			this._StageDisplay.removeChildren();
			//this.SendNotify( ViewSystem_BuildCommands.MAINVIEW_SwitchReady );
			//this.SendNotify( ViewSystem_BuildCommands.MAINVIEW_REMOVE );
			//this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_CREAT);	
			//MainSystemPanel(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.Panel_Main)).UseprotectedFunction("ExploreBack");
		}
		
	}
}