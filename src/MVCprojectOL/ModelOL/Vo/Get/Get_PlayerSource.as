package MVCprojectOL.ModelOL.Vo.Get
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class Get_PlayerSource extends VoTemplate
	{
		
		
		public function Get_PlayerSource() 
		{
			super( "PlayerSource");
			trace("playID>>>"+this._playerID+">>>>VO_name>>"+"PlayerSource");
		}
		
	}
	
}