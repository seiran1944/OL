package MVCprojectOL.ModelOL.ShopMall.basic
{
	import MVCprojectOL.ModelOL.ShopMall.InterFaceCore.IfSetMallTarget;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class  SettingBasic implements IfSetMallTarget
	{
		private var _targetID:String;
		
		//--商城消費類型---
		private var _Type:int;
		
		private var _buildType:int;
		
		//--送建築物的GUID(line>_target)
		private var _missionType:String;
		
		private var _schID:String;
		
		private var _valType:String;
		
		//---消費型態
		public function set Setting(_obj:Object):void 
		{
			if (_obj._tagretID != null) this._targetID = _obj._tagretID;
			if (_obj._type != null) this._Type = _obj._type;
			if (_obj._build != null) this._buildType = _obj._build;
			if (_obj._schID != null) this._schID = _obj._schID;
			if (_obj._mission != null) this._missionType = _obj._mission;
			if (_obj._valType != null) this._valType = _obj._valType;
			//if (_obj._build != null) this._buildType = _obj._build;
		}
		
		
		public function get targetID():String 
		{
			return _targetID;
		}
		
		public function get Type():int 
		{
			return _Type;
		}
		
		public function GetSettingInfo():Object 
		{
			var _returnObj:Object = { 
				_targetID:this._targetID ,
			    _type:this._Type,
				_build:this._buildType,
				_mission:this._missionType,
				_schID:this._schID,
				_valType:this._valType
				};
			return _returnObj;
		}
		
		
		

	}
	
}