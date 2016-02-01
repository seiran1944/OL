package MVCprojectOL.ViewOL.TeamUI
{
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class ShiftBasic implements ITeamCommon
	{
		
		protected var _funControl:Function;
		protected var _actControl:IActionCtrl;
		
		public function ShiftBasic():void
		{
			
		}
		
		
		public function SetAddress(address:Function):void 
		{
			this._funControl = address;
		}
		
		public function SetAction(action:IActionCtrl):void 
		{
			this._actControl = action;
		}
		
		
		public function AddSource(source:Object):void
		{
			
		}
		
		public function AddUnitSource(source:Object,gotoNext:Boolean):void
		{
			
		}
		
		
		public function NextPage(group:Vector.<DisplayObject>):void 
		{
			
		}
		
		public function PrevPage(group:Vector.<DisplayObject>):void 
		{
			
		}
		
		
		public function Destroy():void 
		{
			if(this._actControl!=null) this._actControl.Destroy();
			
		}
		
		
	}
	
}