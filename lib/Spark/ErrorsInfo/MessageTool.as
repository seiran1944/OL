package Spark.ErrorsInfo
{
	
	
	import Spark.ErrorsInfo.MessageControl;
	
	
	/**
	 * ...
	 * @Engine :SparkEngine beta 1
	 * @author :JerryKai
	 * @version :2012.08.14
	 * @Explain:MessageTool 訊息對外接口
	 * @playerVersion:11.0
	 */
	 
	
	public class MessageTool
	{
		
		private static var _MessageControl:MessageControl;
		
		
		
		//=============================初始ErrorMessage工具=================================
		public static function InitMessageTool( _InputParentContainer:* , _InputStageWidth:Number , _InputStageHeight:Number ):void
		{
			_MessageControl = new MessageControl( _InputParentContainer , _InputStageWidth , _InputStageHeight );
		}
		
		
		//=============================輸入訊息key碼搜尋清單================================
		public static function InputMessageKey( _key:* = null ):void 
		{
			//_MessageControl.InputMessageKey( _key );
		}		
		
		
		
	}//end class
}//end package