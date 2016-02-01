package MVCprojectOL.ViewOL.CrewView.EditBoard
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.Vo.Troop;
	import Spark.MVCs.Models.SourceTools.Loader.LoadingBar;
	import strLib.proxyStr.ArchivesStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class TeamEditorView  extends TeamShowView
	{
		
		protected var _switchBox:TeamHeadBox;
		protected var _headDrag:HeadDragTool;
		protected var _loading:Class;
		
		
		public function TeamEditorView(name:String,conter:DisplayObjectContainer,num:int):void 
		{
			super(name, conter,num);
		}
		
		public function get DragNotifyPlace():Function
		{
			return this._headDrag.dragProcess;
		}
		
		override public function InSource(source:Object,dicUiStr:Dictionary ,adorn:Boolean=false):void 
		{
			super.InSource(source,dicUiStr,adorn);
			
			this._loading = source.Loading;
		}
		
		override protected function EditionProcess(btnName:String):void 
		{
			switch (btnName) 
			{
				case "cleanBtn":
					if (this._currentTroop._isPveTeam || this._currentTroop._isPvpTeam)  {
						trace("隊伍是預設隊伍不能移除最後一位成員;隊伍是預設隊伍不能移除最後一位成員;隊伍是預設隊伍不能移除最後一位成員");
						//提示視窗開啟
						this.SendNotify(ArchivesStr.CREW_INFO_NOTIFY, { _active : "OPEN" , _info : "此隊伍為預設戰鬥隊伍不能移除" , _x : 50 , _y : 100 , _btnNum : 1 } );
						return;
					}
					this.CleanAllMember();
				break;
				case "confirmBtn":
					if (this._currentTroop._guid == "") this.RunLoading();
					this.SendNotify(ArchivesStr.CREW_EDIT_CONFIRM, { _loading : this._currentTroop._guid == "" ? true : false , _objChange : this.GetAllChange() , _objMember : this.GetAllMember() , _troopID : this._currentTroop._guid , _num : this._num} );
				break;
			}
		}
		
		public function RunLoading():void 
		{
			this._viewConterBox.parent.mouseChildren = false;//上層panel
			var loading:LoadingBar = new this._loading();
			loading.name = "Loading";
			this._viewConterBox.parent.addChild(loading);
			loading.x = this._viewConterBox.parent.width / 2 - loading.width/2;
			loading.y = this._viewConterBox.parent.height / 2 - loading.height / 2;
			this._loading = null;
		}
		
		public function RemoveLoading():void 
		{
			if (this._loading == null) {
				var loading:LoadingBar = this._viewConterBox.parent.getChildByName("Loading") as LoadingBar;
				loading.stop();
				this._viewConterBox.parent.removeChild(loading);
			}
		}
		
		public function SetDragTool(rectSize:Rectangle,funNotify:Function):void 
		{
			this._headDrag = new HeadDragTool(this._viewConterBox.parent, funNotify, rectSize);
			
		}
		
		public function DraggingProcess(type:String, note:Object = null):void 
		{
			
			var cutName:String = note._name.substr(3, 1);
			trace(cutName, "典籍拖曳字串拆解內容");
			switch (type) 
			{
				case ArchivesStr.TEAM_DRAGDOWN_MONSTER://依照怪物ID回給dragTool頭像
					//if (this._memberNum >= 5) return ;//超過或達限制成員數量則不處理
					var monsterDisplay:MonsterDisplay = this._monDP.GetMonsterDisplay(note._name);
					if (monsterDisplay.CurrentStamp != "") return ;
					this._headDrag.SetDragHead(monsterDisplay.MonsterHead, note._name);
				break;
				case ArchivesStr.TEAM_DRAGDOWN_BOX://依照BOX位置移除並搬移頭像//需要搭配怪物版的隊伍旗幟圖像變化
					this.DownHeadBox(int(cutName));
				break;
				case ArchivesStr.TEAM_DRAGUP_TOBOX://依照BOX位置做切換或搬移處理//需要搭配怪物版的隊伍旗幟圖像變化
					
					//trace("maxiMAN*-*-*-*-*-*-*-*-*-*-*-*-*-", this._memberNum);
					//若是移除清空 要將前次點選目標清掉 避免下次覆蓋怪物會是互換
					note._nameOL != "delete" ? this.UpHeadBox(int(cutName), note._nameOL, note._head) : this._switchBox = null;
					
				break;
			}
		}
		
		//發送通知怪物面板區塊做增減變更 同時做當前數量增減
		//_add : 新增ID , _remove : 移除ID , _limit : 是否滿額不能點選編輯
		private function memberChangeNotify(addMember:String="",removeMember:String=""):void 
		{
			if (removeMember != "") this._memberNum--;
			if (addMember != "") this._memberNum++;
			
			this.SendNotify(ArchivesStr.TEAM_EDIT_CHANGE, { _add : addMember , _remove : removeMember , _limit :  this._memberNum >= 5 ? true : false } );
		}
		
		//點擊頭框處理
		public function DownHeadBox(boxNum:int):void 
		{
			//若隊伍是預設隊伍則點下去移除時this.memberNum==1要檔移除
			//trace(this._memberNum, "成員剩餘數量");
			if ((this._currentTroop._isPveTeam || this._currentTroop._isPvpTeam) && this._memberNum == 1)  {
				//trace("隊伍是預設隊伍不能移除最後一位成員;隊伍是預設隊伍不能移除最後一位成員;隊伍是預設隊伍不能移除最後一位成員");
				//提示視窗開啟
				this.SendNotify(ArchivesStr.CREW_INFO_NOTIFY, { _active : "OPEN" , _info : "此隊伍為預設戰鬥隊伍不能移除" , _x : 50 , _y : 100 , _btnNum : 1 } );
				return;
			}
			
			var headBox:TeamHeadBox = this._vecBox[boxNum];
			
			if (headBox.HasHead) {//移除頭像處理(移出隊伍)
				this.memberChangeNotify("", headBox.CurrentOL);//成員異動通知
				
				this._switchBox = headBox;
				this._headDrag.SetDragHead(headBox.CurrentHead,headBox.CurrentOL);
				headBox.RemoveHead();
			}else {
				//none of process
				
			}
			
		}
		//頭框上鬆開滑鼠處理
		public function UpHeadBox(boxNum:int,name:String="",head:Sprite=null):void 
		{
			if (!name || !head) return;
			var headBox:TeamHeadBox = this._vecBox[boxNum];
			
			if (!headBox.HasHead) {//區域無頭像(加入隊伍)
				if (this._memberNum < 5) {
					this.memberChangeNotify(name);//成員異動通知
					headBox.SetHeadIn(head, name);
					headBox.ShineTheTarget();
				}else {
					trace("超過最大隊伍成員限制");
					//提示視窗開啟
					this.SendNotify(ArchivesStr.CREW_INFO_NOTIFY, { _active : "OPEN" , _info : "隊伍超過最多五位成員限制" , _x : 50 , _y : 100 , _btnNum : 1 } );
					return;
				}
			}else {//放置區域有頭像
				if (this._switchBox != null) {//來源是原來的BOX (替換處理)
					this.memberChangeNotify(name);//成員異動通知
					
					this._switchBox.SetHeadIn(headBox.CurrentHead, headBox.CurrentOL);//原先位置替換成目標物
					this._switchBox.ShineTheTarget();
					headBox.RemoveHead();//現在位置移除
					headBox.SetHeadIn(head, name);//換新
					headBox.ShineTheTarget();
				}else {//來源是怪物清單 (刷新處理)
					this.memberChangeNotify(name, headBox.CurrentOL);//成員異動通知
					
					headBox.RemoveHead();
					headBox.SetHeadIn(head, name);
					headBox.ShineTheTarget();
				}
			}
			this._switchBox = null;
		}
		
		//取得當前所有編輯成員 { 位置 : ID } (SERVER記錄用)
		public function GetAllMember():Object 
		{
			var leng:int = this._vecBox.length;
			var headBox:TeamHeadBox;
			var objMember:Object = { };
			for (var i:int = 0; i < leng; i++) 
			{
				headBox = this._vecBox[i];
				if (headBox.CurrentOL != "") objMember[i] = headBox.CurrentOL;
				//trace("隊伍成員取得", i, headBox.CurrentOL);
			}
			return objMember;
		}
		
		//CLIENT端變更回寫用
		public function GetAllChange():Object
		{
			var leng:int = this._vecBox.length;
			var aryAdd:Array = [];
			var aryRemove:Array = [];
			var box:TeamHeadBox;
			for (var i:int = 0; i < leng; i++) 
			{
				box = this._vecBox[i];
				if (box.AddMember != "") aryAdd.push(box.AddMember);
				if (box.RemoveMember != "") aryRemove.push(box.RemoveMember);
				//trace("新增了",box.AddMember );
				//trace("移除了", box.RemoveMember);
			}
			return { _name : this._currentTroop._guid , _add: aryAdd , _remove : aryRemove };
		}
		
		//清空當前隊伍所有成員 (Clean Btn)
		public function CleanAllMember():void 
		{
			var leng:int = this._vecBox.length;
			var headBox:TeamHeadBox;
			for (var i:int = 0; i < leng; i++) 
			{
				headBox = this._vecBox[i];
				if (headBox.CurrentOL != "") {
					this.memberChangeNotify("", headBox.CurrentOL);//成員異動通知
					headBox.RemoveHead();
				}
			}
		}
		
		//public function DestroyAllBox():void 
		//{
			//var leng:int = this._vecBox.length;
			//for (var i:int = 0; i < leng; i++) 
			//{
				//this._vecBox[i].Destroy();
			//}
		//}
		
		override public function onRemoved():void 
		{
			this.Destroy();
		}
		
		override public function Destroy():void 
		{
			this.RemoveLoading();
			
			super.Destroy();
			
			//this.DestroyAllBox();
			this._headDrag.Destroy();
			this._loading = null;
			this._headDrag = null;
			this._switchBox = null;
		}
		
		
	}
	
}