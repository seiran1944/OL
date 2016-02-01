package MVCprojectOL.ModelOL.Vo.Get
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class  Get_PlayerLibrary  extends VoTemplate
	{
		
		public function  Get_PlayerLibrary (){
			super( "PlayerLiabrary");
			trace("playID>>>"+this._playerID+">>>>VO_name>>"+"PlayerLiabrary");
		}
		
	}
	
}