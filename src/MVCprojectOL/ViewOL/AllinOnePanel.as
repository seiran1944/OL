package MVCprojectOL.ViewOL
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;
	//import flash.display.Sprite;
	import flash.utils.Dictionary;
	import Spark.coreFrameWork.View.ViewCtrl;
	
	/**
	 * ...
	 * @author EricHuang
	 * 該class必須被包覆在viewctrl裡面-----
	 * (他只能被繼承使用)
	 */
	public class AllinOnePanel extends ViewCtrl    
	{
		private var _aryClass:Array;
		protected var _displayObjectBox:DisplayObjectContainer;
		protected var _getName:String;
		protected var _BG:*;
		
		public function AllinOnePanel(_viewConter:DisplayObjectContainer,_name:String)
		{
			this._displayObjectBox = _viewConter;
			this._getName = _name;
			this._aryClass = [];
			super(this._getName,_viewConter);
			
		}
		
		
		public function AddClass(_class:Class):void 
		{
			if (this._aryClass.length != 0) this.RemoveClass();
			var _IfMenuConter:IfMenuConter = IfMenuConter(new _class());
			this._aryClass.push(_IfMenuConter);
			trace(this._aryClass.length);
			_IfMenuConter.onCreat(this.SendNotify,this.PublicSystemHandler,this._displayObjectBox);
			
			
		}
		
		public function GetClassName():String 
		{
			var _str:String;
			if (this._aryClass.length != 0){
				_str=getQualifiedClassName(this._aryClass[0]);
			}
			return _str;
		}
		
		public function AddBG(_bg:*):void 
		{
			trace("check[*]>>"+_bg is MovieClip);
			if (_bg is MovieClip) {
				this._BG = _bg;	
				} else {
				
				this._BG= new Bitmap(_bg);
			}
			this._displayObjectBox.addChild(this._BG);
			
		}
		
		
		//---you can use this function or override -----
		public function AddSingleSource(_key:String,_source:*):void 
		{

			if (this._aryClass.length!=0 && this._aryClass[0]!=null) {
				this._aryClass[0].AddSource(_key,_source);
			}
		}
		
		
		//-----物件陣列進來>>_obj={_key:String,_source:*}
		public function AddSourceList(_ary:Array):void {
			
			var _len:int = _ary.length;
			if(this._aryClass.length!=0 && this._aryClass[0]!=null){
			for (var i:int = 0; i < _len;i++ ) {
			   this.AddSingleSource(_ary[i]._key,_ary[i]._source);
			}
			
			}
			
		}
		
		
		//---you can override this function 
		protected function AddvauleHandler(_vaules:*):void 
		{
			if (this._aryClass.length!=0 && this._aryClass[0]!=null) {
				this._aryClass[0].AddVaules(_vaules);
			}
		}
		
		
		
		//---you can override this function 
		protected function PublicSystemHandler(_key:String,_obj:Object=null):void 
		{
			
			/*
			switch(_key) {
			   case "Exit":
				   //---use exit system-------
				   trace("---use Remove---");
			   break;	   
				
			}
			*/
		}
		
		
		public function GetConterClass():IfMenuConter
		{
		   	
			return this._aryClass[0];
		}
		
     	
		public function RemoveClass():void 
		{
			if (this._aryClass.length>0) {
				
			this._aryClass[0].onRemove();
			this._aryClass[0] = null;
			this._aryClass = [];
		    }	
				
		}
			
		
		public function getClassLen():int 
		{
			var _len:int = (this._aryClass.length > 0)?this._aryClass.length:0;
			return _len;
		}
		
		/*
		override public function onRemoved():void 
		{
		    if (this._aryClass.length) this.RemoveClass();
		}
		*/
		
		
	}
	
}