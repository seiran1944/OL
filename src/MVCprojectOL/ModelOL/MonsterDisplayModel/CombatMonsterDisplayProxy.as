package MVCprojectOL.ModelOL.MonsterDisplayModel {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.03.05.14.02
	 */
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.LoadingCache.RemoteCache;
	import MVCprojectOL.ModelOL.MotionSettings.MotionValue;
	

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
	//import MVCprojectOL.ModelOL.Monster.PlayerMonsterDataCenter;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleFighter;
	
	import strLib.proxyStr.ProxyNameLib;
		
	public final class CombatMonsterDisplayProxy extends ProxY {//extends ProxY
		public static const ReadySignal:String = "CombatMonsterDisplaysAreReady";
		private static var _CombatMonsterDisplayProxy:CombatMonsterDisplayProxy;
		
		//private var _MonsterList:Array = [];
		private var _MonsterComponentDictionary:Dictionary = new Dictionary();
		private var _ComponentClones:Vector.<MonsterDisplay>;
		
		//private var _PlayerMonsterDataCenter:PlayerMonsterDataCenter = PlayerMonsterDataCenter.GetMonsterData();
		//private var _Net:AmfConnector = AmfConnector.GetInstance();
		//private var _SourceProxy:SourceProxy = SourceProxy.GetInstance();
		
		//private var _PublicComponentPackKey:String = "GUI00001_ANI";//公用素材包KEY
		private var _E2Ready:uint = 0;
		private var _CurrentReady:uint = 0;
		
		
		public static function GetInstance():CombatMonsterDisplayProxy {
			return CombatMonsterDisplayProxy._CombatMonsterDisplayProxy = ( CombatMonsterDisplayProxy._CombatMonsterDisplayProxy == null ) ? new CombatMonsterDisplayProxy() : CombatMonsterDisplayProxy._CombatMonsterDisplayProxy; //singleton pattern
		}
		
		public function CombatMonsterDisplayProxy() {
			//constructor
			CombatMonsterDisplayProxy._CombatMonsterDisplayProxy = this;
			super( ProxyNameLib.Proxy_CombatMonsterDisplayProxy , this );
			//EventExpress.AddEventRequest( NetEvent.NetResult , this.onNetResult , this );//建立連線事件接收
			
			trace( "CombatMonsterDisplayProxy constructed !!" );
		}
		
		/*public function InitModule(  ):void {
			//GUI00002_ANI 公用元件包
		}*/
		
		private function TerminateModule():void {
			//EventExpress.RevokeEventRequest( NetEvent.NetResult , this.onNetResult );//終結連線事件接收
			//EventExpress.RevokeAddressRequest( this.onNetResult );//終結連線事件接收
			//EventExpress.RevokeAddressRequest( this.ComponentReturned );
			CombatMonsterDisplayProxy._CombatMonsterDisplayProxy = null;
			for (var i:* in this._MonsterComponentDictionary ) {
				//this._MonsterComponentDictionary[ i ] = null;
				delete this._MonsterComponentDictionary[ i ];
			}
			
		}
		
		/*private function LoadMonsterExtraHurtGraphics():void {
			var _RemoteCache:RemoteCache = new RemoteCache( "MOB00042_ANI" , this.MonsterExtraHurtGraphicsLoadingComplete );
		}*/
		
		/*private function MonsterExtraHurtGraphicsLoadingComplete( _ComponentKey:String ):void {
			MotionValue.GetInstance()._MonsterExtraHurtGraphics
		}*/
		
		
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
		/**
		 * @author 注意:該函式會自動開啟MonsterDisplay的Alive 與 ShowContent
		 * @param	_InputFighterList BattleFighter VO list
		 * @return
		 */
		public function GetMonsterDisplayList( _InputFighterList:Vector.<BattleFighter> ):Vector.<MonsterDisplay> {//取得怪物顯示快取容器
			this._CurrentReady = 0;
			//_InputFighterList:Vector.<BattleFighter>
			
			/*//-----SORT所使用的						戰鬥類   不需要排序121206
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
			
			//var _MonsterList:Vector.<BattleFighter> = _InputFighterVo;
			//var _MonsterList:Array = this._PlayerMonsterDataCenter.GetMonsterList( _InputSort );//向PlayerMonsterDataCenter要重新排序過的怪物清單
			
			
			var _CurrentListTarget:BattleFighter;	//怪物物件指標	這裡的怪物數值是由戰鬥系統傳入  原物件型態為 BattleFighter
			var _CurrentDictionaryTarget:MonsterDisplay;
			this._E2Ready = _InputFighterList.length;
			for (var i:int = 0; i < this._E2Ready ; i++) {
				_CurrentListTarget = _InputFighterList[ i ] as BattleFighter;
				_CurrentDictionaryTarget = this._MonsterComponentDictionary[ _CurrentListTarget._guid ];
				( _CurrentDictionaryTarget == null  ) ?	//比對舊資料與新資料重疊的部分  避免產生過多的快取容器  拖累效能
					_CurrentDictionaryTarget = new MonsterDisplay( _CurrentListTarget , true , "CombatMonsterDisplayProxy" )	//若沒有抓過的怪物 則新增快取容器
					:
					MonsterDisplay( _CurrentDictionaryTarget ).UpdateMonsterValue( _CurrentListTarget );	//若有抓過怪物 則更新怪物數值
				this._MonsterComponentDictionary[ _CurrentListTarget._guid ] = _CurrentDictionaryTarget;
				_MonsterDisplayList.push( _CurrentDictionaryTarget );	//將結果推入陣列中
				
				//_CurrentDictionaryTarget.Alive = true;//戰鬥為動態控制物件 這裡先自動開啟 
				
				_CurrentDictionaryTarget._ReadyNotifyAddress = this.ReadyReciver;
				_CurrentDictionaryTarget.ShowContent();//並且顯示
			}
			
			/*this._E2Ready = _InputFighterList.length;
			var _CurrentMonsterDisplay:MonsterDisplay;
			for (var i:int = 0; i < this._E2Ready ; i++) {
				_CurrentMonsterDisplay = this.GetMonsterDisplayWithObject( _InputFighterList[ i ] as Object );
				_MonsterDisplayList.push( _CurrentMonsterDisplay );
			}*/
			
			//_AutoShowContent == true ? this.ShowContent( _MonsterDisplayList ) : null;
			
			return _MonsterDisplayList;
		}
		
		
			private function ReadyReciver( _InputReadyID:String ):void {
				//trace( _InputReadyID , "Ready <<----------------------" );
				this._CurrentReady++;
				this.ReadyChecker();
			}
			
			private function ReadyChecker():void {
				//----------Send Ready Notify
				( this._CurrentReady >= this._E2Ready ) ? this.SendNotify( CombatMonsterDisplayProxy.ReadySignal ) : null;
				//( this._CurrentReady >= this._E2Ready ) ? trace( "SkillsAreReady" ) : null;
			}
		/*public function ShowContent( _InputMonsterDisplayList:Vector.<MonsterDisplay> ):void {
			var _ArrayLength:uint = _InputMonsterDisplayList.length;
			for (var i:int = 0 ; i < _ArrayLength ; i++) {
				_InputMonsterDisplayList[ i ].ShowContent();
			}
		}*/
		
		public function GetMonsterDisplay( _InputMonsterGuid:String ):MonsterDisplay {
			//必須執行過GetMonsterDisplayList才有可能拿得到指標
			return this._MonsterComponentDictionary[ _InputMonsterGuid ];
		}
		
		public function GetMonsterDisplayClone( _InputMonsterGuid:String ):MonsterDisplay {
			//必須執行過GetMonsterDisplayList才有可能拿得到clone
			/*var _CurrentTarget:MonsterDisplay = this._MonsterComponentDictionary[ _InputMonsterGuid ];
			return _CurrentTarget != null ? new MonsterDisplay( _CurrentTarget.MonsterData ) : null;*/
			this._ComponentClones = ( this._ComponentClones == null ) ? new Vector.<MonsterDisplay> : this._ComponentClones;
			var _CurrentTarget:MonsterDisplay = this._MonsterComponentDictionary[ _InputMonsterGuid ];
			var _Result:MonsterDisplay;
			if ( _CurrentTarget != null ) {
				//var _CloneData:Object = this.MakeClone( _CurrentTarget.MonsterData );
					//_CloneData._guid += this._ComponentClones.length;
				_Result = new MonsterDisplay( _CurrentTarget.MonsterData , false , "CombatMonsterDisplayProxyClone" + this._ComponentClones.length );
				this._ComponentClones.push( _Result );
			}
			
			return _Result;
		}
		
		/*public function GetMonsterDisplayWithObject( _InputMonsterVO:Object ):MonsterDisplay {
			var _CurrentListTarget:Object;	//怪物物件指標	這裡的怪物數值是由戰鬥系統傳入  原物件型態為 BattleFighter
			var _CurrentDictionaryTarget:MonsterDisplay;
			this._ComponentClones = ( this._ComponentClones == null )? new Vector.<MonsterDisplay> : this._ComponentClones;
			
			_CurrentListTarget = _InputMonsterVO as Object;
									
					
			_CurrentListTarget._guid += this._ComponentClones.length;	
			_CurrentDictionaryTarget = new MonsterDisplay( _CurrentListTarget );
			this._ComponentClones.push( _CurrentDictionaryTarget );
					
				//this._MonsterComponentDictionary[ _CurrentListTarget._guid ] = _CurrentDictionaryTarget;
				//_MonsterDisplayList.push( _CurrentDictionaryTarget );	//將結果推入陣列中
				
				_CurrentDictionaryTarget.Alive = true;//戰鬥為動態控制物件 這裡先自動開啟 
				
				//_CurrentDictionaryTarget.ReadyNotifyAddress = this.ReadyReciver;
				_CurrentDictionaryTarget.ShowContent();//並且顯示
				
			return _CurrentDictionaryTarget;
		}*/
		
		
		
		
		
		
		public function ClearAll():void {//清空所有快取容器內容(以確保所有容器都被清空)
			for ( var i:* in this._MonsterComponentDictionary ) {
				MonsterDisplay( this._MonsterComponentDictionary[ i ] ).Destroy();
				delete this._MonsterComponentDictionary[i];
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