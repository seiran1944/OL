package MVCprojectOL.ViewOL.BattleView
{
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Quart;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleBasic;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleEffect;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import Spark.SoarVision.single.BitmapVision;
	import Spark.SoarVision.VisionCenter;
	import strLib.proxyStr.ArchivesStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 扣血量圖示與MISS圖示處理
	 */
	public class BloodZone extends BattleSpace 
	{
		
		private var _funHub:Function;
		private var _dicNumPic:Dictionary;
		private var _allMissCondition:Boolean = false;
		private var _countMiss:int;
		
		public function BloodZone():void 
		{
			this._dicNumPic = new Dictionary(true);
		}
		
		public function set NotifyPlaceHub(hubWay:Function):void
		{
			this._funHub = hubWay;
		}
		
		private function toHub(status:String,info:Object=null,sendOut:Boolean=false):void 
		{
			this._funHub(status, info, sendOut);
		}
		
		//素材加入與佈置
		override public function InSource(objSource:Object):void
		{
			var basicMath:BitmapData;
			var aryKeyMath:Array = ["basicMath", "bloodMath", "cureMath"];
			var aryListKey:Array = ["Y", "R", "G"];
			for (var i:int = 0; i < 3; i++) 
			{
				basicMath = new objSource[aryKeyMath[i]]();
				this.catchNumberPic(basicMath,aryListKey[i]);
			}
			
			//130510 MISS字樣處理
			this._dicNumPic["miss"] = new objSource["word_miss"]();
		}
		
		//先做三組關鍵字對應 可能會用到三種顏色 補血時綠色(G) 扣血時紅色(R) 回合字銘黃(Y)
		private function catchNumberPic(bmdSource:BitmapData,listKey:String):void
		{
			const picWid:int = 64;
			const picHei:int = 64;
			const amountWid:int = 4;//列上單位數量
			const amountPic:int = 12;//總數
			var bmdNum:BitmapData;
			var rectPlace:Rectangle;
			var pZero:Point = new Point();
			
			if (listKey == "Y") {
				var colorTf:ColorTransform = new ColorTransform(0, 0, 0, 1,0xff,0xbd,0x28);//轉變數字顏色
				var rectColor:Rectangle = new Rectangle(0, 0, 64, 64);
			}
			
            for (var i:uint = 0; i < amountPic ; i++ )
			{
					bmdNum = new BitmapData ( picWid , picHei, true , 0 );
                    rectPlace = new Rectangle ( picWid * (i % amountWid) , picHei * int(i / amountWid) , picWid , picHei );
                    bmdNum.copyPixels ( bmdSource , rectPlace, pZero );
					if(listKey=="Y") bmdNum.colorTransform(rectColor, colorTf);
					switch (i) 
					{
						case 10:
							this._dicNumPic[listKey + "+"] = bmdNum;
						break;
						case 11:
							this._dicNumPic[listKey + "-"] = bmdNum;
						break;
						default:
							this._dicNumPic[listKey + i] = bmdNum;
						break;
					}
            }
			// <10 number ; 11>>正號 ; 12>>負號
			
		}
		
		
		public function GetBloodImage(bloodAmount:int,needPlus:Boolean=true):Bitmap
		{
			const betweenValue:int = 13;//左右兩端各切掉此値寬度
			var bloodWord:String = bloodAmount > 0 && needPlus ? "+" + bloodAmount : String(bloodAmount);
			var picType:String = needPlus ? bloodAmount > 0 ? "G" : "R" : "Y";//字色種類
			var leng:int = bloodWord.length;
			var bmd:BitmapData = new BitmapData(leng * 64 - (leng) * 2 * betweenValue, 64, true, 0);
			var bmBlood:Bitmap = new Bitmap(bmd,"auto",true);
			var rect:Rectangle = new Rectangle(betweenValue, 0, 64 - 2 * betweenValue, 64);
			var pDest:Point = new Point();
			var cutStr:String;
			for (var i:int = 0; i < leng; i++) 
			{
				cutStr = bloodWord.substr(i, 1);
				pDest.x = i * (64 - 2 * betweenValue);
				bmd.copyPixels(this._dicNumPic[picType + cutStr], rect, pDest);
			}
			
			return bmBlood;
		}
		
		//130510新增 MISS圖樣取得
		public function GetMissImage():Bitmap 
		{
			return new Bitmap(this._dicNumPic["miss"],"auto",true);
		}
		
		//受攻擊的傷害量呈現(BATTLEIMAGING_VIEW_SHOWEFFECT) 受到的 "技能攻擊" && "附加效果" 傷害都會進來(BattleBasic)
		public function SpoutBlood(info:Object):void
		{
			var combineKey:String = String(info["_place"]) + String(info["_isOurSide"]);
			var btBasic:BattleBasic = info["_valueBag"];
			
			//if (btBasic._hp != 0) this.bloodSpread(this.MonsterLocate(combineKey), this.GetBloodImage(btBasic._hp));
			this.bloodSpread(this.MonsterLocate(combineKey), this.GetBloodImage(btBasic._hp));//130510 調整成血量0也會顯示
		}
		
		//攻擊無命中的單位顯示MISS圖示//{ _aryMiss : [BattleEffect]  , _allMiss : Boolean }
		public function SpoutMiss(info:Object):void 
		{
			
			var leng:int = info["_aryMiss"].length;
			
			this._allMissCondition = info["_allMiss"];
			if (this._allMissCondition) this._countMiss = leng;
			
			var btEffect:BattleEffect;
			var combineKey:String;
			for (var i:int = 0; i < leng; i++)
			{
				btEffect = info["_aryMiss"][i];
				combineKey = String(btEffect._place)+ String([btEffect._ourSide]);
				//this.bloodSpread(this.MonsterLocate(combineKey), this.GetBloodImage(0));//要補充一個MISS的圖示檔案演示**********************************************************************
				this.bloodSpread(this.MonsterLocate(combineKey), this.GetMissImage());//130510 改成MISS圖示
			}
			
		}
		
		private function bloodSpread(place:Point,blood:Bitmap):void
		{
			addChild(blood);
			blood.x = place.x -blood.width / 2 +5;// +(blood.width < 40 ? 65 : 0);//數字零圖示的特例處理
			blood.y = place.y -blood.height / 2;
			blood.alpha = .2;
			blood.scaleX = .5;
			blood.scaleY = .5;
			TweenLite.to(blood, .7, {delay : Math.random()*.4 , alpha : 1, scaleX : 1 , scaleY : 1 , x : blood.x - (blood.width >>2) , y : blood.y - (blood.height >> 1 )- 80,ease : Elastic.easeOut, onComplete : this.bloodFin , onCompleteParams : [blood] } );
			
		}
		//噴血完畢後的動作
		private function bloodFin(blood:Bitmap):void
		{
			removeChild(blood);
			if (this._allMissCondition) {
				this._countMiss--;
				if (this._countMiss == 0) {
					this._allMissCondition = false;
					this.toHub(ArchivesStr.BATTLEIMAGING_VIEW_STEPSFIN, false);//發送false為此次並非回合round的資料 而是steps的處理過程
				}
			}
		}
		
		
		override public function Destroy():void 
		{
			super.Destroy();
			this._dicNumPic = null;
			while (this.numChildren>0) 
			{
				this.removeChildAt(0);
			}
		}
		
		
	}
	
}