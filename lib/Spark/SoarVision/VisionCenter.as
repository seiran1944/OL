package Spark.SoarVision
{
	import flash.display.MovieClip;
	import Spark.ErrorsInfo.MessageTool;
	import Spark.SoarVision.interfaces.IClip;
	import Spark.SoarVision.interfaces.IMultiTape;
	import Spark.SoarVision.interfaces.ITape;
	import Spark.SoarVision.interfaces.ITapeBasic;
	import Spark.SoarVision.interfaces.ITapeInfo;
	import Spark.SoarVision.operate.TapeReader;
	import Spark.SoarVision.operate.TapeSack;
	import Spark.SoarVision.operate.TapeShelf;
	import Spark.SoarVision.single.BitmapVision;
	import Spark.Timers.TimeDriver;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.11.26.15.30
		@documentation 動態播放控制中心
	 */
	public class VisionCenter
	{
		
		protected static var _visionCenter:VisionCenter;
		protected var _speed:uint;
		protected var _shelf:TapeShelf;
		protected var _reader:TapeReader;
		public static const VISION_ENDONCE:String = "visionEndOnce";
		
		public function VisionCenter():void
		{
			if (VisionCenter._visionCenter != null) throw new Error("This class can't be constructed");
			VisionCenter._visionCenter = this;
			this._shelf = new TapeShelf();
			this._reader = new TapeReader();
		}
		
		/**
		 * 取得動態播放控制區
		 */
		public static function GetInstance():VisionCenter
		{
			if (VisionCenter._visionCenter == null) VisionCenter._visionCenter = new VisionCenter();
			return VisionCenter._visionCenter;
		}
		
		/**
		 * 初始預設運行速率--註冊沒改變運行速率時一律以此速度運行
		 * @param	speed 預設40 ( 毫秒 / 張 ) [ 25 FPS ] 
		 */
		public function Start(speed:uint=40):void
		{
			if (this._speed == 0) {
				TimeDriver.AddDrive(speed, 0, playVision);
			}else {
				if (this._speed != speed) TimeDriver.ChangeDrive(this.playVision, speed);
			}
			this._speed = speed;
			
		}
		
		/**
		 * 停止播放運行(整體註冊預設速度的動態播放停止)
		 */
		public function Stop():void
		{
			TimeDriver.RemoveDrive(this.playVision);
		}
		
		/**
		 * 取得預設播放運行的速率 ( 毫秒 / 張 )
		 */
		public function get Speed():uint 
		{
			return this._speed;
		}
		
		/**
		 * 清空所有註冊的容器
		 * @param	deleteInstance 是否回收實體內部資源
		 */
		public function RemoveAllRegister(deleteInstance:Boolean=false):void
		{
			this._shelf.EraseAll(deleteInstance);
		}
		
		//run operation
		private function playVision():void
		{
			//trace("playingVision");
			for each (var i :ITapeInfo in this._shelf.Shelf)
			{
				this._reader.Read(i);
			}
		}
		
		//All User Use Movie Control
		
		/**
		 * 註冊單一素材型態
		 * @param	tape 播放容器
		 * @param	source 播放圖像(順序放置)
		 * @param	play 是否開始播放圖像
		 * @param	once 是否只單次播放
		 * @param	reverse 是否反轉播放
		 * @param	motionTimes 自訂播放速度(非同步運行)  [毫秒 / 張] ( 0 為不變更)
		 */
		public function AddSinglePlay(tape:ITape ,source:Array ,play:Boolean ,once:Boolean=false , reverse:Boolean=false,motionTimes:uint=0):void
		{
			if (tape is IMultiTape) MessageTool.InputMessageKey(806);//註冊類型錯誤
			
			this._reader.BufferTape(tape);
			this._shelf.WritePlayInfo(tape, source, play ? "play" : "stop", once, reverse, motionTimes==0 ? this._speed : motionTimes);
			//this._shelf.WritePlayInfo(tape, source, play ? "play" : "stop", once , reverse, motionTimes);
			
			motionTimes != 0 ? this._shelf.WriteSack(tape, this._reader) : this._shelf.Write(tape);
		}
		
		/**
		 * 註冊多素材型態
		 * @param	tape 播放容器
		 * @param	source 播放圖像(順序放置)
		 * @param	cmdInfo 指令集(不同指令對應不同播放,區間順序由小到大排列) EX: { run: {op: 1 , ed: 2 } , jump: { op: 3 , ed: 5 } , fly: { op: 6 , ed:10 } }
		 * @param	command 選則播放區間 EX : 如上指令集可帶入 "run" / "jump" / "fly"
		 * @param	play 是否開始播放圖像
		 * @param	once 是否只單次播放
		 * @param	reverse 是否反轉播放
		 * @param	motionTimes 自訂播放速度(非同步運行)  [毫秒 / 張] ( 0 為不變更)
		 */
		public function AddMultiPlay(tape:IMultiTape,source:Array,cmdInfo:Object ,command:String ,play:Boolean , once:Boolean=false , reverse:Boolean=false,motionTimes:uint=0):void 
		{
			this._reader.BufferTape(tape as ITapeBasic);
			
			this.checkCommands(cmdInfo);//檢查註冊的屬性(可省略)
			
			this._shelf.WritePlayInfo(tape as ITape, source, play ? "play" : "stop", once, reverse, motionTimes==0 ? this._speed : motionTimes ,cmdInfo,command);
			//this._shelf.WritePlayInfo(ID, play ? "play" : "stop" , once, reverse, motionTimes , command);
			
			motionTimes != 0 ? this._shelf.WriteSack(tape as ITapeInfo, this._reader) : this._shelf.Write(tape as ITapeBasic);
		}
		
		
		//預留MovieClip影格播放
		/**
		 * 註冊MovieClip影格播放方式
		 * @param	tape 播放掛載Class
		 * @param	play 是否開始播放圖像
		 * @param	cmdInfo 指令集(不同指令對應不同播放,區間順序由小到大排列) EX: { run: {op: 1 , ed: 2 } , jump: { op: 3 , ed: 5 } , fly: { op: 6 , ed:10 } }
		 * @param	command 選則播放區間 EX : 如上指令集可帶入 "run" / "jump" / "fly"
		 * @param	once 是否只單次播放
		 * @param	reverse 是否反轉播放
		 * @param	motionTimes 自訂播放速度(非同步運行)  [毫秒 / 張] ( 0 為不變更)
		 */
		public function AddClipPlay(tape:IClip ,play:Boolean,cmdInfo:Object=null , command:String="",once:Boolean=false,reverse:Boolean=false,motionTimes:uint=0):void 
		{
			this._reader.BufferTape(tape);
			
			if (cmdInfo != null) this.checkCommands(cmdInfo);//檢查註冊的屬性(可省略)
			
			this._shelf.WriteClipInfo(tape, play ? "play" : "stop", once, reverse, motionTimes==0 ? this._speed : motionTimes,cmdInfo,command);
			
			motionTimes != 0 ? this._shelf.WriteSack(tape, this._reader) : this._shelf.Write(tape);
		}
		
		/**
		 * 變更MovieClip影格播放掛載的MovieClip實體
		 * @param	ID 掛載註冊名稱
		 * @param	clip 變更的MovieClip實體
		 * @param	play 變更後播放與否 true (播放) / false (停止)
		 * @param	once 是否只播放一次就停止
		 * @param	reverse 是否反轉播放
		 * @param	motionTimes 播放速度[毫秒 / 張] (播放非同步速度下可設定 0 為不變更 )
		 */
		public function MovieChangeClip(ID:String,clip:MovieClip,play:Boolean,once:Boolean=false,reverse:Boolean=false,motionTimes:uint=0):void 
		{
			if (clip == null) MessageTool.InputMessageKey(803);
			
			var tape:IClip = this._shelf.Get(ID) as IClip;
			if (tape == null) MessageTool.InputMessageKey(812);//錯誤的操作類型
			
			if(motionTimes!=0) this.checkMotionTimes(tape, motionTimes,false);
			this._reader.ChangeClip(tape, clip, play, once, reverse, motionTimes != 0 ? motionTimes : tape.VisionSpeed);
		}
		
		/**
		 * 變更容器內的陣列播放圖示與指令集
		 * @param	ID 自定義容器名稱
		 * @param	source 變更的素材
		 * @param	play 變更後播放與否 true (播放) / false (停止)
		 * @param	cmdInfo 變更的指令集(預設null - 若為單一型態則不變更  若為多指令型態則需跟著變更)
		 * @param	command 變更的運行指令(變更後即播放的狀態下)
		 * @param	once 是否只播放一次就停止
		 * @param	reverse 是否反轉播放
		 * @param	motionTimes 播放速度[毫秒 / 張] (播放非同步速度下可設定 0 為不變更 )
		 */
		public function MovieChangeSource(ID:String,source:Array,play:Boolean,cmdInfo:Object=null,command:String="",once:Boolean=false , reverse:Boolean=false,motionTimes:uint=0):void 
		{
			//if (source == null) throw new Error("'MoviePlayer'   source can't be null");
			if (source == null) MessageTool.InputMessageKey(803);
			//_operator.MovieChangeSource(container, source, play, once , reverse, motionTimes);
			var tape:ITape = this._shelf.Get(ID)as ITape;
			if (tape == null) MessageTool.InputMessageKey(812);//錯誤的操作類型
			
			if(motionTimes!=0) this.checkMotionTimes(tape, motionTimes,false);
			this._reader.ChangeTape(tape, source, play, once, reverse, motionTimes != 0 ? motionTimes : tape.VisionSpeed);
			
			if (tape is IMultiTape) {
				this.checkCommands(cmdInfo);//檢查註冊屬性(可省略)
				IMultiTape(tape).VisionCmd(cmdInfo);
				IMultiTape(tape).VisionOrder(command);
			}
			
		}
		
		/**
		 * 變更多素材型態的指令集(播放區間同之前不變更,若需變更需要再呼叫MoviePlay)
		 * @param	ID 自定義容器名稱
		 * @param	command 變更的指令集
		 */
		public function MovieChangeCommands(ID:String,command:Object):void 
		{
			var tape:IMultiTape = this._shelf.Get(ID) as IMultiTape;
			if (tape != null) {
				this.checkCommands(command);
				tape.VisionCmd(command);
			}else {
				MessageTool.InputMessageKey(807);//不支援指令播放類型
			}
		}
		
		//若速度有變化則變更庫管位置與包裝
		private function checkMotionTimes(tape:ITapeInfo,motionTimes:uint,updateTimes:Boolean=true):void 
		{
			//trace(tape, " incheck motiontimes");
			if (motionTimes < this._speed) MessageTool.InputMessageKey(813);//播放速率低於預設速率
			
			if (tape.VisionSpeed != motionTimes) {
				//motionTimes == this._speed ? this._shelf.ChangeShelf(ID) : this._shelf.WriteSack(ID, this._reader);
				//this._shelf.ChangeShelf(ID, this._reader, motionTimes == this._speed ? true : false);
				if (motionTimes == this._speed) {
					this._shelf.ChangeShelf(tape.VisionID, this._reader, true);
				}else {
					tape.VisionSpeed == this._speed ? this._shelf.ChangeShelf(tape.VisionID, this._reader, false,motionTimes) : TimeDriver.ChangeDrive(this._shelf.GetSack(tape.VisionID).Reading, motionTimes);
				}
				if(updateTimes) this._reader.WriteMotionsTimes(tape, motionTimes);
			}
		}
		//檢測指令集是否符合規格
		private function checkCommands(command:Object):void
		{
			var count:int;
			for each (var item:Object in command)
			{
				count++;
				for (var name:String in item)
				{
					if (name != "op" && name != "ed") MessageTool.InputMessageKey(808);//指令集註冊屬性名稱錯誤
				}
			}
			if (count == 0) MessageTool.InputMessageKey(809);//指令集無註冊資料
		}
		
		/**
		 * 變更容器播放速度
		 * @param	ID 自定義容器名稱
		 * @param	motionTimes 變更速度[毫秒 / 張]
		 */
		public function MovieChangeSpeed(ID:String,motionTimes:uint):void
		{
			//_operator.MovieChangeSpeed(container, motionTimes);
			this.checkMotionTimes(this._shelf.Get(ID), motionTimes);
			
		}
		
		/**
		 * 暫停容器播放
		 * @param	ID 自定義容器名稱
		 */
		public function MoviePause(ID:String):void 
		{
			//_operator.ChangeStatus(container, "pause");
			this._reader.WriteStatus(this._shelf.Get(ID), "pause");
		}
		
		/**
		 * 回復播放運行
		 * @param	ID 自定義容器名稱
		 */
		public function MovieResume(ID:String):void 
		{
			//_operator.ChangeStatus(container, "play");
			this._reader.WriteStatus(this._shelf.Get(ID), "play");
		}
		
		/**
		 * 反轉當前播放(順>逆 / 逆>順)
		 * @param	ID 自定義容器名稱
		 */
		public function MovieReverse(ID:String):void
		{
			//_operator.MovieReverse(container);
			this._reader.TurnReverse(this._shelf.Get(ID), 2);
		}
		
		/**
		 * 播放容器圖示( 參數變化)
		 * @param	ID 自定義容器名稱
		 * @param	command 變更播放指令(空字串為不變更)
		 * @param	once 是否只播放一次
		 * @param	reverse 是否反轉播放
		 * @param	motionTimes 播放速度[毫秒 / 張]  ( 0 為不變更 )
		 */
		public function MovieAdjustPlay(ID:String,command:String="",once:Boolean=false , reverse:Boolean=false,motionTimes:uint=0):void 
		{
			//_operator.MoviePlay(container, once , reverse);
			var tape:ITapeInfo = this._shelf.Get(ID);
			var multi:IMultiTape = tape as IMultiTape;
			
			this._reader.TurnReverse(tape, reverse ? 1 : 0);
			this._reader.WriteOnce(tape, once);
			if(command!="") multi != null ? multi.VisionOrder(command) : MessageTool.InputMessageKey(807);//不支援指令播放類型
			this._reader.WriteStatus(tape, "play");
			if(motionTimes!=0) this.checkMotionTimes(tape, motionTimes);
		}
		
		/**
		 * 播放容器圖示( 原先參數)
		 * @param	ID 自定義容器名稱
		 * @param	command 多素材型態可下指令( 空字串為不變更)
		 */
		public function MoviePlay(ID:String,command:String=""):void 
		{
			var tape:ITapeInfo = this._shelf.Get(ID);
			if (command != "") {
				var multi:IMultiTape = tape as IMultiTape;
				multi != null ? multi.VisionOrder(command) : MessageTool.InputMessageKey(807);//不支援指令播放類型
			}
			
			this._reader.WriteStatus(tape, "play");
		}
		
		
		/**
		 * 容器播放停止(同時會初始播放位置)
		 * @param	ID 自定義容器名稱
		 */
		public function MovieStop(ID:String):void
		{
			//_operator.MovieStop(container);
			var tape:ITapeInfo = this._shelf.Get(ID);
			
			this._reader.WriteStatus(tape, "stop");
			this._reader.ResetScreen(tape);
		}
		
		/**
		 * 容器播放停止(同時顯示該位置圖示)
		 * @param	ID 自定義容器名稱
		 * @param	stopAt 停止播放時顯示的圖示(第1~N..張)
		 */
		public function MovieStopAt(ID:String,stopAt:int):void 
		{
			//_operator.MovieStopAt(container, stopAt);
			
			var tape:ITapeInfo = this._shelf.Get(ID);
			var checkTape:ITape = tape as ITape;
			var length:int = checkTape != null ? checkTape.VisionSource.length : IClip(tape).VisionSource.totalFrames;
			if (stopAt > length) {
				MessageTool.InputMessageKey(810);//指定位置大於素材數量
				return;
			}
			this._reader.WriteStatus(tape, "stop");
			this._reader.ResetScreen(tape ,stopAt);
		}
		
		/**
		 * 移除註冊播放容器 (實體回收需使用VisionDestroy方法)
		 * @param	ID 自定義容器名稱
		 * @param	deleteInstance 是否回收實體內部資源
		 */
		public function MovieRemove(ID:String,deleteInstance:Boolean=false):void
		{
			//_operator.MovieRemove(container);
			
			this._shelf.Erase(ID,deleteInstance);
		}
		
		/**
		 * 清除該容器的圖像顯示,並停止播放動作 ( 不適用Extra類型 )
		 * @param	ID 自定義容器名稱
		 */
		public function MovieCleanShow(ID:String):void
		{
			var tp:ITapeInfo = this._shelf.Get(ID);
			
			if (tp != null) {
				//停止運作並清空圖示
				this._reader.WriteStatus(tp, "stop");
				tp.VisionRunner["bitmapData"] = null;
			}
			
		}
		
		
		//調整內部圖示位置
		/**
		 * 調整內部圖示位置偏移
		 * @param	ID 自定義容器名稱
		 * @param	X 偏移的X值
		 * @param	Y 偏移的Y值
		 */
		public function MovieShift(ID:String,X:int=0,Y:int=0):void
		{
			var tape:ITape = this._shelf.Get(ID) as ITape;
			if (!(tape is BitmapVision) && tape!=null) {
				tape.VisionRunner.x = X;
				tape.VisionRunner.y = Y;
			}else {
				MessageTool.InputMessageKey(811);//Bitmap 該型態無法調整內置圖像偏移
			}
		}
		
		
		//Check Value
		/**
		 * 取得當前播放狀態是(true) / 否(false)反轉播放
		 * @param	ID 自定義容器名稱
		 */
		public function GetReverse(ID:String):Boolean
		{
			return ITapeInfo(this._shelf.Get(ID)).VisionReverse;
		}
		
		/**
		 * 取得當前運行狀態play / stop / pause
		 * @param	ID 自定義容器名稱
		 */
		public function GetStatus(ID:String):String
		{
			return this._shelf.Get(ID).VisionStatus;
		}
		
		/**
		 * 取得當前是否只播放一次
		 * @param	ID 自定義容器名稱
		 */
		public function GetOnce(ID:String):Boolean
		{
			return this._shelf.Get(ID).VisionOnce;
		}
		
		/**
		 * 取得當前播放的指令
		 * @param	ID 自定義容器名稱
		 */
		public function GetNowCommand(ID:String):String
		{
			var tape:IMultiTape = this._shelf.Get(ID) as IMultiTape;
			if (tape == null) MessageTool.InputMessageKey(807);//該名稱實體非多素材型態//不支援指令播放類型
			return tape != null ? tape.Command : "";
		}
		
		/**
		 * 依名稱取得註冊實體(需自轉型別)
		 * @param	ID 自定義容器名稱
		 */
		public function GetVision(ID:String):ITapeBasic
		{
			return this._shelf.Get(ID);
		}
		
		/**
		 * 取得當前播放的速度 ( 毫秒 / 張 )
		 * @param	ID 自定義容器名稱
		 */
		public function GetSpeed(ID:String):uint
		{
			return this._shelf.Get(ID).VisionSpeed;
		}
		
		/**
		 * 檢查是否註冊
		 * @param	ID 自定義容器名稱
		 */
		public function CheckRegister(ID:String):Boolean
		{
			return	this._shelf.Get(ID) == null ? false : true;
		}
		
		/**
		 * 取得所有註冊的名稱
		 */
		public function CheckAllRegister():Array
		{
			return this._shelf.CheckAllRegister();
		}
		
		
		
		
		
	}
	
}