package MVCprojectOL.ModelOL.LoadingCache {
	//import com.greensock.loading.data.core.DisplayObjectLoaderVars;
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import Spark.CommandsStrLad;
	//import flash.display.DisplayObject;
	//import flash.display.DisplayObjectContainer;
	//import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	import flash.utils.clearTimeout;
	
	
	
	/*import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;*/
	
	/**
	 * ...
	 * @author K.J. Aris
	 * @note This class is a single Display Cache thread , open a loading cache thread by newing this class.
	 * @version 12.12.12.12.12
	 */
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
		
	import Spark.MVCs.Models.SourceTools.Loader.LoadingBar;
	
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	 
	import MVCprojectOL.ModelOL.LoadingCache.RemoteCache;
	 
	public final class DisplayCache extends RemoteCache{
		//vitals
		private var _CacheContainerList:Vector.<DisplayCacheContainer>;
		
		private var _DisplaySize:uint = 64;//64 X 64 it's a square box
		private var _LoadingTweakX:Number = 0;
		private var _LoadingTweakY:Number = 0;
		
		private const _LoadingMarkName:String = "LoadingMark";
		
		public function DisplayCache( _InputComponentKey:String , _InputCacheContainer:Sprite , _InputCompleteAddress:Function , _InputLoadingDisplaySize:uint = 64 , _InputLoadingTweakX:Number = 0 , _InputLoadingTweakY:Number = 0  ) {
			super( _InputComponentKey , _InputCompleteAddress );
			
			this._CacheContainerList = new Vector.<DisplayCacheContainer>();
			this.AddCacheContainer( _InputCacheContainer , _InputLoadingDisplaySize , _InputLoadingTweakX , _InputLoadingTweakY );//add main cache container
			
			this._DisplaySize = _InputLoadingDisplaySize;
			this._LoadingTweakX = _InputLoadingTweakX;
			this._LoadingTweakY = _InputLoadingTweakY;
			
		}
		
		public function AddExtraSyncCacheContainer( _InputCacheContainer:Sprite , _InputLoadingDisplaySize:uint = 64 , _InputLoadingTweakX:Number = 0 , _InputLoadingTweakY:Number = 0 ):void {
			this.AddCacheContainer( _InputCacheContainer , _InputLoadingDisplaySize , _InputLoadingTweakX , _InputLoadingTweakY );
			( this.isWaiting == true ) ? this.AddLoadingBar( _InputCacheContainer , _InputLoadingDisplaySize , _InputLoadingTweakX , _InputLoadingTweakY ) : null;//如果是在等待期加入的快取容器 則直接加入Loading Bar
		}
		
		private function AddCacheContainer( _InputCacheContainer:Sprite , _InputLoadingDisplaySize:uint = 64 , _InputLoadingTweakX:Number = 0 , _InputLoadingTweakY:Number = 0 ):void {
			//( this._CacheContainerList == null ) ? this._CacheContainerList = new Vector.<DisplayCacheContainer>() : null;
			var _NewCacheContainer:DisplayCacheContainer = new DisplayCacheContainer( _InputCacheContainer , _InputLoadingDisplaySize , _InputLoadingTweakX , _InputLoadingTweakY );
			this._CacheContainerList.push( _NewCacheContainer );
		}
		
		override public function Clear():void {
			this.RemoveLoadingStatus();
			this.RevockCheckAndWait();
			
		}
		
		override public function Destroy():void {
			this.Clear();
			this._CompleteAddress = null;
			this._SourceProxy = null;
			for (var i:int = 0; i < this._CacheContainerList.length ; i++) {
				//delete this._CacheContainerList[ i ];
				this._CacheContainerList.pop().Destroy();
			}
		}
		
		override protected function WaitForComponentReturn():void {
			
			//if ( EventExpress.CheckEventRequestStatus( CommandsStrLad.Source_Complete , this.ComponentReturned ) == false ) {
			if ( this._isWaiting == false ) {
				this._isWaiting = true;
				this.AddLoadingStatus();
				EventExpress.AddEventRequest( CommandsStrLad.Source_Complete , this.ComponentReturned , this );
				this._TimeoutID = setTimeout( this.CheckPeriodly , this._RecheckPeriodlyValue , this._ComponentKey );
			}
			
		}//end WaitForComponentReturn

		
		
		
		
		//--------------------------------------------------------getters
		//--------------------------------------------END---------getters
		
		
		//--------------------------------------------------------setters
		//--------------------------------------------END---------setters
		
		
		
		//-------------------------------------------------Display Cache Status
		private function AddLoadingStatus():void {//產生LoadingMark在快取顯示內容上
			//this.AddLoadingBar( this._CacheContainer , this._DisplaySize , this._LoadingTweakX , this._LoadingTweakY );
			var _Length:uint = this._CacheContainerList.length;
			var _CurrentTarget:DisplayCacheContainer;
			for (var i:int = 0 ; i < _Length ; i++) {
				_CurrentTarget = this._CacheContainerList[ i ];
				this.AddLoadingBar( _CurrentTarget._CacheContainer , _CurrentTarget._LoadingDisplaySize , _CurrentTarget._LoadingTweakX , _CurrentTarget._LoadingTweakY );
			}
			
		}
		
		private function RemoveLoadingStatus():void {
			//this.ClearContent( this._CacheContainer );
			var _Length:uint = this._CacheContainerList.length;
			var _CurrentTarget:DisplayCacheContainer;
			for (var i:int = 0 ; i < _Length ; i++) {
				//_CurrentTarget = this._CacheContainerList[ i ];
				_CurrentTarget = this._CacheContainerList.pop();
				this.ClearContent( _CurrentTarget._CacheContainer );
				_CurrentTarget.Destroy();
			}
		}
		
		private function AddLoadingBar( _InputCacheTarget:Sprite , _InputPreloadSize:uint , _InputLoadingTweakX:Number = 0 , _InputLoadingTweakY:Number = 0 ):void {
			
			var _LoadingMarkClass:Class = this._SourceProxy.GetLoadingMark();
			var _CurrentLoadingMark:LoadingBar = new _LoadingMarkClass();
			
				with ( _CurrentLoadingMark ) {
					name = this._LoadingMarkName;
					width = _InputPreloadSize;
					height = _InputPreloadSize;
					x = _InputLoadingTweakX;
					y = _InputLoadingTweakY;
				}
				
			_InputCacheTarget.addChild( _CurrentLoadingMark );
		}
		
		
		private function ClearContent( _InputTarget:Sprite ):void {
			var _CurrentChild:DisplayObject = _InputTarget.getChildByName( this._LoadingMarkName );
				( _CurrentChild != null ) ? _InputTarget.removeChild( _CurrentChild ) : null;
			/*while ( _InputTarget.numChildren > 0 ) {
				_InputTarget.removeChildAt( 0 );
			}*/
		}
		
		//--------------------------------------END--------Display Cache Status
		
	}//end class
}//end package
	
	import flash.display.Sprite;
	class DisplayCacheContainer {
		public var _CacheContainer:Sprite;
		public var _LoadingDisplaySize:uint = 64;
		public var _LoadingTweakX:Number = 0;
		public var _LoadingTweakY:Number = 0;
		
		public function DisplayCacheContainer( _InputCacheContainer:Sprite , _InputLoadingDisplaySize:uint = 64 , _InputLoadingTweakX:Number = 0 , _InputLoadingTweakY:Number = 0 ) {
			this._CacheContainer = _InputCacheContainer;
			this._LoadingDisplaySize = _InputLoadingDisplaySize;
			this._LoadingTweakX = _InputLoadingTweakX;
			this._LoadingTweakY = _InputLoadingTweakY;
		}
		
		public function Destroy():void {
			this._CacheContainer = null;
		}
		
	}//end class DisplayCacheContainer