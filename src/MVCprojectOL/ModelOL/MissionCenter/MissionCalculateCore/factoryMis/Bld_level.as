package  MVCprojectOL.ModelOL.MissionCenter.MissionCalculateCore.factoryMis
{
	import MVCprojectOL.ModelOL.MissionCenter.MissionCalculateCore.MisCalculateCore;
	import MVCprojectOL.ModelOL.MissionCenter.MissionCalculateCore.MissionCalculateBase;
	import MVCprojectOL.ModelOL.Vo.MissionVO.Mission_bld_level;
	
	/**
	 * ...
	 * @author ...EricHuang
	 */
	public class  Bld_level extends MisCalculateCore 
	{
		override public function injectionTarget(_class:MissionCalculateBase):void 
		{
			//---用來轉型---
			
			this._misCalculate = _class;
		}
		
		override public function Calculate(_class:*):void 
		{
			var _calTarget:Mission_bld_level = _class as Mission_bld_level;
			//---用來單獨處理
			//this._misCalculate._lv = _class._lv;	
		}
		
	}
	
}