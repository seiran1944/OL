package MVCprojectOL.ModelOL.MonsterDisplayModel {
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author K.J. Aris
	 * 
	 * @version 12.12.12.12.12
	 */
	public class MonsterClipDepot {
		private static var _MonsterClipDepot:MonsterClipDepot;
		private const _ComponentDepot:Dictionary = new Dictionary( true );
		
		public static function GetInstance():MonsterClipDepot {
			return MonsterClipDepot._MonsterClipDepot = ( MonsterClipDepot._MonsterClipDepot == null ) ? new MonsterClipDepot() : MonsterClipDepot._MonsterClipDepot; //singleton pattern
		}
		
		public function MonsterClipDepot() {
			MonsterClipDepot._MonsterClipDepot = this;
		}
		
		public function Inquiry( _InputClipClass:Class , _InputDataType:Class ):* {
			return this._ComponentDepot[ _InputClipClass ] = ( this._ComponentDepot[ _InputClipClass ] == null ) ? 
					( new  _InputClipClass() as _InputDataType )
					:
					this._ComponentDepot[ _InputClipClass ];
		}
		
		
	}//end class
}//end package