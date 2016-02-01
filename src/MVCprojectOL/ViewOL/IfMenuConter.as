package MVCprojectOL.ViewOL
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	
	/**
	 * ...
	 * @author EricHuang
	 * 11/12.要塞進AllinOnePanel所專屬的interface
	 * 需要在定義一個class來實踐interface並且擴增他的基礎功能
	 * 
	 */
	public interface IfMenuConter  
	{
		
		function onCreat(_notifyfun:Function,_publicFun:Function,_spr:DisplayObjectContainer):void;
		function AddSource(_key:String,_obj:*):void;
		function onRemove():void;
		function AddVaules(_vaules:*):void;
	}
	
}