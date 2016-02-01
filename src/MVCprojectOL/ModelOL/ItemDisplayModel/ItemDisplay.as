package MVCprojectOL.ModelOL.ItemDisplayModel {
	//import com.greensock.loading.data.core.DisplayObjectLoaderVars;
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
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
	 * @version 12.12.12.12.12
	 * @modified 13.04.10.10.33
	 */
	//import Spark.Utils.GlobalEvent.EventExpress;
	//import Spark.Utils.GlobalEvent.EventExpressPackage;
	
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import Spark.CommandsStrLad;
	
	//import Spark.MVCs.Models.SourceTools.Loader.LoadingBar;
	import MVCprojectOL.ModelOL.LoadingCache.DisplayCache;
	//import MVCprojectOL.ModelOL.Vo.PlayerMonster;
	 
	
	//import Spark.SoarVision.multiple.MultiSpriteVision;//動畫處理器
	//import Spark.SoarVision.VisionCenter;
	 
	public final class ItemDisplay {
		private var _ItemData:Object;
		private var _ItemIcon:Sprite = new Sprite();
		//private var _MonsterBody:Sprite = new Sprite();
		
		private var _ItemID:String = "";
		private var _ItemComponentKey:String = "";
		
		private const _IconSize:uint = 64;//64 X 64
		
		//private const _HalfIconSize:uint = _IconSize * 0.5;
		
		private var _SourceProxy:SourceProxy = SourceProxy.GetInstance();
		
		private var _ComponentAdded:Boolean = false;
		
		public var _status:uint = 0;//for temporary check
		
		private var _DisplayCache:DisplayCache;//Remote Loading cache control
		
		//---2013/03/27
		private var _quaBitmapData:BitmapData;
		
		public function ItemDisplay( _InputMonsterData:Object ) {
			this.UpdateItemValue( _InputMonsterData );
		}
		
		public function UpdateItemValue( _InputItemData:Object ):void {
			/*
			 * _IconKey//道具ICON KEY
			 * 在這裡決定參數
			*/
			this._ItemData = _InputItemData;
			this._ItemComponentKey = this._ItemData._picItem;
			//this._ItemID = this._ItemData._guid == null ? String( Math.random() ) : this._ItemData._guid ;
			this._ItemID = this._ItemData._picItem;
			
			this._ItemIcon.name = this._ItemID + String( Math.random() );
		}
		
		
		
		public function Clear():void {
			/*if ( this._ItemIcon != null && this._ItemIcon.parent != null ) {
				this._ItemIcon.parent.removeChild( this._ItemIcon );
				this._ItemIcon = null;
			}*/
			
			this.ClearContent( this._ItemIcon );
			
			if ( this._DisplayCache != null ) {//確保控制類被清乾淨
				this._DisplayCache.Destroy();
				this._DisplayCache = null;
			}
			
			this._ComponentAdded = false;
		}
		
		public function Destroy():void {
			this.Clear();
			this._ItemData = null;
			this._ItemIcon = null;
			this._SourceProxy = null;
		}
		
		
		public function ShowContent():void {
			this._DisplayCache == null ? this.SetDisplayCache() : null;
			this._DisplayCache.StartLoad();
		}
		
		private function SetDisplayCache():void {
			this._DisplayCache = new DisplayCache( this._ItemComponentKey , this._ItemIcon , this.GetContentShown , this._IconSize , 10 , 10 );
		}
		
		//---2013/03/27
		private function GetContentShown( _InputComponentKey:String ):void {
			
			if ( this._ComponentAdded == false ) {//當素材已加過便不能再加
				this._DisplayCache = null;
				var _Icon:Sprite = this._SourceProxy.GetImageSprite( this._ItemComponentKey );
				_Icon.alpha = 0;
				var _bitmap:Bitmap = (this._quaBitmapData != null)?new Bitmap(this._quaBitmapData):null;
				if (_bitmap != null)_Icon.addChild(_bitmap);
				this._ItemIcon.addChild( _Icon );	
				TweenLite.to( _Icon , 1 , { alpha:1 , ease:Quad.easeOut } );
				
				this._ComponentAdded = true;
			}
			
		}//end GetContentShown
		
		//---set qua的外框-------
	    public function set quaBitmapData(value:BitmapData):void 
		{
			this._quaBitmapData = value;
		}
		
		
		//--------------------------------------------------------getters
		public function get ItemID():String {
			return this._ItemID;
		}
		
		public function get ItemData():Object {
			return this._ItemData;
		}
		
		public function get ItemIcon():Sprite {
				//this.ShowContent();
			return this._ItemIcon;
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