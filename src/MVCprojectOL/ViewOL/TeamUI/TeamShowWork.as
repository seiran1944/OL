package MVCprojectOL.ViewOL.TeamUI
{
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class TeamShowWork extends TeamBasic
	{
		private var _spShift:Sprite;
		private var _mcLeft:MovieClip;
		private var _mcRight:MovieClip;
		
		public function TeamShowWork():void
		{
			this._spShift = new Sprite();
			addChild(this._spShift);
		}
		
		override public function AddSource(objSource:Object):void
		{
			this._mcLeft= new objSource["pageBtnM"]();
			this._mcRight = new objSource["pageBtnM"]();
			this._mcLeft.name = "teamLeft";
			this._mcRight .name = "teamRight";
			this._mcLeft.scaleX = -this._mcLeft.scaleX;
			this._mcLeft.buttonMode = true;
			this._mcRight.buttonMode = true;
			addChild(this._mcLeft);
			addChild(this._mcRight);
			this._mcLeft.y = this._mcRight.y = (this.Hei >> 1) -this._mcLeft.height;
			this._mcLeft.x = this._mcLeft.width;
			this._mcRight.x = this.Wid - this._mcRight.width;
			this.btnFactory(this._mcLeft);
			this.btnFactory(this._mcRight);
			//trace("檢測的UISIZE",this.width, this.height,this._mcRight.x);
			this.addEventListener(MouseEvent.ROLL_OUT, teamEffect,true);
			this.addEventListener(MouseEvent.ROLL_OVER, teamEffect,true);
		}
		
		private function teamEffect(e:MouseEvent):void
		{
			var leng:int = e.target.name.length;
			//trace(e.target.name, e.currentTarget.name, "CHECKINGrollOver",leng);
			switch (e.type) 
			{
				case "rollOver":
					if (leng < 6) {//隊伍
						this.toEffectTeam(e.target);
					}else {//按鈕
						this.btnChange(e);
					}
				break;
				case "rollOut":
					if (leng < 6) {//隊伍
						//this.toEffectTeam(e.target, false);
					}else {//按鈕
						this.btnChange(e);
					}
				break;
			}
		}
		
		private function toEffectTeam(target:Object):void 
		{
			TweenLite.to(target, .3, { glowFilter : { color:0xF0F0F0, alpha:.5, blurX:20, blurY:20 } , onComplete : this.completeEffectTeam , onCompleteParams : [target,false]} );
		}
		private function completeEffectTeam(target:MovieClip,trueEnd:Boolean):void 
		{
			if (!trueEnd) {
				TweenLite.to(target, .3, { glowFilter : { color:0xFFFFFF, alpha:0, blurX:0, blurY:0 } , onComplete : this.completeEffectTeam , onCompleteParams : [target,true]} );
			}else {
				target.filters = [];
			}
		}
		
		private function btnFactory(btn:MovieClip,remove:Boolean=false):void 
		{
			var aryListen:Array = [MouseEvent.MOUSE_DOWN, MouseEvent.MOUSE_UP];
			var leng:int = aryListen.length;
			
			for (var i:int = 0; i < leng; i++) 
			{
				btn[(!remove ? "addEventListener" : "removeEventListener")](aryListen[i], btnChange);
			}
			//trace("檢測移除事件", btn.hasEventListener(aryListen[0]));
		}
		
		private function btnChange(e:MouseEvent):void 
		{
			//trace(e.type, "mouseBtnType",e.target.name,e.currentTarget.name);
			if (!(e.target is MovieClip)) return ;
			
			switch (e.type) 
			{
				case "rollOver":
					e.target.gotoAndStop(2);
				break;
				case "rollOut":
					e.target.gotoAndStop(1);
				break;
				case "mouseUp":
					e.target.gotoAndStop(1);
				break;
				case "mouseDown":
					e.target.gotoAndStop(3);
				break;
			}
		}
		
		public function LimitShow(type:String):void 
		{
			//可替換效果
			switch (type) 
			{
				case "left":
					this._mcLeft.visible = false;
				break;
				case "right":
					this._mcRight.visible = false;
				break;
				case "normal":
					if(!this._mcLeft.visible) this._mcLeft.visible = true;
					if(!this._mcRight.visible) this._mcRight.visible = true;
				break;
			}
		}
		
		
		override public function Destroy():void 
		{
			super.Destroy();
			removeChild(this._mcLeft);
			removeChild(this._mcRight);
			removeChild(this._spShift);
			this.btnFactory(this._mcLeft, true);
			this.btnFactory(this._mcRight, true);
			this._mcLeft = null;
			this._mcRight = null;
			this.removeEventListener(MouseEvent.ROLL_OUT, teamEffect,true);
			this.removeEventListener(MouseEvent.ROLL_OVER, teamEffect,true);
		}
		
		public function get ShiftContainer():Sprite 
		{
			return this._spShift;
		}
		
	}
	
}