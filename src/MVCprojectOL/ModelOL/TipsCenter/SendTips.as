package MVCprojectOL.ModelOL.TipsCenter
{
	//import MVCprojectOL.ModelOL.Vo.Template.BasicVaule;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class SendTips 
	{
		//----發送本身的ClassName---
		private var _tipSystem:String = "";
		//---所在系統-------
		private var _viewSystem:String = "";
		//------
		//private var _nowSendSystem:String;
		//--tips的類型--
		private var _tipsType:String = "";
		
		private var _scherID:String;
		
		private var _picItem:String;
		
		private var _guid:String = "";
		
		//---排程完成暫時替代的(提示完成的字串)(要刪掉)------
		private var _strType:int = 0;
		
		//---所在的系統(例如>熔解排程完成,他所進行排程的建築物--就是容解所=3)
		private var _buildType:int = 0;
		
		//----對應開啟的建築物列表欄位(例如stone完成,他所開啟的就是儲藏室=5)----
		private var _openBuidType:int = 0;
		
		private var _nowTime:uint = 0;
		
		private var _complete:uint = 0;
		
		private var _total:uint = 0;
		
		
		private var _tipsClassName:String = "";
		
		private var _tipsObj:Object = { };
		
		
		//---0417暫時使用的
		private var _width:int = 0;
		private var _height:int = 0;
		
		/*
		private var _nowTime:int = 0;
		private var _completeTimes:int = 0;
		private var _totalTies:int = 0;
		private var _width:int = 0;
		private var _height:int = 0;
		*/
		
		//---原本的_text(時間排程再用的)
		//private var _cdObject:Object;
		//---替換的字元碼
		//private var _change:String = "";
		
		private var _mouseX:Number = 0;
		
		private var _mouseY:Number = 0;
		//------純文字TIPS系統(自行帶入的字串)----
		//private var _strTips:String = "";
		
		
		
		private var _scherObject:Object;
		
		private var _monsterID:String="";
		private var _equGroupID:String="";
		private var _title:String="";
		private var _quality:int = 1;
		//---完成系統(字串)----
		private var _completeStr:String = "";
		
		//private var _stoneID:String;
		
		public function SendTips(_system:String,_name:String,..._args) { 
			this._tipSystem = _system;
			this._tipsType = _name;
			this.SetVauleHandler(_name,_args);
			
		};
		
		public function get tipSystem():String { return _tipSystem };
		
		public function get picItem():String { return this._picItem};
		
		public function get strType():int { return this._strType };
		
		public function get buildType():int { return this._buildType};
		
		public function get nowTime():uint { return this._nowTime };
		
		public function get complete():uint { return this._complete };
		
		public function get total():uint { return this._total };
		
		//public function get change():String { return this._change };
		
		public function get mouseX():Number { return this._mouseX };
		
		public function get mouseY():Number { return this._mouseY };
		
		//public function get strTipsSystem():String { return this._strTipsSystem };
		
		public function get scherObject():Object { return this._scherObject };
		
		public function get guid():String { return this._guid };
		
		//public function get strTips():String { return this._strTips };
		
		public function get viewSystem():String { return this._viewSystem };
		
		public function get scherID():String { return this._scherID };
		
		public function get openBuidType():int { return this._openBuidType};
		
		public function get monsterID():String { return _monsterID };
		
		public function get equGroupID():String { return _equGroupID };
		
		public function get title():String { return _title };
		
		public function get tipsObj():Object {return _tipsObj;}
		
		public function get tipsClassName():String { return _tipsClassName };
		
		public function get quality():int { return _quality };
		
		public function get width():int { return _width };
		
		public function get height():int { return _height };
		//-------完成字串----
		public function get completeStr():String { return _completeStr };
		
		//----TIPS的類型---
		public function get tipsType():String {return _tipsType;}
		
		
		
		
		//public function get stoneID():String { return _stoneID };
		
		
		
		
		
		//---_args在系統中會被視為array.....可用陣列的方法操控(也是可以用for each來掃)
		private function SetVauleHandler(_str:String,_args:*):void 
		{
			switch(_str) {
				case ProxyPVEStrList.TIP_COMPLETE:
					if (_args[0] != null) this._picItem = _args[0];
					if (_args[1] != null) this._guid = _args[1];
					if (_args[2] != null) this._buildType = _args[2];
					if (_args[3] != null) this._strType = _args[3];
					if (_args[4] != null) this._scherID = _args[4];
					if (_args[5] != null) this._openBuidType = _args[5];
					//if (_args[6] != null) this._completeStr = _args[6];
					if (_args[6] != null) this._tipsObj = _args[6];
					
					
				break;
				
				case ProxyPVEStrList.TIP_PVP:
				break;
				//--->system>1.大廳（魔法陣）, 2.巢穴, 3.溶解所, 4.圖書館, 5.儲藏室, 6.煉金所, 7.牢房, 8.英靈室
			    case ProxyPVEStrList.TIP_SCHER:
				    if (_args[0] != null)this._picItem = _args[0];
					if (_args[1] != null)this._scherObject=_args[1];
				    if (_args[2] != null) this._nowTime = _args[2];
				    if (_args[3] != null) this._complete = _args[3];
				    if (_args[4] != null) this._total = _args[4];
				    if (_args[5] != null) this._buildType = _args[5];
					
					
					
				break;
				
			      case ProxyPVEStrList.TIP_STRBASIC:
				/*
			    
				_guid(系統公用字串-就是KEY碼),
				_tipsClassName=要抽取的class名稱
				_mouseX:Number,
				_mouseY:Number,
				_system:String="所開啟的系統字串名稱(view名稱)"}
				 */
				  
				   if(_args[0] != null)this._guid=_args[0];
				   if(_args[1] != null)this._tipsClassName=_args[1];
				   if(_args[2] != null)this._tipsObj=_args[2];
				   if(_args[3] != null)this._mouseX=_args[3];
				   if (_args[4] != null)this._mouseY = _args[4];
				   if (_args[5] != null)this._quality = _args[5];
				   
				   
				break;
				
				//---攻擊範圍----
				case ProxyPVEStrList.TIP_Skill:
				break;
				
				case ProxyPVEStrList.TIP_Explore:
				break;
				
				
				//-----裝備預覽
			    case ProxyPVEStrList.TIP_MonsterEqu:
				   //---裝備ID--
				   if(_args[0] != null)this._guid=_args[0];
				   //---裝備群組ID
				   if(_args[1] != null)this._equGroupID=_args[1];
				   //---怪獸ID
				   if(_args[2] != null)this._monsterID=_args[2];
				   //---標題
				   if(_args[3] != null)this._title="SysTip_EQUPRE";
				   if(_args[4] != null)this._picItem=_args[4];
				
				break;
				
				//-----吃石頭預覽
			    case ProxyPVEStrList.TIP_MonsterEatStone:
			    //---stoneID	    
				if(_args[0] != null)this._guid=_args[0]; 
				//---怪獸ID
				if(_args[1] != null)this._monsterID=_args[1];
				//---標題
				//if(_args[2] != null)this._title=_args[2];
				if(_args[2] != null)this._title="SysTip_EatStonePRE";
				if(_args[3] != null)this._picItem=_args[3];
				
				
				break;
				
				
				//---暫代的timerbar---
			    case ProxyPVEStrList.TIP_TIMERBAR:
				   //-----
				   if(_args[0] != null)this._nowTime=_args[0];
				   if(_args[1] != null)this._complete=_args[1];
				   if(_args[2] != null)this._total=_args[2];
				   if (_args[3] != null) this._buildType = _args[3];
				   if(_args[4] != null)this._width=_args[4];
				   if(_args[5] != null)this._height=_args[5];
				break;
				
			
			}
				
		}
		
		
		
		
	}
	
}