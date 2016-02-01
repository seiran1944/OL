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
		@version #12.05.21.17.25
		@documentation 底部橢圓光輝
	 */
	public class Shine extends EffectBM
	{
		private var _wid:Number;
		private var _hei:Number;
		private var _radiusL:Number;
		private var _radiusS:Number;
		private var _leng:int;
		private var _vecParticles:Vector.<Particle>;
		private var _pCenter:Point;
		private var _blurFt:BlurFilter;
		private var _colortTf:ColorTransform;
		private var _color:uint;
		private var _lightHei:int;
		private var _limitJoin:Boolean = false;
		
		public function Shine(name:String,width:Number,height:Number,color:uint,pixelSnapping:String="auto",smoothing:Boolean=false):void 
		{
			this._wid = width;
			this._hei = height;
			this._color = color;
			super(name,new BitmapData(width, height, true, 0), pixelSnapping, smoothing);
		}
		
		public function Init(center:Point,heightLight:int=1):void 
		{
			this._vecParticles = new Vector.<Particle>();
			this._blurFt = new BlurFilter();
			this._colortTf = new ColorTransform(1,1,1,.95);
			this._radiusL = this._wid * .4;
			this._radiusS = this._hei >> 3;
			
			this._pCenter = center;
			this._lightHei = heightLight * 360;
		}
		//正常環繞狀態下
		private function createCycle():void
		{
			var p:Particle;
			for (var i:int = 0; i < 20; i++)
			{
				p = new Particle();
				p._x = this._pCenter.x;
				p._y = this._pCenter.y;
				p._angle = Math.random() * 360;
				p._velX = this._radiusL;
				p._velY = this._radiusS;
				p._color = this._color;
				this._vecParticles[this._vecParticles.length] = p;
			}
		}
		
		override public function Start(times:Number=0):void
		{
			super.Start(times);
			TimeDriver.AddEnterFrame(30, 0, this.rendering);
		}
		
		private function rendering():void
		{
			this.bitmapData.applyFilter(this.bitmapData, this.bitmapData.rect, PointTool.ZEROPOINT, this._blurFt);
			this.bitmapData.colorTransform(this.bitmapData.rect, this._colortTf);
			
			if(!this._limitJoin) this.createCycle();
			
			this._leng = this._vecParticles.length;
			var p:Particle;
			for (var i:int = this._leng-1 ; i >=0 ; i--)
			{
				p = this._vecParticles[i];
				
				p._x = this._pCenter.x + Math.cos(p._angle) * p._velX;
				p._y = this._pCenter.y + Math.sin(p._angle) * p._velY;
				if (p._angle < this._lightHei) {
					p._y -= Math.random()*(p._angle >> 4);
				}else {
					this._vecParticles.splice(i, 1);
				}
				p._angle += 5;
				this.bitmapData.setPixel32(p._x, p._y, p._color);
			}
			
			this.RunCount(-30);
		}
		
		override protected function EndCountProcess():void 
		{
			this._vecParticles.length = 0;
			this._limitJoin = true;
		}
		
		override public function Destroy():void
		{
			if (TimeDriver.CheckRegister(this.rendering)) TimeDriver.RemoveDrive(this.rendering);
			this._vecParticles.length = 0;
			this._vecParticles = null;
			this._blurFt = null;
			this._colortTf = null;
			this._pCenter = null;
		}
		
	}
	
}