package MVCprojectOL.ModelOL.SourceData
{
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.Vo.PlayerSource;
	import strLib.proxyStr.ProxyPVEStrList;
	//import MVCprojectOL.ModelOL.Vo.SourceVO;
	
	/**
	 * ...
	 * @author EricHuang
	 * 管理玩家的背包[製作素材]裝備/建築素材
	 */
	public class UserSourceCenter 
	{
		private static var _UserSourceCenter :UserSourceCenter ;
		//--裡面只會紀錄鍊金用的素材---
		private var _dicSource:Dictionary;
		private var _sendFunction:Function;
		private var _flag:Boolean = false;
		public function UserSourceCenter (_fun:Function) 
		{
			this._dicSource = new Dictionary(true);
			this._sendFunction = _fun;
		}
		
		
		public static function GetUserSourceCenter(_fun:Function=null):UserSourceCenter 
		{
		 
			if (UserSourceCenter._UserSourceCenter == null) {
				if (_fun != null)UserSourceCenter._UserSourceCenter= new UserSourceCenter(_fun);
			} 
			
			return UserSourceCenter._UserSourceCenter; 
		}
		
		
		//---初始把所有的素材推進來
		/*
		public function SetInit(_ary:Array):void 
		{
		    var _len:int = _ary.length;
			if (_len>=1) {
				for (var i:int = 0; i < _len;i++ ) {
				 this._dicSource[_ary[i]._guid] = _ary[i];
				
			   }		
			}
		}
		*/
		
		//----2013/03/14--------
		public function GetSourceTips(_obj:Object):PlayerSource 
		{
			var _PlayerSource:PlayerSource;
			if (this._dicSource[_obj._groupGuid]!=null && this._dicSource[_obj._groupGuid]!=undefined) {
				_PlayerSource = this._dicSource[_obj._groupGuid];
			}
			
			return _PlayerSource;
		}
		
		
		
		//----12/10-----要修正總類群guid與每個品項的guid紀錄問題
		public function AddSource(_ary:Array):void 
		{
			var _len:int = _ary.length;
			if (_len>0) {
				for (var i:int = 0; i < _len;i++ ) {
			   /*
				if (_ary[i]._type==0) { 
					if (this._dicSource[_ary[i]._groupGuid]!=null && this._dicSource[_ary[i]._groupGuid]!=undefined) { 
					   this._dicSource[_ary[i]._groupGuid]._number += _ary[i]._number;
						}else {
						this._dicSource[_ary[i]._groupGuid] = _ary[i];
					  }
					} else {
					//----建築升級用的素材------
					//---寫回ㄎㄎ那支palyerdatacenter
					this.setBuildSourceHandler( _ary[i]._buildSourceType,_ary[i]._number);
				}	
				
				*/
				switch(_ary[i]._type) {
				   case 0:	
				   if (this._dicSource[_ary[i]._groupGuid]!=null && this._dicSource[_ary[i]._groupGuid]!=undefined) { 
					   this._dicSource[_ary[i]._groupGuid]._number += _ary[i]._number;
						}else {
						this._dicSource[_ary[i]._groupGuid] = _ary[i];
					  }
					   
				   break;	
					
			       case 1:
				   //----建築升級用的素材------
				   //---寫回ㄎㄎ那支palyerdatacenter
					this.setBuildSourceHandler( _ary[i]._buildSourceType,_ary[i]._number);
				   break;
				   
			       case 2:
				    //---PVP商城積分
					PlayerDataCenter.addHonor(_ary[i]._number);
				   break;
				}	
				
			}
			
			}
			
			
			var _str:String = "";
			if (this._flag==false) {
				this._flag = true;
				_str = ProxyPVEStrList.SOURCE_PROXYReady;
				} else {
				_str = ProxyPVEStrList.SOURCE_ADDReady;
			}
			
			this._sendFunction(_str);
			
		}
		
		private function setBuildSourceHandler(_type:int,_number:int):void 
		{
			if (_type == 0) PlayerDataCenter.addWood(_number);
			if (_type == 1) PlayerDataCenter.addStone(_number);
			if (_type == 2) PlayerDataCenter.addFur(_number);
			if (_type == 3) PlayerDataCenter.addSoul(_number);
			
		}
		
		
		//-------損耗素材---
		public function UseSource(_guid:String,_number:int):void 
		{
			
			if (this._dicSource[_guid]!=null && this._dicSource[_guid]!=undefined) { 
				this._dicSource[_guid]._number -= _number;
				if (this._dicSource[_guid]._number<=0) {
				this._dicSource[_guid]=null;
				 
				  delete this._dicSource[_guid];
				}
				
				}else {
				trace("查無所引");
		    }
			
		}
		
		
		public function GetCompleteInfo(_groupID:String):Array 
		{
			//this._dicSource[_ary[i]._groupGuid]
			var _ary:Array;
			if (this._dicSource[_groupID]!=null && this._dicSource[_groupID]) {
				_ary = [
				  this._dicSource[_groupID]._picItem,
				  this._dicSource[_groupID]._groupGuid,
				  6,
				  9,
				  5
				];
					
			}
			
			return _ary;
			
		}
		
		
	
		
		//----提供背包取得所有的素材------
		public function GetAllUserSource():Array 
		{
			 //var _dic:Dictionary = new Dictionary(true);
			 var _ary:Array = [];
				for each(var i:PlayerSource in this._dicSource) {
				var _obj:Object = {
					_type:i._type,
					_picItem:i._picItem,
					_guid:i._groupGuid,
					_number:i._number,
					_showName:i._showName,
					_showInfo:i._showInfo,
					//---堆疊最大上限---
					_stackMax:i._stackMax
				}
				_ary.push(_obj);
			}
				
			//_dic[PlaySystemStrLab.Package_Source] = _ary;
			return _ary;		
		}
		
		
		//---取得分類的總數量
		public function GetNowNumber():int 
		{
			var _number:int = 0;
			for each(var i:PlayerSource in this._dicSource) {
				var _one:int = Math.floor(i._number/i._stackMax);
				var _real:int = 0;
				if (i._number % i._stackMax > 0)_real = 1;
				_number = _number + _one + _real;
			}
			return _number;
		}
		
		
		
		
		public function RemoveSingleAllSource(_id:String):void 
		{
			
			if (this._dicSource[_id]!=null) {
				this._dicSource[_id] = null;
				delete this._dicSource[_id];
				} else {
				
				trace("Error_sourceData");
			}
			
		}
		
		
		//----減少素材
		/*
		public function ReduceSource(_style:int,_number:int):void 
		{
			
			if (this._dicSource[_style]!=null && this._dicSource[_style]!=undefined) { 
				this._dicSource[_style]._number -= _number;
				if (this._dicSource[_style]._number <= 0) {
				 	this._dicSource[_style] = null;
					delete this._dicSource[_style];
			      		
				}
				
				} else {
					
			    //----派送查詢不到此物件的錯誤訊息
				trace("error_ReduceSource");

			}
			
		}*/
		
		
		//----取得單一素材數量---
		public function GetSourceSingleNum(_style:String):int 
		{
			var _returnNumber:int = (this._dicSource[_style] != null && this._dicSource[_style] != undefined)?this._dicSource[_style]._number:0;
			
			return _returnNumber;
		}
		
		
		//---檢查該品項是否有一個以上的素材可支援配方表
		public function CheckSource(_style:String,_number:int):Boolean 
		{
		
			var _returnNumber:Boolean;
				
			if (this._dicSource[_style] != null && this._dicSource[_style] != undefined) {
				_returnNumber = (this._dicSource[_style]._number-_number>=0)?true:false; 
				
				} else {
				
				_returnNumber = false;
				
			}
			
			return _returnNumber;	
			
		}
		
		
		
		
		
		
	}
	
}