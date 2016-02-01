package MVCprojectOL.ModelOL.TipsCenter.TipsDataCenter
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Monster.PlayerMonsterDataCenter;
	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import MVCprojectOL.ModelOL.TipsCenter.DisplayobjLab.SystemStrTIPS;
	import MVCprojectOL.ModelOL.Stone.StoneDataCenter;
	import MVCprojectOL.ModelOL.TipsCenter.Basic.BaseItemView;
	import MVCprojectOL.ModelOL.TipsCenter.Basic.ItemConter;
	import MVCprojectOL.ModelOL.TipsCenter.DisplayobjLab.CompleteConter;
	import MVCprojectOL.ModelOL.TipsCenter.DisplayobjLab.PreviewBox;
	import MVCprojectOL.ModelOL.TipsCenter.DisplayobjLab.SingleTimerBar;
	import MVCprojectOL.ModelOL.TipsCenter.DisplayobjLab.TimeLineTipsConter;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ModelOL.TipsCenter.StrCenter.TipstrData;
	import MVCprojectOL.ModelOL.TipsCenter.TipsLab.TipsDataLab;
	import Spark.CommandsStrLad;
	import Spark.MVCs.Models.BarBasic;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class  TipsCtrlCenter
	{
		
		private var _sourceCenter:Object;
		private var _tipsDataLab:TipsDataLab;
		private var _vecTips:Vector.<BaseItemView>;
		private var _systemStrTIPS:SystemStrTIPS;
		private var _tipstrData:TipstrData;
		private var _sendfunction:Function;
		public function TipsCtrlCenter(_send:Function) 
		{
		   //this._tipsDataLab = new TipsDataLab(_send);
		   this._tipsDataLab = TipsDataLab.GetTipsData(_send);
           this._vecTips = new Vector.<BaseItemView>();
		   this._tipstrData = new TipstrData();
		   this._sendfunction = _send;
		   //----文字TIPS----
		   //this._dicTips["StrTips_system"] = [];
			
		}
		
		public function SetTipData(_tips:TipsDataLab):void { this._tipstrData.TipsData = _tips };
		
		public function set sourceCenter(value:Object):void { this._sourceCenter = value };
		
		public function AddTips(_ary:Array):void 
		{
			this._tipsDataLab.AddTips(_ary);
		}
		//----關閉或是展開TIPS的view----
		public function SetTipsTimeLineVisible(_flag:Boolean,_system:String):void 
		{
			//--"StrTips_system"(系統中用到的純文字系統)
			var _str:String = (_system==ProxyPVEStrList.TIP_MonsterEqu ||_system==ProxyPVEStrList.TIP_MonsterEatStone)?ProxyPVEStrList.TIP_MonsterEqu:_system;
		    
			var _len:int = this._vecTips.length;
			//var _return:int = -1;
			for (var i:int = 0; i < _len;i++ ) {
				if (this._vecTips[i]._groupName==_str) {
				   //_return = i;	
				   
				   this._vecTips[i].OpenClose(_flag);
				   
				   break;	
				}
			}
			
		}
		
		//---刪除完成容器----
		public function RemoveTips(_type:String,_key:String):Boolean 
		{
			var _flag:Boolean = false;
		    var _len:int = this._vecTips.length;
				for (var i:int = 0; i < _len;i++ ) {
					if (this._vecTips[i]._groupName==_type && this._vecTips[i]._guid==_key) {
						this._vecTips[i].CleanALL();
						this._vecTips.splice(i, 1);
						_flag = true;
						break;
					}
				}
			return _flag;
		}
		
		
		public function GetTips(_type:String,_target:SendTips):* 
		{
			
			var _returnSpr:*;
			switch(_type) {
				//---排程完成
				case ProxyPVEStrList.TIP_COMPLETE:
					//-----{_picItem:String,_strType:int,_guid:String,_buildType:int}
					var _class:Class = this._sourceCenter._qua1;
			        var _complete:MovieClip = new _class();
					var _comSpr:CompleteConter=new CompleteConter(_complete,ProxyPVEStrList.TIP_COMPLETE,_target.guid, this._sendfunction, _target.buildType);
					_comSpr.AddItemSource(new ItemConter(_target.picItem, 64, 64));
					//---佔代取代字串-----
					//var _missionStr:String = (_target.completeStr != "")?_target.completeStr:"";
					//var _strComplete:String = TipsDataLab.GetTipsData().GetTipsDate(_target.tipsObj._key, _target.tipsObj._className, _target.tipsObj._getObj);
					var _strTarget:String = TipsDataLab.GetTipsData().GetTipsDate(_target.tipsObj._key);
					if (_target.tipsObj._targetName != "")_strTarget = _strTarget.replace("^_targetName^",_target.tipsObj._targetName);
					if (_target.tipsObj._produceName != "")_strTarget = _strTarget.replace("^_produceName^",_target.tipsObj._produceName);
					//_comSpr.AddShowStr(this.getStrHandler(_missionStr, _target.strType));
					_comSpr.AddShowStr(_strTarget);
					if (this.checkSameComponentHandler(_comSpr._guid) == -1) this._vecTips.push(_comSpr);
					//this.pushTipsHandler(ProxyPVEStrList.TIP_COMPLETE,_comSpr);
					_returnSpr = Sprite(_comSpr);
				break;
				
				//----排程被搶
				case ProxyPVEStrList.TIP_PVP:
				break;
				
				//---還在排程中要秀的
			    case ProxyPVEStrList.TIP_SCHER:
			      var _checkIndex:int = this.checkSameEquAndStoneHandler(1);
			
					if (_checkIndex>=0) {
					//---resetvaule---------
					TimeLineTipsConter(this._vecTips[_checkIndex]).ResetInforTime(_target);
					_returnSpr = this._vecTips[_checkIndex] as TimeLineTipsConter;
					} else {
					//--未創造
					var _class:Class = this._sourceCenter._qua1;
					var _classSource:MovieClip = new _class();
					var _barConter:DisplayObject = BarBasic(ProjectOLFacade.GetFacadeOL().GetProxy(CommandsStrLad.SorceBar_Proxy)).GetBar(100,0,133,11,true,0x7373B9,"","",null,0xd0d0d0);	
					var _timeConter:TimeLineTipsConter = new TimeLineTipsConter(_classSource,ProxyPVEStrList.TIP_SCHER);
					_timeConter.AddTimeSource(this._sourceCenter._number,this._sourceCenter._skill, new ItemConter(_target.picItem, 64, 64));
					//---{_bar:Sprite,_completeTime:int,_totalTime:int,_text:Object}
					_timeConter.AddBar( { _bar:Sprite(_barConter)});
					_timeConter.ResetInforTime(_target);
					_returnSpr = _timeConter;
					 this._vecTips.push(_timeConter);
					}
			
				break;
				
				//--純文字
			    case ProxyPVEStrList.TIP_STRBASIC:
				
				   //var _aryChange:Array = (_target.change != "")?this._GetTipVaule.GetChangeVaule(_target.change):null; 
				   
				   var _str:String =(_target.tipsClassName=="")?TipsDataLab.GetTipsData().GetTipsDate(_target.guid):String(this._tipstrData.GetTips(_target.guid, _target.tipsClassName, _target.tipsObj));
				   //var _quaIndex:int = int(_str.substring(0, 1));
				   _returnSpr = [_str,_target.mouseX, _target.mouseY, _target.viewSystem,_target.quality];
				break;
				//---skill專用(攻擊範圍TIPS)
				case ProxyPVEStrList.TIP_Skill:
				break;
				//----探索獲得
				case ProxyPVEStrList.TIP_Explore:
				break;
				
				//-----裝備預覽
			    case ProxyPVEStrList.TIP_MonsterEqu:
				
				   var _objPre:Object = PlayerMonsterDataCenter.GetMonsterData().GetEquPreView(_target.monsterID, _target.equGroupID, _target.guid);   
				  //--//---正常顯示裝備=99/反之就帶入錯誤資料的錯誤碼
				  //_returnSpr = (_objPre._type==99)?this.creatEatAndEquHandler(_target,_objPre,ProxyPVEStrList.TIP_MonsterEqu):this.GetSystemStrTips("error_EQU"+_objPre._type); 
				  
				  if (_objPre._type==99) {
					  _returnSpr = this.creatEatAndEquHandler(_target, _objPre, ProxyPVEStrList.TIP_MonsterEqu);
					  
					  } else {
					  var _errorStr:String = "";
					  if (_objPre._type == -1)_errorStr = "裝備無法使用,請檢查裝備(裝備不存在)";
					  if (_objPre._type == -2)_errorStr = "裝備並非閒置狀態(以被使用)";
					  if (_objPre._type == -3)_errorStr = "裝備無法使用,怪獸等級太低";
					  if (_objPre._type == -4)_errorStr = "裝備資料系統錯誤";
					  if (_objPre._type == -5)_errorStr = "怪獸資料錯誤";
					  _returnSpr=this.GetSystemStrTips("<error_EQU>"+_errorStr);
				      
				  }
				  
				  
				 
				  
				  /*
				  if (_objPre._type==99) {
					//---正常顯示裝備
					 _returnSpr = this.creatEatAndEquHandler(_target,_objPre,ProxyPVEStrList.TIP_MonsterEqu);
					
					} else {
					//----資料錯誤(帶入引數錯誤)-----
					_returnSpr = this.GetSystemStrTips("error_EQU"+_objPre._type);//---帶入錯誤戴碼
					
				    }
                */
				break;
				
				//-----吃石頭預覽
			    case ProxyPVEStrList.TIP_MonsterEatStone:
				 
				  var _objStone:Object =  PlayerMonsterDataCenter.GetMonsterData().GetPreEatStone(_target.monsterID,_target.guid);
				   _returnSpr = (_objStone._type==99)?this.creatEatAndEquHandler(_target, _objStone,ProxyPVEStrList.STONE_EATPREVIEW):this.GetSystemStrTips("error_"+ _objStone._type);
				
				break;
				
				//----暫時替代的
				//--_timeBarBG/_timeBar
				case ProxyPVEStrList.TIP_TIMERBAR:
				    //var _barConter:DisplayObject = BarBasic(ProjectOLFacade.GetFacadeOL().GetProxy(CommandsStrLad.SorceBar_Proxy)).GetBar(100, 0, 133, 12, true, 0x000000, "", "",this._sourceCenter._timeBar, 0xd0d0d0,this._sourceCenter._timeBarBG);	
				    var _barConter:DisplayObject = BarBasic(ProjectOLFacade.GetFacadeOL().GetProxy(CommandsStrLad.SorceBar_Proxy)).GetScaleDoubleBar(_target.width,_target.height,this._sourceCenter._timeBar,this._sourceCenter._timeBarBG);	
					var _timerBox:SingleTimerBar = new SingleTimerBar(_target,_barConter);
				  _returnSpr = _timerBox;
				break;
				
			
			}
			
			return _returnSpr;
			
		}
		
		
		//---(-1代表目前沒有存到該類別)
		private function checkVecHandler(_tipGroupName:String):int 
		{
			var _len:int = this._vecTips.length;
			var _return:int = -1;
			for (var i:int = 0; i < _len;i++ ) {
				if (this._vecTips[i]._groupName==_tipGroupName) {
				   _return = i;	
				   break;	
				}
			}
			
			return _return;
		}
		
		//---(-1回傳代表沒有相同的)
		private function checkSameComponentHandler(_guid:String):int 
		{
			var _len:int = this._vecTips.length;
			var _return:int = -1;
			for (var i:int = 0; i < _len;i++ ) {
				if (this._vecTips[i] is CompleteConter && this._vecTips[i]._guid==_guid) {
				   _return = i;	
				   break;	
				}
			}
			
			return _return;	
		}
		
		
		
		//---撿查是否推入相同的型別物件
		private function checkSameEquAndStoneHandler(_target:int):int 
		{
			var _len:int = this._vecTips.length;
			var _return:int = -1;
			var _targetClass:*= (_target==0)?PreviewBox:TimeLineTipsConter;
			for (var i:int = 0; i < _len;i++ ) {
				if (this._vecTips[i] is _targetClass) {
				   _return = i;	
				   break;	
				}
			}
			
			return _return;	
		}
		
		private function GetSystemStrTips(_key:String=""):SystemStrTIPS 
		{
			
			//if (this._systemStrTIPS==null) this._systemStrTIPS = new SystemStrTIPS(this._sourceCenter._qua2);
		    var _returnSpr:SystemStrTIPS = (this._systemStrTIPS==null)?this._systemStrTIPS = new SystemStrTIPS(this._sourceCenter._qua2):this._systemStrTIPS;
			if (_key != "")_returnSpr.SetErrorTips(this._tipstrData.deBugTips(_key));
			//var _str:String=String(this._TipstrData.GetTips(_target.guid,_target.strTips,_aryChange));
			/*
			if (this._dicTips["StrTips_system"].length==1) {
				//---已經有被建構出來了
				_returnSpr = this._dicTips["StrTips_system"][0];
				} else {
				_returnSpr = new SystemStrTIPS(this._sourceCenter._qua2);
				this._dicTips["StrTips_system"].push(_returnSpr);
			}
			
			//---找尋系統字串---(要再補過,errorTYPE要造表)
			if (_key != "")_returnSpr.SetErrorTips(this._TipstrData.deBugTips(_key));
			*/
			//---- var _str:String=String(this._TipstrData.GetTips(_target.guid,_target.strTips,_aryChange));
			//----填入找到的對應字串
			return _returnSpr;
		}
		
		
		//---吃石頭 & 裝備預覽-----
		private function creatEatAndEquHandler(_target:SendTips,_objTarget:Object,_system:String):PreviewBox 
		{
		    var _monsterEqu:PreviewBox;	
		 
			//if (_system==ProxyPVEStrList.TIP_MonsterEqu || _system==ProxyPVEStrList.STONE_EATPREVIEW) {
				//var _monsterEqu:EquAndEatStone;
				var _checkIndex:int = this.checkSameEquAndStoneHandler(0);
				if (_checkIndex>=0) {
					//---被創造過了----
					_monsterEqu = this._vecTips[_checkIndex] as PreviewBox;
					_monsterEqu.ResetPicItem(_target.picItem);
					
					
				}else {
					var _classBG:Class = this._sourceCenter._qua1;
			        var _completeBG:MovieClip = new _classBG();
				    _monsterEqu = new PreviewBox(_completeBG, ProxyPVEStrList.TIP_MonsterEqu, "",this._sourceCenter._property);
					_monsterEqu.AddItemSource(new ItemConter(_target.picItem, 64, 64));
					this._vecTips.push(_monsterEqu);
					//this._dicTips[ProxyPVEStrList.TIP_MonsterEqu].push(_monsterEqu);
				}
				var _guid:String = "";
				var _equID:String = "";
				if (_target.tipsType == ProxyPVEStrList.TIP_MonsterEqu) {
					_guid = _target.guid;
					_equID = _target.equGroupID;
					} else {
					_guid = _target.monsterID;
					_equID =StoneDataCenter.GetStoneDataControl().GetStoneShowName(_target.guid);
				}
				
				var _strType:Object = this.getTypeEquAndStoneHandler(_guid,_equID);
				_monsterEqu.AddTitle(this._tipstrData.GetTips(_target.title,_strType._name,_strType._obj));
			    _monsterEqu.AddOriginalStr(_objTarget._monster);
			    _monsterEqu.AddSetEquClothed(_objTarget._vaulePre);
				//_returnSpr = _monsterEqu;
				

			//}
			
			return _monsterEqu;
			
		}
		
		
		
		private function getTypeEquAndStoneHandler(_key:String,_group:String=""):Object 
		{
			var _strIndex:String = _key.slice(0,3);
			//var _equType:int = -1;
			//--0=裝備/1=石頭----
			//var _equTypeStyle:int = 0;
			var _strClassName:String = "";
			var _getClassType:Object;
			switch(_strIndex) {
			  	
				case "WPN":
					_strClassName = PlaySystemStrLab.Package_Weapon;
					_getClassType ={_type:0,_group:_group,_guid:_key};
					
				break;
				
				case "AMR":
					_strClassName = PlaySystemStrLab.Package_Shield;
					_getClassType ={_type:1,_group:_group,_guid:_key};
				break;
				
			    case "ACY":
					_strClassName = PlaySystemStrLab.Package_Accessories;
					_getClassType ={_type:2,_group:_group,_guid:_key};
				break;
				
			    default:
				_strClassName = ProxyPVEStrList.STONE_EATPREVIEW;
				_getClassType = {_guid:_key,_title:_group};
				
			}
			
			return {_name:_strClassName,_obj:_getClassType};
		}
		/*
		private function getStrHandler(misssion:String,_type:int):String 
		{
			var _returnStr:String = "";
			switch(_type) {
				case 2:
				  _returnStr = "技能學習完成";	
				break;
				
				case 4:
				  _returnStr = "魔晶石提煉完成";
				break;
				
			    case 5:
				  _returnStr = "武器製做完成";
				break;
				
				case 6:
				  _returnStr = "防具製做完成";
				break;
				
				case 7:
				  _returnStr = "飾品製做完成";
				break;
				
			    case 8:
				_returnStr = "英靈烤打完成";
				break;
				
				case 9:
				_returnStr = "素材提煉完成";
				break;
				
			    case -1:
				_returnStr = "完成";
			}
			
			return misssion+_returnStr;
			
		}
		*/
	}
	
}