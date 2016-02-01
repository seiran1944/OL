package Spark.MVCs.Models{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import Spark.MVCs.Models.BarTool.BarProxy;
	
	import flash.utils.Dictionary;
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	
	/**
	 * ...
	 * @author EricHuang
	 * 11/2
	 * ----bar創建工具-----
	 * proxyName=CommandsStrLad.SorceBar_Proxy
	 * 採用proxy的方式包裝
	 */
	public class BarBasic extends ProxY
	{
		
		//private var _BarName:String = "";
		
		private var _color:uint;
		
		private var _barBitmap:Bitmap;
		//private var _dicBar:Dictionary;
		
		//private static var _getSourceBar:BarBasic;
		public function BarBasic () 
		{
		   	//if (_getSourceBar != null) trace("[BarBasic] build illegal!!!please,use [Singleton]");
			super(CommandsStrLad.SorceBar_Proxy,this);
			//this._dicBar = new Dictionary(true);
			//this._color = _Color;
			//this.creatBarHandler(_max,_nowMin,_class,_double);
		}
		
		/*
		public static function GetSourceBar():BarBasic
		{
			trace("BarBasic_init");
			if (BarBasic._getSourceBar == null) BarBasic._getSourceBar = new BarBasic();
			return BarBasic._getSourceBar;
		}
		*/
		
		//------_max>最大值/_nowMin>當前值/_class>class/_double>是否劃兩層	
		
		public function GetBar(_max:int,
		_min:int,
		_width:int,
		_height:int,
		_double:Boolean = false,
		_Color:uint = 0x89FF19,
		_groupName:String = "",
		_name:String = "",
		_class:Class = null,
		//----是否需要註冊阿翔那邊的bar控制器
		//_Gradient:Boolean = false,
		_co1Double:uint = 0,
		_colDoubleClass:Class=null):DisplayObject
		{
			var _bitmap:DisplayObject;
			this._color = _Color;
			//----是否需要註冊阿翔那邊的bar控制器
			_bitmap = (_double == false)?DisplayObject(this.CheckBarVauleHandler(_max, _min, _width, _height, _class)):
			DisplayObject(this.creatDoubleHandler(_max, _min, _width, _height,_class,_co1Double,_colDoubleClass));
			if (_groupName!="" && _name!="") {
				//_double=false>>單層的情況
			    //var _pic:DisplayObjectContainer = DisplayObjectContainer(_bitmap);
				var _registerBp:DisplayObject = (_double==false)?_bitmap:DisplayObject(DisplayObjectContainer(_bitmap).getChildAt(1));
				BarProxy.GetInstance().RegisterGroup(_groupName).AddBar(_name,_registerBp,_min, _max,true,.008);
				//if(_groupName!="")BarProxy.GetInstance().RegisterGroup(_groupName).AddBar(_name, DisplayObject(_bitmap),_min, _max);
				
			}
			
			return _bitmap;
		}
		
		//--雙層特殊樣式---(且需要註冊)(原尺寸)
		public function CreatSpBar(_max:int, _min:int,_barClass:Class,_bgClass:Class,_groupName:String,_name:String,_indexX:Number=-99,_indexY:Number=-99): DisplayObject
		{
			var _doubleSpr:Sprite = new Sprite();
			var _barBitmap:Bitmap = new Bitmap(new _barClass());
			var _bgPic:Bitmap = new Bitmap(new _bgClass());
			_doubleSpr.addChild(_bgPic);
			_doubleSpr.addChild(_barBitmap);
			if (_indexX!=-99 && _indexY!=-99) {
			    _barBitmap.x = _indexX;
			    _barBitmap.y = _indexY;
				
				} else {
				
				_barBitmap.x = _bgPic.width - _barBitmap.width >> 1;
				_barBitmap.y = _bgPic.height - _barBitmap.height >> 1;
				
			}
			
			BarProxy.GetInstance().RegisterGroup(_groupName).AddBar(_name,_barBitmap,_min,_max,true,.008);
			
	        return _doubleSpr;
		}
		
	
		private function creatDoubleHandler(_max:int, _min:int, _width:int, _hei:int, _class:Class, _bgCol:uint = 0,_bgClass:Class=null):Sprite 
		{
			var _doubleSpr:Sprite = new Sprite();
			var _basicBar:Bitmap = this.CheckBarVauleHandler(_max, _min, _width, _hei, _class);
			//if (_bgCol != 0) 
			this._color = _bgCol;
			var _barBackGround:Bitmap = this.CheckBarVauleHandler(_max,_min,_width+4, _hei+4, _bgClass);
			_doubleSpr.addChild(_barBackGround);
			_doubleSpr.addChild(_basicBar);
			_basicBar.x = _basicBar.y = 2;
			
			return _doubleSpr;
		}
		
		//---9公格~且不註冊
		public function GetScaleDoubleBar(_width:int,_sw:int,_class:Class,_bg:Class,_sideX:int=4,_sideY:int=4):DisplayObject 
		{
			
			var bar:Sprite = new _class();
			var _barMC:Sprite = new Sprite();
			_barMC.addChild(bar);
			bar.width = _sw;
			//bar.height = _sh;
			var _bitmapBar:BitmapData = new BitmapData(_barMC.width, _barMC.height, true,0);
			_bitmapBar.draw(_barMC);
			var _bar:Bitmap = new Bitmap(_bitmapBar.clone());
			_barMC.removeChild(bar);
			bar = null;
		    
			//================================================
			
			var barBG:Sprite = new _bg();
			_barMC.addChild(barBG);
			barBG.width = _width;
			//barBG.height = _height;
			var _bitmapBarBG:BitmapData = new BitmapData(_barMC.width, _barMC.height, true,0);
			_bitmapBarBG.draw(_barMC);
			var _barBG:Bitmap = new Bitmap(_bitmapBarBG.clone());
			_barMC.removeChild(barBG);
			barBG = null;
			
			var _sprDouble:Sprite = new Sprite();
			_sprDouble.addChild(_barBG);
			_sprDouble.addChild(_bar);
			_bar.x = _barBG.width-_bar.width>>1;
			_bar.y= _barBG.height-_bar.height>>1;
			
			
			return _sprDouble;
		}
		
		
		
		private function CheckBarVauleHandler(_max:int,_min:int,_width:int,_hei:int,_class:Class):Bitmap 
		{
			
			if(_min > _max) {
			
			    throw Error("Bar 創造不合法_最小值大於最大值");
				return;
			    //---回送錯誤訊息*----
			   }else {
				var _bitmap:Bitmap;
				if (_class == null) { 
					
					//----註冊(去阿翔的工具那邊註冊)
					_bitmap = new Bitmap(new BitmapData(_width,_hei,false,this._color));
						
					} else {
					//---實體化之後再畫一次
					var _target:Bitmap = new Bitmap( new (_class));
					var _rect:Rectangle = _target.getBounds(_target);
					var _scaleX:Number = _width / _rect.width;
					var _scaleY:Number = _hei / _rect.height;
					var _bitmapData:BitmapData = new BitmapData(_width,_hei,true,0);
					//_bitmap= new Bitmap(_bitmapData.clone());
					var _matrix:Matrix = new Matrix();
					_matrix.scale( _scaleX , _scaleY );
					_bitmapData.draw(_target, _matrix);
					_bitmap = new Bitmap(_bitmapData);
					
				}
				
				return _bitmap;
			}
			
			
		}
		
		
	
	
	}
	
}