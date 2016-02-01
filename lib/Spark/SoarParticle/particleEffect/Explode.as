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
	import Spark.SoarParticle.ParticleCenter;
	import Spark.Timers.TimeDriver;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.10.08.19.15
		@documentation star bomb
	 */
	public class Explode extends EffectBM
	{
		
		private var _wid:Number;
		private var _hei:Number;
		private var _color:uint;
		private var _blurFt:BlurFilter;
		private var _colorTf:ColorTransform;
		private var _vecParticles:Vector.<Particle>;
		private var _pCenter:Point;
		private var _leng:int;
		private var _radius:Number;
		private var _cd:int;
		
		public function Explode(name:String,width:Number,height:Number,color:uint,pixelSnapping:String="auto",smoothing:Boolean=false):void
		{
			this._wid = width;
			this._hei = height;
			this._color = color;
			super(name ,new BitmapData(width, height, true, 0), pixelSnapping, smoothing);
		}
		
		public function Init(center:Point):void 
		{
			this._vecParticles = new Vector.<Particle>();
			this._cd = 80;
			this._radius = this._wid >>2;
			this._blurFt = new BlurFilter(2, 2, 1);
			this._colorTf = new ColorTransform(1, 1, 1, .99, 1, 0, 0, 0);
			this._pCenter = center;
		}
		
		private function createParticles():void 
		{
			var p:Particle;
			for (var i:int = 0; i < 600; i++)
			{
				p = new Particle();
				p._x = this._pCenter.x;
				p._y = this._pCenter.y;
				p._angle = Math.random() * 360;
				this._vecParticles[this._vecParticles.length] = p;
			}
		}
		
		override public function Start(times:Number=0):void
		{
			super.Start(times);
			this.createParticles();
			TimeDriver.AddEnterFrame(30, 0, this.rendering);
		}
		
		private function rendering():void 
		{
			this.bitmapData.applyFilter(this.bitmapData, this.bitmapData.rect, PointTool.ZEROPOINT, this._blurFt);
			this.bitmapData.colorTransform(this.bitmapData.rect, this._colorTf);
			this._leng = this._vecParticles.length;
			var p:Particle;
			this.bitmapData.lock();
			for (var i:int = this._leng-1; i >= 0; i--) 
			{
				p = this._vecParticles[i];
				p._x =this._pCenter.x+ Math.cos(p._angle) * _radius;
				p._y = this._pCenter.y+Math.sin(p._angle) * _radius * Math.random()*1.1;
				this.bitmapData.setPixel32(p._x, p._y, this._color);
				p._angle += 1;
				if (p._x > this._wid || p._x < 0 || p._y < 0 || p._y > this._hei) {
					this._vecParticles.splice(i, 1);
				}
			}
			this._radius -= 3;
			this.bitmapData.unlock();
			
			if (this._leng == 0) {
				this._cd--;
			}
			
			if (this._cd < 0 && !this._counting) {
				ParticleCenter.GetInstance().EffectNotify(this);
			}
			
			this.RunCount();
			
		}
		
		override protected function EndCountProcess():void 
		{
			this._vecParticles.length = 0;
		}
		
		override public function Destroy():void 
		{
			if (TimeDriver.CheckRegister(this.rendering)) TimeDriver.RemoveDrive(this.rendering);
			this._vecParticles.length = 0;
			this._vecParticles = null;
			this._blurFt = null;
			this._colorTf = null;
			this._pCenter = null;
		}
		
		
		
		
		
		
		
	}
	
}