package MVCprojectOL.ModelOL.Vo.Get
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author EricHuang
	 * ----拿所有從排程回來的東西(玩成排成所使用的)
	 */
	
	public class Get_Buildschedule extends VoTemplate
	{
		
		public var _schID:String = "";
		public var _buildType:int=0
		public function Get_Buildschedule (_id:String,_index:String,_type:int) 
		{
			super(_index);
			this._buildType = _type;
			this._schID = _id;
		}
		
	}
	
}