package Spark.Utils.GlobalEvent.EventRegistry{
	
	/**
	 * @Engine Ignitor
	 * @Author K.J. Aris
	 * @Version 12.12.18.09.33
	 * @FlashPlayerVersion 11.2
	 * @Note This class records every EventClub that has been created , it will also check and block repeated registration in the list.
	 */
	
	import flash.utils.Dictionary;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	import Spark.Utils.GlobalEvent.EventRegistry.EventClub;
	import Spark.Utils.GlobalEvent.EventRegistry.EventClubMember;
	
	public final dynamic class EventManager{
		//Package Info for debug
		//private const _PackageInf:String = " * From Package EventCore.EventManager.as ";
		//private const _Version:String = "#ver 12.11.09.16.02  : ";
		//private const _LastEditor:String = " K.J. Aris ";
		
		private var _ClubList:Dictionary = new Dictionary();//以事件名稱作為清單索引
		
		public function EventManager():void {
			//this._ClubList = _InputClubList;
			//trace( "Event Manager is on duty" );
		}
		
		public function get ClubList():Dictionary {
			return _ClubList;
		}
		
		public function AddEventMember( _InputRequiredEvent:String , _InputPostAddress:Function , _InputRecipientSignature:* ):void {
			( this.CheckEventClubExist( _InputRequiredEvent ) == false ) ?
				this.CreateNewClub( _InputRequiredEvent , this.RegisterNewMember( _InputRequiredEvent , _InputPostAddress , _InputRecipientSignature ) )
				:
				this.ClubList[ _InputRequiredEvent ].AddSingleMember( this.RegisterNewMember( _InputRequiredEvent , _InputPostAddress , _InputRecipientSignature ) );
		}
		
		public function RemoveEventMember( _InputRequiredEvent:String , _InputPostAddress:Function ):Boolean {
			var _EventClubExist:Boolean = this.CheckEventClubExist( _InputRequiredEvent );//
			if ( _EventClubExist == true ) {
				_EventClubExist = this._ClubList[ _InputRequiredEvent ].RemoveSingleMember( _InputPostAddress );
				( this._ClubList[ _InputRequiredEvent ].AnyMemberAlive() == false ) ? this.DismissClub( _InputRequiredEvent ) : null;//Dismiss Club when there's no any member exist
			}
			return _EventClubExist;
		}
		
		public function EventMemberWanted( _InputPostAddress:Function ):Boolean {
			var _AnyBeenCaught:Boolean = false;
			for ( var i:String in _ClubList ) {
				( this._ClubList[ i ].RemoveSingleMember( _InputPostAddress ) ) == true ? ( _AnyBeenCaught = true ) : null ;
				( this._ClubList[ i ].AnyMemberAlive() == false ) ? this.DismissClub( i ) : null;//Dismiss Club when there's no any member exist
			}
			return _AnyBeenCaught;
		}
		
		public function CheckEventClubExist( _InputClubName:String ):Boolean {
			return ( this._ClubList[ _InputClubName ] == null ) ? false : true;
		}
		
		public function CheckEventClubMemberExist( _InputRequiredEvent:String , _InputPostAddress:Function ):Boolean {
			return ( this.CheckEventClubExist( _InputRequiredEvent ) == true ? ( this._ClubList[ _InputRequiredEvent ][ _InputPostAddress ] != null ? true : false) : false );
		}
		
		private function CreateNewClub( _InputClubName:String , _InputFirstMember:EventClubMember ):void {
			this._ClubList[ _InputClubName ] = new EventClub( _InputClubName );
			this._ClubList[ _InputClubName ].AddSingleMember( _InputFirstMember );
		}
		
		public function DismissClub( _InputClubName:String ):Boolean {
			//true = a club has been dismissed		false = no club has been dismissed
			var _AnyClubBeenDismissed:Boolean = this.CheckEventClubExist( _InputClubName );
			if ( _AnyClubBeenDismissed == true ) {
				this._ClubList[ _InputClubName ].Dismiss();
				this._ClubList[ _InputClubName ] = null;
				delete this._ClubList[ _InputClubName ];
			}
			//trace( "Club " + _InputClubName + " Has Been Dismissed !! " );
			return _AnyClubBeenDismissed;
		}
		
		private function RegisterNewMember( _InputRequiredEvent:String , _InputPostAddress:Function , _InputRecipientSignature:* ):EventClubMember {
			return new EventClubMember( _InputRequiredEvent , _InputPostAddress , _InputRecipientSignature );
		}
		
		//=============================Event Transporter
		public function Transport_To( EVT:EventExpressPackage , _InputTargetGroupName:String ):Boolean {
			//Check if there's any specific Event require
			var _TargetClubExist:Boolean = this.CheckEventClubExist( EVT.EventName );
			( _TargetClubExist == true ) ? this.EventTransportor( EVT , _InputTargetGroupName ) : trace("There's no any requiring of event '" + _InputTargetGroupName + "'" );
			return _TargetClubExist;
		}
		
		private function EventTransportor( EVT:EventExpressPackage , _InputTargetGroupName:String ):void {
			//this function will transport "EVT" to every member in "_InputTransportTargetGroup"
			//trace( "Transporting Package to " + _InputTargetGroupName + " Group. " );
			/*var _CurrentClub:EventClub = this._ClubList[ _InputTargetGroupName ];
			var _TransportList:Vector.<Function> = _CurrentClub.ExecutionQueue;
			//var _TransportListLength:uint = _TransportList.length;
			
			for (var i:int = 0 ; i < _TransportList.length ; i++) {
				//i = ( _TransportListLength != _TransportList.length ) ? ( i += _TransportList.length - _TransportListLength ) : i;
				if ( this.CheckEventClubExist( _InputTargetGroupName ) == true ) {//如果傳送途中  有人將事件群組解散了  將會出錯 因此需在每次遞送時檢查群組狀態 120717
					_TransportList[ i ] != null ?
						//this._ClubList[ _InputTargetGroupName ].ClubMemberList[ i ].PostAddress( ( EVT.DuplicateContent == true ) ? EVT.Clone() : EVT )
						_TransportList[ i ]( ( EVT.DuplicateContent == true ) ? EVT.Clone() : EVT )
						:
						this.EventMemberWanted( _TransportList[ i ] );
				}
			}*/
			
			
			/*for ( var i:* in this._ClubList[ _InputTargetGroupName ].ClubMemberList ) {
				if ( this.CheckEventClubExist( _InputTargetGroupName ) == true ) {//如果傳送途中  有人將事件群組解散了  將會出錯 因此需在每次遞送時檢查群組狀態 120717
					this._ClubList[ _InputTargetGroupName ].ClubMemberList[ i ].PostAddress != null && _DeliveredAddress[ this._ClubList[ _InputTargetGroupName ].ClubMemberList[ i ] ] != true ?
						this._ClubList[ _InputTargetGroupName ].ClubMemberList[ i ].PostAddress( ( EVT.DuplicateContent == true ) ? EVT.Clone() : EVT )
						:
						this.EventMemberWanted( this._ClubList[ _InputTargetGroupName ].ClubMemberList[ i ].PostAddress );
				}
			}*/
			
			var _DeliveredAddress:Dictionary = new Dictionary( true );//收發單 遞送過的目標簽名
			var _TargetGroup:Dictionary = this._ClubList[ _InputTargetGroupName ].ClubMemberList;
			var _CurrentTarget:EventClubMember;
			for ( var i:* in _TargetGroup ) {
				if ( this.CheckEventClubExist( _InputTargetGroupName ) == true ) {//如果傳送途中  有人將事件群組解散了  將會出錯 因此需在每次遞送時檢查群組狀態 120717
					_CurrentTarget = _TargetGroup[ i ];
					if ( _CurrentTarget.PostAddress != null ) {//當目標地址存在時才進行遞送任務
						if ( _DeliveredAddress[ _CurrentTarget ] != true ) {//只遞送未簽名標註的目標
							_DeliveredAddress[ _CurrentTarget ] = true;//標註遞送過的地址(防止DICTIONARY刪存時 造成位置推移 而重複遞送)
							_CurrentTarget.PostAddress( ( EVT.DuplicateContent == true ) ? EVT.Clone() : EVT );
						}
					}else {//當目標地址已不存在時  則撤銷其相關的所有註冊
						this.EventMemberWanted( _CurrentTarget.PostAddress );
					}
				}
			}
		}
		//=======================END===Event Transporter
		
		
		
	}//end class
}//end package