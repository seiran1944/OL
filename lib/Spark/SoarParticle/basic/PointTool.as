package Spark.SoarParticle.basic
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class PointTool 
	{
		
		public static const ZEROPOINT:Point = new Point();
		
		public function PointTool():void
		{
			
		}
		
		
		public static function ToParticle(source:BitmapData):Array
		{
			var arrBack:Array = [];
			var wid:Number = source.width;
			var hei:Number = source.height;
			var point:Particle;
			var alpha:uint;
			var color:uint;
			var test:Array = [];
			for (var i:int = 0; i < wid; i++) 
			{
				for (var j:int = 0; j < hei; j++) 
				{
					color = source.getPixel32(i, j);
					alpha = color >> 24 & 0xFF;
					test.push(alpha);
					if (alpha > 0) {//過濾透明(效果有差異,數量較省)
						point = new Particle();
						point._x = i;
						point._y = j;
						point._color = color;
						arrBack[arrBack.length] = point;
					}
				}
			}
			return arrBack;
		}
		
		public static function ToRandom(from:Number,to:Number):Number
		{
			var value:Number = Math.random() * (to - from) + from;
			return value;
		}
		
		public static function GetAngle(px1:Number, py1:Number, px2:Number, py2:Number):Number {
			//两点的x、y值
			var x:Number = px2 - px1;
			var y:Number = py2 - py1;
			var hypotenuse :Number = Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2));
			//斜边长度
			var cos:Number = x / hypotenuse;
			var radian:Number = Math.acos(cos);
			//求出弧度
			var angle:Number = 180 / (Math.PI / radian);
			//用弧度算出角度
			if (y<0) {
					angle = -angle;
			} else if ((y == 0) && (x<0)) {
					angle = 180;
			}
			//trace(x, y, hypotenuse, cos, radian, angle);
			return angle;
		}
		
		
		
		
	}
	
}