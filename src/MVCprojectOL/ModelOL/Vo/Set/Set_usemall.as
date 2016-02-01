package MVCprojectOL.ModelOL.Vo.Set
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author EricHuang
	 * 商城消費
	 * 
	 * $object->_mallType = 2 ; // 亂數重新取得進化技能  20130527 zoearth
		$object->_targetID //魔物唯一ID

	 * 
	 * $this->_object->_mallType = 1; //怪物回血
        $this->_object->_valType = 'hp';
        $this->_object->_targetID = 'MOB136868694489605'; //目標ID

			或是

        $this->_object->_mallType = 1; //怪物回疲勞
        $this->_object->_valType = 'fatigue';
        $this->_object->_targetID = 'MOB136487317243568'; //目標ID

	 */
	public class Set_usemall extends VoTemplate
	{
		//----加速類型的type送0
		public var _mallType :int = 0;
		
		public var _targetID:String = "";
		//----如果是建築物升級的加速這邊也送0
		public var _buildType:int = -1;
		//---serever動作辨識---
		public var _valType:String = "";
		//----偽裝成
		public var _fackSchid:String = "";
		
		
		public function Set_usemall (_replyName:String,_obj:Object,_fack:String=""):void 
		{
			super(_replyName);
			if (_fack != "") this._fackSchid = _fack;
			if (_obj._type != null) this._mallType = _obj._type;
			if (_obj._targetID != null) this._targetID = _obj._targetID;
			if (_obj._buildType != null) this._buildType = _obj._buildType;
			if (_obj._valType != null) this._valType = _obj._valType;
			
		}
		
	}
	
}