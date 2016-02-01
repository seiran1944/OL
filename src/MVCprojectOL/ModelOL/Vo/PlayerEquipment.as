package MVCprojectOL.ModelOL.Vo
{
	import MVCprojectOL.ModelOL.Vo.Template.BasicVaule;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class PlayerEquipment extends BasicVaule
	{
		//----裝備圖片----
		public var _picItem:String = "";
		//----禁錮能力最大值
		public var _detentionMaxVaule:int = 0;
		//----禁錮能力當前值
		public var _detentionNowVaule:int = 0;
		//----使用狀態-0:刪除, 1:閒置, 2:溶解 3出戰 4掛賣(舊的)-----
		//--2013/01/18新的
		//----0.刪除, 1.閒置（在儲藏室）, 2.消耗中（裝備素材合成、道具使用）, 3.被裝備中（只有裝備才會有這狀態，魔晶石、英靈被鑲嵌後是直接被改為刪除狀態的）, 4.掛賣中
		public var _useing:int = 0;
		//--0=武器/1=防具/2=飾品
		public var _type:int = 0;
		//----_gruopGuid---(判斷種類(檢查是否為同一種))
		public var _gruopGuid:String= "";
		
		//----操作價格--
		public var _sellSoul:int;
		//----賣價折數---
		public var _sell:int;
		
		//---鑲嵌時間
		public var _soulTimes:uint;
		
		//---最大英靈容量值
		public var _soulMaxVaule:int = 0;
		//---目前英靈容量值(容量-靈能值)
		public var _nowSoulVaule:int = 0;
		//-----紀錄品質
		//---1.普通/2.良品/3.稀有/4.極品
		public var _quality:int = 0;
		//public var _quaName:String="";
		public var _showInfo:String = "";
		//--裝備等級限制--
		public var _lvEquipment:int = 0;
		
		//------英靈的屬性(紀錄英靈的資料)
		//---攻擊
	    public var _soulAtk:int = 0;
		//---防禦
	    public var _soulDef:int = 0;
		//--敏捷
	    public var _soulSpeed:int = 0;
		//----智力
	    public var _soulInt:int = 0;
		//---精神
	    public var _soulMnd:int = 0;
	    //-----生命
		public var _soulHP:int = 0;
		
		//----該裝備被哪個角色使用了
		public var _monsterID:String = "";
		
	}
	
}