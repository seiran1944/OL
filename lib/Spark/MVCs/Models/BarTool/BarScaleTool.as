package Spark.MVCs.Models.BarTool
{
	import flash.display.DisplayObject;
	import com.greensock.*;
	import Spark.ErrorsInfo.MessageTool;
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.11.02.16.50
		@documentation 傳入操控對象(BAR),起始點位左(下)或右(上)須先調整元件的註冊點方可操作;
	 */
	public class  BarScaleTool
	{
		private var _source:DisplayObject;
		private var _totalValue:Number;
		private var _nowValue:Number;
		private var _currentScale:Number;
		private var _synchronismValue:Number;
		private var _type:String;
		private var _time:Number;
		private var _setFun:Function;
		private var _buffValue:Array;
		private var _running:Boolean = false;
		
		//vertical > l //parallel > 一
		public function BarScaleTool(source:DisplayObject,nowValue:Number,totalValue:Number,parallel:Boolean=true,runTime:Number=1):void
		{
			this._source = source;
			this._totalValue = totalValue;
			this._nowValue = this._synchronismValue = nowValue;
			this._time = runTime;
			this._setFun = parallel ? this.runParallel : this.runVertical;
			this._buffValue = [];
			
			if (nowValue != totalValue) {
				this.RunTotalValue = nowValue;
			}
			//trace("input", source, nowValue, totalValue, parallel, runTime);
			//trace("clickBAR>>",this._totalValue,this._nowValue,this._synchronismValue);
		}
		
		//傳入變更值( + 增 / - 減)
		public function  set RunChangeValue(value:Number):void
		{
			//trace("RUNVALUE>>", value);
			this._synchronismValue += value;
			
			//低於零將數值歸零並調整減少量為適當值
			if (this._synchronismValue < 0) {
				value = value - this._synchronismValue;
				this._synchronismValue = 0;
				//MessageTool.InputMessageKey(705);//數值不正常低於預期狀態的情況 ( 負值 )
			}
			
			//高於上限將數值等同上限值並調整增加量為適當值
			if (this._synchronismValue > this._totalValue) {
				value = value -(this._synchronismValue-this._totalValue);
				this._synchronismValue = this._totalValue;
				//MessageTool.InputMessageKey(706);//數值不正常高於上限值的情況 ( Over Limit )
			}
			
			this._buffValue.push(value);
			if (this._buffValue.length < 2) {
				this.buffValue();
			}
		}
		
		//傳入總值處理
		public function set RunTotalValue(value:Number):void 
		{
			var changeValue:Number = value-this.FinalValue;
			this.RunChangeValue = changeValue;
		}
		
		//回滿(true)/(value)可重設最大值
		public function ReSetBar(fullOf:Boolean,value:Number=0):void 
		{
			if (value != 0) {
				this._totalValue = value;
			}
			TweenMax.killTweensOf(this._source);
			//trace("Run KIll TweensOF");
			var tdn:Number = fullOf ?  this._totalValue-this._nowValue : 0;
			
			if (this._running) {
				this._buffValue.shift();
				this._buffValue.unshift(tdn, tdn);
				//trace("running TRUE");
			}else {
				this._buffValue.unshift(tdn);
				//trace("running FALSE");
			}
			
			if (this._buffValue.length < 2) {
				this.buffValue();
			}
			
		}
		
		//起始
		private function buffValue():void 
		{
			
			this._running = true;
			//trace("cluntvaLUE>", this._buffValue[0]);
			var useValue:Number = this._nowValue + this._buffValue[0];
			//trace("CAL VALUE>>>>>>>>>>>>>>>>", useValue, this._totalValue);
			var newSV:Number = useValue / this._totalValue;
			this._nowValue = useValue;
			if (newSV > 1) { newSV = 1 };
			
			this._setFun(newSV);
		}
		//Next
		private function buffComplete():void 
		{
			//trace(" IN Buff COM", this._buffValue);
			this._buffValue.shift();
				
			this._running = false;
			
			if (this._buffValue.length > 0) {
				this.buffValue();
			}
		}
		
		//BAR型態分別處理
		private function runVertical(value:Number):void 
		{
			//trace("scaleY>>", value);
			TweenMax.to(this._source, this._time, { scaleY:value, onComplete : this.buffComplete } );
			
		}
		private function runParallel(value:Number):void 
		{
			//trace("scaleX>>", value);
			TweenMax.to(this._source, this._time, { scaleX:value,onComplete : this.buffComplete } );
		}
		
		//銷毀內部資料
		public function  ReleaseBar():void 
		{
			this._source = null;
			this._buffValue = null;
			this._setFun = null;
		}
		
		
		//檢測當前數值
		
		//當前值受BUFFER影響
		public function get CurrentValue():Number 
		{
			return _nowValue;
		}
		//總值
		public function get TotalValue():Number 
		{
			return _totalValue;
		}
		//當前值不受BUFFER影響
		public function get FinalValue():Number 
		{
			return _synchronismValue;
		}
		
		public function get Source():DisplayObject 
		{
			return this._source;
		}
		
		
		
	}
	
}