package MVCprojectOL.ViewOL.SharedMethods 
{
	import com.greensock.easing.Elastic;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import MVCprojectOL.ControllOL.SoundControlCenter.SoundEventStrLib;
	import Spark.coreFrameWork.observer.Notify;
	import Spark.Utils.Text;
	import strLib.commandStr.UICmdStrLib;
	/**
	 * ...
	 * @author brook
	 * @version 13.06.20.11.48
	 */
	public class BasisPanel extends Notify
	{
		protected var _SharedEffect:SharedEffect = new SharedEffect();
		protected var _BGObj:Object;
		protected var _Panel:Sprite;
		
		protected var _PageList:Array;
		protected var _CtrlPageNum:int = 0;
		protected var _TextObj:Object = { _str:"", _wid:0, _hei:0, _wap:false, _AutoSize:"CENTER", _col:0xF4F0C1, _Size:16, _bold:true, _font:"Times New Roman", _leading:null };
		private var _RemoveStr:String;
		private var _TipsView:TipsView = new TipsView("MonsterPanel");//---tip---
		private var _IntPageList:int;
		
		public function BasisPanel(_InputObj:Object, _InputPanel:Sprite, _RemoveStr:String = UICmdStrLib.RemoveALL) 
		{
			this._BGObj = _InputObj;
			this._Panel = _InputPanel;
			this._RemoveStr = _RemoveStr;
			this._Panel.addEventListener(MouseEvent.CLICK, playerClickProcess);
		}
		//
		public function AddBasisPanel(_TitleName:String, _BgBW:int, _BgBH:int, _TitleW:int):void 
		{
			var _BgB:Sprite = new (this._BGObj.BgB as Class);
				_BgB.width = _BgBW;
				_BgB.height = _BgBH;
				_BgB.x = 20;
				_BgB.y = 70;
			this._Panel.addChild(_BgB);
			
			var _EdgeBg:Sprite;
			for (var k:int = 0; k < 2; k++) 
			{
				_EdgeBg = new (this._BGObj.EdgeBg as Class);
				(k == 0)?_EdgeBg.scaleY = -1:_EdgeBg.scaleY = 1;
				(k == 0)?_EdgeBg.y =  90:_EdgeBg.y = _BgB.height + 40;
				_EdgeBg.x = _BgB.width / 2 + _BgB.x;
				this._Panel.addChild(_EdgeBg);
			}
			
			var _Title:Sprite = new (this._BGObj.Title as Class);
				_Title.width = _TitleW;
				_Title.x = (_BgB.width / 2) - (_Title.width / 2) + _BgB.x;
				_Title.y =  -500;
			this._Panel.addChild(_Title);
			TweenLite.to(_Title, 1, { y:85 } );
			
			
			this._TextObj._col = 0xF4F0C1;
			this._TextObj._Size = 16;
			this._TextObj._str = _TitleName;
			var _TitleText:Text = new Text(this._TextObj);
				_TitleText.y = 7;
				_TitleText.mouseEnabled = false;
			_Title.addChild(_TitleText);
			var _TitleTextX:int;
			if (_TitleW == 256) _TitleTextX = 90;
			if (_TitleW == 400) _TitleTextX = 103;
			if (_TitleW == 560) (_TitleText.width == 45.1)?_TitleTextX = 105: _TitleTextX = 109;
				_TitleText.x = _TitleTextX;//90
			
			var _ExplainBtn:MovieClip = new (this._BGObj.ExplainBtn as Class);
				_ExplainBtn.x = _BgB.x + 10;
				_ExplainBtn.y = _BgB.y + 10;
				_ExplainBtn.name = "ExplainBtn";
				_ExplainBtn.buttonMode = true;
			this._Panel.addChild(_ExplainBtn);
			this._SharedEffect.MovieClipMouseEffect(_ExplainBtn);
			this._TipsView.MouseEffect(_ExplainBtn);
			
			var _CloseBtn:MovieClip = new (this._BGObj.CloseBtn as Class);
				_CloseBtn.x = _BgBW - 15;
				_CloseBtn.y = _BgB.y + 10;
				_CloseBtn.name = "CloseBtn";
				_CloseBtn.buttonMode = true;
			this._Panel.addChild(_CloseBtn);
			this._SharedEffect.MovieClipMouseEffect(_CloseBtn);
			this._TipsView.MouseEffect(_CloseBtn);
			
			this._SharedEffect.ZoomIn(this._Panel, _BgBW, _BgBH, 0.5);
		}
		//增加魂力
		public function AddFatigue(_scaleX:Number, _scaleY:Number, _X:int, _Y:int, _Name:String = "Fatigue"):void 
		{
			var _Fatigue:Bitmap = new Bitmap(BitmapData(new(this._BGObj.Fatigue as Class)));
				_Fatigue.scaleX = _scaleX;
				_Fatigue.scaleY = _scaleY;
				_Fatigue.x = _X;
				_Fatigue.y = _Y;
				_Fatigue.name = _Name;
			this._Panel.addChild(_Fatigue);
		}
		//增加確認按鈕
		public function AddCheckBtn(_BtnStr:String, _X:int, _Y:int, _BtnW:int, _BtnName:String = "CheckBtn"):MovieClip
		{
			if (this._Panel.getChildByName("GrayCheckBtn") != null) this._Panel.removeChild(this._Panel.getChildByName("GrayCheckBtn"));
			this._TextObj._col = 0xF4F0C1;
			this._TextObj._Size = 14;
			var _CheckBtn:MovieClip = new (_BGObj.CheckBtn as Class);
				_CheckBtn.width = _BtnW;
				_CheckBtn.x = _X;
				_CheckBtn.y = _Y;
				_CheckBtn.name = _BtnName;
				_CheckBtn.buttonMode = true;
			this._Panel.addChild(_CheckBtn);
			this._SharedEffect.MovieClipMouseEffect(_CheckBtn);
			_TextObj._str = _BtnStr;
			var _CheckBtnText:Text = new Text(_TextObj);
				(_CheckBtn.width == 85)?_CheckBtnText.x = 47:_CheckBtnText.x = _CheckBtn.width / 2 - _CheckBtnText.width / 2;
				_CheckBtnText.y = 10;
			_CheckBtn.addChild(_CheckBtnText);
			return _CheckBtn;
		}
		public function AddGrayCheckBtn(_BtnStr:String, _X:int, _Y:int, _BtnW:int, _BtnName:String = "GrayCheckBtn"):Sprite 
		{
			if (this._Panel.getChildByName("CheckBtn") != null) this._Panel.removeChild(this._Panel.getChildByName("CheckBtn"));
			this._TextObj._col = 0xFFFFFF;
			this._TextObj._Size = 14;
			var _CheckBtn:Sprite = new (_BGObj.CheckBtn as Class);
				_CheckBtn.width = _BtnW;
				_CheckBtn.x = _X;
				_CheckBtn.y = _Y;
				_CheckBtn.name = _BtnName;
			this._Panel.addChild(_CheckBtn);
			TweenLite.to(_CheckBtn, .5, { colorMatrixFilter: { matrix : [0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0] }} );
			_TextObj._str = _BtnStr;
			var _CheckBtnText:Text = new Text(_TextObj);
				(_CheckBtn.width == 85)?_CheckBtnText.x = 47:_CheckBtnText.x = _CheckBtn.width / 2 - _CheckBtnText.width / 2;
				_CheckBtnText.y = 10;
			_CheckBtn.addChild(_CheckBtnText);
			return _CheckBtn;
		}
		//增加翻頁按鈕
		public function AddPageBtn(_BtnX:int, _BtnY:int = 530):void
		{
			this._TextObj._col = 0xF4F0C1;
			this._TextObj._Size = 16;
			var _PageBtnS:MovieClip;
			for (var j:int = 0; j < 2; j++) 
			{
				_PageBtnS = new (this._BGObj.PageBtnS as Class);
				_PageBtnS.x = _BtnX + j * 80;
				_PageBtnS.y = _BtnY;
				_PageBtnS.name = "btn" + j;
				if (_PageBtnS.name == "btn0") _PageBtnS.scaleX = -1;
				_PageBtnS.addEventListener(MouseEvent.CLICK, _onClickHandler);
				_PageBtnS.addEventListener(MouseEvent.ROLL_OVER, _onRollOverBtnHandler);
				_PageBtnS.addEventListener(MouseEvent.ROLL_OUT, _onRollOutBtnHandler);
				this._Panel.addChild(_PageBtnS);
				this._TipsView.MouseEffect(_PageBtnS);
			}
			_TextObj._str = "0" +" / " +"0";
			var _PageText:Text = new Text(_TextObj);
				_PageText.x = this._Panel.getChildByName("btn0").x + 24; //219
				_PageText.y = _BtnY;
				_PageText.name = "PageText";
				_PageText.mouseEnabled = false;
			this._Panel.addChild(_PageText);
			
			var _PageSP:Sprite = this._SharedEffect.DrawRect(0, 0, _PageText.width, _PageText.height);
				_PageSP.x = _PageText.x;
				_PageSP.y = _PageText.y;
				_PageSP.name = "PageSP";
				_PageSP.alpha = 0;
			_Panel.addChild(_PageSP);
			this._TipsView.MouseEffect(_PageSP);
		}
		//輸入翻頁資訊
		public function PageData(_PageList:Array, _CtrlPageNum:int):void
		{
			this._PageList = _PageList;
			this._CtrlPageNum = _CtrlPageNum;
			
			var _Btn0:MovieClip = MovieClip(this._Panel.getChildByName("btn0"));
			var _Btn1:MovieClip = MovieClip(this._Panel.getChildByName("btn1"));
			if (this._PageList.length != 0 && this._PageList.length != 1)  {
				_Btn0.buttonMode = false;
				_Btn1.buttonMode = true;
			}else {
				_Btn0.buttonMode = false;
				_Btn1.buttonMode = false;
			}
			this._PageList.length != 0?Text(_Panel.getChildByName("PageText")).ReSetString(this._CtrlPageNum + 1 + " / " + this._PageList.length):Text(_Panel.getChildByName("PageText")).ReSetString(this._CtrlPageNum + " / " + this._PageList.length);
		}
		public function IntPageData(_PageList:int, _CtrlPageNum:int):void
		{
			this._IntPageList = _PageList;
			this._CtrlPageNum = _CtrlPageNum;
			
			var _Btn0:MovieClip = MovieClip(this._Panel.getChildByName("btn0"));
			var _Btn1:MovieClip = MovieClip(this._Panel.getChildByName("btn1"));
			if (_PageList != 0 && _PageList != 1)  {
				_Btn0.buttonMode = false;
				_Btn1.buttonMode = true;
			}else {
				_Btn0.buttonMode = false;
				_Btn1.buttonMode = false;
			}
			_PageList != 0?Text(_Panel.getChildByName("PageText")).ReSetString(this._CtrlPageNum + 1 + " / " + _PageList):Text(_Panel.getChildByName("PageText")).ReSetString(this._CtrlPageNum + " / " + _PageList);
		}
		//翻頁按鈕點擊滑入滑出效果
		protected function _onClickHandler(e:MouseEvent):void
		{
			var _Btn0:MovieClip = MovieClip(this._Panel.getChildByName("btn0"));
			var _Btn1:MovieClip = MovieClip(this._Panel.getChildByName("btn1"));
			var _PageNum:int;
			(this._PageList != null)?_PageNum = this._PageList.length:_PageNum = this._IntPageList;
				switch(e.currentTarget.name)
				{
					case "btn0":
						if (this._CtrlPageNum != 0) {
							this._CtrlPageNum == _PageNum-1?_Btn1.gotoAndStop(1):null;
							this._CtrlPageNum == 1?MovieClip(e.currentTarget).gotoAndStop(1):null;
							this._CtrlPageNum <= 0?this._CtrlPageNum = this._CtrlPageNum:(this._CtrlPageNum --) && (this.CtrlPage(this._CtrlPageNum, false));
							this.SendNotify( SoundEventStrLib.PlaySoundEffect , "GUI00008_SND" );//音效
						}
					break;
					case "btn1":
						if (this._CtrlPageNum != _PageNum - 1 && _PageNum > 1) {
							this._CtrlPageNum == 0?_Btn0.gotoAndStop(1):null;
							this._CtrlPageNum == _PageNum-2?MovieClip(e.currentTarget).gotoAndStop(1):null;
							this._CtrlPageNum ++;
							this._CtrlPageNum < _PageNum?this.CtrlPage(this._CtrlPageNum, true):this._CtrlPageNum --;
							this.SendNotify( SoundEventStrLib.PlaySoundEffect , "GUI00008_SND" );//音效
						}
					break;
				}
			this._CtrlPageNum == 0?_Btn0.buttonMode = false:_Btn0.buttonMode = true;
			(this._CtrlPageNum == _PageNum - 1 || _PageNum <= 1) ?_Btn1.buttonMode = false:_Btn1.buttonMode = true;
		}
		protected function _onRollOverBtnHandler(e:MouseEvent):void
		{
			var _Btn:MovieClip = MovieClip(e.currentTarget);
			var _PageNum:int;
			(this._PageList != null)?_PageNum = this._PageList.length:_PageNum = this._IntPageList;
			switch(e.currentTarget.name)
			{
				case "btn0":
					this._CtrlPageNum == 0?_Btn.gotoAndStop(1):_Btn.gotoAndStop(2);
				break;
				case "btn1":
					(this._CtrlPageNum == _PageNum - 1 || _PageNum <= 1)?_Btn.gotoAndStop(1):_Btn.gotoAndStop(2);
				break;
			}
			var _Btn0:MovieClip = MovieClip(this._Panel.getChildByName("btn0"));
			var _Btn1:MovieClip = MovieClip(this._Panel.getChildByName("btn1"));
			this._CtrlPageNum == 0?_Btn0.buttonMode = false:_Btn0.buttonMode = true;
			(this._CtrlPageNum == _PageNum - 1 || _PageNum <= 1) ?_Btn1.buttonMode = false:_Btn1.buttonMode = true;
		}
		protected function _onRollOutBtnHandler(e:MouseEvent):void
		{
			var _Btn:MovieClip = MovieClip(e.currentTarget);
			var _PageNum:int;
			(this._PageList != null)?_PageNum = this._PageList.length:_PageNum = this._IntPageList;
			switch(e.currentTarget.name)
			{
				case "btn0":
					this._CtrlPageNum == 0?_Btn.gotoAndStop(1):_Btn.gotoAndStop(1);
				break;
				case "btn1":
					(this._CtrlPageNum == _PageNum - 1 || _PageNum <= 1)?_Btn.gotoAndStop(1):_Btn.gotoAndStop(1);
				break;
			}
		}
		//傳送翻頁資訊
		protected function CtrlPage(_InputPage:int , _CtrlBoolean:Boolean):void
		{
			var _PageData:Object = new Object();
				_PageData["CtrlPageNum"] = _InputPage;
				_PageData["CtrlBoolean"] = _CtrlBoolean;
			this.SendNotify(UICmdStrLib.CtrlPage, _PageData);
		}
		//
		protected function playerClickProcess(e:MouseEvent):void 
		{
			if (e.target.name == "CloseBtn" ) {
				this.SendNotify( SoundEventStrLib.PlaySoundEffect , "GUI00006_SND" );//音效
				TweenLite.to(this._Panel, 0.3, { x:(1000 - this._Panel.width / 2) / 2 - 20, y:(700 - this._Panel.height / 2) / 2 - 70, scaleX:0.5, scaleY:0.5 , onComplete:RemovePanel } );
			}
		}
		
		protected function RemovePanel():void
		{
			this.SendNotify(this._RemoveStr);
		}
		
	}
}