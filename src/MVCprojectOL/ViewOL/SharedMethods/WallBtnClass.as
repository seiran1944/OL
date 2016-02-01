package MVCprojectOL.ViewOL.SharedMethods 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import MVCprojectOL.ViewOL.IfMenuConter;
	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import strLib.commandStr.UICmdStrLib;
	/**
	 * ...
	 * @author brook
	 */
	public class WallBtnClass implements IfMenuConter
	{
		public var _ary:Array;
		public var _funSend:Function;
		private var _funPublicfun:Function;
		private var _conter:DisplayObjectContainer;
		private var _NumericalBoxVector:Vector.<Sprite> = new Vector.<Sprite>;
		private var _NumericalBoxBtnBoolean:Boolean = true;
		private var _KeyName:String;
		public function WallBtnClass() 
		{
			this._ary = [];
		}
		public function onCreat(_notifyfun:Function,_publicFun:Function,_spr:DisplayObjectContainer):void 
		{
			this._conter = _spr;
			this._funSend = _notifyfun;
			this._funPublicfun = _publicFun;
			//this._funSend ("AAAA",_obj);
		}
		
		public function AddSource(_key:String,_obj:*):void 
		{
			this._KeyName = _key;
			//trace(_obj is Object,"++++++");
			if (_obj.sortBtn is Object) this._ary.push(_obj.sortBtn);
			if (_obj.bgBtn is Object) this._ary.push(_obj.bgBtn);
			if (_obj.exitBtn is Object) this._ary.push(_obj.exitBtn);
			if (_obj.Property is Object) this._ary.push(_obj.Property);
			if (_obj.pageBtnS is Object) this._ary.push(_obj.pageBtnS);
			if (_obj.changeBtn is Object) this._ary.push(_obj.changeBtn);
			//---你可以藉由長度或是有的沒的判斷來確認素材是否都拿齊了
			if (this._ary.length == 6) this.creatViewHandler();
		}
		
		private var _sortBtn:Sprite;
		private var _bgBtn:Sprite;
		private var _ExitBtn:Sprite;
		private var _Property:MovieClip;
		private var _PageSP:Sprite;
		private var _TxtFormat:TextFormat = new TextFormat();
		private var _PageText:TextField;
		private var _PageMaxNum:Vector.<int>=new Vector.<int>;
		private var _NumericalTextWord:Vector.<String> = new < String > ["HP", "DEF", "SPD", "INT", "MND", "LV", "ATK"];
		private var _changeBtn:MovieClip;
		private var _CurrentNumerical:String = PlaySystemStrLab.Sort_Atk;
		private var _CurrentNum:int = 6;
		private var _CtrlNum:int = 2;
		private function creatViewHandler():void 
		{
			this._ExitBtn=(new (this._ary[2]));
			this._ExitBtn.name = "ExitBtn";
			this._ExitBtn.x = 50;
			this._ExitBtn.y = 120;
			this._ExitBtn.buttonMode = true;
			this._conter.addChild(this._ExitBtn);
			this.AddbtnFactory(this._ExitBtn);
		}
		//Sort&頁數顯示
		private function SortViewHandler():void
		{
			var NumericalText:TextField;
			var _NumericalBtn:Sprite;
			this._sortBtn = new Sprite();
			this._bgBtn = new Sprite();
			for (var j:int = 0; j < 7; j++ ) {
					this._bgBtn = new Sprite();
					_NumericalBtn=(new (this._ary[1]));
					_NumericalBtn.scaleX = 2.5;
					this._bgBtn.name = ""+j;
					this._bgBtn.x = 800;
					this._bgBtn.y = 85;
					this._bgBtn.buttonMode = true;
					(j == 6)?this._bgBtn.alpha = 1:this._bgBtn.alpha = 0;
					this._bgBtn.addEventListener(MouseEvent.CLICK, onClickHandler);
					this._bgBtn.addChild(_NumericalBtn);
					this._NumericalBoxVector.push(_bgBtn);
					
					NumericalText= new TextField();
					this._TxtFormat.color = 0xFFFFFF;
					this._TxtFormat.size = 17;
					this._TxtFormat.bold = true;
					NumericalText.defaultTextFormat = this._TxtFormat;
					NumericalText.x = 40;
					NumericalText.y = 7;
					NumericalText.width = 50;
					NumericalText.height = 40;
					NumericalText.text = this._NumericalTextWord[j];
					//NumericalText.selectable = false;
					NumericalText.mouseEnabled = false;
					this._bgBtn.addChild(NumericalText);
					
					this._conter.addChild(this._bgBtn);
					
					this._Property = (new (this._ary[3]));
					this._Property.x = 11;
					this._Property.y = 6;
					this._Property.gotoAndStop(j+1);
					this._Property.name = "Property" + j;
					this._bgBtn.addChild(this._Property);
			}
			this._sortBtn=(new (this._ary[0]));
			this._sortBtn.name = "sortBtn";
			this._sortBtn.x = 900;
			this._sortBtn.y = 85;
			this._sortBtn.buttonMode = true;
			this._conter.addChild(this._sortBtn);
			
			this._changeBtn = new (this._ary[5]);
			this._changeBtn.name = "changeBtn";
			this._changeBtn.x = 935;
			this._changeBtn.y = 85;
			this._changeBtn.buttonMode = true;
			this._conter.addChild(this._changeBtn);
			
			this._sortBtn.addEventListener(MouseEvent.CLICK, _onNumericalBoxBtnClickHandler);
			this._changeBtn.addEventListener(MouseEvent.CLICK, ConversionArrangedClickHandler);
			
			for (var i:int = 0; i < 2; i++) {
				var _pageBtnS:MovieClip = (new (this._ary[4]));
					_pageBtnS.x = 420 + 150 * i;
					_pageBtnS.y = 85;
					_pageBtnS.name = "btn" + i;
					_pageBtnS.buttonMode = true;
					
					_pageBtnS.addEventListener(MouseEvent.CLICK, _onClickHandler , false , 0 , true );
					//_pageBtnS.addEventListener(MouseEvent.ROLL_OVER, _onRollOverBtnHandler , false , 0 , true );
					//_pageBtnS.addEventListener(MouseEvent.ROLL_OUT, _onRollOutBtnHandler , false , 0 , true );
					if (_pageBtnS.name =="btn0") {
						_pageBtnS.scaleX = -1;
						_pageBtnS.gotoAndStop(3);
					}
					this._conter.addChild(_pageBtnS);
				}
			this._PageSP = (new (this._ary[1]));
			this._PageSP.scaleX = 3;
			this._PageSP.x = 430;
			this._PageSP.y = 82;
			this._conter.addChild(this._PageSP);
			
			this._PageText = new TextField();
			this._TxtFormat.color = 0xF5C401;
			this._TxtFormat.size = 20;
			this._TxtFormat.bold = true;
			this._PageText.defaultTextFormat = this._TxtFormat;
			this._PageText.x = 15;
			this._PageText.y = 4;
			this._PageText.width = 20;
			this._PageText.height = 40;
			//_PageText.autoSize = TextFieldAutoSize.CENTER;
			this._PageText.name = "PageText";
			this._PageSP.addChild(this._PageText);
			
			//this._funSend( UICmdStrLib.PageTextComplete);
		}
		//頁數控制按鈕
		private function _onClickHandler(e:MouseEvent):void
		{
			//trace(this._PageMaxNum[1],"@@@@@@@");
			if(this._NumericalBoxBtnBoolean==false)this.NumericalBoxBtnMove(this._CurrentNum);
			var _Wrap:Object = new Object();
				_Wrap["BtnName"] = e.currentTarget.name;
			this._funSend( UICmdStrLib.ClickMouseName, _Wrap);
			//this._funSend( MonsterCageStrLib.PageTextComplete);
		}
		
		private function PageText():void
		{
			//trace(this._PageMaxNum[1],"@@@@@@@");
			(this._PageText != null)?this._PageText.text = this._PageMaxNum[1] + "/" + this._PageMaxNum[0]:null;
			(this._PageMaxNum[1] == 1)?MovieClip(this._conter.getChildByName("btn0")).gotoAndStop(3):MovieClip(this._conter.getChildByName("btn0")).gotoAndStop(1);
			(this._PageMaxNum[1] == this._PageMaxNum[0])?MovieClip(this._conter.getChildByName("btn1")).gotoAndStop(3):MovieClip(this._conter.getChildByName("btn1")).gotoAndStop(1);
		}
		
		//開啟屬性面板按鈕
		private function _onNumericalBoxBtnClickHandler(e:MouseEvent):void
		{
			for (var i:String in this._NumericalBoxVector) this._NumericalBoxVector[i].alpha = 1;
			this.NumericalBoxBtnMove(this._CurrentNum);
		}
		private function NumericalBoxBtnMove(_InputName:int):void
		{
			for (var i:int = 6; i >=0; i-- ) {
				if (this._NumericalBoxBtnBoolean) {
				TweenLite.to(this._NumericalBoxVector[i], 0.3, { x:this._bgBtn.x, y:this._bgBtn.y -210+ (i * 35), alpha:1, delay: i * 0.05,onComplete:NumericalBoxHandler,onCompleteParams:[this._NumericalBoxBtnBoolean] } );
				}else {
				TweenLite.to(this._NumericalBoxVector[i], 0.3, { x:this._bgBtn.x, y:this._bgBtn.y, alpha:(_InputName==i)?1:0, delay: i * 0.05, onComplete:NumericalBoxHandler, onCompleteParams:[this._NumericalBoxBtnBoolean] } );
				}
			}
		}
		private function NumericalBoxHandler(_InputBoolean:Boolean):void
		{
			switch (_InputBoolean) {
				case true :
					this._NumericalBoxBtnBoolean = false;
					break;
				case false :
					this._NumericalBoxBtnBoolean = true;
					break;
			}
		}
		//轉換排列 //排列數值大小按鈕
		private function ConversionArrangedClickHandler(e:MouseEvent):void
		{
			if (this._CtrlNum == 2) {
				this._changeBtn.gotoAndStop(2);
				this._CtrlNum = 1;
			}else if (this._CtrlNum == 1) {
				this._changeBtn.gotoAndStop(1);
				this._CtrlNum = 2;
			}
			var _Wrap:Object = new Object();
				_Wrap["_sort"] = this._CurrentNumerical ;
				(this._CtrlNum == 1)?_Wrap["CtrlNum"] = 1:_Wrap["CtrlNum"] = -1;
			this._funSend( UICmdStrLib.AscendingOrDescending , _Wrap );
		}
		
		
		//屬性按鈕
		private function onClickHandler(e:MouseEvent):void
		{
			for (var i:String in this._NumericalBoxVector) this._NumericalBoxVector[i].alpha = 1;
			this._conter.setChildIndex(Sprite(e.currentTarget), this._conter.numChildren - 1);
			this._conter.setChildIndex(Sprite(this._conter.getChildByName("sortBtn")), this._conter.numChildren - 1);
			this._conter.setChildIndex(Sprite(this._conter.getChildByName("changeBtn")), this._conter.numChildren - 1);
			switch(e.currentTarget.name) 
				{
					case "0":
						this._CurrentNumerical = PlaySystemStrLab.Sort_HP;
						this._CurrentNum = 0;
						break;
					case "1":
						this._CurrentNumerical= PlaySystemStrLab.Sort_Def;
						this._CurrentNum = 1;
						break;
					case "2":
						this._CurrentNumerical= PlaySystemStrLab.Sort_Speed;
						this._CurrentNum = 2;
						break;
					case "3":
						this._CurrentNumerical = PlaySystemStrLab.Sort_Int;
						this._CurrentNum = 3;
						break;
					case "4":
						this._CurrentNumerical= PlaySystemStrLab.Sort_Mnd;
						this._CurrentNum = 4;
						break;
					case "5":
						this._CurrentNumerical = PlaySystemStrLab.Sort_LV;
						this._CurrentNum = 5;
						break;
					case "6":
						this._CurrentNumerical = PlaySystemStrLab.Sort_Atk;
						this._CurrentNum = 6;
						break;
				}
			this.NumericalBoxBtnMove(this._CurrentNum);
			var _Wrap:Object = new Object();
				_Wrap["_sort"] = this._CurrentNumerical ;
				(this._CtrlNum == 1)?_Wrap["CtrlNum"] = 1:_Wrap["CtrlNum"] = -1;
			this._funSend( UICmdStrLib.SortNumerical , _Wrap );
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
					e.target.gotoAndStop(2);
					if (!TweenMax.isTweening(e.target)) this.onCompleteShake(e.target , true , 4);
				break;
				case "rollOut":
					e.target.gotoAndStop(1);
				break;
				case "click":
					this._funPublicfun("Exit");
					this._funSend(  UICmdStrLib.onRemoveALL );
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
			if (this._KeyName == "StorageWall" && _vaules[0] == 3) this.SortViewHandler();
			//if (this._KeyName == "StorageWall")
			//this._PageMaxNum[0] = int(_vaules[0]);
			//this._PageMaxNum[1] = int(_vaules[1]);
			//this.PageText();
			if(this._NumericalBoxBtnBoolean==false)this.NumericalBoxBtnMove(this._CurrentNum);
		}
		
		public function onRemove():void 
		{
			this._conter.removeEventListener(MouseEvent.ROLL_OVER, btnChange);
			this._conter.removeEventListener(MouseEvent.ROLL_OUT, btnChange);
			this._conter.removeEventListener(MouseEvent.CLICK, btnChange);
			this._conter.removeChild(this._ExitBtn);
			
			var _CurrentTarget:*;
			for (var j:int = 0; j < 7; j++ ) {
				_CurrentTarget = this._conter.getChildByName("btn" + j);
				_CurrentTarget != null ? this._conter.removeChild( _CurrentTarget ): null;
			}
			this._sortBtn.removeEventListener(MouseEvent.CLICK, _onNumericalBoxBtnClickHandler);
			this._bgBtn.removeEventListener(MouseEvent.CLICK, onClickHandler);
			this._changeBtn.removeEventListener(MouseEvent.CLICK, ConversionArrangedClickHandler);
			
			while (this._conter.numChildren>0) 
			{
				this._conter.removeChildAt(0);
			}
		}
		
	}
}