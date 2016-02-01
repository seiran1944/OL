package Spark.coreFrameWork.commands
{
	import Spark.coreFrameWork.Interface.IfCommands;
	import Spark.coreFrameWork.Interface.IfNotify;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.observer.Notify;
	import flash.utils.Dictionary;
	
	/**
	 * 
	 * @author EricHuang
	 * <one in all commands>system 
	 * //----_flag==true>>代表執行一次就移除掉該commands,false=可以重復執行-----
	   //----PS>>_flag=true 代表執行過後該class就被銷毀,生命週期宣告結束-------
	   //--預設值=true(就是執行完畢會自行銷毀)
	 */
	 
	public class MacroCommands extends Notify implements IfCommands,IfNotify 
	{
		
		
		private var _aryCommands:Array;
		private var _removeFlag:Boolean;
	
		
		public function MacroCommands(_flag:Boolean=true) 
		{
		  this._aryCommands = [];
		  this._removeFlag = _flag;
		  this.initMacroCommands(); 
		}
		
		//----if you want to use init to do something,you must override this function*-*-------
		protected function initMacroCommands():void 
		{
			
		}
		
		//----push your commands---------
		public function AddCommands(_commands:Class):void 
		{
			this._aryCommands.push(_commands);
		}
		
		
		public final function ExcuteCommand(_obj:IfNotifyInfo):void 
		{
		    
			if(this._aryCommands.length>0){
			var _check:int = 0;
			var _len:int = this._aryCommands.length;
			for (var i:int = 0; i < _len;i++) {
				_check++;
				var _commandClass:Class = this._aryCommands[i];
			    var _commands:IfCommands = new _commandClass(); 
				_commands.ExcuteCommand(_obj);
				if (_check == this._aryCommands.length)this.RemoveCommands(); 
			 }
			}
		}
		
		public function RemoveCommands():void 
		{
			if (this._aryCommands.length > 0) {
			  
			  //this._removeFlag = null;
			  this._aryCommands = null;
			
			}
			
		}
		
	}
	
}