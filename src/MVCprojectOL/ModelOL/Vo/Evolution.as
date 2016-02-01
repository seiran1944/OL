package MVCprojectOL.ModelOL.Vo 
{
	import MVCprojectOL.ModelOL.Vo.Template.BasicVaule;
	
	/**
	 * ...
	 * @author EricHuang
	 * 
	 * 怪獸進化表配方
	 */
	public class Evolution extends BasicVaule
	{
		//---_lvBg=進化色階(要改成_rank)
		public var _rank:int = 0;
		
		public var _jobName:int = 0;
		public var _jobPic:String = "";
		
		//---完成品
		public var _picItem:String = "";
		
		public var _needLv:int = 0;
		
		//public var _needStoneMax:int = 0;
		
		public var _targetGroupID:String = "";
		//-- 
		public var _needMonsterNum:int = 1;
		
		public var _motionItem:String;
		
		public var _soul:int = 0;
		
		public var _uintTimes:uint = 0;
		
		//---第一階進化=空陣列(需與_lvBG做比對)
		//-物件陣列--{(物品的)_groupGuid:String,_number:int,_picItem:String,_showInfo:String,_showName:String}(用原型來判斷)
		public var _aryNeedSourceA:Array = [];
		public var _aryNeedSourceB:Array = [];
		
		public var _showInfo:String = "";
		
		
	}
	
}