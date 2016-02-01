package MVCprojectOL.ViewOL.SharedMethods 
{
	import caurina.transitions.Tweener;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import Spark.coreFrameWork.observer.Notify;
	import strLib.commandStr.ExploreAdventureStrLib;
	/**
	 * ...
	 * @author brook
	 * 13.06.17.16.30
	 */
	public class ParabolaMove extends Notify
	{
		private var _CtrlNum:int = 0;
		private var _Chestlength:int;
		public function ParabolaMove()
		{
			TweenPlugin.activate([GlowFilterPlugin]);
		}	
		public function AddElement(_Icon:Sprite, _SourceType:int, _Chestlength:int):void
		{
			this._Chestlength = _Chestlength;
			this.Brilliant(_Icon, false);
			this.dropJumper(_Icon);
			_Icon.buttonMode = true;
			_Icon.name = "Icon" + _SourceType;
			_Icon.addEventListener(MouseEvent.ROLL_OVER, IconHandler);
		}
		private function dropJumper(aim:Sprite):void
		{
			//可調整範圍
			var ranX:Number=Math.random()*80+40;
			var ranY:Number=Math.random()*80+10;
			var ranH:Number=Math.random()*80+20;

			//左右掉落隨機1/2
			var direct:Number=Math.random()*10;
			ranX=direct<5 ? -ranX : ranX
			
			Tweener.addTween(aim,{
					x:aim.x+ranX,
					time:0.75,
					transition:"linear"
					
									 })
			Tweener.addTween(aim,{
					y:aim.y-ranH,
					time:0.25,
					transition:"easeOutQuad"
					
									 })
			Tweener.addTween(aim,{
					y:aim.y+ranY,
					delay:0.25,
					time:0.5,
					transition:"easeOutBounce"
					
									 })
		}
		
		private function Brilliant(_Icon:Sprite, _CtrlBoolean:Boolean):void
		{
			(_CtrlBoolean == false)?TweenLite.to(_Icon, 1, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }, onComplete:this.Brilliant , onCompleteParams : [_Icon, true]} ):TweenLite.to(_Icon, 1, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }, onComplete:this.Brilliant , onCompleteParams : [_Icon, false]} );
		}
		
		private function IconHandler(e:MouseEvent):void
		{
			if (e.target.name == "Icon-1") TweenLite.to(e.target, 0.7, { alpha:0, onComplete:this.RemoveIcon} );
			if (e.target.name == "Icon0") TweenLite.to(e.target, 1, { x:100, y:40, alpha:0, onComplete:this.RemoveIcon() } );
			if (e.target.name == "Icon1") TweenLite.to(e.target, 1, { x:270, y:40, alpha:0, onComplete:this.RemoveIcon() } );
			if (e.target.name == "Icon2") TweenLite.to(e.target, 1, { x:440, y:40, alpha:0, onComplete:this.RemoveIcon() } );
			if (e.target.name == "Icon3") TweenLite.to(e.target, 1, { x:610, y:40, alpha:0, onComplete:this.RemoveIcon() } );
			if (e.target.name == "Icon9") TweenLite.to(e.target, 1, { x:250, y:330, alpha:0, onComplete:this.RemoveIcon() } );
		}
			
		private function RemoveIcon():void
		{
			this._CtrlNum++;
			if (this._CtrlNum == this._Chestlength) this.SendNotify(ExploreAdventureStrLib.ShowIndex);
		}
		
	}
}