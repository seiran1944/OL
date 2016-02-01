package MVCprojectOL.ViewOL.CrewView.MonsterMixed
{
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class StatusTemporal
	{
		
		private var _dicTeamWrite:Dictionary;
		
		public function StatusTemporal():void 
		{
			this._dicTeamWrite = new Dictionary();
		}
		
		//先做初始建檔
		public function FirstDataInit(vecMonDp:Vector.<MonsterDisplay>):void 
		{
			var leng:int = vecMonDp.length;
			var objMonDp:Object;
			for (var i:int = 0; i < leng; i++)
			{
				objMonDp = vecMonDp[i].MonsterData;
				this._dicTeamWrite[objMonDp["_guid"]]= new TeamWrite(objMonDp["_teamGroup"], objMonDp["_TeamFlag"]);//須注意屬性正確性****************************************************************************************
			}
		}
		
		//刷新SORT過後的怪物資料
		public function SortDataRecover(vecMonDp:Vector.<MonsterDisplay>):void 
		{
			var leng:int = vecMonDp.length;
			var tw:TeamWrite;
			var objMonDp:Object;
			for (var i:int = 0; i < leng; i++) 
			{
				objMonDp = vecMonDp[i].MonsterData;
				tw = this.getTeamWrite(objMonDp["_guid"]);
				objMonDp["_teamGroup"] = tw._teamGroup;
				objMonDp["_TeamFlag"] = tw._teamFlag;
			}
		}
		
		private function getTeamWrite(monID:String):TeamWrite
		{
			if (monID in this._dicTeamWrite) {
				return this._dicTeamWrite[monID];
			}
			trace("ERROR , Can't find the TeamWrite Data with monster ID");
			return null;
		}
		
		//查詢是否可開啟手指
		public function HandsEnable(monID:String):Boolean
		{
			return this.getTeamWrite(monID)._teamGroup == "" ? true : false;
		}
		
		//編輯加入隊伍的怪物資料與顯示處理
		public function AddInGroup(monID:String,teamID:String,teamFlag:int,monDp:MonsterDisplay):void
		{
			var tw:TeamWrite = this.getTeamWrite(monID);
			if (tw) {
				tw._teamGroup = teamID == "" ? "ORZ" : teamID;
				tw._teamFlag = teamFlag;
				monDp.MonsterData._teamGroup = tw._teamGroup;
				monDp.MonsterData._TeamFlag = teamFlag;
				monDp.ShowContent();
			}
		}
		//編輯移出隊伍的怪物資料與顯示處理
		public function RemoveGroup(monID:String,monDp:MonsterDisplay):void 
		{
			var tw:TeamWrite = this.getTeamWrite(monID);
			if (tw) {
				tw.Reset();
				monDp.MonsterData._teamGroup = "";
				monDp.MonsterData._TeamFlag = -1;
				monDp.ShowContent();
			}
		}
		
		public function Destroy():void 
		{
			this._dicTeamWrite = null;
		}
		
	}
	
}
class TeamWrite 
{
	
	public var _teamGroup:String;
	public var _teamFlag:int;
	
	public function TeamWrite(group:String,flag:int):void 
	{
		this._teamFlag = flag;
		this._teamGroup = group;
	}
	
	public function Reset():void 
	{
		this._teamFlag = -1;
		this._teamGroup = "";
	}
	
}