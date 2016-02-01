package Spark.MVCs.COMMANDS
{
	import Spark.coreFrameWork.commands.SingleCompleteCommands;
	import Spark.coreFrameWork.Interface.IfCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	
	/**
	 * ...
	 * @author EricHuang
	 * spark Modle註冊----
	 */
	public class StarSpark_Complete extends SingleCompleteCommands 
	{
		
		
		
		private var _aryCommands:Array = [MenuSeqCommand,BarProxyCommand,BarCommand,NetWorkCommand,SourceCommads,RegeistBarProxyCommands,TextDriftCommand];
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			if(this._aryCommands.length>0){
			var _check:int = 0;
			var _len:int = this._aryCommands.length;
			for (var i:int = 0; i < _len;i++) {
				_check++;
				var _commandClass:Class = this._aryCommands[i];
			    var _commands:IfCommands = new _commandClass();
				_commands.ExcuteCommand(_obj);
				if (_check == this._aryCommands.length) { 
				  this.onCompleteHandler(); 	
					
				}
			 }
			}
		}
	    
		
	}
	
}