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
	import Spark.SoarParticle.basic.PointTool;
	import Spark.SoarParticle.basic.Particle;
	import Spark.SoarParticle.ParticleCenter;
	import Spark.Timers.TimeDriver;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.10.08.17.53
		@documentation bomb from center point 怪物消散粉碎
	 */
	public class  Smash extends EffectBM
	{
		
		private var _arrParticle:Array;
		private var _leng:int;
		private var _point:Point;
		private var _colorForm:ColorTransform;
		private var _filter:BlurFilter;
		private var _center:Point;
		
		/*
		 爆炸過程中過貼近邊界的粒子會有堆積邊界的顯像,已加一層範圍來作顯像衰減
		過於貼近邊界依舊會有些微堆積狀態,可再增加一層快速衰減範圍區來避免
		*/
		public function Smash(name:String,source:BitmapData,pixelSnapping:String="auto",smoothing:Boolean=false):void
		{
			this._center = new Point(source.width / 2, source.height / 2);
			super(name,source, pixelSnapping, smoothing);
		}
		
		public function Init(moveRate :Number=0,alphaDecrease:Number=0):void
		{
			this._colorForm = new ColorTransform(1, 1, 1, .6, 0, 0, 0, 0);
			this._filter = new BlurFilter();
			this._point = new Point();
			if (moveRate != 0)  this._velocity = moveRate;
			if (alphaDecrease != 0) this._deAlpha = alphaDecrease;
		}
		
		private function particleInit():void 
		{
			this._arrParticle = PointTool.ToParticle(this.bitmapData);
			this._leng = this._arrParticle.length;
			//trace("總點數為" + this._leng);
			var pe:Particle;
			var quadrant:int;
			for (var i:int = 0; i < this._leng; i++)
			{
				pe = this._arrParticle[i];
				pe._velX = this._velocity;
				pe._velY = this._velocity;
				quadrant = pe._x > this._center.x ? 0 : 1;
				quadrant += pe._y > this._center.y ? 1 : 3;
				switch (quadrant) 
				{
					case 1:
						pe._angle = PointTool.ToRandom(90, 180);
					break;
					case 2:
						pe._angle = PointTool.ToRandom(270, 360);
					break;
					case 3:
						pe._angle = PointTool.ToRandom(0, 90);
					break;
					case 4:
						pe._angle = PointTool.ToRandom(180, 270);
					break;
				}
			}
			
			var wid:Number = this.bitmapData.width;
			var hei:Number = this.bitmapData.height;
			this._rectLimit = new Rectangle(wid >> 3 , hei >> 3, wid - (wid >> 2),hei - (hei >> 2));
			//trace("WID", wid >> 3, "WIDse", wid >> 2);
		}
		
		override public function Start(times:Number=0):void
		{
			super.Start(times);
			this.particleInit();
			TimeDriver.AddEnterFrame(35, 0, this.rendering);
		}
		
		override protected function get GetFPS():int
		{
			return 35;
		}
		
		private var _rectLimit:Rectangle ;
		private var _deAlpha:uint = 0x16;
		private var _velocity:Number = 3.25;
		private var _count:int;
		
		private function rendering():void 
		{
			this.bitmapData.colorTransform(this.bitmapData.rect, this._colorForm);
			this.bitmapData.applyFilter(this.bitmapData, this.bitmapData.rect, this._point, this._filter);
			
			var pe:Particle;
			var a:uint = this._deAlpha << 24;
			var cA:uint;
			
			this._count = this._leng;
			this.bitmapData.lock();
			
			for (var i:int = this._leng-1; i >= 0; i--)
			{
				pe = this._arrParticle[i];
				if (!pe._endLife) {
					
					pe._x = pe._x + Math.sin(pe._angle) * pe._velX;
					pe._y = pe._y + Math.cos(pe._angle) * pe._velY;
					
					if (pe._x > this._rectLimit.right || pe._x < this._rectLimit.left || pe._y > this._rectLimit.bottom || pe._y < this._rectLimit.top) {
						cA = pe._color >> 24 & 0xFF;
						if (cA > this._deAlpha) {
							pe._color -= a;
						}else {
							//this._arrParticle.splice(i, 1);//較慢
							pe._endLife = true;
						}
					}
					this.bitmapData.setPixel32(pe._x, pe._y, pe._color);
				}else{
					this._count--;
				}
				
			}
			
			this.bitmapData.unlock();
			
			//沒有使用計時下播放結束的通知
			if (0 == this._count && !this._counting) {
				ParticleCenter.GetInstance().EffectNotify(this);
			}
			
			this.RunCount();
		}
		
		override protected function EndCountProcess():void
		{
			this._leng = 0;
			this._arrParticle.length = 0;
		}
		
		override public function Destroy():void 
		{
			if (TimeDriver.CheckRegister(this.rendering)) TimeDriver.RemoveDrive(this.rendering);
			this._arrParticle.length = 0;
			this._arrParticle = null;
			this.bitmapData.dispose();//*************需注意圖像來源是否還需要利用
			this.bitmapData = null;
			this._center = null;
			this._colorForm = null;
			this._filter = null;
			this._point = null;
			this._rectLimit = null;
		}
		
	}
	
}