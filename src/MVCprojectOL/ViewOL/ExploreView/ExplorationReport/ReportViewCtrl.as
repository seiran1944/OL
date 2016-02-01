package MVCprojectOL.ViewOL.ExploreView.ExplorationReport 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import MVCprojectOL.ModelOL.Explore.Vo.ExploreReport;
	import Spark.coreFrameWork.View.ViewCtrl;
	/**
	 * ...
	 * @author brook
	 * @version 13.04.18.14.30
	 */
	public class ReportViewCtrl extends ViewCtrl
	{
		private var _BGObj:Object;
		
		public function ReportViewCtrl(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			super( _InputViewName , _InputConter );
		}
		
		public function BackGroundElement(_InputObj:Object):void
		{
			this._BGObj = _InputObj;
		}
		
		public function AddReportPanel(_ExploreReport:ExploreReport, _LvUpData:Array = null):void
		{
			var _Panel:Sprite = new Sprite();
				_Panel.x = 373;//265 + 215-107;
				_Panel.y = 153;//25 + 255-127;
				_Panel.scaleX = 0.5;
				_Panel.scaleY = 0.5;
				_Panel.name = "ReportPanel";
			this._viewConterBox.addChild(_Panel);
			var _AssemblyPanel:AssemblyPanel = new AssemblyPanel(this._BGObj, _Panel, _ExploreReport, _LvUpData);
		}
		
		override public function onRemoved():void 
		{
			if (this._viewConterBox.getChildByName("ReportPanel") != null) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("ReportPanel"));
		}
		
	}
}