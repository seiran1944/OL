package Spark.MVCs.Models.SourceTools.Loader
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	
	/**
	 * ...
	 * @Engine :SparkEngine beta 1
	 * @author :JerryKai
	 * @version :2012.07.17
	 * @Explain:LoadingBar 加載動畫元件
	 * @playerVersion:11.0
	 */
	
	 
	 
	
	public class LoadingBar extends MovieClip
	{
		
		private var _LoadingBar:Bar ;
		
		private var _LoadingTxt:TextField;
		
		
		
		public function LoadingBar(){
			
			this._LoadingBar = new Bar();
			this.addChild( _LoadingBar );
			//this._LoadingBar.stop();
			this._LoadingTxt = new TextField();
			this._LoadingBar.addChild( this._LoadingTxt );
			this._LoadingTxt.selectable = false;
			this._LoadingTxt.x = 35;
			this._LoadingTxt.y = 60;
			this._LoadingBar.play();	
			
		}
		
		public function set LoadingTxt( _InputValue:uint ):void 
		{
			if(this._LoadingTxt!=null)this._LoadingTxt.text = String( _InputValue ) + " %";
		}
		
		
		public function StopNull():void 
		{
			this._LoadingBar.stop();
			this._LoadingBar = null;
			this._LoadingTxt = null;
		}
		
		
		
		
	}//end class
}//end package