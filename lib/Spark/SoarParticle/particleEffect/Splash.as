package Spark.SoarParticle.particleEffect
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import Spark.SoarParticle.basic.EffectBM;
	import Spark.SoarParticle.basic.Particle;
	import Spark.Timers.TimeDriver;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.10.09.10.35
		@documentation 液態疊加飛濺狀態
	 */
	public class Splash extends EffectBM
	{
		private var _pZero:Point;
		private var _blurFt:BlurFilter;
		private var _colorTf:ColorTransform;
		private var _vecParticle:Vector.<Particle>;
		private var _color:uint;
		private var _leng:int;
		private var _deRate:Number;
		private var _limitJoin:Boolean = false;
		//private var _arrColor:Array = [0xFFFF1111, 0xFF12FFCC];//可調整為多色
		
		public function Splash(name:String,wid:int,hei:int,color:uint,pixelSnapping:String="auto",smoothing:Boolean=false):void
		{
			this._color = color;
			super(name,new BitmapData(wid, hei, true, 0), pixelSnapping, smoothing);
		}
		
		public function Init(deRate:Number=0):void
		{
			this._pZero = new Point();
			this._blurFt = new BlurFilter(2, 2);
			this._colorTf = new ColorTransform(1,1,1,.95);
			this._vecParticle = new Vector.<Particle>();
			this._deRate = deRate == 0 ? 1 : deRate;
		}
		
		override public function Start(times:Number=0):void 
		{
			super.Start(times);
			TimeDriver.AddEnterFrame(30, 0, this.rendering);
		}
		
		
		private function particleInit():void 
		{
			var p:Particle = new Particle();
            p._x = (this.bitmapData.width >> 1);//+Math.random()*10;
            p._y = (this.bitmapData.height >> 1);//+Math.random()*10;
            
			var radius:Number = Math.sqrt(Math.random())*10;
			
			p._angle = Math.random() * Math.PI * 2;
            p._velX = Math.random() * 3 * Math.cos(p._angle) * radius;
            p._velY = Math.random() * 3 * Math.sin(p._angle) * radius;
			
            this._vecParticle[this._vecParticle.length] = p;
		}
		
		private function rendering():void 
		{
			if (!this._limitJoin) {
				for (var i:int = 0; i < 30; i++)
				{
					this.particleInit();
				}
			}
			this.bitmapData.colorTransform(this.bitmapData.rect, this._colorTf);
			this.bitmapData.applyFilter(this.bitmapData, this.bitmapData.rect, this._pZero, this._blurFt);
			
			var p:Particle;
			this._leng = this._vecParticle.length;
			this.bitmapData.lock();
			
			while (this._leng--) 
			{
				p = this._vecParticle[this._leng];
				
				p._velX *= .9;
				p._velY *= .9;
				
				p._x += p._velX * this._deRate;
				p._y += p._velY * this._deRate;
				this.bitmapData.setPixel32(p._x, p._y, this._color);
				//動能過小清除粒子
				//if (p._x > this._bmdShow.width || p._x < 0 || p._y > this._bmdShow.height || p._y < 0 || Math.abs(p._velX) < .01 || Math.abs(p._velY) < .01) {
				
				//Over Range Delete
				if (p._x > this.bitmapData.width || p._x < 0 || p._y > this.bitmapData.height || p._y < 0) {
					//this._vecParticle.splice(z, 1);
				}
			}
			
			this.bitmapData.unlock();
			
			this.RunCount(-30);
		}
		
		override protected function EndCountProcess():void
		{
			this._vecParticle.length = 0;
			this._limitJoin = true;
		}
		
		override public function Destroy():void 
		{
			if (TimeDriver.CheckRegister(this.rendering)) TimeDriver.RemoveDrive(this.rendering);
			this.bitmapData.dispose();
			this.bitmapData = null;
			this._vecParticle.length = 0;
			this._vecParticle = null;
			this._blurFt = null;
			this._pZero = null;
		}
		
		
	}
	
}