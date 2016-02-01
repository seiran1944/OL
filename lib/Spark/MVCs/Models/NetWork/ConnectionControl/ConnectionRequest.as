package Spark.MVCs.Models.NetWork.ConnectionControl {
	
	/**
	 * @Engine Ignitor
	 * @Author K.J. Aris
	 * @Version 12.08.21.11.17
	 * @FlashPlayerVersion 11.2
	 * @Note 
	 */
		
	import flash.net.Responder;
	 
	public final class ConnectionRequest {
		
		private var _CallAmfFunction:String;
		private var _CallResponder:Responder;
		private var _CallValue:Array;
		
		private var _ParamArray:Array;
		
		public function ConnectionRequest( _InputAmfFunction:String , _InputResponder:Responder , _InputValue:Array ) {
			this._CallAmfFunction = _InputAmfFunction;
			this._CallResponder = _InputResponder;
			this._CallValue = _InputValue;
			
			this.WrapUpParam();
		}
		
		private function WrapUpParam():void {
			this._ParamArray = [ this._CallAmfFunction , this._CallResponder ];
			this._ParamArray = this._ParamArray.concat( this._CallValue );
		}
		
		/*public function get CallAmfFunction():String {
			return _AmfFunction;
		}
		
		public function get CallResponder():Responder {
			return _Responder;
		}
		
		public function get CallValue():Array {
			return _Value;
		}*/
		
		public function get ParamArray():Array {
			return _ParamArray;
		}
		
	}//end class

}//end package