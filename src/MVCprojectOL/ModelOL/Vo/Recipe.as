package MVCprojectOL.ModelOL.Vo
{
	import MVCprojectOL.ModelOL.Vo.Template.BasicVaule;
	
	/**
	 * ...
	 * @author EricHuang
	 * 配方表
	 */
	public class  Recipe extends BasicVaule
	{
		
		//--0=武器/1=防具/2=飾品/3=素材合成
		public var _type:int = 0;
		
		//-----該配方的guid
	    //--顯示名稱---
		//-----物件陣列----
		//_type----0=武器/1=防具/2=飾品/3=素材
		//_guid-----(給該類群GUID)--groupID
		//_number--數量
		//---obj>{_type:int,_guid:String,_number:int,_picItem:String,_info:String}
		public var _aryNedSource:Array = [];
		
		//---裝備等級限制---
		public var _lvEquipment:int = 0;
		//---等級限制(製作建築物)
		public var _lvLock:int = 0;
		//----製作時間
		public var _needTimes:int = 0;
		//---最大英靈容量值
		public var _soulMaxVaule:int = 0;
		//----禁錮能力最大值(只有裝備類的才會有)
		public var _detentionMaxVaule:int = 0;
		//---圖片的位置所引
		public var _picItem:String = "";
		//----鍛造所需要的魂量----
		public var _needSoul:int = 0;
		//---秀出的中文資訊說明---
		public var _showInfo:String = "";
		
	}
	
}