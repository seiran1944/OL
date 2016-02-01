package MVCprojectOL.ModelOL.Explore.Display {
	//import com.greensock.loading.data.core.DisplayObjectLoaderVars;
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import MVCprojectOL.ModelOL.Vo.Explore.ExploreChapter;
	//import flash.utils.setTimeout;
	//import flash.utils.clearTimeout;
	
	
	
	//import flash.utils.getDefinitionByName;
	//import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.05.03.16.33
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
	 
	public final class ChapterDisplay {
		private var _ChapterData:ExploreChapter;
		private var _ChapterCover:Sprite = new Sprite();
		private var _ChapterMap:Sprite = new Sprite();
		//private var _MonsterBody:Sprite = new Sprite();
		
		private var _ChapterID:String = "";
		private var _ChapterComponentKey:String = "";
		
		private const _ChapterCoverClassName:String = "Cover";
		private const _ChapterMapClassName:String = "Map";
		
		private const _IconSize:uint = 64;//64 X 64
		public const _CoverSize:Point = new Point( 200 , 135 );//		200 X 135
		public const _MapSize:Point = new Point( 730 , 505 );//		730 X 505
		
		//private const _HalfIconSize:uint = _IconSize * 0.5;
		
		private var _SourceProxy:SourceProxy = SourceProxy.GetInstance();
		
		private var _ComponentAdded:Boolean = false;
		
		public var _status:uint = 0;//for temporary check
		
		private var _DisplayCache:DisplayCache;//Remote Loading cache control
		
		private var _ReadyNotifyAddress:Function;
		
		public function ChapterDisplay( _InputChapterData:ExploreChapter , _InputReadyNotifyAddress:Function = null ) {
			this._ReadyNotifyAddress = _InputReadyNotifyAddress;
			this.UpdateItemValue( _InputChapterData );
		}
		
		public function UpdateItemValue( _InputChapterData:ExploreChapter ):void {
			/*
			 * _IconKey//道具ICON KEY
			 * 在這裡決定參數
			*/
			this._ChapterData = _InputChapterData;
			this._ChapterComponentKey = this._ChapterData._picItem;
			this._ChapterID = this._ChapterData._guid;
			
			this._ChapterCover.name = this._ChapterID;	// + this._ChapterCoverClassName;
			this._ChapterMap.name = this._ChapterID + this._ChapterMapClassName;
		}
		
		
		
		public function Clear():void {
			/*if ( this._ChapterCover != null && this._ChapterCover.parent != null ) {
				this._ChapterCover.parent.removeChild( this._ChapterCover );
				this._ChapterCover = null;
			}*/
			
			this.ClearContent( this._ChapterCover );
			
			if ( this._DisplayCache != null ) {//確保控制類被清乾淨
				this._DisplayCache.Destroy();
				this._DisplayCache = null;
			}
			
			this._ComponentAdded = false;
		}
		
		public function Destroy():void {
			this.Clear();
			this._ChapterData = null;
			this._ChapterCover = null;
			this._SourceProxy = null;
		}
		
		
		public function ShowContent():void {
			this._DisplayCache == null ? this.SetDisplayCache() : null;
			this._DisplayCache.StartLoad();
		}
		
		private function SetDisplayCache():void {
			this._DisplayCache = new DisplayCache( this._ChapterComponentKey , this._ChapterCover , this.GetContentShown , this._IconSize , 10 , 10 );
		}
		
		private function GetContentShown( _InputComponentKey:String ):void {
			
			if ( this._ComponentAdded == false ) {//當素材已加過便不能再加
				this._DisplayCache = null;
					
				var _Cover:Sprite = new ( this._SourceProxy.GetMaterialSWP( this._ChapterComponentKey , this._ChapterCoverClassName ) as Class );
					_Cover.alpha = 0;
					
				this._ChapterCover.addChild( _Cover );
					
					TweenLite.to( _Cover , 1 , { alpha:1 , ease:Quad.easeOut } );
					
					
					
				var _Map:Sprite = new ( this._SourceProxy.GetMaterialSWP( this._ChapterComponentKey , this._ChapterMapClassName ) as Class );
					_Map.alpha = 0;
					
				this._ChapterMap.addChild( _Map );
					
					TweenLite.to( _Map , 1 , { alpha:1 , ease:Quad.easeOut } );
					
				this._ReadyNotifyAddress != null ? this._ReadyNotifyAddress() : null;
					
				this._ComponentAdded = true;
			}
			
		}//end GetContentShown
		
		
		
		//--------------------------------------------------------getters
		public function get ID():String {
			return this._ChapterID;
		}
		
		public function get Data():Object {
			return this._ChapterData;
		}
		
		public function get Cover():Sprite {
			return this._ChapterCover;
		}
		
		public function get Map():Sprite {
			return this._ChapterMap;
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