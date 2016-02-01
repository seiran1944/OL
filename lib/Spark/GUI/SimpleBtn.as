package Spark.GUI
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import gs.TweenMax;
	
	/**
	 * @Engine SparkEngine beta 1
	 * @author EricHuang
	 * @version 2012.05.25
	 * @playerVersion 11.0
	 * @param  It is basic simplebutton Object in this class 
	 * 
	 */
	public class  SimpleBtn extends Sprite
	{
		
		
		/*
		 * -----------_btnObject屬性------
		 * _generalpic---一般狀態圖片[bitmapdata]
		 * _overPic---over狀態圖片[bitmapdata]
		 * _downPic----down狀態圖片[bitmapdata]
		 * _mouseEnable----
		 * 
		 * ----------_TextObject屬性------
		 * 
		 * _str[顯示字串]string
		 * _wid[寬]int
		 * _hei[高]int
		 * _wap[自動換行]boolean
		 * _AutoSize[對齊方式]String-->CENTER/LEFT
		 * _col[顏色]--uint
		 * _Size[自體大小]--int
		 * _bold[粗細]--boolean
		 * _font[自型]
		 * _leading 
		 * 
		 * 
		 * ---------建構式-----
		 * _btnObject---btnObj
		 *_TextObject---textObj
		 * _X--文字的位置
		 * _y--文字的位置
		 * _evtType---btnEvt註冊名稱---
		*/
		
		private var _generalState:BitmapData=null;
		private var _overState:BitmapData=null;
		private var _downState:BitmapData=null;
		private var _nowState:Bitmap;
		private var _Info:Object;
		private var _textField:Text;
	    private var _btnEventID:String="setINIT";
		
		
		public function SimpleBtn () 
		{
		   this.mouseEnabled = false;
			
		}
		
		//----init btnState---------------------------------
		public function Add(_btnObject:Object, _X:int=0,_y:int=0,_evtType:String="",_TextObject:Object=null):void 
		{
			this._btnEventID = _evtType;
			this._generalState = _btnObject._generalpic;
			this._overState = _btnObject._overPic;
			this._downState = _btnObject._downPic;
			this._nowState = new Bitmap(this._generalState);
			this.addChild(this._nowState);
			this.buttonMode = _btnObject._mouseEnable;
			this.mouseEnabled = _btnObject._mouseEnable;
			if (_TextObject != null) this._textField = new Text(_TextObject) ;
			if(_TextObject != null)this.addChild(this._textField);
			if(_X!=0 && _TextObject != null)this._textField.x = _X;
			if(_y!=0 && _TextObject != null)this._textField.y = _y;
			
		}
		
	   
		//--------init mouseStates----------
		//---把需要啟動的type塞進去做啟動-----
		public function SetingMouseEvent(_ary:Array):void 
		{
			for (var i:* in _ary) {
			    if(_ary[i]=="click")this.addEventListener(MouseEvent.CLICK,onMouseEvtHandler);
				if(_ary[i]=="rollOut")this.addEventListener(MouseEvent.ROLL_OUT,onMouseEvtHandler);
			  	if(_ary[i]=="rollOver")this.addEventListener(MouseEvent.ROLL_OVER,onMouseEvtHandler);
				if(_ary[i]=="mouseUp")this.addEventListener(MouseEvent.MOUSE_UP,onMouseEvtHandler);
				if(_ary[i]=="mouseDown")this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseEvtHandler);
			}
		}
		
		//-----send/save  info-------------------------
		//public function get Info():Object { return this._Info; };
	    public function set Info(value:Object):void {this._Info = value;}
		
		//---get Btn Name--------------
		public function get btnEventID():String 
		{
			return _btnEventID;
		}
		//-----send/save  info-------------------------
		
		
		//----change mouseStatePicture Tools(you can override this function )------------------
		public function onMouseEvtHandler(e:MouseEvent):void 
		{
			this.Effect(e.type);
			switch(e.type) {
				
			case "click":
			  //---方便依據不同的ID做管理(外層使用)----
			  this.dispatchEvent(new BtnEvent(BtnEvent.Btn_Event,true,this._btnEventID,this._Info));	
			break;
				
		    case"rollOut":
			 this._nowState.bitmapData = this._generalState;
			break;
			 
		    case"rollOver":
			if (this._overState != null) this._nowState.bitmapData = this._overState;
			
			break;
			  
		    case"mouseUp":
			 this._nowState.bitmapData = this._generalState;
			break;
			 
			case "mouseDown":
			if (this._downState != null) this._nowState.bitmapData = this._downState;
			break;	
			}
			
		}
		
		//----change info string--------
		public function ChangeStr(_str:String):void 
		{
			this._textField.ReSetString(_str);
		}
		
		
		//---change btn color-------
		public function GrayBtn():void 
		{
			
			
			TweenMax.to(this, .5, 
			{
				colorMatrixFilter	:{colorize: 0xBBBBBB,amount:1}
				//ease			:Cubic.easeInOut
			} );
			
		
		}
		
		public function ColorReSet():void 
		{
			this.filters = null;
			
		}
		
		//---use lock btn function (color change Gray)---------
		public function CloseMouse():void 
		{
			this.buttonMode = false;
			this.mouseEnabled = false;
			this.GrayBtn();
		}
		
		//----override btnAnimation use this function(_type=mouseEvent.type)------
		public function Effect(_type:String):void 
		{
		   	
			
		}
		
		
		public function TextVisible(_boL:Boolean):void 
		{
			this._textField.visible = _boL;
		}
		
		
		//----remove this btn source--------------
		public function Remove():void 
		{
			if(this.hasEventListener(MouseEvent.CLICK)==true)this.removeEventListener(MouseEvent.CLICK,onMouseEvtHandler);
			if(this.hasEventListener(MouseEvent.ROLL_OVER)==true)this.removeEventListener(MouseEvent.ROLL_OVER,onMouseEvtHandler);
			if(this.hasEventListener(MouseEvent.ROLL_OUT)==true)this.removeEventListener(MouseEvent.ROLL_OUT,onMouseEvtHandler);
			if(this.hasEventListener(MouseEvent.MOUSE_DOWN)==true)this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseEvtHandler);
			if(this.hasEventListener(MouseEvent.MOUSE_UP)==true)this.removeEventListener(MouseEvent.MOUSE_UP, onMouseEvtHandler);
			this._generalState=null;
			this._overState = null;
			this._downState = null;
			this._nowState = null;
		
		}
		
	
		
		
		
		
		
		
	}
	
}