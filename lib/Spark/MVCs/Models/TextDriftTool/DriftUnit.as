package Spark.MVCs.Models.TextDriftTool
{
	import com.greensock.TweenLite;
	import flash.text.TextField;
	import Spark.MVCs.Models.TextDriftTool.TextDriftProxy;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.11.08.10.30
		@documentation 文字框運作單元
	 */
	public class DriftUnit 
	{
		
		public var _driftMath:int;
		private var _driftSpeed:Number;
		private var _txtDrift:TextField;
		
		
		public function DriftUnit(text:TextField,speed:Number=.2):void 
		{
			this._txtDrift = text;
			this._driftSpeed = speed;
		}
		
		public function DriftTo(startValue:int,endValue:int):void 
		{
			this._driftMath = startValue;
			this._txtDrift.text = String(startValue);
			this.doDrift({ _driftMath:endValue,onUpdate :this.updateMath});
		}
		
		public function RandomDrift(to:int):void 
		{
			var leng:int = String(to).length-1;
			
			this._driftMath = 0;
			this._txtDrift.text = String(this._driftMath);
			this.doDrift({ _driftMath:9,onUpdate :this.updateRandom,onUpdateParams :[leng],onComplete:this.completeMath,onCompleteParams :[to]});
		}
		
		private function doDrift(param:Object):void 
		{
			TweenLite.to(this, this._driftSpeed, param );
		}
		
		private function completeMath(finalMath:int):void 
		{
			this._txtDrift.text = String(finalMath);
		}
		
		private function updateMath():void 
		{
			this._txtDrift.text = String(this._driftMath);
		}
		
		private function updateRandom(leng:int):void 
		{
			this._txtDrift.text = String(this._driftMath);
			for (var i:int = 0; i < leng; i++) 
			{
				this._txtDrift.appendText(String(this._driftMath));
			}
		}
		
		public function ReleaseDrift():void 
		{
			TweenLite.killTweensOf(this,true,{_driftMath:true});
			this._txtDrift = null;
		}
		
		public function get Text():TextField 
		{
			return this._txtDrift;
		}
		
		
	}
	
}