package MVCprojectOL.ModelOL.SkillData {
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Vo.Skill;
	import MVCprojectOL.ModelOL.Vo.SkillEffect;
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.06.14.14.14
	 */
	public final class SkillDataCenter {
		private static var _SkillDataCenter:SkillDataCenter;//singleton pattern
		
		private var _SkillList:Dictionary;
		//private var _SkillEffectList:Dictionary;
		
		//private var _SkillListClone:Array;
		//private var _SkillEffectListClone:Array;
		public var _UpgradeSkillList:Array;
		
		public static function GetInstance():SkillDataCenter {//IfProxy
			return SkillDataCenter._SkillDataCenter = ( SkillDataCenter._SkillDataCenter == null ) ? new SkillDataCenter() : SkillDataCenter._SkillDataCenter; //singleton pattern
		}
		
		public function SkillDataCenter() {
			SkillDataCenter._SkillDataCenter = this;
			this._SkillList = new Dictionary();
			//this._SkillEffectList = new Dictionary();
		}
		
		//===================================Skills
		public function CreateSkill( _InputSkill:Skill ):void {
			this._SkillList[ _InputSkill._guid ] = _InputSkill;
			//trace( _InputSkill._guid , "<<<<Added" );
		}
		
		//------skillclone-----2013/3/15
		public function GetSkill( _InputSkillKey:String ):Skill {
			//return this._SkillList[ _InputSkillKey ] != null ? this.MakeClone( Object( this._SkillList[ _InputSkillKey ] ) )  : null;//Skills are constant VOs can not be written by others. return clones only. 
			var _Result:Skill;
			if ( this._SkillList[ _InputSkillKey ] != null ) {
				_Result = this.MakeClone( Object( this._SkillList[ _InputSkillKey ] ) ) as Skill;
			}
			return _Result;
		}
		
		/*public function get SkillList():Array {
			return  this._SkillListClone = ( this._SkillListClone == null ) ? this.MakeListClone( this._SkillList ) : this._SkillListClone;
		}*/
		
		//----2013/01/16----ericHuang
		//-------
		public function GetSingleIconKey(_key:String):String {
			var _key:String = (this._SkillList[ _key ]!=null)?this._SkillList[ _key ]._iconKey:"";
			
			return _key;
		}
		//----2013/05/24----ericHuang
		public function GetSingleNmae(_key:String):String {
			var _name:String = (this._SkillList[ _key ] != null)?this._SkillList[ _key ]._name:"undefind";
			return _name;
		}
		
		
		//============================END====Skills
		
		/*public function GetRandomSkillInfo( _InputNumber:uint = 3 ):Array {	//130527
			var _TempSkillList:Array = [ ];
			for (var i:* in this._SkillList ) {
				_TempSkillList.push( this._SkillList[ i ] );
			}
			_TempSkillList = this.Shuffle( _TempSkillList );
			//_TempSkillList = _TempSkillList.slice( 0 , _InputNumber );
			
			var _ResultList:Array = [ ];
			var _CurrentData:Object;
			for (var j:int = 0; j < _InputNumber ; j++) {
				_CurrentData = this.MakeClone( Object( _TempSkillList[ j ] ) );
				//_CurrentData = _TempSkillList[ j ];
				_ResultList.push( _CurrentData );
			}
			return _ResultList;
			
			
			//return _TempSkillList;
		}*/
		
		public function GetRandomSkillInfo( _InputNumber:uint = 3 ):Array {//130614
			this.Shuffle( this._UpgradeSkillList );
			var _TempSkillList:Array = [ ];
			for (var i:int = 0; i < _InputNumber && i < this._UpgradeSkillList.length ; i++) {
				_TempSkillList.push( this.GetSkill( this._UpgradeSkillList[ i ] ) );
			}
			
			return _TempSkillList;
		}
		
		
		
		//===================================SkillEffects
		/*public function CreateSkillEffect( _InputSkillEffect:SkillEffect ):void {
			this._SkillEffectList[ _InputSkillEffect._guid ] = _InputSkillEffect;
			//trace( _InputSkillEffect._guid , "<<<<Added" );
		}
		
		public function GetSkillEffect( _InputSkillEffectKey:String ):Object {
			return this._SkillEffectList[ _InputSkillEffectKey ] != null ?  this.MakeClone( Object( this._SkillEffectList[ _InputSkillEffectKey ] ) )  : null;//SkillEffects are constant VOs can not be written by others. return clones only. 
		}
		
		public function get SkillEffectList():Array {
			return this._SkillEffectListClone = ( this._SkillEffectListClone == null ) ? this.MakeListClone( this._SkillEffectList ) : this._SkillEffectListClone;
		}*/
		//============================END====SkillEffects
		
		private function MakeClone( _InputSource:Object ):Object {
				var _Clone:ByteArray = new ByteArray();
					_Clone.writeObject( _InputSource );
					_Clone.position = 0;
				return ( _Clone.readObject() );
		}
		
		/*private function MakeListClone( _InputList:Dictionary ):Array {
			var _CloneList:Array = [];
			for (var i:* in _InputList ) {
				_CloneList.push( this.MakeClone( Object( _InputList[ i ] ) ) );
			}
			return _CloneList;
		}*/
		
		public function Shuffle(  _InputArray:Array  ):Array {
			var _RandIndex:int = 0;
			var _len:int = _InputArray.length - 1;
			for (var a:int = 0; a < _len; a++) {
				_RandIndex = Math.round( Math.random()*( _len ) );
				Swap( _InputArray , a , _RandIndex );
			}
			return _InputArray;
		}
		
		private function Swap( _InputArray:Array , i:int , j:int ):void {
			var _Temp:* = _InputArray[i];
			_InputArray[i] = _InputArray[j];
			_InputArray[j] = _Temp;
		}
		
	}//end class
}//end package