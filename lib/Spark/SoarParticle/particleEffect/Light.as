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
		@version #12.10.09.10.15
		@documentation 光輝
	 */
	public class Light extends EffectBM
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
		private var _limitJoin:Boolean = false;
		
		
		public function Light(name:String,width:Number,height:Number,color:uint,pixelSnapping:String="auto",smoothing:Boolean=false):void
		{
			this._wid = width;
			this._hei = height;
			this._color = color;
			super(name,new BitmapData(width, height, true, 0), pixelSnapping, smoothing);
		}
		
		public function Init(center:Point):void 
		{
			this._vecParticles = new Vector.<Particle>();
			this._radius = (this._wid + this._hei) * .1;
			this._blurFt = new BlurFilter();
			this._colorTf = new ColorTransform(1, 1, 1, 1);
			this._pCenter = center;
		}
		
		private function createParticles():void
		{
			var p:Particle;
			for (var i:int = 0; i < 15; i++)
			{
				p = new Particle;
				p._x = this._pCenter.x;
				p._y = this._pCenter.y;
				p._velX = 1;
				p._velY = 1;
				p._angle = Math.random() * 360;
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
			this.bitmapData.applyFilter(this.bitmapData, this.bitmapData.rect, PointTool.ZEROPOINT, this._blurFt);
			this.bitmapData.colorTransform(this.bitmapData.rect, this._colorTf);
			if(!this._limitJoin) this.createParticles();
			this._leng = this._vecParticles.length;
			var p:Particle;
			this.bitmapData.lock();
			for (var i:int = this._leng-1; i >= 0; i--)
			{
				p = this._vecParticles[i];
				p._x += Math.cos(p._angle) * p._velX;
				p._y += Math.sin(p._angle) * p._velY;
				this.bitmapData.setPixel32(p._x, p._y, p._color);
				p._angle += 40;//effect operate speed 
				
				if (p._velX >= this._radius || p._velY >= this._radius) {
					p.Destroy();
					this._vecParticles.splice(i, 1);
				}
				
				p._velX *= Math.random()*6;//effect x radius
				p._velY *= Math.random()*6;//effect y radius
				
			}
			this.bitmapData.unlock();
			
			
			this.RunCount(-60);
		}
		
		override protected function EndCountProcess():void
		{
			this._vecParticles.length = 0;
			this._limitJoin = true;
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