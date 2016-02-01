package Spark.SoarParticle.particleEffect
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Spark.SoarParticle.basic.EffectBM;
	import Spark.SoarParticle.basic.IEffect;
	import Spark.SoarParticle.basic.Particle;
	import Spark.SoarParticle.basic.PointTool;
	import Spark.Timers.TimeDriver;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.10.09.14.00
		@documentation 漩渦風暴
	 */
	public class CircleWave extends EffectBM
	{
		
		private var _color:uint;
		private var _vecParticle:Vector.<Particle>;
		private var _leng:int;
		private var _pCenter:Point;
		private var _blurFt:BlurFilter;
		private var _colorTf:ColorTransform;
		private var _rectLimit:Rectangle;
		
		public function CircleWave(name:String,width:Number,height:Number,color:uint,pixelSnapping:String="auto",smoothing:Boolean=false):void
		{
			this._color = color;
			this._rectLimit = new Rectangle(width >> 4 , height >> 4, width -(width >> 3), height - (height >> 3));
			super(name,new BitmapData(width, height, true, 0), pixelSnapping, smoothing);
		}
		
		public function Init(center:Point):void 
		{
			this._vecParticle = new Vector.<Particle>();
			this._blurFt = new BlurFilter(2, 2);
			
			this._colorTf = new ColorTransform(1, 1, 1, .98);
			//trace("Wid/Hei",_rectLimit.left, _rectLimit.bottom, _rectLimit.right, _rectLimit.top);
			this._pCenter = center;
		}
		
		private function createParticles():void
		{
			var p:Particle;
			for (var i:int = 0; i < 30; i++) 
			{
				p = new Particle();
				p._x = this._pCenter.x;
				p._y = this._pCenter.y;
				p._color = this._color;
				p._velX = 1;
				p._velY = 1;
				p._angle = 0;
				this._vecParticle[this._vecParticle.length] = p;
			}
		}
		
		override public function Start(times:Number=0):void 
		{
			super.Start(times);
			TimeDriver.AddEnterFrame(30, 0, this.rendering);
		}
		
		private function rendering():void
		{
			if(this._times>=0) this.createParticles();
			
			this.bitmapData.applyFilter(this.bitmapData, this.bitmapData.rect, PointTool.ZEROPOINT, this._blurFt );
			this.bitmapData.colorTransform(this.bitmapData.rect, this._colorTf);
			this._leng = this._vecParticle.length;
			var p:Particle;
			var de:uint;
			this.bitmapData.lock();
			
			for (var i:int = this._leng-1; i >= 0; i--)
			{
				p = this._vecParticle[i];
				p._x += Math.sin(p._angle) * p._velX;
				p._y += Math.cos(p._angle) * p._velY;
				p._velX += .5;
				p._velY += .5;
				p._angle += Math.random();//*.75;    //change point to change circle way(階梯 / 回勾螺旋)
					
					if (p._x < this._rectLimit.left || p._x>this._rectLimit.right || p._y > this._rectLimit.bottom || p._y < this._rectLimit.top) {
						
						de = p._color >> 24 & 0xFF;
						if (de > 0xA0) {
							p._color-= 0xA0 << 24;
						}else {
							p.Destroy();
							this._vecParticle.splice(i, 1);
						}
					}
						
				this.bitmapData.setPixel32(p._x, p._y, p._color);
			}
			this.bitmapData.unlock();
			
			this.RunCount(-70);
			
		}
		
		override protected function EndCountProcess():void 
		{
			this._vecParticle.length = 0;
		}
		
		override public function Destroy():void
		{
			if (TimeDriver.CheckRegister(this.rendering)) TimeDriver.RemoveDrive(this.rendering);
			this._colorTf = null;
			this._blurFt = null;
			this._pCenter = null;
			this._rectLimit = null;
			this._vecParticle.length = 0;
			this._vecParticle = null;
		}
		
		
		
		
	}
	
}