package MVCprojectOL.ModelOL.ShopMall.InterFaceCore
{
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public interface IfSetMallTarget
	{
		
		function set Setting(_obj:Object):void 
		function get targetID():String
		function get Type():int
		function GetSettingInfo():Object
	}
	
}