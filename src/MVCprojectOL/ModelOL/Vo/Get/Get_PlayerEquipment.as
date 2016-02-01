package MVCprojectOL.ModelOL.Vo.Get
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class Get_PlayerEquipment extends VoTemplate
	{
		public function Get_PlayerEquipment(){
			super( "PlayerEquipment");
			trace("playID>>>"+this._playerID+">>>>VO_name>>"+"PlayerEquipment");
		}
	}
	
}