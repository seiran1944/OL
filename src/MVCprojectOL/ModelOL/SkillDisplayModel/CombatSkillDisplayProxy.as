package MVCprojectOL.ModelOL.SkillDisplayModel {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.01.17.11.30
	 */
	
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Vo.Skill;
	
	

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
	
	import MVCprojectOL.ModelOL.SkillData.SkillDataCenter;
	import strLib.proxyStr.ProxyNameLib;
	
	import MVCprojectOL.ModelOL.SkillDisplayModel.CombatSkillDisplay;
		
	public final class CombatSkillDisplayProxy extends ProxY {//extends ProxY
		public static const ReadySignal:String = "CombatSkillDisplaysAreReady";
		private static var _CombatSkillDisplayProxy:CombatSkillDisplayProxy;
		private var _ComponentClones:Vector.<CombatSkillDisplay>;
		//private var _MonsterList:Array = [];
		private var _SkillComponentDictionary:Dictionary;
		
		private var _SkillDataCenter:SkillDataCenter;
		//private var _Net:AmfConnector = AmfConnector.GetInstance();
		//private var _SourceProxy:SourceProxy = SourceProxy.GetInstance();
		
		//private var _PublicComponentPackKey:String = "GUI00001_ANI";//公用素材包KEY
		private var _IDSpliter:uint = 0;//用來區隔開相同ID  造成VISION CENTER無法播放的問題
		
		private var _E2Ready:uint = 0;
		private var _CurrentReady:uint = 0;
		
		public static function GetInstance():CombatSkillDisplayProxy {
			return CombatSkillDisplayProxy._CombatSkillDisplayProxy = ( CombatSkillDisplayProxy._CombatSkillDisplayProxy == null ) ? new CombatSkillDisplayProxy() : CombatSkillDisplayProxy._CombatSkillDisplayProxy; //singleton pattern
		}
		
		public function CombatSkillDisplayProxy() {
			//constructor
			CombatSkillDisplayProxy._CombatSkillDisplayProxy = this;
			super( ProxyNameLib.Proxy_CombatSkillDisplayProxy , this );
			//EventExpress.AddEventRequest( NetEvent.NetResult , this.onNetResult , this );//建立連線事件接收
			this._SkillComponentDictionary = new Dictionary();
			this._SkillDataCenter = SkillDataCenter.GetInstance();
			
			trace( "CombatSkillDisplayProxy constructed !!" );
		}
		
		/*public function InitModule(  ):void {
			//GUI00002_ANI 公用元件包
		}*/
		
		private function TerminateModule():void {
			//EventExpress.RevokeEventRequest( NetEvent.NetResult , this.onNetResult );//終結連線事件接收
			//EventExpress.RevokeAddressRequest( this.onNetResult );//終結連線事件接收
			//EventExpress.RevokeAddressRequest( this.ComponentReturned );
			for (var i:* in this._SkillComponentDictionary ) {
				this._SkillComponentDictionary[ i ] = null;
				delete this._SkillComponentDictionary[ i ];
			}
			CombatSkillDisplayProxy._CombatSkillDisplayProxy = null;
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
		public function GetCombatSkillDisplayList( _InputSkillKey:Vector.<String> ):Vector.<CombatSkillDisplay> {//取得怪物顯示快取容器
			this._CurrentReady = 0;
			//_AutoShowContent = true 改為主動121228
			var _SkillDisplayList:Vector.<CombatSkillDisplay> = new Vector.<CombatSkillDisplay>();
			
			
			//var _MonsterList:Array = this._SkillDataCenter.GetMonsterList( _InputSort );//向SkillDataCenter要重新排序過的怪物清單
			
			
			//var _CurrentListTarget:Object;	//物件指標	Note : _SkillDataCenter 不會回傳VO本體  而是包裝在Object中
			//var _CurrentDictionaryTarget:CombatSkillDisplay;
			this._E2Ready = _InputSkillKey.length;
			for (var i:int = 0; i < this._E2Ready ; i++) {
				/*_CurrentListTarget = this._SkillDataCenter.GetSkill( _InputSkillKey[ i ] );
				if ( _CurrentListTarget == null ) break;//若給錯誤ID Skill會是空值
				_CurrentDictionaryTarget = this._SkillComponentDictionary[ _CurrentListTarget._guid ];
				( _CurrentDictionaryTarget == null  ) ?	//比對舊資料與新資料重疊的部分  避免產生過多的快取容器  拖累效能
					_CurrentDictionaryTarget = new SkillDisplay( _CurrentListTarget )	//若沒有抓過的怪物 則新增快取容器
					:
					SkillDisplay( _CurrentDictionaryTarget ).UpdateSkillValue( _CurrentListTarget );	//若有抓過怪物 則更新怪物數值
				this._SkillComponentDictionary[ _CurrentListTarget._guid ] = _CurrentDictionaryTarget;*/
				_SkillDisplayList.push( this.GetCombatSkillDisplay( _InputSkillKey[ i ] ) );	//將結果推入陣列中
			}
			
			//_AutoShowContent == true ? this.ShowContent( _SkillDisplayList ) : null;
			
			return _SkillDisplayList;
		}
		
		/*public function ShowContent( _InputSkillDisplayList:Vector.<CombatSkillDisplay> ):void {
			var _ArrayLength:uint = _InputSkillDisplayList.length;
			for (var i:int = 0 ; i < _ArrayLength ; i++) {
				_InputSkillDisplayList[ i ].ShowContent();
			}
		}*/
			
			
			private function ReadyReciver( _InputReadyID:String ):void {
				//trace( _InputReadyID , "Ready <<----------------------" );
				this._CurrentReady++;
				this.ReadyChecker();
			}
			
			private function ReadyChecker():void {
				//----------Send Ready Notify
				( this._CurrentReady >= this._E2Ready ) ? this.SendNotify( CombatSkillDisplayProxy.ReadySignal ) : null;
				//( this._CurrentReady >= this._E2Ready ) ? trace( "SkillsAreReady" ) : null;
			}
		
		
		public function GetCombatSkillDisplay( _InputSkillKey:String ):CombatSkillDisplay {
			//必須執行過GetSkillDisplayList才有可能拿得到指標
			//var _CurrentListTarget:Object = this.SearchSkillOrSkillEffect( _InputSkillKey );	//物件指標	Note : _SkillDataCenter 不會回傳VO本體  而是包裝在Object中
			var _CurrentListTarget:Skill = this._SkillDataCenter.GetSkill( _InputSkillKey );	//物件指標	Note : _SkillDataCenter 不會回傳VO本體  而是包裝在Object中
			if ( _CurrentListTarget == null ) return null;//若為空物件則不處理
			var _CurrentDictionaryTarget:CombatSkillDisplay = this._SkillComponentDictionary[ _CurrentListTarget._guid ];
				( _CurrentDictionaryTarget == null  ) ?	//比對舊資料與新資料重疊的部分  避免產生過多的快取容器  拖累效能
					_CurrentDictionaryTarget = new CombatSkillDisplay( _CurrentListTarget )	//若沒有抓過的怪物 則新增快取容器
					:
					CombatSkillDisplay( _CurrentDictionaryTarget ).UpdateSkillValue( _CurrentListTarget );	//若有抓過怪物 則更新怪物數值
				this._SkillComponentDictionary[ _CurrentListTarget._guid ] = _CurrentDictionaryTarget;
				
				_CurrentDictionaryTarget._ReadyNotifyAddress = this.ReadyReciver;
				_CurrentDictionaryTarget.ShowContent();//改為主動121228
				
			return this._SkillComponentDictionary[ _InputSkillKey ];
			
			
			/*//----------------------------------------------for simulation
			var _CombatSkillValue:Skill = new Skill();
				_CombatSkillValue._guid = _InputSkillKey;// + this._IDSpliter;
				_CombatSkillValue._iconKey = "QQQQQ_0001";
				_CombatSkillValue._name = "無敵風火輪" + _InputSkillKey;
				
			var _SS:CombatSkillDisplay = new CombatSkillDisplay( _CombatSkillValue , this._IDSpliter );
				_SS.ReadyNotifyAddress = this.ReadyReciver;
				_SS.ShowContent();
				
			this._SkillComponentDictionary[ _InputSkillKey ] = _SS;
			//this._IDSpliter++;
				
			return _SS;
			//-------------------------------------END------for simulation*/
		}
		
		/*private function SearchSkillOrSkillEffect( _InputSkillKey:String ):Object {
			var _CurrentTarget:Object = this._SkillDataCenter.GetSkill( _InputSkillKey );
				_CurrentTarget = ( _CurrentTarget == null ) ? this._SkillDataCenter.GetSkillEffect( _InputSkillKey ) : _CurrentTarget;
			return _CurrentTarget;
		}*/
		
		public function GetCombatSkillDisplayClone( _InputSkillKey:String ):CombatSkillDisplay {
			this._ComponentClones = ( this._ComponentClones == null )? new Vector.<CombatSkillDisplay> : this._ComponentClones;
			
			//必須執行過GetSkillDisplayList或GetSkillDisplay才有可能拿得到clone
			this._CurrentReady = 0;
			this._IDSpliter++;
			var _CurrentTarget:CombatSkillDisplay = this._SkillComponentDictionary[ _InputSkillKey ];
			
			if ( _CurrentTarget != null ) {
				_CurrentTarget = new CombatSkillDisplay( _CurrentTarget.Data , this._IDSpliter );
				_CurrentTarget.ShowContent();
			}else {
				_CurrentTarget = this.GetCombatSkillDisplay( _InputSkillKey );
			}
			this._ComponentClones.push( _CurrentTarget );
			return _CurrentTarget;
			//return ( _CurrentTarget != null ) ? new CombatSkillDisplay( _CurrentTarget.Data , this._IDSpliter ) : this.GetCombatSkillDisplay( _InputSkillKey );
		}
		
		public function ClearAll():void {//清空所有快取容器內容(以確保所有容器都被清空)
			for ( var i:* in this._SkillComponentDictionary ) {
				this._SkillComponentDictionary[ i ].Destroy();
				delete this._SkillComponentDictionary[ i ];
			}
			this._SkillComponentDictionary = null;
			
			if ( this._ComponentClones != null ) {
				for (var j:int = 0; j < this._ComponentClones.length; j++) {
					this._ComponentClones.pop().Destroy();
				}
				this._ComponentClones = null;
			}
			
			this._SkillDataCenter = null;
		}
		
		override public function onRemovedProxy():void {
			this.ClearAll();//在模組結束時   確保所有項目都被清空(包含監聽)
			this.TerminateModule();
		}
		//================================================================END======Actions
		
		
		
		
		
		
		
		//======================================================================Condition judges
		
	
		
		
		//=============================================================END======Condition judges
		
		
		
		
		
		
		//====================================================================================Send message
		
	
		//==========================================================================END=======Send message
		
		
		
		
		
		
		
		
		
		
	}//end class
}//end package

	/*class IDSpliter {
		private static var _IDSpliter:IDSpliter;
		private var _Split:uint = 0;
		
		public static function GetInstance():IDSpliter {
			return IDSpliter._IDSpliter = ( IDSpliter._IDSpliter == null ) ? new IDSpliter() : IDSpliter._IDSpliter; //singleton pattern
		}
		
		public function get Split():uint {
			this._Split++;
			return _Split;
		}
	}//end class*/