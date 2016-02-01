package Spark.SoarParticle.particleEffect
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import Spark.SoarParticle.basic.EffectBM;
	import Spark.SoarParticle.basic.Particle;
	import Spark.SoarParticle.basic.PointTool;
	import Spark.Timers.TimeDriver;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.10.16.14.53
		@documentation super line cross center
	 */
	public class Concenter extends EffectBM 
	{
		private var _blurFt:BlurFilter;
		private var _colorTf:ColorTransform;
		private var _vecParticle:Vector.<Particle>;
		private var _color:uint;
		private var _leng:int;
		private var _deRate:Number;
		private var _start:Point;
		private var _radius:Number;
		
		public function Concenter(name:String,wid:int,hei:int,color:uint,pixelSnapping:String="auto",smoothing:Boolean=false):void
		{
			this._color = color;
			super(name,new BitmapData(wid, hei, true, 0), pixelSnapping, smoothing);
		}
		
		//半徑影響起始點位置  >>  預設半徑為圖寬一半 ( radius = 0 )
		public function Init(start:Point,radius:Number=0):void
		{
			this._blurFt = new BlurFilter();
			this._colorTf = new ColorTransform(1, 1, 1, .9,-10,-10,-10);
			this._vecParticle = new Vector.<Particle>();
			this._radius = radius == 0 ? this.bitmapData.width >> 1 : radius;
			this._start = start;
		}
		
		override public function Start(times:Number=0):void
		{
			super.Start(times);
			TimeDriver.AddEnterFrame(30, 0, this.rendering);
		}
		
		private function particleInit():void
		{
			var p:Particle;
			var angle:Number = Math.random() * Math.PI*2;
			
			for (var i:int = 0; i < 100; i++)
			{
				p = new Particle();
				p._angle = angle;
				p._x = this._start.x + Math.cos(p._angle) * this._radius;
				p._y = this._start.y + Math.sin(p._angle) * this._radius;
				p._velX = -Math.cos(p._angle);
				p._velY = -Math.sin(p._angle);
				
				this._vecParticle[this._vecParticle.length] = p;
			}
		}
		
		private function rendering():void
		{
			
			if(this._times>=0) this.particleInit();
			
			this.bitmapData.applyFilter(this.bitmapData, this.bitmapData.rect, PointTool.ZEROPOINT, this._blurFt);
			this.bitmapData.colorTransform(this.bitmapData.rect, this._colorTf);
			var p:Particle;
			var random:Number;
			
			this._leng = this._vecParticle.length;
			
			this.bitmapData.lock();
			
			while (this._leng--) 
			{
				p = this._vecParticle[this._leng];
				
				random = Math.random() * 10;
				p._x += p._velX *random;
				p._y += p._velY *random;
				
				this.bitmapData.setPixel32(p._x, p._y, this._color);
				
				//Over Range Delete
				if (p._x > this.bitmapData.width || p._x < 0 || p._y > this.bitmapData.height || p._y < 0) {
					this._vecParticle.splice(z, 1);
				}
			}
			
			this.bitmapData.unlock();
			
			this.RunCount(-30);
		}
		
		override protected function EndCountProcess():void 
		{
			this._vecParticle.length = 0;
		}
		
		override public function Destroy():void 
		{
			if (TimeDriver.CheckRegister(this.rendering)) TimeDriver.RemoveDrive(this.rendering);
			this._vecParticle.length = 0;
			this._vecParticle = null;
			this._blurFt = null;
			this.bitmapData.dispose();
			this.bitmapData = null;
			this._start = null;
			this._colorTf = null;
		}
		
	}
	
}