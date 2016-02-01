package MVCprojectOL.ModelOL.Vo.Template
{
	
	/**
	 * ...
	 * @author EricHuang
	 * 基礎五屬性
	 */
	public class BasicVaule 
	{
		
		public var _guid:String = "";
		
		public var _showName:String = "";
		//---攻擊
	    public var _attack:int = 0;
		//---防禦
	    public var _defense:int = 0;
		//--敏捷
	    public var _speed:int = 0;
		//----智力
	    public var _int:int = 0;
		//---精神
	    public var _mnd:int = 0;
		//---生命值
		public var _HP:int = 0;
		
		//--掛賣允許(1=yes/0=no)
		public var _isTradable:int = 0;
		
		
	}
	
}