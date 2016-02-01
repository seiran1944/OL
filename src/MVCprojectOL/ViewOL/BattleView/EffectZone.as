package MVCprojectOL.ViewOL.BattleView
{
	import com.greensock.easing.Elastic;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import MVCprojectOL.ModelOL.SkillDisplayModel.CombatSkillDisplay;
	import MVCprojectOL.ModelOL.SkillDisplayModel.CombatSkillDisplayProxy;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleEffect;
	import Spark.MVCs.Models.SourceTools.Loader.LoadingBar;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import Spark.SoarVision.single.BitmapVision;
	import Spark.SoarVision.VisionCenter;
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	import strLib.proxyStr.ArchivesStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.04.16.17.26
		@documentation 技能演示區塊&&其他動態演示區塊
	 */
	public class EffectZone extends BattleSpace
	{
		
		private var _funHub:Function;
		private var _pStageSize:Point;
		private var _objSource:Object;
		private var _proxySkill:CombatSkillDisplayProxy;
		
		public function EffectZone():void
		{
			this._pStageSize = ProjectOLFacade.GetFacadeOL().GetStageInfo();
		}
		
		
		public function set NotifyPlaceHub(hubWay:Function):void
		{
			this._funHub = hubWay;
		}
		
		//素材加入與佈置
		override public function InSource(objSource:Object):void
		{
			this._objSource = objSource;
		}
		
		//播放效果素材
		public function InSkill(skillProxy:Object):void
		{
			this._proxySkill = skillProxy as CombatSkillDisplayProxy;
			
			
		}
		
		//戰鬥起始的效果之類播放處理
		public function ShowLoading():void
		{
			var load:LoadingBar = new _objSource["loading"]();
			load.name = "ZoneLoad";
			addChild(load);
			var locate:Point = this.getShowPlace("mid");
			load.x = locate.x - (load.width >> 1);
			load.y = locate.y - (load.height >> 1);
			
			//var aryRunerPic:Array = SourceProxy.GetInstance().GetMovieClipHandler(new runer());
			//var loadRuner:BitmapVision = new BitmapVision("runer");
			//VisionCenter.GetInstance().AddSinglePlay(loadRuner, aryRunerPic, true, false, false, 166);
			//addChild(loadRuner);
			//loadRuner.x = load.x;
			//loadRuner.y = load.y;
			
		}
		
		public function RemoveLoading():void 
		{
			var load:LoadingBar = getChildByName("ZoneLoad") as LoadingBar;
			if (load != null) {
				load.stop();
				removeChild(load);
			}
		}
		
		//同時移除掉LOADING的顯示
		public function ShowBanner(type:int):void
		{
			var useKey:String;
			switch (type) 
			{
				case 0:
					useKey = "word_fight";
				break;
				case 1:
					useKey = "word_win";
				break;
				case 2:
					useKey = "word_lose";
				break;
			}
			var showOP:Bitmap = new Bitmap(new this._objSource[useKey]());
			showOP.name = "showBanner";
			addChild(showOP);
			var pCenter:Point = this.getShowPlace("mid");
			var basicW:int = showOP.width >> 2;
			var basicH:int = showOP.height >> 1;
			showOP.x = pCenter.x - basicW;
			showOP.y = pCenter.y - basicH;
			showOP.scaleX = .5;
			showOP.scaleY = .5;
			showOP.alpha = 0;
			
			TweenLite.to(showOP, 2, { delay : 2 , x : pCenter.x - (showOP.width >>1)-basicW, y : pCenter.y - (showOP.height >>1) - basicH, alpha : 1 , scaleX : 1 , scaleY : 1 , onComplete : this.showDone , onCompleteParams : [showOP,type] , ease : Elastic.easeOut} );
			
			//setTimeout(this.showDone, 1000, null);//代替開場動態播出的時間處理 ,有動態時要調整**************************************
		}
		
		private function showDone(showOP:Bitmap,type:int):void
		{
			if (type == 0) {//start
				showOP.bitmapData.dispose();
				showOP.bitmapData = null;
				removeChild(showOP);
				this.toHub(ArchivesStr.BATTLEIMAGING_VIEW_FIGHT);
			}else {//end
				//畫面會停留故無影響,若要移除之類動作再新增
			}
		}
		
		
		private function getShowPlace(type:String, place:int = 0 ):Point 
		{
			var pLocate:Point;
			
			switch (type) 
			{
				case "mid":
					pLocate = new Point();	
					pLocate.x = this._pStageSize.x >> 1;
					pLocate.y = this._pStageSize.y >> 1;
				break;
				default ://目前左方區塊為自己方(isOurSide > true) , 右方區塊為敵方(isOurSide > false)
					pLocate = this.MonsterLocate(String(place) + type);
				break;
			}
			return pLocate;
		}
		
		
		//場景加入效果顯示(顯示完會自動移除)若需移動要追加外掛
		public function AddShowEffect(effectInfo:Object):void
		{
			//Object夾帶內容 >> _effect:String,_palce:int,_isOurSide:Boolean,_funFin:Function,_valueBag:Object(BattleBasic)  ,_scaleAdjust : 校正減少值
			//抓EFFECT的key播放
			
			//_funFin要給技能播放時START導入通知播放完成時機使用,或是查找後無效果動態播放則回call
			var csDisplay:CombatSkillDisplay = this._proxySkill.GetCombatSkillDisplayClone(effectInfo["_effect"]);
			//Size可能為 150 / 225
			var  effectWid:Number = 150;//技能效果原始SIZE
			var  effectHei:Number = 225;//技能效果原始SIZE
			addChild(csDisplay.Body);
			csDisplay.Motion.Act(effectInfo["_funFin"]);
			//if (effectInfo["_isOurSide"]) csDisplay.Motion.Direction = true;
			
			var scaleAdjust:Number = effectInfo["_scaleAdjust"];//縮小比率
			if (scaleAdjust != 1 && scaleAdjust) {//暫時拿掉縮小功能
				csDisplay.Body.scaleX = scaleAdjust;
				csDisplay.Body.scaleY = scaleAdjust;
				effectWid = effectWid * scaleAdjust;
				effectHei = effectHei * scaleAdjust;
			}
			
			var locate:Point = this.getShowPlace( effectInfo["_isOurSide"] , effectInfo["_place"]);
			//trace("locate",locate);
			csDisplay.Body.x = locate.x - effectWid / 2;//減掉怪物的中心對齊位偏
			csDisplay.Body.y = locate.y - (effectHei - effectWid) - effectWid / 2;//減effectWid為同怪物縮放後的高度,再減掉位偏
			
			//trace("此次施放技能SIZE為>><<>><<", effectWid + "*" + effectHei , scaleAdjust);
			//若查找不到效果動態
			//setTimeout(effectInfo._funFin, 1000);
		}
		
		
		
		
		private function toHub(status:String,info:Object=null,sendOut:Boolean=false):void 
		{
			this._funHub(status, info, sendOut);
		}
		
		
		override public function Destroy():void 
		{
			super.Destroy();
			this._funHub = null;
			this._objSource = null;
			this._pStageSize = null;
			//this._proxySkill.ClearAll();
			this._proxySkill = null;
			this.RemoveLoading();
			
			while (this.numChildren>0) 
			{
				this.removeChildAt(0);
			}
			
		}
		
		
	}
	
}