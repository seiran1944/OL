package MVCprojectOL.ModelOL.ShopMall.Facatorys
{
	import MVCprojectOL.ModelOL.Vo.Set.Set_usemall;
	
	/**
	 * ...
	 * @author EricHuang
	 * 0528---
	 */
	public class RandomSkillFactory extends TimeLineCompleteFacatory 
	{
		
		public function RandomSkillFactory(_fun:Function,_setObj:Object,_setPay:Object) 
		{
			super(_fun,_setObj,_setPay);
		}
		
		override public function Pay():void 
		{
			var _obj:Object= this._setterObj.GetSettingInfo();
			this.PayObjHandler();
			this._sendFun(new Set_usemall("RandomEvo_Skill",{_targetID:_obj._targetID,_type:_obj._type}),true);
			
		}
		
		
		override public function onCompleteCalculate(_obj:Object=null):void 
		{
		  
		}
		
	}
	
}