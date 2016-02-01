package MVCprojectOL.ViewOL.ExploreView.Journey 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import MVCprojectOL.ModelOL.Explore.Data.ExploreDataCenter;
	import MVCprojectOL.ViewOL.IfMenuConter;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import Spark.MVCs.Models.SourceTools.SourceTool;
	import strLib.commandStr.ExploreAdventureStrLib;
	import strLib.commandStr.MajidanStrLib;
	/**
	 * ...
	 * @author brook
	 * @modifiedBy K.J. Aris
	 * @version 13.04.18.14.30
	 */
	public class JourneyWallView implements IfMenuConter
	{
		private static var _MajidanWallView:JourneyWallView;
		
		private var _ary:Array;
		private var _funSend:Function;
		private var _funPublicfun:Function;
		private var _conter:DisplayObjectContainer;
		
		//private var _ExploreDataCenter:ExploreDataCenter;
		//private var _SourceTool:SourceProxy;
		
		/*public static function GetInstance():MajidanWallView {
			return MajidanWallView._MajidanWallView = ( MajidanWallView._MajidanWallView == null ) ? new MajidanWallView() : MajidanWallView._MajidanWallView; //singleton pattern
		}*/
		
		public function JourneyWallView() 
		{
			//MajidanWallView._MajidanWallView = this;
			this._ary = [];
		}
		
		public function onCreat(_notifyfun:Function,_publicFun:Function,_spr:DisplayObjectContainer):void 
		{
			this._conter = _spr;
			this._funSend = _notifyfun;
			this._funPublicfun = _publicFun;
			//this._SourceTool = SourceProxy.GetInstance();
		}
		
		public function AddSource(_key:String, _obj:*):void 
		{	
			trace("進入探索城牆-------------");
			//if (_obj[0].exitBtn is Object) this._ary.push(_obj[0].exitBtn);
			//if (_obj[1].Blank is Object) this._ary.push(_obj[1].Blank);
			//if (_obj[1].Index is Object) this._ary.push(_obj[1].Index);
			//if (_obj[1].DevilS is Object) this._ary.push(_obj[1].DevilS);
			//if (_obj[1].CampfireS is Object) this._ary.push(_obj[1].CampfireS);
			//if (_obj[1].ChestS is Object) this._ary.push(_obj[1].ChestS);
			
			//---你可以藉由長度或是有的沒的判斷來確認素材是否都拿齊了
			//if (_ary.length == 1) this.creatViewHandler();
		}
		private var _ExitBtn:Sprite;
		//private var _Blank:Bitmap;
		private function creatViewHandler():void 
		{
			
			/*var _WBar:Sprite = this.DrawRect(0, 0, 550, 5);
				_WBar.x = 220;
				_WBar.y = 102;
			this._conter.addChild(_WBar);
			for (var i:int = 0; i < 10; i++) 
			{
				this._Blank = new Bitmap( BitmapData( new (this._ary[1]) )  );
				this._Blank.x = 210 + i * 60;
				this._Blank.y = 90;
				this._Blank.name = "" + i;
				this._conter.addChild(this._Blank);
			}
			var _Index:Bitmap = new Bitmap( BitmapData( new (this._ary[2]) )  );
				_Index.x = 203;
				_Index.y=25;
				_Index.name = "Index";
			this._conter.addChild(_Index);*/
			
			this._ExitBtn=(new (this._ary[0]));
			this._ExitBtn.name = "ExitBtn";
			this._ExitBtn.x = 50;
			this._ExitBtn.y = 124;
			this._ExitBtn.buttonMode = true;
			this._conter.addChild(this._ExitBtn);
			this.AddbtnFactory(this._ExitBtn);
		}
		//指標位置與步數狀態
		/*private function IndicatorLocation(_InputSP:*):void
		{
			var _Backplane:Sprite = _InputSP;
				_Backplane.x = 190;
				_Backplane.y = 65;
			this._conter.addChild(_Backplane);
			this._conter.setChildIndex(_Backplane, 0);
			
			var _IndexNum:int = this._ExploreDataCenter._stepHistory.length;//this._ExploreDataCenter._currentRouteNode._step;
			if (_IndexNum < 10) if (this._conter.getChildByName("Index").x != this._conter.getChildByName(String(_IndexNum)).x - 7) TweenLite.to(this._conter.getChildByName("Index"), 0.5, { x:this._conter.getChildByName(String(_IndexNum)).x - 7, y:this._conter.getChildByName(String(_IndexNum)).y - 65  } );

			var _Icon:Bitmap;
			for (var i:int = 0; i < this._ExploreDataCenter._stepHistory.length; i++) 
			{
				if (this._ExploreDataCenter._stepHistory[i] == 1) _Icon=new Bitmap( BitmapData( new (this._ary[3]) )  );
				if (this._ExploreDataCenter._stepHistory[i] == 2) _Icon=new Bitmap( BitmapData( new (this._ary[5]) )  );
				if (this._ExploreDataCenter._stepHistory[i] == 3) _Icon = new Bitmap( BitmapData( new (this._ary[4]) )  );
				_Icon.x = this._conter.getChildByName(String(i)).x;
				_Icon.y = this._conter.getChildByName(String(i)).y;
				this._conter.addChild(_Icon);
			}
		}*/
		
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
					e.target.gotoAndStop(2);
					if (!TweenMax.isTweening(e.target)) this.onCompleteShake(e.target , true , 4);
				break;
				case "rollOut":
					e.target.gotoAndStop(1);
				break;
				case "click":
					this._funPublicfun("Exit");
					this._funSend(  ExploreAdventureStrLib.ShowReport );//KJ 130418
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
			/*this._ExploreDataCenter = null;
			this._ExploreDataCenter = _vaules;
			this.IndicatorLocation(this._SourceTool.GetImageSprite(this._ExploreDataCenter._uiKey));*/
		}
		
		/*private function DrawRect(_LocationX:int, _LocationY:int, _Width:int, _Height:int):Sprite 
		{
			var _sp:Sprite = new Sprite ();
				_sp.graphics.beginFill(0xF0F0F0);
				_sp.graphics.drawRect(_LocationX,_LocationY,_Width,_Height);
			return _sp;
		}*/
		
		public function onRemove():void 
		{
			this._conter.removeEventListener(MouseEvent.ROLL_OVER, btnChange);
			this._conter.removeEventListener(MouseEvent.ROLL_OUT, btnChange);
			this._conter.removeEventListener(MouseEvent.CLICK, btnChange);
			this._conter.removeChildren();
		}
	}

}