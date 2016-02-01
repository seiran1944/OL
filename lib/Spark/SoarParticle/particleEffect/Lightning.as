package Spark.SoarParticle.particleEffect
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.filters.BlurFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import SoarParticle.basic.IEffect;
	import SoarParticle.basic.Particle;
	import SoarParticle.basic.PointTool;
	import Spark.Timers.TimeDriver;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class Lightning extends Bitmap implements IEffect
	{
		
		private var _vecParticles:Vector.<Particle>;
		private var _leng:int;
		private var _colorTf:ColorTransform;
		private var _blurFt:DisplacementMapFilter;
		private var _trunLimit:int;
		private var _glowFt:BlurFilter;
		
		public function Lightning():void 
		{
			super(new BitmapData(300, 300, false, 0));
			this.init();
		}
		
		private function init():void 
		{
			this._vecParticles = new Vector.<Particle>();
			this._colorTf = new ColorTransform(1,1,1,1,0,0,0);
			this._blurFt = new DisplacementMapFilter(this.bitmapData, PointTool.ZEROPOINT,1,1,1,1);
			this._glowFt = new BlurFilter(4,4);
			this._trunLimit = 10;
			this._vecDirection[0] = 1;
			this._vecDirection[1] = -1;
			this._vecDirection[2] = -1;
			//this._vecDirection[1] = [1,-1];
			//this._vecDirection[2] = [-1,-1];
			
			
			
		}
		public var sp:Shape = new Shape();
		private function createParticles():void 
		{
			var p:Particle;
			for (var i:int = 0; i < 10; i++) 
			{
				p = new Particle();
				p._x = 150;
				p._y = 150;
				p._velX = 3;
				p._velY = 3;
				p._angle = 180;
				p._color = 0xFF0000FF;
				//p._color = int(Math.random() * 3);
				p._next = new Particle();
				p._next._x = 150;
				p._next._y = 150;
				
				this._vecParticles[this._vecParticles.length] = p;
			}
		}
		
		public function Start():void 
		{
			this.createParticles();
			TimeDriver.AddEnterFrame(30, 0, this.rendering);
		}
		private var _vecDirection:Vector.<int> = new Vector.<int>(3);
		private var _added:int=1;
		private function rendering():void 
		{
			//this.bitmapData.applyFilter(this.bitmapData, this.bitmapData.rect, PointTool.ZEROPOINT, this._glowFt);
			//this.bitmapData.colorTransform(this.bitmapData.rect, this._colorTf);
			
			//this.createParticles();
			
			
			this._leng = this._vecParticles.length;
			var p:Particle;
			var value:int;
			this.bitmapData.lock();
			for (var i:int = this._leng-1; i >=0 ; i--) 
			{
				p = this._vecParticles[i];
				
				//this._trunLimit--;
				//if (this._trunLimit < 0) {
					this._added+=Math.random();
					//this._trunLimit = Math.random()*this._added;
					value = this.getDirection(2);
					p._velX*= this._vecDirection[value];
					//p._velY = p._velX;
				//}
				p._x += Math.cos(p._angle)*p._velX;
				p._y += -Math.sin(p._angle)*p._velY;
				//p._x += p._velX;
				//p._y += p._velY;
				this.sp.graphics.lineStyle(0,0xF0F0F0);
				this.sp.graphics.moveTo(p._next._x, p._next._y);
				this.sp.graphics.lineTo(p._x, p._y);
				//trace("moveTO>>>" , p._next._x, p._next._y);
				//trace("LinetO<<<<", p._x, p._y);
				p._next._x = p._x;
				p._next._y = p._y;
				
				//this.bitmapData.setPixel32(p._x, p._y,0xFF0000FF);
				this.bitmapData.draw(this.sp);
			}
			
			this.bitmapData.unlock();
		}
		
		private function limitPoint():void 
		{
			
		}
		
		private function getDirection(range:int):int
		{
			return int(Math.random() * range);
		}
		
		public function Destroy():void 
		{
			
		}
		
		
	}
	
}