package MVCprojectOL.ViewOL.ExampleAllPanel
{
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import MVCprojectOL.ViewOL.IfMenuConter;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class ShowBtn implements IfMenuConter
	{
		//private var _dicSource:Dictionary ;
		private var _ary:Array;
		private var _funSend:Function;
		private var _funPublicfun:Function;
		private var _conter:DisplayObjectContainer;
		public function ShowBtn() 
		{
			//this._dicSource = new Dictionary(true);
			this._ary = [];
		}
		
		public function onCreat(_notifyfun:Function,_publicFun:Function,_spr:DisplayObjectContainer):void 
		{
			this._conter = _spr;
			this._funSend = _notifyfun;
			this._funPublicfun = _publicFun;
		}
		
		public function AddSource(_key:String,_obj:*):void 
		{
			trace(_obj is Shape);
			if (_obj is Shape) this._ary.push(_obj);
			//---你可以藉由長度或是有的沒的判斷來確認素材是否都拿齊了
			if (_ary.length == 2) this.creatViewHandler();
			
		}
		
		private var _mybtn:Sprite;
		private var _pulicBtn:Sprite;
		private function creatViewHandler():void 
		{
			this._mybtn = new Sprite();
			this._pulicBtn= new Sprite();
			
			this._mybtn.addChild(this._ary[0]);
			this._mybtn.name = "1";
			this._pulicBtn.addChild(this._ary[1]);
			this._pulicBtn.name = "2";
			this._conter.addChild(this._mybtn);
			this._conter.addChild(this._pulicBtn);
			this._mybtn.x =this._mybtn.y= 0;
			this._pulicBtn.x =this._pulicBtn.y= 50;
			this._mybtn.buttonMode=this._pulicBtn.buttonMode=true;
			
			this._mybtn.addEventListener(MouseEvent.CLICK,onClickHandler);
			this._pulicBtn.addEventListener(MouseEvent.CLICK,onClickHandler);
		}
		
		private function onClickHandler(e:MouseEvent):void 
		{
			//trace("click>>"+e.currentTarget is this._mybtn);
			if (e.currentTarget.name=="1") {
				this._funSend("classBtn");
			}else {
				var _obj:Object = { _get:"yes!"};
				this._funPublicfun("other",_obj);
			}
			
		}
		
		
		public function onRemove():void 
		{
			this._mybtn.removeEventListener(MouseEvent.CLICK,onClickHandler);
			this._pulicBtn.removeEventListener(MouseEvent.CLICK, onClickHandler);
			this._conter.removeChild(this._mybtn);
			this._conter.removeChild(this._pulicBtn);
			trace("kill ShowBtn");
		}
		
	}
	
}