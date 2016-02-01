package Spark.MVCs.Models.NetWork 
{
	/**
	 * ...
	 * @author K.J. Aris
	 */
	import MVCprojectOL.ModelOL.Vo.Guide;
	import Spark.MVCs.Models.NetWork.AmfConnection.NetResultPack;
	//import MVCprojectOL.ModelOL.SkillWarehouse.Vo.Skill;
	
	public class VoSimulatorOther {
		
		public static function SkillVo():NetResultPack {
			var _SimulateResult:NetResultPack = new NetResultPack();
				//_SimulateResult.SendNotification();
				_SimulateResult._Signature = "Get_AllSkill";
				_SimulateResult._ResultDataType = "Skill";
				_SimulateResult._ServerStatus = "OK";
					var _SkillList:Array = new Array();
					var _Skill:Skill;
					for ( var i:int = 0; i < 76; i++ ) {
						
							_Skill = new Skill();
							_Skill._guid = String( 3010000 + i );
							_Skill._effectKey = String( 100 + i );
							_Skill._info = "Simulate Skill " + i;
							_Skill._name = "Skill " + i ;
							_Skill._type = String( 402 + i );
							_Skill._picKey = String( 503 + i );
							_Skill._soundKey = { "Active":901002 , "Hit":901003 , "End":901004 };
						
						_SkillList[ i ] = _Skill;
					}
				_SimulateResult._Result = _SkillList;
				
			return _SimulateResult;
		}//end func SkillVo
		
		
		
		public static function GuideVo():NetResultPack {
			var _SimulateResult:NetResultPack = new NetResultPack();
				//_SimulateResult.SendNotification();
				_SimulateResult._Signature = "Get_GuideList";
				_SimulateResult._ResultDataType = "Guide";
				_SimulateResult._ServerStatus = "OK";
					var _GuideList:Array = new Array();
					var _Guide:Guide;
					for ( var i:int = 0; i < 76; i++ ) {
						
							_Guide = new Guide();
							_Guide._Guid = String( 3010000 + i );
							/*_Guide._effectKey = String( 100 + i );
							_Guide._info = "Simulate Guide " + i;
							_Guide._name = "Guide " + i ;
							_Guide._type = String( 402 + i );
							_Guide._picKey = String( 503 + i );
							_Guide._soundKey = { "Active":901002 , "Hit":901003 , "End":901004 };*/
							_Guide._Read = false;
							_Guide._ContentPage = [ "901002" , "901003" , "901004" ];
						
						_GuideList[ i ] = _Guide;
					}
				_SimulateResult._Result = _GuideList;
				
			return _SimulateResult;
		}//end func SkillVo
		
		
		
		
	}//end class

}//end package