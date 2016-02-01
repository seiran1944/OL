package MVCprojectOL.ModelOL.Vo.Set
{
	import MVCprojectOL.ModelOL.Vo.Template.VoTemplate;
	import flash.net.registerClassAlias;
	registerClassAlias("Set_PvpReceiveReward", Set_PvpReceiveReward);
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.05.09.13.57
		@documentation 通知該玩家領取了獎勵>>回傳實際上接收到的獎勵品內容PvpReward ( _isReceiveBack = true)
	 */
	public class Set_PvpReceiveReward extends VoTemplate
	{
		
		public function Set_PvpReceiveReward():void 
		{
			super("PvpReward");
		}
		
		
	}
	
}