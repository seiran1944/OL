package MVCprojectOL.ModelOL.Vo.Set
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author EricHuang
	 * 刪除玩家物品的指令
	 * 2013/04/03
	 */
	public class Set_RemovePlayerGods extends VoTemplate
	{
		public var _guid:String = "";
		public var _godNum:int = 1;
		public function Set_RemovePlayerGods (_id:String,_num:int=1) 
		{
			this._guid = _id;
			this._godNum = _num;
		}
		
		
		
		
	}
	
}