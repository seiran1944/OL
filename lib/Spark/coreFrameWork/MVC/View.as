package Spark.coreFrameWork.MVC
{
	import Spark.coreFrameWork.Interface.IFMeditorGUI;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfObserver;
	import Spark.coreFrameWork.Interface.IfView;
	import flash.utils.Dictionary;
	import Spark.GUI.BasicPanel;
	//import mx.controls.ButtonLabelPlacement;
	
	/**
	 * ...
	 * @author EricHuang
	 * MVC pattern-----View Center----
	 * 
	 */
	public class  View
	{
		
		private static var _view:View;
		
		private var _dicObserver:Dictionary;
		private var _dicViewConterBox:Dictionary;
		//----調管gui專用的meditor------
		//private var _GuiMeditor:IFMeditorGUI;
		
		//private var _dicGui:Dictionary;
		
		
		//---2013/06/17-建立再同一層可視清單的列表-*---
		private var _dicContent:Dictionary;
		
		
		public function View() 
		{
			if (View._view != null) throw Error("[View] build illegal!!!please,use [Singleton]");
            View._view = this;
			this._dicObserver = new Dictionary(true);
			this._dicViewConterBox = new Dictionary(true);
			//this._dicContent = new Dictionary(true);
			//this._dicGui = new Dictionary(true);
			
		}
		
		
		public static function GetView():View 
		{
			if (View._view == null )View._view = new View();
			return View._view;
		}
		
		
		//----command 會來這邊訂閱-----
		public function RegisterObserver(_ObserverName:String,observer:IfObserver):void 
		{
			trace("Register[Observer]>>>>>" + "[" + _ObserverName + "]");
			//var _flag:Boolean=
			trace("RegisterOBSERVER----"+this.checkMapHandler(_ObserverName));
			if (this.checkMapHandler(_ObserverName)) {
				this._dicObserver[_ObserverName].push(observer);
				} else {
				this._dicObserver[_ObserverName] = [observer];
				
			}
			
		}
		
		
		public function RemoveObserver(_index:String,_target:Object,_key:String):void 
		{
			
			if (this.checkMapHandler(_index)) {
				trace("RemoveObserver");
				var _len:int = this._dicObserver[_index].length;
				
				for (var i:int = 0;i < _len; i++ ) {
					
			     	//檢查註冊的本體是否為同一個
					//var _IfObserver:IfObserver = this._dicObserver[_index][i];
					//var _lenFinal:int = this._dicObserver[_index].length;
					//var _boolean:Boolean=this._dicObserver[_index][i].CehckObserver(_target)
					//trace("OBSERVER>>>>>"+_boolean);
					if (this._dicObserver[_index][i].CehckObserver(_key)) {
				     	trace("RemoveObserver----" + _index);
						this._dicObserver[_index].splice(i, 1);
						break;
						//trace("reback>>"+this._dicObserver[_index].length);
					}
					
				}
				
				if (this._dicObserver[_index].length==0) {
					this._dicObserver[_index] = null;
				    delete this._dicObserver[_index];
				}
				
		     	}else {
			 return;	
			}
		}
		
		//------11/23-----
		public function GETTestObserverList():Dictionary 
		{
			return this._dicObserver;
		}
		
		
		//----要被改變的可視物件都在這邊註冊
		public function RegisterViewCtrl(_target:IfView):void 
		{
		    if (this.CheckViewCtrlHandler(_target.GetViewName())) {
				trace("RegisterViewCtrl=========["+_target.GetViewName()+"]");
				/*
				if (this._dicContent[_target.GetViewConterName()]==null) {
					this._dicContent[_target.GetViewConterName()] = [_target.GetViewName()];
					} else {
					this._dicContent[_target.GetViewConterName()].push(_target.GetViewName());	
				}*/
				this._dicViewConterBox[_target.GetViewName()] = _target;
				_target.onRegisted();
			}	 
		}
		
		//---檢查該層是否有兩個系統在內~且最上層的屬於可以刪除的(註冊系統名稱)
		/*
		public function CheckCompleteJump(_name:String):String 
		{
			var _flag:String = "";
			
			if (this._dicContent[_name]!=null) {
				if (this._dicViewConterBox[this._dicContent[_name][this._dicContent[_name].length-1]]!=null) {	
				  var _targetView:IfView=IfView(this._dicViewConterBox[this._dicContent[_name][this._dicContent[_name].length - 1]]);	
				  
				  if (_targetView.GetLock() == false) {
					  _flag = _targetView.GetViewName();
					  _targetView.DisplayClose();
					 }
				}
			}
			
			
			return _flag;
		}
			
		*/
		
		//----取得要改變的實體可視物件-----
		public function GetRegisterViewCtrl(_index:String):IfView 
		{
			
			var _returnView:IfView=(this._dicViewConterBox[_index] != null && this._dicViewConterBox[_index] != undefined)?this._dicViewConterBox[_index]:null;
		
			return _returnView;
		}
		
		
		//---移除代管的ViewCtrl-*------
	    public function RemoveRegisterViewCtrl(_index:String):void 
		{
			if (!this.CheckViewCtrlHandler(_index)) {
			 var _viewCtrl:IfView = this._dicViewConterBox[_index];
			
			 
			 //---移除容器顯示的比較
			 /*
			 var _strIndex:String = _viewCtrl.GetViewConterName();
		   	 var _ary:Array = this._dicContent[_strIndex];
			 var _len:int=_ary.length 
			 for (var i:int = 0; i < _len;i++ ) {
				if (_index==_ary[i]) {
					_ary.splice(i, 1);
					break;
				} 
				 
			 }
			 if (_ary.length == 0) {
				this._dicContent[_strIndex] = null;
				delete this._dicContent[_strIndex];
			  }
			 */ 
			 this._dicViewConterBox[_index] = null;
			 delete this._dicViewConterBox[_index];
			 _viewCtrl.onRemoved();
			 
			}
		}
		
		
		
		//----send messages for observers------
		
		public function SendObservers(_infor:IfNotifyInfo):void 
		{
			var _test:Boolean = this.checkMapHandler(_infor.GetName());
			if (this.checkMapHandler(_infor.GetName())) {
				var _ary:Array = this._dicObserver[_infor.GetName()];
				
				for (var i:* in _ary) {
			        _ary[i].SendNotifyObserver(_infor);	
					
				}
			}
		}
		
		
		private function CheckViewCtrlHandler(_index:String):Boolean 
		{
			var _flag:Boolean = (this._dicViewConterBox[_index]!=null && this._dicViewConterBox[_index]!=null)?false:true;
			return _flag;
		}
		
		private function checkMapHandler(_index:String):Boolean 
		{
			var _flag:Boolean = (this._dicObserver[_index]!=null && this._dicObserver[_index]!=undefined)?true:false;
			
			return _flag;
		}
		
		//---_GuiMeditor---
		//----註冊託管GUI的仲介者
		/*
		public function RegisterMeditorGUI(_obj:IFMeditorGUI):void 
		{
			if (this._GuiMeditor==null) {
				this._GuiMeditor = _obj;
				} else {
				return;
			}
		}
		
		//---_dicGui--_GuiMeditor
		//----PS---_class:Class>>要改成接interface(gui)-----
		public function RegisterGui(_name:String,_class:BasicPanel):void 
		{
			if (this.checkGuiHandler(_name)) {
				_class.AddMeditor(this._GuiMeditor);
				this._dicGui[_name] = _class;
				_class.OnRegeisterGUI();
			}else {
			 return;	
			}
		}
		
		
		public function RemoveGui(_name:String):void 
		{
			if (this.checkGuiHandler(_name)) {
				this._dicGui[_name].RemoveMeditor();
				delete _dicGui[_name];
			}
		}
		
		
		public function GetRegisterGui(_name:String):BasicPanel 
		{
			var _obj:BasicPanel = (this.checkGuiHandler(_name))?null:this._dicGui[_name];
			return _obj;
		}
		
		
		private function checkGuiHandler(_index:String):Boolean
		{
			var _returnFlag:Boolean = (this._dicGui[_index] == null && this._dicGui[_index] == undefined)?true:false;
			return _returnFlag;
		}
		*/
	}
	
}