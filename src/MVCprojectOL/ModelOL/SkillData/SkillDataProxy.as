package MVCprojectOL.ModelOL.SkillData {
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import MVCprojectOL.ModelOL.Vo.Get.Get_UpgradeSkills;
	import strLib.proxyStr.ProxyNameLib;
	import strLib.proxyStr.ProxyPVEStrList;
	
	
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	
	import Spark.coreFrameWork.ProxyMode.ProxY;
	
	import MVCprojectOL.ModelOL.Vo.Skill;
	import MVCprojectOL.ModelOL.Vo.Get.Get_Skills;
	import MVCprojectOL.ModelOL.SkillData.SkillDataCenter;
	import MVCprojectOL.ModelOL.SkillData.SkillDataEvent;
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.06.14.14.14
	 */
	
	public class SkillDataProxy extends ProxY{
		private static var _SkillDataProxy:SkillDataProxy;
		
		private var _Net:AmfConnector;
		private var _SkillDataCenter:SkillDataCenter;
		
		private var _ReadyCounter:uint = 0;
		
		public static function GetInstance():SkillDataProxy {//IfProxy
			return SkillDataProxy._SkillDataProxy = ( SkillDataProxy._SkillDataProxy == null ) ? new SkillDataProxy() : SkillDataProxy._SkillDataProxy; //singleton pattern
		}
		
		public function SkillDataProxy() {
			SkillDataProxy._SkillDataProxy = this;
			super( ProxyNameLib.Proxy_SkillDataProxy , this );
			trace( "SkillDataProxy constructed !!" );
		}
		
		override public function onRegisteredProxy():void {
			this._Net = AmfConnector.GetInstance();
			this._SkillDataCenter = SkillDataCenter.GetInstance();
			
			this.GetAllSkills();
			this.GetUpgradeSkills();
		}
		
		
		
		private function GetAllSkills():void {
			EventExpress.AddEventRequest( NetEvent.NetResult , this.onNetResult , this );
			//this._Net.Call( "Get_Skills" );
			this._Net.VoCall( new Get_Skills() );
		}
		
		private function GetUpgradeSkills():void {
			this._Net.VoCall( new Get_UpgradeSkills() );
		}
		
		private function TerminateThis():void {
			EventExpress.RevokeAddressRequest( this.onNetResult );
			this.SendNotify( SkillDataEvent.Terminate_GetSkillDataProxy );
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
						this.DeserializeSkillData( _NetResultPack._result );
						this.CheckReady();
					break;
					
				case "UpgradeSkills":
						this.DeserializeUpgradeSkillData( _NetResultPack._result as Array );
						this.CheckReady();
				break;
			}
			
		}
		
		private function CheckReady():void {
			this._ReadyCounter++;
			if ( this._ReadyCounter >= 2 ) {
				this.SendReady();
			}
		}
		
		private function SendReady():void {
			this.SendNotify( ProxyPVEStrList.Skill_SkillListReady );//發出準備好的事件
			this.TerminateThis();
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
		
		private function DeserializeUpgradeSkillData( _InputUpgradeSkillList:Array ):void {
			this._SkillDataCenter._UpgradeSkillList = _InputUpgradeSkillList;
		}
		
		
	}//end class
}//end package