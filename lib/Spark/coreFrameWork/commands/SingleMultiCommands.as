package Spark.coreFrameWork.commands
{
	import flash.utils.Dictionary;
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.Interface.IfFacade;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	
	/**
	 * ...
	 * @author EricHuang
	 * 單次commands執行並且蒐集[多次]相關的數據完畢----
	 * 小凱的下載工具,結取數據包裝
	 */
	public class  SingleMultiCommands extends CatchCommands
	{
		
		private var _facade:IfFacade;
		private var _registerStr:String;
		private var _aryKey:Array;
		private var _dicSource:Dictionary;
		private var _starCommandsFlag:Boolean;
		private var _SourceProxy:SourceProxy;
		private var _check:int;
		private var _function:Function;
		
		public function SingleMultiCommands(_name:String,_facede:IfFacade,_key:Array) 
		{
		   this._facade = _facede;
		   this._registerStr = _name;
		   this._aryKey = _key;
		   this._starCommandsFlag = false
		   this._check = 0;
		   this._dicSource = new Dictionary(true);
		   this._facade.RegisterCommand(_name, this);
		   
		}
		
		override public function ExcuteCommand(_obj:IfNotifyInfo):void
		{
			if (this._starCommandsFlag==false) {
				//---CommandsStrLad.SourceSystem
				this._SourceProxy= SourceProxy(this._facade.GetProxy(CommandsStrLad.SourceSystem).GetData());
				//-----啟動小凱的拿素材工具(帶入this._aryKey,整批拿)
				//_SourceProxy.
				this._starCommandsFlag = true;
			}else {
				this._check ++;
				this.resNotiyfHandler(_obj);
				
			}
			
		}
		
		
		public function SetSaveFunction(_fun:Function):void 
		{
			this._function = _fun;
		}
		
		
		
		private function resNotiyfHandler(_obj:IfNotifyInfo):void 
		{
			var _str:String = String(_obj.GetClass());
			//---在回連一次拿到素材,callfunction拿到回傳的素材
			//var _source:*......
			this._dicSource[_str] = _source;
			if (this._check==_aryKey.length) {
				this._function(this._dicSource);
				this._facade.RemoveCommand(this._registerStr,this);
				
			}
			
			
			
			
		}
		
		
	}
	
}