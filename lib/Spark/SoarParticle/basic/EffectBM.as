package Spark.SoarParticle.basic
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import Spark.SoarParticle.ParticleCenter;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation Bitmap basic
	 */
	public class  EffectBM extends Bitmap implements IEffect
	{
		
		protected var _name:String;
		protected var _counting:Boolean;
		protected var _times:Number;
		
		public function EffectBM(name:String,bmData:BitmapData,pixelSnapping:String="auto",smoothing:Boolean=false):void
		{
			super(bmData, pixelSnapping, smoothing);
			this._name = name;
		}
		
		public function get GetName():String
		{
			return this._name;
		}
		
		public function Start(times:Number=0):void 
		{
			this._counting = times != 0 ? true : false;
			this._times = this._counting ? times * GetFPS : 0;
			
		}
		
		//FPS不為30者需複寫
		protected function get GetFPS():int
		{
			return 30;
		}
		
		protected function RunCount(limit:int=-10):void 
		{
			if (this._counting) {
				this._times--;
				
				if (this._times == 0) this.EndCountProcess();
				if(this._times< limit ) {
					//並發送播放時間到達的銷毀通知
					//待統一處理平台發送與Destroy處理
					ParticleCenter.GetInstance().EffectNotify(this);
					trace("EnD");
				}
			}
		}
		
		override public function set x(value:Number):void 
		{
			super.x = value;
		}
		override public function set y(value:Number):void 
		{
			super.y = value;
		}
		
		//計時到達時的處理
		protected function EndCountProcess():void
		{
			//particle leng = 0;
		}
		
		public function Destroy():void
		{
			
		}
		
	}
	
}