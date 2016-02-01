package MVCprojectOL.ModelOL.TimeLine
{
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import MVCprojectOL.ModelOL.Alchemy.AlchemyDataCenter;
	import MVCprojectOL.ModelOL.Building.BuildingProxy;
	import MVCprojectOL.ModelOL.Monster.PlayerMonsterDataCenter;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import MVCprojectOL.ModelOL.Vo.Buildschedule;
	import MVCprojectOL.ModelOL.Vo.BuildSchedule_Error;
	import MVCprojectOL.ModelOL.Vo.Get.Get_Buildschedule;
	import MVCprojectOL.ModelOL.Vo.Get.Get_Mission;
	import MVCprojectOL.ModelOL.Vo.MissionVO.MissionConditionComplete;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.Utils.GlobalEvent.EventExpress;
	//import MVCprojectOL.ModelOL.Vo.Get.Get_Buildscheduleres;
	import MVCprojectOL.ModelOL.Vo.Set.Set_BuildSchedule;
	import MVCprojectOL.ModelOL.Vo.Set.Set_Schedule;
	//import MVCprojectOL.ModelOL.Vo.PlayerTimeLine;
	import Spark.Timers.TimeDriver;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author EricHuang
	 /----排程處理器
	 */
	public class  TimeLineObject
	{
		
		private var _fackindex:int;
		private var _dicRealLine:Dictionary;
		
		//private var _dicFackLine:Dictionary;
		private var _aryCompleteHold:Array;
		//private var _aryDic:Array;
		//private var _flag:Boolean;
		private static var _TimeObj:TimeLineObject
		private var _funSendNotify:Function;
		private var _initCheck:Boolean;
		//----voCallGroup
		//private var _funVoGroup:Function;
		//----圖書館GUID----
		private var _libraryBuild:String;
		//private var _checkToRun:Boolean = false;
		
		private var _currFrameTime:int;
		private var _getTimer:int;
		
		//private var _AMFConnect:AmfConnector;
		
		private var _fpsResetFlag:Boolean = false;
		
		private var _booleanTimerFlag:Boolean = false;
		
		private var _amfConnect:AmfConnector;
		//---排成完成返回清單(右側滑出專用)
		private var _aryCompleteTips:Array;
		public function TimeLineObject(_fun:Function) 
		{
			
			if (TimeLineObject._TimeObj != null) throw Error("[TimeLineObject] build illegal!!!please,use [Singleton]");
			this._dicRealLine = new Dictionary(true);
			//this._dicFackLine = new Dictionary(true);
			this._fackindex = 0;
			this._funSendNotify = _fun;
			this._initCheck = false;
			this._currFrameTime = getTimer();
			this._aryCompleteTips = [];
			
			//this._aryCompleteHold = [];
			//this._aryDic = [this._dicRealLine, this._dicFackLine];
			
			//this._flag = true;
		}
		
		/*
		public function set funVoGroup(value:Function):void 
		{
			_funVoGroup = value;
			this._AMFConnect=AmfConnector.GetInstance();
		}
		*/
		//---check FPSReset------
		public function get fpsResetFlag():Boolean { return _fpsResetFlag };
		
		public function set amfConnect(value:AmfConnector):void {_amfConnect = value;}
		
		
		
		public static function GetTimeLineObject(_fun:Function=null):TimeLineObject 
		{
			
			
			if (TimeLineObject._TimeObj == null && _fun!=null) {
				
				TimeLineObject._TimeObj = new TimeLineObject(_fun);
			} 
		    return TimeLineObject._TimeObj;
		}
		
		/*
		
	    public function AddCompleteTips(_tips:TimeCompleteInfo):void 
		{
		    this._aryCompleteTips.push(_tips);	
		}	
		
		public function GetCompleteTips(_obj:Object):TimeCompleteInfo 
		{
			var _tips:TimeCompleteInfo;
			var _len:int = this._aryCompleteTips.length;
			for (var i:int = 0; i < _len;i++) {
				if (this._aryCompleteTips[i]._schID==_obj._schID) {
				  _tips = this._aryCompleteTips[i];
				  break;
				}
			}
			
			return _tips;
		}
	    
		
		public function RemoveCompleteTips(_id:String):void 
		{
			//var _tips:TimeCompleteInfo;
			var _len:int = this._aryCompleteTips.length;
			for (var i:int = 0; i < _len;i++) {
				if (this._aryCompleteTips[i]._schID==_id) {
				  this._aryCompleteTips.splice(i, 1);
				  break;
				}
			}
			
			
		}*/
		
		//------_finishTime=排程所需時間
		public function AddTimeLine(_build:String,_target:String,_starTime:uint,_finishTime:uint,_buildType:int,_type:String="",_changeSkill:String="",_group:int=-1):void 
		{
			//--this.BUILDING_TIMELINE, build._guid,time,needCD,0,"build";
			//this._fackindex++;
			var _name:String = "fackLine"+_target+String(_starTime)
			var _line:Buildschedule = new Buildschedule();
			_line._buildID = _build;
			_line._fackID = _name;
			_line._needTime=_finishTime
			_line._finishTime =_starTime+_finishTime;
			_line._startTime = _starTime;
			_line._targetID = _target;
			_line._buildType = _buildType;
			//_line._timeCheck = _starTime;
			_line._timeCheck = 0;
			var _str:String = "Buildschedule:";
			if(_type!="build")BuildingProxy.GetInstance().AddWorker(_build,_name);
			switch(_type) {
				case "":
				   //this._a
					this._amfConnect.VoCall(new Set_BuildSchedule(_str,_line._buildID,_line._targetID,_line._fackID,_line._startTime,_line._buildType));	
				break;
				
			    case "Library":
				this._amfConnect.VoCall(new Set_BuildSchedule(_str,_line._buildID,_line._targetID,_line._fackID,_line._startTime,_line._buildType,_changeSkill,_group));
				break;
				
			   
				case "build":
				this._amfConnect.VoCall(new Set_BuildSchedule(_str,_line._buildID,_line._targetID,_line._fackID,_line._startTime,_line._buildType));	
				break;
				
			}
			
			this.AddVoTimeLine([_line]);
			
		}
		
		
		//---連線回來使用
		public function AddVoTimeLine(_vo:Array):void 
		{
			
		    var _resetSchID:String = "";
			if (_vo.length!=0) {
				var _len:int = _vo.length;
			    var _nowTime:uint = ServerTimework.GetInstance().ServerTime;
				for (var i:int = 0; i < _len;i++ ) {
				var _strIndex:String = (_vo[i]._buildID==_vo[i]._targetID)?"buildingTimeline":_vo[i]._buildID;	
				if (this._dicRealLine[_strIndex] == null || this._dicRealLine[_strIndex] == undefined ) {
					
					if (_vo[i]._guid != "" ) {
					 if(_vo[i]._buildType>0)BuildingProxy.GetInstance().AddWorker(_vo[i]._buildID,_vo[i]._guid);	
					 _vo[i]._timeCheck = _nowTime-_vo[i]._startTime;
					  _resetSchID = ProxyPVEStrList.TIMELINE_SCHIDReady;
					}
					this._dicRealLine[_strIndex]=[_vo[i]];	
					trace("hello");
					} else {
					if (_vo[i]._guid == "") {
						//---假造的狀態
						this._dicRealLine[_strIndex].push(_vo[i]);
						
						} else {
							
						var _ary:Array = this._dicRealLine[_strIndex];
						var _index:int = _ary.length;
						if (_vo[i]._fackID=="") {
							 _vo[i]._timeCheck = _nowTime-_vo[i]._startTime;
							this._dicRealLine[_strIndex].push(_vo[i]);
							_resetSchID = ProxyPVEStrList.TIMELINE_SCHIDReady;
							} else {
							
							for (var j:int = 0; j < _index;j++ ) {
							   if (_ary[j]._fackID==_vo[i]._fackID) {
								_vo[i]._timeCheck = _nowTime-this._dicRealLine[_strIndex][j]._startTime;
								//_vo[i]._timeCheck = this._dicRealLine[_vo[i]._buildID][j]._timeCheck;
								this._dicRealLine[_strIndex][j] = _vo[i];
								//-----送回阿翔那邊------
							    if (_vo[i]._buildType > 0) BuildingProxy.GetInstance().WorkerFakeIdChange(_vo[i]._fackID,_vo[i]._guid); 
										
								 _resetSchID = ProxyPVEStrList.TIMELINE_SCHIDReady;
						
								break; 
						   }
						 }   	
							
						}
						
					}
						
					
				}
	
			}
	
			}
			
			
			if (this._initCheck == false) {
				this._initCheck = true;
				this._funSendNotify(ProxyPVEStrList.TIMELINE_PROXYReady);
			    this._libraryBuild = BuildingProxy.GetInstance().GetBuildingGuid(4);
				//this._funSendNotify(ProxyPVEStrList.TIMELINE_NETReady);
			   
			    }else if(_resetSchID!=""){
				this._funSendNotify(_resetSchID);
				
			}
			
			trace("hello");
		}
		
		
		public function GetExproleSingleLine(_build:String,_targedID:String):Object 
		{
			var _obj:Object;
			
			if (this._dicRealLine[_build]!=null && this._dicRealLine[_build]!=undefined) {
				  var _targetAry:Array = this._dicRealLine[_build];
				  //var _str:String = _key.substr(0,8);
				  var _len:int = _targetAry.length;
				  for (var i:int = 0; i < _len;i++ ) {
				     //var _index:String= (_str!="fackLine")?_targetAry[i]._guid:_targetAry[i]._fackId;
				     if (_targedID==_targetAry[i]._targetID) {
						 _obj = {
						  _startTime:_targetAry[i]._startTime,
						  _needTime:_targetAry[i]._needTime,
						  _finishTime:_targetAry[i]._finishTime,
						  _target:_targetAry[i]._targetID,
						  _timeCheck:_targetAry[i]._timeCheck,
						  _schID:_targetAry[i]._guid
						  
						 }
						 break;
						}

				   }
				}
			
			return _obj;
			
		}
		
		
		/*
		private function checkDicHandler():Boolean 
		{
			var _return:Boolean = false;
			for (var i:String in this._dicRealLine) {
				_return = true;
				break;
			}
			
			return _return;
		}
		*/
		//------檢查該棟建築物是否正在升級當中
		public function CheckUpdataLine(_buildType:String,_buildTarget:String):Boolean 
		{
			var _flag:Boolean = true;
			if (this._dicRealLine[_buildType]!=null && this._dicRealLine[_buildType]!=undefined) {
				var _ary:Array = this._dicRealLine[_buildType];
				var _len:int = _ary.length;
				for (var i:int = 0; i <_len;i++ ) {
					if (_buildTarget==_ary[i]._targetID) {
					_flag = false;	
					break;	
					}
					
				}
				
				
			}
			return _flag;
		}
		
		
		//----同時取經過server註冊的LINE &&　還在排程中的
		//---{_build:String,_key:String}---送物件陣列進來
		public function GetSingleLine(_build:String,_key:String):Object 
		{
			var _obj:Object;
			if (this._dicRealLine[_build]!=null && this._dicRealLine[_build]!=undefined) {
				  var _targetAry:Array = this._dicRealLine[_build];
				  var _str:String = _key.substr(0,8);
				  for (var i:* in _targetAry) {
				     var _index:String= (_str!="fackLine")?_targetAry[i]._guid:_targetAry[i]._fackId;
				     if (_index==_key) {
						 _obj = {
						  _startTime:_targetAry[i]._startTime,
						  _needTime:_targetAry[i]._needTime,
						  _finishTime:_targetAry[i]._finishTime,
						  _target:_targetAry[i]._targetID,
						  _timeCheck:_targetAry[i]._timeCheck,
						  _schID:_targetAry[i]._guid
						  
						 }
						 break;
						}

				   }
				}
			return 	_obj;
			
		}
		
		
		public function GetCalculateTime(_build:String,_id:String):int 
		{
		    var _returnTime:int;
			var _nowTime:uint=ServerTimework.GetInstance().ServerTime;
			if (this._dicRealLine[_build]!=null && this._dicRealLine[_build]!=undefined) {
				var _ary:Array = this._dicRealLine[_build];
				var _len:int = _ary.length;
				for (var i:int = 0; i < _len;i++ ) {
					if (_ary[i]._guid==_id) {
				     var _endTime:int= _ary[i]._startTime+_ary[i]._needTime;
					  
						_returnTime =_ary[i]._finishTime- _nowTime;
					 
					  break;	
					
					}
					
					
				}
				
				
			}
			return _returnTime;
			
		}
		
		
		private function getPreInforHandler(_vo:Buildschedule):Object 
		{
			var _returnObj:Object = { };
			if (_vo._buildType == 3 || _vo._buildType == 4) { 
				_returnObj = PlayerMonsterDataCenter.GetMonsterData().GetTipsTimeLinne(_vo._targetID,_vo._buildType);
				
				} else if(_vo._buildType==6){
				//---煉金GetSingleRecipeInfo
				_returnObj = AlchemyDataCenter.GetAlchemy().GetSingleRecipeInfo(_vo._targetID);
				
			}else {
				//---牢房
				
			}
			return _returnObj;
		}
		
		
		//----取得全部的排程-----
		public function GetAllLine(_build:String):Array 
		{
			var _ary:Array = [];
			if (this._dicRealLine[_build]!=null && this._dicRealLine[_build]!=undefined) {
				var _targetAry:Array = this._dicRealLine[_build];
				for (var i:* in _targetAry) {
					//_targetID
					var _skill:int = (_build==this._libraryBuild)?PlayerMonsterDataCenter.GetMonsterData().GetMonsterLearning(_targetAry[i]._targetID):-1;
					
					var _obj:Object = {
						  _startTime:_targetAry[i]._startTime,
						  _needTime:_targetAry[i]._needTime,
						  _finishTime:_targetAry[i]._finishTime,
						  _target:_targetAry[i]._targetID,
						  _timeCheck:_targetAry[i]._timeCheck,
						  _learning:_skill,
						  _schID:_targetAry[i]._guid,
						  //---13/01/08新增(client要防呆=null的情況)
						  
						  _tipsInfo:this.getPreInforHandler(_targetAry[i])
					}
					//_obj._buildType
					
					if (_build == "buildingTimeline") {
						_obj._buildType=BuildingProxy.GetInstance().GetBuildType(_targetAry[i]._targetID);
						} else if("pvp"){
						_obj._buildType = _targetAry[i]._buildType;
					}

					_ary.push(_obj);
					
				}
				
			}
			
			return _ary;
			
		}
		
		//--BuildingProxy.GetBuildType
		
		/*
		public function GetUpgradeLine():Array 
		{
			
			var _ary:Array = this._dicRealLine["buildingTimeline"];
			var _len:int = _ary.length;
			var _returnAry:Array = new Array(8);
			for (var i:int = 0; i < _len;i++ ) {
				var _object:Object = {
					_startTime:_ary[i]._startTime,
					_needTime:_ary[i]._needTime,
					_finishTime:_ary[i]._finishTime,
				    _buildType:BuildingProxy.GetInstance().GetBuildType(_ary[i]._targetID),
					_schID:_targetAry[i]._guid	
				}
				
				_returnAry[_object._buildType-1] = _object;
				
			}
			
			
			return _returnAry;
			
		}*/
		
		
		public function ToRun():void 
		{
			//this._checkToRun = true;
			if (!TimeDriver.CheckRegister(this.UpdateTimerLine)) {
			  //----準備註冊阿翔的timer
			  if (!this._booleanTimerFlag) this._booleanTimerFlag = true;
			  TimeDriver.AddDrive(1000, 0, this.UpdateTimerLine);	
			  
			}
			/*
			this.checkTimerResgiterHandler();
			*/
		}
		/*
		private function checkTimerResgiterHandler():void 
		{
			
			if (this.checkDicHandler()==false &&TimeDriver.CheckRegister(this.UpdateTimerLine) ) {
					
				TimeDriver.RemoveDrive(this.UpdateTimerLine);	
			}
			
			if (!TimeDriver.CheckRegister(this.UpdateTimerLine)) {
			  //----準備註冊阿翔的timer
			  TimeDriver.AddDrive(1000,0,this.UpdateTimerLine);	
			}
			
		    
		}*/
		
		//-----花費消除排程
		public function CleanLine(_build:String,_key:String):void 
		{
			var _ary:Array = this._dicRealLine[_build];
			for (var i:* in _ary) {
				if (_ary[i]._guid==_key) {
					_ary[i]._flagTime = 1;
					//this._dicRealLine[_build].splice(i,1);
					//---直接VOclal連線
					break;
				}
			}
			//this.checkTimerResgiterHandler();
		}
		
		//-----PVP排程被搶奪的改變時間
		public function PVPChaneLine():void 
		{
			
		}
		
	   
		
		//---完成物品
		public function RemoveRealLine(_build:String,_key:String,_buildType:int):void 
		{
            //this.removeLineHandler(this._dicRealLine,_build,_key);
			
			if (this._dicRealLine[_build]!=null && this._dicRealLine[_build]!=undefined) {
				//var _ary:Array = this._dicRealLine[_build];
				var _len:int = this._dicRealLine[_build].length;
				for (var i:int = 0; i < _len;i++ ) {
				   if (this._dicRealLine[_build][i]._guid==_key) {
					   //var _schid:String=
					   this._dicRealLine[_build].splice(i, 1);
					   BuildingProxy.GetInstance().RemoveWorker(_build,_key);
					   this._funSendNotify(ProxyPVEStrList.TIMELINE_SCHID_COMPLETE, { _schid:_key,_build:_buildType});
					   //---去移除阿翔的建築物排程key
					   break;
					}	
				}
			    
				if ( this._dicRealLine[_build].length<=0) {
					 this._dicRealLine[_build] = null;
					delete  this._dicRealLine[_build];
				}
				
				//this.checkTimerResgiterHandler();
				
			}
				
			
		}
		
		/*
		public function CallTestRemoveALL():void 
		{
			var _test:Array = this._dicRealLine["BLD135400192937888"];
			for (var i:* in _test) {
			var _str:String = _test[i]._buildType + ":"+_test[i]._guid;
			var _Get_Buildscheduleres:Get_Buildschedule = new Get_Buildschedule(_test[i]._guid, _str,_test[i]._buildType);
			this._funVoGroup(_Get_Buildscheduleres);
			}
			
		}*/
		
		public function CheckTime():String 
		{
			var _str:String = "";
			for (var i:String in this._dicRealLine) {
				
				_str = "<<_timeCheck>>__" + String(this._dicRealLine[i][0]._timeCheck) +"<<_finishTime>>__" + String(this._dicRealLine[i][0]._finishTime);
				break;
			}
			
			return _str ;
		}
		
	    
		private function resetGetVOHandler(_build:String,_guid:String):Buildschedule 
		{
			var _returnLine:Buildschedule;
			if (this._dicRealLine[_build].length!=0) {
				var _len:int=this._dicRealLine[_build].length
				for (var i:int = 0; i < _len;i++) {
					if (this._dicRealLine[_build][i]._guid==_guid) {
						_returnLine = this._dicRealLine[_build][i];
						break;
					}
						
				}
				
			}
			
			return _returnLine;
		}
		
		
		//------重新啟動記時機制------
		public function ReSetschedule(_error:BuildSchedule_Error):void 
		{
			if (this._booleanTimerFlag) this._booleanTimerFlag = false;
			var _Schedule:Buildschedule=this.resetGetVOHandler(_error._buildID,_error._guid);
			if (_Schedule!=null) {
				trace("TimerLine_Reset>>");
				_Schedule._needTime = _error._needTime;
				_Schedule._timeCheck = 0;
				_Schedule._flagTime = 0;
				this._fpsResetFlag = false;
				this._booleanTimerFlag = true;
				//EventExpress.DispatchGlobalEvent(ProxyPVEStrList.FPSEvent_Ready);
			}else {
			  trace("ReSetschedule_Error");	
			  	
			}
		}
		
		
		//---時間機制凍結後的重新啟動----
		/*
		public function ResetAllTime():void 
		{
		   for (var i:String in this._dicRealLine){	
			 var _ary:Array = this._dicRealLine[i];
			 var _lenAry:int = _ary.length;
		     for (var j:int = 0; j < _lenAry;j++) {
				 var _str:String = _ary[j]._buildType + ":"+_ary[j]._guid;
				  var _Get_Buildscheduleres:Get_Buildschedule = new Get_Buildschedule(_ary[j]._guid, _str,_ary[j]._buildType);
				  //this._funVoGroup(_Get_Buildscheduleres);    
				  this._AMFConnect.VoCallGroup(_Get_Buildscheduleres); 
		       }
			   
			}
			//----送出連線請求-----
			this._fpsResetFlag = true;
			this._AMFConnect.SendVoGroup();
		}
		*/
		
		//---server校正時間回來(慢的話給正值)---
		//---PS-換算成[無條件進位]的秒數!!!!](正負值)
		//---2013/05/08---
		public function ReSetCheckTime(_sercerTime:int):void 
		{
			trace("SERVERReBack>>"+_sercerTime);
			if (this._booleanTimerFlag) this._booleanTimerFlag = false; 
			for (var i:String in this._dicRealLine) {
				var _ary:Array = this._dicRealLine[i];
				var _lenAry:int = _ary.length;
				for (var j:int = 0; j < _lenAry;j++ ) {
					if (this._dicRealLine[i][j]._flagTime==0 && this._dicRealLine[i][j]._guid!="") {
						this._dicRealLine[i][j]._timeCheck = this._dicRealLine[i][j]._timeCheck + _sercerTime;	
					}
					
				}	
			}
			//---0509測試用
			this.testTracerTimerLine();
			this._booleanTimerFlag = true;
		}
		
		//----serverResetTimer----
		private function testTracerTimerLine():void 
		{
		    for (var i:String in this._dicRealLine) {
				var _ary:Array = this._dicRealLine[i];
				var _lenAry:int = _ary.length;
				for (var j:int = 0; j < _lenAry;j++ ) {
					trace("restetLine<ID>>>"+this._dicRealLine[i][j]._guid+">>>initTimes>>"+this._dicRealLine[i][j]._startTime+">>_needTime>>"+this._dicRealLine[i][j]._needTime+">>>runnReset>>"+this._dicRealLine[i][j]._timeCheck);
				}	
			}	
		}
		
		
	    //private var _testTimers:int = 0;
		//----刷新時間使用
		public function UpdateTimerLine():void 
		{
			//this._testTimers++;
			//trace("Driver_Running__LINE@@@@@@@@>" + ServerTimework.GetInstance().ServerTime);
			//if (!this._booleanTimerFlag) { return };
			var _timer:Number = (getTimer()- this._currFrameTime)/1000;
			
			this._currFrameTime = getTimer();
			//this._getTimer = this._getTimer - _timer;
			trace("_currTimer>>"+_timer);
			for (var i:String in this._dicRealLine) {
				var _ary:Array = this._dicRealLine[i];
				var _lenAry:int = _ary.length;
				for (var j:int = 0; j < _lenAry;j++ ) {
					if (_ary[j]._flagTime==0) {
					 _ary[j]._timeCheck++
					if (_ary[j]._timeCheck>=_ary[j]._needTime) {
						_ary[j]._flagTime = 1;
					
						//----建築物類型1.大廳（魔法陣）, 2.巢穴 3.溶解所, 4.圖書館, 5.儲藏室, 6.煉金所, 7.牢房, 8.英靈室
						if (_ary[j]._guid=="") {
							//var _index:int = this._dicRealLine[i]._needTime-this._dicRealLine[i]._timeCheck;
							trace("_timeCheck_back_10");
							_ary[j]._timeCheck -= 2;
					        _ary[j]._flagTime = 0;
							} else {
							trace("complete[TimerLine]--->"+ServerTimework.GetInstance().ServerTime);
							var _str:String = _ary[j]._buildType + ":"+_ary[j]._guid;
							var _Get_Buildscheduleres:Get_Buildschedule = new Get_Buildschedule(_ary[j]._guid, _str,_ary[j]._buildType);
							var _strMission:String = this.getMissionTypeHandler(_ary[j]._buildType);
							
							this._amfConnect.VoCallGroup(_Get_Buildscheduleres);
							if (_strMission!="") {
								var _mission:MissionConditionComplete= new MissionConditionComplete(); 
								_mission._missionType = _strMission;
								_mission._target = _ary[j]._targetID;
								this._amfConnect.VoCallGroup(new Get_Mission([_mission]));
								//this._funVoGroup(_Get_Buildscheduleres);
								if (_ary[j]._buildType==6) { 
									var _missionHave:MissionConditionComplete= new MissionConditionComplete(); 
									_missionHave._missionType = ProxyPVEStrList.MISSION_Cal_MONSTER_HAVE;
									_missionHave._target = _ary[j]._targetID;
									this._amfConnect.VoCallGroup(new Get_Mission([_missionHave]));
									
								};
								
							
							}
							
						
							this._amfConnect.SendVoGroup();
							
							
							//var _schID:String = "GetSCH__"+_ary[j]._guid;
							//this._funSendNotify("ERROR_TRACER_COM", _schID);Get_Buildschedule
						}
						
						//-----直接推到ㄎㄎhold清單的連線器裡面-----
						//--靠建築物的type來判斷是哪個建築物~來給予特別的值(Get_Buildscheduleres)
						//this._aryCompleteHold.push(_readyVO);
						
					}	
					
				}
					
					
				}
				
				
				
				
			}
			
			//this._currFrameTime = SetTimer();
		}
		
		
		private function getMissionTypeHandler(_id:int):String
		{
			
			
			
			var _missionType:String = "";
			switch(_id) {
				
				case 0:
				 _missionType=ProxyPVEStrList.MISSION_Cal_MISBUILD;	
				break;
				/*
			    case 1:
				_missionType=ProxyPVEStrList.MISSION_Cal_MISBUILD;	
				break;
				
			    case 2:
				_missionType=ProxyPVEStrList.MISSION_Cal_MISBUILD;	
				break;
				*/
			    case 3:
				_missionType = ProxyPVEStrList.MISSION_Cal_MONSTER_TRAN;	
				break;
				
			    case 4:
				_missionType=ProxyPVEStrList.MISSION_Cal_MONSTER_SKILL;	
				break;
				/*
			    case 5:
				_missionType=ProxyPVEStrList.MISSION_Cal_MISBUILD;	
				break;
				*/
			    case 6:
				_missionType=ProxyPVEStrList.MISSION_Cal_MTL_MAKE;
				break;
				
				
			}
			
			return _missionType;
		}
		
		public function Remove():void 
		{
			this._fackindex = null;
			this._funSendNotify = null;
			this._initCheck = null;
			
			for (var i:String in this._dicRealLine) {
				this._dicRealLine[i] = null
                delete this._dicRealLine[i];
			}
			
			this._dicRealLine = null;
			//this.checkTimerResgiterHandler();
		}
		
		
		
		
		
		
		
	}
	
}



