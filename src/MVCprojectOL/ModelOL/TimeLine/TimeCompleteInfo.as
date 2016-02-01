package MVCprojectOL.ModelOL.TimeLine
{
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class  TimeCompleteInfo
	{
	    
		public var _schID:String = "";
		
		public var _target:String = "";
		
		public var _produce:String = "";
		
		public function TimeCompleteInfo(_sch:String,_targetID:String,_produceID:String) 
		{
			this._schID = _sch;
			this._target = _targetID;
			this._produce = _produceID;
		}
	}
	
}