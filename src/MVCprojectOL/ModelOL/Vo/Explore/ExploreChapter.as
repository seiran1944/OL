package MVCprojectOL.ModelOL.Vo.Explore {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.05.23.11.09
	 */
	import MVCprojectOL.ModelOL.Vo.Explore.ExploreArea;
	 
	public class ExploreChapter {
		public var _guid:String;//該章GUID
		public var _name:String;//該章節名稱
		public var _info:String;//該章內容說明
		
		public var _accessible:Boolean;//是否開放
		
		public var _picItem:String;//包含 該章 左邊封面圖 與 右邊大地圖 底圖	ANI
		
		public var _areaList:Array;//該章的探索結點 ExploreArea
		
		public function ExploreChapter() {
			
		}
		
		
		
		
	}//end class

}//end package