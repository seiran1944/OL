package MVCprojectOL.ModelOL.Vo.Get
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.11.08.11.10
		@documentation 初始由SERVER拿取所有建築物清單
	 */
	public class Get_Building extends VoTemplate
	{
		
		//回傳所有建築物清單陣列 ( Building ) Array
		
		public function Get_Building():void 
		{
			super("Building");
		}
		
	}
	
}