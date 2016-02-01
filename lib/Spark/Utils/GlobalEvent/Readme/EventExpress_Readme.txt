EventExpress	is a static class

	Public methods:
		

		DispatchGlobalEvent( _InputEventName:String , _InputStatus:String = null , _InputContent:Object = null , _InputSenderSignature:* = null , _DuplicateContentOrNot:Boolean = true ):void

			@ Function: To dispath a global event , anyone who have registered compatible Event Name will recive an Event Package as a notification.

			
			_InputEventName:String		=	Event code that you wanna send

			_InputStatus:String		=	Secondary Event code for special identification , default as a String "Causual" if no input
	
			_InputContent:Object		=	Values or Objects you wanna send to the recipients , wrap it up before you send	

			_InputSenderSignature:*		=	A Signature for identification	, default as a String "Anonymous" if no input

			_DuplicateContentOrNot:Boolean		=	true : Make a copy of "Content" for recipients , incase that some values been modified by recipients.
									false : Send original "Content" for recipients , recipients will recive an pointer points to the original object, any modification by recipients will change Sender's original value. 



		AddEventRequest( _InputRequiredEvent:String , _InputPostAddress:Function , _InputRecipientSignature:* = null ):void
			
			@ Function: To register an Event that you wanna recive , when a compatible Event occur , 'PostAddress' will recive an Event Package as a notification.	


			_InputRequiredEvent:String 	=	Event code that you wanna recive

			_InputPostAddress:Function 	=	When a specific event recied , an EventPackage will be sent to this function 
	
			_InputRecipientSignature:*	=	A Signature for identification	, default as a String "Anonymous" if no input



		RevokeEventRequest( _InputRequiredEvent:String , _InputPostAddress:Function ):Boolean
			
			@ Function: To revoke an Event that you have registered , there will be no notification for the event anymore.

			
			_InputRequiredEvent:String	=	Event code you registered when Adding

			_InputPostAddress:Function	=	Function that you registered when Adding

			Boolean		=	true : Event request revoked successfully 	false : No event request been revoked



		CheckEventRequestStatus( _InputRequiredEvent:String , _InputPostAddress:Function ):Boolean
			
			@ Function: To check an Event has been registered or not , if it does , returning "true" , not , "false";

			_InputRequiredEvent:String	=	Event code you registered when Adding

			_InputPostAddress:Function	=	function that you registered when Adding



		ListRegisteredEvent( ):Dictionary

			@ Function: Show the Event List containing Event Names which are still requested.
			
			
			
			
EventExpressPackage is a Event that recipient will 	recive

	public properties : 
		
		
			
			
			
			
			
			
			
			
			
			
			
@ Example:
	
	package Events{
		public class EventName {
			public static const IveGotPresentForYou:String = "IveGotPresentForYou";
		}
	}
	
	package EventStatus {
		public class EventStatus {
			public static const IwantToConfess:String = "IwantToConfess";	
		}
	}
	
	
	
	
	
	
	package {
		import flash.utils.setTimeout;
		import GlobalEvent.EventExpress;
		import Events.EventName;
		import Events.EventStatus;
	
		public class ModuleSender {
			private var _Name:String = "";
			private var _Gift:Object = new Object();
		
			public function ModuleSender( _InputName:String ):void {
				this._Name = _InputName;
			
				this._Gift["Message"] = "I Love You !!";
				this._Gift["CellNumber"] = 987987987;
			
				setTimeout( this.SendMessage , 1000 );
			}
		
			private function SendMessage():void {
				trace( " ModuleSender '" + this._Name + "' has send a golbal event package " );
				EventExpress.DispatchGlobalEvent( EventName.IveGotPresentForYou , EventStatus.IwantToConfess , this._Gift , this._Name );
			}
		}
	}
	
	
	
	
	
	package {
		import GlobalEvent.EventExpress;
		import GlobalEvent.EventExpressPackage;
		import Events.EventName;
		import Events.EventStatus;
	
		public class ModuleReceiver{
			private var _Name:String = "";
			public function ModuleReceiver( _InputName:String ):void {
				this._Name = _InputName;
				EventExpress.AddEventRequest( EventName.IveGotPresentForYou , this.MailBox , this );
			}
		
			private function MailBox( EVT:EventExpressPackage ):void {
				trace( " ModuleReceiver '" + this._Name + "' has recived a golbal event package '" + EVT.EventName + "' from : " , EVT.SenderSignature );
				if ( EVT.Status == EventStatus.IwantToConfess ) {
					for (var i:* in EVT.Content ) {
						trace( "			" +  i + " = " + EVT.Content[ i ] );
					}
				}
			}
		}
	}
	
	
	
	
	
	@========in Main : 
			var _Sender:ModuleSender = new ModuleSender( "Jack" );//劈腿Jack發送禮物
			
			var _Reciever:ModuleReceiver = new ModuleReceiver( "Rose" );//Rose美眉會收到
			var _Reciever2:ModuleReceiver = new ModuleReceiver( "Alisa" );//Alisa美眉會收到
			var _Reciever3:ModuleReceiver = new ModuleReceiver( "Reona" );//Reona美眉會收到
			var _Reciever4:ModuleReceiver = new ModuleReceiver( "Yuna" );//Yuna美眉會收到
			
			
		Output Result : 
			
			ModuleSender 'Jack' has send a golbal event package 
			ModuleReceiver 'Alisa' has recived a golbal event package 'IveGotPresentForYou' from : Jack
						Message = I Love You !!
						CellNumber = 987987987
			ModuleReceiver 'Rose' has recived a golbal event package 'IveGotPresentForYou' from : Jack
						Message = I Love You !!
						CellNumber = 987987987
			ModuleReceiver 'Yuna' has recived a golbal event package 'IveGotPresentForYou' from : Jack
						Message = I Love You !!
						CellNumber = 987987987
			ModuleReceiver 'Reona' has recived a golbal event package 'IveGotPresentForYou' from : Jack
						Message = I Love You !!
						CellNumber = 987987987
	