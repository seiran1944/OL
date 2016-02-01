package Spark.Timers
{
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.01.03.15.00
		@documentation 時間管理器運作系統
	 */
	public class TimeOperate 
	{
		private var _manage:TimeManage = TimeDriver._manage;
		private var _arrTickMember:Array = _manage._arrClockTick;
		private var _arrTockMember:Array = _manage._arrClockTock;
		private var _arrTiToMember:Array = _manage._arrClockTiTo;
		private var _arrSynchronism:Array = _manage._arrSynchronism;
		private var _tickTock:Boolean = false;
		//
		/*private var _tt:TimerTester = new TimerTester(10, "operate");
		public function TimeOperate():void 
		{
			this._tt.setNormalCount();
		}*/
		
		internal function runClock():void
		{
			//trace("Run OPERate", this._tt.getNormalCount());
			//this._tt.setNormalCount();
			
			this._tickTock = !this._tickTock;
			var runArr:Array= this._tickTock ?  this._arrTickMember : this._arrTockMember;
			
			var long:int = runArr.length ;
			var theBox:TimeBox;
			for (var i:int = long - 1; i >= 0;i--)
			{
				theBox = runArr[i];
				if (theBox != null) {
					if (theBox.CheckRun()==2 ) {
						this._manage.DelMember(theBox.Stop());
					}
				}
			}
			
			
			
			//奇數跳躍處理
			long = this._arrTiToMember.length;
			if(!this._tickTock && long>0){
			for ( i = long-1; i >=0 ; i--) 
			{
				theBox = _arrTiToMember[i];
				if (theBox != null) {
					if (theBox.CheckRun() == 2) {
						this._manage.DelMember(theBox.Stop());
					}
					this._arrTiToMember.pop();
				}
			}
			}
			//同步速率物件處理
			long = this._arrSynchronism.length;
			//trace("Synchronism", long);
			if (long>0) {
				for (i= long-1; i >=0 ; i--) 
				{
					theBox = _arrSynchronism[i];
					//trace("theBoxUP>",theBox);
					if (theBox != null) {
						if (theBox .CheckRun() == 2) {
							//trace("theBoxD>",theBox);
							this._manage.DelMember(theBox.Stop());
							this._arrSynchronism.pop();
						}
					}
				}
			}
			
		}
		
		
		
		
	}
	
}