package MVCprojectOL.ViewOL.SharedMethods 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import MVCprojectOL.ModelOL.ShowSideSys.TimeConversion;
	/**
	 * ...
	 * @author brook
	 */
	public class ChangeNumPic 
	{
		private var _MainContainer:Sprite;
		private var _CompleteTime:int;
		private var _TotalTime:int;
		private var _NumberAry:Array;
		private var _TimeConversion:TimeConversion = new TimeConversion();
		private var _SurplusTime:int;
		private var _TimeStr:String;
		private var _TimeNum:Vector.<int> = new Vector.<int>;
		private var _NumBmp:Vector.<Bitmap> = new <Bitmap>[new Bitmap(),new Bitmap(),new Bitmap(),new Bitmap(),new Bitmap(),new Bitmap(),new Bitmap(),new Bitmap()];
		private var _NowTime:int;
		
		public function ChangeNumPic(_InputContainer:Sprite) 
		{
			this._MainContainer = _InputContainer;
		}
		
		//輸入素材
		public function AddSource(_InputNumAry:Array):void
		{
			this._NumberAry = _InputNumAry;
		}
		
		//輸入數據
		public function SetHandler(_InputNowTime:int, _InputCompleteTime:int, _InputTotalTime:int):void
		{
			this._NowTime = _InputNowTime;
			this._CompleteTime = _InputCompleteTime;
			this._TotalTime = _InputTotalTime;
			this._SurplusTime = this._CompleteTime-this._NowTime;
			this._TimeStr = this._TimeConversion.TimerConversion(_SurplusTime);
			
			this._TimeNum.length= 0;
			for (var i:int = 1; i < 9; i++) 
			{
				this._TimeNum.push(_TimeStr.substr(i - 1, 1));
				if (i != 3 && i != 6) {  
					this._NumBmp[i - 1].bitmapData = this._NumberAry[this._TimeNum[i - 1]]
				}
				if (i == 3 || i == 6) { 
					this._NumBmp[i - 1].bitmapData = this._NumberAry[10];
				}
				this._NumBmp[i - 1].x = 205 + i * 20;
				this._NumBmp[i - 1].y = 0;
				this._MainContainer.addChild(this._NumBmp[i - 1]);
			}
			
			this.TimingHandler();
		}
		
		//每秒更新
		public function TimingHandler():void
		{
			if (this._flagOpen == true) {
				this._NowTime++;
				this._TimeNum.length= 0;
				this._SurplusTime = this._CompleteTime-this._NowTime;
				this._TimeStr = this._TimeConversion.TimerConversion(_SurplusTime);
				
				for (var i:int = 1; i < 9; i++) 
				{
					this._TimeNum.push(_TimeStr.substr(i - 1, 1));
					if (i != 3 && i != 6) {
						this._NumBmp[i - 1].bitmapData = this._NumberAry[this._TimeNum[i - 1]]
					}
					if (i == 3 || i == 6) {
						this._NumBmp[i - 1].bitmapData = this._NumberAry[10];
					}
				}
				
			}
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