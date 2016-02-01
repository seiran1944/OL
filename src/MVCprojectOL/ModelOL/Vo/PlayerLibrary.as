package MVCprojectOL.ModelOL.Vo
{
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class PlayerLibrary 
	{
		//---學習所需消耗疲勞度
		public var _learnFatigue:int = 0;
		//--學習需復的魂量
		public var _learnSoul:int = 0;
		//---學習時間
		public var _learnTime:int = 0;
		//=========================================
		//---以ary裡面裝的是<<該建築物等級內可以學習到的技能--key>>
		//---物件陣列>{_type:群組ID,_ary:[技能ID]}
		public var _ary:Array;
		
		
	}
	
}