package MVCprojectOL.ModelOL.Vo {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.05.10.16.16
	 */
	public class Skill {
		
		public var _guid:String;//GUID
		public var _name:String;//技能名稱
		
		public var _iconKey:String;//圖示Key	//	ICO
		public var _effectKey:String;//發動效果  	//	ANI
		public var _soundKey:String;//施放時的音效		//SND
		
		public var _info:String;//資訊內容(Tip)
		
		public var _actType:uint;//動作屬性  (魔法or物理動作)
		
		
		// 130116新增
		//130530調整 _class 效果類型會傳送1.增加攻擊, 2.增加防禦, 3.增加速度, 4.增加智力, 5.增加精神, 6.增加生命上限, 7.減少攻擊, 8.減少防禦, 9.減少速度, 10.減少智力, 11.減少精神, 12.減少生命上限, 13.中毒, 14.流血, 15.燃燒, 16.冰凍, 17.包紮, 18.再生, 19.禁言, 20.禁武, 21.睡眠, 22.昏迷, 23.混亂, 24.無敵
		//cc類的 class 有 19.禁言, 20.禁武, 21.睡眠, 22.昏迷, 23.混亂, 24.無敵

		public var _class:uint; // 技能種類：1.攻擊傷害類, 2.守護類, 3.增益類, 4.減益類, 5.持續傷害類, 6.補血類, 7.控場類
		public var _executeType:uint; // 攻擊種類：1.自己, 2.目標, 3.我方隊伍, 4.敵方隊伍
		public var _locate:Array; // 攻擊座標 [0,2,5,7] //技能範圍			//當技能沒有範圍限定  將會是null
		
		/*public var _skillEffects:Array;//技能效果的KEY	所含的skillEffect的KEY				wasted 130115
					//[ "skillEffectKey001" , "skillEffectKey002" , "skillEffectKey003" ]*/
					
		//130429新增
		public var _launchType:uint;//發動種類
		public var _probability:uint;//發動機率
		public var _damage:uint;//技能傷害
		
		//130510新增
		public var _movingType:uint;//技能播放的移動種類 1. 移動到隊伍前面施法 2. 原地施法
		
		//130528新增
		public var _cdRound:uint;//冷卻回合數
		//---130531//此招式的類型 1 . 技能    2 . 普通攻擊
		public var _attackType:uint;
		//130605新增
		public var _isShowDamage:Boolean;//是(true)   /   否(false) 顯示傷害血量值
		
		public function Skill() {
			
		}
		
	}//end class

}//end package