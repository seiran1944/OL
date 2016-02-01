package  Spark.Utils.GlobalEvent{
	
	/**
	 * @Engine Ignitor
	 * @Author K.J. Aris
	 * @Version 12.11.09.16.02
	 * @FlashPlayerVersion 11.2
	 * @Note This module core dispatchs global events that can penetrate hole system to communicate different modules without adding additional Event Listener. Follow the register step will do.
	 */
	
	import flash.events.EventDispatcher;
	import Spark.Utils.GlobalEvent.*;
	import Spark.Utils.GlobalEvent.EventRegistry.EventManager;
	import flash.utils.Dictionary;
	
	public class EventExpress {
		//Package Info for debug
		//private const _PackageInf:String = " * From Package EventCore.EventExpress.as ";
		//private const _Version:String = "#ver 12.11.09.16.02 : ";
		//private const _LastEditor:String = " K.J. Aris ";
		
		private static const _EventManager:EventManager = new EventManager();
		
		/**
		 * @Function : To dispath a global event , anyone who have registered compatible Event Name will recive an Event Package as a notification.
		 * @param	_InputEventName:String		=	Event code that you wanna send
		 * @param	_InputStatus:String		=	Secondary Event code for special identification , default as a String "Causual" if no input
		 * @param	_InputContent:Object		=	Values or Objects you wanna send to the recipients , wrap it up before you send
		 * @param	_InputSenderSignature:*		=	A Signature for identification	, default as a String "Anonymous" if no input
		 * @param	_DuplicateContentOrNot:Boolean		=	true : Make a copy of "Content" for recipients , incase that some values been modified by recipients.
															false : Send original "Content" for recipients , recipients will recive an pointer points to the original object, any modification by recipients will change Sender's original value.
		 */
		public static function DispatchGlobalEvent( _InputEventName:String , _InputStatus:String = null , _InputContent:Object = null , _InputSenderSignature:* = null , _DuplicateContentOrNot:Boolean = true ):void {
			//trace( _InputSenderSignature + " Dispatched A Global Event" );
			EventTransferStation( new EventExpressPackage( _InputEventName , _InputStatus , _InputContent , _InputSenderSignature , _DuplicateContentOrNot ) );
		}
		
		
		/**
		 * @Function : To register an Event that you wanna recive , when a compatible Event occur , 'PostAddress' will recive an Event Package as a notification.	
		 * @param	_InputRequiredEvent:String	=	Event code that you wanna recive
		 * @param	_InputPostAddress:Function =	When a specific event recied , an EventExpressPackage will be sent to this function 
		 * @param	_InputRecipientSignature:*	=	A Signature for identification	, default as a String "Anonymous" if no input
		 */
		public static function AddEventRequest( _InputRequiredEvent:String , _InputPostAddress:Function , _InputRecipientSignature:* = null ):void {
			_EventManager.AddEventMember( _InputRequiredEvent , _InputPostAddress , _InputRecipientSignature );
		}
		
		
		/**
		 * @Function : To revoke an Event that you have registered , there will be no notification for the event anymore.
		 * @param	_InputRequiredEvent:String	=	Event code you registered when Adding
		 * @param	_InputPostAddress:Function	=	Function that you registered when Adding
		 * @return	Boolean		=	true : Event request revoked successfully 	false : No event request been revoked
		 */
		public static function RevokeEventRequest( _InputRequiredEvent:String , _InputPostAddress:Function ):Boolean {
			//true = Event request has been revoked		false = No any event request has been revoked
			return _EventManager.RemoveEventMember( _InputRequiredEvent , _InputPostAddress );
		}
		
		
		/**
		 * @Function : To check if an Event has been registered or not , if it does , returning "true" , not , "false";
		 * @param	_InputRequiredEvent:String	=	Event code you registered when Adding
		 * @param	_InputPostAddress:Function	=	function that you registered when Adding
		 * @return	Boolean : true = Event request exist	,	false = Event request does not exist
		 */
		public static function CheckEventRequestStatus( _InputRequiredEvent:String , _InputPostAddress:Function ):Boolean {
			//true = Event request exist		false = Event request does not exist
			return _EventManager.CheckEventClubMemberExist( _InputRequiredEvent , _InputPostAddress );
		}
		
		
		/**
		 * @Function : Show the Event List which are still requested , showing by Event Names.
		 * @return	Dictionary : The Event List ( Read Only )
		 */
		public static function ListRegisteredEvents( ):Dictionary {
			trace( "====Registered Events : ====" );
			for (var i:String in _EventManager.ClubList ) {
				trace( "		" + i );
			}
			return _EventManager.ClubList;
		}
		
		
		private static function EventTransferStation( EVT:EventExpressPackage ):void {
			//Transfer to event club
			_EventManager.Transport_To( EVT , EVT.EventName );//Index of EventClub list is builded with "EVT.EventName"
		}
		
		
		//=========120717		Added
		/**
		 * @Function : This method will revoke all event requests which have the same requirement of event name .
		 * @param	_InputRequiredEvent : Event Name ( the specific event gruop will be removed entirely if it's exist )
		 * @return Boolean		=	true : Event request revoked successfully 	false : No event request been revoked
		 */
		public static function RevokeEventRequestGroup( _InputRequiredEvent:String ):Boolean {
			//true = Event requests have been revoked		false = No any event request has been revoked
			return _EventManager.DismissClub( _InputRequiredEvent );
		}
		
		
		/**
		 * @Function : This method will revoke a single event request by using it's Function registry.
		 * @param	_InputPostAddress : Function registry ( the single event request will be removed )
		 * @return Boolean		=	true : Event request revoked successfully 	false : No event request been revoked
		 */
		public static function RevokeAddressRequest( _InputPostAddress:Function ):Boolean {
			//true = Event requests have been revoked		false = No any event request has been revoked
			return _EventManager.EventMemberWanted( _InputPostAddress );
		}
		//====END==120717		Added
		
	}//end class
	
}//end package
