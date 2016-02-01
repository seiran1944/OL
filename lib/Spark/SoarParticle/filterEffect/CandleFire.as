package Spark.SoarParticle.filterEffect
{
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import Spark.SoarParticle.basic.EffectSP;
	import Spark.SoarParticle.basic.IEffect;
	import Spark.SoarParticle.basic.PointTool;
	import Spark.Timers.TimeDriver;
	
	/**
	 * ...reference : http://bbs.redocn.com/thread-373511-1-1.html
	 * @author Andrew
		@SparkEngine beta1
		@version #12.10.09.15.56
		@documentation 燭火
	 */
	public class CandleFire extends EffectSP
	{
		
		private var _wid:Number;
		private var _hei:Number;
		private var _arrOffset:Array;
		private var _rateX:Number;
		private var _rateY:Number;
		private var _shCenter:Shape;
		private var _bdGradient:BitmapData;
		private var _bdDisplace:BitmapData;
		private var _pointRatio:Number = .6;
		private var _margin:int = 10;
		private var _seed:Number;
		private var _rdm:Number;
		private var _dpmFt:DisplacementMapFilter;
		
		
		public function CandleFire(name:String,wid:Number=30,hei:Number=50,colorInside:uint=0xFFCC00,colorOutside:uint=0xE22D09):void 
		{
			super(name);
			this._wid = wid;
			this._hei = hei;
			this.init([colorInside, colorOutside, colorOutside]);
		}
		
		private function init(colors:Array):void 
		{
			this._rateX = 0;
			this._rateY = 5;
			this._seed = Math.random();
			this._arrOffset = [new Point(), new Point()];
			var alpha:Array = [1, 1, 0];
			var ratio:Array = [30, 100, 220];
			var mx:Matrix = new Matrix();
			mx.createGradientBox(this._wid, this._hei, Math.PI  * .5 , -this._wid * .5 , -this._hei * (this._pointRatio + 1) * .5);
			this._shCenter = new Shape();
			with (this._shCenter.graphics)
			{
				beginGradientFill(GradientType.RADIAL,colors, alpha, ratio, mx,"pad","rgb",this._pointRatio);
				drawEllipse( -this._wid * .5, -this._hei * (this._pointRatio + 1) * .5, this._wid, this._hei);
				endFill();
				//余白確保用透明矩形
				beginFill(0x000000,0);
				drawRect( -this._wid * .5, 0, this._wid + this._margin, 1);
				endFill();
			}
			addChild(this._shCenter);
			//微調位置
			this._shCenter.x = 50;
			this._shCenter.y = 50;
			
			this._bdDisplace = new BitmapData(this._wid + this._margin, this._hei, false, 0xFFFFFFFF);
			this._dpmFt = new DisplacementMapFilter(this._bdDisplace, PointTool.ZEROPOINT, 1, 1, 20, 10, DisplacementMapFilterMode.CLAMP);
			
			var mx2:Matrix = new Matrix();
			mx2.createGradientBox(this._wid + this._margin, this._hei, Math.PI * .5 , 0, 0);
			
			var gradient:Shape = new Shape();
			with (gradient.graphics) 
			{
				beginGradientFill(GradientType.LINEAR,[0x666666,0x666666], [0,1], [120,220], mx2);
				drawRect(0,0,this._wid+this._margin,this._hei);
				endFill();
			}
			this._bdGradient = new BitmapData(this._wid+this._margin,this._hei,true,0x00FFFFFF);
			this._bdGradient.draw(gradient);
			
			this._rdm = Math.floor(Math.random() * 10);
			
		}
		
		override public function Start(times:Number=0):void
		{
			super.Start(times);
			TimeDriver.AddEnterFrame(40, 0, this.rendering);
		}
		
		override protected function get GetFPS():int
		{
			return 40;
		}
		
		private function rendering():void
		{
			var p:Point;
			for (var i:int = 0; i < 2; i++)
			{
				p = this._arrOffset[i];
				p.x += this._rateX;
				p.y += this._rateY;
			}
			
			this._bdDisplace.perlinNoise(30 + this._rdm, 60 + this._rdm, 2, this._seed, false, false, 7, true, this._arrOffset);
			this._bdDisplace.copyPixels(this._bdGradient, this._bdGradient.rect, PointTool.ZEROPOINT, null, null, true);
			this._shCenter.filters = [this._dpmFt];
			
			this.RunCount();
		}
		
		override public function Destroy():void 
		{
			if (TimeDriver.CheckRegister(this.rendering)) TimeDriver.RemoveDrive(this.rendering);
			this._arrOffset.length = 0;
			this._arrOffset = null;
			this._bdDisplace.dispose();
			this._bdGradient.dispose();
			this._bdDisplace = null;
			this._bdGradient = null;
			this._dpmFt = null;
			removeChild(this._shCenter);
			this._shCenter = null;
		}
		
		
		
		
		
		
	}
	
}