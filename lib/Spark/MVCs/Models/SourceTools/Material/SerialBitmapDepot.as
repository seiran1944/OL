package Spark.MVCs.Models.SourceTools.Material
{
	
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	import Spark.MVCs.Models.SourceTools.Material.MaterialComponent;
	import Spark.MVCs.Models.SourceTools.Material.ComponentBase;
	
	
	/**
	 * ...
	 * @author :K.J. Aris
	 * @version :2013.01.02
	 */
	
	
	public final class SerialBitmapDepot {
			
		private const _SerialList:Dictionary = new Dictionary( true );
		
		public function SerialBitmapDepot(){

		}
		
		
		
		public function AddSerialImage( _InputKey:String , _InputContent:Array ):void {//Vector.<BitmapData>
			this._SerialList[ _InputKey ] = _InputContent;
		}

		public function RemoveSerialImage( _InputKey:String ):void {
			delete this._SerialList[ _InputKey ];
		}
		
		public function GetSerialImage( _InputKey:String ):Array {//Vector.<BitmapData>
			return this._SerialList[ _InputKey ];
		}
		
		public function CheckExist( _InputKey:String ):Boolean {
			return ( this._SerialList[ _InputKey ] == null )? false : true ;
		}
		
	}//end class
}//end package