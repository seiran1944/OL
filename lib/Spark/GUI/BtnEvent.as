package Spark.GUI
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author EricHuang
	 * 2012/08/13
	 */
	public class BtnEvent extends Event 
	{
		
		public static const Btn_Event:String = "btnEvent";
		public var _evtID:String = "";
		public var _sendInfo:Object=null;
		public function BtnEvent (evtName:String,evtBul:Boolean,evtID:String,evtSendObj:Object=null) 
		{
			
			super(evtName,evtBul);
			this._evtID = _evtID;
			if (evtSendObj != null) this._sendInfo = evtSendObj;
			
		}
		
		
		override public function clone():Event 
		{
			return new BtnEvent(BtnEvent.Btn_Event,true,this._evtID,this._sendInfo);
		}
		
	}
	
}