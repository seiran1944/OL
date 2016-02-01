package MVCprojectOL.ModelOL.Vo.Pvp
{
	import flash.net.registerClassAlias;
	import MVCprojectOL.ModelOL.Vo.Buildschedule;
	import MVCprojectOL.ModelOL.Vo.ItemDrop;
	registerClassAlias("PvpReward", PvpReward);
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.05.09.14.05
		@documentation ＰＶＰ結算名次獎勵取得項目 ( 排程到達時回傳  , Set_PvpReceiveReward回傳 , PvpInitData內屬性)
	 */
	public class PvpReward
	{
		public var _isReceiveBack:Boolean;//是(true)  /  否(false)  為Set_PvpReceiveReward 回傳的PvpReward (SERVER確認有增加的獎勵內容)
		//Set_PvpReceiveReward >> true
		//PvpInitData >> false
		//排程到達時回傳 >> false
		
		//目前只掉素材 最大種類十種限定(UI十格)
		public var _rewardItem:Array;
		//會有一堆MissionBackReward 01246會對應PlayerSource
		//----0=木頭/1=石頭/2=皮毛/3=soul/--4素材/--5裝備/6道具/7怪獸/8.金鑽/9.魔晶石
		
		public var _buildschedule:Buildschedule = null;//循環排程用
		
	}
	
}