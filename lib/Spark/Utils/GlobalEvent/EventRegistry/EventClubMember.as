package Spark.Utils.GlobalEvent.EventRegistry{
	
	/**
	 * @Engine Ignitor
	 * @Author K.J. Aris
	 * @Version 12.05.29.14.41
	 * @FlashPlayerVersion 11.2
	 * @Note This class is the basic unit of event registry.
	 */
	
	internal dynamic class EventClubMember {
		//Package Info for debug
		//private const _PackageInf:String = " * From Package EventCore.EventClubMember.as ";
		//private const _Version:String = "#ver 12.05.29.14.41 : ";
		//private const _LastEditor:String = " K.J. Aris ";
		
		private var _RequiredEvent:String;
		private var _PostAddress:Function;
		private var _RecipientSignature:*;
		
		public function EventClubMember( _InputRequiredEvent:String , _InputPostAddress:Function , _InputRecipientSignature:* = null ):void {
			this._RequiredEvent = _InputRequiredEvent;
			this._PostAddress = _InputPostAddress;
			this._RecipientSignature = ( _InputRecipientSignature != null ) ? _InputRecipientSignature : "Anonymous";
		}
		
		public function get RequiredEvent():String {
			return _RequiredEvent;
		}
		
		public function get PostAddress():Function {
			return _PostAddress;
		}
		
		public function get RecipientSignature():* {
			return _RecipientSignature;
		}
		
		
		
	}//end class
	
}//end package