package Spark.SoarParticle.filterEffect
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import Spark.SoarParticle.basic.EffectBM;
	import Spark.SoarParticle.basic.IEffect;
	import Spark.SoarParticle.basic.PointTool;
	import Spark.Timers.TimeDriver;
	
	/**
	 * Reference: http://www.avanderw.co.za/smoke-effect-moku-moku/
	 * 
	 * @author Andrew
		@SparkEngine beta1
		@version #12.10.09.16.24
		@documentation 冒煙效果
	 */
	public class Smog extends EffectBM
	{
		
		private var _arrSmoke:Array;
		private var _arrPick:Array;
		private var _vecLogo:Vector.<BitmapData>;
		private var _mxSmog:Matrix;
		private var _colorTf:ColorTransform;
		private var _moveRange:Number;
		private var _size:int;
		private var _originX:int;
		private var _originY:int;
		private var _value:int;
		
		
		public function Smog(name:String,wid:int,hei:int,size:int=60,range:Number=1,pixelSnapping:String="auto",smoothing:Boolean=false):void 
		{
			super(name,new BitmapData(wid, hei, true, 0), pixelSnapping, smoothing);
			this._size = size;
			this._moveRange = range;
		}
		
		public function Init(originX:int,originY:int):void 
		{
			this._mxSmog = new Matrix();
			this._colorTf = new ColorTransform();
			this._arrSmoke = [];
			this._vecLogo = new Vector.<BitmapData>(3);
			this._vecLogo[0] = this.DustImage(_size, _size);
			this._vecLogo[1] = this.DustImage(_size, _size);
			this._vecLogo[2] = this.DustImage(_size, _size, 0);
			this._originX = originX;
			this._originY = originY;
		}
		
		private function DustImage(W:int,H:int,color:uint=0xFFFFFF):BitmapData
		{
			var buf:BitmapData = new BitmapData(W, H);
            var buf2:BitmapData = new BitmapData(W, H);
            var buf3:BitmapData = new BitmapData(W, H);
            
            var colors:Array = [0xD0D0D0, 0xA0A0A0, 0x000000];
            var alphas:Array = [1, 1, 1];
            var ratios:Array = [0, 127, 255];
            var matrix:Matrix = new Matrix();
 			var sh:Shape = new Shape();
			
            buf.perlinNoise(W, W, 4, Math.random() * 0xFFFF, true, true, 4);
            matrix.createGradientBox(W, H, 0, 0, 0);
            sh.graphics.beginGradientFill(GradientType.RADIAL, colors, alphas, ratios, matrix);
            sh.graphics.drawRect(0, 0, W, H);
            sh.graphics.endFill();
			
            buf3.draw(sh);
            buf.draw(buf3, null, null, BlendMode.MULTIPLY);
 			
            colors = [color, 0, 0];
            alphas = [1, 1, 1];
            ratios = [0, 192, 255];
            matrix.createGradientBox(W, H, 45);
            sh.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
            sh.graphics.drawRect(0, 0, W, H);
            sh.graphics.endFill();
 			
            buf2.perlinNoise(buf2.width, buf2.height, 4, Math.random() * 0xFFFF, true, false, 7, true);
            buf2.draw(sh, null, null, BlendMode.ADD);
 			
            buf2.copyChannel(buf, buf.rect, PointTool.ZEROPOINT, 4, 8);
            return buf2;
		}
		
		//起始運行
		override public function Start(times:Number=0):void 
		{
			super.Start(times);
			if(!TimeDriver.CheckRegister(this.newSmog)) TimeDriver.AddEnterFrame(5, 0, this.newSmog);
			if(!TimeDriver.CheckRegister(this.fumingOperate)) TimeDriver.AddEnterFrame(30, 0, this.fumingOperate);
		}
		
		//停止運行(停止產生煙霧true  or 停止動作false)
		public function Stop(onlyStopSmog:Boolean=false):void 
		{
			TimeDriver.RemoveDrive(this.newSmog);
			if(!onlyStopSmog) TimeDriver.RemoveDrive(this.fumingOperate);
		}
		
		private function newSmog():void 
		{
			var r:Number = (this._value & 15 ) >> 2;
			this.addSmog(this._originX + Math.cos(r * Math.PI / 4) * 24, this._originY + Math.sin(r * Math.PI / 4) * 24);
		}
		
		private function addSmog(x:int,y:int):void 
		{
			var r:Number = 0.4 + Math.random() * 0.4;
			this._arrSmoke.push(
				new Dust(x + Math.random() * 20, y + Math.random() * 20, r, 0, 0.06, 0, 0, Math.random() * .02 - .01, this._vecLogo[int(Math.random() * 3)])
			);
		}
		
		private function fumingOperate():void 
		{
			this.bitmapData.lock();
			this.bitmapData.fillRect(this.bitmapData.rect, 0x0);
			
			this._arrPick = [];
			
			for each (var dt:Dust in this._arrSmoke) 
			{
				dt._y -= this._moveRange;
				dt._r += .005;
				dt._third += dt._forth;
				dt._fifth += .03;
				dt._rotate += dt._roVary;
				if (dt._third > 1.3) dt._forth = -.007;
				if (dt._third < 0 ) dt._third = 0;
				if (dt._fifth > 1) dt._fifth = 1;
				this._mxSmog.identity();
				this._mxSmog.translate( -50, -50);
				this._mxSmog.scale(dt._r, dt._r);
				this._mxSmog.rotate(dt._rotate);
				this._mxSmog.translate(dt._x, dt._y);
				this._colorTf.redMultiplier = dt._fifth;
				this._colorTf.greenMultiplier = dt._fifth;
				this._colorTf.blueMultiplier = dt._fifth;
				this._colorTf.alphaMultiplier = dt._third;
				this.bitmapData.draw(dt._bmdShow, this._mxSmog, this._colorTf);
				if (dt._y > -this._size && dt._r > 0) {
					this._arrPick[this._arrPick.length] = dt;
				}else {
					dt.Destroy();
				}
			}
			
			this.bitmapData.unlock();
			this._arrSmoke = this._arrPick;
			this._value++;
			
			this.RunCount(-200);
		}
		
		override protected function EndCountProcess():void 
		{
			this.Stop(true);//stop create smog ,still upon.
		}
		
		override public function Destroy():void 
		{
			if(TimeDriver.CheckRegister(this.newSmog)) TimeDriver.RemoveDrive(this.newSmog);
			if(TimeDriver.CheckRegister(this.fumingOperate)) TimeDriver.RemoveDrive(this.fumingOperate);
			this._arrPick.length = 0;
			this._arrSmoke.length = 0;
			this.bitmapData.dispose();
			this.bitmapData = null;
			this._arrPick = null;
			this._arrSmoke = null;
			this._colorTf = null;
			this._mxSmog = null;
			this._vecLogo = null;
		}
		
	}
	
}
import flash.display.BitmapData;


class  Dust
{
	
	public var _x:Number;
	public var _y:Number;
	public var _r:Number;
	public var _third:Number;
	public var _forth:Number;
	public var _fifth:Number;
	public var _rotate:Number;
	public var _roVary:Number;
	public var _bmdShow:BitmapData;
	
	public function Dust(X:Number,Y:Number,R:Number,third:Number,forth:Number,fifth:Number,rotate:Number,roVary:Number,show:BitmapData):void
	{
		this._x = X;
		this._y = Y;
		this._r = R;
		this._third = third;
		this._forth = forth;
		this._fifth = fifth;
		this._rotate = rotate;
		this._roVary = roVary;
		this._bmdShow = show;
	}
	
	public function Destroy():void 
	{
		this._bmdShow = null;
	}

	
}