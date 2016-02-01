package MVCprojectOL.ModelOL.TipsCenter.DisplayobjLab
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import MVCprojectOL.ModelOL.TipsCenter.Basic.TimerBar;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import Spark.Timers.TimeDriver;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class  SingleTimerBar extends Sprite
	{
		private var _timerBar:TimerBar;
		private var _nowTime:int;
		private var _completeTimes:int;
		private var _totalTies:int;
		public var _buildType:int;
		
		public function SingleTimerBar(_obj:SendTips,_displayContent:DisplayObject) 
		{
		    if (_obj!=null && _displayContent!=null) {
				
				this._completeTimes = _obj.complete;
				this._nowTime = _obj.nowTime;
				this._totalTies = _obj.total;
				this._buildType = _obj.buildType;
				this.CreatTimeBar(_displayContent);
			}   
			
			
		}
		
		//---{_bar:Sprite,_completeTime:int,_totalTime:int,_text:Object}
		private function CreatTimeBar(_infor:DisplayObject):void 
		{
			//this.addChild(_infor);
			//this._timerBar = new TimerBar(this);
			//
			this.addChild(_infor);
			this._timerBar = new TimerBar(this);
			this._timerBar.AddSource(Sprite(_infor));

			
		}
		
		public function StarTimes(_obj:SendTips=null):void 
		{
		    this._timerBar.SetHandler(this._nowTime, this._completeTimes, this._totalTies);
			this.OpenClose(true);
		}
		
		private function OpenClose(_flag:Boolean):void 
		{
			
			if (_flag==true) {
				//----註冊----
				if (!TimeDriver.CheckRegister(this._timerBar.TimingHandler)) {
			     //----準備註冊阿翔的timer
			        TimeDriver.AddDrive(1000, 0, this._timerBar.TimingHandler);
					trace("register[timeBar]_timerDriver");
			     }
				} else {
				//---移除註冊
				if (TimeDriver.CheckRegister(this._timerBar.TimingHandler)) {
					TimeDriver.RemoveDrive(this._timerBar.TimingHandler);
					trace("remove[timeBar]_timerDriver");
				}
			}
			//this.visible = _flag;
			this._timerBar.OpenCloseFlag(_flag);
        }
		
		
		public function ResetTimer(_nowTime:int):void 
		{
			this._nowTime = _nowTime;
			this._timerBar.SetHandler(this._nowTime, this._completeTimes, this._totalTies);
			this.OpenClose(true);
			//this._timerBar.OpenCloseFlag(true);
		}
		
		public function Close():void 
		{
			this.OpenClose(false);
		}
		
		public function Remove():void 
		{
			
			this.OpenClose(false);
			this._timerBar.RemoveBar();
			
		}
		
		
	}
	
}