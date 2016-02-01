package MVCprojectOL.ModelOL.MonsterDisplayModel {
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
	 * @version 13.05.13.14.44
	 */
	//import Spark.Utils.GlobalEvent.EventExpress;
	//import Spark.Utils.GlobalEvent.EventExpressPackage;
	
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import Spark.CommandsStrLad;
	
	//import Spark.MVCs.Models.SourceTools.Loader.LoadingBar;
	import MVCprojectOL.ModelOL.Vo.PlayerMonster;
	 
	import MVCprojectOL.ModelOL.LoadingCache.DisplayCache;
	
	import Spark.SoarVision.multiple.MultiSpriteVision;//動畫處理器
	import Spark.SoarVision.VisionCenter;
	
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterUtilities;
	 
	public final class MonsterDisplay {
		include "MonsterStatusStamp.as";
		private var _MonsterData:Object;
		private var _MonsterHead:Sprite = new Sprite();//this is a Cache Container
		private var _MonsterBody:Sprite = new Sprite();//this is a Cache Container
		private var _InnerBody:DisplayObjectContainer;
		private var _MiddleBody:Sprite;
		
		private var _MonsterID:String = "";
		private var _MonsterComponentKey:String = "";
		
		private const _HeadSize:uint = 64;//64 X 64
		private const _BodySize:uint = 150;//150 X 150
		
		//private const _HalfHeadSize:uint = _HeadSize * 0.5;
		//private const _HalfBodySize:uint = _BodySize * 0.5;
		private var _SourceProxy:SourceProxy = SourceProxy.GetInstance();
		private var _MonsterClipDepot:MonsterClipDepot = MonsterClipDepot.GetInstance();
		
		private const _HeadClassName:String = "head";
		private const _BodyClassName:String = "body";
		
		private var _ComponentAdded:Boolean = false;
		
		public var _status:uint = 0;//for temporary check
		
		private var _DisplayCache:DisplayCache;//Remote Loading cache control
		
		private var _Alive:Boolean = false;//為true 時才給動態控制器
		private var _MotionController:MonsterMotionController;//怪物動作控制器 Note : Alive模式才有用
		
		//private var _Direction:Boolean = false;//預設圖向左  因此向左為false 向右為true  Note : Alive模式才有用
		
		private var _HeadDir:Boolean = false;
		private var _BodyDir:Boolean = false;
		private var _AddStamp:Boolean = false;
		
		public var _ReadyNotifyAddress:Function;
		
		private var _CurrentStamp:String = "";//當前蓋章狀態
		
		private var _IDSplit:String;
		
		private var _CacheMonsterMotionController:CacheMonsterMotionController;
		
		public function MonsterDisplay( _InputMonsterData:Object , _InputAlive:Boolean = false , _InputIDSplit:String = "" ) {
			this.UpdateMonsterValue( _InputMonsterData );
			this._Alive = _InputAlive;
			this._IDSplit = _InputIDSplit;
		}
		
		public function UpdateMonsterValue( _InputMonsterData:Object ):void {
			/*
			 * _picItem//頭像素材KEY
			 * _motionItem//動態素材KEY
			*/
			this._MonsterData = _InputMonsterData;
			
			this._MonsterID = this.MonsterData._guid;
			this._MonsterComponentKey = this._MonsterData._motionItem;
			
			this._MonsterHead.name = this._MonsterData._guid;
			this._MonsterBody.name = this._MonsterData._guid;
			
		}
		
		
		public function Clear():void {
			/*if ( this._MonsterHead != null && this._MonsterHead.parent != null ) {
				this._MonsterHead.parent.removeChild( this._MonsterHead );
				this._MonsterHead = null;
			}*/
			
			/*if ( this._MonsterBody != null && this._MonsterBody.parent != null ) {
				this._MonsterBody.parent.removeChild( this._MonsterBody );
				this._MonsterBody = null;
			}*/
			
			
			this.ClearContent( this._MonsterBody );
			this.ClearContent( this._MonsterHead );
			
			if ( this._MotionController != null ) {//確保控制類被清乾淨
				this._MotionController.Destroy();
				this._MotionController = null;
			}
			
			if ( this._DisplayCache != null ) {//確保控制類被清乾淨
				this._DisplayCache.Destroy();
				this._DisplayCache = null;
			}
			
			this._ComponentAdded = false;
		}
		
		public function Destroy():void {
			this.Clear();
			this._MonsterData = null;
			this._MonsterBody = null;
			this._SourceProxy = null;
			this._MonsterClipDepot = null;
			//this._DisplayCache = null;
			//this._MotionController = null;
			this._ReadyNotifyAddress = null;
			this._InnerBody = null;
			
			if ( this._MotionController != null ) {//確保控制類被清乾淨
				this._MotionController.Destroy();
				this._MotionController = null;
			}
			
			if ( this._CacheMonsterMotionController != null ) {
				this._CacheMonsterMotionController.Destroy();
				this._CacheMonsterMotionController = null;
			}
			
			if ( this._DisplayCache != null ) {//確保控制類被清乾淨
				this._DisplayCache.Destroy();
				this._DisplayCache = null;
			}
			
			this.clearStampSetting();
		}
		
		public function ShowContent():void {
			this._DisplayCache == null ? this.SetDisplayCache() : null;
			this._DisplayCache.StartLoad();
		}
		
		private function SetDisplayCache():void {
			this._DisplayCache = new DisplayCache( this._MonsterComponentKey , this._MonsterBody , this.GetContentShown , this._BodySize , 10 );
			this._DisplayCache.AddExtraSyncCacheContainer( this._MonsterHead , this._HeadSize );
		}
		
		private function GetContentShown( _InputComponentKey:String ):void {
			//當素材回來時
			if ( this._ComponentAdded == false ) {//當素材已加過便不能再加
				//this._DisplayCache = null;//130114
				var _Head:Sprite = new ( this._SourceProxy.GetMaterialSWP( this._MonsterComponentKey , this._HeadClassName ) as Class );
				var _Body:DisplayObjectContainer;
				this.Reverse( _Head , this._HeadDir , this._HeadSize );//靜態頭像轉向
				if ( this._Alive == false ) {//當為非動態狀態時  
					//只給靜態圖
					var _BodySprite:Sprite = new ( this._SourceProxy.GetMaterialSWP( this._MonsterComponentKey , this._BodyClassName ) as Class );
					//var _BodySprite:Sprite = this._MonsterClipDepot.Inquiry( this._SourceProxy.GetMaterialSWP( this._MonsterComponentKey , this._BodyClassName ) as Class , Sprite );
					_Body = _BodySprite;
					this.Reverse( _Body , this._BodyDir , this._BodySize );//靜態身體轉向
				}else {
					//var _SourceClip:MovieClip = new ( this._SourceProxy.GetMaterialSWP( this._MonsterComponentKey , this._BodyClassName ) as Class );
					var _SourceClip:MovieClip = this._MonsterClipDepot.Inquiry( this._SourceProxy.GetMaterialSWP( this._MonsterComponentKey , this._BodyClassName ) as Class , MovieClip );
					this._MotionController = new MonsterMotionController( this._MonsterID , this._MonsterComponentKey , _SourceClip , this._IDSplit );//加入動態控制
					this._CacheMonsterMotionController ||= new CacheMonsterMotionController();
					this._CacheMonsterMotionController.UpdateMonsterMotionController( this._MotionController );
					//this._MotionController.Direction = this._BodyDir;//130306
					var _BodyClip:MultiSpriteVision = this._MotionController.MotionClip;//動態容器
					_Body = _BodyClip;
				}
					
					_Head.alpha = 0;
					_Body.alpha = 0;
					
				_Head.name = this._HeadClassName;
				_Body.name = this._BodyClassName;
				
				this._InnerBody = _Body;
				//this._MonsterHead == null ? this._MonsterHead = new Sprite() : null;
				//this._MonsterBody == null ? this._MonsterBody = new Sprite() : null;
				this._MiddleBody = new Sprite();
				this._MiddleBody.name = this._BodyClassName;
				this._MiddleBody.addChild( _Body );//為避免遇外層遮罩衝突  因此將其層級分開
				
				this._MonsterHead.addChild( _Head );
				this._MonsterBody.addChild( this._MiddleBody );
				
					
					TweenLite.to( _Head , 1 , { alpha:1 , ease:Quad.easeOut } );
					TweenLite.to( _Body , 1 , { alpha:1 , ease:Quad.easeOut } );
				
				this._ComponentAdded = true;
				
				MonsterUtilities.AddInnerShadowFilter( this._MiddleBody );//130411加入內影遮罩  //為避免遇外層遮罩衝突  因此將其層級分開   使用_MiddleBody做內層遮罩
				//this.AddShadow();
				
				
			}//end if
			
			//----------Send Ready Notify
			( this._ReadyNotifyAddress != null ) ? this._ReadyNotifyAddress( this._MonsterID ) : null;
			this._ReadyNotifyAddress = null;
			
			this.JudgeStampStatus();//每次執行時都做狀態判斷更新
			
		}//end GetContentShown
		
		
		//--------------------------------------------------------commands
		public function AddShadow():void {
			MonsterUtilities.AddBodyShadow( this._MonsterBody );//130411//加入影子
		}
		
		public function RemoveShadow():void {
			MonsterUtilities.RemoveBodyShadow( this._MonsterBody );//130411//移除影子
		}
		
		//----------------------------------------------END-------commands
		
		//--------------------------------------------------------getters
		public function get MonsterID():String {
			return _MonsterID;
		}
		
		public function get MonsterData():Object {
			return this._MonsterData;
		}
		
		public function get MonsterHead():Sprite {
				//this.ShowContent();
			return this._MonsterHead;
		}
		
		public function get MonsterBody():Sprite {
				//this.ShowContent();
			return this._MonsterBody;
		}
		
		public function get HeadSize():uint {
			return this._HeadSize;
		}
		
		public function get BodySize():uint {
			return this._BodySize;
		}
		
		//public function get Motion():MonsterMotionController {
		public function get Motion():CacheMonsterMotionController {
			//要檢查怪物素材回來了沒
			//要檢查_MotionController 有沒有New過
			//return this._MotionController != null ? this._MotionController : new FakeMonsterMotionController() as MonsterMotionController;
			//return this._MotionController;
			return this._CacheMonsterMotionController ||= new CacheMonsterMotionController();
		}
		
		public function get Alive():Boolean {
			return this._Alive;
		}
		
		public function get HeadDir():Boolean {
			return this._HeadDir;
		}
		
		public function get BodyDir():Boolean {
			return this._BodyDir;
		}
		
		public function get AddStamp():Boolean {
			return this._AddStamp;
		}
		
		public function get CurrentStamp():String {
			return _CurrentStamp;
		}
		//--------------------------------------------END---------getters
		
		//--------------------------------------------------------setters
		public function set Alive( value:Boolean ):void {
			if ( this._Alive != value ) {//當狀態不同時才做改變
				this._Alive = value;
				this.Clear();//刷掉既有的內容物
				this.ShowContent();//重新啟始容器
			}
		}
		
		
		
		public function set HeadDir(value:Boolean):void {
			if ( this._HeadDir != value ) {//當狀態不同時才做改變
				this._HeadDir = value;
				var _Target:DisplayObjectContainer = this._MonsterHead.getChildByName( this._HeadClassName ) as DisplayObjectContainer;
				( _Target != null ) ? this.Reverse( _Target , this._HeadDir , this._HeadSize ) : null;
			}
		}
		
		
		
		public function set BodyDir(value:Boolean):void {
			//_BodyDir = value;
			if ( this._BodyDir != value ) {//當狀態不同時才做改變
				this._BodyDir = value;
				var _Target:DisplayObjectContainer = this._MonsterBody.getChildByName( this._BodyClassName ) as DisplayObjectContainer;
				( _Target != null ) ? this.Reverse( _Target , this._BodyDir , this._BodySize ) : null;
				//this._MotionController != null ? this._MotionController.Direction = this._BodyDir : null;
			}
		}
		
		public function set HeadAndBodyDir( value:Boolean ):void {
			this.HeadDir = value;
			this.BodyDir = value;
		}
		
		
		/*public function set ReadyNotifyAddress( value:Function ):void {
			this._ReadyNotifyAddress = value;
		}*/
		
		
		
		public function set AddStamp( value:Boolean ):void {
			
			if ( this._AddStamp != value ) {//當狀態不同時才做改變
				this._AddStamp = value;
				this.JudgeStampStatus();
			}
		}
		
		//--------------------------------------------END---------setters
		
		
		
		private function Reverse( _InputTarget:DisplayObjectContainer , _InputDirection:Boolean , _InputSize:uint ):void {
			//false = 預設(向左)		true = 轉向(向右)
			var _Value:Number = Math.abs( _InputTarget.scaleX );
			if ( _InputDirection == true ) {
				_Value = -_Value;
				_InputTarget.x = _InputSize;
			}else {
				_InputTarget.x = 0;
			}
			_InputTarget.scaleX = _Value;//( _InputDirection == true ) ?  -Math.abs( _InputTarget.scaleX ) : Math.abs( _InputTarget.scaleX );
		}
		
		//-------------------------------------------------Cache Status
		
		private function ClearContent( _InputTarget:Sprite ):void {
			/*while ( _InputTarget.numChildren > 0 ) {
				_InputTarget.removeChildAt( 0 );
			}*/
			_InputTarget.removeChildren();
		}
		//--------------------------------------END--------Cache Status
		
		
		//-----------------------------------------------------------------------------------------in MonsterStatusStamp.as
		
		
		//-----------------------------------------------------------------------------END---------in MonsterStatusStamp.as

		
	}//end class
}//end package


import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterMotionController;
class CacheMonsterMotionController {
	//private static var _CacheMonsterMotionController:CacheMonsterMotionController;
	
	private var _MonsterMotionController:MonsterMotionController;
	
	private var _ActionHistroy:Vector.<Array>;
	
	public function CacheMonsterMotionController():void {
		this._ActionHistroy = new Vector.<Array>();
	}
	
	/*public static function GetInstance():CacheMonsterMotionController {
		return CacheMonsterMotionController._CacheMonsterMotionController ||= new CacheMonsterMotionController();
	}*/
	
	public function UpdateMonsterMotionController( _InputMonsterMotionController:MonsterMotionController ):void {
		this._MonsterMotionController = _InputMonsterMotionController;
		this.ExecuteRecord();
	}
	
	private function Record( ..._Arguments ):void {
		this._ActionHistroy.push( _Arguments );
	}
	
	private function ExecuteRecord():void {
		while ( this._ActionHistroy.length > 0 ) {
			this.ExecutionNavigator( this._ActionHistroy[ 0 ] );
			this._ActionHistroy.shift();
		}
	}
	
	private function ExecutionNavigator( _InputArguments:Array ):void {
		switch ( _InputArguments[ 0 ] ) {
			case "Act":
					this._MonsterMotionController.Act( _InputArguments[ 1 ] );
				break;
				
			case "Stop":
					this._MonsterMotionController.Stop();
				break;
				
			case "Direction":
					this._MonsterMotionController.Direction = _InputArguments[ 1 ];
				break;
				
			default:
				break;
		}
	}
	
	public function Act( _InputAction:String ):void {
		this._MonsterMotionController != null ? this._MonsterMotionController.Act( _InputAction ) : this.Record( "Act" , _InputAction );
	}
	
	public function Stop():void {
		this._MonsterMotionController != null ? this._MonsterMotionController.Stop() : this.Record( "Stop" );
	}
		
	public function set Direction( value:Boolean ):void {
		this._MonsterMotionController != null ? this._MonsterMotionController.Direction = value : this.Record( "Direction" , value );
	}
	
	public function Destroy():void {
		this._MonsterMotionController = null;
		this._ActionHistroy = null;
	}
	
	
	
}//end class


