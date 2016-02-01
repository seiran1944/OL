package MVCprojectOL.ModelOL.MonsterDisplayModel {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.06.06.10.08
	 */
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.CrewModel.CrewProxy;
	import MVCprojectOL.ModelOL.Troop.TroopProxy;
	

	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	 
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.CommandsStrLad;
		
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
		
	//----------------------------------------------------------------------VOs

	import MVCprojectOL.ModelOL.Vo.PlayerMonster;
	
	//-------------------------------------------------------------END------VOs
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import MVCprojectOL.ModelOL.Monster.PlayerMonsterDataCenter;
	
	import strLib.proxyStr.ProxyNameLib;
		
	public final class MonsterDisplayProxy extends ProxY {//extends ProxY
		
		private static var _MonsterDisplayProxy:MonsterDisplayProxy;
		
		//private var _MonsterList:Array = [];
		private var _MonsterComponentDictionary:Dictionary = new Dictionary();
		private var _ComponentClones:Vector.<MonsterDisplay>;
		
		private var _PlayerMonsterDataCenter:PlayerMonsterDataCenter = PlayerMonsterDataCenter.GetMonsterData();
		//private var _Net:AmfConnector = AmfConnector.GetInstance();
		//private var _SourceProxy:SourceProxy = SourceProxy.GetInstance();
		
		//private var _PublicComponentPackKey:String = "GUI00001_ANI";//公用素材包KEY
		private var _TroopProxy:CrewProxy = CrewProxy.GetInstance();//用來查找組隊編號
		
		public static function GetInstance():MonsterDisplayProxy {
			return MonsterDisplayProxy._MonsterDisplayProxy = ( MonsterDisplayProxy._MonsterDisplayProxy == null ) ? new MonsterDisplayProxy() : MonsterDisplayProxy._MonsterDisplayProxy; //singleton pattern
		}
		
		public function MonsterDisplayProxy() {
			//constructor
			MonsterDisplayProxy._MonsterDisplayProxy = this;
			super( ProxyNameLib.Proxy_MonsterDisplayProxy , this );
			//EventExpress.AddEventRequest( NetEvent.NetResult , this.onNetResult , this );//建立連線事件接收
			
			trace( "MonsterDisplayProxy constructed !!" );
		}
		
		/*public function InitModule(  ):void {
			//GUI00002_ANI 公用元件包
		}*/
		
		private function TerminateModule():void {
			//EventExpress.RevokeEventRequest( NetEvent.NetResult , this.onNetResult );//終結連線事件接收
			//EventExpress.RevokeAddressRequest( this.onNetResult );//終結連線事件接收
			//EventExpress.RevokeAddressRequest( this.ComponentReturned );
			MonsterDisplayProxy._MonsterDisplayProxy = null;
			for (var i:* in this._MonsterComponentDictionary ) {
				//this._MonsterComponentDictionary[ i ] = null;
				delete this._MonsterComponentDictionary[ i ];
			}
			
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
		public function GetMonsterDisplayList( _InputSort:String = "sort_lv" , _InputAscendingOrDescending:int = -1 , _AutoShowContent:Boolean = false ):Vector.<MonsterDisplay> {//取得怪物顯示快取容器
			
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
			var _MonsterDisplayList:Vector.<MonsterDisplay> = new Vector.<MonsterDisplay>();
			
			
		
			var _MonsterList:Array = this._PlayerMonsterDataCenter.GetMonsterList( _InputSort , _InputAscendingOrDescending );//向PlayerMonsterDataCenter要重新排序過的怪物清單
			
			
			var _CurrentListTarget:Object;	//怪物物件指標	Note : _PlayerMonsterDataCenter.GetMonsterList() 不會回傳怪物VO本體  而是包裝在Object中
			var _CurrentDictionaryTarget:Object;
			var _MonsterListerLength:uint = _MonsterList.length;
			for (var i:int = 0; i < _MonsterListerLength ; i++) {
				_CurrentListTarget = _MonsterList[ i ] as Object;
				
				_CurrentListTarget._TeamFlag = this._TroopProxy.GetTeamFlagNum( _CurrentListTarget._teamGroup );//附加組隊隊伍編號在資料中 130205
				
				_CurrentDictionaryTarget = this._MonsterComponentDictionary[ _CurrentListTarget._guid ];
				( _CurrentDictionaryTarget == null  ) ?	//比對舊資料與新資料重疊的部分  避免產生過多的快取容器  拖累效能
					_CurrentDictionaryTarget = new MonsterDisplay( _CurrentListTarget , false , "MonsterDisplayProxy" )	//若沒有抓過的怪物 則新增快取容器
					:
					MonsterDisplay( _CurrentDictionaryTarget ).UpdateMonsterValue( _CurrentListTarget );	//若有抓過怪物 則更新怪物數值
				this._MonsterComponentDictionary[ _CurrentListTarget._guid ] = _CurrentDictionaryTarget;
				_MonsterDisplayList.push( _CurrentDictionaryTarget );	//將結果推入陣列中
			}
			
			_AutoShowContent == true ? this.ShowContent( _MonsterDisplayList ) : null;
			
			return _MonsterDisplayList;
		}
		
		public function ShowContent( _InputMonsterDisplayList:Vector.<MonsterDisplay> ):void {
			var _ArrayLength:uint = _InputMonsterDisplayList.length;
			for (var i:int = 0 ; i < _ArrayLength ; i++) {
				_InputMonsterDisplayList[ i ].ShowContent();
			}
		}
		
		public function GetMonsterDisplay( _InputMonsterGuid:String ):MonsterDisplay {
			//必須執行過GetMonsterDisplayList才有可能拿得到指標
			return this._MonsterComponentDictionary[ _InputMonsterGuid ];
		}
		
		public function GetMonsterDisplayUpdated( _InputMonsterGuid:String ):MonsterDisplay {
			//取得已更新的MonsterDisplay
			var _currentTarget:MonsterDisplay = this._MonsterComponentDictionary[ _InputMonsterGuid ];
			var _MonsterValue:Object = this._PlayerMonsterDataCenter.GetSingleMonster( _InputMonsterGuid );
			if ( _MonsterValue != null && _currentTarget != null ) {//若資料且有在HASH表裡 則更新數值
				_currentTarget.UpdateMonsterValue( _MonsterValue );
			}else if( _MonsterValue != null && _currentTarget == null ){//若有資料但沒有在HASH表裡 則新增追加
				_currentTarget = new MonsterDisplay( _MonsterValue );
				_currentTarget.ShowContent();
				this._MonsterComponentDictionary[ _InputMonsterGuid ] = _currentTarget;
			}
			
			return _currentTarget;
		}
		
		public function GetMonsterDisplayClone( _InputMonsterGuid:String ):MonsterDisplay {
			//必須執行過GetMonsterDisplayList才有可能拿得到clone
			/*var _CurrentTarget:MonsterDisplay = this._MonsterComponentDictionary[ _InputMonsterGuid ];
				_CurrentTarget.MonsterData._guid += Math.random();
			return _CurrentTarget != null ? new MonsterDisplay( _CurrentTarget.MonsterData ) : null;*/
			this._ComponentClones ||= new Vector.<MonsterDisplay>;
			var _CurrentTarget:MonsterDisplay = this._MonsterComponentDictionary[ _InputMonsterGuid ];
			var _Result:MonsterDisplay;
			if ( _CurrentTarget != null ) {
				//var _CloneData:Object = this.MakeClone( _CurrentTarget.MonsterData );
					//_CloneData._guid += this._ComponentClones.length;
				_Result = new MonsterDisplay( _CurrentTarget.MonsterData , false , "MonsterDisplayProxyClone" + this._ComponentClones.length );
				this._ComponentClones.push( _Result );
			}
			
			return _Result;
		}
		
		public function ClearAll():void {//清空所有快取容器內容(以確保所有容器都被清空)
			for ( var i:* in this._MonsterComponentDictionary ) {
				this._MonsterComponentDictionary[ i ].Destroy();
				delete this._MonsterComponentDictionary[ i ];
			}
			this._MonsterComponentDictionary = null;
			
			if ( this._ComponentClones != null ) {
				for (var j:int = 0; j < this._ComponentClones.length; j++) {
					this._ComponentClones.pop().Destroy();
				}
				this._ComponentClones = null;
			}
		}
		
		override public function onRemovedProxy():void {
			this.ClearAll();//在模組結束時   確保所有項目都被清空(包含監聽)
			this.TerminateModule();
		}
		//================================================================END======Actions
		
		
		private function MakeClone( _InputSource:Object ):Object {
				var _Clone:ByteArray = new ByteArray();
					_Clone.writeObject( _InputSource );
					_Clone.position = 0;
				return ( _Clone.readObject() );
		}
		
		
		
		
		//======================================================================Condition judges
		
	
		
		
		//=============================================================END======Condition judges
		
		
		
		
		
		
		//====================================================================================Send message
		
	
		//==========================================================================END=======Send message
		
		
		
		
		
		
		
		
		
		
	}//end class

}//end package