package MVCprojectOL.ModelOL.SkillDisplayModel {
	//import com.greensock.loading.data.core.DisplayObjectLoaderVars;
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterClipDepot;
	import MVCprojectOL.ModelOL.Vo.Skill;
	//import flash.utils.setTimeout;
	//import flash.utils.clearTimeout;
	
	
	//import flash.utils.getDefinitionByName;
	//import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.06.03.14.38
	 */
	//import Spark.Utils.GlobalEvent.EventExpress;
	//import Spark.Utils.GlobalEvent.EventExpressPackage;
	
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import Spark.CommandsStrLad;
	
	//import Spark.MVCs.Models.SourceTools.Loader.LoadingBar;
	//import MVCprojectOL.ModelOL.Vo.PlayerMonster;
	 
	//import MVCprojectOL.ModelOL.LoadingCache.DisplayCache;
	import MVCprojectOL.ModelOL.LoadingCache.MultiRemoteCache;
	import MVCprojectOL.ModelOL.SkillDisplayModel.SkillAnimateController;
	//import Spark.SoarVision.multiple.MultiSpriteVision;//動畫處理器
	//import Spark.SoarVision.VisionCenter;
	 
	public final class CombatSkillDisplay {
		private var _SkillData:Skill;
		private var _SkillIcon:Sprite = new Sprite();
		private var _SkillBody:Sprite = new Sprite();
		//private var _MonsterBody:Sprite = new Sprite();
		
		private var _SkillID:String = "";
		private var _SkillComponentKey:String = "";
		private var _SkillComponentKeyList:Vector.<String> = new Vector.<String>;
		//private var _SkillComponentKey2:String = "";
		
		private const _SkillIconClassName:String = "SKicon";
		private const _SkillEffectClassName:String = "SKeffect";
		
		private const _IconSize:uint = 12;//64 X 64
		
		//private const _HalfIconSize:uint = _IconSize * 0.5;
		
		private var _SourceProxy:SourceProxy = SourceProxy.GetInstance();
		
		private var _ComponentAdded:Boolean = false;
		
		public var _status:uint = 0;//for temporary check
		
		private var _DisplayCache:MultiRemoteCache;//Remote Loading cache control
		//private var _DisplayCache2:DisplayCache;//Remote Loading cache control
		
		private var _SkillAnimateController:SkillAnimateController;//動態播放器
		
		public var _ReadyNotifyAddress:Function;
		
		public function CombatSkillDisplay( _InputSkillData:Skill , _InputSplit:uint = 0 ) {
			this.UpdateSkillValue( _InputSkillData , _InputSplit );
		}
		
		public function UpdateSkillValue( _InputSkillData:Skill , _InputSplit:uint = 0 ):void {
			/*
			 * _IconKey//道具ICON KEY
			 * 在這裡決定參數
			*/
			this._SkillData = _InputSkillData;
			this._SkillComponentKey = this._SkillData._effectKey;
			
			this._SkillComponentKeyList.push( this._SkillData._iconKey );
			this._SkillComponentKeyList.push( this._SkillComponentKey );
			
			this._SkillID = this._SkillData._guid + "_" + _InputSplit;// ( ( _InputSplit != 0 ) ? _InputSplit : "" );
			//trace( this._SkillID , "GDFDFDFDFDFDF" );
			this._SkillIcon.name = this._SkillData._guid;
			
		}
		
		
		
		public function Clear():void {
			/*if ( this._SkillIcon != null && this._SkillIcon.parent != null ) {
				this._SkillIcon.parent.removeChild( this._SkillIcon );
				this._SkillIcon = null;
			}*/
			
			this.ClearContent( this._SkillIcon );
			this.ClearContent( this._SkillBody );
			
			if ( this._DisplayCache != null ) {//確保控制類被清乾淨
				this._DisplayCache.Stop();
				this._DisplayCache = null;
			}
			
			if ( this._SkillAnimateController != null ) {//確保控制類被清乾淨
				this._SkillAnimateController.Destroy();
				this._SkillAnimateController = null;
			}
			
			this._ComponentAdded = false;
		}
		
		public function Destroy():void {
			this.Clear();
			this._SkillData = null;
			this._SkillIcon = null;
			this._SkillBody = null;
			this._SourceProxy = null;
			//this._DisplayCache = null;
			//this._MotionController = null;
			this._ReadyNotifyAddress = null;
			
			if ( this._SkillAnimateController != null ) {//確保控制類被清乾淨
				this._SkillAnimateController.Destroy();
				this._SkillAnimateController = null;
			}
			
			if ( this._DisplayCache != null ) {//確保控制類被清乾淨
				this._DisplayCache.Stop();
				this._DisplayCache = null;
			}
		}
		
		public function ShowContent():void {
			this._DisplayCache == null ? this.SetDisplayCache() : null;
			this._DisplayCache.StartLoad();
			//this.GetContentShown( this.ID );
		}
		
		private function SetDisplayCache():void {
			//this._DisplayCache = new DisplayCache( this._SkillComponentKey , this._SkillIcon , this.GetContentShown , this._IconSize );
			this._DisplayCache = new MultiRemoteCache( this._SkillComponentKeyList , this.GetContentShown );
		
		}
		
		private function GetContentShown( _InputComponentKey:String ):void {
			
			if ( this._ComponentAdded == false ) {//當素材已加過便不能再加
				//this._DisplayCache = null;
				//var _Icon:Sprite = this._SourceProxy.GetImageSprite( this._SkillComponentKey );
				
				//var _Icon:Sprite = new ( this._SourceProxy.GetMaterialSWP( this._SkillComponentKey , this._SkillIconClassName ) as Class );
				var _Icon:Sprite = this._SourceProxy.GetImageSprite( this._SkillData._iconKey );
					_Icon.alpha = 0;
				
				var _EffectClass:Class = ( this._SourceProxy.GetMaterialSWP( this._SkillComponentKey , this._SkillEffectClassName ) as Class );
				var _SourceClip:MovieClip = MonsterClipDepot.GetInstance().Inquiry( _EffectClass , MovieClip );
				this._SkillAnimateController = new SkillAnimateController( this._SkillID , this._SkillComponentKey , _SourceClip );
				
				
					
				this._SkillAnimateController.MotionClip.alpha = 0;
					
				this._SkillIcon.addChild( _Icon );
				this._SkillBody.addChild( this._SkillAnimateController.MotionClip );
					
					TweenLite.to( _Icon , 1 , { alpha:1 , ease:Quad.easeOut } );
					TweenLite.to( this._SkillAnimateController.MotionClip , 1 , { alpha:1 , ease:Quad.easeOut } );
					
				this._ComponentAdded = true;
				//trace( "QQQQQQQQQQQQQQQQQQQQQQQQ" );
				
				
				
				
				
				//trace( _InputComponentKey , "Ready <<----------------------" , this._ReadyNotifyAddress );
				
				//this._ReadyNotifyAddress( this._SkillID );
				
			}
			//----------Send Ready Notify
			( this._ReadyNotifyAddress != null ) ? this._ReadyNotifyAddress( this._SkillID ) : null;
			this._ReadyNotifyAddress = null;
			
			
		}//end GetContentShown
		
		
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
		
		public function get Body():Sprite {
			return this._SkillBody;
		}
		
		public function get IconSize():uint {
			return this._IconSize;
		}
		
		public function get IconKey():String {
			return _SkillComponentKey;
		}
		
		public function get Motion():SkillAnimateController {
			return this._SkillAnimateController;
		}
		
		
		
		
		
		//--------------------------------------------END---------getters
		
		
		
		
		
		
		
		//-------------------------------------------------Cache Status
		private function ClearContent( _InputTarget:Sprite ):void {
			while ( _InputTarget.numChildren > 0 ) {
				_InputTarget.removeChildAt( 0 );
			}
		}
		
		/*public function set ReadyNotifyAddress( value:Function ):void {
			this._ReadyNotifyAddress = value;
		}*/
		//--------------------------------------END--------Cache Status
		
	}//end class
}//end package