package Spark.ErrorsInfo
{
	
	
	
	
	/**
	 * ...
	 * @Engine :SparkEngine beta 1
	 * @author :JerryKai
	 * @version :2012.08.06
	 * @Explain:MessageControl 訊息系統控制
	 * @playerVersion:11.0
	 */
	 
	
	public class MessageControl
	{
		
		private var _MessageDataPools:MessageDataPools;
		
		private var _MessageUI:MessageUI;
		
		
		public function MessageControl( _InputParentContainer:* , _InputStageWidth:Number , _InputStageHeight:Number ):void 
		{
			this._MessageDataPools = new MessageDataPools();
			
			this._MessageUI = new MessageUI( _InputParentContainer , _InputStageWidth , _InputStageHeight );
		}
		
		
		//=============================輸入訊息key碼搜尋清單================================
		public function InputMessageKey( _key:* ):void 
		{
			//篩選查詢或直接秀出功能
			var _type:String = (_key != null ) ? typeof( _key ) : "default";
			var _MessageTxt:String;
			switch(_type)
			{
				case"number":
					_MessageTxt = this._MessageDataPools.SelectMessageData( _key );
					( _MessageTxt != null ) ? this._MessageUI.BumpMessage( _MessageTxt ) : trace("MessageBox狀態:null");
					break;	
				case"string":
					this._MessageUI.BumpMessage( _key );
					break;
				case"default":
					this._MessageUI.BumpMessage( "未輸入訊息內容" );
					break;
			}
		}
		
		
	}//end class
}//end package