package MVCprojectOL.ModelOL.Dissolve
{
	import MVCprojectOL.ModelOL.Building.BuildingProxy;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class DissolveProxy extends ProxY 
	{
		
		private var _DissolveDataCenter:DissolveDataCenter;
		public function DissolveProxy():void 
		{
			super(ProxyPVEStrList.DISSOLVE_PROXY,this);
		}
		
		
		override public function onRegisteredProxy():void 
		{
			this._DissolveDataCenter = new DissolveDataCenter();
			var _buildGuid:String=BuildingProxy.GetInstance().GetBuildingGuid(3);
		    this._DissolveDataCenter.dissolveBuildKey = _buildGuid;
		    this._DissolveDataCenter.dissolveBuildType = 3;
		}
		
		//---寫入該建築物的GUID-
		/*
		public function DissolveBuildKey(_guid:String):void 
		{
			this._DissolveDataCenter.dissolveBuildKey = _guid;
		}
		*/
		//-----取得怪獸列表狀態(帶入排序參數);
		public function GetMonsterLister(_str:String):Array 
		{
		   return this._DissolveDataCenter.GetMonsterLister(_str);	
		}
		//---檢查排程數量是否合法---
		public function CheckLineIllegal():Boolean 
		{
			return this._DissolveDataCenter.CheckLineIllegal();
		}
		
		//---取得排程(該棟建築物)
		public function GetLine():Array 
		{
			return  this._DissolveDataCenter.GetLine();
		}
		
		//--1>怪獸溶解資料錯誤/-2//----溶解等級過低於建築物---3>OK
		public function CheckDissolve(_monster:String,_disLV:int):int 
		{
			return  this._DissolveDataCenter.CheckDissolve(_monster,_disLV);
		}
		//---溶解
		public function DissolveMonster(_monster:String):Array 
		{
			return this._DissolveDataCenter.DissolveMonster(_monster);
		}
		
		//----取得怪獸的熔解結果預覽數值
		public function PreViewDissolve(_key:String):Object 
		{
			return this._DissolveDataCenter.PreViewDissolve(_key);
		}
	
		
	}
	
}