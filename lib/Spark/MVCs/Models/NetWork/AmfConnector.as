package  Spark.MVCs.Models.NetWork {
	
	/**
	 * @Engine Ignitor
	 * @author K.J. Aris
	 * @version 12.12.05.10.20 
	 * @FlashPlayerVersion 11.2
	 * @Note This module core is doing Amf connection routines.
	 */
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Proxy;
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.MVCs.Models.NetWork.ConnectionControl.ConnectionManager;
	import Spark.MVCs.Models.NetWork.ConnectionControl.ConnectionRequest;
	import Spark.MVCs.Models.NetWork.ConnectionVariableDefinition;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	import Spark.Utils.GlobalEvent.EventExpress;
	
	
	
	//import Spark.MVCs.Models.NetWork.AmfConnection.ConnectionVariableDefinition;
	//import Spark.MVCs.Models.NetWork.AmfConnection.ConnectionControl.ConnectionManager;
	//import Spark.MVCs.Models.NetWork.AmfConnection.ConnectionControl.ConnectionRequest;
	//import Spark.MVCs.Models.NetWork.AmfConnection.NetResultPack;
	//import NetWork.GlobalEvent.EventExpress;
	
	/*import Spark.CommandsStrLad;
	import Spark.coreFrameWork.Interface.IfProxy;
	import Spark.coreFrameWork.ProxyMode.ProxY;*/
	//import Spark.MVCs.Models.SkillWarehouse.Vo.Skill;
	//import Spark.MVCs.Models.NetWork.AmfConnection.VoSimulator;
	
	//import Spark.utils.GlobalEvent.EventExpress;
	
	public final class AmfConnector extends ProxY{
		
		public const _PackageInf:String = " * From Package AmfConnector.as ";//for debug
		public const _ActionMessage:String = " #ver 12.11.23.11.52 : ";//for debug
		
		//---------------Native	Pointer
		private static var _AmfConnector:AmfConnector;//static pointer for singleton pattern
		
		private var _GatewayThisCatched:String;
		private var _VoHarbor:String;//AmfPhp的Vo接口
		private var _VoGroupHarbor:String;
		
		private const _ServerConnection:NetConnection = new NetConnection();
		private const _DefaultResponder:Responder = new Responder( DefaultResponder_hasResult , DefaultResponder_noResult );
		
		private var _ConnectionManager:ConnectionManager;//connection controller
		
		
		public static function GetInstance():AmfConnector {//IfProxy
			return AmfConnector._AmfConnector = ( AmfConnector._AmfConnector == null ) ? new AmfConnector() : AmfConnector._AmfConnector; //singleton pattern
		}
		
		// constructor
		public function AmfConnector() {
			super( CommandsStrLad.Proxy_NetWork , this );
			AmfConnector._AmfConnector = this;//singleton pattern
			
			//trace( _PackageInf + _ActionMessage + " * AmfConnection constructed !!" );
		}
		
		//----buildTest-----
		//public function GetHello():String { return "helloAMF_Connector" };
		
		//=========================================================AMF connection
		
		/**
		 * @Function : To initialize AMF Connection .
		 * @param	_InputGateway:String	=	AMF gateway.
		 * @param	_InputSettingFile:ConnectionVariableDefinition	=	a setting file including Vo mapping settings , inherit ConnectionVariableDefinition to define your outside settings.
		 */
		public function Connect( _InputSettingFile:ConnectionVariableDefinition = null ):void {
			
			this.GetInitSetting( _InputSettingFile );//initialize variables
			
			//this._GatewayThisCatched = ( _InputGateway == null ? this._GatewayThisCatched : _InputGateway );
			this._ServerConnection.hasEventListener( NetStatusEvent.NET_STATUS ) == false ? this._ServerConnection.addEventListener( NetStatusEvent.NET_STATUS , netStatusHandler ) : null;
			( _ServerConnection.connected == false ) ? this._ServerConnection.connect( this._GatewayThisCatched ) : null;
			this._ConnectionManager = ( this._ConnectionManager == null ) ? new ConnectionManager( this._ServerConnection ) : this._ConnectionManager;
			trace( "Server Connection Status : " + _ServerConnection.connected , this._GatewayThisCatched );
		}
		
		private function GetInitSetting( _InputSettingFile:ConnectionVariableDefinition = null ):void {
			_InputSettingFile == null ? ConnectionVariableDefinition.GetInstance() : ConnectionVariableDefinition._ConnectionVariableDefinition = _InputSettingFile;
			this._GatewayThisCatched = ConnectionVariableDefinition._ConnectionVariableDefinition.GateWay;
			this._VoHarbor = ConnectionVariableDefinition._ConnectionVariableDefinition._VoServiceFunction;
			this._VoGroupHarbor = ConnectionVariableDefinition._ConnectionVariableDefinition._VoGroupServiceFunction;
			ConnectionVariableDefinition._ConnectionVariableDefinition.InitVoMapping();//initialize VO mapping
		}
		
		private function netStatusHandler( EVT:NetStatusEvent ):void {
			/*switch (EVT.info.code){
				case "NetConnection.Connect.Success":               
						trace("GGG");
					break;   
					
				case "NetGroup.Connect.Success":                    
						trace("GGG2");
					break;
					
				default:                    
						trace("EVT.info.code : " + EVT.info.code);           
					break;
			}  */       
			//trace("NetConnection Status : " + EVT.info.code);
			trace( " NetConnection Status : " , this._ConnectionManager.CurrentCaller , EVT.info.code );//121205
		}
		
		public function Disconnect( ):void{
			_ServerConnection.close();
			_ServerConnection.removeEventListener( NetStatusEvent.NET_STATUS , netStatusHandler );
		}
		
		
		//=================================Call
		/**
		 * @Function : To call AMF by directive function .
		 * @param	_InputAmfFunction:String	=	AMF function name.
		 * @param	_InputValue:*	=	values for server.
		 */
		public function Call( _InputAmfFunction:String , _InputRespondingFunction:Function = null , ..._InputValue ):void{//, _InputRespondingFunction:Function = null
				var _CurrentResponder:Responder = (_InputRespondingFunction != null) ? new Responder( _InputRespondingFunction , DefaultResponder_noResult ) : _DefaultResponder;
				this._ConnectionManager != null ? this._ConnectionManager.AddCall( new ConnectionRequest( _InputAmfFunction , _CurrentResponder , _InputValue ) ) : null;
		}
		
		/**
		 * @Function : To call AMF by VO .
		 * @param	_InputVo:*	=	a requesting VO for server. Server will repond with a connection VO.
		 */
		public function VoCall( _InputVo:* ):void {
				this._ConnectionManager != null ? this._ConnectionManager.AddCall( new ConnectionRequest( this._VoHarbor , this._DefaultResponder , [ _InputVo ] ) ) : null;
		}
		
		/**
		 * @Function : Add VO into a requesting queue waiting to send together with the group.
		 * @param	_InputVo:*	=	a requesting VO for server. Server will repond with a connection VO.
		 * @param _InstantCall:Boolean =  	true : add current request into requesting queue and launch the group,		false : add current request into requesting queue until "function SendVoGroup()" launch the group.
		 */
		public function VoCallGroup( _InputVo:* , _InstantCall:Boolean = false ):void {
			if ( this._ConnectionManager != null ) {
				this._ConnectionManager.addGroupCall( _InputVo );
				( _InstantCall == true ) ? this.SendVoGroup() : null;
			}
			//Note : when "_InstantCall = true" , will trigger the launch , ConnectionManager will send out entire requesting queue including current request.	12.11.27 K.J. Aris
		}
		
		
		/**
		 * @Function : Launch current requesting queue to AMF.
		 */
		public function SendVoGroup():void {//使用VO群組連線
			if ( this._ConnectionManager.GroupCallVo != null ) {
				if ( this._ConnectionManager.GroupCallVo._requestQueue.length > 0 ) {//當請求清單多於一筆時才發送請求	
					this._ConnectionManager != null ? this._ConnectionManager.AddCall( new ConnectionRequest( this._VoGroupHarbor , this._DefaultResponder , [ this._ConnectionManager.GroupCallVo ] ) ) : null;//將requestQueue加入連線請求內
					this._ConnectionManager.clearGroupCall();//清除已發送的requestQueue
				}
			}else {
				trace( "There's no any net requesting in Vo Group !!" , this );
			}
		}
		//=========================END=====Call
		
		//================================Connection queue operations
		/** * @Function : To active queue transmission in "Manual" mode.*/
		public function StartQueue():void {
			this._ConnectionManager != null ? this._ConnectionManager.StartQueue() : null;
		}
		
		/** * @Function : To stop queue transmission in "Manual" mode. */
		public function StopQueue():void {
			this._ConnectionManager != null ? this._ConnectionManager.StopQueue() : null;
		}
		
		
		//=========================END====Connection queue operations
		
		
		
		//=================================Responder operations
		private function DefaultResponder_hasResult( _InputResult:* ):void {
			trace( _PackageInf + _ActionMessage + " * Default Responder - Has Result : " + _InputResult );
			//_InputResult.PrintResult();
			//this.SendNotify( CommandsStrLad.Notification_onNetResult , _InputResult );
			
			/*var _ResultDataType:String = getQualifiedClassName( _InputResult ).split( "::" )[1];
			( _ResultDataType == "NetResultPack" || _ResultDataType == "NetResultPackGroup" ) ? _InputResult.SendNotification() : null;*/
			
			//EventExpress.DispatchGlobalEvent( NetEvent.NetResult , _InputResult._ReplyDataType , NetResultPack( _InputResult ) , _InputResult._Signature , false );
			
			_InputResult.SendNotification();
			//trace( _InputResult );
		}
		
		private function DefaultResponder_noResult( _InputResult:* ):void {
			trace( _PackageInf + _ActionMessage + " * Default Responder - No Result : " + _InputResult );
			//this.SendNotify( CommandsStrLad.Notification_onNetError , _InputResult );
			for ( var i:* in _InputResult ) {
				trace( _InputResult[i] );
			}
			//trace( getQualifiedClassName( new NetResultPack() ).split( "::" )[1] );//
			
			//var _SimulateResult:NetResultPack = VoSimulator.GuideBuild();
			//var _SimulateResult:NetResultPack = VoSimulator.SkillVo();
			//var _SimulateResult:NetResultPack = VoSimulator.GuideVo();
			//EventExpress.DispatchGlobalEvent( NetEvent.NetResult , _SimulateResult._ReplyDataType , NetResultPack( _SimulateResult ) , _SimulateResult._Signature , false );
		}
		//=========================END=====Responder operations
		
		
		
		
		//==========================================Variables Operation
		/** * @Function : set queue transmission mode.*/
		public function set ConnectMode(value:String):void {
			this._ConnectionManager != null ? this._ConnectionManager.Mode = value : null;
		}
		
		/** * @Function : get current queue transmission mode.*/
		public function get ConnectMode():String {
			return this._ConnectionManager != null ? this._ConnectionManager.Mode : "Error : Not Ready !!";
		}
		
		
		/** * @Function : set queue transmission rate.*/
		public function set QueueExecutionPeriod(value:uint):void {
			( this._ConnectionManager != null ) ? this._ConnectionManager.QueueExecutionPeriod = value : null;
		}
		
		/** * @Function : get queue transmission rate.*/
		public function get QueueExecutionPeriod():uint {
			return ( this._ConnectionManager != null ) ? this._ConnectionManager.QueueExecutionPeriod : 0;
		}
		
		
		public function get currentGroupRequestingList():Array {
			return ( this._ConnectionManager != null ) ? this._ConnectionManager.currentGroupRequestingList : null;
		}
		//====================================END===Variables Operation
		
		
	}//end class
	
}//end package
