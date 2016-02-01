package MVCprojectOL.ModelOL.TipsCenter.StrCenter 
{
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.TipsCenter.Basic.MonsterEatStone;
	import MVCprojectOL.ModelOL.TipsCenter.StrCenter.GetClassCenter;
	import MVCprojectOL.ModelOL.TipsCenter.TipsLab.TipsDataLab;
	import MVCprojectOL.ModelOL.Vo.PlayerEquipment;
	import MVCprojectOL.ModelOL.Vo.PlayerMonster;
	import MVCprojectOL.ModelOL.Vo.PlayerStone;
	import MVCprojectOL.ModelOL.Vo.Skill;
	import MVCprojectOL.ModelOL.Vo.Template.BasicVaule;
	//import org.papervision3d.view.BasicView;
	import Spark.Utils.KeyCodeInfo.UrlKeeper;
	//import MVCprojectOL.ModelOL.TIPDate.TipsData;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author EricHuang
	 * tipsdataCenter----2013/01/08
	 * 
	 * <font color="#FFFFFF">+^_attack^ 攻擊</font>
		<font color="#FFFFFF">+^_defense^ 防禦</font>
		<font color="#FFFFFF">+^_int^ 智慧</font>
		<font color="#FFFFFF">+^_mnd^ 精神</font>
		<font color="#FFFFFF">+^_speed^ 速度</font>
	 */
	public class TipstrData 
	{
		
		//private static var _TipstrData:TipstrData;
		//private var _dicTips:Dictionary;
		private var _sendFunction:Function;
		private var _flag:Boolean;
		//private var _KeyWordList:Vector.<String>;
		//private var _KeyWordList_Found:Vector.<String>;
		//---取得讀取要替換數值的function---
		private var _GetClassCenter:GetClassCenter;
		private var _TipsData:TipsDataLab;
		//-----需要再完成tips下載才能繼續操作---
		public function TipstrData()
		{
			//this._dicTips = new Dictionary(true);
			//this._sendFunction = _fun;
			//this._flag = false;
			//this._KeyWordList = new Vector.<String>();
			//this._KeyWordList_Found = new Vector.<String>();
		    this._GetClassCenter = new GetClassCenter();
			//---取得tips的內容---
			//this._TipsData = TipsDataLab.GetTipsData(_fun);
			
			
		}
		
	
	
		//-----2013/03/08----取代字串與搜尋------
		//---正規式
		//---test>___________________\^(.[^\^]*)\^
		
		private var _checkRegExp:RegExp =/\^(.[^\^]*)\^/;
		private var _singleRegExp:RegExp =/([^.]*).([^.]*)/;
		//private var _hideleRegExp:RegExp =/(\\n(.*)\+0(.*)\\n)/;
		
		
		//_class=proxy註冊的名稱
		
		public function GetTips(_key:String="",_className:String="",_objTarget:Object=null):String 
		{
			
			var _tipsString:String="Error";
			
			
			if (_key!="") {
			var _target:String=this._TipsData.GetTipsDate(_key);	
			var _str:String = (_target=="")?"Error_Tips_Undefind":_target; 
		    var _fun:Function = (_target=="")?this.deBugTips:this.getTipsHandler;
			
			_tipsString=_fun(_str,_className,_objTarget);	
			}
			
			return _tipsString;
		}
		
		
		private var _deBugStr:String = '<textformat leading="8"><font size="13" color="#C9A99B"><b>^_error^</b></font><br></textformat><textformat leading="2"></textformat>';
		public function deBugTips(_str:String,..._args):String 
		{
			var _target:String = this._deBugStr;
			var _return:String = _target.replace(this._checkRegExp,_str);
			return _return
		}
		
		
		private function getTipsHandler(_str:String,_className:String="",_objTarget:Object=null):String 
		{
			//var _strTips:String = (_str != "")?_str:"Null";
			var _strTips:String = (_str != "")?_str:"";
			//var _quaName:String = "";
			if (_strTips!="" && _objTarget!=null ) {
				var _regExp:Object = this._checkRegExp.exec(_str);
				var _classFuction:Function=this._GetClassCenter.GetFunction(_className);
				var _targetObject:*= _classFuction(_objTarget);
				//trace("_input_>"+_strTips);
				//_strTips = (_targetObject._info != null)?_strTips+'<br>'+_targetObject._info:_strTips;
				while (_regExp!=null) {
					var index:String = _regExp[0] as String;
					//var _target:String = index.slice(1, index.length - 1);
					var _target:String = _regExp[1] as String;
					
					switch(true) {
						/*
					   	case _targetObject is PrevoClass:
							var _strImage:String = _target.slice(-3);
							if (_strImage=="ICO") {
								//---getImageUrl----
								//trace("getget");
                                var _url:String = UrlKeeper.getUrl(_target);
								_strTips = _strTips.replace(index,_url);
								} else {
								if ((_target=="SysTip_QUACOLOR") || (_target == "SysTip_QUACOLOR_END")) {
									
									var _getIndexTest:String = (_target=="SysTip_QUACOLOR_END")?_target:_target + "_" + _targetObject._quality;
									var _changeStrTest:String =this._TipsData.GetTipsDate(_getIndexTest);
									 _strTips=_strTips.replace(index,_changeStrTest);
										} else {
									if (_strImage=="CHA") {
										//---顏色變色(裝備)----
										var _colorTab:String =this._TipsData.GetColorChange(_targetObject[_target]);
										_strTips= _strTips.replace(index,_colorTab); 
										} else {
									    _strTips = _strTips.replace(index,_targetObject[_target]); 	
									}
									
								}	
							}
							trace("getTipsObj");
						break;
						*/
						
						case _targetObject is PlayerMonster:
							if ((_target=="SysTip_MON_QUACOLOR") || (_target == "SysTip_QUACOLOR_END")) {
								
								var _getIndex:String = (_target=="SysTip_QUACOLOR_END")?_target:_target + "_" + _targetObject._rank;
								var _changeColorStr:String = this._TipsData.GetTipsDate(_getIndex);
								_strTips=_strTips.replace(index,_changeColorStr);
								} else {
								
								if (_target == "_basicFive") {
								 var _fiveStr:String = this.getFiveVauleHandler(_targetObject);
								 _strTips=_strTips.replace(index,_fiveStr);
								
								} else {
							    _strTips = _strTips.replace(index,_targetObject[_target]);	
								
							    }
								
							}
							
						break;
						case _targetObject is PlayerEquipment:
						case _targetObject is MonsterEatStone:
					
						   if ((_target=="_quality") || (_target=="SysTip_QUACOLOR") || (_target == "SysTip_QUACOLOR_END")) {
						   if (_target=="_quality" ) {
							   //_quaName = _target;
							   //_strTips = _strTips.replace(index,TipsDataLab.GetTipsData().GetQuaName(0,_targetObject._quality)); 
							   var _quaStr:String = String(_target)+"_"+_targetObject[_target];
								_strTips=_strTips.replace(index,this._TipsData.GetTipsDate(_quaStr));
							}else {
							  var _getIndex:String = (_target=="SysTip_QUACOLOR_END")?_target:_target + "_" + _targetObject._quality;
							  var _changeStr:String =this._TipsData.GetTipsDate(_getIndex);
							  _strTips=_strTips.replace(index,_changeStr);	
									
								
							}
						
							
						}else {
							if (_target == "_basicFive") {
								 var _fiveStr:String = this.getFiveVauleHandler(_targetObject);
								 _strTips=_strTips.replace(index,_fiveStr);
								
								} else {
							 _strTips = _strTips.replace(index,_targetObject[_target]);	
								
							}
							
						}	
							
							
							
						break;
						
						
					   case _targetObject is PlayerStone:
						  
						  
						   //--取五屬性
						   if (_target=="_basicFive") { 
							    var _getFiveStr:String = this.getFiveVauleHandler(_targetObject);
							   _strTips=_strTips.replace(index,_getFiveStr);
							   } else {
							   _strTips = _strTips.replace(index, _targetObject[_target]);
							}
						   
						   /*
						   if (_target=="_attack" || _target=="_defense" || _target=="_int" || _target=="_mnd" || _target=="_speed") {
							 var _stoneRegExp:Object = this._hideleRegExp.exec(_strTips); 
							 if (_stoneRegExp!=null) { 
							  _strTips = _strTips.replace(_stoneRegExp[1],"");
							   //_strTips = _strTips.replace(_stoneRegExp,_targetObject[_target]);  
						    } 
							   
							   
							}
						   */
						   //_strTips = _strTips.replace(index,_targetObject[_target]);
						   //--(.*[+0].*)
						   
						
						break;
						
						
					    case _targetObject is Skill:
						  var _tipsIndex:int = -1; 
						  var _tipesMap:String = (_target == "_class" || _target == "_launchType" || _target == "_executeType")?String(_target)+"_"+_targetObject[_target]:""; 
						  if (_tipesMap!="") {
							 //var _changeStrMap:String =this._TipsData.GetTipsDate(_tipesMap);
							 _strTips=_strTips.replace(index,this._TipsData.GetTipsDate(_tipesMap));
							  } else {
							 _strTips = _strTips.replace(index,_targetObject[_target]);   
						   }
						  
						
						  
						  
						  //_strTips = _strTips.replace(index,TipsDataLab.GetTipsData().GetQuaName(_targetObject._quality)); 
						
						break;
						
					    default:
						  var _targetRegExp:Object = this._singleRegExp.exec(_target);
						  if (_targetRegExp[2]=="") {
							   _strTips = _strTips.replace(index,_targetObject[_target]);
							  } else {
							   var _indexStar:String = _targetRegExp[1] as String;
							   var _indexEnd:String=_targetRegExp[2] as String;
								  
							   _strTips = _strTips.replace(index,_targetObject[_indexStar][_indexEnd]);
							  
						   }
						
						
					}
					

					_regExp=this._checkRegExp.exec(_strTips);
				}
				
				//--hello 我很帥 _aaa
			}
			//trace("_strTips___"+_strTips);
			//---改變tips的外框(取得品質資訊)
			//if (_targetObject is PlayerEquipment)_strTips = _strTips + _targetObject["_quality"];
			return _strTips;
		}
		
		//---有就顯示~沒有就不顯示
		private function getFiveVauleHandler(_class:BasicVaule):String 
		{
			
			var _str:String = "";
			if (_class._attack != 0)_str +="+"+_class._attack +this._TipsData.GetTipsDate("_attack")+"\n";
			if (_class._defense != 0)_str += "+"+_class._defense+this._TipsData.GetTipsDate("_defense") + "\n";
			if (_class._int != 0)_str +="+"+ _class._int +this._TipsData.GetTipsDate("_int")+"\n";
			if (_class._mnd != 0)_str +="+"+_class._mnd +this._TipsData.GetTipsDate("_mnd")+"\n";
			if (_class._speed != 0)_str +="+"+ _class._speed +this._TipsData.GetTipsDate("_speed")+"\n";
			if (_class._HP != 0)_str +="+"+_class._HP+this._TipsData.GetTipsDate("_HP")+"\n";
			_str = _str.substr(0,_str.length-1);
			return _str;
		}
		
		public function set TipsData(value:TipsDataLab):void 
		{
			_TipsData = value;
		}
		
	}
	
}