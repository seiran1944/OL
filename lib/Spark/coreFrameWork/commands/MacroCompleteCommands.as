package Spark.coreFrameWork.commands
{
	
	import Spark.coreFrameWork.Interface.IfCommands;
	import Spark.coreFrameWork.Interface.IfCompleteCommands;
	import Spark.coreFrameWork.Interface.IfFacade;
	import Spark.coreFrameWork.Interface.IfNotify;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.MVC.FacadeCenter;
	import Spark.coreFrameWork.observer.Notify;
	
	/**
	 * ...
	 * @author ...ericHuang
	 * 該class只有灌入SingleCompleteCommands才能使用
	 */
	public class MacroCompleteCommands extends Notify implements IfCommands,IfNotify 
	{
		
		
		//---提供繼承的使用,讓使用command的使用者直接掉用facade-----
		protected var _facaed:IfFacade = FacadeCenter.GetFacadeCenter();
		protected var _aryCommands:Array;
		
		protected var _commandsNote:IfNotifyInfo;
		
		protected var _complete:Function;
		
		public function MacroCompleteCommands() 
		{
			this._aryCommands = [];
			this.initMacroCompleteCommands();
		}
		
		//----if you want to use init to do something,you must override this function*-*-------
		protected function initMacroCompleteCommands():void 
		{
			
		}
		
		//----push your commands---------
		public function AddCommands(_commands:Class):void 
		{
			this._aryCommands.push(_commands);
		}
		
		public final function ExcuteCommand(_obj:IfNotifyInfo):void 
		{
		    this._commandsNote = _obj;
			//trace("MacroComplete>"+this._commandsNote.GetClass()._PlayerID);
			
			//trace("_PlayerID>"+PlayerDataCenter._PlayerID);
			//trace("_ServGateWay>"+PlayerDataCenter._ServGateWay);
			//trace("_ServDomain>"+PlayerDataCenter._ServDomain);
			this.nextCommandsHandler();
		}
		
		
		public function SetComplete(_fun:Function):void 
		{
			this._complete = _fun;
		}
		
		
		protected function nextCommandsHandler():void 
		{
			
			if (this._aryCommands.length>0) {
				
				var _commandClass:Class = this._aryCommands.shift();
				var _commands:Object = new _commandClass();
				var _flag:Boolean = _commands is IfCompleteCommands;
				if (_flag) IfCompleteCommands(_commands).setComplete(this.nextCommandsHandler);
				IfCompleteCommands(_commands).ExcuteCommand(this._commandsNote);
				if (!_flag) this.nextCommandsHandler();
				} else {
				
				if (this._complete != null) this._complete();
				this._commandsNote = null;
				this._complete = null;
				
			}
			
	
			
		}
		
		
	}
	
}



/*
 *
 * ==========Example===========
 * 
 * package MVCprojectOL.ControllOL
{
	import Spark.coreFrameWork.commands.SingleCompleteCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	
	
	public class CompleteA extends SingleCompleteCommands 
	{
	    
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			trace("i am CompleteA");
			//-----you can do anything---------
			this.onCompleteHandler();
			
			
		}
	   	
	}
	
}
 * 
=================================================================================
//---CompleteA,CompleteB,CompleteC>>寫法跟上面一樣(都要繼承SingleCompleteCommands)
 public class TestMacroCompleteCommands extends MacroCompleteCommands 
	{
		
		
		override protected function initMacroCompleteCommands():void 
		{
			var _ary:Array = [CompleteA,CompleteB,CompleteC];
		   	var _len:int = _ary.length;
			for (var i:int = 0; i < _len;i++ ) {
				this.AddCommands(_ary[i]);
			}
			this.SetComplete(this.onCompleteMacroHadler);
		}
		
		private function onCompleteMacroHadler():void 
		{
			ProjectOLFacade.GetFacadeOL().RemoveCommand("MacroComplete",TestMacroCompleteCommands);
			
		}
		
	
		
	}
 * 
 * 
 * 
 * 
 */

