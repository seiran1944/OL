package MVCprojectOL.ModelOL.Vo.MissionVO
{
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class  Mission
	{
	    //----任務狀態/0未接/1接取,未完成/2.完成未領取/3.完成以領取
		public var _status:int = -1;
		
		//---任務類型ID
		public var _typeID:String="";
		//---0509新增任務條件描述
		public var _strCondition:String = "";
		//---任務ID---
		public var _guid:String = "";
		//---任務標題
		public var _title:String = "";
		//----任務說明
		public var _minssionInfo:String = "";
		//-----重複接取
		public var _repeatFlag:Boolean = false;
		//---任務獎勵([MissionReward])
		public var _reward:Array = [];
		//---完成條件(終止任務條件)--[依照條件塞對應的CLASS]
		public var _endCondition:Array=[];
		//---任務前置條件(同上)
		public var _starCondition:Array;
		
		
		/*_typeID
		$lang['mis_type_0'] = '探索';
		$lang['mis_type_1'] = '戰鬥';
		$lang['mis_type_2'] = '導引';
		$lang['mis_type_3'] = '每日';
		$lang['mis_type_4'] = 'PVP';
        */ 
		
		
		/*
		 * 需求條件type定義碼

		0>建築物類(升級操作)
		1>怪獸類
		2>裝備類
		4>素材類(包含玩家基礎-魂 金鑽 皮 木 毛)
		5>鍊金製作
		6>探索
		7>圖書館學習
		8>PVP纇
		9>拍賣商場
		10>時間排程
		11>牢房
		12>烤打
		13>戰鬥
		 * 
		 * 
		*/
	}
	
}