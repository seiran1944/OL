package MVCprojectOL.ModelOL.Vo.Get
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author ...Eric Huang
	 * 取得任務
	 * 2013/05/09---
	 * (會在更新)
	 */
	public class  Get_Mission extends VoTemplate
	{
		//---ary裡面放MissionConditionComplete陣列
		public var _aryMission:Array;
		public function Get_Mission(_misAry:Array)
		{
			super("Get_Mission");
			
			this._aryMission = _misAry;
		}
			
	}
	
}