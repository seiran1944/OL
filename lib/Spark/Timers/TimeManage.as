package  Spark.Timers
{
	import flash.utils.Dictionary;
	import Spark.ErrorsInfo.MessageTool;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.08.27.14.20
		@documentation 時間管理器庫存裝置
	 */
		public class  TimeManage
	{
		internal var _dicMember:Dictionary = new Dictionary ();
		internal var _arrClockTick:Array = [];										//half unit single
		internal var _arrClockTock:Array = [];										//half unit double
		internal var _arrClockTiTo:Array = [];										//single value use
		internal var _arrSynchronism:Array=[];									//synchronism rate use
		private var _speed:int;																		//Timer run rate
		
		internal function AddMember(runFunction:Function,tBox:TimeBox,delay:int):void
		{
			if (this._dicMember[runFunction] == null) {
				this._dicMember[runFunction] = tBox;
			}else {
				//throw new Error ("The function has been added>>",runFunction);
				MessageTool.InputMessageKey(602);
				return;
			}
			
			if (delay == this._speed) {
				tBox.NeedCount = 1;
				if (this._arrSynchronism != null) {
					this._arrSynchronism.push(tBox);
				}else {
					this._arrSynchronism = [tBox];
				}
				tBox.Belong = 2;
				return;
			}
			
			var needCount:Number = delay / this._speed / 2 ;
			var checkValue:Boolean = needCount is int;
			//trace("AddValue>>",delay,this._speed,needCount,checkValue);
			if (!checkValue) {//奇數狀態
				tBox.NeedCount = needCount + 1;
				this._arrClockTick .push(tBox);
				tBox.Belong = 0;
			}else {//偶數狀態
				tBox.NeedCount = needCount;
				this._arrClockTock.push(tBox);
				tBox.Belong = 1;
			}
			
		}
		
		internal function CheckRegister(runFunction:Function):Boolean 
		{
			return	this._dicMember[runFunction] == null ? false : true;
		}
		
		internal function TiToProcess(timeBox:TimeBox):void 
		{
			this._arrClockTiTo.push(timeBox);
		}
		
		//@param needBack = true 搭配ChangeDrive操作使用
		internal function DelMember(runFunction:Function,needBack:Boolean=false):TimeBox 
		{
			//trace("REMOVE TIMER FUNCTION CALL>>>", runFunction, needBack);
			var theBox:TimeBox = this._dicMember[runFunction] ;
			//trace("_arrClockTick>",_arrClockTick );
			//trace("_arrClockTock>", _arrClockTock );
			//trace("_arrClockTiTo", _arrClockTiTo);
			//trace("_arrSynchronism", _arrSynchronism);
			if (theBox!= null) {
				delete this._dicMember[runFunction];
				var cutArr:Array;
				var index:int;
				cutArr = theBox.Belong == 0 ? this._arrClockTick : this._arrClockTock;
				index = cutArr.indexOf (theBox);
				cutArr.splice(index, 1);
				
				index = this._arrSynchronism.indexOf(theBox);
				if(index>=0)	this._arrSynchronism.splice(index, 1);
				
				//不等運行後自動移除 因運行位置可能會被清除掉造成錯誤
				index = this._arrClockTiTo.indexOf(theBox);
				if(index>=0)	this._arrClockTiTo.splice(index, 1);
				//trace("finded-------------------------*" , index);
			//trace("_arrClockTick>",_arrClockTick );
			//trace("_arrClockTock>", _arrClockTock );
			//trace("_arrClockTiTo", _arrClockTiTo);
			//trace("_arrSynchronism", _arrSynchronism);
				//trace("收到註銷>>",index,theBox.Belong);
				if (!needBack) theBox = null;
			}else {
				//throw new Error("Your function is not in it");
			}
			
			return theBox;
		}
		
		internal function DelAll():void 
		{
			var member:*;
			for (member in this._dicMember)
			{
				this.DelMember(member);
			}
			
		}
		
		internal function AddPause(runFunction:Function):void 
		{
			this._dicMember[runFunction].Pause();
		}
		
		internal function Resume(runFunction:Function):void 
		{
			this._dicMember[runFunction].Resume();
		}
		
		internal function set speed(value:int):void 
		{
			this._speed = value;
		}
		
		
		
		
	}
	
}