package Spark.MVCs.Models.MenuLine
{
	import Spark.coreFrameWork.observer.Notify;
	import Spark.ErrorsInfo.MessageTool;
	import Spark.CommandsStrLad;
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.10.30.15.12
		@documentation 介面列隊處理先後控管操作
	 */
	public class EntrySelect extends Notify
	{
		
		//private const SEQUENCE_ENTRY:String = "MenuEntry";
		private var _arrLine:Array = [];								//無優先的介面佇列處理
		//private var _arrPriority:Array = [];						//具優先權的介面
		private var _currentShowPriority:Array = [];	//當前有顯示的優先介面
		private var _currentMenu:String="";						//當前最上層顯示的一般介面
		private var _currentPriorityMenu:String="";		//當前最上層顯示的優先介面
		
		/*public function EntrySelect():void
		{
			super(SEQUENCE_ENTRY, this);
		}
		
		internal function AddPriorityMember(name:String):void
		{
			if (this._arrPriority.indexOf(name) == -1) {
				this._arrPriority.push(name);
			}
			
		}*/
		
		//無一般介面互疊狀況(一般介面排列先後處理,優先介面先開啟)
		internal function AddIn(name:String,layerID:int):void 
		{
			
			if (layerID > 1) MessageTool.InputMessageKey(12999);//UI的layerID不符合規則 (0/1)
			
			//優先全介面直接處理
			if (layerID) {
				this.priorityMember(name);
			}else {
				this.normalMember(name);
			}
		}
		
		//一般介面優先顯示重疊處理(一般介面開一般介面)
		internal function AddCover(name:String):void 
		{
			this.priorityMember(name);
		}
		
		//介面關閉通知移除相關處理
		internal function RemoveOut():void
		{
			
			if (this._currentShowPriority.length > 0) {
				this.sendMessage(this._currentShowPriority.shift(), false);//remove & send
				this._currentPriorityMenu = this._currentShowPriority.length > 0 ? this._currentShowPriority[0] : "";
				if (this._currentPriorityMenu == "" && this._arrLine.length > 0 && this._currentMenu == "") this.checkNext(true);
				return;
			}else if(this._arrLine.length>0){
				this.sendMessage(this._arrLine.shift(), false);//remove & send
				if (this._arrLine.length > 0) {
					this.dataUpdate(false, false);
					this.checkNext(false);
				}else {
					this.dataUpdate(false, false, true);
				}
			}else {
				MessageTool.InputMessageKey(1202);
			}
			
		}
		
		private function priorityMember(name:String):void 
		{
			
			//加入已顯示列表
			this._currentShowPriority.unshift(name);
			this.checkNext(true,true);
			
			
		}
		
		private function normalMember(name:String):void
		{
			this._arrLine.push(name);
			
			if (this._arrLine.length < 2 && this._currentShowPriority.length==0) {
				this.checkNext(true);
			}
			
		}
		
		private function checkNext(isAdd:Boolean,priority:Boolean=false):void 
		{
			this.dataUpdate(isAdd, priority);
			var sendKey:String = !priority ? this._arrLine[0] : this._currentShowPriority[0];
			this.sendMessage(sendKey);//send Add
		}
		
		//priority close不會進來,不需處理_currentShowPriority;
		private function dataUpdate(isAdd:Boolean,priority:Boolean,end:Boolean=false):void
		{
			if (end) {
				this._currentMenu = "";
				this._currentPriorityMenu = "";
				return;
			}
			var check:int = 0;
			check += isAdd ? 1 : -1;
			check += priority ? 3 : 2;
			
			switch (check) 
			{
				case 1://remove normal
					this._currentMenu= this._arrLine[0];
				break;
				//case 2://remove priority
					//maybe use decide to input value need sign removed is/isn't priority menu;
				//break;
				case 3://show normal
					this._currentMenu = this._arrLine[0];
				break;
				case 4://show priority
					this._currentPriorityMenu = this._currentShowPriority[0];
				break;
			}
			
		}
		
		//發送上層介面異動狀態
		private function sendMessage(name:String,open:Boolean=true):void 
		{
			var state:String = open ? "OPEN" : "CLOSE";
			
			//_action 動作型態 ( OPEN / CLOSE )
			//_name 處理代號 ( 代入處理的代號 )
			this.SendNotify(CommandsStrLad.SEQUENCE_NOTIFY, {_action:state,_name:name});
		}
		
		
		//Get Value
		public function get CurrentShowPriority():Array 
		{
			return this._currentShowPriority;
		}
		
		public function get CurrentPriorityMenu():String 
		{
			return this._currentPriorityMenu;
		}
		
		public function get CurrentMenu():String 
		{
			return _currentMenu;
		}
		
		public function get CurrentLine():Array
		{
			return this._arrLine;
		}
		
		
	}
	
}