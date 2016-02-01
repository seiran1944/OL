package  MVCprojectOL.ViewOL.OpenLoading
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import Spark.coreFrameWork.View.ViewCtrl;
	import Spark.Utils.Text;
	import strLib.GameSystemStrLib;
	//import strLib.proxyStr.FontStr;
	
	/**
	 * ...
	 * @author EricHuang
	 * loading show顯示專用-----
	 */
	public class LoadingBarShow extends ViewCtrl 
	{
	   
		
		private var _show:Sprite;
		private var _showTextfield:Text;
		private var _bar:DisplayObject;
		public function LoadingBarShow(_barSource:DisplayObject=null) 
		{
			this._show = new Sprite();
			this._show.name = "BarShowBox";
			super(GameSystemStrLib.Game_LoadingShow,this._show);
			//super(GameSystemStrLib.Game_LoadingShow,this._show);
			if(_barSource!=null)this._bar = _barSource;
		}
		
		
		
		
		override public function onRegisted():void
		{
			var _obj:Object = {_str:"startup_game",_wid:200,_hei:15,_wap:false,_AutoSize:"CENTER",_col:0xffffff,_Size:15,_bold:true};
			this._showTextfield = new Text(_obj);
			this._show.addChild(this._bar);
			this._show.addChild(this._showTextfield);	
			this._showTextfield.x = (this._bar .width - this._showTextfield.textWidth) / 2;
			this._showTextfield.y =20;
		};
		
		public function ReSetStr(_str:String):void 
		{
			this._showTextfield.ReSetString (_str);	
		}
		
		override public function onRemoved():void
		{ 
			trace("REMOVE[LoadingBarShow]>>>>>");
			while (this._show.numChildren>0) {
				this._show.removeChildAt(0);
			}
			if (this._showTextfield != null) this._showTextfield = null;
			if (this._bar != null) this._bar = null;
			if (this._show != null) this._show = null;
			
		};
		
	}
	
}