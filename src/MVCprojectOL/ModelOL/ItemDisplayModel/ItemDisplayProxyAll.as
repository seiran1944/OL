package MVCprojectOL.ModelOL.ItemDisplayModel 
{
	/**
	 * ...
	 * @author brook
	 * @version 13.01.18.11.34
	 */
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Alchemy.AlchemyDataCenter;
	import MVCprojectOL.ModelOL.Alchemy.AlchemyProxy;
	import MVCprojectOL.ModelOL.Stone.StoneDataCenter;
	

	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	 
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.CommandsStrLad;
		
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
		
	//import MVCprojectOL.ModelOL.Explore.ExploreEvent;
		
	//----------------------------------------------------------------------VOs

	import MVCprojectOL.ModelOL.Vo.PlayerMonster;
	
	//-------------------------------------------------------------END------VOs
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	//import MVCprojectOL.ModelOL.Monster.StoneDataCenter;
	
	import strLib.proxyStr.ProxyNameLib;
	public class ItemDisplayProxyAll extends ProxY
	{
		private static var _ItemDisplayProxyAll :ItemDisplayProxyAll ;
		
		//private var _List:Array = [];
		private var _ComponentDictionary:Dictionary = new Dictionary( );
		private var _ComponentDataDictionary:Dictionary = new Dictionary( );
		private var _ComponentClones:Vector.<ItemDisplay>;
		
		private var _AlchemyDataCenter:AlchemyDataCenter = AlchemyDataCenter.GetAlchemy();
		//----2013/06/12---erichuang----
		//private var _AlchemyDataCenter:AlchemyProxy = 
		
		
		public static function GetInstance():ItemDisplayProxyAll {
			return ItemDisplayProxyAll._ItemDisplayProxyAll = ( ItemDisplayProxyAll._ItemDisplayProxyAll == null ) ? new ItemDisplayProxyAll() : ItemDisplayProxyAll._ItemDisplayProxyAll; //singleton pattern
		}
		
		public function ItemDisplayProxyAll () 
		{
			ItemDisplayProxyAll ._ItemDisplayProxyAll  = this;
			super( ProxyNameLib.Proxy_ItemDisplayProxyAll  , this );
			//EventExpress.AddEventRequest( NetEvent.NetResult , this.onNetResult , this );//建立連線事件接收
			
			trace( "ItemDisplayProxyAll  constructed !!" );
		}
		
		private function TerminateModule():void {
			//EventExpress.RevokeEventRequest( NetEvent.NetResult , this.onNetResult );//終結連線事件接收
			//EventExpress.RevokeAddressRequest( this.onNetResult );//終結連線事件接收
			//EventExpress.RevokeAddressRequest( this.ComponentReturned );
			ItemDisplayProxyAll ._ItemDisplayProxyAll  = null;
		}
		
		public function GetItemDisplayList(_InputCurrentTab:String):Vector.<ItemDisplay> {//取得怪物顯示快取容器
			
			
			var _ItemDisplayList:Vector.<ItemDisplay> = new Vector.<ItemDisplay>();
			
			var _List:Array = this._AlchemyDataCenter.GetRecipeList()[String(_InputCurrentTab)];//向StoneDataCenter要重新排序過的怪物清單
			
			/*var _List:Array = [];
			for (var j:int = 0; j < 20 ; j++) {
				var _obj:Object = { 
					_guid:"WPN00048"+j,
					_picItem:"WPN00048_ICO",
					
				
					_attack:300,
					_defense:100,
					_speed:2,
					_Int:50,
					_mnd:60,
					_HP:70,
					_lvEquipment:4
					//--素材是否足夠鍊金--
					
				};
				_List.push( _obj );
			}*/
			
			/*for ( var j:* in _List ) {
				_List[ j ]._picItem = "WPN00048_ICO";
			}*/
				
			
			
			
			var _CurrentListTarget:Object;	//怪物物件指標	Note : _AlchemyDataCenter.GetMonsterList() 不會回傳怪物VO本體  而是包裝在Object中
			var _CurrentDictionaryTarget:Object;
			var _ListerLength:uint = _List.length;
			for (var i:int = 0; i < _ListerLength ; i++) {
				_CurrentListTarget = _List[ i ];
				_CurrentDictionaryTarget = this._ComponentDictionary[ _CurrentListTarget._guid ];
				( _CurrentDictionaryTarget == null  ) ?	//比對舊資料與新資料重疊的部分  避免產生過多的快取容器  拖累效能
					_CurrentDictionaryTarget = new ItemDisplay( _CurrentListTarget )	//若沒有抓過的怪物 則新增快取容器
					:
					ItemDisplay( _CurrentDictionaryTarget ).UpdateItemValue( _CurrentListTarget );	//若有抓過怪物 則更新怪物數值
				this._ComponentDictionary[ _CurrentListTarget._guid ] = _CurrentDictionaryTarget;
				this._ComponentDataDictionary[ _CurrentListTarget._guid ] = _CurrentListTarget;
				_ItemDisplayList.push( _CurrentDictionaryTarget );	//將結果推入陣列中
			}
			return _ItemDisplayList;
		}
		
		
		public function GetItemDisplay( _InputItemGuid:String ):ItemDisplay {
			//必須執行過GetMonsterDisplayList才有可能拿得到指標
			return this._ComponentDictionary[ _InputItemGuid ];
		}
		
		public function GetItemDisplayClone( _InputItemGuid:String ):ItemDisplay {
			//必須執行過GetMonsterDisplayList才有可能拿得到clone
			/*var _CurrentTarget:ItemDisplay = this._ComponentDictionary[ _InputItemGuid ];
			return _CurrentTarget != null ? new ItemDisplay( _CurrentTarget.ItemData ) : null;*/
			
			this._ComponentClones = ( this._ComponentClones == null )? new Vector.<ItemDisplay> : this._ComponentClones;
			var _CurrentTarget:ItemDisplay = this._ComponentDictionary[ _InputItemGuid ];
			var _Result:ItemDisplay;
			if ( _CurrentTarget != null ) {
				_Result = new ItemDisplay( _CurrentTarget.ItemData );
				this._ComponentClones.push( _Result );
			}
			
			return _Result;
		}
		
		public function GetRecipeRequireContentDisplay( _InputKey:String ):Vector.<ItemDisplay> {
			//取得配方內容的顯是快取物件
			
			var _CurrentData:Object = this._ComponentDataDictionary[ _InputKey ];
			
			var _Result:Vector.<ItemDisplay> = new Vector.<ItemDisplay>();
			if ( _CurrentData != null ) {
				var _CurrentSourceItemList:Array = _CurrentData._aryNedSource;////裡面包了一堆---obj>{_type:int,_guid:String,_number:int,_picItem:String,_info:String}
				var _ListLength:uint = _CurrentSourceItemList.length;
				for (var i:int = 0; i < _ListLength ; i++) {
					_Result.push( new ItemDisplay( _CurrentSourceItemList[i] ) );//做成快取容器
				}
				
			}
			
			return _Result;
			
		}
		
		
		public function ClearAll():void {//清空所有快取容器內容(以確保所有容器都被清空)
			for ( var i:* in this._ComponentDictionary ) {
				this._ComponentDictionary[ i ].Destroy();
				delete this._ComponentDictionary[ i ];
			}
			this._ComponentDictionary = null;
			
			
			for ( var k:* in this._ComponentDataDictionary ) {
				delete this._ComponentDataDictionary[ k ];
			}
			this._ComponentDataDictionary = null;
			
			if ( this._ComponentClones != null ) {
				for (var j:int = 0; j < this._ComponentClones.length; j++) {
					this._ComponentClones.pop().Destroy();
				}
				this._ComponentClones = null;
			}
			
			this._AlchemyDataCenter = null;
		}
		
		override public function onRemovedProxy():void {
			this.ClearAll();//在模組結束時   確保所有項目都被清空(包含監聽)
			this.TerminateModule();
		}
		
		
		
	}

}