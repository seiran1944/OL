package MVCprojectOL.ModelOL.Explore.Data {
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import strLib.proxyStr.ProxyNameLib;
	import strLib.proxyStr.ProxyPVEStrList;
	
	
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	
	import Spark.coreFrameWork.ProxyMode.ProxY;
	
	import MVCprojectOL.ModelOL.Explore.Data.ExploreDataCenter;
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 12.12.10.13.45
	 */
	
	public class ExploreDataProxy extends ProxY{
		private static var _ExploreDataProxy:ExploreDataProxy;
		
		private var _Net:AmfConnector;
		private var _SkillDataCenter:ExploreDataCenter = ExploreDataCenter.GetInstance();
		
		public static function GetInstance():ExploreDataProxy {//IfProxy
			return ExploreDataProxy._ExploreDataProxy = ( ExploreDataProxy._ExploreDataProxy == null ) ? new ExploreDataProxy() : ExploreDataProxy._ExploreDataProxy; //singleton pattern
		}
		
		public function ExploreDataProxy() {
			ExploreDataProxy._ExploreDataProxy = this;
			super( ProxyNameLib.Proxy_ExploreDataProxy , this );
			trace( "ExploreDataProxy constructed !!" );
		}
		
		override public function onRegisteredProxy():void {
			this._Net = AmfConnector.GetInstance();

			

		}
		
		
		
		private function GetAllSkills():void {
			EventExpress.AddEventRequest( NetEvent.NetResult , this.onNetResult , this );
			//this._Net.Call( "Get_Skills" );
			this._Net.VoCall( new Get_Skills() );
		}
		
		private function TerminateThis():void {
			EventExpress.RevokeAddressRequest( this.onNetResult );
			this.SendNotify( SkillDataEvent.Terminate_GetExploreDataProxy );
		}
		
		private function onNetResult( _Result:EventExpressPackage ):void {
			//trace( "GGGGG" , getQualifiedClassName( _Result.Content ) );
			var _NetResultPack:NetResultPack =  _Result.Content as NetResultPack;
			
			//trace( _Result.Content is NetResultPack );
			//trace( _Result.Content._Signature , _NetResultPack );
			//trace( "QQQQQQQQQQQQQQQ" , _NetResultPack._Signature , _NetResultPack._ReplyDataType , _NetResultPack._ServerStatus );
			//trace( Skill( _NetResultPack._Result[0] ) );
			switch( _Result.Status ) {
				case "Skill":
						//trace( "有技有能" );
						EventExpress.RevokeAddressRequest( this.onNetResult );
						this.DeserializeSkillData( _NetResultPack._result );
						this.SendNotify( ProxyPVEStrList.Skill_SkillListReady );//發出準備好的事件
						this.TerminateThis();
					break;
			}
			
		}
		
		
		private function DeserializeSkillData( _InputResultContent:* ):void {
			//trace( "Skills Writing >>" , _InputResultContent );
			var _CurrentSkill:Skill;
			for ( var i:* in _InputResultContent ) {
				_CurrentSkill = _InputResultContent[ i ] as Skill;
				this._SkillDataCenter.CreateSkill( _CurrentSkill );
				/*trace( "Writing Skill into data pool ====>>>" , _CurrentSkill._guid );
					trace( "		_name :" , _CurrentSkill._name );
					trace( "		_actType :" , _CurrentSkill._actType );
					trace( "		_class :" , _CurrentSkill._class );
					trace( "		_effectKey :" , _CurrentSkill._effectKey );
					trace( "		_executeType :" , _CurrentSkill._executeType );
					trace( "		_iconKey :" , _CurrentSkill._iconKey );
					trace( "		_info :" , _CurrentSkill._info );
					trace( "		_locate :" , _CurrentSkill._locate );
					trace( "		_soundKey :" , _CurrentSkill._soundKey );*/
					
					
				
			}
		}
		
		
		
	}//end class
}//end package