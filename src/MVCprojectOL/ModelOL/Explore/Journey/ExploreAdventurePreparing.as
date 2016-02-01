package MVCprojectOL.ModelOL.Explore.Journey {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.05.23.11.09
	 */
	
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.Explore.Data.ExploreDataCenter;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleFighter;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.commandStr.ExploreAdventureStrLib;
	 
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.CommandsStrLad;
		
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	
	import MVCprojectOL.ModelOL.MonsterDisplayModel.CombatMonsterDisplayProxy;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	
	import MVCprojectOL.ModelOL.Monster.PlayerMonsterDataCenter;
	//import MVCprojectOL.ModelOL.Explore.ExploreEvent;
		
	//----------------------------------------------------------------------VOs
	//import MVCprojectOL.ModelOL.Vo.Get.Get_ExploreFightResult; //wasted 121009
	
	//-------------------------------------------------------------END------VOs
	
	
	import strLib.proxyStr.ProxyNameLib;
	
	import MVCprojectOL.ModelOL.LoadingCache.MultiRemoteCache;
		
	public class ExploreAdventurePreparing extends ProxY{//extends ProxY
		private static var _ExploreAdventurePreparing:ExploreAdventurePreparing;
		
		private var _ExploreDataCenter:ExploreDataCenter;
		
		private var _Net:AmfConnector = AmfConnector.GetInstance();
		private var _MultiRemoteCache:MultiRemoteCache;
		
		private var _PlayerMonsterDataCenter:PlayerMonsterDataCenter = PlayerMonsterDataCenter.GetMonsterData();
		//private var _CombatMonsterDisplayProxy:CombatMonsterDisplayProxy = CombatMonsterDisplayProxy.GetInstance();
		
		private var _ComponentClones:Vector.<MonsterDisplay>;
		
		private var _SourceProxy:SourceProxy = SourceProxy.GetInstance();
		
		
		public static function GetInstance():ExploreAdventurePreparing {
			return ExploreAdventurePreparing._ExploreAdventurePreparing = ( ExploreAdventurePreparing._ExploreAdventurePreparing == null ) ? new ExploreAdventurePreparing() : ExploreAdventurePreparing._ExploreAdventurePreparing; //singleton pattern
		}
		
		public function ExploreAdventurePreparing() {
			//constructor
			super( ProxyNameLib.Proxy_ExploreAdventurePreparing , this );
			ExploreAdventurePreparing._ExploreAdventurePreparing = this;
			//EventExpress.AddEventRequest( NetEvent.NetResult , this.onNetResult , this );//建立連線事件接收
			
			this._ExploreDataCenter = ExploreDataCenter.GetInstance();
			trace( "ExploreAdventurePreparing constructed !!" );
		}
		
		public function PrepareAreaScene( _InputExploreAreaKey:String ):void {
			/*var _ScenesKey:Vector.<String> = Vector.<String>( this._ExploreDataCenter.GetExploreAreaSceneKeys( _InputExploreAreaKey ) );
			var _Check:Boolean = false;	
			for (var i:int = 0; i < _ScenesKey.length; i++) {
				_Check = _ScenesKey[ i ] == this._ExploreDataCenter._uiKey ? true : false;
			}
			_Check == false ? _ScenesKey.push( this._ExploreDataCenter._uiKey ) : null;*/
				
			var _ScenesKey:Vector.<String> = new Vector.<String>();
				_ScenesKey.push( this._ExploreDataCenter.GetExploreAreaSceneKeys( _InputExploreAreaKey ) );
			this.StartLoad( _ScenesKey );
			
		}
		
		private function StartLoad( _InputComponentKeys:Vector.<String> ):void {
			this.GetMonsterPrepared();
			trace( "ExploreAdventurePreparing initing" , _InputComponentKeys );
			//在這裡發送LOADING指令	130218
			this._SourceProxy.PreloadMaterial( this._ExploreDataCenter._HealSkill._effectKey );//預載治癒技能素材
			this._SourceProxy.PreloadMaterial( this._ExploreDataCenter._LvUpSkill._effectKey );//預載治癒技能素材
			this._MultiRemoteCache = this._MultiRemoteCache == null ? new MultiRemoteCache( _InputComponentKeys , this.ComponentReturned , null , true ) : this._MultiRemoteCache;
			this._MultiRemoteCache._SingleCompleteAddress = this.SingleComplete;
			this._MultiRemoteCache.StartLoad();
		}
		
		private function TerminateModule():void {
			if ( this._MultiRemoteCache != null ) {
				this._MultiRemoteCache.Stop();
				//this._MultiRemoteCache.Clear();
				this._MultiRemoteCache = null;
			}
			
			//this._CombatMonsterDisplayProxy.onRemovedProxy();
			if ( this._ComponentClones != null ) {
				for (var j:int = 0; j < this._ComponentClones.length; j++) {
					this._ComponentClones.pop().Destroy();
				}
				this._ComponentClones = null;
			}
			
			
			ExploreAdventurePreparing._ExploreAdventurePreparing = null;
		}
		
		
		//=========================================================================Actions
		
		//================================================================END======Actions
		
		
		
		//=====================================================================Net message transport router
		private function SingleComplete( _InputKey:String ):void {
			//( _InputKey.substr( 0 , 3 ) == this._ExploreDataCenter._uiKey ) ? this._ExploreDataCenter._uiBitmapData =  : this._ExploreDataCenter.AddSceneMap( _InputKey );
			this._ExploreDataCenter.AddSceneMap( _InputKey );
		}
		
		
		
		private function ComponentReturned( _InputKey:String ):void {
			//Load完了
			//this.GetMonsterPrepared();
			this.SendNotify( ExploreAdventureStrLib.ExploreAdventurePreparing_AllReady );
		}//end ComponentReturned
		//=============================================================END=====Net message transport router
		
		private function GetMonsterPrepared():void {
				//取得己方怪物顯示實體
				var _MonsterMemberList:Object = this._ExploreDataCenter._currentSelectedTeamMember; 
				var _currentMonsterDisplay:MonsterDisplay;
				for ( var i:* in _MonsterMemberList ) {
					//trace( i , _MonsterMemberList[ i ] , "<<<<<<<<探索怪物" );
						_currentMonsterDisplay = this.GetMonsterDisplayByKey( _MonsterMemberList[ i ] );
					this._ExploreDataCenter._currentSelectedTeamMemberDisplays[ i ] = _currentMonsterDisplay;//依照組隊索引位置建立Display物件清單
					this._ExploreDataCenter._currentSelectedTeamMemberDisplayIDDictionary[ _currentMonsterDisplay.MonsterData._guid ] = _currentMonsterDisplay;//依照惡魔ID建立顯示實體索引清單
					this._ExploreDataCenter.SetMonsterPrimitiveValue( _currentMonsterDisplay.MonsterData._guid , _currentMonsterDisplay.MonsterData );//記錄怪物初始數值
					this._ExploreDataCenter._currentSelectedTeamMemberPos[ _MonsterMemberList[ i ] ] = i;//建立GUID反查清單 以利搜尋
				}
		}
		
		public function GetEnemyMonsterPrepared( _InputMonsterList:Object ):void {
			var _EnemyTeamMemberDisplays:Object = { };
			for (var i:* in _InputMonsterList) {
				//trace( i , _InputMonsterList[ i ]._guid , "<<<<<<<<敵方怪物" );
				_EnemyTeamMemberDisplays[ i ] = this.GetMonsterDisplayWithObject( _InputMonsterList[ i ] as Object );//BattleFighter依照組隊索引位置建立Display物件清單
			}
			this._ExploreDataCenter._currentEnemyTeamMemberDisplays = _EnemyTeamMemberDisplays;
		}
		//======================================================================Condition judges
		/*public function GetMonsterDisplayByKey( _InputMonsterKey:Vector.<String> ):Vector.<MonsterDisplay> {
			var _MonsterDisplayList:Vector.<MonsterDisplay> = new Vector.<MonsterDisplay>();
			
			var _Length:uint = _InputMonsterKey.length;
			var _CurrentMonsterVO:Object;
			for (var i:int = 0; i < _Length ; i++) {
				_CurrentMonsterVO = this._PlayerMonsterDataCenter.GetSingleMonster( _InputMonsterKey[ i ] );
				_MonsterDisplayList.push( this._CombatMonsterDisplayProxy.GetMonsterDisplayWithObject( _CurrentMonsterVO ) );
			}
			
			return _MonsterDisplayList;
		}*/
		/*private function GetMonsterDisplayByKey( _InputMonsterKey:String ):MonsterDisplay {
			//var _MonsterDisplayList:Vector.<MonsterDisplay> = new Vector.<MonsterDisplay>();
			
			//var _Length:uint = _InputMonsterKey.length;
			var _CurrentMonsterVO:Object;
			//for (var i:int = 0; i < _Length ; i++) {
				_CurrentMonsterVO = this._PlayerMonsterDataCenter.GetSingleMonster( _InputMonsterKey );
				//_MonsterDisplayList.push( this._CombatMonsterDisplayProxy.GetMonsterDisplayWithObject( _CurrentMonsterVO ) );
			//}
			
			return this._CombatMonsterDisplayProxy.GetMonsterDisplayWithObject( _CurrentMonsterVO );
		}*/
		
		private function GetMonsterDisplayByKey( _InputMonsterKey:String ):MonsterDisplay {
			//var _MonsterDisplayList:Vector.<MonsterDisplay> = new Vector.<MonsterDisplay>();
			
			//var _Length:uint = _InputMonsterKey.length;
			var _CurrentMonsterVO:Object;
			//for (var i:int = 0; i < _Length ; i++) {
				_CurrentMonsterVO = this._PlayerMonsterDataCenter.GetSingleMonster( _InputMonsterKey );
				//_MonsterDisplayList.push( this._CombatMonsterDisplayProxy.GetMonsterDisplayWithObject( _CurrentMonsterVO ) );
			//}
			
			return this.GetMonsterDisplayWithObject( _CurrentMonsterVO );
		}
		
		
		/*private function GetMonsterDisplayByVo( _InputMonsterVo:Object ):MonsterDisplay {//BattleFighter
			return this._CombatMonsterDisplayProxy.GetMonsterDisplayWithObject( _InputMonsterVo );
		}*/
		
		public function GetMonsterDisplayWithObject( _InputMonsterVO:Object ):MonsterDisplay {
			var _CurrentListTarget:Object;	//怪物物件指標	這裡的怪物數值是由戰鬥系統傳入  原物件型態為 BattleFighter
			var _CurrentDictionaryTarget:MonsterDisplay;
			this._ComponentClones = ( this._ComponentClones == null )? new Vector.<MonsterDisplay> : this._ComponentClones;
			
			_CurrentListTarget = _InputMonsterVO as Object;
				/*_CurrentDictionaryTarget = this._MonsterComponentDictionary[ _CurrentListTarget._guid ];
				( _CurrentDictionaryTarget == null  ) ?	//比對舊資料與新資料重疊的部分  避免產生過多的快取容器  拖累效能
					_CurrentDictionaryTarget = new MonsterDisplay( _CurrentListTarget )	//若沒有抓過的怪物 則新增快取容器
					:
					MonsterDisplay( _CurrentDictionaryTarget ).UpdateMonsterValue( _CurrentListTarget );	//若有抓過怪物 則更新怪物數值*/
					
					
			//_CurrentListTarget._guid += this._ComponentClones.length;	
			_CurrentDictionaryTarget = new MonsterDisplay( _CurrentListTarget, true , "Explore" + this._ComponentClones.length + Math.random() );
			this._ComponentClones.push( _CurrentDictionaryTarget );
					
				//this._MonsterComponentDictionary[ _CurrentListTarget._guid ] = _CurrentDictionaryTarget;
				//_MonsterDisplayList.push( _CurrentDictionaryTarget );	//將結果推入陣列中
				
				//_CurrentDictionaryTarget.Alive = true;//戰鬥為動態控制物件 這裡先自動開啟 
				
				//_CurrentDictionaryTarget.ReadyNotifyAddress = this.ReadyReciver;
				_CurrentDictionaryTarget.ShowContent();//並且顯示
				
			return _CurrentDictionaryTarget;
		}
		//=============================================================END======Condition judges
		
		public override function onRemovedProxy():void {
			this.TerminateModule();
		}
		
		
		
		
		//====================================================================================Send message    這些應該要在控制器中聽 並做出對應動作 130205

		//==========================================================================END=======Send message
		
		
		
		
		
		
		
		
		
		
	}//end class

}//end package