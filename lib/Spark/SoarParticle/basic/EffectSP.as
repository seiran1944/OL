package Spark.SoarParticle.basic
{
	import flash.display.Sprite;
	import Spark.SoarParticle.ParticleCenter;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.10.09.14.45
		@documentation Sprite basic
	 */
	public class  EffectSP extends Sprite implements IEffect
	{
		
		protected var _name:String;
		protected var _counting:Boolean;
		protected var _times:Number;
		
		public function EffectSP(name:String):void
		{
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
		
		override public function set x(value:Number):void 
		{
			super.x = value;
		}
		override public function set y(value:Number):void 
		{
			super.y = value;
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