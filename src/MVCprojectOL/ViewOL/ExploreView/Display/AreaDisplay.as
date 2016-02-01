package MVCprojectOL.ViewOL.ExploreView.Display {
	//import com.greensock.loading.data.core.DisplayObjectLoaderVars;
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import MVCprojectOL.ModelOL.Vo.Explore.ExploreArea;
	import MVCprojectOL.ModelOL.Vo.Explore.ExploreChapter;
	//import flash.utils.setTimeout;
	//import flash.utils.clearTimeout;
	
	
	
	//import flash.utils.getDefinitionByName;
	//import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.04.24.17.49
	 */
	//import Spark.Utils.GlobalEvent.EventExpress;
	//import Spark.Utils.GlobalEvent.EventExpressPackage;
	
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import Spark.CommandsStrLad;
	
	//import Spark.MVCs.Models.SourceTools.Loader.LoadingBar;
	import MVCprojectOL.ModelOL.LoadingCache.DisplayCache;
	import MVCprojectOL.ModelOL.LoadingCache.MultiRemoteCache;
	//import MVCprojectOL.ModelOL.Vo.PlayerMonster;
	 
	
	//import Spark.SoarVision.multiple.MultiSpriteVision;//動畫處理器
	//import Spark.SoarVision.VisionCenter;
	 
	public final class AreaDisplay extends Sprite{
		private var _AreaData:ExploreArea;
		private var _AreaClasses:Object;
		//private var _AreaBody:Sprite = this;
		
		private var _AreaID:String = "";
		private var _AreaComponentKey:String = "";
		
		private const _AreaBodyClassName:String = "Map";
		
		private const _IconSize:uint = 64;//64 X 64
		
		//private const _HalfIconSize:uint = _IconSize * 0.5;
		
		//private var _SourceProxy:SourceProxy = SourceProxy.GetInstance();
		
		private var _ComponentAdded:Boolean = false;
		
		private var _DisplayCache:DisplayCache;//Remote Loading cache control
		
		public function AreaDisplay( _InputAreaData:ExploreArea , _InputAreaClasses:Object ) {
			this.UpdateItemValue( _InputAreaData );
			this._AreaClasses = _InputAreaClasses;
		}
		
		public function UpdateItemValue( _InputAreaData:ExploreArea ):void {
			/*
			 * _IconKey//道具ICON KEY
			 * 在這裡決定參數
			*/
			this._AreaData = _InputAreaData;
			//this._AreaComponentKey = this._AreaData._picItem;
			this._AreaID = this._AreaData._guid;
			
			//this._ChapterCover.name = this._AreaID + this._ChapterCoverClassName;
			//this._AreaBody.name = this._AreaID + this._AreaBodyClassName;
			this.name = this._AreaID + this._AreaBodyClassName;
		}
		
		
		
		public function Clear():void {
			/*if ( this._ChapterCover != null && this._ChapterCover.parent != null ) {
				this._ChapterCover.parent.removeChild( this._ChapterCover );
				this._ChapterCover = null;
			}*/
			
			this.ClearContent( this._ChapterCover );
			
			/*if ( this._DisplayCache != null ) {//確保控制類被清乾淨
				this._DisplayCache.Destroy();
				this._DisplayCache = null;
			}*/
			
			this._ComponentAdded = false;
		}
		
		public function Destroy():void {
			this.Clear();
			this._AreaData = null;
			this._ChapterCover = null;
			//this._SourceProxy = null;
		}
		
		public function ShowContent():void {
			//從this._AreaClasses使用將會使用到的類別
			//動態特效項目
			//this._AreaBody
			//
			( this._AreaData._accessible == true ) ? "顯示開啟狀態" : "顯示關閉狀態";
			
		}
		
		public function onClicked():void {
			//PS : 在外部建立一個全域監聽器  當點擊節點時導入這串
			( this._AreaData._accessible == true ) ? "跳出難易度選擇" : "不理他";	//判斷是否能點
		}
		
		public function onRollover():void {
			//PS : 在外部建立一個全域監聽器  當滑過節點時導入這串
			( this._AreaData._accessible == true ) ? "發亮" : "不理他";	//判斷是否能點
		}
		
		/*public function ShowContent():void {
			this._DisplayCache == null ? this.SetDisplayCache() : null;
			this._DisplayCache.StartLoad();
		}
		
		private function SetDisplayCache():void {
			this._DisplayCache = new DisplayCache( this._AreaComponentKey , this._ChapterCover , this.GetContentShown , this._IconSize , 10 , 10 );
		}
		
		private function GetContentShown( _InputComponentKey:String ):void {
			
			if ( this._ComponentAdded == false ) {//當素材已加過便不能再加
				this._DisplayCache = null;
					
				var _Map:Sprite = new ( this._SourceProxy.GetMaterialSWP( this._AreaComponentKey , this._AreaBodyClassName ) as Class );
					_Map.alpha = 0;
					
				this._AreaBody.addChild( _Map );
					
					TweenLite.to( _Map , 1 , { alpha:1 , ease:Quad.easeOut } );
					
				
				this._ComponentAdded = true;
			}
			
		}//end GetContentShown*/
		
		
		
		//--------------------------------------------------------getters
		public function get ID():String {
			return this._AreaID;
		}
		
		public function get Data():Object {
			return this._AreaData;
		}
		
		/*public function get Cover():Sprite {
			return this._ChapterCover;
		}*/
		
		public function get Body():Sprite {
			return this._AreaBody;
		}
		
		/*public function get IconSize():uint {
			return this._IconSize;
		}*/
		
		//--------------------------------------------END---------getters
		
		//-------------------------------------------------Cache Status
		
		
		private function ClearContent( _InputTarget:Sprite ):void {
			/*while ( _InputTarget.numChildren > 0 ) {
				_InputTarget.removeChildAt( 0 );
			}*/
			_InputTarget.removeChildren();
		}
		//--------------------------------------END--------Cache Status
		
	}//end class
}//end package