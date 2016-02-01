package MVCprojectOL.ModelOL.Vo.Get
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	import flash.net.registerClassAlias;
	
	registerClassAlias("Get_BattleInfoList",Get_BattleInfoList );
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.02.04.17.33
		@documentation 取得初始戰報的顯示資料清單//會回傳Array > [BattleReport,...]
	 */
	public class Get_BattleInfoList extends VoTemplate
	{
		
		
		public function Get_BattleInfoList():void 
		{
			super("BattleReport");
		}
		
	}
	
}