package MVCprojectOL.ViewOL.TeamUI
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class TeamBasic extends Sprite implements ITeamCommon
	{
		
		protected var _funControl:Function;
		protected var _wid:Number;
		protected var _hei:Number;
		
		public function TeamBasic():void
		{
			
		}
		
		public function SetAddress(address:Function):void
		{
			this._funControl = address;
		}
		
		public function SetSize(wid:Number,hei:Number):void 
		{
			this._wid = wid;
			this._hei = hei;
		}
		
		public function AddSource(objSource:Object):void 
		{
			
		}
		
		
		
		public function Destroy():void 
		{
			this._funControl = null;
		}
		
		public function get Wid():Number
		{
			return this._wid;
		}
		
		public function get Hei():Number
		{
			return this._hei;
		}
		
		
	}
	
}