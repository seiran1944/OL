package  MVCprojectOL.ViewOL.OpenLoading
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import Spark.MVCs.Models.SourceTools.Loader.LoadingBar;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class OpenLoadView extends Sprite 
	{
		//private var _safeDisplayConter:DisplayObjectContainer;
		private var _picBG:Bitmap;
		private var _loadPic:DisplayObjectContainer;
		private var _loadingBar:LoadingBar;
		
		private var _viewConterBox:DisplayObjectContainer;
		public function OpenLoadView(_viewConter:DisplayObjectContainer) 
		{
			this._viewConterBox = _viewConter;
			
			this._viewConterBox.addChildAt(this,0);
			
		    this.SetLoadingBar();
		}
		
		
		//------開始添加loading_bar----
		public function AddRealBaR(_pic:DisplayObjectContainer):void 
		{
			
			this._loadPic = _pic;
			//if(this._loadingBar!=null)this._loadingBar.StopNull();
			this.addChild(this._loadPic);
			this._loadPic.visible = false;
		   
		}
		
		
		public function SetBackGround(_pic:BitmapData):void 
		{
			this._picBG = new Bitmap(_pic);
			//this._viewConterBox.addChild(this._picBG);
			this.addChildAt(this._picBG,0);
			/*
			if (this._loadingBar != null) {
			    this._loadingBar.StopNull();
			    //this._loadingBar.stop();
				this.removeChild(this._loadingBar);
		        this._loadingBar = null;
			}
		   */
			this._loadPic.x = (this.width - this._loadPic.width) / 2;
			this._loadPic.y = (this.height - this._loadPic.height+100) / 2+100;
			this._loadPic.visible = true;
		}
		
		//------塞入loadingBar----
		
		public function SetLoadingBar(_mc:Class=null):void 
		{
			
			
			if (_mc!=null) {
				//this._loadingBar = new monsterLoader();
			    this._loadingBar =LoadingBar(new _mc());
				//this.addChild(this._loadingBar);
				this.addChild(this._loadingBar);
				//this._loadingBar.x = (this.width-this._loadingBar .width)/2;
				//this._loadingBar.y = (this.height-this._loadingBar .height)/2 ;
				
				
			}
			
		}
		
		
		
		public function RemoveALL():void 
		{
			while (this.numChildren>0) {
			  this.removeChildAt(0);
			}
			this._picBG=null;
		    this._loadPic=null;
		    this._loadingBar=null;
			this._viewConterBox.removeChild(this);
			this._viewConterBox = null;
			
		}
		
	}
	
}