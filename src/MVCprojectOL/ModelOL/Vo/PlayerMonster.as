package MVCprojectOL.ModelOL.Vo
{
	import MVCprojectOL.ModelOL.Vo.Template.BasicVaule;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class PlayerMonster extends BasicVaule{
		
		//----1.白色, 2.綠色, 3.藍色, 4.藍色+1, 5.藍色+2, 6.藍色+3, 7.粉紅色, 8.金色
		public var _rank:int = 0;
		public var _scaleRate:Number = 0;
		public var _gruopGuid:String = "";
		//---12/6----要替換的技能key---
		public var _chageSkill:String = "";
		
		
		//---圖片(頭像)位置
		public var _picItem:String = "";
		//---連續動作位置
		public var _motionItem:String = "";
		public var _jobName:String = "";
		//---職業圖片----
		public var _jobPic:String = "";
		//----使用狀態-0.刪除, 1.閒置（在巢穴）, 2.溶解中, 3.學習中, 4.戰鬥中, 5.掛賣中-----
		public var _useing:int = 0;
		//---註冊使用時間---
		public var _registerTime:uint = 0;
	    //-----融解所需要的時間
		public var _dissolvedTimes:int = 0;
		//----溶解值
		public var _dissolvedValue:int = 0;
		//----融解要花掉的靈魂
		public var _dissolvedSoul:int = 0;
		//---轉化值
		//public var _ConversionValue:int = 0;
		//----等級數據
	    public var _nowlvValue:int = 0;
		//-----經驗值----
		public var _nowExp:int = 0;
		//----升級需要的經驗值
		public var _upNextExp:int = 0;
		//---該等級可以吃石頭的最大量
		//public var _lvEatStoneValue:int = 0;
		//---目前使用掉的吃石頭限制額度
		public var _eatStoneRange:int = 0;
		//---生命值(當前)
		public var _nowhpValue:int = 0;
		//---生命值(最大值)
		public var _maxhpValue:int = 0;
		//---該怪獸的回復生命值----
		public var _rehpValue:int = 0;
		
		//---疲勞值(當前)
		public var _nowfatigueValue:int = 0;
		//---疲勞值(最大值)
		public var _maxfatigueValue:int = 0;
		
		//-----
	    //_monsterExhaustLimit
		//---正在學習的技能
		public var _nowLearning:int = 0;
		//----所在團隊資訊--
		public var _teamGroup:String = "";
		//---裡面放key---
		public var _arySkill:Array = [];
		//---裡面放key物件----{_gruopGuid:String,_guid:String}-物件陣列
		public var _aryEquipment:Array = [];
		
		//----可以學習技能的種類(字串)
		public var _learnSkill:String = "";
		//----------溶解石頭屬性基礎數值(溶解石)----
		//---攻擊
	    public var _stoneAtk:int = 0;
		//---防禦
	    public var _stoneDef:int = 0;
		//--敏捷
	    public var _stoneSpeed:int = 0;
		//----智力
	    public var _stoneInt:int = 0;
		//---精神
	    public var _stoneMnd:int = 0;
	    public var _stoneHP:int = 0;
		
		
		
	}
	
}