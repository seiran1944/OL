package MVCprojectOL.ViewOL.BattleView
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.CombatMonsterDisplayProxy;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleFighter;
	import Spark.SoarParticle.basic.IEffect;
	import Spark.SoarParticle.ParticleCenter;
	import Spark.Timers.TimeDriver;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 惡魔放置區塊
	 */
	public class FighterArea extends BattleSpace
	{
		private var _dicShadow:Dictionary;//殘影庫存處
		private var _rightSide:Boolean;
		public const _gapWid:int = 50;//左右減少間距值
		public const _gapHei:int = 60;//上下減少間距值
		public const _picSize:int = 150;//圖檔寬高值
		private var _pCenter:Point;//戰場中央點
		private const _shadowGapX:int = 50;//殘影與本體的距離
		private const _moveSpeed:Number = .5;//基礎移動速度
		private var _millisecondPeriod:uint;
		
		public function FighterArea():void
		{
			this._dicShadow = new Dictionary(true);
			
		}
		
		public function set Period(millisecond:uint):void 
		{
			this._millisecondPeriod = millisecond;
		}
		
		public function set IsRightSide(value:Boolean):void
		{
			this._rightSide = value;
		}
		
		//佈置戰鬥單位
		public function SetFighters(info:Object,source:CombatMonsterDisplayProxy):void
		{
			this._pCenter = ProjectOLFacade.GetFacadeOL().GetStageInfo();
			this._pCenter.x = this._pCenter.x >> 1;
			this._pCenter.y = this._pCenter.y >> 1;
			this._pCenter = this.globalToLocal(this._pCenter);
			//trace("newPOINT",this._pCenter, ProjectOLFacade.GetFacadeOL().GetStageInfo(),this.x,this.y);
			
			var fighter:BattleFighter;
			for (var name:String in info)
			{
				fighter = info[name];
				var body:Sprite = source.GetMonsterDisplay(fighter._guid).MonsterBody;
				addChild(body);//翻轉動作在CombatMonsterDisplayProxy內做掉了
				body.name = name + String(!this._rightSide);
				var locate:Point = this.GetMonsterLocate(int(name));
				
				//trace("檢測布置FIGHTER的縮放值為>>>", fighter._scaleRate,body.width,body.height);
				
				//縮小怪物
				if (fighter._scaleRate != 1) {//
					body.scaleX = fighter._scaleRate;
					body.scaleY = fighter._scaleRate;
				}
				
				//置中對齊模式
				body.x = locate.x - body.width / 2;
				body.y = locate.y - body.height / 2;
				
				
			}
			
			
			//this.graphics.beginFill(0x00FF00, .2);
			//this.graphics.drawRect(0, 0, this.width, this.height);
			//this.graphics.endFill();
			
			this.resetMonsterLayer();
		}
		
		public function MonsterDeadShow(combineKey:String):void 
		{
			//原為*4 調整為*3
			TimeDriver.AddDrive(this._millisecondPeriod *3, 1,//需注意延遲時間避免加速後的錯誤情況,應該是回收掉了抓不到相對function位置******************************************************
				function DustToDustAshToAsh():void
				{
					TimeDriver.RemoveDrive(DustToDustAshToAsh);
					
					var monsterBody:DisplayObject = getChildByName(combineKey);
					if (monsterBody != null) {
						var monsterPic:BitmapData = new BitmapData(monsterBody.width, monsterBody.height, true, 0);
						monsterPic.draw(monsterBody,new Matrix(monsterBody.scaleX,0,0,monsterBody.scaleY));//加入MATRIX對應縮小圖的狀況
						var smashParticle:IEffect = ParticleCenter.GetInstance().GetParticleByKey("0002", monsterPic);
						//ParticleCenter.GetInstance().RegisterParticle(smashParticle, smashParticleFin);//可忽略最後關閉也是會移除
						removeChild(monsterBody);
						addChild(smashParticle as DisplayObject);
						smashParticle.x = monsterBody.x;
						smashParticle.y = monsterBody.y;
						smashParticle.Start();
					}
				}
				
			);
			
		}
		//移除怪物粉碎效果物件
		//private function smashParticleFin(target:DisplayObject):void
		//{
			//removeChild(target);
		//}	
		
		private function shadowFactory(place:int,monsterBody:DisplayObject):Bitmap 
		{
			var bmBody:Bitmap;
			if (place in this._dicShadow) {
				bmBody = this._dicShadow[place];
			}else {
				var bmdShadow:BitmapData = new BitmapData(monsterBody.width, monsterBody.height, true, 0);
				//trace("殘影SIZE測試>>>", monsterBody.width, monsterBody.height,monsterBody.scaleX,monsterBody.scaleY);
				var mx:Matrix = new Matrix(monsterBody.scaleX, 0, 0, monsterBody.scaleY, 0, 0);//殘影大小依照怪物縮放比例來處理
				var colorTf:ColorTransform = new ColorTransform(1, 1, 1, .25);
				bmdShadow.draw(monsterBody, mx, colorTf, null);
				mx.tx = !this._rightSide ? 20 : -20;
				bmdShadow.draw(monsterBody, mx, colorTf, null);
				mx.tx = !this._rightSide ? 40 : -40;
				bmdShadow.draw(monsterBody, mx, colorTf, null);
				bmBody = new Bitmap(bmdShadow);
				this._dicShadow[place] = bmBody;
			}
			
			return bmBody;
		}
		
		public function MonsterMoving(place:int):void 
		{
			var monsterBody:DisplayObject = getChildByName(String(place) + String(!this._rightSide));
			if (monsterBody == null) return;//怪物沒準備好時 ( 應當不會有此狀況了)
			
			//避免連續操作移動造成位置錯亂 20130617
			if (TweenMax.isTweening(monsterBody)) {
				TweenLite.killTweensOf(monsterBody, true);
				var shadow:DisplayObject = getChildByName("shadow" + String(place) + String(!this._rightSide));
				TweenLite.killTweensOf(shadow,true);
			}
			//
			
			var bmBody:Bitmap = this.shadowFactory(place,monsterBody);
			bmBody.name = "shadow" + String(place) + String(!this._rightSide);//20130617
			addChild(bmBody);
			bmBody.x = monsterBody.x + (!this._rightSide ? -this._shadowGapX : this._shadowGapX);
			bmBody.y = monsterBody.y;
			
			TweenLite.to(monsterBody,this._moveSpeed, { x:this._pCenter.x- (monsterBody.width>>1), y:this._pCenter.y - (monsterBody.height>>1), onComplete:this.movingDoneNotify , onCompleteParams:[true, monsterBody, monsterBody.x, monsterBody.y,this._rightSide] } );
			TweenLite.to(bmBody, this._moveSpeed, { x:this._pCenter.x - (bmBody.width >> 1) + (!this._rightSide ? -this._shadowGapX : this._shadowGapX), y:this._pCenter.y - (bmBody.height >> 1), onComplete:this.movingDoneNotify , onCompleteParams:[false, bmBody, monsterBody.x, monsterBody.y,this._rightSide] } );
		}
		//動回原位的處理
		private function movingDoneNotify(isAim:Boolean,target:DisplayObject,homeX:int,homeY:int,rightSide:Boolean):void
		{
			if (!isAim) removeChild(target);
			//在移動後定點停留的時間可調整*****
			TimeDriver.AddDrive(int(this._millisecondPeriod * 1.6), 1, readyToBack, [isAim, target, homeX, homeY, rightSide]);
			function readyToBack(isAim:Boolean,target:DisplayObject,homeX:int,homeY:int,rightSide:Boolean):void //tween back
			{
				//trace(TimeDriver.CheckRegister(readyToBack));
				TimeDriver.RemoveDrive(readyToBack);
				//trace(TimeDriver.CheckRegister(readyToBack));
				var shiftX:int = !rightSide ? +target.width : -target.width;
				target.scaleX *= -1;
				if (!isAim) {//為殘影
					addChild(target);
					target.x = !rightSide ? _pCenter.x - (target.width>>1) + _shadowGapX : _pCenter.x -(target.width>>1) + target.width - _shadowGapX;
					target.y = _pCenter.y - (target.height >> 1);
					shiftX += !rightSide ? _shadowGapX :  2 * target.width -_shadowGapX;
				}else {
					if (rightSide) {
						target.x += target.width;
						shiftX += 2 * target.width;
					}
				}
				TweenLite.to(target, _moveSpeed, { x:homeX + shiftX, y:homeY, onComplete:movingDoneTurnBack, onCompleteParams:[isAim,target,homeX,homeY] } );
			}
		}
		//移動回定點的處理
		private function movingDoneTurnBack(isAim:Boolean,target:DisplayObject,homeX:int,homeY:int):void
		{
			target.scaleX *= -1;
			if (isAim) {
				target.x = homeX;
				target.y = homeY;
				
			}else {
				removeChild(target);
			}
		}
		
		//	6		3		0
		//	7		4		1
		//	8		5		2
		private function resetMonsterLayer():void 
		{
			var monster:DisplayObject;
			var count:int;
			var aryPosition:Array = [6, 3, 0, 7, 4, 1, 8, 5, 2];//可調整低至高LAYER
			for (var i:int = 0; i < 9; i++)
			{
				monster = this.getChildByName(String(aryPosition[i]) + String(!this._rightSide));
				
				if (monster != null) {
					this.setChildIndex(monster, i - count);
					//trace("oh the mon", aryPosition[i] , !this._rightSide,i-count);
				}else {
					count++;
				}
			}
		}
		
		public function ShowAllLocate():void 
		{
			for (var name:String in this._dicLocate) 
			{
				trace("位置<" + name + "> = " + this._dicLocate[name]);
			}
		}
		
		// 6		3		0 // 0		3		6
		// 7		4		1 // 1		4		7
		// 8		5		2 // 2		5		8
		//調用擺放位置
		public function GetMonsterLocate(place:int):Point
		{
			var locate:Point = new Point();
			var xShift:int = !this._rightSide ? 2 - int(place / 3 ) : int(place / 3 );
			locate.x =  xShift * (this._picSize-this._gapWid);
			locate.y = (place % 3 ) * (this._picSize - this._gapHei);
			this.CreateGlobalList(place, locate);
			return locate;
		}
		
		//製作有用到的絕對位置查找表
		public function CreateGlobalList(place:int,locate:Point):void
		{
			//我方位置都放置於左邊 對應isOurSide的値做對應 其他對照表會用 place + isOurSide來做查找 故左邊的話用 !this._rightSide
			this._dicLocate[String(place) + String(!this._rightSide)] = this.localToGlobal(locate);
			//trace("轉換全域座標位置",place,!this._rightSide,this.localToGlobal(locate));
		}
		
		
		override public function Destroy():void 
		{
			super.Destroy();
			for each (var item:Bitmap in this._dicShadow) 
			{
				item.bitmapData.dispose();
				item.bitmapData = null;
			}
			this._dicShadow = null;
			while (this.numChildren>0) 
			{
				this.removeChildAt(0);
			}
		}
		
		
	}
	
}