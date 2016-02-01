package MVCprojectOL.ViewOL.CrewView.MonsterMixed
{
	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplayProxy;
	import MVCprojectOL.ModelOL.Vo.Troop;
	import MVCprojectOL.ViewOL.CrewView.EditBoard.TeamEditorView;
	import MVCprojectOL.ViewOL.MonsterView.MonsterPanel;
	import strLib.proxyStr.ArchivesStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.05.22.17.30
		@documentation to use this Class....
	 */
	public class TeamMonsterView extends MonsterPanel 
	{
		
		private var _monDsPx:MonsterDisplayProxy;
		private var _editView:TeamEditorView;
		private var _rectSize:Rectangle;
		private var _currentTroop:Troop;
		private var _sTemporal:StatusTemporal;//紀錄會異動的寫入值屬性處理 避免SORT時的刷舊
		private var _handsLock:Boolean;//初始灌入Troop時會算一次成員數滿五則true 反之false
		private var _vecStampStr:Vector.<String> = new < String > ["Group"];
		
		public function TeamMonsterView(viewName:String,conter:DisplayObjectContainer):void
		{
			super(viewName, conter);
			this._sTemporal = new StatusTemporal();
		}
		
		public function AllMonsterListInit(vecMonster:Vector.<MonsterDisplay>):void 
		{
			//先初始隊伍資料會寫動的屬性區域才有檢測值
			this._sTemporal.FirstDataInit(vecMonster);
		}
		
		//搭配點擊使用關閉mouseChildren影響與多餘監聽
		override protected function CtrlPage(_InputPage:int , _CtrlBoolean:Boolean ):void
		{
			this.removeBoardDownListen();
			super.CtrlPage(_InputPage, _CtrlBoolean);
			
			//怪物底板的點選鎖定
			var leng:int = this._MonsterMenuSP.length;
			var spMonster:Sprite;
			for (var i:int = 0; i < leng; i++) 
			{
				spMonster = this._MonsterMenuSP[i];
				//spMonster.mouseChildren = false;//20130522
				spMonster.removeEventListener(MouseEvent.CLICK, MonsterClickHandler);//移除用不到的監聽種類
				//20130522 作為版面內額外TIP的判斷開回mouseChildren後的排除處理
				spMonster.addEventListener(MouseEvent.MOUSE_DOWN, this.boardDragNotify);
			}
			
			//開啟印章的種類設定
			var _MyPage:Array = this._PageList[_InputPage];
			if (_MyPage != null) {
				
				leng = _MyPage.length;
				for (i = 0; i < leng ; i++) 
				{
					MonsterDisplay(_MyPage[i]).setStampSetting(this._vecStampStr);
				}
				
				if (!this._handsLock) this.ChangeAllHand();//初始刷一次手指變化
			}
			
		}
		
		//20130522 新增作為額外的MOUSE DOWN 判斷 currentTarget.name
		private function boardDragNotify(e:MouseEvent):void 
		{
			this._editView.DragNotifyPlace(e);
		}
		//20130522 移除新增的監聽
		private function removeBoardDownListen():void 
		{
			if (this._MonsterMenuSP != null) {
				var leng:int = this._MonsterMenuSP.length;
				var spMonster:Sprite;
				for (var i:int = 0; i < leng; i++) 
				{
					spMonster = this._MonsterMenuSP[i];
					spMonster.removeEventListener(MouseEvent.MOUSE_DOWN, this.boardDragNotify);
				}
			}
		}
		
		
		//按下關閉按鈕後觸發關閉的調整
		override protected function ClickHandler(_TargetName:String):void
		{
			(_TargetName == "SortBtn")?this.SortBtnMove(this._CurrentNum):TweenLite.to(this._viewConterBox.getChildByName("Panel"), 0.3, { x:240, y:127, scaleX:0.5, scaleY:0.5 , onComplete:this.RemovePanel } );
		}
		
		override public function AssemblyPanel(_PanelX:int = 312, _PanelY:int = 127, _BgBW:int = 750, BgBH:int = 510, _TitleW:int = 630, _TitleName:String = "出征大廳", _TextBgW:int = 240, _TextBgH:int = 90, _TextBgX:int = 505, _TextBgY:int = 470 ):void
		{
			
			super.AssemblyPanel(_PanelX, _PanelY, _BgBW, BgBH, _TitleW, _TitleName, _TextBgW, _TextBgH, _TextBgX, _TextBgY);
			this._rectSize = new Rectangle(_PanelX-22, _PanelY-27, _BgBW-40, BgBH-60);
			
		}
		
		//避免預設頁面的UI與編輯頁面UI關閉同訊號
		override protected function RemovePanel():void
		{
			this.SendNotify( ArchivesStr.CREW_EDIT_REMOVE);
		}
		
		//篩選條件的摘錄 (先取用了monster的判斷) *********************************************************Notice
		override protected function FilterMonster():void
		{
			this._MonsterMenu = new Vector.<MonsterDisplay>;
			var i:int;
			for (i = 0; i < this._MonsterDisplay.length; i++) {
				(this._MonsterDisplay[i].MonsterData._useing == 2 )?null:this._MonsterMenu.push(this._MonsterDisplay[i]);
			}	
			this.AddMonsterMenu();
		}
		
		public function get RectSize():Rectangle
		{
			return this._rectSize;
		}
		
		//導入編輯版並設定
		public function set EditBoardView(board:TeamEditorView):void 
		{
			this._editView = board;
			board.SetDragTool(this.RectSize, board.DraggingProcess);//設定拖曳範圍
			board.GetViewConter().x = 510;
			board.GetViewConter().y = 130;
		}
		
		//設定當前隊伍資料 用於旗幟編號導入Temporal 的ADD
		public function set CurrentTroop(troop:Troop):void 
		{
			var num:int = 0;
			if (troop) {
				this._currentTroop = troop;
				for each (var item:String in troop._objMember) 
				{
					num++;
				}
			}
			this._handsLock = num >= 5 ? true : false;
		}
		
		public function set MonDsPx(msDsPx:MonsterDisplayProxy):void 
		{
			this._monDsPx = msDsPx;
		}
		
		//更新SORT的資料內容為編輯中的最新值
		public function SortRecover(vecMonDp:Vector.<MonsterDisplay>):void 
		{
			this._sTemporal.SortDataRecover(vecMonDp);
		}
		
		//手指頭變化處理
		public function ChangeHand(guid:String,open:Boolean):void 
		{
			var slideContainer:Sprite = Sprite(this._viewConterBox.getChildByName("Panel")).getChildByName("SlidingContainer") as Sprite;//可由此取得怪物底板容器byName("monsterGuid")
			var spTarget:Sprite = slideContainer.getChildByName(guid) as Sprite;
			if (spTarget) spTarget.buttonMode = open;
		}
		
		//變更全怪物底版的手指
		public function ChangeAllHand():void 
		{
			var slideContainer:Sprite = Sprite(this._viewConterBox.getChildByName("Panel")).getChildByName("SlidingContainer") as Sprite;//可由此取得怪物底板容器byName("monsterGuid")
			
			var num:int = slideContainer.numChildren;
			var spBoard:Sprite;
			for (var i:int = 0; i < num; i++)
			{
				spBoard = slideContainer.getChildAt(i) as Sprite;
				//確認是怪物底板時,須注意底板名稱的改變可能性或是GUID名稱變更************************************************************************************************************************************************************
				if (spBoard.name.substr(0, 3) == "MOB") spBoard.buttonMode = !this._handsLock && this._sTemporal.HandsEnable(spBoard.name) ? true : false;
			}
		}
		
		//拖曳變更的成員資料處理
		//_add : "" , _remove : "" , _limit : true/false
		public function EditProcess(note:Object = null):void 
		{
			//五隻成員鎖怪物版拖曳處理
			//if (note._limit != this._handsLock) {
				//this._handsLock = note._limit;
				//this.ChangeAllHand();
			//}
			
			//導入變更編輯的暫存值與怪物版的顯示印章旗幟與底板手指
			if (note._add != "") {
				this._sTemporal.AddInGroup(note._add, this._currentTroop._guid, this._currentTroop._teamNum, this._monDsPx.GetMonsterDisplay(note._add));
				this.ChangeHand(note._add, false);
			}
			if (note._remove != "") {
				this._sTemporal.RemoveGroup(note._remove, this._monDsPx.GetMonsterDisplay(note._remove));
				this.ChangeHand(note._remove, true);
			}
			
		}
		
		
		override public function onRemoved():void 
		{
			super.onRemoved();
			this.Destroy();
		}
		
		public function Destroy():void 
		{
			this.removeBoardDownListen();
			this._viewConterBox.removeChildren();
			this._currentTroop = null;
			this._editView = null;
			this._monDsPx = null;
			this._sTemporal.Destroy();
			this._sTemporal = null;
			this._vecStampStr = null;
			this._rectSize = null;
		}
		
		
	}
	
}