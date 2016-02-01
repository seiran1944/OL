package MVCprojectOL.ViewOL.AlchemyView 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import MVCprojectOL.ViewOL.IfMenuConter;
	import strLib.commandStr.UICmdStrLib;
	/**
	 * ...
	 * @author brook
	 */
	public class AlchemyWallExitBtn implements IfMenuConter
	{
		private var _ary:Array;
		private var _funSend:Function;
		private var _funPublicfun:Function;
		private var _conter:DisplayObjectContainer;
		private var _Layer:int;
		public function AlchemyWallExitBtn() 
		{
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
			if (_obj.exitBtn is Object) this._ary.push(_obj.exitBtn);
			//---你可以藉由長度或是有的沒的判斷來確認素材是否都拿齊了
			if (_ary.length == 1) this.creatViewHandler();
		}
		private var _ExitBtn:Sprite;
		private function creatViewHandler():void 
		{
			this._ExitBtn=(new (this._ary[0]));
			this._ExitBtn.name = "ExitBtn";
			this._ExitBtn.x = 50;
			this._ExitBtn.y = 124;
			this._ExitBtn.buttonMode = true;
			this._conter.addChild(this._ExitBtn);
			this.AddbtnFactory(this._ExitBtn);
		}
		
		private function AddbtnFactory(btn:*):void
		{
			btn.addEventListener(MouseEvent.ROLL_OVER, btnChange);
			btn.addEventListener(MouseEvent.ROLL_OUT, btnChange);
			btn.addEventListener(MouseEvent.CLICK, btnChange);
		}
		
		private function btnChange(e:MouseEvent):void 
		{
			switch (e.type) 
			{
				case "rollOver":
					(this._Layer == 0 || this._Layer == 1)?e.target.gotoAndStop(2):e.target.gotoAndStop(4);
					if (!TweenMax.isTweening(e.target)) this.onCompleteShake(e.target , true , 4);
				break;
				case "rollOut":
					(this._Layer == 0 || this._Layer == 1)?e.target.gotoAndStop(1):e.target.gotoAndStop(3);
				break;
				case "click":
				if (this._Layer!=2&&this._Layer!=3)this._funPublicfun("Exit");
					this._funSend(  UICmdStrLib.RemoveALL );
				break;
			}
		}
		
		private function onCompleteShake(target:Object,isLeft:Boolean,times:int):void 
		{
			if (times > 0) {
				TweenLite.to(target, .15, { rotation:isLeft ? -25 : 25 , onComplete:this.onCompleteShake , onCompleteParams : [target, !isLeft, times-1] } );
			}else {
				TweenLite.to(target, .15, { rotation:0 } );
			}
		}
		
		public function AddVaules(_vaules:*):void
		{
			this._Layer = int(_vaules);
			(this._Layer == 1)?MovieClip(this._conter.getChildByName("ExitBtn")).gotoAndStop(1):MovieClip(this._conter.getChildByName("ExitBtn")).gotoAndStop(3);
		}
		
		public function onRemove():void 
		{
			this._conter.removeEventListener(MouseEvent.ROLL_OVER, btnChange);
			this._conter.removeEventListener(MouseEvent.ROLL_OUT, btnChange);
			this._conter.removeEventListener(MouseEvent.CLICK, btnChange);
			this._conter.removeChild(this._ExitBtn);
		}
	}

}