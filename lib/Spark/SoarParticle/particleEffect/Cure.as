package Spark.SoarParticle.particleEffect
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import Spark.SoarParticle.basic.EffectBM;
	import Spark.SoarParticle.basic.IEffect;
	import Spark.SoarParticle.basic.Particle;
	import Spark.SoarParticle.basic.PointTool;
	import Spark.Timers.TimeDriver;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.10.30.14.31
		@documentation 治癒光閃效果
	 */
	public class Cure extends EffectBM
	{
		
		private var _wid:Number;
		private var _hei:Number;
		private var _color:uint;
		private var _leng:int;
		private var _limit:int;
		private var _born:int;
		private var _vecParticles:Vector.<Particle>;
		private var _colorTf:ColorTransform;
		
		public function Cure(name:String,width:Number,height:Number,color:uint,pixelSnapping:String="auto",smoothing:Boolean=false):void 
		{
			this._wid = width;
			this._hei = height;
			this._color = color;
			super(name,new BitmapData(width, height, true, 0), pixelSnapping, smoothing);
		}
		
		public function Init():void 
		{
			this._vecParticles = new Vector.<Particle>();
			this._colorTf = new ColorTransform(1, 1, 1, .95);
			this._born = this._hei >> 1;
		}
		
		private function createParticle(amount:int):void 
		{
			var p:Particle;
			for (var i:int = 0; i < amount; i++) 
			{
				p = new Particle();
				p._x = PointTool.ToRandom(1, this._wid);
				p._y = PointTool.ToRandom(this._born, this._hei);
				p._velY = 0;
				p._color = this._color;
				this._vecParticles[this._vecParticles.length] = p;
			}
		}
		
		override public function Start(times:Number=0):void 
		{
			super.Start(times);
			TimeDriver.AddEnterFrame(30, 0, this.rendering);
			this.createParticle(10);
		}
		
		private function rendering():void 
		{
			this.bitmapData.colorTransform(this.bitmapData.rect, this._colorTf);
			this._limit--;
			if (this._limit < 0) {
				if(this._times>=0) this.createParticle(1);
				this._limit = 2;
			}
			
			this._leng = this._vecParticles.length;
			var p:Particle;
			this.bitmapData.lock();
			for (var i:int = this._leng-1; i >=0; i--) 
			{
				p = this._vecParticles[i];
				if (p._velY < 50) {
					p._velY += 1;
					p._y -= 3;
				}else {
					this._vecParticles.splice(i, 1);
				}
				
				this.bitmapData.setPixel32(p._x, p._y, p._color);
				this.bitmapData.setPixel32(p._x, p._y + 5, p._color);
			}
			
			this.bitmapData.unlock();
			
			this.RunCount(-90);
			
		}
		
		override public function Destroy():void 
		{
			if (TimeDriver.CheckRegister(this.rendering)) TimeDriver.RemoveDrive(this.rendering);
			this._vecParticles.length = 0;
			this._vecParticles = null;
			this._colorTf = null;
			
		}
		
	}
	
}