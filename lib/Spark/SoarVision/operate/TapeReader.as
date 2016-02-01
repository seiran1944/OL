package Spark.SoarVision.operate
{
	import flash.display.MovieClip;
	import Spark.SoarVision.interfaces.IClip;
	import Spark.SoarVision.interfaces.IMultiTape;
	import Spark.SoarVision.interfaces.ITape;
	import Spark.SoarVision.interfaces.ITapeBasic;
	import Spark.SoarVision.interfaces.ITapeInfo;
	import Spark.SoarVision.VisionCenter;
	import Spark.Utils.GlobalEvent.EventExpress;

	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.11.30.17.32
		@documentation 播放器
	 */
	public class TapeReader 
	{
		
		//依種類預置運行位置
		public function BufferTape(tape:ITapeBasic):void
		{
			
			switch (true)
			{
				case tape is ITape :
					ITape(tape).VisionRun = this.playForPic;
				break;
				case tape is IClip://預留播放影格狀態
					IClip(tape).VisionRun = this.playForClip;
				break;
			}
			//trace("tapBuffer",className,index,cut);
		}
		
		public function ChangeTape(tape:ITape,source:Array,play:Boolean,once:Boolean , reverse:Boolean,motionTimes:uint):void 
		{
			tape.VisionContent(source, play ? "play" : "stop", once , reverse, motionTimes);
		}
		
		public function ChangeClip(tape:IClip,clip:MovieClip,play:Boolean,once:Boolean,reverse:Boolean,motionTimes:uint):void 
		{
			tape.VisionInfo(play ? "play" : "stop", once, reverse, motionTimes);
			tape.VisionClip(clip);
		}
		
		//reverse>> 2反轉 , 0 false , 1 true;
		public function TurnReverse(tape:ITapeInfo,reverse:int=0):void 
		{
			if (reverse != 2) {
				tape.VisionReverse = reverse == 0 ? false : true;
				//trace("TAPE SET REVERSE>>>", tape._reverse,reverse );
			}else {
				tape.VisionReverse = !tape.VisionReverse;
				//trace("TAPE !!!!!!!REVERSE ", tape._reverse,reverse);
			}
		}
		
		public function ResetScreen(tape:ITapeInfo,setPosition:int=-1):void 
		{
			var threshold:int = !(tape is IMultiTape) ?  1 : IMultiTape(tape).VisionThreshold ;
			tape.VisionPosition = setPosition == -1 ? !tape.VisionReverse ? threshold : tape.VisionLong : setPosition;
			tape.VisionRun(tape, setPosition==-1 ? !tape.VisionReverse ? threshold  : tape.VisionLong : setPosition);
		}
		
		//pause / play / stop
		public function WriteStatus(tape:ITapeInfo,status:String):void
		{
			tape.VisionStatus = status;
		}
		
		public function WriteOnce(tape:ITapeInfo,once:Boolean):void
		{
			tape.VisionOnce = once;
		}
		
		public function WriteMotionsTimes(tape:ITapeInfo,motionsTimes:uint):void 
		{
			tape.VisionSpeed = motionsTimes;
		}
		
		public function Read(tape:ITapeInfo):void 
		{
			//trace("in reading",tape.VisionStatus);
			if (tape.VisionStatus == "play") {
				this.toPlay(tape);
			}
		}
		
		//calculate run place
		private function toPlay(tape:ITapeInfo):void
		{
			var curShow:int = tape.VisionPosition;
			var long:int = tape.VisionLong;
			var threshold:int = !(tape is IMultiTape) ? 1 : IMultiTape(tape).VisionThreshold;
			var once:Boolean = tape.VisionOnce;
			//trace("currentTHRESHOLD>>", curShow+" <<",threshold,long,once,tape.VisionReverse);
			
			if (curShow < long) {
				curShow += !tape.VisionReverse ? 1 : curShow == threshold ? once ? -curShow- 1 : -curShow+long : -1 ;
				//trace("if",curShow);
			}else {//last pic/ currentShow == finalframe
				curShow = !tape.VisionReverse ? once ? -1 : threshold : curShow - 1;
				//trace("else",curShow);
			}
			
			if (curShow == -1) {//once狀況處理
				tape.VisionStatus = "stop";
				//運行一次的停止時機點需發送通知(夾帶容器本身送出)
				//EventExpress.DispatchGlobalEvent(VisionCenter.VISION_ENDONCE , tape is IMultiTape ? IMultiTape(tape).Command : "" ,  );//若為指令集類型容器 則夾帶當前指令名稱 反之空字串;
				EventExpress.DispatchGlobalEvent( VisionCenter.VISION_ENDONCE + tape.VisionID, tape is IMultiTape ? IMultiTape(tape).Command : "", tape );
				return;
			}
			tape.VisionRun( tape, curShow);
			tape.VisionPosition = curShow;
			//trace("檢測圖示位置",tape.VisionPosition,tape.VisionLong,tape.VisionOnce,curShow);
		}
		
		private function playForPic(tape:ITape,show:int):void
		{
			tape.VisionRunner.bitmapData = tape.VisionSource[show - 1];
			//trace("收到show為", show);
			//trace("runningPIC >>", show,">>",IMultiTape(tape).VisionThreshold+"/"+tape.VisionLong);
		}
		
		private function  playForClip(tape:IClip,show:int):void
		{
			//trace("收到show為", show);
			tape.VisionRunner.gotoAndStop(show);
		}
		
		
		
		
		
		
	}
	
}