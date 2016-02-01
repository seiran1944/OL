package MVCprojectOL.ModelOL.Vo.Get
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author ...Eric Huang
	 * 取得獎勵品
	 * 2013/05/09---
	 */
	public class Get_MissionReward extends VoTemplate
	{
		
		public var _missionID:String = "";
		
		public function Get_MissionReward(_guid:String="")
		{
			super("Get_MissionReward");
			this._missionID = _guid;
		}
	}
	
}