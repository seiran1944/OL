package MVCprojectOL.ModelOL.Vo.Pvp
{
	import flash.net.registerClassAlias;
	
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation 初始UI需要的資料
	 */
	registerClassAlias("PvpInitData", PvpInitData);
	public class  PvpInitData
	{
		//public var _intro:String;//UI顯示的說明文字
		public var _isCD:Boolean;//系統是(true)  /  否(false)  冷卻中
		//public var _fightCD:int;//出征失敗時需要系統冷卻的時間(秒)			//若有同時發送了schedule 則此屬性不需要
		public var _reward:PvpReward;//有獎勵有值 沒獎勵則null  ( _isReceiveBack = false)
		public var _fightTimes:int;//當天出征次數(遞減)
		public var _fightLimit:int;//當天限制出征數
		public var _rankingData:PvpRankingUpdate;//排行榜內容
		
		
	}
	
}