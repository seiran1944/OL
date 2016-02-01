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
		@version #12.10.08.19.50
		@documentation line
	 */
	public class Linear extends EffectBM 
	{
		private var _blurFt:BlurFilter;
		private var _vecParticle:Vector.<Particle>;
		private var _color:uint;
		private var _leng:int;
		private var _deRate:Number;
		private var _start:Point;
		private var _end:Point;
		private var _varyX:Number;
		private var _varyY:Number;
		
		public function Linear(name:String,wid:int,hei:int,color:uint,pixelSnapping:String="auto",smoothing:Boolean=false):void
		{
			this._color = color;
			super(name,new BitmapData(wid, hei, true, 0), pixelSnapping, smoothing);
		}
		
		public function Init(start:Point,end:Point,deRate:Number=0):void 
		{
			this._blurFt = new BlurFilter(4, 4);
			this._vecParticle = new Vector.<Particle>();
			
			this._deRate = deRate == 0 ? 1 : deRate;
			this._start = start;
			this._end = end;
			
			this._varyX = end.x - start.x >> 7;
			this._varyY = end.y - start.y >> 7;
		}
		
		override public function Start(times:Number=0):void
		{
			super.Start(times);
			TimeDriver.AddEnterFrame(30, 0, this.rendering);
		}
		
		private function particleInit():void
		{
			var p:Particle = new Particle();
            p._x = this._start.x;
            p._y = this._start.y;
            
			p._velX = this._varyX//+Math.random()*5;
			p._velY = this._varyY//+Math.random()*5;
			
            this._vecParticle[this._vecParticle.length] = p;
		}
		
		private function rendering():void 
		{
			for (var i:int = 0; i < 30; i++)
			{
				this.particleInit();
			}
			
			this.bitmapData.applyFilter(this.bitmapData, this.bitmapData.rect, PointTool.ZEROPOINT, this._blurFt);
			var p:Particle;
			this._leng = this._vecParticle.length;
			
			this.bitmapData.lock();
			
			while (this._leng--) 
			{
				p = this._vecParticle[this._leng];
				
				var random:Number = Math.random()*25;
				p._x += p._velX *random;
				p._y += p._velY *random;
				
				this.bitmapData.setPixel32(p._x, p._y, this._color);
				//for (i = 1; i <3; i++)
				//{
					//this.bitmapData.setPixel32(p._x+i, p._y, this._color);
					//this.bitmapData.setPixel32(p._x, p._y+i, this._color);
					//this.bitmapData.setPixel32(p._x + i, p._y + i, this._color);
				//}
				
				//動能過小清除粒子
				//if (p._x > this.bitmapData.width || p._x < 0 || p._y > this.bitmapData.height || p._y < 0 || Math.abs(p._velX) < .01 || Math.abs(p._velY) < .01) {
				
				//Over Range Delete
				if (p._x > this.bitmapData.width || p._x < 0 || p._y > this.bitmapData.height || p._y < 0) {
					this._vecParticle.splice(z, 1);
					//trace("de");
				}
			}
			
			this.bitmapData.unlock();
			
			this.RunCount();
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
			this._end = null;
			this._start = null;
			
		}
		
	}
	
}