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
		@version #12.10.08.20.07
		@documentation circle wave
	 */
	public class Pulsation extends EffectBM
	{
		
		private var _wid:Number;
		private var _hei:Number;
		private var _color:uint;
		private var _blurFt:BlurFilter;
		private var _colorTf:ColorTransform;
		private var _vecParticles:Vector.<Particle>;
		private var _pCenter:Point;
		private var _leng:int;
		private var _radiusL:Number;
		private var _radiusS:Number;
		
		
		public function Pulsation(name:String,width:Number,height:Number,color:uint,pixelSnapping:String="auto",smoothing:Boolean=false):void
		{
			this._wid = width;
			this._hei = height;
			this._color = color;
			super(name,new BitmapData(width, height, true, 0), pixelSnapping, smoothing);
		}
		
		public function Init(center:Point,range:int=8):void 
		{
			this._vecParticles = new Vector.<Particle>();
			this._radiusL = this._wid * .4;
			this._radiusS = this._hei >> 2;
			this._blurFt = new BlurFilter();
			this._colorTf = new ColorTransform(1, 1, 1, .6);
			
			this._pCenter = center;
			this._releaseCount = this._reverseCount = range;
		}
		
		private function createParticles():void 
		{
			var p:Particle;
			for (var i:int = 0; i < 150; i++)
			{
				p = new Particle;
				p._x = this._pCenter.x;
				p._y = this._pCenter.y;
				p._velX = 0;
				p._velY = 0;
				p._angle = Math.random() * 360;
				this._vecParticles[this._vecParticles.length] = p;
			}
		}
		private var _releaseCount:int;
		private var _reverseCount:int;
		override public function Start(times:Number=0):void
		{
			super.Start(times);
			TimeDriver.AddEnterFrame(30, 0, this.rendering);
		}
		
		private function rendering():void 
		{
			this.bitmapData.applyFilter(this.bitmapData, this.bitmapData.rect, PointTool.ZEROPOINT, this._blurFt);
			this.bitmapData.colorTransform(this.bitmapData.rect, this._colorTf);
			
				this._releaseCount--;
				if (this._releaseCount < 0) {
					this.createParticles();
					this._releaseCount = this._reverseCount;
				}
			this._leng = this._vecParticles.length;
			var p:Particle;
			this.bitmapData.lock();
			for (var i:int = this._leng-1; i >= 0; i--)
			{
				p = this._vecParticles[i];
				p._x += Math.cos(p._angle) * p._velX;
				p._y += Math.sin(p._angle) * p._velY;
				this.bitmapData.setPixel32(p._x, p._y, this._color);
				p._angle += 2;//effect operate speed 
				
				if (p._velX >= this._radiusL) this._vecParticles.splice(i, 1);
				if (p._velY >= this._radiusS) this._vecParticles.splice(i, 1);
				p._velX += 2;//effect x radius
				p._velY += .8;//effect y radius
				
			}
			this.bitmapData.unlock();
			
			this.RunCount();
		}
		
		override protected function EndCountProcess():void 
		{
			this._vecParticles.length = 0;
			this._releaseCount = 99;
		}
		
		override public function Destroy():void 
		{
			if (TimeDriver.CheckRegister(this.rendering)) TimeDriver.RemoveDrive(this.rendering);
			this._vecParticles = null;
			this._blurFt = null;
			this._colorTf = null;
			this._pCenter = null;
		}
		
		
		
		
		
		
		
	}
	
}