package MVCprojectOL.ViewOL.OpenLoading
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import Spark.coreFrameWork.View.ViewCtrl;
	import Spark.MVCs.Models.SourceTools.Loader.LoadingBar;
	import strLib.GameSystemStrLib;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class OpenLoadingSystem extends ViewCtrl
	{
		
		//private var _creatView
		//private var _picBG:Bitmap;
		//private var _loadingBar:LoadingBar;
		//private var _loadPic:DisplayObjectContainer;
		//---loadview---
		private var _OpenLoadView:OpenLoadView;
		private var _safeConter:DisplayObjectContainer
		public function OpenLoadingSystem (_viewConter:DisplayObjectContainer) 
		{
			
			super(GameSystemStrLib.Game_System_Open);
			this._safeConter = _viewConter;
			
		}		
		
		public function CloseTest():void 
		{
			this._OpenLoadView.visible = false;
		}
		
		override public function onRemoved():void {
			
			//----準備移除掉所有的東西------
			//trace("removeOpenLoadingSystem>>>>>>>>>>");
			this._OpenLoadView.RemoveALL();
			this._OpenLoadView = null;
	    }
		
		
		override public function onRegisted():void {
			//-----開始調用資料---------
			if (this._OpenLoadView == null) this._OpenLoadView = new OpenLoadView(this._safeConter);
		}
		
		
		
		
		//------開始添加loading_bar----
		public function AddRealBaR(_pic:DisplayObjectContainer):void 
		{
		    this._OpenLoadView.AddRealBaR(_pic);
		}
		
		
		public function SetBackGround(_pic:BitmapData):void 
		{
			
			this._OpenLoadView.SetBackGround(_pic);
			
		}
		
		//------塞入loadingBar----
		public function SetLoadingBar(_mc:Class=null):void 
		{
			this._OpenLoadView.SetLoadingBar(_mc);
		}
		
		
		
		
		
	}
	
}