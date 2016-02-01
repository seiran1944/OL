package Spark.Utils.GlobalEvent.EventRegistry{
	
	/**
	 * @Engine Ignitor
	 * @Author K.J. Aris
	 * @Version 12.12.17.15.43
	 * @FlashPlayerVersion 11.2
	 * @Note This class records the registered members which have the same event request .
	 */
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import Spark.Utils.GlobalEvent.EventRegistry.EventClubMember;
	
	internal dynamic class EventClub{
		//Package Info for debug
		//private const _PackageInf:String = " * From Package EventCore.EventClub.as ";
		//private const _Version:String = "#ver 12.05.29.14.41 : ";
		//private const _LastEditor:String = " K.J. Aris ";
		
		private var _ClubName:String;//群組名稱為事件名稱
		private var _ClubMemberList:Dictionary = new Dictionary();//以EventClubMember.PostAddress作為索引
		//private var _ExecutionQueue:Vector.<Function> = new Vector.<Function>();
		
		public function EventClub( _InputClubName:String ):void {
			this._ClubName = _InputClubName;
		}
		
		internal function AddSingleMember( _InputMember:EventClubMember ):void {
			this._ClubMemberList[ _InputMember.PostAddress ] == null ? this.AddToList( _InputMember ) : trace("This post address has already been registered !! : " + _InputMember.PostAddress );
		}
		
		private function AddToList( _InputMember:EventClubMember ):void {
			this._ClubMemberList[ _InputMember.PostAddress ] = _InputMember;
			//this._ExecutionQueue.push( _InputMember.PostAddress );
		}
		
		internal function RemoveSingleMember( _InputPostAddress:Function ):Boolean {
			var _AnyOneBeenRemoved:Boolean = false;
			if ( this._ClubMemberList[ _InputPostAddress ] != null ) {
				/*var _TargetIndex:uint = this._ExecutionQueue.indexOf( _InputPostAddress );
				this._ExecutionQueue = this._ExecutionQueue.splice( _TargetIndex , 1 );*/
				
				this._ClubMemberList[ _InputPostAddress ] = null;
				delete this._ClubMemberList[ _InputPostAddress ];
				_AnyOneBeenRemoved = true;
			}
			return _AnyOneBeenRemoved;
		}
		
		internal function AnyMemberAlive():Boolean {
			var _SomeoneStillAlive:Boolean = false;
			for (var i:* in this._ClubMemberList ) {
				_SomeoneStillAlive = true;
				break;
			}
			return _SomeoneStillAlive;
		}
		
		internal function Dismiss():void {
			for ( var i:* in this._ClubMemberList ) {
				this._ClubMemberList[ i ] = null;
				delete this._ClubMemberList[ i ];
				this._ExecutionQueue.pop();
			}
			this._ExecutionQueue = null;
		}
		
		internal function get ClubName():String {
			return this._ClubName;
		}
		
		internal function get ClubMemberList():Dictionary {
			return this._ClubMemberList;
			//return Dictionary( this.MakeClone( this._ClubMemberList ) );
		}
		
		/*internal function get ExecutionQueue():Vector.<Function> {
			return this._ExecutionQueue;
			//return Vector.<Function>( this.MakeClone( this._ExecutionQueue ) );
		}*/
		
		/*private function MakeClone( _InputSource:* ):* {
				var _Clone:ByteArray = new ByteArray();
					_Clone.writeObject( _InputSource );
					_Clone.position = 0;
				return ( _Clone.readObject() );
		}*/
		
		
	}//end class
	
}//end package