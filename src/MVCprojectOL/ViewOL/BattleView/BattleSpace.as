package MVCprojectOL.ViewOL.BattleView
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class BattleSpace extends Sprite 
	{
		
		protected var _dicLocate:Dictionary;
		
		public function BattleSpace():void 
		{
			
		}
		
		public function SetLocationInfo(dicLocate:Dictionary):void 
		{
			this._dicLocate = dicLocate;
		}
		
		public function MonsterLocate(key:String):Point
		{
			return key in this._dicLocate ? this._dicLocate[key] : null;
		}
		
		//素材加入與佈置
		public function InSource(objSource:Object):void
		{
			//this._objSource = objSource;
		}
		
		public function Destroy():void
		{
			this._dicLocate = null;
		}
		
	}
	
}