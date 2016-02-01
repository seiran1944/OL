package MVCprojectOL.ModelOL.Vo.Get
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 取得戰場結果資料清單(舊款取全資料)
	 */
	public class  Get_BattleHistorical extends VoTemplate
	{
		
		//回傳ㄧ個Array 裝了限定期間內的所有基本單場戰鬥結果 ( BattlefieldInit )
		//>>>  [ BattlefieldInit , BattlefieldInit , BattlefieldInit , ... , ... , ..... ]
		//public var _checkTimes:uint;
		
		public function Get_BattleHistorical(checkTimes:uint):void
		{
			super("BattlefieldInit");
			//this._checkTimes = checkTimes;
		}
		
	}
	
}