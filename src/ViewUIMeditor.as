package 
{
	import flash.utils.Dictionary;
	import Spark.coreFrameWork.MVC.MeditorGuiCenter;
	import Spark.GUI.BasicPanel;
	
	/**
	 * ...
	 * @author EricHuang
	 * 控制GUI的圖層堆疊處理順序與開關順序-------
	 */
	public class ViewUIMeditor extends MeditorGuiCenter 
	{
	    
		
		private var _dicMenu:Dictionary;
		
		
		public function ViewUIMeditor () 
		{
			super();
			this._dicMenu =new Dictionary(true);
		}
		
		
		public function AddDisplayMenu(_menu:BasicPanel):void 
		{
		   	
		}
		
		//-----加入判斷-*------
		override public function ExcuteGUI(_Nmae:String,Gui:Object):void 
		{
			
		}
		
		
		
		
	}
	
}