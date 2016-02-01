package Spark.coreFrameWork.commands
{
	import Spark.coreFrameWork.Interface.IfCompleteCommands;
	
	/**
	 * ...
	 * @author ...EricHuang
	 * 10/26新增>>用於需要在commands執行完畢後,接續執行特殊的function---
	 * [該class只適用'單一'的commands]
	 */
	public class SingleCompleteCommands extends Commands  implements IfCompleteCommands
	{
		
		
		private var _function:Function;
		public function setComplete(_fun:Function):void
		{
			this._function = _fun;
		}
		//-----you can do anything---------
		protected function onCompleteHandler():void 
		{
			
			if (this._function != null) this._function ();
		}
		
		
		
	}
	
}

/*
========Example=========================

package MVCprojectOL.ControllOL
{
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.commands.SingleCompleteCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	
	 public class  SimpleCompleteTEST extends Commands
	{
		
		
		override public function ExcuteCommand(_obj:IfNotifyInfo):void 
		{
			var _singleComplete:SingleCompleteCommands = new TargetSingleComplete();
			_singleComplete.setComplete(this.CompleteCheck);
			//---不需要註冊直接去SingleCompleteCommands調用方法
			_singleComplete.ExcuteCommand(_obj);	
			
		}
		
		private function CompleteCheck():void 
		{
			
		}
		
	}
	
}

package MVCprojectOL.ControllOL
{
	import Spark.coreFrameWork.commands.SingleCompleteCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	
	
	public class  TargetSingleComplete extends SingleCompleteCommands
	{
		
		
		
		
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			//-----you can do anything---------
			this.onCompleteHandler();
			
			
		}
	   
		
		
		
	}
	
}





*/






