package  MVCprojectOL.ModelOL.MissionCenter.MissionCalculateCore.factoryMis
{
	import MVCprojectOL.ModelOL.MissionCenter.MissionCalculateCore.MisCalculateCore;
	import MVCprojectOL.ModelOL.MissionCenter.MissionCalculateCore.MissionCalculateBase;
	import MVCprojectOL.ModelOL.Vo.MissionVO.Mission_mis_done;
	
	/**
	 * ...
	 * @author ...EricHuang
	 */
	public class  Mis_done extends MisCalculateCore 
	{
		override public function injectionTarget(_class:*):void 
		{
			//---用來轉型---
			
			this._misCalculate = _class as Mission_mis_done;
		}
		
		override public function Calculate(_class:MissionCalculateBase):void 
		{
			//---用來單獨處理
			this._misCalculate._missionDone = _class._missionDone;	
		}
		
	}
	
}