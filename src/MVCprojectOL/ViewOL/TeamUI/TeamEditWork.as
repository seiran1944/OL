package MVCprojectOL.ViewOL.TeamUI
{
	import com.greensock.plugins.ColorMatrixFilterPlugin;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class TeamEditWork extends TeamBasic
	{
		private var _spShift:Sprite;
		private var _spEdit:Sprite;
		private var _btnLeft:MovieClip;
		private var _btnRight:MovieClip;
		private var _currentBox:MovieClip;
		private const _editLimit:int = 5;
		private var _editCurrent:int;
		private var _teamID:String;
		private var _aryCurrentMember:Array;
		private var _aryRemoveMember:Array;
		private var _dicCurrentGray:Dictionary;
		//private var _dicCurrentPage:Dictionary;//記錄當頁有的怪物ID
		
		
		public function TeamEditWork():void 
		{
			TweenPlugin.activate([GlowFilterPlugin, ColorMatrixFilterPlugin]);
			this._spShift = new Sprite();
			addChild(this._spShift);
		}
		
		
		override public function AddSource(objSource:Object):void
		{
			//編輯頭像面板處理
			this._spEdit = new objSource["editBoard"];
			this._spEdit.name = "userEdit";
			addChild(this._spEdit);
			this._spEdit.y = this.Hei >> 3;
			this._spEdit.x = this.Wid - this.width;
			var spBox:Sprite;
			for (var i:int = 0; i < 9; i++) 
			{
				//Sprite(this._spEdit.getChildByName("box" + String(i))).mouseChildren = false;
				spBox = this._spEdit.getChildByName("box" + String(i)) as Sprite;
				spBox.mouseChildren = false;
				spBox.buttonMode = true;
			}
			
			
			//翻頁按鈕處理
			this._btnLeft = new objSource["pageBtnN"];
			this._btnRight = new objSource["pageBtnN"];
			this._btnLeft.name = "monsterLeft";
			this._btnRight.name = "monsterRight";
			this._btnLeft.buttonMode = true;
			this._btnRight.buttonMode = true;
			this.btnFactory(this._btnLeft);
			this.btnFactory(this._btnRight);
			this._btnLeft.scaleX = -this._btnLeft.scaleX;
			this._btnRight.x = this._spEdit.x - this._btnRight.width*2;
			this._btnLeft.x = this._btnLeft.width * 2.5;
			this._btnRight.y = this._btnLeft.y = (this.Hei >> 1) - (this._btnLeft.height * .8);
			addChild(this._btnLeft);
			addChild(this._btnRight);
			
			
		}
		
		public function SetBoardMonster(place:uint,head:DisplayObject):void 
		{
			var box:MovieClip = this._spEdit.getChildByName("box" + place) as MovieClip;
			this.cleanHeadBox(box);
			box.addChild(head);
		}
		
		
		private function btnFactory(btn:MovieClip,remove:Boolean=false):void 
		{
			
			var aryListen:Array = [MouseEvent.ROLL_OVER, MouseEvent.ROLL_OUT, MouseEvent.MOUSE_DOWN, MouseEvent.MOUSE_UP];
			var leng:int = aryListen.length;
			
			for (var i:int = 0; i < leng; i++) 
			{
				btn[(!remove ? "addEventListener" : "removeEventListener")](aryListen[i], btnStatus);
			}
			
		}
		
		private function btnStatus(e:MouseEvent):void 
		{
			switch (e.type) 
			{
				case "rollOver":
					e.target.gotoAndStop(2);
				break;
				case "rollOut":
					e.target.gotoAndStop(1);
				break;
				case "mouseUp":
					e.target.gotoAndStop(1);
				break;
				case "mouseDown":
					e.target.gotoAndStop(3);
				break;
			}
		}
		
		public function LimitShow(type:String):void 
		{
			//可替換效果
			switch (type) 
			{
				case "left":
					this._btnLeft.visible = false;
				break;
				case "right":
					this._btnRight.visible = false;
				break;
				case "normal":
					if(!this._btnLeft.visible) this._btnLeft.visible = true;
					if(!this._btnRight.visible) this._btnRight.visible = true;
				break;
			}
		}
		
		public function CleanAllHead(needSign:Boolean=false):void 
		{
			var head:MovieClip;
			for (var i:int = 0; i < 9; i++)
			{
				head = this._spEdit.getChildByName("box" + String(i)) as MovieClip;
				if (needSign && head.currentOL != "") this.teamMemberProcess(head.currentOL, false);
				head.currentOL = "";
				head.isChoose = false;
				this.cleanHeadBox(head);
			}
			//初始配置數量
			this._editCurrent = 0;
		}
		
		//初始化點擊的隊伍顯示版面
		public function InitHeadBoard(member:Object,source:Object):void
		{
			this._aryCurrentMember = [];
			this._aryRemoveMember = [];
			this._dicCurrentGray = new Dictionary(true);
			
			for (var name:String in member)
			{
				this.SetHeadOnBoard(name, member[name], source[member[name]]);
			}
		}
		// SINGLE 傳入隊伍成員清單(已有頭像檔的對應資料)
		public function SetHeadOnBoard(place:String,key:String,source:DisplayObject):void
		{
			//trace("SETHEAD ON BOARD", place, key, source);
			if (this._editCurrent < this._editLimit) {
				this._editCurrent++;
				var head:MovieClip;
				head = this._spEdit.getChildByName("box" + place) as MovieClip;
				head.addChild(source);
				head.currentOL = key;
				this._aryCurrentMember[this._aryCurrentMember.length] = key;
			}
			//trace("檢測中當前", this._editCurrent);
		}
		
		//點擊怪物卡片的操作 >> 傳入怪物ID與頭像檔
		public function SetClickHead(monsterID:String,source:DisplayObject):Boolean
		{
			if (this._editCurrent < this._editLimit) {
				
				if (this._currentBox != null) {
					this._currentBox.addChild(source);
					this._currentBox.currentOL = monsterID;
					this.headBoxDeshine(this._currentBox);
					this._currentBox = null;
					this._editCurrent++;
					this.teamMemberProcess(monsterID, true);//成員加入該隊伍的標記
					//trace("檢測中當前", this._editCurrent);
					return true;
				}
				return false;
			}
			return false;
		}
		
		
		//頭像框的標記與單一判斷 (舊版選框選擇的方式)
		public function chooseHeadPlace(headBox:MovieClip):void
		{
			if (this._editCurrent < this._editLimit) {//小於限制數量才有辦法點選
				//trace("HeadPlace_1");
				if (this._currentBox == null) {//First Click
					if (headBox.currentOL != "") {//點擊有怪物設置的狀態(清除)
						//this.ColorfulEffect(this.checkMonsterInGray(headBox.currentOL), false);//移除若有灰階對像則變更顯示
						//this.checkMonsterSign(headBox.currentOL);
						this.teamMemberProcess(headBox.currentOL, false);//變更當前隊伍成員//同時發送訊號
						headBox.currentOL = "";
						this.cleanHeadBox(headBox);
						this._editCurrent--;
						//trace("HeadPlace_2");
					}else {//empty box
						this.headBoxShine(headBox);
						this._currentBox = headBox;
						//trace("HeadPlace_3");
					}
				}else {//已有點擊框狀態
					//trace("HeadPlace_4");
					if (this._currentBox == headBox) {//重複點選
						this._currentBox = null;
						this.headBoxDeshine(headBox);
						//trace("HeadPlace_5");
					}else {//點選別框
						//trace("HeadPlace_6");
						this.headBoxDeshine(this._currentBox);
						if (headBox.currentOL != "") {//別框有怪的狀態做替換
							this._currentBox.currentOL = headBox.currentOL;
							headBox.currentOL = "";
							this._currentBox.addChild(headBox.removeChildAt(1));
							this._currentBox = null;
							//trace("HeadPlace_7");
						}else {
							this.headBoxShine(headBox);
							this._currentBox = headBox;
							//trace("HeadPlace_8");
						}
					}
				}
			}else {
				//trace("HeadPlace_9");
				if (headBox.currentOL != "") {//點擊有怪物設置的狀態(清除)
					//this.ColorfulEffect(this.checkMonsterInGray(headBox.currentOL), false);//移除若有灰階對像則變更顯示
					//this.checkMonsterSign(headBox.currentOL);
					this.teamMemberProcess(headBox.currentOL, false);//變更當前隊伍成員//同時發送訊號
					headBox.currentOL = "";
					this.cleanHeadBox(headBox);
					this._editCurrent--;
					//trace("HeadPlace_10");
				}
			}
			
		}
		
		private var _chooseMonster:String;
		
		public function DragPickCardMonster(monsterGuid:String):void
		{
			this._chooseMonster = monsterGuid;
			this._currentBox = null;
		}
		public function DragPickBoxMonster(box:MovieClip):Sprite 
		{
			//trace("點擊怪物頭框>___", _editCurrent);
			if (box.currentOL != "" ) {
				this._chooseMonster = box.currentOL;
				this.teamMemberProcess(this._chooseMonster, false);
				box.currentOL = "";
				this._currentBox = box;
				this._editCurrent--;//總數計算減少
				//trace("點擊怪物頭框>_2__", _editCurrent);
				return box.removeChildAt(1) as Sprite;
			}else {
				this._currentBox = null;
				return null;
			}
		}
		//from >> 點擊的來源 >> "Mon" / "box"
		public function DragPutMonster(box:MovieClip , head:Sprite,from:String):void
		{
			if (head != null) {
				if (box.currentOL != "") {//當前有怪佔位
					//洗掉既有怪物
					var oldHead:DisplayObject = box.removeChildAt(1);
					//box.addChild(head);
					if (this._currentBox != null) {//怪物是由別的BOX來的 要做替換
						this._currentBox.currentOL = box.currentOL;
						oldHead.x = 0;
						oldHead.y = 0;
						this._currentBox.addChild(oldHead);
						this.headBoxShine(this._currentBox);//閃爍
						this._editCurrent++;
					}else {//怪物由卡片點選覆蓋的要做移除
						this.teamMemberProcess(box.currentOL, false);
					}
				}else {//無佔位
					this._editCurrent++;
				}
				this.teamMemberProcess(this._chooseMonster, true);
				box.currentOL = this._chooseMonster;
				head.x = 0;
				head.y = 0;
				box.addChild(head);
				this.headBoxShine(box);//閃爍
			}
			//this._currentBox = null;
		}
		
		public function ColorfulEffect(target:MovieClip,toGray:Boolean):void 
		{
			if (target != null) {
				if (toGray) {
					target.mouseEnabled = false;
					target.buttonMode = false;
					TweenLite.to(target, .5, { colorMatrixFilter: { matrix:[0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0] }} );//灰階化處理參數
				}else {
					target.mouseEnabled = true;
					target.buttonMode = true;
					target.filters = [];
				}
			}
		}
		
		
		//當前隊伍變更控管
		private function teamMemberProcess(guid:String,isAdd:Boolean):void
		{
			if (isAdd) {
				if (this._aryCurrentMember.indexOf(guid) == -1) this._aryCurrentMember[this._aryCurrentMember.length] = guid;
			}else {
				var index:int = this._aryCurrentMember.indexOf(guid);
				if (index != -1) {
					this._aryRemoveMember.indexOf(guid) == -1 ? this._aryRemoveMember[this._aryRemoveMember.length] = this._aryCurrentMember.splice(index, 1)[0] : this._aryCurrentMember.splice(index, 1);
				}
			}
			//trace("編輯隊伍的>>>>>>新增>>>>", this._aryCurrentMember);
			//trace("編輯隊伍的>>>>>>移除>>>>", this._aryRemoveMember);
			this._funControl(TeamViewCtrl.TEAM_CHOOSE_CHANGE, { guid : guid , isAdd : isAdd } ,false);//(不發送)外部不處理//內部值變更而已
		}
		
		private function headBoxShine(box:MovieClip):void
		{
			this.effectComplete(box, false,0);
		}
		private function effectComplete(target:MovieClip,isNormal:Boolean,count:int):void
		{
			count++;
			var param:Object = { onComplete:this.effectComplete, onCompleteParams:[target, !isNormal ,count] };
			param.glowFilter = isNormal ? { color:0xFFFF22, alpha:1, blurX:0, blurY:0 } : { color:0xFFFF22, alpha:.5, blurX:20, blurY:20 } ;
			(count < 3) ? TweenLite.to(target, .5, param) : this.headBoxDeshine(target);
		}
		private function headBoxDeshine(target:MovieClip):void
		{
			TweenLite.killTweensOf(target);
			target.filters = [];
		}
		
		//切換到第一場景時確認點擊的框框閃光消失
		public function CheckCleanBox():void 
		{
			if(this._currentBox!=null) this.headBoxDeshine(this._currentBox);
		}
		
		//common
		private function cleanHeadBox(headBox:MovieClip):void 
		{
			//trace(headBox.numChildren);
			while (headBox.numChildren>1) 
			{
				headBox.removeChildAt(1);
			}
		}
		
		//需要調整成將該頁的怪物KEY加入字典內同時在移除隊伍成員時檢測是否該頁中具有移除的怪物KEY 會需要做怪物版面的型態變更
		//寫入加入灰階的版面
		public function MonsterInGray(guid:String,target:MovieClip):void
		{
			this._dicCurrentGray[guid] = target;
		}
		
		
		//檢測取消的怪物是否有灰階的顯示狀態
		private function checkMonsterInGray(guid:String):MovieClip
		{
			return guid in this._dicCurrentGray ? this._dicCurrentGray[guid] : null;
		}
		
		//關閉編輯模式後清除有加入灰階狀態的模板
		public function CleanGrayBoard():void 
		{
			for (var name:String in this._dicCurrentGray)
			{
				delete this._dicCurrentGray[name];
			}
		}
		
		public function get EditTeamID():String 
		{
			return this._teamID;
		}
		
		public function set EditTeamID(id:String):void 
		{
			this._teamID = id;
		}
		
		public function get CurrentMember():Array
		{
			return this._aryCurrentMember;
		}
		
		public function get RemoveMember():Array
		{
			return this._aryRemoveMember;
		}
		
		public function get CurrentGrayNum():int
		{
			var num:int;
			for (var name:String in this._dicCurrentGray)
			{
				num++;
			}
			return num;
		}
		
		public function get CurrentEditAmount():int 
		{
			return this._editCurrent;
		}
		
		public function get ShiftContainer():Sprite 
		{
			return this._spShift;
		}
		
		
		public function PickUpAllMember():Object
		{
			var objMember:Object = { };
			var guid:String;
			for (var i:int = 0; i < 9; i++)
			{
				guid = this._spEdit.getChildByName("box" + String(i))["currentOL"];
				if (guid != "") objMember[i] = guid;
				//trace("PICK UP ALLLLL MEMBER>>>>>", guid ,"--", i);
			}
			return objMember;
		}
		
		override public function Destroy():void 
		{
			super.Destroy();
			var box:MovieClip;
			for (var i:int = 0; i < 9; i++) 
			{
				box = this._spEdit.getChildByName("box" + String(i)) as MovieClip;
				this.cleanHeadBox(box);
			}
			
			this._spEdit = null;
			this._currentBox = null;
			this.btnFactory(this._btnLeft);
			this.btnFactory(this._btnRight);
			this._btnLeft = null;
			this._btnRight = null;
			this._aryCurrentMember = null;
			this._aryRemoveMember = null;
			this.CleanGrayBoard();
			this._dicCurrentGray = null;
		}
		
		
		
		
	}
	
}