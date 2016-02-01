package MVCprojectOL.ViewOL.SharedMethods 
{
	import flash.display.Shape;
	/**
	 * ...
	 * @author brook
	 */
	public class DrawShadow 
	{
		public function DrawCricle(_LocationX:int, _LocationY:int, _width:int, _height:int ):Shape {
			var _sp:Shape = new Shape();
				_sp.graphics.beginFill(0x333333);
				_sp.graphics.drawEllipse(_LocationX, _LocationY, _width, _height);
				//_sp.alpha = 0.6;
			return _sp;
		}
	}

}