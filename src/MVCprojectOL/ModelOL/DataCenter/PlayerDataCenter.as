package MVCprojectOL.ModelOL.DataCenter {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 12.11.30
	 */
	import MVCprojectOL.ModelOL.DataCenter.PrimitiveDataCenter;
	import MVCprojectOL.ModelOL.Vo.PlayerBasicValue;
	//import MVCprojectOL.ModelOL.Vo.PlayerBasicVaule;
	import MVCprojectOL.ModelOL.Vo.PlayerData;
	import strLib.commandStr.UserInfoStr;
		
	import Spark.coreFrameWork.MVC.FacadeCenter;
	 
	public final class PlayerDataCenter {
		private static var _isInitialized:Boolean = false;
		
		private static var _PlayerID:String = "48313530454787098";//"Initialization uncompleted !!";//若系統未初始成功  會得到"Initialization uncompleted !!" 後續系統會出錯
		private static var _ServGateWay:String = "Initialization uncompleted !!";
		private static var _ServDomain:String = "Initialization uncompleted !!";
		private static var _Token:String = "c7a5dffa4ab154b949dc5ecf7606df6d";//121120 K.J.Aris
		private static var _LastServTime:uint = 0;//unix time from server , this value stores the last updated time from server 
		
		
	
	
		private static var _PlayerData:PlayerData;
		
		public static function Init( _InputPlayerID:String , _InputServGateWay:String , _InputServDomain:String , _InputToken:String,_InputSt:uint):void {
			if ( _isInitialized == false ) {
				PlayerDataCenter._isInitialized = true;
				PlayerDataCenter._PlayerID = _InputPlayerID;
				PlayerDataCenter._ServGateWay = _InputServGateWay;
				PlayerDataCenter._ServDomain = _InputServDomain;
				PlayerDataCenter._Token = _InputToken;//121120 K.J.Aris
				//---12/03---erichuang--
				PlayerDataCenter._LastServTime = _InputSt;
				//trace("_PlayerID>"+PlayerDataCenter._PlayerID);
				//trace("_ServGateWay>"+PlayerDataCenter._ServGateWay);
				//trace("_ServDomain>"+PlayerDataCenter._ServDomain);
			}else {
				trace( "Error : Double Initialization - Primitive Data can not be rewrite !!" );
			}
		}
		
		public static function WritePlayerData( _InputPlayerData:PlayerData ):void {
			//僅能透過PlayerDataProxy.as由Server寫入    否則只會拿到預設值 121107
			PlayerDataCenter._PlayerData = null;
			PlayerDataCenter._PlayerData = _InputPlayerData;
			trace("getPlayData0301____"+_InputPlayerData);
			trace("getPlayData<_loadingBgKey>0301____"+_InputPlayerData._loadingBgKey);
			
		}
		
		
		public static  function get HealKey():String
		{
			return PlayerDataCenter._PlayerData._healKey;
		}
		
		
		//------------------2013/3/05---eric-----新增monsterHPTimes/新增monsterFatigueTimes(生命值/疲勞度回復時間)
		//---怪獸生命值回復時間
		public static function GetMonsterHPTimes():uint 
		{
			return PlayerDataCenter._PlayerData._monsterHPTimes;
		}
		
		//---怪獸疲勞值回復時間
		public static function GetMonsterFatigueTimes():uint 
		{
			return PlayerDataCenter._PlayerData._monsterFatigueTimes;
		}
		//------------------2013/3/05---eric-------------------------
		public static function WriteServTime( _InputUnixTime:uint ):void {
			PlayerDataCenter._LastServTime = _InputUnixTime;
		}
		
		//--*---重設PlayerBasicVaule
		public static function SetPlayerDataVaule(_data:PlayerBasicValue):void 
		{
			if (PlayerDataCenter._PlayerData._playerValue._fur != _data._fur) PlayerDataCenter.addFur(_data._fur-PlayerDataCenter._PlayerData._playerValue._fur);
			if (PlayerDataCenter._PlayerData._playerValue._playerMony != _data._playerMony) PlayerDataCenter.addMoney(_data._playerMony-PlayerDataCenter._PlayerData._playerValue._playerMony);
			if (PlayerDataCenter._PlayerData._playerValue._playerSoul != _data._playerSoul) PlayerDataCenter.addSoul(_data._playerSoul-PlayerDataCenter._PlayerData._playerValue._playerSoul);
			if (PlayerDataCenter._PlayerData._playerValue._stone != _data._stone) PlayerDataCenter.addStone(_data._stone-PlayerDataCenter._PlayerData._playerValue._stone);
			if (PlayerDataCenter._PlayerData._playerValue._wood != _data._wood) PlayerDataCenter.addWood(_data._wood-PlayerDataCenter._PlayerData._playerValue._wood);
			
			PlayerDataCenter._PlayerData._playerValue = _data;
			 //----04/11---要再補重刷數值的動畫驅動
		}
		
		
		//---2013/3/14(TIPS專用的)----
	    
		public static function GetPlayerInfoTips(_obj:Object):PlayerData 
		{
			return PlayerDataCenter._PlayerData;
			
		}
		
		//---2013/03/18---取得顏色(品質)
		/*
		public static function GetQuaColor():Array
		{
			return PlayerDataCenter._PlayerData._aryQuaColor;
		}*/
		
		//============================================================value writing
		
		public static function addSoul( _InputIncrease:int ):int {
			//使用該方法來增加 或 減少(使用負號) 玩家靈魂量
			//外部無法直接操作該值  
			//該函式會回傳當前總量新值
			PlayerDataCenter._PlayerData._playerValue._playerSoul = PlayerDataCenter.CheckLimitBound( UserInfoStr.CHANGE_SOUL , PlayerDataCenter._PlayerData._playerValue._playerSoul , _InputIncrease );
			return PlayerDataCenter._PlayerData._playerValue._playerSoul;
			//須加入<0的狀況判斷  當<0時須有錯誤訊號
		}
		
		public static function addMoney( _InputIncrease:int ):int {
			//使用該方法來增加 或 減少(使用負號) 玩家台幣量
			//外部無法直接操作該值
			//該函式會回傳當前總量新值
			PlayerDataCenter._PlayerData._playerValue._playerMony = PlayerDataCenter.CheckLimitBound( UserInfoStr.CHANGE_MONEY , PlayerDataCenter._PlayerData._playerValue._playerMony , _InputIncrease );
			return PlayerDataCenter._PlayerData._playerValue._playerMony;
			//須加入<0的狀況判斷  當<0時須有錯誤訊號
		}
		
		public static function addFur( _InputIncrease:int ):int {
			//使用該方法來增加 或 減少(使用負號) 玩家毛皮量
			//外部無法直接操作該值
			//該函式會回傳當前總量新值
			PlayerDataCenter._PlayerData._playerValue._fur = PlayerDataCenter.CheckLimitBound( UserInfoStr.CHANGE_FUR , PlayerDataCenter._PlayerData._playerValue._fur , _InputIncrease );
			return PlayerDataCenter._PlayerData._playerValue._fur;
			//須加入<0的狀況判斷  當<0時須有錯誤訊號
		}
		
		public static function addStone( _InputIncrease:int ):int {
			//使用該方法來增加 或 減少(使用負號) 玩家石材量
			//外部無法直接操作該值
			//該函式會回傳當前總量新值
			PlayerDataCenter._PlayerData._playerValue._stone = PlayerDataCenter.CheckLimitBound( UserInfoStr.CHANGE_STONE , PlayerDataCenter._PlayerData._playerValue._stone , _InputIncrease );			
			return PlayerDataCenter._PlayerData._playerValue._stone;
			//須加入<0的狀況判斷  當<0時須有錯誤訊號
		}
		
		public static function addWood( _InputIncrease:int ):int {
			//使用該方法來增加 或 減少(使用負號) 玩家木材量
			//外部無法直接操作該值
			//該函式會回傳當前總量新值		
			PlayerDataCenter._PlayerData._playerValue._wood = PlayerDataCenter.CheckLimitBound( UserInfoStr.CHANGE_WOOD , PlayerDataCenter._PlayerData._playerValue._wood , _InputIncrease );
			return 	PlayerDataCenter._PlayerData._playerValue._wood;
			//須加入<0的狀況判斷  當<0時須有錯誤訊號
		}
		
		
		
		private static function CheckLimitBound( _InputSignalName:String , _InputOriValue:int , _InputIncrease:int ):int {
			
			return ( _InputOriValue <= 0 || ( _InputOriValue + _InputIncrease ) < 0 ) ? 
						_InputOriValue 
						: 
						PlayerDataCenter.WrapAndSend( _InputSignalName , _InputOriValue , ( _InputOriValue += _InputIncrease ) );//真正改變值在這裡
		}
		
		private static function WrapAndSend( _InputSignalName:String , _InputStartValue:int , _InputEndValue:int ):int {
			var _Result:Object = { 
				  _name:_InputSignalName, 
				  _start:_InputStartValue,
				  _end:_InputEndValue
				}; 
				
			FacadeCenter.GetFacadeCenter().SendNotify( UserInfoStr.CHANGE_USERINFO , _Result );
			
			return _InputEndValue
		}
		
		//----------------------------------------------------Getters
			//............................Primitive Data
			
			//............................0515--eric missionITEM---
			public static function get missionItem():String {
				return PlayerDataCenter._PlayerData._missionItem;
			}
			
			
			
			public static function get isInitialized():Boolean {
				return PlayerDataCenter._isInitialized;
			}
			
			public static function get PlayerID():String {
				return PlayerDataCenter._PlayerID;
			}
		
			public static function get ServGateWay():String {
				return PlayerDataCenter._ServGateWay;
			}
		
			public static function get ServDomain():String {
				return PlayerDataCenter._ServDomain;
			}
			//..................END.......Primitive Data
		
		
		public static  function get PlayerName():String {
			return PlayerDataCenter._PlayerData._playerName;
		}
		
		public static function get PlayerSoul():int {
			return PlayerDataCenter._PlayerData._playerValue._playerSoul;
		}
		
		public static function get PlayerMony():int {
			return PlayerDataCenter._PlayerData._playerValue._playerMony;
		}
		
		public static function get PlayerFur():int {
			return PlayerDataCenter._PlayerData._playerValue._fur;
		}
		
		public static function get PlayerStone():int {
			return PlayerDataCenter._PlayerData._playerValue._stone;
		}
		
		public static function get PlayerWood():int {
			return PlayerDataCenter._PlayerData._playerValue._wood;
		}
		
		public static function get SoundEffectSetting():Boolean {
			return PlayerDataCenter._PlayerData._soundEffectSetting;
		}
		
		public static function get SoundEffectValue():Number {
			return PlayerDataCenter._PlayerData._soundEffectValue;
		}
		
		public static function get BGMusicSetting():Boolean {
			return PlayerDataCenter._PlayerData._bGMusicSetting;
		}
		
		public static function get BGMusicValue():Number {
			return PlayerDataCenter._PlayerData._bGMusicValue;
		}
		
		public static function get FontKey():String {
			return PlayerDataCenter._PlayerData._fontKey;
		}
		/*
		public static function get MonsterExhaustLimit():uint {
			return PlayerDataCenter._PlayerData._monsterExhaustLimit;
		}*/
		
		public static function get LoadingBgKey():String {
			trace("get___PlayerData._loadingBgKey>>>"+PlayerDataCenter._PlayerData._loadingBgKey);
			return PlayerDataCenter._PlayerData._loadingBgKey;
		}
	    
		public static function get Token():String {//121120 K.J.Aris
			return PlayerDataCenter._Token;
		}
		
		//-----2012/11/16---erichuang(取所有UI素材KEY)-----
		public static function GetInitUiKey(_str:String=""):Array{
			var _ary:Array = [];
			var _obj:Object=PlayerDataCenter._PlayerData._initUiKey;
			if (_str=="") {
			  
				for (var i:String in _obj) {
					_ary.push(_obj[i]);	
					trace("SOURCE>>"+_obj[i]);
				}
				//return _ary;
				
			}else {
				
				
				for (var j:String in _obj) {
					if (j==_str) {
						_ary.push(_obj[j]);
						break;
					}
				}
				
				
			}
			
			return _ary;
			
		}
		
		public static function get LastServTime():uint {//121129
			return PlayerDataCenter._LastServTime;
		}
		
		
		
	    /*public function SetInitKey():void 
		{
			
		}*/
		//----------------------------------------END---------Getters
		
		
		//----------------------------------------------------Setters
		
			//................................Protections
			/*internal static function set PlayerID(value:String):void {
				_PlayerID = value;
			}*/
		
			public static function set PlayerName(value:String):void {
				PlayerDataCenter._PlayerData._playerName = value;
				//有可能更改Player name 要回寫SERVER
			}
			//......................END.......Protections
		
		
		
		
		
		public static function set SoundEffectSetting(value:Boolean):void {
			PlayerDataCenter._PlayerData._soundEffectSetting = value;
			//當值變更時 須呼叫回寫新值回SERVER
		}
		
		public static function set SoundEffectValue( value:Number ):void {
			PlayerDataCenter._PlayerData._soundEffectValue = value;
			//當值變更時 須呼叫回寫新值回SERVER
		}
		
		public static function set BGMusicSetting( value:Boolean ):void {
			PlayerDataCenter._PlayerData._bGMusicSetting = value;
			//當值變更時 須呼叫回寫新值回SERVER
		}
		
		public static function set BGMusicValue( value:Number ):void {
			PlayerDataCenter._PlayerData._bGMusicValue = value;
			//當值變更時 須呼叫回寫新值回SERVER
		}
		
		public static function addHonor( _InputIncrease:int ):int {
			//使用該方法來增加 或 減少(使用負號) 玩家PVP積分
			//外部無法直接操作該值
			//該函式會回傳當前總量新值		
			var honorPoint:int = PlayerDataCenter._PlayerData._playerValue._honorPoint + _InputIncrease;
			PlayerDataCenter._PlayerData._playerValue._honorPoint = ( (honorPoint <= PlayerDataCenter._PlayerData._honorMax)  && honorPoint >= 0) ? honorPoint : honorPoint < 0 ? 0 : PlayerDataCenter._PlayerData._honorMax;
			return 	PlayerDataCenter._PlayerData._playerValue._honorPoint;
			//須加入<0的狀況判斷  當<0時須有錯誤訊號
		}
		
		//20130509 -- Paladin -- PVP system 
		public static function get PlayerHonor():int {
			return PlayerDataCenter._PlayerData._playerValue._honorPoint;
		}
		
		//20130509 -- Paladin -- PVP system 
		public static function get PlayerHonorMax():int {
			return PlayerDataCenter._PlayerData._honorMax;
		}
		
		//20130509 -- Paladin -- PVP system 
		public static function set PlayerHonorMax(value:int):void {
			PlayerDataCenter._PlayerData._honorMax = value;
			//當值變更時 須呼叫回寫新值回SERVER
		}


		
		
		
		//----------------------------------------END---------Setters
		
		
	}//end class

}//end package