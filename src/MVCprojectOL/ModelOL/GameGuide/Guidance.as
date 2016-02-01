package MVCprojectOL.ModelOL.GameGuide {
	/**
	 * ...
	 * @author K.J. Aris
	 */
	import flash.utils.Dictionary;
	
	import MVCprojectOL.ModelOL.Vo.Guide;
	import MVCprojectOL.ModelOL.Vo.Get.Get_GuideList;
	import MVCprojectOL.ModelOL.Vo.Set.Set_GuideReadRecord;
	import MVCprojectOL.ModelOL.GameGuide.GuideEvent;
	
	import Spark.coreFrameWork.ProxyMode.ProxY;
	
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	 
	public class Guidance {//extends ProxY
		private static var _Guidance:Guidance;
		
		private var _Net:AmfConnector;
		
		private var _GuideList:Dictionary = new Dictionary();
		
		private var _Ready:Boolean = false;
		
		public static function GetInstance():Guidance {
			return Guidance._Guidance = ( Guidance._Guidance == null ) ? new Guidance() : Guidance._Guidance; //singleton pattern
		}
		
		public function Guidance() {
			Guidance._Guidance = this;
			this._Net = AmfConnector.GetInstance();
			trace( "Guidance constructed !!" );
		}
		
		
		public function CheckGuide( _InputKey:String ):void {
			//每次開啟區域或頁面時，須執行這個function 來檢查是否有導引   若有  則此函式會自動發出開啟訊號
			//var _CheckStatus:Boolean = false;
			if ( this._Ready == true && this._GuideList[ _InputKey ] != null ) {
				
				if ( this._GuideList[ _InputKey ]._Read == false ) {
					//FirstOpen
					this.SetGuidePageReadRecord( this._GuideList[ _InputKey ] );	
					this.OpenGuidePage( _InputKey );
				}
				
			}
			
		}
		
		public function OpenGuidePage( _InputKey:String ):void {
			if ( this._Ready == true && this._GuideList[ _InputKey ] != null ) {
				//this.SendNotify( GuideEvent.OpenGuidePage , this._GuideList[ _InputKey ] );//發送開啟導引訊息給View
				( this._GuideList[ _InputKey ]._Read == false ) ? this.SetGuidePageReadRecord( this._GuideList[ _InputKey ] ) : null;
			}
		}
		
		
		private function SetGuidePageReadRecord( _InputGuide:Guide ):void {
			//回寫已讀記錄
			_InputGuide._Read = true;
			//this._Net.VoCall( new Set_GuideReadRecord( _InputGuide._Guid , _InputGuide._Read ) );
			this._Net.Call( "new Set_GuideReadRecord( _InputGuide._Guid , _InputGuide._Read )" );
		}
		
		
		//============================================net work
		public function GetGuideList():void {
			EventExpress.AddEventRequest( NetEvent.NetResult , this.onNetResult , this );
			//this._Net.VoCall( new Get_GuideList() );
			this._Net.Call( "Get_GuideList()" );
		}
		
		private function onNetResult( _Result:EventExpressPackage ):void {
			if ( _Result.Status == "Guide" ) {
				//EventExpress.RevokeEventRequest( NetEvent.NetResult , this.onNetResult );//終結連線事件接收
				EventExpress.RevokeAddressRequest( this.onNetResult );//終結連線事件接收
				var _NetResultPack:NetResultPack =  _Result.Content as NetResultPack;
				this.DeserializeGuideData( _NetResultPack._Result , this._GuideList );
			}
		}
		
		private function DeserializeGuideData( _InputResultContent:* , _InputGuideList:Dictionary ):void {
			for ( var i:* in _InputResultContent ) {
				_InputGuideList[ _InputResultContent[ i ]._Guid ] = _InputResultContent[ i ];
				trace( _InputResultContent[ i ]._Guid , _InputResultContent[ i ] );
			}
			this._Ready = true;
		}
		
		
		//=======================================END==net work
		
		
		public function get Ready():Boolean {
			return _Ready;
		}
		
	}//end class

}//end package