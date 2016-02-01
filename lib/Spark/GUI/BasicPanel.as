package Spark.GUI
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import Spark.coreFrameWork.Interface.IfNotify;
	import Spark.coreFrameWork.MVC.FacadeCenter;
	//import Spark.coreFrameWork.Interface.IfCommands;
	import Spark.coreFrameWork.Interface.IFMeditorGUI;
	import Spark.Utils.Text;
	
	/**
	 * @Engine SparkEngine beta V1.0.0
	 * @author EricHuang
	 * @version 2012.08.13
	 * @param 本class用於basic panel ctrl---------------
	 * @player 11.0
	 * 該基礎GUI工具只能透過繼承來使用------
	 */
	
	 
	 
	//---用於基本型態的控制面板---- 
	public class BasicPanel extends Sprite implements IfNotify
	{
		
		
		protected var _guiIDName:String = "";
		protected var _objTransfrom:Object;
		
		//---開啟或是關閉該操作面板-----
		protected var _closeFlag:Boolean;
		//---裝載按鈕------
		//protected var _vecBtn:Vector.<BtnSingle> = new Vector.<BtnSingle>();
		protected var _vecStrin:Vector.<Text> = new Vector.<Text>();
		
		protected var _layerID:int = 0;
		
		protected var _MeditorGUI:IFMeditorGUI;
		
		protected var _function:Function = FacadeCenter.GetFacadeCenter().SendNotify;
		
		
	    //----this._bg maybe[bitmapdata]/[movieclip]----
		public var _Bg:*;
		
		public function BasicPanel () 
		{
			
		}
		
		
		public function SendNotify(_notifyName:String,body:Object=null):void 
		{
			this._function(_notifyName,body);
		}
		
		
		//---set Your BackGround pic*---------0=bitmapData/1=MovieClip
		public function AddBG(_bg:*,_flag:int):void 
		{
			if (_flag==0) {
				this._Bg= new Bitmap(_bg);
				} else {
				this._Bg = _bg;	
			}
			this.addChild(this._Bg);
			
		}
		//---add stringtypeObject--------
		
	   /*
		public function AddString(_objType:Object,_x:int,_y:int,_id:String):void 
		{
			var _str:Text = new Text(_objType);
			this.addChild(_str);
		    _str.x = _x;
			_st.y = _y;
			_str.name = _id;
			this._vecStrin.push(_str);
		}
		
		//----控制字串顯示之類的-----(override it)
		public function UseString(_id:String,_visible:Boolean):void 
		{
			var _text:Text = this.getStrHandler(_id);
			_text.visible = _visible;
			
			
		}
		
		
		private function getStrHandler(_id:String):Text 
		{
			var _text:Text;
			for (var i:* in this._vecStrin) {
				
				if (this._vecStrin[i].name==_id) {
				 _text =	this._vecStrin[i];
				return _text;
				break;	
			    }	
			}
			
		}
		*/
		
		
		//----set your displayobject planel info(you can override it)------------------
		public function SetTransFrom(_x:Number,_y:Number):void {this._objTransfrom = { x:_x, y:_y };}
		
		
		public function get closeFlag():Boolean 
		{
			return _closeFlag;
		}
		
		public function set closeFlag(value:Boolean):void 
		{
			_closeFlag = value;
		}
		
		
		//-------Layerid[get/set]---------
		public function get layerID():int {return _layerID;}
		
		public function set layerID(value:int):void {_layerID = value;}
		
		public function get guiIDName():String {return _guiIDName;}
		
		public function set guiIDName(value:String):void {_guiIDName = value;}
		
	
		//----拿變型的參數(可複寫)-----
		public function GetTransform():Object {return this._objTransfrom;}
		
		//-----override this function-----
		public function OnRegeisterGUI():void {}
		
		//----override this function-----
		public function OnRemove():void {}
		
		//---use Garbage tools[you can override this function]----
		public function Garbage():void {}
		
		//-----
		public function AddMeditor(_meditor:IFMeditorGUI):void 
		{
			this._MeditorGUI = _meditor;
		}
		
		
		public function SendMeditorGUI():void 
		{
			this._MeditorGUI.ExcuteGUI(this._guiIDName,this);
		}
		
		//---MeditorGUI 回過頭來執行的--------
		//---- you can override this function------
		public function BackExCute(...args):void 
		{
			
		}
		
	}
	
}