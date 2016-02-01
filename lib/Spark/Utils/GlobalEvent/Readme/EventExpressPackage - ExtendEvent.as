package GlobalEvent{

	/**
	 * @Engine Ignitor
	 * @Author K.J. Aris
	 * @Version 12.05.24.14.23
	 * @Note This class wraps up as an event package and will be sent to the members of specific Event Club
	 */
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public dynamic class EventExpressPackage extends Event {
		//本元件用來發送自定義事件  並夾帶 物件 或  物件清單		PS:清單內若夾帶類別  將無法實體化
		//Package Info for debug
		//private const _PackageInf:String = " * From Package EventExpressPackage.as ";
		//private const _Version:String = "#ver 12.05.18.17.07 : ";
		//private const _LastEditor:String = " K.J. Aris ";
		
		public static const GolbalEvent:String = "GolbalEvent";
		
		private var _EventName:String;
		private var _Status:String = CasualMessage.Casual;
		private var _Content:Object;
		private var _SenderSignature:*;
		private var _DuplicateContent:Boolean = false;
		
		public function EventExpressPackage( type:String , _InputEventName:String , _InputStatus:String = null , _InputContent:Object = null , _InputSenderSignature:* = null , _DuplicateContentOrNot:Boolean = false , 
		                                  bubbles:Boolean=false ,
		                                  cancelable:Boolean=false ) {

			super( type , bubbles , cancelable );
			
			this._EventName = _InputEventName;
			this._Status = ( _InputStatus == null ) ? CasualMessage.Casual :  _InputStatus;
			this._Content = _InputContent;
			this._SenderSignature = ( _InputSenderSignature != null ) ? _InputSenderSignature : "Anonymous";
			this._DuplicateContent = _DuplicateContentOrNot;
		}
		
		public function get EventName():String {
			return _EventName;
		}
		
		public function get Status():String {
			return this._Status;
		}
		
		public function get Content():Object {
			return this._Content;
		}
		
		public function get SenderSignature():* {
			return _SenderSignature;
		}
		
		public function get DuplicateContent():Boolean {
			return _DuplicateContent;
		}
		
		private function MakeClone( _InputSource:Object ):* {
				var _Clone:ByteArray = new ByteArray();
					_Clone.writeObject( _InputSource );
					_Clone.position = 0;
			return( _Clone.readObject() );
		}
		
		public override function clone():Event {
			//trace(type , this._Carrier , this._MakeCloneOrNot , bubbles , cancelable);
			return new EventExpressPackage( type , this._EventName , this._Status , this.MakeClone( this._Content ) , this._SenderSignature , this._DuplicateContent , bubbles , cancelable );
		}

		public override function toString():String {
			return formatToString( "EventPackage", "type", "EventName", "Status" , "Content" , "SenderSignature" , "DuplicateContentOrNot" , 
			                               "bubbles", "cancelable", "eventPhase" );
		}

	}//end class

}//end package


class CasualMessage {
		public static const Casual:String = "Casual";
}//end class