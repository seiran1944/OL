package MVCprojectOL.ModelOL.Vo {
	/**
	 * ...
	 * @author K.J. Aris
	 */
	public class PlayerData {
		
		public var _playerName:String = "DefaultPlayer";//玩家名稱
		
		//--eric/04/11-
		public var _playerValue:PlayerBasicValue;
		
		public var _soundEffectSetting:Boolean = true;//音效開關
		public var _soundEffectValue:Number = 0;//音效音量
		
		public var _bGMusicSetting:Boolean;//音樂開關
		public var _bGMusicValue:Number = 0;//音樂音量
		

		public var _fontKey:String = "Error";//字型包Key碼
		
		//public var _monsterExhaustLimit:uint = 0;//怪物疲勞值下限(多少以下<或以上>無法出征)
		
		public var _loadingBgKey:String = "";//Loading背景圖 Key
		public var _initUiKey:Object;//主畫面UI KEY (可能有好幾包)
		
		//------------------2013/3/05---eric
		//---怪獸生命值回復時間
		public var _monsterHPTimes:uint = 0;
		//---怪獸疲勞值回復時間
		public var _monsterFatigueTimes:uint = 0;
		//-----2013/03/18
		public var _healKey:String = "";
		//---0510---
		public var _honorMax:int = 0;
		
		//--0515-mission--
		public var _missionItem:String = "";
		//----2013/3/18-quaColor----
		//public var _aryQuaColor:Array = 
		
		
		public function PlayerData() {
			
		}
		
		
		
	}//end class
}//end package