package MVCprojectOL.ModelOL.Dissolve
{
	import MVCprojectOL.ModelOL.Building.BuildingProxy;
	import MVCprojectOL.ModelOL.Building.BuildingStock;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.Monster.MonsterServerWrite;
	import MVCprojectOL.ModelOL.Monster.PlayerMonsterDataCenter;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineObject;
	
	/**
	 * ...
	 * @author EricHuang
	 * 溶解鎖系統----
	 */
	public class  DissolveDataCenter
	{
	    
		//---溶解所建築物KEY---
		private var _dissolveBuildKey:String = "";
		
		private var _dissolveBuildType:int = 0;
		
		private static var _DissolveData:DissolveDataCenter;
		
		public function set dissolveBuildKey(value:String):void { this._dissolveBuildKey = value };
		
		public function set dissolveBuildType(value:int):void {_dissolveBuildType = value}
		
		public function DissolveDataCenter() 
		{
			if (DissolveDataCenter._DissolveData != null) throw Error("[DissolveDataCenter] build illegal!!!please,use [Singleton]");
		}
		
		//-----融解預覽相關情況
		
		public function PreViewDissolve(_key:String):Object 
		{
			return PlayerMonsterDataCenter.GetMonsterData().GetMonsterStone(_key);
		}
		
		
		public static function GetDissolve():DissolveDataCenter 
		{
			if (DissolveDataCenter._DissolveData == null) DissolveDataCenter._DissolveData=new DissolveDataCenter();
			return DissolveDataCenter._DissolveData;
		}
		
	    //-----取得怪獸列表狀態(帶入排序參數);
		public function GetMonsterLister(_str:String):Array 
		{
			return PlayerMonsterDataCenter.GetMonsterData().GetMonsterList(_str);
		}
		
		
		//---檢查排程數量是否合法---
		public function CheckLineIllegal():Boolean 
		{
			//--要請阿翔新增proxy function[GetBuildLineMax]--取得玩家合法排程目前最大量
			var _flag:Boolean = ((BuildingProxy.GetInstance().GetBuildWorking(this._dissolveBuildKey)).length<BuildingProxy.GetInstance().GetBuildLineMax(this._dissolveBuildKey))?true:false;
		    return _flag;
			
		}
		
		//---取得時間排程
		public function GetLine():Array 
		{
			return TimeLineObject.GetTimeLineObject().GetAllLine(this._dissolveBuildKey);
		}
		
		
		
		public function CheckDissolve(_monster:String,_disLV:int):int 
		{
			var _flag:int = 0;
			var _monsterDisLV:int = PlayerMonsterDataCenter.GetMonsterData().GetMonsterDisLV(_monster);
			if (_monsterDisLV!=_disLV) { 
				//---怪獸溶解資料錯誤
				_flag = 1;
				} else if(int(BuildingProxy.GetInstance().GetBuildLV(this._dissolveBuildKey))<_disLV){
				_flag = 2;//----溶解等級過低於建築物
			   }else {
				_flag = 3;
			}
			
			return _flag;
			
		}
		
		
		public function DissolveMonster(_monster:String):Array 
		{
			//-----_build:String,_target:String,_starTime:int,_finishTime:int,_buildType:int
			//-----
		
			//var _buildType:int = int(BuildingProxy.GetInstance().GetBuildType(this._dissolveBuildKey));
			var _starTime:uint = ServerTimework.GetInstance().ServerTime;		
			//var _starTime:uint = 1000000000;		
			var _aryDissolve:Array;
			//--test------
			//var _starTime:int = 1;
			var _monsterFlag:int = PlayerMonsterDataCenter.GetMonsterData().CheckMonster(_monster);
			//--取得溶解時間
			if (_monsterFlag==1) {
				//---刪除怪獸
				//PlayerMonsterDataCenter.GetMonsterData().RemoveMonster(_monster);
				MonsterServerWrite.GetMonsterServerWrite().RegisterUseMonster(_monster,_starTime,2);
				var _monsterTime:int = PlayerMonsterDataCenter.GetMonsterData().GetDissolvedTimes(_monster);
		   	    TimeLineObject.GetTimeLineObject().AddTimeLine(this._dissolveBuildKey, _monster,_starTime,_monsterTime,this._dissolveBuildType);
				_aryDissolve = TimeLineObject.GetTimeLineObject().GetAllLine(this._dissolveBuildKey);
			}else {
			  trace("monster 不合法");	
				_aryDissolve=[];
			}
			
			return _aryDissolve;
			
		}
		
		
		 
		
		/*
		public function RemoveMonster(_index:String):void 
		{
			
		}
		*/
	}
	
}