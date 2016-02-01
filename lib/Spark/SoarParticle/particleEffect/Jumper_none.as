package SoarParticle.particleEffect
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import SoarParticle.basic.EffectBM;
	import SoarParticle.basic.Particle;
	import SoarParticle.basic.PointTool;
	import SoarParticle.motions.SpeedMove;
	import Spark.Timers.TimerPlayer.TimeDriver;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.10.16.14.53
		@documentation super line cross center
	 */
	public class Jumper extends EffectBM 
	{
		private var _blurFt:BlurFilter;
		private var _colorTf:ColorTransform;
		private var _vecParticle:Vector.<Particle>;
		private var _color:uint;
		private var _leng:int;
		private var _deRate:Number;
		private var _start:Point;
		private var _radius:Number;
		
		public function Jumper(name:String,wid:int,hei:int,color:uint,pixelSnapping:String="auto",smoothing:Boolean=false):void
		{
			this._color = color;
			super(name,new BitmapData(wid, hei, false, 0), pixelSnapping, smoothing);
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
			this.particleInit();
		}
		
		
		private function particleInit():void
		{
			var p:Particle;
			var angle:int = 0//Math.random() * 6;
			
			for (var i:int = 0; i < 100; i++)
			{
				p = new Particle();
				p._angle = angle;
				p._x = this._start.x + Math.cos(p._angle) * this._radius;
				p._y = this._start.y + Math.sin(p._angle) * this._radius;
				p._velX = -Math.cos(p._angle);
				p._velY = -Math.sin(p._angle);
				p._color = this._color;
				this._vecParticle[this._vecParticle.length] = p;
			}
		}
		
		private function rendering():void
		{
			
			this.bitmapData.applyFilter(this.bitmapData, this.bitmapData.rect, PointTool.ZEROPOINT, this._blurFt);
			this.bitmapData.colorTransform(this.bitmapData.rect, this._colorTf);
			var p:Particle;
			var random:Number;
			var checkPoint:Point = new Point();
			//var angle:Number = Math.random() * 6;
			
			this._leng = this._vecParticle.length;
			
			this.bitmapData.lock();
			
			while (this._leng--)
			{
				p = this._vecParticle[this._leng];
				
				random = Math.random() * 10;
				
				p._x += p._velX * random;
				p._y += p._velY *random;
				checkPoint.x = p._x;
				checkPoint.y = p._y;
				
				this.bitmapData.setPixel32(p._x, p._y, p._color);
				
				if (Point.distance(this._start, checkPoint) >= this._radius) {
					
					p._angle = getAngle();
					p._velX = -Math.cos(p._angle);
					p._velY = -Math.sin(p._angle);
					p._color = Math.random() * 0xFFFFFFFF;
				}
				
				
			}
			
			this.bitmapData.unlock();
			this.RunCount( -30);
			this.angleChange();
		}
		private var _key:Boolean;
		private var _ary:Array=[2,4,6,1,3,5];
		private function getAngle():int
		{
			this._key = true;
			return this._ary[0];
		}
		private function angleChange():void
		{
			if (this._key) {
				this._key = false;
				trace(this._ary.shift());
			}
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