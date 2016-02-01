package MVCprojectOL.ModelOL.BattleImaging
{
	import MVCprojectOL.ModelOL.Vo.Battle.BattlefieldInit;
	import MVCprojectOL.ModelOL.Vo.Battle.BattlefieldSteps;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleRound;
	import Spark.Timers.TimeDriver;
	import strLib.proxyStr.ArchivesStr;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 管理相關資料
	 */
	public class BattleManager 
	{
		
		private var _funHub:Function;
		private var _initData:BattlefieldInit;
		private var _steps:int = -1;
		private var _currentRound:int = 1;
		private var _isEnd:Boolean = false;
		
		public function BattleManager():void
		{
			
		}
		
		//改成新VO
		public function set Screenplay(data:BattlefieldInit):void
		{
			this._initData = data;
		}
		
		public function get Army():Object
		{
			return this._initData._objArmy;
		}
		
		public function get Enemy():Object
		{
			return this._initData._objEnemy;
		}
		
		public function get InfoData():BattlefieldInit
		{
			return this._initData;
		}
		
		public function MusicControl(on:Boolean):void
		{
			//this._initData._bgMusic
		}
		
		
		public function set NotifyPlaceHub(hubWay:Function):void
		{
			this._funHub = hubWay;
		}
		
		public function get Round():int 
		{
			return this._currentRound;
		}
		
		public function get IsEnd():Boolean 
		{
			return this._isEnd;
		}
		
		private function toHub(status:String,carry:Object=null,sendOut:Boolean=false):void
		{
			this._funHub(status, carry, sendOut);
		}
		
		public function StartToFight():void
		{
			
			//this.StepsFin();
			TimeDriver.AddDrive(1000, 1, this.toFightDelay);
		}
		
		//增加完成靈氣ICON後的延遲進場時間
		private function toFightDelay():void 
		{
			TimeDriver.RemoveDrive(this.toFightDelay);
			this.StepsFin();
		}
		
		
		private function callThePigeon(letters:Object):void
		{
			switch (true) 
			{
				case letters is BattlefieldSteps:
					this.toHub(ArchivesStr.BATTLEIMAGING_VIEW_STEPS, letters);
				break;
				case letters is BattleRound:
					
					if (!letters["_battleEnd"]) {
						this._currentRound++;
						this.toHub(ArchivesStr.BATTLEIMAGING_VIEW_ROUNDS, letters["_roundEffect"] );
					}else {
						//20130607在戰鬥結束時最後的RoundEnd = true 但同時造成結束原因是怪物死於EFFECT 調整為播放好最後效果才結束流程
						this._isEnd = true;
						var aryRoundEffect:Array = letters["_roundEffect"];
						if (aryRoundEffect.length > 0) {
							this.toHub(ArchivesStr.BATTLEIMAGING_VIEW_ROUNDS, aryRoundEffect);
						}else {
							this.toHub(ArchivesStr.BATTLEIMAGING_VIEW_END);
						}
					}
					
				break;
			}
		}
		
		public function StepsFin():void
		{
			this._steps++;
			this.callThePigeon(this._initData._arySteps[this._steps]);
		}
		
		public function Destroy():void
		{
			this._currentRound = 1;
			this._funHub = null;
			this._initData = null;
			this._steps = -1;
			this._isEnd = false;
		}
		
		
		
	}
	
}