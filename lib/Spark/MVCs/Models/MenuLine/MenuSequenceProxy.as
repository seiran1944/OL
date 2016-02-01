package Spark.MVCs.Models.MenuLine
{
	import flash.display.DisplayObject;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.ErrorsInfo.MessageTool;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.10.30.18.05
		@documentation 介面排序操控-註冊介面後可操作
	 */
	public class MenuSequenceProxy extends ProxY
	{
		private var _entry:EntrySelect = new EntrySelect();
		
		//事件處理器註冊
		public function MenuSequenceProxy(registerName:String):void
		{
			super(registerName, this);
		}
		
		//***改為不註冊機制由每次開啟關閉時導入UI名稱來處理
		//串列式註冊優先名稱>>(字串)
		/**
		 * 註冊具有優先權顯示的UI 自定義名稱
		 * @param	...args 字串>> ( "menuA" , "menuB" )
		 */
		/*public function RegisterName(...args):void
		{
			var long:int = args.length;
			var name:String;
			for (var i:int = long ; i >= 0; i--) {
				name = args[i];
				//if (!(args[i] is String)) ErrorList.OutputError(RegisterList.SEQUENCE_SYSTEM, ErrorList.SEQUENCE_RESTRICT);
				if (!(args[i] is String)) MessageTool.InputMessageKey(1201);
				this._entry.AddPriorityMember(name);
			}
		}*/
		
		//Menu Priority Process
		//開啟某介面(註冊的key值)
		/**
		 * ( 預設介面註冊時呼叫 ) 通知須要開啟的UI (名稱) 加入排列處理 有異動會發出Notify
		 * @param	name 輸入自定義名稱
		 * @param	layerID 輸入UI的優先度數值( 0 非優先/ 1 優先)
		 */
		public function OpenMenu(name:String,layerID:int):void
		{
			this._entry.AddIn(name,layerID);
		}
		
		//一般介面開啟中開啟另外一般介面
		/**
		 * ( 特例情況非優先先開啟 )通知開啟無優先UI 須要疊加顯示的狀態 有異動會發出Notify
		 * @param	name 輸入自定義名稱
		 */
		public function CoverMenu(name:String):void
		{
			this._entry.AddCover(name);
		}
		
		//關閉當前最優先顯示的介面-依序往後關閉-
		/**
		 * ( 預設介面移除時呼叫 )通知須要關閉UI 由最上層開始關閉 有異動會發出Notify
		 */
		public function CloseMenu():void 
		{
			this._entry.RemoveOut();
		}
		
		//Check Menu 
		//取得當前顯示的介面(非優先)
		/**
		 * GET 取得當前顯示的非優先UI 名稱
		 */
		public function get CurrentMenu():String
		{
			return this._entry.CurrentMenu;
		}
		
		//取得當前顯示的介面(優先)
		/**
		 * GET 取得當前顯示的優先 UI 名稱
		 */
		public function get CurrentPriorityMenu():String
		{
			return this._entry.CurrentPriorityMenu;
		}
		
		//當前顯示出的所有優先介面
		/**
		 * GET 取得當前顯示出的所有優先 UI 名稱
		 */
		public function get CurrentShowPriority():Array 
		{
			return this._entry.CurrentShowPriority;
		}
		
		/**
		 * GET 取得當前排列中的所有非優先 UI 名稱
		 */
		public function get CurrentLine():Array
		{
			return this._entry.CurrentLine;
		}
		
	}
	
}