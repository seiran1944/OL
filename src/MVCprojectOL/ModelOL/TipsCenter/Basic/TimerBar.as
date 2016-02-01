package MVCprojectOL.ModelOL.TipsCenter.Basic 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import MVCprojectOL.ViewOL.SharedMethods.TimeConversion;
	/**
	 * ...
	 * @author brook
	 */
	public class TimerBar extends EventDispatcher
	{
		private var _MainContainer:Sprite;
		private var _TimeBar:Sprite;
		private var _CompleteTime:int;
		private var _TotalTime:int;
		private var _BarProportion:Number;
		//private var _NumberAry:Array;
		private var _TimeConversion:TimeConversion = new TimeConversion();
		private var _SurplusTime:int;
		private var _TimeStr:String;
		private var _TimeNum:Vector.<int> = new Vector.<int>;
		private var _TimeBarWidth:int;
		
		private var _TimeBarX:int = 90;//x軸位置
		private var _TimeBarY:int = 10;//Y軸位置
		private var _flagOpen:Boolean = false;
		private var _topBar:Bitmap;
		private var _NowTime:int;
		
		private var _TxtFormat:TextFormat = new TextFormat();
		private var _TimeNumText:TextField = new TextField();
		
		public function TimerBar(_InputContainer:Sprite) 
		{
			this._MainContainer = _InputContainer;
		}
		//位置設定
		public function SetInfo(_TimeBarX:int, _TimeBarY:int):void
		{
			this._TimeBarX = _TimeBarX;
			this._TimeBarY = _TimeBarY;
		}
		//輸入素材
		public function AddSource(_InputBar:Sprite, _InputNumAry:Array = null):void
		{
			this._TimeBar = _InputBar;
			this._TimeBar.x = _TimeBarX;
			this._TimeBar.y = _TimeBarY;
			this._MainContainer.addChild(this._TimeBar);
			this._topBar = (this._TimeBar.getChildAt(this._TimeBar.numChildren - 1)) as Bitmap;
			this._TimeBarWidth = this._topBar.width;
		}
		//輸入數據
		public function SetHandler(_InputNowTime:int, _InputCompleteTime:int, _InputTotalTime:int):void
		{
			this._NowTime = _InputNowTime;
			this._CompleteTime = _InputCompleteTime;// _InputNowTime + _InputTotalTime;
			this._TotalTime = _InputTotalTime;
			this._topBar.width = this._TimeBarWidth;
			this._BarProportion = (this._CompleteTime-this._NowTime) / this._TotalTime;
			(this._BarProportion >= 0)?this._topBar.width = this._TimeBarWidth * _BarProportion:this._topBar.width = 0;
			this._SurplusTime = this._CompleteTime-this._NowTime;
			(this._SurplusTime > 0)?this._TimeStr = this._TimeConversion.TimerConversion(_SurplusTime):this._TimeStr = this._TimeConversion.TimerConversion(0);
			//trace(_InputNowTime,_InputCompleteTime,_InputTotalTime,this._SurplusTime,this._TimeStr,"@@@@@");
			
			this._TxtFormat.color = 0xFFFFFF;
			this._TxtFormat.size = 12;
			this._TxtFormat.bold = true;
			this._TimeNumText.defaultTextFormat = this._TxtFormat;
			this._TimeNumText.width = 60;
			this._TimeNumText.height = 20;
			this._TimeNumText.x = this._TimeBar.width / 2 - 25;
			this._TimeNumText.y = this._TimeBar.height / 2 -10;
			this._TimeNumText.mouseEnabled = false;
			this._TimeNumText.text = this._TimeStr;
			this._TimeBar.addChild(this._TimeNumText);
			
			this.TimingHandler();
		}
		//每秒更新
		public function TimingHandler():void
		{
			//trace(this._NowTime,this._CompleteTime,this._TotalTime,"+++++++++++++++++++++++++++++");
			if (this._flagOpen == true) {
				this._NowTime++;
				this._TimeNum.length= 0;
				this._BarProportion = (this._CompleteTime-this._NowTime) / this._TotalTime;
				//trace(this._BarProportion,"@@@@@@@@@@@@");
				(this._BarProportion >= 0)?this._topBar.width = this._TimeBarWidth * _BarProportion:this._topBar.width = 0;
				this._SurplusTime = this._CompleteTime-this._NowTime;
				(this._SurplusTime > 0)?this._TimeStr = this._TimeConversion.TimerConversion(_SurplusTime):this._TimeStr = this._TimeConversion.TimerConversion(0);
				trace(this._TimeStr,"=====");
				this._TimeNumText.text = this._TimeStr;
			}
		}
		
		public function OpenCloseFlag(_flag:Boolean):void 
		{
			this._flagOpen = _flag;
		}
		
		//移除
		public function RemoveBar():void
		{
			while (this._MainContainer.numChildren>0) 
			{
				this._MainContainer.removeChildAt(0);
			}
		}
	}

}