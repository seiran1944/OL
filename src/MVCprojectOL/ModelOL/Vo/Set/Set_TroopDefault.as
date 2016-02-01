package MVCprojectOL.ModelOL.Vo.Set
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	import flash.net.registerClassAlias;
	
	registerClassAlias("Set_TroopDefault", Set_TroopDefault);
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.04.26.11.31
		@documentation to use this Class....
	 */
	public class Set_TroopDefault extends VoTemplate
	{
		public var _guid:String;
		public var _isPvpTeam:Boolean;//是(true)  /  否(false)為PVP預設隊伍
		public var _isPveTeam:Boolean;//是(true)  /  否(false) 為PVE預設隊伍
		
		public function Set_TroopDefault(guid:String,isPvp:Boolean,isPve:Boolean):void 
		{
			super("");
			this._guid = guid;
			this._isPvpTeam = isPvp;
			this._isPveTeam = isPve;
		}
		
		
	}
	
}