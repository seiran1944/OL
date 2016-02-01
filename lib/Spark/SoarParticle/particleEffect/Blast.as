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
		@version #12.10.09.13.53
		@documentation //弧狀爪痕跳躍
	 */
	public class Blast extends EffectBM
	{
		
		private var _color:uint;
		private var _radius:Number;
		private var _vecParticle:Vector.<Particle>;
		private var _leng:int;
		private var _blurFt:BlurFilter;
		private var _pOne:Point;
		private var _pTwo:Point;
		private var _pCount:Point;
		private var _finalAngle:Number;
		private var _direction:Boolean;
		private var _curAngle:Number = 0;
		public var _distance:uint;
		
		public function Blast(name:String,wid:Number,hei:Number,color:uint,pixelSnapping:String="auto",smoothing:Boolean=false):void 
		{
			super(name,new BitmapData(wid, hei, true, 0), pixelSnapping, smoothing);
			this._color = color;
		}
		
		public function Init(p1:Point,p2:Point,radius:Number):void 
		{
			this._vecParticle = new Vector.<Particle>();
			this._blurFt = new BlurFilter(2, 2);
			this._pOne = p1;
			this._pTwo = p2;
			this._pCount = new Point();
			this._radius = radius;
		}
		
		private function create():void 
		{
			var p:Particle;
			
			var deX:Number = this._pTwo.x - this._pOne.x;
			var deY:Number = this._pTwo.y - this._pOne.y;
			
			for (var i:int = 0; i < 50; i++) 
			{
				p = new Particle();
				p._x = this._pOne.x;
				p._y = this._pOne.y;
				p._velX = (this._pOne.x + this._pTwo.x) >> 1;
				p._velY = (this._pOne.y + this._pTwo.y) >> 1;
				
				p._velX += Math.cos(Math.atan2(deY, deX ) - (Math.PI >> 1)) * 2;
				p._velY += Math.sin(Math.atan2(deY, deX) - (Math.PI >> 1)) * 2;
				
				p._angle = Math.atan2(this._pOne.y - p._velY, this._pOne.x - p._velX);
				
				p._color = this._color;
				
				this._pCount.x = p._velX;
				this._pCount.y = p._velY;
				
				this._distance = uint(Point.distance(this._pCount, this._pOne));
				
				this._vecParticle[this._vecParticle.length] = p;
			}
			
			this._finalAngle = Math.atan2(this._pTwo.y - this._pCount.y, this._pTwo.x - this._pCount.x);
			
			this._pOne.x += Math.sin(this._curAngle) *20;
			this._pOne.y += Math.cos(this._curAngle) *20;
			this._curAngle += 5;
			
			if (this._finalAngle > p._angle) this._direction = true;
		}
		
		override public function Start(times:Number=0):void
		{
			super.Start(times);
			TimeDriver.AddEnterFrame(30, 0, this.rendering);
		}
		
		private function rendering():void
		{
			
			if(this._times>=0) this.create();
			this.bitmapData.applyFilter(this.bitmapData, this.bitmapData.rect, PointTool.ZEROPOINT, this._blurFt);
			this.bitmapData.colorTransform (this.bitmapData.rect, new ColorTransform(1,1,1,.9));
			this._leng = this._vecParticle.length;
			
			this.bitmapData.lock();
			var p:Particle;
			//var random:Number = 2.1;
			for (var i:int = this._leng-1; i >= 0 ; i--)
			{
				p = this._vecParticle[i];
				
				if (!p._endLife) {
					
					if (this._direction) {
						if(p._angle > this._finalAngle-1) p._endLife = true;
						p._angle+= Math.random() * .2*3.5;
					}else {
						if (p._angle < this._finalAngle+1) p._endLife = true;
						p._angle-= Math.random() * .2*3.5;
					}
					
					p._x = (this._pCount.x + Math.cos(p._angle) * _distance);
					p._y = (this._pCount.y + Math.sin(p._angle) * _distance);
					
					//if (p._x < 0 + this.bitmapData.width >> 4 || p._y < 0 + this.bitmapData.height >> 4 || p._x > this.bitmapData.width - 100 || p._y > this.bitmapData.height - 100) {
						//p._color -= 0xFF << 24;
					//}
					
					this.bitmapData.setPixel32(p._x, p._y, p._color);
				}else {
					this._vecParticle.splice(i, 1);
					p.Destroy();
				}
				
			}
			
			this.bitmapData.unlock();
			
			this.RunCount(-20);
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
			this._pOne = null;
			this._pTwo = null;
			this._pCount = null;
			
		}
		
		
	}
	
}