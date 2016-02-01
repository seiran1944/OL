package Spark.MVCs.Models.SourceTools.Material
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @Engine :SparkEngine beta 1
	 * @author :JerryKai
	 * @version :2012.07.30
	 * @Explain:ImageProcessing 動畫處理工具
	 * @playerVersion:11.0
	 * 
	  * @Modifier : K.J. Aris
	 * @version : 2013.01.02
	 */
	
	
	public class ImageProcessing
	{
		//存取切割好的影像群組
		//private var _groupArr:Array = [];
		
		//動畫影像拆解存成BitmapData
		public function GetMovieClipHandler( _InputMc:MovieClip , _InputHorizontalReverse:Boolean = false ):Array 
		{
			//var _mc:MovieClip = MovieClip( _InputMc.getChildAt(0) );
			var _totalFrames:int = _InputMc.totalFrames;
			var _width:Number = _InputMc.width;
			var _height:Number = _InputMc.height;
			var _McArr:Array = [];
				
			_InputMc.stop();
			
			//trace("動畫長度: " + _totalFrames );
			
			for (var i:int = 1; i <= _totalFrames; i++ ) 
			{
				_InputMc.gotoAndStop(i);
				
				var _bmd:BitmapData = new BitmapData( _width , _height , true , 0x000000); 
					_bmd.draw( _InputMc );
					
					_bmd = ( _InputHorizontalReverse == true ) ? this.ReverseBitmapData( _bmd ) : _bmd;//121204 K.J. Aris
				_McArr.push( _bmd );
				
			}
			//trace("動畫陣列: " + _McArr.length);
			return _McArr;
		}
		
		//BitmapData影像截取
		public function CutImgaeHandler( _Bmd:BitmapData, _Width:uint, _Height:uint ):Array 
		{
			var _wi:uint = Math.floor (_Bmd.width / _Width);
			var _hi:uint = Math.floor (_Bmd.height / _Height);
			
			//this._groupArr = [];
			var arr:Array = [];
            for (var i:uint = 0; i < _wi; i++ )
			{
                
               
				for (var j:uint = 0; j < _hi; j++ )
				{
                    var bmp:BitmapData = new BitmapData ( _Width , _Height , true , 0x00FFFFFF );
                    var _rect:Rectangle = new Rectangle ( _Width * i , _Height * j , _Width , _Height );
                    bmp.copyPixels ( _Bmd , _rect , new Point ( 0 , 0 ) );
                    arr.push ( bmp );
                }
				
				//this._groupArr.push( arr );
            }
			
			return arr;
		}
		
		//取得BitmapData截取處理後的影像
		/*public function GetCutImageGroup( _Count:uint , _length:uint ):Array 
		{
			var _DataPlay:Array = [];
			
			for (var i:uint = 0; i < _length; i++ )
			{
				_DataPlay.push( this._groupArr[ _Count ][ i ] );
			}
			
			return _DataPlay;
		}*/
		
		
		
		//靜態圖片翻轉功能
		public function RotationImg( _InputBmp:Bitmap , _InBoolean:Boolean ):BitmapData 
		{
			var _myBmd:BitmapData = new BitmapData( _InputBmp.width , _InputBmp.height , true , 0x000000 );
				
			var _matrix:Matrix = new Matrix();
			
			_InputBmp.smoothing = true;
			
			//預設水平翻轉
			if ( _InBoolean == true )
			{
				_matrix.a = -1;
				_matrix.tx = _InputBmp.width;	
			}else {
				_matrix.d = -1;
				_matrix.ty = _InputBmp.height;
			}			
				_myBmd.draw( _InputBmp , _matrix );
			
			return _myBmd;
		}
		
		public function ReverseBitmapData( _InputBmpData:BitmapData ):BitmapData {
			var _ReversedBitmapData:BitmapData = new BitmapData( _InputBmpData.width , _InputBmpData.height , true , 0x000000 );
			var _matrix:Matrix = new Matrix();
				_matrix.a = -1;
				_matrix.tx = _InputBmpData.width;
				
			_ReversedBitmapData.draw( _InputBmpData , _matrix );
			
			return _ReversedBitmapData;
			
		}
		
		
		//縮放圖片大小
		public function ScaleImg( _target:DisplayObject , _tarW:int , _tarH:int ):BitmapData {
			
			var _rect:Rectangle = _target.getBounds(_target);
			var _ScaleX:Number = _tarW / _rect.width;
			var _ScaleY:Number = _tarH / _rect.height;
			var _myBmd:BitmapData = new BitmapData(_tarW, _tarH, true, 0x000000);
			var _matrix:Matrix = new Matrix();
				_matrix.scale( _ScaleX , _ScaleY );
				_myBmd.draw(_target, _matrix);
			//trace("放大圖像: " + _myBmd );
			return _myBmd;
		}
		
		//變型後畫上容器
		public function DrawSprite( _InputBmd:BitmapData ):Sprite 
		{
			var _mySprite:Sprite = new Sprite();
				_mySprite.graphics.beginBitmapFill( _InputBmd );
				_mySprite.graphics.drawRect( 0 , 0 , _InputBmd.width , _InputBmd.height );
				_mySprite.graphics.endFill();
				
			return _mySprite;
		}
		
		
	}//end class
}//end package