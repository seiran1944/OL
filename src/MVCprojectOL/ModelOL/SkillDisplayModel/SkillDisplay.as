package MVCprojectOL.ModelOL.SkillDisplayModel {
	//import com.greensock.loading.data.core.DisplayObjectLoaderVars;
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import MVCprojectOL.ModelOL.Vo.Skill;
	//import flash.utils.setTimeout;
	//import flash.utils.clearTimeout;
	
	
	//import flash.utils.getDefinitionByName;
	//import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author K.J. Aris
	 * 
	 @version 13.02.08.11.15
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
	 
	public final class SkillDisplay {
		private var _SkillData:Skill;
		private var _SkillIcon:Sprite = new Sprite();
		//private var _MonsterBody:Sprite = new Sprite();
		
		private var _SkillID:String = "";
		private var _SkillComponentKey:String = "";
		
		private const _IconSize:uint = 64;//64 X 64
		//private var _currentIconSize:uint = _IconSize;
		
		//private const _HalfIconSize:uint = _IconSize * 0.5;
		
		private var _SourceProxy:SourceProxy = SourceProxy.GetInstance();
		
		private var _ComponentAdded:Boolean = false;
		
		public var _status:uint = 0;//for temporary check
		
		private var _DisplayCache:DisplayCache;//Remote Loading cache control
		
		public function SkillDisplay( _InputSkillData:Skill ) {
			this.UpdateSkillValue( _InputSkillData );
		}
		
		public function UpdateSkillValue( _InputSkillData:Skill ):void {
			/*
			 * _IconKey//道具ICON KEY
			 * 在這裡決定參數
			*/
			this._SkillData = _InputSkillData;
			this._SkillComponentKey = this._SkillData._iconKey;
			this._SkillID = this._SkillData._guid;
			
			this._SkillIcon.name = this._SkillData._guid;
		}
		
		
		
		public function Clear():void {
			/*if ( this._SkillIcon != null && this._SkillIcon.parent != null ) {
				this._SkillIcon.parent.removeChild( this._SkillIcon );
				this._SkillIcon = null;
			}*/
			
			this.ClearContent( this._SkillIcon );
			
			if ( this._DisplayCache != null ) {//確保控制類被清乾淨
				this._DisplayCache.Destroy();
				this._DisplayCache = null;
			}
			
			this._ComponentAdded = false;
		}
		
		public function Destroy():void {
			this.Clear();
			this._SkillData = null;
			this._SkillIcon = null;
			
			this._SourceProxy = null;
		}
		
		public function ShowContent():void {
			this._DisplayCache == null ? this.SetDisplayCache() : null;
			this._DisplayCache.StartLoad();
		}
		
		private function SetDisplayCache():void {
			this._DisplayCache = new DisplayCache( this._SkillComponentKey , this._SkillIcon , this.GetContentShown , this._IconSize );
		}
		
		private function GetContentShown( _InputComponentKey:String ):void {
			
			if ( this._ComponentAdded == false ) {//當素材已加過便不能再加
				//this._DisplayCache = null;
				var _Icon:Sprite = this._SourceProxy.GetImageSprite( this._SkillComponentKey );
					
					_Icon.alpha = 0;
					
				this._SkillIcon.addChild( _Icon );
				
				//this.AdjustIconSize( this._SkillIcon , this._currentIconSize );
				
					TweenLite.to( _Icon , 1 , { alpha:1 , ease:Quad.easeOut } );
				
				this._ComponentAdded = true;
			}
			
		}//end GetContentShown
		
		/*private function AdjustIconSize( _InputIcon:Sprite , _InputSize:uint ):void {
			_InputIcon.scaleX = _InputSize / this.IconSize;
			_InputIcon.scaleY = _InputIcon.scaleX;
		}*/
		
		
		//--------------------------------------------------------getters
		public function get ID():String {
			return this._SkillID;
		}
		
		public function get Data():Skill {
			return this._SkillData;
		}
		
		public function get Icon():Sprite {
				//this.ShowContent();
			return this._SkillIcon;
		}
		
		public function get IconSize():uint {
			return this._IconSize;
		}
		//--------------------------------------------END---------getters
		
		
		//--------------------------------------------------------setters
		/*public function set IconSize(value:uint):void {
			this._currentIconSize = value;
			//if ( this._SkillIcon.width >= 0 ) {
				
				//this._IconScale = this._IconSize / this._SkillIcon.width;
				
				this._ComponentAdded == true ? this.AdjustIconSize( this._SkillIcon , this._currentIconSize ) : null;
			//}
			
		}*/
		//--------------------------------------------END---------setters
		
		
		
		
		//-------------------------------------------------Cache Status
		private function ClearContent( _InputTarget:Sprite ):void {
			while ( _InputTarget.numChildren > 0 ) {
				_InputTarget.removeChildAt( 0 );
			}
		}
		//--------------------------------------END--------Cache Status
		
	}//end class
}//end package