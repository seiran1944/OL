package MVCprojectOL.ModelOL.Vo.Set
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.04.26.10.42
		@documentation 隊伍變更成員寫回SERVER內容
	 */
	public class Set_Troop extends VoTemplate
	{
		//新隊伍創建 >> guid=""   ;    symbol=某標記值 >>>SERVER須回NewTroop
		//舊隊伍編輯 >> guid=隊伍ID    ;    symbol=""      >>> SERVER須回EditTroop
		
		public var _guid:String;
		public var _symbol:String;
		public var _objMember:Object;
		
		//20130426 new default team 
		public var _teamNum:int;//隊伍紀錄的編號(位置)
		
		
		public function Set_Troop(IsNewTroop:Boolean,member:Object,symbol:String,guid:String="",teamNum:int=-1):void
		{
			super(IsNewTroop ? "NewTroop" : "EditTroop");
			this._guid = guid;
			this._symbol = symbol;
			this._objMember = member;
			this._teamNum = teamNum;
		}
		
		
	}
	
}