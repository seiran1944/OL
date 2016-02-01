package MVCprojectOL.ModelOL.PackageSys
{
	import flash.utils.Dictionary;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author EricHuang
	 * --背包系統
	 */
	public class  PackageProxy extends ProxY
	{
		
		private var _Package:Package;
		public function PackageProxy() 
		{
			super(ProxyPVEStrList.PACKAGE_PROXY,this);
		}
		
		
		override public function onRegisteredProxy():void 
		{
			this._Package = Package.GetPackag();
			this.SendNotify(ProxyPVEStrList.PACKAGE_PROXYReady);
		}
		
		
		public function GetPackage():Dictionary 
		{
			return this._Package.GetALLPackage();
		}
		
		//-------取單一頁籤
		public function GetSingleGoods(_str:String):Array 
		{
			return this._Package.GetSingleGoods(_str);
		}
		
		public function RemoveEqu(_index:String,_id:String,_type:int,_group:String=""):void 
		{
			this._Package.RemoveEqu(_index,_id,_type,_group);
		}
		
		//---取得該品項有多少數量----(type如下)
		/*PlaySystemStrLab.Package_Source
		 *PlaySystemStrLab.Package_Stone
		 *PlaySystemStrLab.Package_Weapon
		 *PlaySystemStrLab.Package_Shield
		 *PlaySystemStrLab.Package_Accessories 
		*/
		public function GetSingleNumber(_type:String):int 
		{
			return this._Package.GetSingleNumber(_type)
		}
		
		
	}
	
}