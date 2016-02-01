package MVCprojectOL.ViewOL.BattleView
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Quart;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import strLib.proxyStr.ArchivesStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.03.14.10.36
		@documentation 背景層區塊配置
	 */
	public class  CarpetLayer extends Sprite
	{
		
		protected var _funHub:Function;//溝通外部位置
		protected var _bmRound:Bitmap;//當前回合數圖檔或其他需顯示在中央面板的圖示
		protected var _shMask:Shape;//遮罩64*50  
		protected var _shMask2:Shape;//遮罩64*50
		protected var _boardCenterX:Number;//回合面板的X中心
		protected var _maskWid:int = 64;//遮罩寬
		protected var _maskHei:int = 50;//遮罩高
		
		public function CarpetLayer():void 
		{
			
		}
		
		//導入與外部溝通的function 需要有兩個屬性 function xxx( status : String  ,  info  :  Object  ):void
		public function set NotifyPlaceHub(hubWay:Function):void
		{
			this._funHub = hubWay;
		}
		
		//內部呼叫外部的訊息通知
		protected function toHub(status:String, info:Object = null ):void 
		{
			this._funHub(status, info);
		}
		
		//變更背景圖示
		public function ChangeBackground(background:BitmapData):void 
		{
			var bmBg:Bitmap = getChildByName("backGround") as Bitmap;
			if (bmBg != null) bmBg.bitmapData = background;
		}
		
		//導入的object型態素材檔與額外的下方城牆容器位置(不採用AllInOnePanel後的調整)
		//繼承使用時第二參數不需導入(下方城牆的區塊)
		//**若需要下方底板上面的布置元件可導入自定義繼承Sprite的CLASS,會壓在下方的底板層上但objSource需要夾帶一個bottomWall的屬性(BitmapData)作為底板顯示
		public function UseTheCarpet(objSource:Object,iconZone:Sprite=null):void 
		{
			var carpet:BitmapData = objSource.background == undefined ? new objSource["bg1"]() : objSource.background;
			var map:Bitmap = new Bitmap(carpet);
			map.name = "backGround";
			addChild(map);
			
			var pStage:Point = ProjectOLFacade.GetFacadeOL().GetStageInfo();
			
			var leftTriangle:Sprite=new objSource["triangleArea"]();
			var rightTriangle:Sprite = new objSource["triangleArea"]();
			leftTriangle.name = "leftTri";
			rightTriangle.name = "rightTri";
			rightTriangle.scaleX *= -1;
			addChild(leftTriangle);
			addChild(rightTriangle);
			rightTriangle.x = pStage.x;
			
			var roundBoard:Sprite = new objSource["roundBoard"]();
			roundBoard.name = "roundBoard";
			roundBoard.x = (pStage.x >> 1) - (roundBoard.width >> 1);
			roundBoard.y = -roundBoard.height;
			addChild(roundBoard);
			//trace("回合樹面版寬", roundBoard.width, roundBoard.width / 2);
			this._boardCenterX = roundBoard.width / 2;
			//roundMask
			this._shMask = new Shape();
			this.makeMask(this._shMask);
			this._shMask.y = 100;
			roundBoard.addChild(this._shMask);
			this._shMask2 = new Shape();
			this.makeMask(this._shMask2);
			this._shMask2.y = 85;//傳入的回合數BITMAP會參照mask2的座標位置配置(Notice****)
			roundBoard.addChild(this._shMask2);
			//構築下方城牆區域版
			if (iconZone != null) this.buildDownWall(objSource, iconZone,pStage);
			this.alpha = 0;
			
			//直接壓上場景較為突兀
			//this.BackGroundMoving(true);
			
			//改變入場時的透明化效果做銜接處理
			TweenLite.to(this, 1, { alpha : 1 , onComplete : this.BackGroundMoving , onCompleteParams : [true] } );
			
		}
		
		//由 UseTheCarpet 導入(iconZone!=null) , 構築下方城牆區域版 若需要下方面板可以在objSource夾帶一個bottomWall的屬性(BitmapData)
		protected function buildDownWall(objSource:Object,iconZone:Sprite,pStage:Point):void
		{
			var downContainer:Sprite = new Sprite();
			var shitWall:Bitmap = new Bitmap(objSource.bottomWall is Class ? new objSource["bottomWall"]() : objSource.bottomWall);
			shitWall.name = "shitWall";
			downContainer.name = "bottomArea";
			downContainer.addChild(shitWall);
			downContainer.addChild(iconZone);//導入訊息顯示區塊進下方城牆層
			addChild(downContainer);
			downContainer.y = pStage.y + shitWall.height;
		}
		
		//中央版回合數字遮罩
		protected function makeMask(shTarget:Shape):void
		{
			shTarget.graphics.beginFill(0xFF0000,0);
			shTarget.graphics.drawRect(0, 0, this._maskWid, this._maskHei);
			shTarget.graphics.endFill();
			shTarget.x = this._boardCenterX - this._maskWid / 2;
		}
		
		//外部主要操作方法控制啟始(true)與結束(false)
		public function BackGroundMoving(show:Boolean):void
		{
			this.triangleShow("leftTri", show);
			this.triangleShow("rightTri", show);
		}
		private function triangleShow(name:String,show:Boolean):void 
		{
			var triAngle:Sprite = getChildByName(name) as Sprite;
			var angle:int = show ? 10 : -10;//左骷髏旋轉角度
			TweenLite.to(triAngle.getChildByName("gear"), .5, { rotation : name == "leftTri" ? angle : angle , ease:Back.easeIn, onComplete : this.driveOtherRunning , onCompleteParams :[name,show] } );
		}
		
		private function driveOtherRunning(name:String,show:Boolean):void
		{
			var triAngle:Sprite = getChildByName(name) as Sprite;
			var insideSoul:DisplayObject;
			var angle:int = show ? -360 : 360;//左骷髏旋轉角度
			var range:Number = show ? Math.PI / 4 : Math.PI / 4 * 5 ;
			const leng:int = 100;
			
			insideSoul = triAngle.getChildByName("gear");
			TweenLite.to(insideSoul, 1.7, { rotation : name == "leftTri" ? angle : angle ,ease:Quart.easeOut})//, ease:Elastic.easeIn } );
			
			insideSoul = triAngle.getChildByName("chain");
			TweenLite.to(insideSoul, 2, { x: insideSoul.x + leng * Math.cos(range), y: insideSoul.y - leng * Math.sin(range) , ease:Quart.easeOut } );//, ease:Elastic.easeIn
			
			var pStage:Point = ProjectOLFacade.GetFacadeOL().GetStageInfo();
			
			insideSoul = getChildByName("bottomArea");//底板區塊的動態
			if(insideSoul!=null) TweenLite.to(insideSoul, 1.2, { y : show ? pStage.y - insideSoul.height : pStage.y + insideSoul.height, ease:show ? Bounce.easeOut : Quart.easeOut } );
			
			insideSoul = getChildByName("roundBoard");
			TweenLite.to(insideSoul, 2, { y : show ? -insideSoul.height/3 : -insideSoul.height, ease:show ? Elastic.easeOut : Quart.easeOut ,onComplete : this.showRunComplete , onCompleteParams : [!show]} );
			
		}
		//完成關閉的播放時發送的通知
		private function showRunComplete(isEnd:Boolean):void
		{
			if (isEnd) this.movingDoneProcess();
		}
		
		//(Override) 須要寫入動態完成時的操作動作
		protected function movingDoneProcess():void 
		{
			this.toHub(ArchivesStr.BATTLEIMAGING_VIEW_DESTROY);//Battle自用
		}
		
		
		//外部主要操作,變更回合數字圖示(導入數字圖檔)
		public function RoundChangeTo(newRound:Bitmap):void 
		{
			var roundBoard:Sprite = getChildByName("roundBoard") as Sprite;
			//trace(newRound.width,"rOUndSize");
			newRound.x = this._boardCenterX - newRound.width / 2;//this._shMask2.x;//調整為置中處理
			newRound.y = this._shMask2.y + newRound.height;
			roundBoard.addChild(newRound);
			
			//trace("ROUND CHANGE>>>>", newRound.width, newRound.height,newRound.x,newRound.y, this._shMask.width, this._shMask.height,this._shMask.x,this._shMask.y);
			
			if (this._bmRound != null) this.outOfRound(this._bmRound, true);
			this._bmRound = newRound;
			this.outOfRound(newRound, false);
			
		}
		private function outOfRound(roundTarget:Bitmap,clean:Boolean):void
		{
			roundTarget.mask = clean ? this._shMask : this._shMask2;
			
			TweenLite.to(roundTarget, 1, { y : roundTarget.y - roundTarget.height , onComplete : this.roundMovingFin , onCompleteParams : [roundTarget , clean] } );
		}
		private function roundMovingFin(roundTarget:Bitmap,clean:Boolean):void
		{
			if (clean) roundTarget.parent.removeChild(roundTarget);
		}
		
		
		//(Override) 回收整物件時呼叫註銷 可擴增
		public function Destroy():void 
		{
			this._funHub = null;
			this._bmRound = null;
			this._shMask = null;
			this._shMask2 = null;
			while (this.numChildren>0) 
			{
				this.removeChildAt(0);
			}
			
		}
		
		
		
	}
	
}