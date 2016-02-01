package Spark.SoarParticle.particleEffect
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
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
		@version #12.10.08.17.53
		@documentation 類聲納效果 可做標記或影響
	 */
	public class Curve extends EffectBM 
	{
		
		private var _color:uint;
		private var _leng:int;
		private var _radius:Number;
		private var _vecParticles:Vector.<Particle>;
		private var _pCenter:Point;
		private var _blurFt:BlurFilter;
		private var _colorTf:ColorTransform;
		
		public function Curve(name:String,width:Number,height:Number,color:uint,pixelSnapping:String="auto",smoothing:Boolean=false):void 
		{
			this._color = color;
			super(name,new BitmapData(width, height, true, 0), pixelSnapping, smoothing);
		}
		
		public function Init(center:Point):void
		{
			this._vecParticles = new Vector.<Particle>();
			this._blurFt = new BlurFilter();
			this._colorTf = new ColorTransform(1, 1, 1, .9);
			this._pCenter = center;
			this._radius = (center.x - (center.x >> 5)) >> 1;
		}
		
		private function createParticle():void 
		{
			var p:Particle;
			for (var i:int = 0; i < 250; i++)
			{
				p = new Particle();
				p._x = this._pCenter.x ;//+ Math.cos(180) * 20;
				p._y = this._pCenter.y ;//+ Math.sin(180) * 20;
				p._color = this._color;
				p._angle = Math.random()*180;
				this._vecParticles[this._vecParticles.length] = p;
			}
			
		}
		
		override public function Start(times:Number=0):void
		{
			super.Start(times);
			
			TimeDriver.AddEnterFrame(10, 0, this.rendering);
			this.createParticle();
		}
		
		override protected function get GetFPS():int
		{
			return 10;
		}
		
		private function rendering():void 
		{
			this.bitmapData.applyFilter(this.bitmapData, this.bitmapData.rect, PointTool.ZEROPOINT, this._blurFt);
			this.bitmapData.colorTransform(this.bitmapData.rect, this._colorTf);
			this._leng = this._vecParticles.length;
			var p:Particle;
			this.bitmapData.lock();
			for (var i:int = this._leng-1 ; i >=0 ; i--)
			{
				p = this._vecParticles[i];
				p._x +=Math.cos(p._angle)*this._radius;
				p._y +=Math.sin(p._angle)*this._radius;
				p._angle +=1;
				this.bitmapData.setPixel32(p._x, p._y, p._color);
			}
			
			this.bitmapData.unlock();
			
			this.RunCount();
		}
		
		override protected function EndCountProcess():void 
		{
			this._vecParticles.length = 0;
		}
		
		public override function Destroy():void 
		{
			if (TimeDriver.CheckRegister(this.rendering)) TimeDriver.RemoveDrive(this.rendering);
			this._vecParticles.length = 0;
			this._vecParticles = null;
			this.bitmapData.dispose();
			this.bitmapData = null;
			this._colorTf = null;
			this._pCenter = null;
		}
		
		
	}
	
}