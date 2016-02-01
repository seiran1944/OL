package MVCprojectOL.ModelOL.Vo
{
	import MVCprojectOL.ModelOL.Vo.Template.BasicVaule;
	
	/**
	 * ...
	 * @author EricHuang
	 * 用於所有有關怪獸的數值增減回傳
	 */
	public class ReturnMonster extends BasicVaule  
	{
		//----1.EXP改變2.HP改變3.ENG改變4吃石頭後5.使用掛賣6.技能學回來7.裝備狀態改變8.怪獸穿裝備9.其他的使用狀態.10>CD回復HP/ENG 11.進化刷技能
		public var _type:int = -1;
		
		//----monsterGroup--
		public var _gruopGuid:String = "";
		//--PS--5屬性用在[吞食石頭使用/技能/裝備]
		//---_HP用在改變的HP
		//---_guid=怪獸的guid
		public var _stoneId:String = "";
		
		public var _skillId:String = "";
		//---裡面放key物件----{_gruopGuid:String,_guid:String}-物件陣列/---2013/1/28
		//---物件陣列(目前該怪獸身上所有的裝備)
		public var _aryEqu:Array = [];
		//---(脫掉)裡面放key物件----{_gruopGuid:String,_guid:String}-物件陣列/---2013/4/15
		public var _removeEqu:Object;
		
		//----HP/EXP/ENG的改變回總質即可
		//---經驗值
		public var _EXP:int = 0;
		
		public var _monsterLV:int = 0;
		//---疲勞度
		public var _ENG:int = 0;
		
		//---使用狀態
		public var _useing:int = 0;
		
		//----生命值最大值
		public var _hpMax:int = 0;
		//----2013/2/22--替換的技能
		public var _chageSkill:String = "";
		// 上次回復血量時間
		public var _health_regen_date:uint = 0;
		// 上次回復疲勞值時間
		public var _fatigue_regen_date:uint = 0;	
		
	}
	
}