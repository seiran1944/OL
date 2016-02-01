package Spark.MVCs.Models.BarTool
{
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.ErrorsInfo.MessageTool;
	import Spark.MVCs.Models.BarTool.BarGroup;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.11.05.16.28
		@documentation 調度BarGroup的場所
	 */
	public class BarProxy extends ProxY
	{
		
		private var _stock:GroupStock = new GroupStock();
		private static var _barProxy:BarProxy;
		
		public function BarProxy(registerName:String):void
		{
			if (BarProxy._barProxy != null )trace("fack");
			BarProxy._barProxy = this;
			super(registerName, this);
			/*
			if (_key == null) {
				
				throw Error("不合法的建構");
				
				} else {
				
				BarProxy._barProxy = this;
			//super(registerName, this);
				
			} */
			/*
			if (BarProxy._barProxy != null || _key==null) {
				
				return;
			}*/
			
		}
		
		
		public static function GetInstance():BarProxy
		{
			if (BarProxy._barProxy == null) BarProxy._barProxy = new BarProxy(CommandsStrLad.BAR_SYSTEM);
			return BarProxy._barProxy;
		}
		
		/**
		 * 註冊並取得BarGroup class
		 * @param	groupName 自定義名稱
		 * @return	BarGroup
		 */
		public function RegisterGroup(groupName:String):BarGroup
		{
			return this._stock.AddIn(groupName);
		}
		
		/**
		 * 移除註冊的BarGroup群組
		 * @param	groupName 自定義的群組名稱
		 */
		public function RemoveGroup(groupName:String):void
		{
			this._stock.RemoveOut(groupName);
		}
		
		/**
		 * 取得BarGroup群組
		 * @param	groupName 自定義的群組名稱
		 * @return	BarGroup
		 */
		public function GetBarGroup(groupName:String):BarGroup
		{
			var bg:BarGroup = this._stock.GetGroup(groupName);
			
			if (bg == null) {
				//ErrorList.OutputError(RegisterList.BAR_SYSTEM, ErrorList.SOURCE_NONE);//未註冊Group
				MessageTool.InputMessageKey(701);
			}
			
			return bg;
		}
		
		/**
		 * 註銷class
		 */
		public function Destroy():void
		{
			this._stock.RemoveAll();
			this._stock.Destroy();
			this._stock = null;
		}
		
		
	}
	
}
import Spark.ErrorsInfo.MessageTool;
import Spark.MVCs.Models.BarTool.BarGroup;

class GroupStock
{
	
	public var _objStock:Object = { };
	
	public function AddIn(groupName:String):BarGroup
	{
		var bg:BarGroup;
		if (!(groupName in this._objStock)) {
			bg = new BarGroup();
			this._objStock[groupName] = bg;
		}else {
			//ErrorList.OutputError(RegisterList.BAR_SYSTEM, ErrorList.SOURCE_IN);
			//702
			MessageTool.InputMessageKey(702);
		}
		return bg;
	}
	
	public function RemoveOut(groupName:String):void 
	{
		trace("REmoveBar[Proxy]>>>"+groupName);
		trace("checkGroup>>>"+this.checkGroup(groupName));
		if (this.checkGroup(groupName)) {
			this.Remove(groupName);
		}else {
			//Error no register
			//701
			MessageTool.InputMessageKey(701);
		}
		
	}
	public function RemoveAll():void 
	{
		for (var name:String in this._objStock)
		{
			this.Remove(name);
		}
	}
	private function Remove(groupName:String):void 
	{
		this._objStock[groupName].Destroy();
		this._objStock[groupName] = null;
		delete this._objStock[groupName];
	}
	
	public function GetGroup(groupName:String):BarGroup
	{
		if (this.checkGroup(groupName)) {
			return this._objStock[groupName];
		}else {
			return null;
		//Error no register
		//701
		MessageTool.InputMessageKey(701);
		}
	}
	
	private function checkGroup(groupName:String):Boolean
	{
		return groupName in this._objStock ? true : false;
	}
	
	public function Destroy():void 
	{
		this._objStock = null;
	}
	
	
}


class Key {
	
	
}