package MVCprojectOL.ModelOL.MissionCenter.MissionCalculateCore
{
	import MVCprojectOL.ModelOL.MissionCenter.MissionCalculateCore.IfMission.IfCalculate;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MisCalculateCore implements IfCalculate 
	{
		//--計算清單本體
		protected var _misCalculate:MissionCalculateBase;
		protected var _aryReturn:Array = [];
		protected var _funSingleMissionCondition:Function;
		public function injectionTarget(_class:MissionCalculateBase,_fun:Function):void 
		{
			//---用來計算的清單
			this._misCalculate = _class;
			//---取得吻合條件的任務條件清單
			this._funSingleMissionCondition = _fun;	
			
		}
		
		public function Calculate(_class:*):void 
		{
			//---用來轉型---(累加條件區域)
			//---一累加完一項~就去檢查是否完成
			//---有正確完成到的任務ID就推進去--
		}
		
		//---override this-----(class)
		public function checkCompleteHandler(_class:*,_aryMissionCondition:Array):void 
		{
			//--用迴圈去掃比對該任務需要的條件(用當前去檢察該任務的需求條件)
			//---完成就把[MissionConditionComplete]推入_aryReturn
		}
		
		//--取得剛剛確實加總的計算任務---
		public function GetCanCalculate():Array 
		{
			return this._aryReturn;
		}
		
		
	}
	
}