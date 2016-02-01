package Spark.MVCs.COMMANDS
{
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.commands.MacroCommands;
	import Spark.coreFrameWork.MVC.FacadeCenter;
	import Spark.MVCs.COMMANDS.BarCommand;
	import Spark.MVCs.COMMANDS.MenuSeqCommand;
	import Spark.MVCs.COMMANDS.NetWorkCommand;
	import Spark.MVCs.COMMANDS.SourceCommads;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class StarSpark extends  MacroCommands
	{
		
		//---use static str[StarUP_Spark]--------
		public function StarSpark()
		{
			
			super();
			
		}
		
		//---手動匯入------
		private var _aryCommand:Array = [MenuSeqCommand,BarCommand,NetWorkCommand,SourceCommads,RegeistBarProxyCommands];
		
		//----starUP spark------ 
		override protected function initMacroCommands():void
		{
		   var _len:int = this._aryCommand.length;
		    for (var i:int = 0; i < _len;i++ ) {
			    this.AddCommands(_aryCommand[i]); 
			}
		  
		}
		
		override public function RemoveCommands():void 
		{
		   super.RemoveCommands();
		   this._aryCommand = null;
		   FacadeCenter.GetFacadeCenter().RemoveCommand(CommandsStrLad.StarUP_Spark,StarSpark);
			
		}
		
		
		
	}
	
}