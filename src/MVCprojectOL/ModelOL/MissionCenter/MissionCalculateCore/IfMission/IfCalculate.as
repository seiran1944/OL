package MVCprojectOL.ModelOL.MissionCenter.MissionCalculateCore.IfMission
{
	import MVCprojectOL.ModelOL.MissionCenter.MissionCalculateCore.MissionCalculateBase;
	
	/**
	 * ...
	 * @author ...EricHuang
	 * 任務計算機(暗照不同的條件去實做不同的計算)
	 */
	public interface IfCalculate
	{
		
		function injectionTarget(_class:MissionCalculateBase,_fun:Function):void
		function Calculate(_class:*):void
	    //--取得剛剛確實加總的計算任務---
		function GetCanCalculate():Array
		
		
	}
	
	
}