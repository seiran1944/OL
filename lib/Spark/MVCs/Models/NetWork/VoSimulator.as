package Spark.MVCs.Models.NetWork 
{
	/**
	 * ...
	 * @author K.J. Aris
	 */
	import MVCprojectOL.ModelOL.Vo.Building;
	import MVCprojectOL.ModelOL.Vo.Guide;
	//import Spark.MVCs.Models.NetWork.AmfConnection.NetResultPack;
	//import MVCprojectOL.ModelOL.SkillWarehouse.Vo.Skill;
	
	public class VoSimulator {
		/*
		
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
		
		*/
		
		
		/*
		public static  function GuideBuild():NetResultPack 
		{
			var _SimulateResult:NetResultPack = new NetResultPack();
			_SimulateResult._signature = "Get_Building";
			_SimulateResult._replyDataType = "Building";
			_SimulateResult._serverStatus = "OK";
			//var _aryGuid:Array = ["","","","","","","",""];
			//var _aryPic:Array = ["Main0", "Main0", "Main0", "Main0", "Main0", "Main0", "Main0"];
			var _responder:Array = [];
			for (var i:int = 0; i < 8;i++ ) {
				var _build:Building = new Building();
				_build._guid="build"+i;
		        //----顯示名稱的key 
				_build._name="Build[test]"+i;//名稱key
				_build._picKey="Main"+i+1;//實體圖檔key //沒有小icon
				_build._info="";//tip說明key
				_build._status = 0;//建築物狀態( 0 閒置  /  1升級中  /  2建築功能運作中 )
				_build._lv=1;//當前等級
				_build._maxLv=10;//最高等級
				//_build._aryMaterial=[];//升級所需素材 key / amount >>  若無則為空陣列
				_build._aryWorking=[];//  key/_times  ( 溶解所 圖書館 鍊金所 牢房 英靈室 )  >>  若無則為空陣列
				_build._cost=0//升級所耗費金錢
				_build._currentUpCD=0;//當前升級倒數
				_build._needUpCD=0;//升級所需時間
				_build._upgradable=false;//可否升級
				_build._enable=true;//是否可操作該棟建築功能 ( 依照系統預設初始限定起始 ) 任務可能影響建築功能性
				_build._x=0;//座落位置(八種建築八個位置) 會依照格子座標配置
				_build._y=0;//座落位置(八種建築八個位置) 會依照格子座標配置
				_build._width=0;//建築物寬對應格子的數量
				_build._height=0;//建築物高對應格子的數量
				_responder.push(_build);
			}
			
			_SimulateResult._result = _responder;
			
			return _SimulateResult;
			
		}
		
		*/
		
		
		
	}//end class

}//end package