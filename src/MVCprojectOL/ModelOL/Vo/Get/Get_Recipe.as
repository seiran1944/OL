package MVCprojectOL.ModelOL.Vo.Get
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class Get_Recipe extends VoTemplate
	{
		/*public var _PlayerID:String=PlayerDataCenter.PlayerID;//玩家ID
		//----VO_className()-----
		public var _ReplyDataType:String = "PlayerMonster";//記錄要回傳的VO型態*/
		
		public function Get_Recipe(){
			super( "PlayerRecipe");
			trace("playID>>>"+this._playerID+">>>>VO_name>>"+"PlayerRecipe");
		}
		
		
	}
	
}