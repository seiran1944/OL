package Spark.SoarParticle.filterEffect
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Point;
	import Spark.SoarParticle.basic.EffectBM;
	import Spark.SoarParticle.basic.IEffect;
	import Spark.Timers.TimeDriver;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.09.12.17.30
		@documentation 飄動波狀效果
	 */
	public class  Flutter extends EffectBM
	{
		
		private var _pFilter:Point;
		private var _pOffset:Point;
		private var _dmFilter:DisplacementMapFilter;
		private var _bmdShow:BitmapData;
		private var _offsetX:Number;
		private var _offsetY:Number;
		
		public function Flutter(name:String,source:BitmapData,pixelSnapping:String="auto",smoothing:Boolean=false):void
		{
			super(name,source, pixelSnapping, smoothing);
		}
		
		public function Init(offsetX:Number=NaN,offsetY:Number=NaN):void 
		{
			this._pFilter = new Point();
			this._pOffset = new Point();
			this._bmdShow = new BitmapData(this.bitmapData.width, this.bitmapData.height);
			this._dmFilter = new DisplacementMapFilter(this._bmdShow, this._pFilter, 1, 1, 50, 50, "ignore");
			this._offsetX = isNaN(offsetX)? -3 : offsetX;
			this._offsetY = isNaN(offsetY) ? .1 : offsetY;
		}
		
		override public function Start(times:Number=0):void
		{
			super.Start(times);
			TimeDriver.AddEnterFrame(30, 0, this.rendering);
		}
		
		
		private function rendering():void
		{
			this._pOffset.offset( this._offsetX, this._offsetY);
			this._bmdShow.perlinNoise(120, 40, 1, 0, true, true, 2, true, [this._pOffset]);
			this.filters = [this._dmFilter];
			
			this.RunCount();
		}
		
		override protected function EndCountProcess():void 
		{
			this._bmdShow.dispose();
			this._bmdShow = null;
		}
		
		override public function Destroy():void 
		{
			if (TimeDriver.CheckRegister(this.rendering)) TimeDriver.RemoveDrive(this.rendering);
			if (this._bmdShow) {
				this._bmdShow.dispose();
				this._bmdShow = null;
			}
			this.bitmapData.dispose();//需注意導入的素材是否需要重複使用 /目前會清除掉圖檔;
			this.bitmapData = null;
			this._dmFilter = null;
			this._pFilter = null;
			this._pOffset = null;
		}
		
	}
	
}