package MVCprojectOL.ModelOL.Vo.Set
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author EricHuang
	 * 裝備類型的物品改變狀態
	 */
	public class Set_Equipment  extends VoTemplate
	{
		
		//-----1=鑲嵌,2=禁錮力改變
		public var _type:int = -1;
		public var _useing:int = -1;
		
		public var _soul:String = "";
		public var _guid:String = "";
		//---該裝備靈魂容量
		public var _soulVaule:int = 0;
		//---該裝備的當前禁錮力
		public var _detentionVaule:int = 0;
			
		public function Set_Equipment(_name:String,_guid:String,_type:int = -1,_useing:int = -1,_soul:String = "",_soulVaule:int=0,_detentionVaule:int=0) 
		{
			super(_name);
			this._guid = _guid;
			this._type = _type;
			this._useing = _useing;
			this._soul = _soul;
			this._soulVaule = _soulVaule;
			this._detentionVaule = _detentionVaule;
			
		}
		
		
	}
	
}