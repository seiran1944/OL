package MVCprojectOL.ModelOL.Vo.Get
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author EricHuang
	 * init取得玩家的排成表
	 * 
	 * //---Get_Buildschedule
	 */
	public class Get_PlayerBuildschedule extends VoTemplate 
	{
		
		
		public function Get_PlayerBuildschedule():void 
		{
			super("Buildschedule");
			trace("Buildschedule-------------------" + this._replyDataType);
			trace("Buildschedule--[player]-----------------"+this._playerID);
			
		}
		
	}
	
}