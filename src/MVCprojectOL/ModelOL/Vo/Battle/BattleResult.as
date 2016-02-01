package MVCprojectOL.ModelOL.Vo.Battle
{
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.06.14.14.43
		@documentation 戰報第二頁面所需資料(Client 2 Client)
	 */
	public class BattleResult
	{
		
		public var _battleId:String;//戰鬥編號
		//戰鬥成員Object
		//{
			//_picItem : String 戰鬥惡魔頭像KEY
			//_nowhpValue : int 最後剩餘血量
			//_addExp : int 戰鬥結束後增加的經驗值量
		//}
		public var _aryArmy:Array;//itemDisplay
		public var _aryEnemy:Array;//itemDisplay
		
		//戰鬥掉煉金素材
		//{ _picItem : String  , _amount : int  }
		public var _aryDrop:Array;//itemDisplay
		
		//public var _soulDrop:int;//掉落魂數量
		public var _fightAim:String;//戰鬥區域(type王國) or 對戰對象(type玩家)  // ------------ of no use
		public var _dateTitle:String;//紀錄日期
		
		//[王國]城下廢墟-第5節點戰鬥結果[勝利]
		public var _infoTitle:String;//標題內文
		
		//戰鬥區域: 城下廢墟-第1節點
		public var _typeTitle:String;//標題字串(王國 / 玩家)
		
		//戰鬥結果: 勝利
		public var _resultTitle:String;//勝負結果
		
		public var _battleType:int;//戰鬥的種類 (  1探索 , 2 PVP  )
		
	}
	
}