package MVCprojectOL.ModelOL.TipsCenter.DisplayobjLab
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import MVCprojectOL.ModelOL.TipsCenter.Basic.BaseItemView;
	import MVCprojectOL.ViewOL.TurntableView.TurntableViewCtrl;
	import strLib.vewStr.ViewNameLib;
	//import Spark.Utils.Text;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class CompleteConter extends  BaseItemView
	{
		
		private var _textShow:TextField;
		//--sendNotify----
		private var _function:Function;
		//-------sendNotify_string----
		private var _buildType:int = 0;
		public function CompleteConter(_bgSource:MovieClip,_group:String,_guid:String,_fun:Function,_sys:int) 
		{
			super(_bgSource,_guid,_group);
			//new Text({_str:"",_wid:350,_hei:380,_wap:true,_AutoSize:"LEFT",_col:0,_Size:12,_bold:true});
			//this._textShow = new Text({_str:"",_wid:286,_hei:0,_wap:true,_AutoSize:"LEFT",_col:0xffffff,_Size:12,_bold:true});
			//this._textShow.name = "testttt";
			this._textShow = new TextField();
			this._textShow.width = 140;
			this._textShow.height = 80;
			
			//this._style = new TextFormat();
			//this._text.setTextFormat(_style);
			this._textShow.wordWrap = true;
			this._textShow. multiline = true;
			this.addChild(this._textShow);
			this._textShow.x = 79;
			this._function = _fun;
			this.buttonMode = true;
			this._buildType = _sys;
			//this.deformbadyHandler();
		}
		/*
		public function AddItem(_spr:ItemConter):void 
		{
			if(_spr!=null)this.AddItemSource(_spr);
		}*/
		
		private function deformbadyHandler():void 
		{
		    this._item.x = this._item.y = 8;
			this._textShow.y = this._item.y ;
			this._bg.width = 286;
			this._bg.height = (this._textShow.height - (80 - 6) <= 80)?80:this._textShow.height - (80 - 6);
			//6
			this.addEventListener(MouseEvent.CLICK,onClickHandler);
		}
		
		private function onClickHandler(e:MouseEvent):void 
		{
			var _randomView:TurntableViewCtrl=TurntableViewCtrl(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewNameLib.View_Turntable));
			  if (_randomView == null || !_randomView.JudgeWork()) {
				this.removeEventListener(MouseEvent.CLICK, onClickHandler);
				this.visible = false;
				this._function(ProxyPVEStrList.TIP_CompleteOpen,{_build:this._buildType,_guid:this._guid}); 
			   }else {
				return;
			   }
		}
		
		
		public function AddShowStr(_str:String):void 
		{
			this._textShow.htmlText = _str;
			
			this.deformbadyHandler();
		}
		
		/*
		public function StarLoadingItem():void 
		{
			this._item.StarLoading();
		}
		*/
		override public function CleanALL():void 
		{
			//var _bef:int = this.numChildren;
			this.CleaN();
			//var _after:int = this.numChildren;
			//var _target:Text = this.getChildByName("testttt") as Text;
			if (this.numChildren > 0) this.removeChildren();
			if (this._textShow != null) this._textShow = null;
			
			if (this.hasEventListener(MouseEvent.CLICK)) this.removeEventListener(MouseEvent.CLICK,onClickHandler);	
			
			
			
		}
		
		
	}
	
}