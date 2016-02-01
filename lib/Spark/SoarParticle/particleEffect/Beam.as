package Spark.SoarParticle.particleEffect
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import Spark.SoarParticle.basic.EffectBM;
	import Spark.SoarParticle.basic.IEffect;
	import Spark.SoarParticle.basic.Particle;
	import Spark.SoarParticle.basic.PointTool;
	import Spark.Timers.TimeDriver;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 傳送降落效果(點光柱)
	 */
	public class Beam extends EffectBM
	{
		private var _color:uint;
		private var _leng:int;
		private var _radius:Number;
		private var _limit:Number;
		private var _born:Point;
		private var _vecParticles:Vector.<Particle>;
		private var _colorTf:ColorTransform;
		private var _blurFt:BlurFilter;
		
		public function Beam(name:String,width:Number,height:Number,color:uint,pixelSnapping:String="auto",smoothing:Boolean=false):void
		{
			this._born = new Point(width >> 1 , height >> 6);
			this._limit = height- (height>>5)-8;
			this._color = color;
			super(name,new BitmapData(width, height, true, 0), pixelSnapping, smoothing);
		}
		
		public function Init(radius:Number):void 
		{
			this._vecParticles = new Vector.<Particle>();
			this._colorTf = new ColorTransform(1, 1, 1, .97);
			this._blurFt = new BlurFilter();
			this._radius = radius;
		}
		
		private function createParticle(amount:int):void
		{
			var p:Particle;
			for (var i:int = 0; i < amount; i++)
			{
				p = new Particle();
				p._angle = Math.random() * 90;
				p._x = this._born.x + Math.cos(p._angle) * Math.random() * this._radius;
				p._y = 50+Math.sin(p._angle) * Math.random() * this._radius;
				p._velX = (p._x - this._born.x)*.3;
				p._velX = p._velX >= 0 ? p._velX : - p._velX;
				p._velY = 15;
				p._color = this._color;
				this._vecParticles[this._vecParticles.length] = p;
			}
		}
		
		override public function Start(times:Number=0):void 
		{
			super.Start(times);
			TimeDriver.AddEnterFrame(30, 0, this.rendering);
		}
		
		private function rendering():void 
		{
			
			//if (this._times >= 0 ) 
			if(this._times >=0) this.createParticle(180);
			
			this.bitmapData.colorTransform(this.bitmapData.rect, this._colorTf);
			this.bitmapData.applyFilter(this.bitmapData, this.bitmapData.rect, PointTool.ZEROPOINT, this._blurFt);
			
			this._leng = this._vecParticles.length;
			var p:Particle;
			
			this.bitmapData.lock();
			for (var i:int = this._leng-1; i >=0; i--)
			{
				p = this._vecParticles[i];
				if (p._y>this._limit-p._velX) {
					this._vecParticles.splice(i, 1);
				}else {
					p._y += p._velY;
				}
				this.bitmapData.setPixel32(p._x, p._y, p._color);
			}
			
			this.bitmapData.unlock();
			
			this.RunCount(-60);
		}
		
		override protected function EndCountProcess():void
		{
			this._vecParticles.length = 0;
		}
		
		override public function Destroy():void 
		{
			if (TimeDriver.CheckRegister(this.rendering)) TimeDriver.RemoveDrive(this.rendering);
			this._blurFt = null;
			this._born = null;
			this._colorTf = null;
			this._vecParticles.length = 0;
			this._vecParticles = null;
			
		}
		
		
	}
	
}