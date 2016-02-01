package MVCprojectOL.ViewOL.BattleView
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleFighter;
	import Spark.SoarVision.single.SpriteVision;
	import Spark.SoarVision.VisionCenter;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.04.08.20.10
		@documentation 單位資訊顯示框
	 */
	public class SignBox extends Sprite 
	{
		
		private var _hpBar:Bitmap;
		private var _vecEffectKey:Vector.<String>;
		private var _vecMultiKey:Vector.<String>;
		private var _spHead:Sprite;
		private var _spVision:SpriteVision;
		private var _aryVision:Array;
		//private var _dicPoint:Dictionary;
		private var _dicSaveIcon:Dictionary;
		//private var _iconBasicX:int;
		private var _txtHp:TextField;//130327提供測試用的血量顯示
		private var _mxIcon:Matrix;//130604 ICON畫圖使用到的縮小繪製
		
		
		public function SignBox():void
		{
			this._vecEffectKey = new Vector.<String>();
			this._vecMultiKey = new Vector.<String>();
			this._dicSaveIcon = new Dictionary(true);
			this._mxIcon = new Matrix(.5, 0, 0, .5);
		}
		
		public function get BarImagine():DisplayObject
		{
			return this._hpBar;
		}
		
		//測試用顯示,怪物職業130408若不顯示可摘掉
		public function InitJobTitle(job:String):void 
		{
			var txtJob:TextField = new TextField();
			var txtFormat:TextFormat = new TextFormat();
			txtJob.selectable = false;
			txtFormat.size = 14;
			txtFormat.color = 0xFFFFFF;
			txtJob.defaultTextFormat = txtFormat;
			txtJob.text = job != null ? job : "None";
			txtJob.width = this._hpBar.width;
			txtJob.height = 18;
			txtJob.y = 64 - 2 * txtJob.height;
			addChild(txtJob);
		}
		
		public function InSource(objSource:Object):void
		{
			//底框圖配置
			//var bmBg:Bitmap = new Bitmap(new objSource["infoBoard"]());
			//addChild(bmBg);
			//血條配置
			//this._hpBar = new Bitmap(new BitmapData(50, 10, false, 0x00FF00));
			var bmdHp:BitmapData = new objSource["hpBar"]();
			//var bmdResize:BitmapData = new BitmapData(64, bmdHp.height, true, 0x00FFFFFF);
			//bmdResize.copyPixels(bmdHp, new Rectangle(0, 0, 64, bmdHp.height), new Point());
			
			this._hpBar = new Bitmap(bmdHp);
			addChild(this._hpBar);
			this._hpBar.x = 1;
			this._hpBar.y = 64 - this._hpBar.height;
			
			//for (var i:int = 0; i < 4; i++) 
			//{
				//var bmb:Bitmap = new Bitmap();
				//bmb.bitmapData=new BitmapData(16, 16, false, 0xFF0000)
				//this.AddSign(String(Math.random() * 100),bmb );
				//
			//}
			
			this._txtHp = new TextField();
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.size = 14;
			txtFormat.color = 0xFFFFFF;
			this._txtHp.selectable = false;
			this._txtHp.defaultTextFormat = txtFormat;
			this._txtHp.width = this._hpBar.width;
			this._txtHp.height = 18;
			this._txtHp.y = 64 - this._txtHp.height;
			addChild(this._txtHp);
		}
		
		public function SetBloodValue(currentBlood:int,totalBlood:int):void 
		{
			this._txtHp.text = String(currentBlood) + " / " + String(totalBlood);
		}
		
		
		
		public function PlaceRight(iconBasicX:int):void
		{
			//this._iconBasicX = iconBasicX + 13;
			//this._spHead.x = 52;
			//this._hpBar.x = 52;
		}
		
		//public function SetDicPlace(dicPlace:Dictionary):void
		//{
			//this._dicPoint = dicPlace;
		//}
		
		public function SetHeadIcon(head:Sprite):void
		{
			this._spHead = head;
			//head.width = head.width >> 1 ;
			//head.height= head.height>> 1 ;
			addChild(head);
			//head.x = 20;
			//head.y = -7;
		}
		
		
		//public function AddSign(effectKey:String,signLogo:DisplayObject):void
		//{
			//signLogo.name = effectKey;
			//var index:int = this._vecEffectKey.indexOf(effectKey);
			//if (index == -1) {//沒有的狀態圖示再做處理
				//this._vecEffectKey[this._vecEffectKey.length] = effectKey;
				//var eKeyLeng:int = this._vecEffectKey.length;
				//
				//if (eKeyLeng > 4) {//加入圖示時已經加滿四個(須先記錄圖示ICON)
					//this._dicSaveIcon[effectKey] = signLogo;//已篩選過故都是沒有的圖示
					//return ;
				//}
				//
				//var pLocate:Point = this.getIconPlace(eKeyLeng -1);
				//addChild(signLogo);
				//signLogo.alpha = 0;
				//signLogo.x = pLocate.x + this._iconBasicX;
				//signLogo.y = pLocate.y;
				//TweenLite.to(signLogo, .5, { alpha:1 } );
			//}else {//有重複的圖示,不顯示但須記錄
				//this._vecMultiKey[this._vecMultiKey.length] = effectKey;
			//}
			//
			//
		//}
		
		//移除記錄中的效果KEY與圖像,同時若還有狀態疊加則往前移動
		//public function RemoveSign(effectKey:String):void
		//{
			//
			//先確認是否有重複需要到共用圖示,有先移除標記不改變圖示處理
			//var preIndex:int = this._vecMultiKey.indexOf(effectKey);
			//if (preIndex != -1) {//有重複則移掉,後續不處理
				//this._vecMultiKey.splice(preIndex, 1);
				//return;
			//}
			//圖示為單一效果擁有的狀態,移除圖示的步驟
			//var leng:int = this._vecEffectKey.length;
			//var index:int = this._vecEffectKey.indexOf(effectKey);
			//this._vecEffectKey.splice(index, 1);
			//var icon:DisplayObject = getChildByName(effectKey);
			//removeChild(icon);
			//var currentKey:String;
			//var leastNum:int = leng - 1 - index;
			//if (leastNum > 0) {
				//var pLocate:Point;
				//for (var i:int = index; i < index + leastNum; i++) 
				//{
					//currentKey = this._vecEffectKey[i];
					//icon = getChildByName(currentKey);
					//if (icon != null) {//有顯示出來的移除效果後方ICON
						//pLocate = this.getIconPlace(i);
						//TweenLite.killTweensOf(icon);//避免移除多個ICON造成多重移動
						//TweenLite.to(icon, .5, { x:pLocate.x + this._iconBasicX, y:pLocate.y } );
					//}else {//加入佇列尚未顯示的ICON(新增時應當會是最末位置)目前為[3]
						//pLocate = this.getIconPlace(3);
						//icon = this._dicSaveIcon[currentKey];
						//delete this._dicSaveIcon[currentKey];
						//addChild(icon);
						//icon.x = pLocate.x + this._iconBasicX;
						//icon.y = pLocate.y;
						//icon.alpha = 0;
						//TweenLite.to(icon, .5, { alpha:1 } );
						//補足一個空位即結束
						//break;
					//}
				//}
			//}
			//
		//}
		
		//new edition mode
		public function AddSign(effectKey:String,signLogo:DisplayObject):void
		{
			signLogo.name = effectKey;
			var index:int = this._vecEffectKey.indexOf(effectKey);
			if (index == -1) {//沒有的狀態圖示再做處理
				this._vecEffectKey[this._vecEffectKey.length] = effectKey;
				var eKeyLeng:int = this._vecEffectKey.length;
				
				var insidePic:Sprite = Sprite(signLogo).getChildAt(0) as Sprite;
				
				var bmLogo:BitmapData = new BitmapData(32, 32, true, 0);
				bmLogo.draw(insidePic,this._mxIcon);
				//var bm:Bitmap = new Bitmap(bmLogo);//test
				//addChild(bm);//test
				this._dicSaveIcon[effectKey] = bmLogo;
				this.visionContentProcess(true, bmLogo);
				
			}
			
		}
		
		//new edition mode
		public function RemoveSign(effectKey:String):void
		{
			//先確認是否有重複需要到共用圖示,有先移除標記不改變圖示處理
			var preIndex:int = this._vecMultiKey.indexOf(effectKey);
			if (preIndex != -1) {//有重複則移掉,後續不處理
				this._vecMultiKey.splice(preIndex, 1);
				return;
			}
			//圖示為單一效果擁有的狀態,移除圖示的步驟
			var index:int = this._vecEffectKey.indexOf(effectKey);
			this._vecEffectKey.splice(index, 1);
			
			this.visionContentProcess(false, this._dicSaveIcon[effectKey]);
			delete this._dicSaveIcon[effectKey];
			
		}
		
		private function visionContentProcess(isAdd:Boolean,logo:BitmapData=null):void
		{
			if (this._spVision == null) {
				this._spVision = new SpriteVision(this.name);
				this._aryVision = [];
				addChild(this._spVision);
				this._spVision.x = 16;
				this._spVision.y = 68;
				VisionCenter.GetInstance().AddSinglePlay(this._spVision, this._aryVision, true, false, false, 800);
			}
			isAdd ? this._aryVision[this._aryVision.length] = logo : this._aryVision.splice(this._aryVision.indexOf(logo), 1);
			
			VisionCenter.GetInstance().MovieChangeSource(this.name, this._aryVision, true, null, "", false, false, 800);
		}
		
		public function get CurrentEffectName():String
		{
			return this._spVision == null || this._vecEffectKey.length==0 ? "" : this._vecEffectKey[this._spVision.VisionPosition - 1];
		}
		
		//預計最大値四個左右 索引為 >> "icon" + 0~3
		//private function getIconPlace(place:int):Point
		//{
			//return this._dicPoint["icon" + String(place)];
		//}
		
		public function Destroy():void 
		{
			if (this._aryVision != null) {
				this._aryVision.length = 0;
				this._aryVision = null;
			}
			this._dicSaveIcon = null;
			this._hpBar.bitmapData.dispose();
			this._hpBar.bitmapData = null;
			this._hpBar = null;
			this._spHead = null;
			this._vecEffectKey.length = 0;
			this._vecMultiKey.length = 0;
			this._vecEffectKey = null;
			this._vecMultiKey = null;
			VisionCenter.GetInstance().MovieRemove(this.name, true);
			this._spVision = null;
			this._mxIcon = null;
		}
		
	}
	
}