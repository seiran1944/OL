package MVCprojectOL.ViewOL.SharedMethods 
{
	import com.greensock.easing.Elastic;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import Spark.Utils.Text;
	/**
	 * ...
	 * @author brook
	 */
	public class AskPanel 
	{
		private var _SharedEffect:SharedEffect = new SharedEffect();
		private var _viewConterBox:DisplayObjectContainer;
		private var _BGObj:Object;
		private var _TextObj:Object = { _str:"", _wid:0, _hei:0, _wap:false, _AutoSize:"CENTER", _col:0xFFFFFF, _Size:16, _bold:true, _font:"Times New Roman", _leading:null };
		private var _Inform:Sprite = new Sprite();
		private var _BtnNum:int;
		private var _BtnName:String;
		private var _BtnY:int;
		private var _EngBtnName:String;
		
		public function AddElement(_viewConterBox:DisplayObjectContainer, _BGObj:Object):void
		{
			this._viewConterBox = _viewConterBox;
			this._BGObj = _BGObj;
			//this._BtnNum = _Num;
			
			//this.AddInform();
		}
		
		public function AddInform(_Num:int = 2, _BtnName:String = "確定", _BtnY:int = 180, _EngBtnName:String = "Make0"):void 
		{
			this._BtnNum = _Num;
			this._BtnName = _BtnName;
			this._BtnY = _BtnY;
			this._EngBtnName = _EngBtnName;
			
			var _AlphaBox:Sprite; 
				_AlphaBox = this._SharedEffect.DrawRect(0, 0, 1000, 700);
				_AlphaBox.name = "InformBox";
				_AlphaBox.alpha = 0;
			this._viewConterBox.addChild(_AlphaBox );
			
			this._Inform.x = 393;
			this._Inform.y = 255;
			this._Inform.scaleX = 0.5;
			this._Inform.scaleY = 0.5;
			this._Inform.name = "Inform";
			this._viewConterBox.addChild(this._Inform);
			
			var _BgB:Sprite = new (this._BGObj.BgB as Class);
				_BgB.width = 430;
				_BgB.height = 280;
			this._Inform.addChild(_BgB);
			
			var _DemonAvatar:Bitmap = new Bitmap(BitmapData(new ( this._BGObj.DemonAvatar as Class)));
				_DemonAvatar.x = _BgB.width / 2 - _DemonAvatar.width / 2;
				_DemonAvatar.y = -30;
			this._Inform.addChild(_DemonAvatar);
			
			var _EdgeBg:Sprite = new (this._BGObj.EdgeBg as Class);
				_EdgeBg.y = _BgB.height - 25;
				_EdgeBg.x = _BgB.width / 2 + _BgB.x;
			this._Inform.addChild(_EdgeBg);
			
			var _Paper:Bitmap = new Bitmap(BitmapData(new ( this._BGObj.Paper as Class)));
				_Paper.x = 20;
				_Paper.y = 25;
			this._Inform.addChild(_Paper);
			
			(this._BtnNum == 0)?this.AddAddBtnZero():(this._BtnNum == 1)?this.AddBtnOne():this.AddBtnTow();
			
			this._SharedEffect.ZoomIn(this._Inform, this._Inform.width * 2, this._Inform.height * 2, .5);
		}
		private function AddAddBtnZero():void 
		{
			this._Inform.alpha = 0.9;
			TweenLite.to(this._Inform, 1.5, { alpha:1 , onComplete:RemovePanel } );
		}
		private function AddBtnOne():void 
		{
			var _CheckBtn:MovieClip;
			var _CheckBtnText:Text;
			this._TextObj._Size = 16;
			
				_CheckBtn = new (this._BGObj.CheckBtn as Class);
				_CheckBtn.width = 85;
				_CheckBtn.x = 173;
				_CheckBtn.y = this._BtnY;
				_CheckBtn.name = this._EngBtnName;
				_CheckBtn.buttonMode = true;
				this._Inform.addChild(_CheckBtn);
				this._SharedEffect.MovieClipMouseEffect(_CheckBtn);
				this._TextObj._str = this._BtnName;
				_CheckBtnText = new Text(_TextObj);
				_CheckBtn.addChild(_CheckBtnText);
				_CheckBtnText.x = 35;
				_CheckBtnText.y = 10;
		}
		private function AddBtnTow():void 
		{
			var _CheckBtn:MovieClip;
			var _CheckBtnText:Text;
			this._TextObj._Size = 16;
			for (var i:int = 0; i < 2; i++) 
			{
				_CheckBtn = new (this._BGObj.CheckBtn as Class);
				_CheckBtn.width = 85;
				_CheckBtn.x = 95+i * 150;
				_CheckBtn.y = 180;
				_CheckBtn.name = "Make" + i;
				_CheckBtn.buttonMode = true;
				this._Inform.addChild(_CheckBtn);
				this._SharedEffect.MovieClipMouseEffect(_CheckBtn);
				if (i == 0) { 
					this._TextObj._str = "確定";
					_CheckBtnText = new Text(_TextObj);
					_CheckBtn.addChild(_CheckBtnText);
				}else {
					this._TextObj._str = "取消";
					_CheckBtnText = new Text(_TextObj);
					_CheckBtn.addChild(_CheckBtnText);
				}
				_CheckBtnText.x = 35;
				_CheckBtnText.y = 10;
			}
		}
		
		public function RemovePanel():void 
		{
			if (this._viewConterBox.getChildByName("InformBox") != null) this._viewConterBox.removeChild(this._viewConterBox.getChildByName("InformBox"));
			if (this._viewConterBox.getChildByName("Inform") != null ) this._Inform.removeChildren();
			if (this._viewConterBox.getChildByName("Inform") != null) this._viewConterBox.removeChild(this._Inform);
		}
		
		//輸入文字訊息
		public function AddMsgText(_Msg:String, _X:int, _Y:int = 100):void 
		{
			this._TextObj._str = _Msg;
			this._TextObj._Size = 20;
			var _MsgText:Text = new Text(this._TextObj);
			this._Inform.addChild(_MsgText);
			_MsgText.x = 215 - _MsgText.width / 2;
			_MsgText.y = _Y;
		}
		
	}
}