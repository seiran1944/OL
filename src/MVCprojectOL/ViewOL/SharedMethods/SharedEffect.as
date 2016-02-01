package MVCprojectOL.ViewOL.SharedMethods 
{
	import com.greensock.easing.Elastic;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author brook
	 */
	public class SharedEffect 
	{
		//畫矩形
		public function DrawRect(_LocationX:int, _LocationY:int, _Width:int, _Height:int):Sprite
		{
			var _sp:Sprite = new Sprite ();
				_sp.graphics.beginFill(0xFFFFFF);
				_sp.graphics.drawRect(_LocationX,_LocationY,_Width,_Height);
			return _sp;
		}
		//縮放
		public function ZoomIn(_InputSp:Sprite, _OriginalWidth:int, _OriginalHeight:int, _Proportion:Number):void
		{
			var _NewX:int = _InputSp.x - ((_OriginalWidth * _Proportion)) * _Proportion;
			var _NewY:int = _InputSp.y - ((_OriginalHeight * _Proportion)) * _Proportion;
			TweenLite.to(_InputSp, 1, { x:_NewX, y:_NewY, scaleX:1, scaleY:1 , ease:Elastic.easeOut } );
		}
		//閃爍
		public function Brilliant(_Icon:*, _CtrlBoolean:Boolean):void
		{
			(_CtrlBoolean == false)?TweenLite.to(_Icon, 1, { alpha:1, onComplete:this.Brilliant , onCompleteParams : [_Icon, true]} ):TweenLite.to(_Icon, 1, { alpha:0, onComplete:this.Brilliant , onCompleteParams : [_Icon, false]} );
		}
		//模糊閃爍
		public function GlowFilterBrilliant(_Icon:Sprite, _CtrlBoolean:Boolean):void
		{
			(_CtrlBoolean == false)?TweenLite.to(_Icon, 1, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }, onComplete:this.GlowFilterBrilliant , onCompleteParams : [_Icon, true]} ):TweenLite.to(_Icon, 1, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }, onComplete:this.GlowFilterBrilliant , onCompleteParams : [_Icon, false]} );
		}
		//次數模糊閃爍
		public function TimesGlowFilterBrilliant(_Icon:Sprite, _CtrlBoolean:Boolean, Times:int):void
		{
			if (Times > 0) { 
				(_CtrlBoolean == false)?TweenLite.to(_Icon, 1, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }, onComplete:this.TimesGlowFilterBrilliant , onCompleteParams : [_Icon, true, Times] } ):TweenLite.to(_Icon, 1, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }, onComplete:this.TimesGlowFilterBrilliant , onCompleteParams : [_Icon, false, Times - 1] } );
			}else {
				TweenLite.to(_Icon, 1, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
			}
			
		}
		//滑鼠滑入滑出效果 跳影格
		public function MovieClipMouseEffect(btn:*):void
		{
			btn.addEventListener(MouseEvent.ROLL_OVER, BtnEffect);
			btn.addEventListener(MouseEvent.ROLL_OUT, BtnEffect);
		}
		private function BtnEffect(e:MouseEvent):void 
		{
			switch (e.type) 
			{
				case "rollOver":
					MovieClip(e.target).gotoAndStop(2);
				break;
				case "rollOut":
					MovieClip(e.target).gotoAndStop(1);
				break;
			}
		}
		public function RemoveMovieClipMouseEffect(btn:*):void
		{
			btn.removeEventListener(MouseEvent.ROLL_OVER, BtnEffect);
			btn.removeEventListener(MouseEvent.ROLL_OUT, BtnEffect);
		}
		
		//滑鼠滑入滑出效果 
		public function MouseEffect(btn:*):void
		{
			btn.addEventListener(MouseEvent.ROLL_OVER, MouseBtnEffect);
			btn.addEventListener(MouseEvent.ROLL_OUT, MouseBtnEffect);
		}
		private function MouseBtnEffect(e:MouseEvent):void 
		{
			switch (e.type) 
			{
				case "rollOver":
					 TweenLite.to(e.target, 0, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }} );
				break;
				case "rollOut":
					 TweenLite.to(e.target, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
				break;
			}
		}
		public function RemoveMouseEffect(btn:*):void
		{
			btn.removeEventListener(MouseEvent.ROLL_OVER, MouseBtnEffect);
			btn.removeEventListener(MouseEvent.ROLL_OUT, MouseBtnEffect);
		}
		
	}
}