package MVCprojectOL.ModelOL.Vo.Explore{
	import flash.net.registerClassAlias;
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.01.21.14.29
	 * @documentation 獲取魔神殿區域資料
	 */
		
	registerClassAlias( "Get_ExploreAreas" , Get_ExploreAreas );
	 
	public class Get_ExploreAreas extends VoTemplate{
		/*
		public var _playerID:String = PlayerDataCenter.PlayerID;
		public var _replyDataType:String = "ExploreAreaList";
		public var _token:String = PlayerDataCenter.Token;
		*/
		//回傳所有魔神殿區塊 ( ExploreArea ) Array
		
		public function Get_ExploreAreas():void {
			super( "ExploreAreaList" );
		}
		
	}//end class
}//end package