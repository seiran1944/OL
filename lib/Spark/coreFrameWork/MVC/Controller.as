package Spark.coreFrameWork.MVC
{
	import flash.utils.getQualifiedClassName;
	//import MVCprojectOL.ControllOL.OpenLoading.OpenSystemCore;
	import Spark.coreFrameWork.commands.CatchCommands;
	import Spark.coreFrameWork.Interface.IfCatchCommands;
	import Spark.coreFrameWork.Interface.IfCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.observer.Observer;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author EricHuang
	 * mvc pattern--Controller----
	 */
	public class Controller 
	{
		
		private var _dicCommand:Dictionary;
		private var _aryCatch:Array;
		private var _view:View;
		//--- singleton pattern----
		private static var _instance:Controller;
		
		public function Controller()
		{
		   
		  if (Controller._instance != null) throw Error("[Controller] build illegal!!!please,use [Singleton]");
		   this._dicCommand = new Dictionary(true);	
		   this._aryCatch = [];
		   Controller._instance = this;
		   initControllerHandler();
		}
		
		
		private function initControllerHandler():void 
		{
			//--- 藉由singleton向facade拿到view的calass
			this._view = View.GetView();
		}
		
		//----Register user Command in View(command 註冊+view註冊observer)
		//-----考慮加入flag避免同時註冊兩種狀態----
		//----10/29參數_args>>用於註冊同一個command的情況下----
		public function RegisterCommand(_ObserverName:String,_commandClass:Class):void 
		{
			//trace("this.CheckCommandIng>>"+this.CheckCommandIng(_ObserverName));
			
			
			//---檢查commands是否為特化的Commands,如果是的話就實體建構
			var _checkClass:Boolean = this.CheckCommandIng(_ObserverName);
			trace("RegisterCommand>>" + _ObserverName);
			
			var _checkStr:String = (String(getQualifiedClassName(_commandClass)).split("::")[1]).substr(0, 5);
		    var _checLen:int = (String(getQualifiedClassName(_commandClass)).split("::")[1]).length;
			var _checkName:String = (String(getQualifiedClassName(_commandClass)).split("::")[1]).substr(0, _checLen);
		
			
			if (_ObserverName=="" &&_checkStr=="Catch" && (_commandClass is IfCatchCommands)==false ) {
				
				var _objClass:IfCatchCommands = new _commandClass();
				
				var _aryCommandsStr:Array = _objClass.GetListRegisterCommands();
	            //trace("catchARY}}}]]]]]]]]]"+_aryCommandsStr);
				if (_aryCommandsStr!=null && _aryCommandsStr.length != 0) {
				   //----直接註冊序列裡面的commands字串
				    this._aryCatch.push(_objClass);
					var _len:int = _aryCommandsStr.length;
				    for (var i:int = 0; i < _len;i++ ) {
					  //---檢查是否被時體化
					  //----不同名稱,相同的class--- 
					var _chekFlag:Boolean =true;
					if (this._dicCommand[_aryCommandsStr[i]]==null) {
						 this._dicCommand[_aryCommandsStr[i]] = [_objClass];
						
						} else {
						if (this.checkSameHandler(_aryCommandsStr[i], _checkName) == true) {
							
							this._dicCommand[_aryCommandsStr[i]].push(_objClass);
						}else {
							_chekFlag = false;
						}
						
					}	  
						
					  if(_chekFlag==true)this._view.RegisterObserver(_aryCommandsStr[i], new Observer(this, this.ExecuteCommand,_ObserverName,_checkName)); 
					  
					}	
				}
				
			   }else {
				  trace("RegisterCommand[_commandClass]---" + _ObserverName);
				  trace("_checkClass================"+_checkClass);
				 //-----相同名稱,不同的class----
				  
				 
				 //if(_checkClass==false)
				 var _checkFlagCommands:Boolean = true;
				 if (_checkClass==true) {
			      this._dicCommand[_ObserverName] = [_commandClass];
			      }else {
			        var _flagTest:Boolean = this.checkSameHandler(_ObserverName, _checkName);
					if (this.checkSameHandler(_ObserverName, _checkName) == true) {
					   this._dicCommand[_ObserverName].push(_commandClass);
					}else {
					   _checkFlagCommands = false;	
					}
			    }
				trace("_checkFlagCommands=============="+_checkFlagCommands);
				if(_checkFlagCommands==true)this._view.RegisterObserver(_ObserverName,new Observer(this,this.ExecuteCommand,_ObserverName,_checkName));
			}
				
		}
		
		
		
		private function checkSameHandler(_index:String,_class:String):Boolean 
		{
			
			var _ary:Array = this._dicCommand[_index];
			var _len:int = _ary.length;
			var _flag:Boolean = true;
			for (var i:int = 0; i < _len;i++ ) {
				
				var _checkLen:int= (String(getQualifiedClassName(_ary[i])).split("::")[1]).length;
				var _checkStr:String=(String(getQualifiedClassName(_ary[i])).split("::")[1]).substr(0,_checkLen); 
				if (_checkStr==_class) {
				  _flag = false;	
				  break;	
				}
				
			}
			return _flag;
		}
		
		//---10/29-----分段執行(同一個command下面掛載多個的執行狀況)
		
		
		public function ExecuteCommand(_index:IfNotifyInfo):void 
		{
			
			var _commandAry:Array= this._dicCommand[_index.GetName()];
			
			if (_commandAry == null || _commandAry.length==0) {
			   return;	
			   }else {
				//-----本體直到執行的時候才會被建構出來----(生命周期到執行結束就會被刪除)
				trace("ExecuteCommand"+"<<"+_index.GetName()+">>");
				var _len:int = _commandAry.length;
				for (var i:int = 0; i < _len; i++ ) {
				  var _commandCheck:Boolean = ( this._dicCommand[_index.GetName()][i] is IfCatchCommands)?true:false;
				  var _commandClass:Class = (_commandCheck==false)?this._dicCommand[_index.GetName()][i]:null;
				  var _executeCommand:IfCommands = (_commandClass!=null)?new _commandClass:this._dicCommand[_index.GetName()][i];
	              _executeCommand.ExcuteCommand(_index);
				  	
				}	
			} 	
		}
		
		
		
		//---10/29---_index註冊commands的名稱,_indexStr--實際commands的本體---
		public function RemoveCommand(_index:String,_indexStr:Object):void 
		{
			//trace("[NOT]RemoveCommands>>"+_index);
			if (!this.CheckCommandIng(_index)) {
				trace("RemoveCommands>-----" + "<<" + _index + ">>");
			 var _checkLen:int = (String(getQualifiedClassName(_indexStr)).split("::")[1]).length;
			 var _checkStr:String = (String(getQualifiedClassName(_indexStr)).split("::")[1]).substr(0, _checkLen);
			 //var _removeObj:Object = (_indexStr!=null)?_indexStr:this;
			 var _removeObj:Object = this;
			 //----11/24修正-------
			 this._view.RemoveObserver(_index,_removeObj,_checkStr);
			
				var _len:int = this._dicCommand[_index].length; 
				for (var i:int = 0; i < _len;i++ ) {
					var _targetLen:int= (String(getQualifiedClassName(this._dicCommand[_index][i])).split("::")[1]).length;
					var _targetStr:String=(String(getQualifiedClassName(this._dicCommand[_index][i])).split("::")[1]).substr(0,_targetLen);
					if (_targetStr==_checkStr) {
						this._dicCommand[_index].splice(i,1);
						break;	
					}  
				}
			    
				if(this._dicCommand[_index]==null || this._dicCommand[_index].length==0)delete this._dicCommand[_index];
				
			}else {
			    //----send errorEvent------
				return;	
			}
			
		}
		
		
		public function GetCatchCommand(_class:Object):IfCatchCommands
		{
			var _returnCommands:IfCatchCommands;
			var _checkClass:Class = _class as Class;
			//var _flag:Boolean=_class==
			var _targetLen:int= (String(getQualifiedClassName(_class)).split("::")[1]).length;
			var _targetStr:String=(String(getQualifiedClassName(_class)).split("::")[1]).substr(0,_targetLen);
			for (var i:* in this._aryCatch) {
			var _checkLen:int= (String(getQualifiedClassName(this._aryCatch[i])).split("::")[1]).length;
			var _checkStr:String=(String(getQualifiedClassName(this._aryCatch[i])).split("::")[1]).substr(0,_checkLen); 
				if (_checkStr == _targetStr) {
				  _returnCommands =IfCatchCommands( this._aryCatch[i]);
				  break; 
				}		
			}
			return _returnCommands;
		}
		
		//----11/24新增----
		public function RemoveCatchCommands(_class:Object):void 
		{
			var _returnCommands:IfCatchCommands = this.GetCatchCommand(_class);
			var _removeList:Array = _returnCommands.GetListRegisterCommands();
			var _len:int = _removeList.length;
			//---
			if (_removeList!=null && _removeList.length>0) {
				for (var i:int = 0; i < _len;i++ ) {
				  this.RemoveCommand(_removeList[i],_returnCommands);
			    }	
			}
			
			this.removeCatchAryHandler(_returnCommands);
		}
		
		
		private function removeCatchAryHandler(_class:Object):void 
		{
			//var _checkClass:Class = Class(_class);
		    var _len:int = this._aryCatch.length;
			for (var i:int = 0; i < _len; i++) {
			   if (this._aryCatch[i]==_class) {
				  this._aryCatch[i] = null;
				  this._aryCatch.splice(i,1);
				  break; 
				}		
			}
			
		}
		
		//---11/25----最好不要用XD
		public function RemoveSingleCatch(_index:String,_class:Object):void 
		{
			var _returnCommands:IfCatchCommands = this.GetCatchCommand(_class);
			var _ary:Array = _returnCommands.GetListRegisterCommands();
			if (_ary.indexOf(_index)!=-1) {
				this.RemoveCommand(_index,_class);
				
			}else {
				
			 trace("error----沒有該索引");	
			}
			
		}
		
		
		
		
		//----檢查目前是否有監聽註冊該對象-----
		public function CheckCommandIng(_index:String):Boolean 
		{
			var _flag:Boolean = (this._dicCommand[_index] == null || this._dicCommand[_index] == undefined)?true:false;
			return _flag;
		}
		
		//----facade init 會被啟動-----
		public static function GetController():Controller 
		{
			
			if (Controller._instance == null) Controller._instance = new Controller() ;
			return Controller._instance;
		}
		
		
	}
	
}

