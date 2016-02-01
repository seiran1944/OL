package MVCprojectOL.ModelOL.ShopMall.Facatorys
{
	import MVCprojectOL.ModelOL.TimeLine.TimeLineObject;
	
	/**
	 * ...
	 * @author EricHuang
	 * 建築物升級立即完成---(一次性的消費)
	 */
	public class UpgradeCompleteFacatory extends TimeLineCompleteFacatory 
	{
		
		private const _buildName:String = "buildingTimeline";
		public function BuildUpgradeCompleteFacatory(_fun:Function,_setObj:Object,_setPay:Object):void 
		{
			super(_fun,_setObj,_setPay);
			
		}
		
		
		//-----消費需做的扣除動作之類的----
		override public function onCompleteCalculate(_obj:Object=null):void 
		{
			//----暫停排程----
			TimeLineObject.GetTimeLineObject().CleanLine(this._buildName,_obj._targetID);
		}
		
		
		
		
	}
	
}