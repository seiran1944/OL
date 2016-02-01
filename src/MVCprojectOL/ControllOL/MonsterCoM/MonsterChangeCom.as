package MVCprojectOL.ControllOL.MonsterCoM 
{
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	/**
	 * ...
	 * @author EricHuang
	 */
	public class MonsterChangeCom extends Commands
	{
	    
		//----registerNmae>PVECommands.MONSTER_VauleCANGE;
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			var _testName:String = String(_obj.GetClass());
			trace("MonsterBackkkkk___");
			
		}
		
		
		
	}

}