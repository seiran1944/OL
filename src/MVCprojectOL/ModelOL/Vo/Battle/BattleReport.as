package MVCprojectOL.ModelOL.Vo.Battle
{
	import MVCprojectOL.ModelOL.Vo.ItemDrop;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.04.12.10.22
		@documentation 戰報顯示清單的內容數值
	 */
	public class BattleReport 
	{
		public var _battleId:String;//兌換BattleInit的編號
		public var _battleType:int;//戰鬥的種類 ( 0 王國 , 1 PVP , 2探索 )
		public var _isWin:Boolean;//我方是(true)  /  否(false)  勝利
		public var _aryArmy:Array;//我方成員戰鬥結束狀態
		public var _aryEnemy:Array;//敵方成員戰鬥結束狀態
		/*
		戰鬥成員Object
		{
			_picItem : String 戰鬥惡魔頭像KEY
			_showName : String 怪物名稱
			_nowhpValue : int 最後剩餘血量
			_addExp : int 戰鬥結束後增加的經驗值量
		}
		*/
		
		//130412 新增
		public var _date:String;//戰報的歷史時間 年月日時分
		public var _fightAim:String;//戰鬥區域(type王國) or 對戰對象(type玩家)
		
		//public var _soulDrop:int;//掉落魂數量//整合到itemDrop內
		//掉落品的VO //目前主要拿_material 操作
		//戰鬥掉煉金素材 探索掉木毛石 [ 右方圖示>>PVE戰鬥固定會有魂 , PVP戰鬥固定會有積分 ]
		public var _itemDrop:ItemDrop;
		 /*
		_material 
		{ 
			itemGUID : PlayerSource VO
		}
		*/
		
		
	}
	
}