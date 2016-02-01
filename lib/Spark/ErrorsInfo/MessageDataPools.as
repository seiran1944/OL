package Spark.ErrorsInfo
{
	
	
	
	
	
	/**
	 * ...
	 * @Engine :SparkEngine beta 1
	 * @author :JerryKai
	 * @version :2012.08.13
	 * @Explain:MessageDataPools 訊息資料庫
	 * @playerVersion:11.0
	 */
	 
	
	public class MessageDataPools
	{
		
		//=======================================建立訊息清單區=======================================
		
		//SystemInit系統初始訊息 (1)
		private var _SystemInitObj:Object = { 104:"SourceTool初始完成!" };
		
		//連線器訊息 (2)
		private var _ConnetObj:Object = { 201:"" };
		
		//事件處理器訊息 (3)
		private var _EventObj:Object = {};
		
		//素材載入器訊息 (4)
		private var _LoadObj:Object = { 401:"下載素材完成!" , 402:"下載素材中斷!" , 403:"下載素材中斷!" , 404:"素材URL位置錯誤!" , 405:"素材已儲存Lribrary" };
		
		//素材管理、影像處理訊息 (5)
		private var _MaterialObj:Object = { 501:"查無素材元件!" };
		
		//計數器處理訊息 (6)
		private var _TimerObj:Object = { 601:"當前非暫停狀態>>呼叫Resume" , 602:"該Function已經註冊" , 603:"必須先初始SourceTimer的SetSpeed()" };
		
		//Bar工具處理訊息 (7)
		private var _BarObj:Object = { 701:"尚未註冊此群組" , 702:"群組代號重複註冊" , 703:"已註冊過此BAR稱號" , 704:"尚未註冊此BAR稱號" };
		
		//播放器處理訊息 (8)
		private var _PlayMcObj:Object = { 801:"容器已註冊過" , 802:"未註冊過的容器" , 803:"素材不能是null" , 804:"不支援的註冊容器" };
		
		//介面排序訊息 (12)
		private var UISortObj:Object = { 1201:"註冊非字串格式" , 1202:"當前無介面開啟>>呼叫關閉介面通知" };
		
		//角色動態元件訊息 (13)
		private var _RoleObj:Object = { 1301:"已註冊過此稱號" , 1302:"尚未註冊此稱號" , 1303:"素材操作方式須相同" , 1304:"素材已傳入" };
		
		
		//=======================================搜尋Message內容======================================
		public function SelectMessageData( _key:int ):String 
		{
			//Key碼最大四碼，大於四碼取前兩碼做Type
			var _keyString:String = ( String( _key ).length < 4 ) ? String( _key ).substr(0, 1) : String( _key ).substr(0, 2);
			var _ContentMsg:String = "";
			
			switch( _keyString )
			{
				//SystemInit系統初始訊息
				case "1":
					_ContentMsg = this.GetMessageContent( this._SystemInitObj , _key );
					break;
				
				//連線器訊息
				case "2":
					_ContentMsg = this.GetMessageContent( this._ConnetObj , _key );
					break;	
				
				//事件處理器訊息
				case "3":
					_ContentMsg = this.GetMessageContent( this._EventObj , _key );
					break;	
				
				//素材載入器訊息
				case "4":
					_ContentMsg = this.GetMessageContent( this._LoadObj , _key );
					break;
				
				//素材管理、影像處理訊息
				case "5":
					_ContentMsg = this.GetMessageContent( this._MaterialObj , _key );
					break;	
					
				//計數器處理訊息
				case "6":
					_ContentMsg = this.GetMessageContent( this._TimerObj , _key );
					break;
					
				//Bar工具處理訊息
				case "7":
					_ContentMsg = this.GetMessageContent( this._BarObj , _key );
					break;
					
				//播放器處理訊息
				case "8":
					_ContentMsg = this.GetMessageContent( this._PlayMcObj , _key );
					break;
					
				//
				case "12":
					_ContentMsg = this.GetMessageContent( this.UISortObj , _key );
					break;
					
				//
				case "13":
					_ContentMsg = this.GetMessageContent( this._RoleObj , _key );
					break;
				//--------------以下可擴增區---------------
				
				
				
				
			}
			return _ContentMsg;
		}
		
		//======================================取得訊息內容==========================================
		private function GetMessageContent( _InputObj:Object , _key:int ):String 
		{
			var _ContentMsg:String;
			
			for ( var i:* in _InputObj )
			{	
				if ( _key == i )
				{
					_ContentMsg = _InputObj[_key];
					break;
				}else {
					_ContentMsg = "查無此訊息";
				}				
			}
			return _ContentMsg;
		}
		
		
		
	}//end class
}//end package