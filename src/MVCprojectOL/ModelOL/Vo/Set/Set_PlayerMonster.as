package MVCprojectOL.ModelOL.Vo.Set
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class  Set_PlayerMonster extends VoTemplate
	{
		//----1.EXP改變2.HP改變3.ENG改變4吃石頭後5.使用掛賣6.技能學回來7.裝備狀態改變8.怪獸穿裝備9.其他的使用狀態
		public var _type:int = -1;
		
		//--PS--5屬性用在[吞食石頭使用/技能/裝備]
		//---_HP用在改變的HP
		//---_guid=怪獸的guid
		public var _stoneId:String = "";
		
		public var _skillId:String = "";
		
		public var _equID:String ="";
		
		//public var _equType:int = 0;
		//---經驗值
		public var _EXP:int = 0;
		//---疲勞度
		public var _ENG:int = 0;
		//--monsterGuid
		public var _guid:String = "";
		//---生命值
		public var _HP:int = 0;
		
		
		//---使用狀態
		public var _useing:int = 0;
		public function Set_PlayerMonster(_setName:String,_obj:Object) 
		{
			super(_setName);
			if (_obj._type != null && _obj._type != undefined) this._type = _obj._type;
			if (_obj._stoneId != null && _obj._stoneId != undefined) this._stoneId = _obj._stoneId;
			if (_obj._skillId != null && _obj._skillId != undefined) this._skillId = _obj._skillId;
			if (_obj._equID != null && _obj._equID != undefined) this._equID = _obj._equID;
			//if (_obj._equType != null && _obj._equType != undefined) this._equType = _obj._equType;
			if (_obj._EXP != null && _obj._EXP != undefined) this._EXP = _obj._EXP;
			if (_obj._ENG != null && _obj._ENG != undefined) this._ENG = _obj._ENG;
			if (_obj._HP != null && _obj._HP != undefined) this._HP = _obj._HP;
			if (_obj._guid != null && _obj._guid != undefined) this._guid = _obj._guid;
			if (_obj._useing != null && _obj._useing != undefined) this._useing = _obj._useing;
			
		}
		
		
		
	}
	
}