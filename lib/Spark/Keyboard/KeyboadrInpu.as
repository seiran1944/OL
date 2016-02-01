package Spark.Keyboard
{
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	import Spark.coreFrameWork.Interface.IfNotify;
	import Spark.coreFrameWork.observer.Notify;
	
	/**
	 * ...
	 * @author EricHuang
	 * //---提供keyboard送notify的工具
	 */
	public class KeyboadrInpu extends Notify implements IfNotify
	{
		
		
		//private var _vecKeyCode:Vector.<KeyBoardStates> = new Vector.<KeyBoardStates>();
		private var _dicKeyCode:Dictionary;
		//----要把commands放進來(屬於keyboard的)
		private static var _KeyBoardInfo:KeyboadrInpu;
		
		protected var _dicKeyBoardCommands:Dictionary;
		
		public function KeyboadrInpu() 
		{
			this._dicKeyCode = new Dictionary(true);
			this._dicKeyBoardCommands = new Dictionary(true);
		}
		
		
		public static function GetKeyBoard():KeyboadrInpu 
		{
			if (KeyboadrInpu._KeyBoardInfo == null)KeyboadrInpu._KeyBoardInfo= new KeyboadrInpu();
			return KeyboadrInpu._KeyBoardInfo;
		}
		
		
		//--------override it-----------------------
		public function KeyDownEvtHandler(e:KeyboardEvent):void 
		{
			//--------check----------------------
			if (this._dicKeyCode[e.keyCode]==undefined || !(this._dicKeyCode[e.keyCode].downFlag)) {
				return;
				} else {
				//---switch && lock-------
				this._dicKeyCode[e.keyCode].DownClose();
				
			}
		}
		
		private function sendNotifyCenter(_notifyName:String,body:Object=null):void 
		{
			this.SendNotify(_notifyName,body);
		}
		
		//--------unlock---------
		public function KeyboardComplete(_keyCode:uint):void 
		{
			if (this._dicKeyCode[_keyCode]!=undefined) {	
			this._dicKeyCode[_keyCode].Complete();	
			}
		}
		
		//---add new keyboard states-------
		public function AddKeyBoadrd(_str:String,_keyCode:uint):void 
		{
			
			if (this._dicKeyCode[_keyCode]==undefined) {	
			var _KeyBoardStates:KeyBoardStates = new KeyBoardStates();
			_KeyBoardStates._keyName = _str;
			this._dicKeyCode[_keyCode] = _KeyBoardStates;	
			}
		}
		
		
		public function RemoveKeyboard(_keyCode:uint):void 
		{
		   if (this._dicKeyCode[_keyCode]!=undefined)delete this._dicKeyCode[_keyCode];
		}
		
		
		
		public function Remove():void 
		{
		  this._dicKeyCode = null;		
		}
		
		
		
		
		
	}
	
}



//---防止連擊裝置------
class KeyBoardStates {
	
	
	private var _downFlag:Boolean = false;
	public var _keyName:String = "";
	
	
	public function get downFlag():Boolean 
	{
		return _downFlag;
	}

    
 	public function DownClose():void 
	{
		this._downFlag = true;
	}
	
	public function Complete():void 
	{
		if (_downFlag==true)_downFlag=false;
		
	}

	
}