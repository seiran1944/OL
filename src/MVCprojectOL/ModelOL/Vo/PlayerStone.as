package MVCprojectOL.ModelOL.Vo
{
	import MVCprojectOL.ModelOL.Vo.Template.BasicVaule;
	
	
	/**
	 * ...
	 * @Engine :SparkEngine
	 * @author :EricHuang
	 * @version :2012/11/23
	 * @Explain:StoneComponent 魔石基底元件
	 * @playerVersion:11.4
	 */
	
	public class PlayerStone extends BasicVaule 
	{
		//記錄魔石圖像 ====>暫定
		public var _picItem:String;
		//記錄魔石Tip訊息
		public var _stoneTip:String;
		//----2013/1/28
		//---1=正常/2=掛賣/0=使用狀態(server尚未回寫)
		public var _type:int = 0;	
		
		public var _monsterID:String = "";
		
		
	}
}