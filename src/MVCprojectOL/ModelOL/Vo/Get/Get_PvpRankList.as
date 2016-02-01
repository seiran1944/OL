package MVCprojectOL.ModelOL.Vo.Get
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	import flash.net.registerClassAlias;
	registerClassAlias("Get_PvpRankList", Get_PvpRankList);
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 取得新榜單資料
	 */
	public class Get_PvpRankList  extends VoTemplate
	{
		
		
		public function Get_PvpRankList():void 
		{
			super("PvpRankingUpdate");
		}
		
	}
	
}