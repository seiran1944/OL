package MVCprojectOL.ModelOL.Vo.Get
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class Get_BattleInit_Design  extends VoTemplate
	{
		
		public var _battleId:String;
		
		public function Get_BattleInit_Design(battleId:String):void
		{
			super("BattlefieldInit");
			this._battleId = battleId;
		}
		
		
	}
	
}