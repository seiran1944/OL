package MVCprojectOL.ModelOL.Vo.Get
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.11.08.11.10
		@documentation 取得玩家所有隊伍
	 */
	public class Get_Troop extends VoTemplate
	{
		
		//回傳所有隊伍清單 ( Troop ) Array;
		
		public function Get_Troop():void 
		{
			super("Troop");//記錄SERVER需要回傳的VO型態
		}
	}
	
}