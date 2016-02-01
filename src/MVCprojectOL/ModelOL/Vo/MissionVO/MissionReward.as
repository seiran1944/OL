package MVCprojectOL.ModelOL.Vo.MissionVO
{
	
	/**
	 * ...
	 * @author EricHuang.
	 * 任務獲得獎勵品
	 */
	public class  MissionReward
	{
		
		//----0=木頭/1=石頭/2=皮毛/3=金鑽//--4素材/--5裝備/6道具/7怪獸
		public var _type:int = 0;
		//--給原形ID
		public var _guid:String="";
		
		public var _number:int=0;
		
		public var _picItem:String = "";
		
		public var _info:String="";
		
		public var _showName:String = "";
	}
	
}