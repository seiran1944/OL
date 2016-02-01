package MVCprojectOL.ModelOL.Vo.Get
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	import flash.net.registerClassAlias;
	
	registerClassAlias("Get_PvpInit", Get_PvpInit);
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 取得PVP基本設定值 回傳 PvpInitData
	 */
	public class Get_PvpInit extends VoTemplate
	{
		
		
		public function Get_PvpInit():void 
		{
			super("PvpInitData");
		}
		
	}
	
}