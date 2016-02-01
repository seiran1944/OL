package MVCprojectOL.ModelOL.LoadingCache {
	//import com.greensock.loading.data.core.DisplayObjectLoaderVars;
	//import com.greensock.easing.Quad;
	//import com.greensock.TweenLite;
	import flash.utils.Dictionary;
	import Spark.CommandsStrLad;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
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
	 * @note This class is a single Remote Cache thread , open a loading cache thread by newing this class.
	 * @version 13.02.19.16.47
	 */
	 
	import MVCprojectOL.ModelOL.LoadingCache.RemoteCache;
	 
	public final class MultiRemoteCache {
		//vitals
		private var _ComponentKeys:Vector.<String>;
		private var _CompleteAddress:Function;
		private var _FailAddress:Function;
		
		private var _isWaiting:Boolean = false;
		
		//private var _ComponentLines:Dictionary;
		
		private var _SelfDestruction:Boolean;
		
		private var _RemoteCache:RemoteCache;
		private var _CurrentIndex:uint = 0;
		
		public var _SingleCompleteAddress:Function;
		
		public function MultiRemoteCache( _InputComponentKeys:Vector.<String> , _InputCompleteAddress:Function , _InputFailAddress:Function = null , _InputSelfDestruction:Boolean = false ) {
			this._ComponentKeys = _InputComponentKeys;
			this._CompleteAddress = _InputCompleteAddress;
			this._FailAddress = _InputFailAddress;
			this._SelfDestruction = _InputSelfDestruction;
			
			//this._ComponentLines = new Dictionary();
		}
		
		/*public function Clear():void {
			this.RevockCheckAndWait();
		}*/
		
		public function StartLoad():void {
			if ( this._isWaiting == false ) {
				this._CurrentIndex = 0;
				this._RemoteCache = ( this._RemoteCache == null && this._ComponentKeys.length > 0 ) ? new RemoteCache( this._ComponentKeys[ this._CurrentIndex ] , this.ComponentReturned , this._FailAddress , this._SelfDestruction ) : this._RemoteCache;
				this._RemoteCache.StartLoad();
			}
		}
		
		public function Stop():void {
			this._RemoteCache != null ? this._RemoteCache.Clear() : null;
			this._SingleCompleteAddress = null;
		}
		
		private function Proceed():void {
			this._CurrentIndex++;
			this._RemoteCache.UpdateComponentKey( this._ComponentKeys[ this._CurrentIndex ] );
			//trace( this._ComponentKeys , "QQBOQB" , this._CurrentIndex );
			
			this._RemoteCache.StartLoad();
		}
		
		private function ComponentReturned( _Result:String ):void {
			//switch( _Result ) {
				//case String( this._ComponentKeys[ this._CurrentIndex ] ) ://如果是這個素材的檔案回來了
						//trace( this._ComponentKeys , "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<回來了" , this._CurrentIndex );
						
						( this._CurrentIndex >= this._ComponentKeys.length - 1 ) ? this.onComplete( this._ComponentKeys[ this._CurrentIndex ] ) : this.Proceed();
						
						this._SingleCompleteAddress != null ? this._SingleCompleteAddress( this._ComponentKeys[ this._CurrentIndex ] ) : null;
					//break;
			//}
		}//end ComponentReturned
		
		
		private function onComplete( _InputLastKey:String ):void {
			this._SingleCompleteAddress = null;
			this._CompleteAddress( _InputLastKey );
			this._RemoteCache != null ? this._RemoteCache.Clear() : null;
			
		}//end GetContentShown
		
		
		
		
		
		//--------------------------------------------------------getters
		public function get isWaiting():Boolean {
			return this._isWaiting;
		}
		//--------------------------------------------END---------getters
		
		
		//--------------------------------------------------------setters
		//--------------------------------------------END---------setters
		
		
		
		//-------------------------------------------------Cache Status
		
		//--------------------------------------END--------Cache Status
		
	}//end class
}//end package