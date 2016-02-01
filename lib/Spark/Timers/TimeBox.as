package Spark.Timers
{
	import Spark.ErrorsInfo.MessageTool;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 時間管理單位
	 */
	public class TimeBox
	{
		private var _defaultDelay:int;							//未調整前原始執行速率
		public var _delay:int;										//執行速率
		public var _times:int;										//執行次數
		private var _needCount:int=0;						//觸發次數
		private var _count:int;										//當前觸發數
		
		private var _runFunction:Function;				//運行Function
		private var _runArgument:Array;				//運行參數
		private var _endFunction:Function;				//結束運行Function
		private var _endArgument:Array;				//結束運行參數
		
		private var _runTimes:int;								//已執行Function次數
		private var _belong:int;										//呼叫階段tick(0)/tock(1);
		private var _belongRun:Function;					//呼叫階段所屬Function
		private var _belongValue:Boolean=false;	//奇數階段所屬跳躍值
		private var _endRun:Boolean = false;			//是否運行結束
		private var _isRunning:Boolean = false;		//是否正在運行
		private var _cycle:Boolean = false;					//是否為無限循環
		private var _pause:Boolean = false;				//是否暫停中
		
		//private var tt:TimerTester = new TimerTester(1000, "boxtest");
		
		public function TimeBox(catchBox:Array):void 
		{
			this._delay = catchBox[0];
			this._times =catchBox[1];
			this._runFunction =catchBox[2];
			this._runArgument =catchBox[3];
			this._endFunction =catchBox[4]
			this._endArgument = catchBox[5];
			this._defaultDelay = catchBox[6];
			if (this._times == 0) { this._cycle = true };
			this._isRunning = true;
			//tt.setNormalCount();
		}
		
		//return 0[pause status]	,1[true work status]	,2[stop work status]
		//運行所屬區間Function
		public function CheckRun():int
		{
			return this._belongRun();
		}
		//奇數區間
		private function oddRun():int
		{
			//trace("RUN ODDRUN");
			if (this._pause) { return 0};
			
			if (this._count == 2) {
					if (this._belongValue) {
						//trace("STEP1");
						TimeDriver._manage.TiToProcess(this);
						//this._belongValue = !this._belongValue;
						this._count-- 
						return 3;
					}
			}
			
			if (this._count > 1) {
				this._count-- ;
				//trace("STEP2");
				return 1;
			}else {
				//trace("STEP3");
				this._count = this._needCount;
				return this.Run();
			}
		}
		//偶數區間
		private function evenRun():int 
		{
			//trace("RUN EVEN RUN",this._count,tt.getNormalCount());
			//tt.setNormalCount();
			if (this._pause) { return 0 };// trace("PAUSE>>>>",this._count);
			//trace("STEP2-dUo" );
			if (this._count > 1) {
				this._count-- ;
				return 1;
			}else {
				this._count = this._needCount;
				return this.Run();
			}
		}
		
		//cycle run(Mode1>> run & endRun not the same time call)[run 4 times>> call , call , call ,endCall];
		//if run4 times want[call, call, call, call ,endCall]>>just change STEP4 > ''this._times > 0''
/*		internal function Run():int 
		{
			if (!this._cycle ){
				trace("檢查次數>>",this._times);
				if(this._times > 1) {
					trace("STEP4");
					this._times-- 
				} else {
					trace("STEP5");
					return 2;
				}
			}
			
			this.justRunIt();
			trace("STEP6");
			return 1;
		}
		*/
			
		//運行判斷
		//cycle run(Mode2>> run & endRun in the same time call)[run 4 times>> call, call, call ,call & endCall];
		public function Run():int 
		{
			//trace("RUN");
			
			if (!this._cycle ){
				if(this._times > 1) {
					this._times-- 
				} else {
					this.justRunIt();
					return 2;
				}
			}
			this.justRunIt();
			return 1;
		}
		//運行Function
		private function justRunIt():void 
		{
			//trace("======RUN JUSTRUNIT======");
			if (this._runArgument != null) {
				this._runFunction.apply(null, this._runArgument);
			}else {
				this._runFunction();
			}
			this._belongValue = !this._belongValue;
			this._runTimes++;
		}
		
		//運行EndFunction
		public function Stop():Function 
		{
			this._endRun = true;
			this._isRunning = false;
			if(this._endFunction!=null){
				if (this._endArgument != null) {
					this._endFunction.apply(null, this._endArgument);
				}else {
					this._endFunction();
				}
			}
			return this._runFunction;
		}
		public function Pause():void 
		{
			this._pause = true;
			this._isRunning = false;
		}
		
		public function Resume():void 
		{
			if (this._pause) {
				this._count = this._needCount;
				this._pause = false;
				this._isRunning = true;
			}else {
				//throw new Error("Not in Pause status");
				MessageTool.InputMessageKey(601);
			}
		}
	
		
		//監控用值
		public function get IsRunning():Boolean
		{
			return this._isRunning;
		}
		
		public function get EndRun():Boolean 
		{
			return this._endRun;
		}
		
		public function get RunTimes():int 
		{
			return _runTimes;
		}
		
		public function get Delay():int 
		{
			return _delay;
		}
		
		public function get Cycle():Boolean 
		{
			return _cycle;
		}
		
		//輸入奇偶數處理後需要觸發前的運行次數
		public function set NeedCount(value:int):void 
		{
			//trace("Need count>>>", value);
			//if (this._needCount != 0) { throw new Error("'_needCount ' has been set"); return ; }//加入changeDrive時註解會重置到needcount
			this._count = value;
			this._needCount = value;
		}
		
		public function get Belong():int 
		{
			return this._belong;
		}
		
		public function set Belong(value:int):void 
		{
			this._belong = value;
			this._belongRun = value == 0 ? this.oddRun : this.evenRun;
			
			//odd normal run / even special run;
		}
		
		public function get DefaultDelay():int 
		{
			return _defaultDelay;
		}
		
		public function set DefaultDelay(delay:int):void 
		{
			this._defaultDelay = delay;
		}
		
		
		
		
		
		
		
		
		
	}
	
}