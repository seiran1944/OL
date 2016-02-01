package Spark.Utils
{
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @Engine SparkEngine beta 1
	 * @author EricHuang
	 * @version 2012.05.28
	 * @param 本class用於文字處理工具
	 */
	public class Text extends TextField {
		
		/*
		 * ----object屬性表-----
		 * _str[顯示字串]string
		 * _wid[寬]int
		 * _hei[高]int
		 * _wap[自動換行]boolean
		 * _AutoSize[對齊方式]String-->CENTER/LEFT
		 * _col[顏色]--uint
		 * _Size[自體大小]--int
		 * _bold[粗細]--boolean
		 * _font[自型]
		 * _leading
		*/
		
		
	    private var _style:TextFormat;
		private var _aryStyle:Array;
		public function Text(_object:Object) {
			this._aryStyle = [];
			this.mouseEnabled = false;
			this.type = TextFieldType.DYNAMIC;
			//this.background = true;
			//this.backgroundColor = 0xFFBFFF;
			
			if(_object._str!=null)this.text = _object._str;
			if(_object._wid!=null)this.width= _object._wid;
			if(_object._hei!=null)this.height =_object._hei;
			this.wordWrap=(_object._wap != null)?_object._wap:false;
			if (_object._AutoSize!=null) {
				this.autoSize = (_object._AutoSize=="CENTER")?TextFieldAutoSize.CENTER:TextFieldAutoSize.LEFT;
				} else {
				this.autoSize = TextFieldAutoSize.LEFT;
			}
			
			//this.background = true;
			//this.backgroundColor = 0xffffff;
			
			this._style= new TextFormat();
			if (_object._col != null)_style.color = _object._col;
			if (_object._Size != null)_style.size = _object._Size;
			if (_object._bold != null)_style.bold = _object._bold;
			if (_object._font != null)_style.font = _object._font;
			if (_object._leading != null)_style.leading = _object._leading;
			this.setTextFormat(_style);
		}
		
		
				
		//---reset text info----
		public function ReSetString(str:String,_swichColor:Boolean=false):void {
			this.text = str;
			this.setTextFormat(this._style);
			if (_swichColor==true) {
				var _index:int = -1;
				var _checkIndex:int = -1;
				var _checkStr:String = "";
				if (this.text.indexOf("+")!=-1) {
					_checkIndex = this.text.indexOf("+");
					_index = 0;
					} else if(this.text.indexOf("-")!=-1){
					_checkIndex=this.text.indexOf("-");
					_index = 1;
				}
				
				if (_checkIndex!=-1) {
				    //var _varTest:String = this.text;
					//var _testStr:String =_varTest.charAt(_checkIndex + 2);
				   this.setTextFormat(this._aryStyle[_index],_checkIndex,this.text.length);	
				}
				
				
			}
			
		}
		
		
		public function SetStyle(_style:TextFormat):void 
		{
			this._aryStyle.push(_style);
		}
		
		
		/*
		public function GetHeight():Number {return  this.textHeight;}
		
		public function GetWidth():Number { return this.textWidth; };
		*/
		
		//--重設字體組態---<視情況添加>
		/*
		public function ResetStatus():void {
			
		}*/
		
		
	}
	
}