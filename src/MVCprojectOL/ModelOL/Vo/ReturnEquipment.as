package MVCprojectOL.ModelOL.Vo
{
	import MVCprojectOL.ModelOL.Vo.Template.BasicVaule;
	
	/**
	 * ...
	 * @author EricHuang
	 * 裝備類型的改變
	 */
	public class  ReturnEquipment extends BasicVaule
	{
		
		//-----1=鑲嵌,2=禁錮力改變
		public var _type:int = -1;
		public var _useing:int = -1;
		
		public var _soul:String = "";
		//---該裝備靈魂容量
		public var _soulVaule:int = 0;
		//---該裝備的當前禁錮力
		public var _detentionVaule:int = 0;
		
		
	}
	
}