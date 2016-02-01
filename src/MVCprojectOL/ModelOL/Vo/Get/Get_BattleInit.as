package MVCprojectOL.ModelOL.Vo.Get
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	import flash.net.registerClassAlias;
	registerClassAlias( "Get_BattleInit" , Get_BattleInit );//
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class Get_BattleInit  extends VoTemplate
	{
		
		public var _battleId:String;
		
		public function Get_BattleInit(battleId:String):void
		{
			super("BattlefieldInit");
			this._battleId = battleId;
		}
		
		
	}
	
}