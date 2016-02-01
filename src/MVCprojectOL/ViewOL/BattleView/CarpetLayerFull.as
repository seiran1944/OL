package MVCprojectOL.ViewOL.BattleView
{
	import com.greensock.easing.Elastic;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import MVCprojectOL.ViewOL.BattleView.CarpetLayer;
	import strLib.proxyStr.ArchivesStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation Battle Background Control Use
	 */
	public class  CarpetLayerFull extends CarpetLayer
	{
		
		private var _btnLeave:Sprite;
		private var _currentBtn:Sprite;
		private var _glowFt:GlowFilter;
		private var _glowFtLock:GlowFilter;
		
		public function CarpetLayerFull():void
		{
			
		}
		
		override protected function buildDownWall(objSource:Object,iconZone:Sprite,pStage:Point):void
		{
			super.buildDownWall(objSource, iconZone, pStage);
			this.buildControlBtn(objSource,pStage);
		}
		
		//補足搭配按鈕區域的動態處理 (CLOSE)
		override public function BackGroundMoving(show:Boolean):void
		{
			this.showControlBtn(show);
			super.BackGroundMoving(show);
		}
		
		private function buildControlBtn(objSource:Object,pStage:Point):void
		{
			var downContainer:Sprite = getChildByName("bottomArea") as Sprite;
			var btnGroup:Sprite = new Sprite();
			btnGroup.name = "btnGroup";
			
			this._glowFt = new GlowFilter(0x1122FF);
			this._glowFtLock = new GlowFilter(0xFFFFFF,1,6,6,3);
			
			
			btnGroup.addEventListener(MouseEvent.MOUSE_OVER, rollBtnGroup);
			btnGroup.addEventListener(MouseEvent.MOUSE_OUT, rollBtnGroup);
			
			var btn:Sprite;
			var aryKey:Array = ["pause", "play", "faster", "leave"];
			var leng:int = aryKey.length;
			var thisKey:String;
			for (var i:int = 0; i < leng; i++)
			{
				thisKey = aryKey[i];
				btn = new objSource[thisKey]();
				if (thisKey == "play" ) this.ChooseButton(btn);
				btn.name = thisKey;
				btn.x = i * 40;
				btnGroup.addChild(btn);
				btn.buttonMode = true;	
			}
			this._btnLeave = btn;//Leave  按鈕
			this._btnLeave.mouseChildren = false;
			btnGroup.x = pStage.x;
			downContainer.addChild(btnGroup);
			
		}
		
		//按鈕群組效果處理(排除了被標記的按鈕處理)
		private function rollBtnGroup(e:MouseEvent):void 
		{
			//trace(e.target.name, e.currentTarget.name, "ROLLALLBTN",e.type);
			if (e.target == this._currentBtn) return;
			
			if (e.type == "mouseOver") {
				//if (e.target.filters.length == 0 ) 
				e.target.filters = [this._glowFt];
			}else {
				//trace(e.target.filters , e.target.filters[0] , e.target.filters[0] == this._glowFt , e.target.filters == this._glowFt,e.target.filters == [this._glowFt]);
				//if (e.target.filters.length > 0) if (e.target.filters[0].strength != 3)
				e.target.filters = [];
			}
			
		}
		//點選的按鈕濾鏡標記功能
		public function ChooseButton(btn:Object):void 
		{
			if (this._currentBtn != null) this._currentBtn.filters = [];
			this._currentBtn = btn as Sprite;
			this._currentBtn.filters = [this._glowFtLock];
		}
		
		//若為入場動作 播放完畢時導入 讓控制按鈕出現
		private function showControlBtn(show:Boolean):void
		{
			var btnGroup:Sprite = Sprite(getChildByName("bottomArea")).getChildByName("btnGroup") as Sprite;
			
			TweenLite.to(btnGroup, .5, { delay : show ? 2.7 : 0 , x : show ? btnGroup.x - 300 : btnGroup.x + 300 , ease : Elastic.easeOut } );
		}
		private function leaveShine(toShine:Boolean=true):void 
		{
			TweenLite.to(this._btnLeave, .5, { glowFilter : !toShine ? { color:0xFFFF22, alpha:1, blurX:0, blurY:0 } : { color:0xFFFF22, alpha:.5, blurX:20, blurY:20 } ,onComplete : this.leaveShine ,onCompleteParams : [!toShine]} );
		}
		public function DeLeaveShine():void 
		{
			TweenLite.killTweensOf(this._btnLeave);
			this._btnLeave.filters = [];
			this._btnLeave = null;
		}
		//閃爍離開按鈕
		public function ShineTheLeave(shine:Boolean):void
		{
			var btnGroup:Sprite = Sprite(getChildByName("bottomArea")).getChildByName("btnGroup") as Sprite;
			btnGroup.removeEventListener(MouseEvent.MOUSE_OVER, rollBtnGroup);
			btnGroup.removeEventListener(MouseEvent.MOUSE_OUT, rollBtnGroup);
			if (shine) this.leaveShine();
		}
		
		override public function Destroy():void 
		{
			super.Destroy();
			this._btnLeave = null;
			this._currentBtn = null;
			this._glowFt = null;
			this._glowFtLock = null;
		}
		
		
	}
	
}