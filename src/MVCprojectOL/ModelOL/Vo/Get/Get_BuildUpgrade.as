package MVCprojectOL.ModelOL.Vo.Get
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.11.08.11.10
		@documentation SERVER須回傳該GUID的BuildingVO ( 升級過後的建築物資訊 )
	 */
	public class Get_BuildUpgrade extends VoTemplate
	{
		
		public var _guid:String;
		
		public function Get_BuildUpgrade(guid:String):void
		{
			super("BuildingUpgrade");//SERVER回傳的VO型態 ( 升級過後的建築物新VO)
			this._guid = guid;
		}
		
	}
	
}