package MVCprojectOL.ViewOL.MallBtn 
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import Spark.coreFrameWork.observer.Notify;
	import strLib.commandStr.UICmdStrLib;
	/**
	 * ...
	 * @author brook
	 */
	public class MallBtn extends Notify
	{
		private var _DiamondBtn:Sprite;
		private var _MonsterGuid:String;
		private var _Hp:int;
		private var _Eng:int;
		public function AddMallBtn(_DiamondBtn:Sprite, _MonsterGuid:String = "", _Hp:int = 0, _Eng:int = 0):void
		{
			this._DiamondBtn = _DiamondBtn;
			this._DiamondBtn.buttonMode = true;
			
			this._MonsterGuid = _MonsterGuid;
			this._Hp = _Hp;
			this._Eng = _Eng;
			
			this.MouseEffect(this._DiamondBtn);
		}
		
		//滑鼠滑入滑出效果
		private function MouseEffect(btn:*):void
		{
			btn.addEventListener(MouseEvent.ROLL_OVER, BtnEffect);
			btn.addEventListener(MouseEvent.ROLL_OUT, BtnEffect);
			btn.addEventListener(MouseEvent.CLICK, BtnEffect);
		}
		private function BtnEffect(e:MouseEvent):void 
		{
			switch (e.type) 
			{
				case "click":
					var _Diamond:Object = new Object();
						_Diamond["Name"] = e.target.name;
						_Diamond["Guid"] = this._MonsterGuid;
						_Diamond["Hp"] = this._Hp;
						_Diamond["Eng"] = this._Eng;
					this.SendNotify(UICmdStrLib.ShopMaill, _Diamond);
				break;
				case "rollOver":
					TweenLite.to(e.target, 0, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }} );
				break;
				case "rollOut":
					TweenLite.to(e.target, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
				break;
			}
		}
		//移除滑入滑出效果
		private function RemoveMouseEffect(btn:*):void
		{
			btn.removeEventListener(MouseEvent.ROLL_OVER, BtnEffect);
			btn.removeEventListener(MouseEvent.ROLL_OUT, BtnEffect);
			btn.removeEventListener(MouseEvent.CLICK, BtnEffect);
		}
		
	}
}