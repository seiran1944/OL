package Spark.SoarParticle.particleEffect
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import Spark.SoarParticle.basic.EffectBM;
	import Spark.SoarParticle.basic.Particle;
	import Spark.SoarParticle.basic.PointTool;
	import Spark.Timers.TimeDriver;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.10.19.14.11
		@documentation firework
	 */
	public class Sparkler extends EffectBM 
	{
		private var _blurFt:BlurFilter;
		private var _colorTf:ColorTransform;
		private var _vecParticle:Vector.<Particle>;
		private var _color:uint;
		private var _leng:int;
		private var _pCenter:Point;
		private var _deAlpha:uint;
		private var _cycleAmount:int;
		private var _gravity:Number = 0.25;
		
		public function Sparkler(name:String,wid:int,hei:int,color:uint,pixelSnapping:String="auto",smoothing:Boolean=false):void
		{
			this._color = color;
			super(name,new BitmapData(wid, hei, true, 0), pixelSnapping, smoothing);
		}
		
		//半徑影響起始點位置  >>  預設半徑為圖寬一半 ( radius = 0 )
		//deAlpha會隨寬高影響(目前預設寬高100)
		//cycleAmount 影響每次運行的產出量
		public function Init(center:Point,deAlpha:uint=5,cycleAmount:int=2):void
		{
			this._blurFt = new BlurFilter();
			this._colorTf = new ColorTransform(1, 1, 1, .99);
			this._vecParticle = new Vector.<Particle>();
			this._pCenter = center;
			this._deAlpha = 255 >> deAlpha;
			this._cycleAmount = cycleAmount;
		}
		
		override public function Start(times:Number=0):void
		{
			super.Start(times);
			TimeDriver.AddEnterFrame(30, 0, this.rendering);
		}
		
		
		private function particleInit():void
		{
			var p:Particle;
			var radius:Number = Math.random()*2 + 2;//視圖像寬高調整半徑大小
			var place:Number = Math.random();
			
			for (var i:int = 0; i < 200; i++)
			{
				p = new Particle();
				p._angle = Math.random() * Math.PI * 2;
				p._x = this._pCenter.x;
				p._y = this._pCenter.y;
				p._velX = Math.cos(p._angle) * radius;
				p._velY = Math.sin(p._angle) * radius;
				p._color = this._color;
				//p._color = place * 0xFFFFFFFF;
				this._vecParticle[this._vecParticle.length] = p;
			}
		}
		
		
		private function rendering():void
		{
			
			this.bitmapData.applyFilter(this.bitmapData, this.bitmapData.rect, PointTool.ZEROPOINT, this._blurFt);
			this.bitmapData.colorTransform(this.bitmapData.rect, this._colorTf);
			var p:Particle;
			
			if(this._times % 60 ==0 && this._times>=0) this.particleInit();
				
				
			this._leng = this._vecParticle.length;
			
			this.bitmapData.lock();
			
			while (this._leng--)
			{
				p = this._vecParticle[this._leng];
				
				p._x += p._velX;
				p._y += p._velY
				
				p._velY += Math.random() *_gravity;
				//p._velX += p._velX > 0 ? -.01 : .01;
				
				if ((p._color >> 24 & 0xFF) > this._deAlpha) {
					p._color -= (this._deAlpha << 24);
				}else {
					this._vecParticle.splice(this._leng, 1);
				}
				
				this.bitmapData.setPixel32(p._x, p._y, p._color);
				this.bitmapData.setPixel32(p._x + 1, p._y + 1, p._color);
				
			}
			//trace(p._velY);
			this.bitmapData.unlock();
			this.RunCount( -100);
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
			this._colorTf = null;
			this._pCenter = null;
		}
		
	}
	
}