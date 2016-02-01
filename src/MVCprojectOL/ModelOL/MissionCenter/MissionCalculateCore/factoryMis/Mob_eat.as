package  MVCprojectOL.ModelOL.MissionCenter.MissionCalculateCore.factoryMis
{
	import MVCprojectOL.ModelOL.MissionCenter.MissionCalculateCore.MisCalculateCore;
	import MVCprojectOL.ModelOL.MissionCenter.MissionCalculateCore.MissionCalculateBase;
	import MVCprojectOL.ModelOL.Vo.MissionVO.Mission_mob_eat;
	
	
	/**
	 * ...
	 * @author ...EricHuang
	 * '惡魔[%s]吃[%s]個，等級[%s]魔精石';
	 * 在新增計算條件清單的時候..如果有石頭等級限制需要再寫進去條件理面
	 * 
	 */
	public class  Mob_eat extends MisCalculateCore 
	{
		override public function injectionTarget(_class:*):void 
		{
			//---用來轉型---
			
			this._misCalculate = _class as Mission_mob_eat;
		}
		
		override public function Calculate(_class:MissionCalculateBase):void 
		{
			//---用來單獨處理
			//--check魔晶石是否有等級限制
			if () {
				
				
				
				
				} else {
				
				
				
				
			}
			
			
			
			if (this._misCalculate._lv==-1) {
				this._misCalculate._number += _class._number;	
			}else if(this._misCalculate._lv==_class._lv){
				
				this._misCalculate._number += _class._number;
			}
			
			
		}
		
	}
	
}