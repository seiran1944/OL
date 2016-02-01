package MVCprojectOL.ModelOL.SkillDisplayModel {
	//import com.greensock.loading.data.core.DisplayObjectLoaderVars;
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	//import flash.utils.setTimeout;
	//import flash.utils.clearTimeout;
	
	
	//import flash.utils.getDefinitionByName;
	//import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author K.J. Aris
	 * 
	 @version 12.12.11.15.07
	 */
	//import Spark.Utils.GlobalEvent.EventExpress;
	//import Spark.Utils.GlobalEvent.EventExpressPackage;
	
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import Spark.CommandsStrLad;
	
	//import Spark.MVCs.Models.SourceTools.Loader.LoadingBar;
	//import MVCprojectOL.ModelOL.Vo.PlayerMonster;
	 
	import MVCprojectOL.ModelOL.LoadingCache.DisplayCache;
	
	//import Spark.SoarVision.multiple.MultiSpriteVision;//動畫處理器
	//import Spark.SoarVision.VisionCenter;
	 
	public final class SkillEffectDisplay {
		private var _SkillEffectData:Object;
		private var _SkillEffectIcon:Sprite = new Sprite();
		//private var _MonsterBody:Sprite = new Sprite();
		
		private var _SkillEffectID:String = "";
		private var _SkillEffectComponentKey:String = "";
		
		private const _IconSize:uint = 64;//64 X 64
		
		//private const _HalfIconSize:uint = _IconSize * 0.5;
		
		private var _SourceProxy:SourceProxy = SourceProxy.GetInstance();
		
		private var _ComponentAdded:Boolean = false;
		
		public var _status:uint = 0;//for temporary check
		
		private var _DisplayCache:DisplayCache;//Remote Loading cache control
		
		public function SkillEffectDisplay( _InputSkillEffectData:Object ) {
			this.UpdateSkillValue( _InputSkillEffectData );
		}
		
		public function UpdateSkillValue( _InputSkillEffectData:Object ):void {
			/*
			 * _IconKey//道具ICON KEY
			 * 在這裡決定參數
			*/
			this._SkillEffectData = _InputSkillEffectData;
			this._SkillEffectComponentKey = this._SkillEffectData._IconKey;
			this._SkillEffectID = this._SkillEffectData._guid;
			
			this._SkillEffectIcon.name = this._SkillEffectData._guid;
		}
		
		
		
		public function Clear():void {
			/*if ( this._SkillEffectIcon != null && this._SkillEffectIcon.parent != null ) {
				this._SkillEffectIcon.parent.removeChild( this._SkillEffectIcon );
				this._SkillEffectIcon = null;
			}*/
			
			this.ClearContent( this._SkillEffectIcon );
			
			if ( this._DisplayCache != null ) {//確保控制類被清乾淨
				this._DisplayCache.Clear();
				this._DisplayCache = null;
			}
			
			this._ComponentAdded = false;
		}
		
		public function ShowContent():void {
			this._DisplayCache == null ? this.SetDisplayCache() : null;
			this._DisplayCache.StartLoad();
		}
		
		private function SetDisplayCache():void {
			this._DisplayCache = new DisplayCache( this._SkillEffectComponentKey , this._SkillEffectIcon , this.GetContentShown , this._IconSize );
		}
		
		private function GetContentShown( _InputComponentKey:String ):void {
			
			if ( this._ComponentAdded == false ) {//當素材已加過便不能再加
				this._DisplayCache = null;
				var _Icon:Sprite = this._SourceProxy.GetImageSprite( this._SkillEffectComponentKey );
					
					_Icon.alpha = 0;
					
				this._SkillEffectIcon.addChild( _Icon );
					
					TweenLite.to( _Icon , 1 , { alpha:1 , ease:Quad.easeOut } );
				
				this._ComponentAdded = true;
			}
			
		}//end GetContentShown
		
		
		
		//--------------------------------------------------------getters
		public function get ID():String {
			return _SkillEffectID;
		}
		
		public function get Data():Object {
			return this._SkillEffectData;
		}
		
		public function get Icon():Sprite {
				//this.ShowContent();
			return this._SkillEffectIcon;
		}
		
		public function get IconSize():uint {
			return this._IconSize;
		}
		
		//--------------------------------------------END---------getters
		
		
		
		
		
		
		
		//-------------------------------------------------Cache Status
		private function ClearContent( _InputTarget:Sprite ):void {
			while ( _InputTarget.numChildren > 0 ) {
				_InputTarget.removeChildAt( 0 );
			}
		}
		//--------------------------------------END--------Cache Status
		
	}//end class
}//end package