package MVCprojectOL.ModelOL.Vo.Set
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.11.08.11.10
		@documentation 通知SERVER該GUID建築物開始操作升級動作,SERVER回傳BuildingUpgrade
	 */
	public class Set_BuildUpgrade extends VoTemplate
	{
		
		public var _guid:String;
		
		
		public function Set_BuildUpgrade(guid:String):void 
		{
			super("CheckBuildUpgrade");//SERVER回傳VO型態
			this._guid = guid;
		}
	}
	
}