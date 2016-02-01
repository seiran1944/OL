package MVCprojectOL.ViewOL.CrewView.EditBoard
{
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplayProxy;
	import MVCprojectOL.ModelOL.Vo.Troop;
	import Spark.coreFrameWork.View.ViewCtrl;
	import strLib.proxyStr.ArchivesStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class TeamShowView extends ViewCtrl
	{
		protected var _monDP:MonsterDisplayProxy;
		protected var _vecBox:Vector.<TeamHeadBox>;
		protected var _currentTroop:Troop;
		protected var _memberNum:int;
		protected var _num:int;
		protected var _boxWidGap:int;
		protected var _boxHeiGap:int;
		protected var _pBoxStart:Point;
		protected var _aryBtn:Array;
		protected var _objBtnTips:Object = { cleanBtn : "TEAM_TIP_RESET" , confirmBtn : "TEAM_TIP_SURE" , PVP : "TEAM_TIP_SET_PVP" , PVE : "TEAM_TIP_SET_PVE" , editBtn : "TEAM_TIP_EDIT" };
		
		
		public function TeamShowView(name:String,conter:DisplayObjectContainer,num:int=0):void
		{
			super(name, conter);
			this._vecBox = new Vector.<TeamHeadBox>(9);
			this._aryBtn = [];
			this._num = num;
		}
		
		public function SetBoxPlace(start:Point,widGap:int,heiGap:int):void 
		{
			this._boxWidGap = widGap;
			this._boxHeiGap = heiGap;
			this._pBoxStart = start;
		}
		
		public function set MonDsPx(msDsPx:MonsterDisplayProxy):void 
		{
			this._monDP = msDsPx;
		}
		
		// 6		3		0
		// 7		4		1
		// 8		5		2
		//要先布置頭框底板才能導入資料
		public function InSource(source:Object,dicUiStr:Dictionary , adorn:Boolean=false):void 
		{
			var board:Sprite = new (adorn ? source.EditAdorn : source.EditNone)();
			board.name = "showBoard";
			var boxPic:BitmapData = new source.CrewBox();
			var box:Sprite;
			for (var i:int = 0; i < 9; i++) 
			{
				box = this.getCrewBox(boxPic);
				box.name = "box" + String(i);
				this._vecBox[i] = new TeamHeadBox(box);//要換成素材框位置
				box.x = this._pBoxStart.x + (3 - int(i / 3) - 1) * this._boxWidGap + (3 - int(i / 3) - 1) * boxPic.width;
				box.y = this._pBoxStart.y + (i % 3) * this._boxHeiGap + (i % 3) * boxPic.height;
				board.addChild(box);
			}
			this._viewConterBox.addChild(board);
			
			if (adorn) {//EditBoard
				
				var btnClean:MovieClip = this.getDefaultBtn(source.CheckBtn, dicUiStr["BTN_TEAM_TIP_RESET"], "cleanBtn", 40, 8, 1);
				var btnConfirm:MovieClip = this.getDefaultBtn(source.CheckBtn, dicUiStr["BTN_TEAM_TIP_SURE"], "confirmBtn", 40, 8, 1);
				btnClean.width = 80;
				btnConfirm.width = 80;
				btnClean.x = this._pBoxStart.x;
				btnConfirm.x = this._pBoxStart.x + 90;
				btnClean.y = btnConfirm.y = this._pBoxStart.y +195 ;
				
				board.addChild(btnClean);
				board.addChild(btnConfirm);
				
				var txtIntro:TextField = this.getText();
				txtIntro.width = 180;
				txtIntro.wordWrap = true;
				txtIntro.text = dicUiStr["TEAM_TIP_INTRO2"];
				txtIntro.x = this._pBoxStart.x - 10;
				txtIntro.y = this._pBoxStart.y + 280;
				
				board.addChild(txtIntro);
				
			}else {//DefaultBoard
				
				var btnPvp:MovieClip = this.getDefaultBtn(source.Tab,dicUiStr["BTN_TEAM_TIP_SET_PVP"],"PVP",8,4);
				var btnPve:MovieClip = this.getDefaultBtn(source.Tab,dicUiStr["BTN_TEAM_TIP_SET_PVE"],"PVE",8,4);
				btnPvp.x = this._pBoxStart.x + 10;
				btnPve.x = this._pBoxStart.x + 100;
				btnPvp.y = btnPve.y =this._pBoxStart.y - 33;
				
				board.addChild(btnPve);
				board.addChild(btnPvp);
				this.addShiftControl(true);//ADD預設隊伍功能按鈕的內嵌屬性方法
				
				var btnEdit:MovieClip = this.getDefaultBtn(source.CheckBtn, dicUiStr["BTN_TEAM_TIP_EDIT"], "editBtn",40,8,1);
				btnEdit.width = 70;
				btnEdit.x = this._pBoxStart.x + 55;
				btnEdit.y = this._pBoxStart.y + 200;
				
				board.addChild(btnEdit);
			}
			
		}
		private function addShiftControl(on:Boolean):void 
		{
			var btn:MovieClip;
			var aryName:Array = ["PVP", "PVE"];
			
			for (var i:int = 0; i < 2; i++) 
			{
				btn = Sprite(this._viewConterBox.getChildByName("showBoard")).getChildByName(aryName[i]) as MovieClip;
				if (btn == null) break;
				if (on) {
					btn._originX = btn.x;
					btn._originY = btn.y;
					
					btn.ShiftControl = function ShiftControl(click:Boolean):void 
					{
						if (click) {
							this.x = this._originX + 2;
							this.y = this._originY + 2;
						}else{ 
							this.x = this._originX;
							this.y = this._originY;
						}
					}
				}else {
					btn._originX = null;
					btn._originY = null;
					btn.ShiftControl = null;
				}
			}
		}
		private function getDefaultBtn(classBtn:Class,word:String,name:String,X:int = 5 ,Y:int = 2,multi:int=0):MovieClip
		{
			var btn:MovieClip = new classBtn();
			var txt:TextField = this.getText();
			btn.name = name;
			btn.buttonMode = true;
			btn.mouseChildren = false;
			
			txt.width = 70;
			txt.height = 20;
			txt.text = word;
			btn.addChild(txt);
			txt.x = X;
			txt.y = Y;
			this.ListenForBtn(true, btn, multi);
			this._aryBtn.push({_target : btn , _type : multi});
			
			return btn;
		}
		private function getText():TextField
		{
			var tf:TextFormat = new TextFormat("微軟正黑體", 14, 0xCCCCCC);
			var txt:TextField = new TextField();
			txt.defaultTextFormat = tf;
			txt.selectable = false;
			return txt;
		}
		private function getCrewBox(pic:BitmapData):Sprite
		{
			var cbox:Sprite = new Sprite();
			cbox.graphics.beginBitmapFill(pic);
			cbox.graphics.drawRect(0, 0, pic.width, pic.height);
			cbox.graphics.endFill();
			cbox.mouseChildren = false;
			//20130520
			this.ListenForBtn(true, cbox, 2);
			return cbox;
		}
		
		//是否開啟 , 按鈕 , 單一CLICK  /  UP-DOWN
		protected function ListenForBtn(add:Boolean , btn:Object,multi:int):void 
		{
			var aryListen:Array;// = multi ? [MouseEvent.MOUSE_DOWN, MouseEvent.MOUSE_UP] : [MouseEvent.CLICK];
			switch (multi) 
			{
				case 0:
					aryListen = [MouseEvent.CLICK,MouseEvent.ROLL_OVER,MouseEvent.ROLL_OUT];
				break;
				case 1:
					aryListen = [MouseEvent.MOUSE_DOWN, MouseEvent.MOUSE_UP,MouseEvent.ROLL_OVER,MouseEvent.ROLL_OUT];
				break;
				case 2:
					aryListen = [MouseEvent.ROLL_OVER,MouseEvent.ROLL_OUT];
				break;
			}
			var leng:int = aryListen.length;
			for (var i:int = 0; i < leng; i++)
			{
				add ? btn.addEventListener(aryListen[i], this.ActionForBtn) : btn.removeEventListener(aryListen[i], this.ActionForBtn);
			}
		}
		
		protected function ActionForBtn(e:MouseEvent):void 
		{
			switch (e.type) 
			{
				case MouseEvent.MOUSE_UP://點選編輯按鈕
					e.target.gotoAndStop(1);
					
					switch (e.target.name) 
					{
						case "editBtn":
							if (this._currentTroop == null) {//組新隊伍的狀況
								this._currentTroop = new Troop();
								this._currentTroop._guid = "";
								this._currentTroop._teamNum = this._num;
							}
							//發送通知編輯頁面UI開啟
							this.SendNotify(ArchivesStr.CREW_EDIT_SHOW, { _num : this._num , _troop : this._currentTroop } );
						break;
						default : 
							this.EditionProcess(e.target.name);
						break;
					}
					
				break;
				case MouseEvent.MOUSE_DOWN:
					e.target.gotoAndStop(2);
				break;
				case MouseEvent.CLICK://點選預設按鈕
					if (e.target.currentFrame == 1 && this._currentTroop) {
						if (this._currentTroop._guid != "") {//避免組新隊伍編輯後卻沒有組隊
							//trace(e.target.name, "預設隊伍點選按鈕名稱")
							e.target.name == "PVP" ? this._currentTroop._isPvpTeam = true : this._currentTroop._isPveTeam = true;
							e.target.gotoAndStop(2);
							e.target.ShiftControl(true);
							//e.target.x += 2;
							//e.target.y += 2;
							//通知預設頁面UI按鈕變更與資料異動處理
							this.SendNotify(ArchivesStr.CREW_DEFAULT_CHANGE, { _num : this._num , _name : e.target.name ,_troopID : this._currentTroop._guid} );
						}
					}
				break;
				
				case MouseEvent.ROLL_OVER://可外接到CMD處理
					//trace("ROLLOVER", e.target.name);
					if (e.target.name.indexOf("box") == -1) {
						this._viewConterBox.addEventListener(MouseEvent.MOUSE_MOVE, this.ActionForBtn);
						this.SendNotify(ArchivesStr.CREW_TIPS_NOTIFY, { _type : e.type , _key : this._objBtnTips[e.target.name] , _x :  e.stageX , _y :e.stageY} );
					}
				break;
				
				case MouseEvent.ROLL_OUT://可外接到CMD處理
					//trace("ROLLOUT", e.target.name);
					this._viewConterBox.removeEventListener(MouseEvent.MOUSE_MOVE, this.ActionForBtn);
					
					this.SendNotify(ArchivesStr.CREW_TIPS_NOTIFY, { _type : e.type } );
				break;
				
				case MouseEvent.MOUSE_MOVE:
					this.SendNotify(ArchivesStr.CREW_TIPS_NOTIFY, { _type : e.type , _x :  e.stageX, _y :e.stageY} );
				break;
			}
		}
		
		//confirmBtn / cleanBtn
		protected function EditionProcess(btnName:String):void 
		{
			
		}
		
		public function ReverseDefaultBtn(btnName:String,on:Boolean=false):void 
		{
			var btn:MovieClip = Sprite(this._viewConterBox.getChildByName("showBoard")).getChildByName(btnName) as MovieClip;
			if (btn) {
				btn.gotoAndStop(on ? 2 : 1);
				btn.ShiftControl(on);
				//btn.x += on ? 2 : -2;
				//btn.y += on ? 2 : -2;
			}
			if (!on) btnName == "PVP" ? this._currentTroop._isPvpTeam = false : this._currentTroop._isPveTeam = false;
		}
		
		//初始化頭框板頭像與ID (會自動清除舊有隊伍資料)
		public function InitTeamGroup(troop:Troop,defaultView:Boolean=false):void 
		{
			if (troop == null) return ;//代表新增隊伍
			
			this.CleanTroopShow();//有舊資料就清除
			
			//按鈕預設
			if (troop._isPveTeam) this.ReverseDefaultBtn("PVE", true);
			if (troop._isPvpTeam) this.ReverseDefaultBtn("PVP", true);
			//
			
			var monGuid:String;
			var monDp:MonsterDisplay;
			for (var place:String in troop._objMember) 
			{
				monGuid = troop._objMember[place];
				monDp = this._monDP.GetMonsterDisplay(monGuid);
				monDp.ShowContent();
				this._vecBox[place].SetHeadIn(monDp.MonsterHead, monGuid, true ,defaultView);
				this._memberNum++;
			}
			
			this._currentTroop = troop;
		}
		
		public function CleanTroopShow():void 
		{
			if (this._currentTroop != null) {
				for (var place:String in this._currentTroop._objMember) 
				{
					this._vecBox[place].RemoveHead();
					this._vecBox[place].ResetValue();
				}
				this._memberNum = 0;
				this._currentTroop = null;
			}
		}
		
		public function get Content():Sprite
		{
			return this._viewConterBox as Sprite;
		}
		
		public function get TroopID():String
		{
			return this._currentTroop._guid;
		}
		
		//override public function onRemoved():void 
		//{
			//this.Destroy();
		//}
		
		public function Destroy():void 
		{
			//移除預設隊伍功能按鈕的內嵌屬性方法
			this.addShiftControl(false);
			
			this._viewConterBox.removeChildren();
			this._viewConterBox.parent.removeChild(this._viewConterBox);
			
			//頭框監聽移除
			for (var i:int = 0; i < 9; i++) 
			{
				this.ListenForBtn(false, this._vecBox[i].TargetBox, 2);
				this._vecBox[i].Destroy();
			}
			this._vecBox.length = 0;
			this._vecBox = null;
			
			//BTN監聽移除
			var leng:int = this._aryBtn.length;
			var objInfo:Object;
			for (i= 0; i < leng; i++) 
			{
				objInfo = this._aryBtn[i];
				this.ListenForBtn(false, objInfo._target, objInfo._type);
			}
			this._aryBtn.length = 0;
			this._aryBtn = null;
			
			//
			this._currentTroop = null;
			this._monDP = null;
			this._pBoxStart = null;
			this._viewConterBox = null;
			
			
		}
		
	}
	
}