package MVCprojectOL.ModelOL.SkillDisplayModel {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 12.12.11.15.07
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
		
	public final class SkillDisplayProxy extends ProxY {//extends ProxY
		
		private static var _SkillDisplayProxy:SkillDisplayProxy;
		private var _ComponentClones:Vector.<SkillDisplay>;
		//private var _MonsterList:Array = [];
		private var _SkillComponentDictionary:Dictionary;
		
		private var _SkillDataCenter:SkillDataCenter;
		//private var _Net:AmfConnector = AmfConnector.GetInstance();
		//private var _SourceProxy:SourceProxy = SourceProxy.GetInstance();
		
		//private var _PublicComponentPackKey:String = "GUI00001_ANI";//公用素材包KEY
		
		public static function GetInstance():SkillDisplayProxy {
			return SkillDisplayProxy._SkillDisplayProxy = ( SkillDisplayProxy._SkillDisplayProxy == null ) ? new SkillDisplayProxy() : SkillDisplayProxy._SkillDisplayProxy; //singleton pattern
		}
		
		public function SkillDisplayProxy() {
			//constructor
			SkillDisplayProxy._SkillDisplayProxy = this;
			super( ProxyNameLib.Proxy_SkillDisplayProxy , this );
			//EventExpress.AddEventRequest( NetEvent.NetResult , this.onNetResult , this );//建立連線事件接收
			this._SkillComponentDictionary = new Dictionary();
			this._SkillDataCenter = SkillDataCenter.GetInstance();
			
			trace( "SkillDisplayProxy constructed !!" );
		}
		
		/*public function InitModule(  ):void {
			//GUI00002_ANI 公用元件包
		}*/
		
		private function TerminateModule():void {
			//EventExpress.RevokeEventRequest( NetEvent.NetResult , this.onNetResult );//終結連線事件接收
			//EventExpress.RevokeAddressRequest( this.onNetResult );//終結連線事件接收
			//EventExpress.RevokeAddressRequest( this.ComponentReturned );
			SkillDisplayProxy._SkillDisplayProxy = null;
			for (var i:* in this._SkillComponentDictionary ) {
				this._SkillComponentDictionary[ i ] = null;
				delete this._SkillComponentDictionary[ i ];
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
		public function GetSkillDisplayList( _InputSkillKey:Vector.<String> , _AutoShowContent:Boolean = false ):Vector.<SkillDisplay> {//取得怪物顯示快取容器
			
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
			var _SkillDisplayList:Vector.<SkillDisplay> = new Vector.<SkillDisplay>();
			
			
			//var _MonsterList:Array = this._SkillDataCenter.GetMonsterList( _InputSort );//向SkillDataCenter要重新排序過的怪物清單
			
			
			//var _CurrentListTarget:Object;	//物件指標	Note : _SkillDataCenter 不會回傳VO本體  而是包裝在Object中
			//var _CurrentDictionaryTarget:SkillDisplay;
			var _SkillListLength:uint = _InputSkillKey.length;
			for (var i:int = 0; i < _SkillListLength ; i++) {
				/*_CurrentListTarget = this._SkillDataCenter.GetSkill( _InputSkillKey[ i ] );
				if ( _CurrentListTarget == null ) break;//若給錯誤ID Skill會是空值
				_CurrentDictionaryTarget = this._SkillComponentDictionary[ _CurrentListTarget._guid ];
				( _CurrentDictionaryTarget == null  ) ?	//比對舊資料與新資料重疊的部分  避免產生過多的快取容器  拖累效能
					_CurrentDictionaryTarget = new SkillDisplay( _CurrentListTarget )	//若沒有抓過的怪物 則新增快取容器
					:
					SkillDisplay( _CurrentDictionaryTarget ).UpdateSkillValue( _CurrentListTarget );	//若有抓過怪物 則更新怪物數值
				this._SkillComponentDictionary[ _CurrentListTarget._guid ] = _CurrentDictionaryTarget;*/
				_SkillDisplayList.push( this.GetSkillDisplay( _InputSkillKey[ i ] ) );	//將結果推入陣列中
			}
			
			_AutoShowContent == true ? this.ShowContent( _SkillDisplayList ) : null;
			
			return _SkillDisplayList;
		}
		
		public function ShowContent( _InputSkillDisplayList:Vector.<SkillDisplay> ):void {
			var _ArrayLength:uint = _InputSkillDisplayList.length;
			for (var i:int = 0 ; i < _ArrayLength ; i++) {
				_InputSkillDisplayList[ i ].ShowContent();
			}
		}
		
		public function GetSkillDisplay( _InputSkillKey:String ):SkillDisplay {
			//必須執行過GetSkillDisplayList才有可能拿得到指標
			var _CurrentListTarget:Skill = this._SkillDataCenter.GetSkill( _InputSkillKey );	//物件指標	Note : _SkillDataCenter 不會回傳VO本體  而是包裝在Object中
			if ( _CurrentListTarget == null ) return null;
			var _CurrentDictionaryTarget:SkillDisplay = this._SkillComponentDictionary[ _CurrentListTarget._guid ];
				( _CurrentDictionaryTarget == null  ) ?	//比對舊資料與新資料重疊的部分  避免產生過多的快取容器  拖累效能
					_CurrentDictionaryTarget = new SkillDisplay( _CurrentListTarget )	//若沒有抓過的怪物 則新增快取容器
					:
					SkillDisplay( _CurrentDictionaryTarget ).UpdateSkillValue( _CurrentListTarget );	//若有抓過怪物 則更新怪物數值
				this._SkillComponentDictionary[ _CurrentListTarget._guid ] = _CurrentDictionaryTarget;
			
			return this._SkillComponentDictionary[ _InputSkillKey ];
		}
		
		public function GetSkillDisplayClone( _InputSkillKey:String ):SkillDisplay {
			//必須執行過GetSkillDisplayList或GetSkillDisplay才有可能拿得到clone
			/*var _CurrentTarget:SkillDisplay = this._SkillComponentDictionary[ _InputSkillKey ];
			return _CurrentTarget != null ? new SkillDisplay( _CurrentTarget.Data ) : null;*/
			
			
			
			
			this._ComponentClones = ( this._ComponentClones == null )? new Vector.<SkillDisplay> : this._ComponentClones;
			var _CurrentTarget:SkillDisplay = this._SkillComponentDictionary[ _InputSkillKey ];
			var _Result:SkillDisplay;
			if ( _CurrentTarget != null ) {
				_Result = new SkillDisplay( _CurrentTarget.Data );
				this._ComponentClones.push( _Result );
			}
			
			return _Result;
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