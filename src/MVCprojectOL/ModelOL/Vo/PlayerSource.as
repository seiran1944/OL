package MVCprojectOL.ModelOL.Vo
{
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class PlayerSource 
	{
		//----檢查製作類的素材類型(裝備用/魔神殿建築用--0=製作類/1=建築類/--02PVP魔鬥積分)
		//----建築物升級與裝備製作的素材不會重疊到(是分開設計的)
		public var _type:int = 0;
		//----0=木頭/1=石頭/2=皮毛/-3soul
		public var _buildSourceType:int = -1;
		public var _picItem:String = "";
		//----素材的類型Key---
		public var _groupGuid:String = "";
		public var _guid:String = "";
		//public var _key:int = 0;
		//---有的數量-----
		public var _number:int = 0;
		//----秀出的名稱
		public var _showName:String = "";
		//---秀出的中文資訊說明---
		public var _showInfo:String = "";
		//-----0.已刪除, 1.放在儲藏室, 2.被裝備, 3.合成中, 4.掛賣中
		public var _status:int = 0;
		//-----堆疊(單疊數量最大上限)
		public var _stackMax:int = 0;	
	}
	
}