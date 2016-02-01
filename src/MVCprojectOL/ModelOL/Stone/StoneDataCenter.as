package MVCprojectOL.ModelOL.Stone
{
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Monster.MonsterServerWrite;
	import MVCprojectOL.ModelOL.Monster.PlayerMonsterDataCenter;
	import MVCprojectOL.ModelOL.Troop.TroopProxy;
	import MVCprojectOL.ModelOL.Vo.PlayerStone;
	import strLib.proxyStr.ProxyPVEStrList;
	
	
	
	/**
	 * ...
	 * @Engine :SparkEngine beta
	 * @author :EricHuang
	 * @version :2012/11/23
	 * @Explain:StoneDataControl 魔石資料控制處理
	 * @playerVersion:11.4
	 */
	
	public class StoneDataCenter
	{
		//建立魔石倉庫區	
		private var _StoneDepot:Dictionary;
		private var _sendFunction:Function;
		private var _flag:Boolean = false;
		
		private static var _StoneDataControl:StoneDataCenter;
		public function StoneDataCenter(_fun:Function):void 
		{
			this._StoneDepot = new Dictionary(true);
			this._sendFunction = _fun;
		}
		
		public static function GetStoneDataControl(_fun:Function=null):StoneDataCenter 
		{
			
			if (StoneDataCenter._StoneDataControl==null) {
				
				if (_fun != null) {
					StoneDataCenter._StoneDataControl = new StoneDataCenter(_fun);
				}
			}
			
			return StoneDataCenter._StoneDataControl;
		}
		
		
		
		//----2013/03/14-----
		public function GetTipsVO(_obj:Object):PlayerStone 
		{
			var _stone:PlayerStone;
			if (this._StoneDepot[ _obj._guid ]!=null && this._StoneDepot[ _obj._guid ]!=undefined ) {
				_stone = this._StoneDepot[ _obj._guid ];
			}
			return _stone;
		}
		
		
		
		public function GetStoneShowName(_key:String):String 
		{
			var _stoneName:String = (this._StoneDepot[_key] != null && this._StoneDepot[_key] != undefined)?this._StoneDepot[_key]._showName:"";
			
			return _stoneName;
		}
		
		//=================加入魔石Vo物件到倉庫
		public function AddVoStone( _data:Array ):void 
		{
			var _len:int = _data.length;
			for (var i:int = 0; i < _len;i++ ) {
				
				if ( this._StoneDepot[ _data[i]._guid ] == undefined || this._StoneDepot[ _data[i]._guid ] == null ) {
				
					this._StoneDepot[ _data[i]._guid ] = _data[i];
					//----刪除角色----
					if (_data[i]._monsterID != "") {
						 //----補刪除怪獸的資訊&&組隊刪除----
				         TroopProxy.GetInstance().DeleteMember(_data[i]._monsterID);
                         MonsterServerWrite.GetMonsterServerWrite().RemoveMonster(_data[i]._monsterID);
					}
				}
			}
			
			if (this._flag==false) {
				this._flag = true;
				this._sendFunction(ProxyPVEStrList.STONE_PROXYReady);
				} else {
				this._sendFunction(ProxyPVEStrList.STONE_ADDComplete);
			}
			
		}
		
		
		//----取得全部的石頭資訊
		public function GetAllStone():Array 
		{
			var _ary:Array = [];
			for (var i:String in this._StoneDepot) {
				
				var _obj:Object = {
				_guid : this._StoneDepot[i]._guid,
				_showName : this._StoneDepot[i]._showName,
				//----用Key去查找-----
				_picItem : this._StoneDepot[i]._picItem,
				//--禁錮能力
				_atk:this._StoneDepot[i]._attack,
				_def:this._StoneDepot[i]._defense,
				_speed:this._StoneDepot[i]._speed,
				_int:this._StoneDepot[i]._int,
				_mnd:this._StoneDepot[i]._mnd,
				_hp:this._StoneDepot[i]._HP,
				_type:this._StoneDepot[i]._type
				//_style:_dic[_index]._style
				//----要再補使用狀態(是否背掛賣或是使用)------ 
			 }
				
				_ary.push(_obj);
			}
			return _ary;
		}
		
		//---取得分類的總數量
		public function GetNowNumber():int 
		{
			var _number:int = 0;
			for (var i:String in  this._StoneDepot) {
				_number++;
			}
			return _number;
		}
		
		
		//-----取得要掛賣的石頭----
		
		public function GetSellStone():Array 
		{
			
			var _ary:Array = [];
			for (var i:String in this._StoneDepot) {
				
				if (this._StoneDepot[i]._type!=2) {
				var _obj:Object = {
				_guid : this._StoneDepot[i]._guid,
				_showName : this._StoneDepot[i]._showName,
				//----用Key去查找-----
				_picItem : this._StoneDepot[i]._picItem
				//--禁錮能力
				//_atk:this._StoneDepot[i]._attack,
				//_def:this._StoneDepot[i]._defense,
				//_speed:this._StoneDepot[i]._speed,
				//_int:this._StoneDepot[i]._int,
				//_mnd:this._StoneDepot[i]._mnd,
				//_hp:this._StoneDepot[i]._HP,
				//_type:this._StoneDepot[i]._type
				//_style:_dic[_index]._style
				//----要再補使用狀態(是否背掛賣或是使用)------ 
			    //}
					
					
				}
				
				}
				_ary.push(_obj);
			}
			return _ary;
			
		}
		
		
		
		//----取回單一的顯示圖片
		public function GetSingleStonePic(_index:String):String 
		{
			var _returnPic:String = "";
			if (this._StoneDepot[_index] != undefined && this._StoneDepot[_index ] !=null) {
				
				_returnPic = this._StoneDepot[_index]._picItem;
			}
			return _returnPic;
		}
		
		
		public function ChangeStoneType(_key:String,_Status:int):void 
		{
			if (this._StoneDepot[_key] != undefined && this._StoneDepot[_key ] !=null) {
				
				this._StoneDepot[_key]._type = _Status;
				
			}
		}
		
		
		//---檢查stone狀態
		//---1=正常/2=掛賣/0=使用狀態(server尚未回寫)
		public function CheckStoneStatus(_key:String):int 
		{
			var _checkType:int = (this._StoneDepot[_key] != undefined && this._StoneDepot[_key ] !=null)?this._StoneDepot[_key]._type:-1;
			return _checkType;
		}
		
		
		
		//----檢查stone是否存在
		public function CheckStone(_key:String):Boolean 
		{
           var _flag:Boolean = (this._StoneDepot[_key] != undefined && this._StoneDepot[_key ]!=null)?true:false;
		   return _flag;
		}
		
		
		//=========取得魔石基本數值
		public function GetStone( _index:String ):Object
		{
			var _obj:Object;
			if (this._StoneDepot[_index]!=null && this._StoneDepot[_index]!=undefined) {
				_obj = {
				_key : this._StoneDepot[_index]._guid,
				_atk:this._StoneDepot[_index]._attack,
				_def:this._StoneDepot[_index]._defense,
				_speed:this._StoneDepot[_index]._speed,
				_Int:this._StoneDepot[_index]._int,
				_mnd:this._StoneDepot[_index]._mnd,
				_hp:this._StoneDepot[_index]._HP
					
				}
				
			}
			return _obj;
		}
		
		
		public function GetStoneClass(_index:String):PlayerStone 
		{
			var _return:PlayerStone;
			if (this._StoneDepot[_index]!=null && this._StoneDepot[_index]!=undefined) {
				
				_return = this._StoneDepot[_index];
			}
			
			return _return;
			
		}
		
		//==========移除魔石倉庫物件
		public function RemoveStone( _index:String ):void 
		{
			if (this._StoneDepot[_index]!=null && this._StoneDepot[_index]!=undefined) {
			this._StoneDepot[ _index ] = null;
			delete this._StoneDepot[ _index ];
			}
		}
		
	}
}