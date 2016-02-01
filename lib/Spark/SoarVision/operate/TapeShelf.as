package Spark.SoarVision.operate
{
	import Spark.SoarVision.interfaces.IClip;
	import Spark.SoarVision.interfaces.IMultiTape;
	import Spark.SoarVision.interfaces.ITape;
	import Spark.ErrorsInfo.MessageTool;
	import Spark.SoarVision.interfaces.ITapeBasic;
	import Spark.SoarVision.interfaces.ITapeInfo;
	import Spark.Timers.TimeDriver;
	import Spark.SoarVision.operate.TapeSack;
	import Spark.SoarVision.operate.TapeReader;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.08.27.16.35
		@documentation 物件庫
	 */
	public class  TapeShelf
	{
		private var _objShelf:Object = { };
		private var _objStand:Object = { };
		
		//同步運行狀態寫入庫存
		public function Write(tape:ITapeBasic):void 
		{
			//stock tape
			if (!(tape.VisionID in this._objShelf)) {
				this._objShelf[tape.VisionID] = tape;
			}else {
				//throw new Error("'MoviePlayer'  your source has been added");
				MessageTool.InputMessageKey(801);
			}
		}
		//寫入INFO (圖片陣列播放方式的型態)
		public function WritePlayInfo(tape:ITape,playSource:Array,status:String,once:Boolean,reverse:Boolean,motionTimes:uint,command:Object=null,cmd:String=""):void
		{
			tape.VisionContent(playSource, status, once, reverse, motionTimes);
			if (command != null) {
				if (tape is IMultiTape) {
					IMultiTape(tape).VisionCmd(command);
					IMultiTape(tape).VisionOrder(cmd);
				}else {
					MessageTool.InputMessageKey(807);//不支援指令播放類型
				}
			}
		}
		//寫入INFO (MovieClip影格播放方式的型態)
		public function WriteClipInfo(tape:IClip,status:String,once:Boolean,reverse:Boolean,motionTimes:uint,command:Object=null,cmd:String=""):void 
		{
			tape.VisionInfo(status, once, reverse, motionTimes);
			if (command != null) {
				if (tape is IMultiTape) {
					IMultiTape(tape).VisionCmd(command);
					IMultiTape(tape).VisionOrder(cmd);
				}else {
					MessageTool.InputMessageKey(807);//不支援指令播放類型
				}
			}
		}
		
		//非同步運行狀態sack包裝寫入庫存
		public function WriteSack(tape:ITapeInfo ,reader:TapeReader,newMotions:uint=0):void
		{
			var sack:TapeSack = new TapeSack(tape, reader);
			//trace("write in speeddddd", tape.VisionSpeed);
			TimeDriver.AddDrive(newMotions==0 ? tape.VisionSpeed : newMotions, 0,sack.Reading);
			
			if (!(tape.VisionID in this._objStand)) {
				this._objStand[tape.VisionID] = sack;
			}else {
				//throw new Error("'MoviePlayer'  your source has been added");
				MessageTool.InputMessageKey(801);
			}
			
		}
		
		//速率變更時庫存位置調換
		public function ChangeShelf(ID:String,reader:TapeReader,toShelf:Boolean=false,newMotions:uint=0):void
		{
			if (toShelf) {
				//trace("toShelf",this._objStand[ID]);
				//trace("toShelf",this._objStand[ID]["_tape"]);
				//trace(ID, reader, _objShelf[ID]);
				this._objShelf[ID] = this._objStand[ID]["_tape"];
				//trace(ID, reader, _objShelf[ID]);
				this.cleanSpecial(ID);
			}else {
				//trace("toStand", this._objShelf[ID]);
				//trace(this.CheckAllRegister());
				this.WriteSack(this._objShelf[ID], reader,newMotions);
				this.cleanNormal(ID);
			}
		}
		
		//調庫存Tape
		public function Get(ID:String):ITapeInfo
		{
			//trace(ID in this._objShelf , ID in this._objStand);
			//if (ID in this._objStand) trace(this._objStand[ID]);
			var tape:ITapeInfo = ID in this._objShelf ? this._objShelf[ID] : ID in this._objStand ? this._objStand[ID]["_tape"] : null;
			//if (tape == null) throw new Error("'MoviePlayer'  your source has been removed or not registed");
			if (tape == null) MessageTool.InputMessageKey(802);
			
			return tape;
		}
		
		//調庫存TapeSack
		public function GetSack(ID:String):TapeSack 
		{
			var sack:TapeSack = this._objStand[ID];
			//if (sack == null) throw new Error("'MoviePlayer' your source has been removed or not registed");
			if (sack == null) MessageTool.InputMessageKey(802);
			
			return sack;
		}
		
		//移出庫存
		public function Erase(ID:String,deleteInstance:Boolean):void
		{
			//trace("Erasing");
			var check:Boolean;
			ID in this._objShelf ? this.cleanNormal(ID,deleteInstance) : ID in this._objStand ? this.cleanSpecial(ID,deleteInstance) : check = true;
			//if(check) throw new Error("'MoviePlayer'  your source has been removed or not registed");
			if (check) MessageTool.InputMessageKey(802);
		}
		
		//同步下移除
		private function cleanNormal(ID:String,deleteInstance:Boolean=false):void
		{
			if (deleteInstance) this._objShelf[ID].VisionDestroy();
			this._objShelf[ID] = null;
			delete this._objShelf[ID];
		}
		//非同步下移除
		private function cleanSpecial(ID:String,deleteInstance:Boolean=false):void
		{
			var sack:TapeSack = this._objStand[ID];
			if (deleteInstance) this._objStand[ID]["_tape"].VisionDestroy();
			TimeDriver.RemoveDrive(sack.Reading);
			sack.Destroy();
			this._objStand[ID] = null;
			delete this._objStand[ID];
		}
		//清空兩種狀態下的庫存
		public function EraseAll(deleteInstance:Boolean):void 
		{
			for (var i:* in this._objShelf)
			{
				this.cleanNormal(i,deleteInstance);
			}
			for (i in this._objStand) 
			{
				this.cleanSpecial(i,deleteInstance);
			}
		}
		
		//取得同步庫
		public function get Shelf():Object
		{
			return this._objShelf;
		}
		
		//檢測所有註冊名稱與速率的同步關係
		public function CheckAllRegister():Array
		{
			var arrReg:Array = [];
			for (var name:String in this._objShelf) 
			{
				arrReg[arrReg.length] = "Shelf-同步" + name;
			}
			for (name in this._objStand) 
			{
				arrReg[arrReg.length] = "Stand-非同步" + name;
			}
			return arrReg;
		}
		
		
		
	}
	
}