package MVCprojectOL.ModelOL.ItemDisplayModel {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.04.22.17.05
	 */
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
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
		
	public class ItemDisplayProxy extends ProxY {//extends ProxY
		
		private static var _ItemDisplayProxy:ItemDisplayProxy;
		
		//private var _StoneList:Array = [];
		private var _ItemComponentDictionary:Dictionary = new Dictionary( );
		private var _ComponentClones:Vector.<ItemDisplay>;
		
		private var _StoneDataCenter:StoneDataCenter = StoneDataCenter.GetStoneDataControl();
		//private var _Net:AmfConnector = AmfConnector.GetInstance();
		//private var _SourceProxy:SourceProxy = SourceProxy.GetInstance();
		
		//private var _PublicComponentPackKey:String = "GUI00001_ANI";//公用素材包KEY
		
		public static function GetInstance():ItemDisplayProxy {
			return ItemDisplayProxy._ItemDisplayProxy = ( ItemDisplayProxy._ItemDisplayProxy == null ) ? new ItemDisplayProxy() : ItemDisplayProxy._ItemDisplayProxy; //singleton pattern
		}
		
		public function ItemDisplayProxy() {
			//constructor
			ItemDisplayProxy._ItemDisplayProxy = this;
			super( ProxyNameLib.Proxy_ItemDisplayProxy , this );
			//EventExpress.AddEventRequest( NetEvent.NetResult , this.onNetResult , this );//建立連線事件接收
			
			trace( "ItemDisplayProxy constructed !!" );
		}
		
		/*public function InitModule(  ):void {
			//GUI00002_ANI 公用元件包
		}*/
		
		private function TerminateModule():void {
			//EventExpress.RevokeEventRequest( NetEvent.NetResult , this.onNetResult );//終結連線事件接收
			//EventExpress.RevokeAddressRequest( this.onNetResult );//終結連線事件接收
			//EventExpress.RevokeAddressRequest( this.ComponentReturned );
			ItemDisplayProxy._ItemDisplayProxy = null;
		}
		
		//=====================================================================Net message transport router
		/*private function onNetResult( _Result:EventExpressPackage ):void {
			var _NetResultPack:NetResultPack =  _Result.Content as NetResultPack;
			//EventExpress.RevokeEventRequest( NetEvent.NetResult , this.onNetResult );
			switch ( _Result.Status ) {
				
				case "" ://
						
					break;
					
					
				default :
					break;
				
			}
		}*/
		//=============================================================END=====Net message transport router
		
		
		//=========================================================================Actions
		public function GetItemDisplayList( _InputList:Array ):Vector.<ItemDisplay> {//取得怪物顯示快取容器
			
			/*//-----SORT所使用的
			 * PlaySystemStrLab.
			 * 
			public static const Sort_LV:String = "sort_lv";
			public static const Sort_HP:String = "sort_HP";
			public static const Sort_Atk:String = "sort_Atk";
			public static const Sort_Def:String = "sort_Def";
			public static const Sort_Speed:String = "sort_Speed";
			public static const Sort_Int:String = "sort_Int";
			public static const Sort_Mnd:String = "sort_Mnd";
		
			//-----靈能值
			public static const Sort_SoulAbility:String = "sort_SoulAbility";
			public static const Sort_SoulHP:String = "sort_SoulHP";*/
			var _ItemDisplayList:Vector.<ItemDisplay> = new Vector.<ItemDisplay>();
			
			
			var _StoneList:Array = _InputList; // this._StoneDataCenter.GetAllStone();//向StoneDataCenter要重新排序過的怪物清單
			
			
			var _CurrentListTarget:Object;	//怪物物件指標	Note : _StoneDataCenter.GetMonsterList() 不會回傳怪物VO本體  而是包裝在Object中
			var _CurrentDictionaryTarget:ItemDisplay;
			var _StoneListerLength:uint = _StoneList.length;
			for (var i:int = 0; i < _StoneListerLength ; i++) {
				_CurrentListTarget = _StoneList[ i ];
				/*_CurrentDictionaryTarget = this._ItemComponentDictionary[ _CurrentListTarget._guid ];
				( _CurrentDictionaryTarget == null  ) ?	//比對舊資料與新資料重疊的部分  避免產生過多的快取容器  拖累效能
					_CurrentDictionaryTarget = new ItemDisplay( _CurrentListTarget )	//若沒有抓過的怪物 則新增快取容器
					:
					ItemDisplay( _CurrentDictionaryTarget ).UpdateItemValue( _CurrentListTarget );	//若有抓過怪物 則更新怪物數值
				this._ItemComponentDictionary[ _CurrentListTarget._guid ] = _CurrentDictionaryTarget;*/
				_CurrentDictionaryTarget = this.GetItemDisplayExpress( _CurrentListTarget );
				_ItemDisplayList.push( _CurrentDictionaryTarget );	//將結果推入陣列中
			}
			
			
			return _ItemDisplayList;
		}
		
		
		public function GetItemDisplay( _InputItemGuid:String ):ItemDisplay {
			//必須執行過GetMonsterDisplayList才有可能拿得到指標
			return this._ItemComponentDictionary[ _InputItemGuid ];
		}
		
		public function GetItemDisplayClone( _InputItemGuid:String ):ItemDisplay {
			//必須執行過GetMonsterDisplayList才有可能拿得到clone
			/*var _CurrentTarget:ItemDisplay = this._ItemComponentDictionary[ _InputItemGuid ];
			return _CurrentTarget != null ? new ItemDisplay( _CurrentTarget.ItemData ) : null;*/
			
			
			this._ComponentClones = ( this._ComponentClones == null )? new Vector.<ItemDisplay> : this._ComponentClones;
			var _CurrentTarget:ItemDisplay = this._ItemComponentDictionary[ _InputItemGuid ];
			var _Result:ItemDisplay;
			if ( _CurrentTarget != null ) {
				_Result = new ItemDisplay( _CurrentTarget.ItemData );
				this._ComponentClones.push( _Result );
			}
			
			return _Result;
			
			
		}
		
		public function GetItemDisplayFullyClone( _InputItemGuid:String ):ItemDisplay {
			//必須執行過GetMonsterDisplayList才有可能拿得到clone
			/*var _CurrentTarget:ItemDisplay = this._ItemComponentDictionary[ _InputItemGuid ];
			return _CurrentTarget != null ? new ItemDisplay( _CurrentTarget.ItemData ) : null;*/
																														//完全複製ITEMDATA 130422
			
			this._ComponentClones = ( this._ComponentClones == null )? new Vector.<ItemDisplay> : this._ComponentClones;
			var _CurrentTarget:ItemDisplay = this._ItemComponentDictionary[ _InputItemGuid ];
			var _Result:ItemDisplay;
			if ( _CurrentTarget != null ) {
				_Result = new ItemDisplay( this.MakeClone( _CurrentTarget.ItemData ) );
				this._ComponentClones.push( _Result );
			}
			
			return _Result;
			
			
		}
		
		
		
		public function GetItemDisplayExpress( _InputItemVo:Object ):ItemDisplay {
			var _CurrentTarget:Object;	//怪物物件指標	Note : _StoneDataCenter.GetMonsterList() 不會回傳怪物VO本體  而是包裝在Object中
			var _CurrentDictionaryTarget:ItemDisplay;
			
			_CurrentTarget = _InputItemVo;
				_CurrentDictionaryTarget = this._ItemComponentDictionary[ _CurrentTarget._guid ];
				( _CurrentDictionaryTarget == null  ) ?	//比對舊資料與新資料重疊的部分  避免產生過多的快取容器  拖累效能
					_CurrentDictionaryTarget = new ItemDisplay( _CurrentTarget )	//若沒有抓過的怪物 則新增快取容器
					:
					ItemDisplay( _CurrentDictionaryTarget ).UpdateItemValue( _CurrentTarget );	//若有抓過怪物 則更新怪物數值
				this._ItemComponentDictionary[ _CurrentTarget._guid ] = _CurrentDictionaryTarget;
			
			return _CurrentDictionaryTarget;	
			
		}
		
		
		
		//================================================================END======Actions
		
		public function ClearAll():void {//清空所有快取容器內容(以確保所有容器都被清空)
			for ( var i:* in this._ItemComponentDictionary ) {
				this._ItemComponentDictionary[ i ].Destroy();
				delete this._ItemComponentDictionary[ i ];
			}
			this._ItemComponentDictionary = null;
			
			if ( this._ComponentClones != null ) {
				for (var j:int = 0; j < this._ComponentClones.length; j++) {
					this._ComponentClones.pop().Destroy();
				}
				this._ComponentClones = null;
			}
			
			this._StoneDataCenter = null;
		}
		
		override public function onRemovedProxy():void {
			this.ClearAll();//在模組結束時   確保所有項目都被清空(包含監聽)
			this.TerminateModule();
		}
		
		
		
		
		
		
		
		//======================================================================Condition judges
		
	
		
		
		//=============================================================END======Condition judges
		
		private function MakeClone( _InputSource:Object ):Object {
				var _Clone:ByteArray = new ByteArray();
					_Clone.writeObject( _InputSource );
					_Clone.position = 0;
				return ( _Clone.readObject() );
		}
		
		
		
		
		//====================================================================================Send message
		
	
		//==========================================================================END=======Send message
		
		
		
		
		
		
		
		
		
		
	}//end class

}//end package