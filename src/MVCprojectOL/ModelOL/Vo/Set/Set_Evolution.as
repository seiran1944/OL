package MVCprojectOL.ModelOL.Vo.Set
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class  Set_Evolution extends VoTemplate
	{
		
		
		public var _evoId:String = "";
		public var _targetID:String = "";
		public var _otherID:String = "";
		//public var _skill:String = "";
		public function Set_Evolution(_evo:String,_monster:String,_otherMonster:String="") 
		{
			super("Set_Evolution");
			this._evoId = _evo;
			this._targetID = _monster;
			this._otherID = _otherMonster;
			
		}
		
		
	}
	
}