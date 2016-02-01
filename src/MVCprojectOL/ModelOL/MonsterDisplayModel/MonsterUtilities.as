package MVCprojectOL.ModelOL.MonsterDisplayModel {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	/**
	 * ...
	 * @author Aris
	 * @version 13.04.11.09.40
	 */
	public class MonsterUtilities {
		public static const _PublicComponentKey:String = "GUI00002_ANI";
		public static const _StampClassName:String = "DemonState";
		
		public static const _DefaultStampCondition:Vector.<String> = new < String > [ "Learn" , "Battle" , "Group" , "Exhaust" ];
		
		private static const _InnerShadowFilter:GlowFilter = new GlowFilter( 0x2a2a2a , 1 , 3 , 3 , 2 , 1 , true );
		private static const _FilterArray:Array = [ _InnerShadowFilter ];
		
		private static var _SourceProxy:SourceProxy = SourceProxy.GetInstance();
		
		/*public function MonsterUtilities() {
			
		}*/
		
		public static function AddInnerShadowFilter( _InputTarget:DisplayObjectContainer ):void {//描邊濾鏡
			//_InnerShadowFilter = new GlowFilter( 0xFF0000 );
			//_InputTarget.filters = [ MonsterUtilities._InnerShadowFilter ];
			_InputTarget.filters = MonsterUtilities._FilterArray;
			//_InputTarget.filters.push( MonsterUtilities._InnerShadowFilter );
		}
		
		public static function RemoveFilters( _InputTarget:DisplayObjectContainer ):void {//移除描邊濾鏡
			
			var _location:uint = _InputTarget.filters.lastIndexOf( MonsterUtilities._InnerShadowFilter );
			_location != -1 ? _InputTarget.filters.splice( _location , 1 ) : null;
			
		}
		
		public static function AddBodyShadow( _InputTarget:Sprite ):void {//身體陰影
			/*var _sp:Shape = new Shape();
				_sp.graphics.beginFill(0x333333);
				_sp.graphics.drawEllipse( 0 , 0 , 120 , 20 );
				_sp.graphics.endFill();
				_sp.name = "BodyShadow";
				_sp.x = 70;
				_sp.y = 160;
				_sp.alpha = 0.6;
				
			_InputTarget.addChild( _sp );*/
			
			/*var type:String = GradientType.RADIAL; 
			var colors:Array = [0x333333, 0xFF0000]; 
			var alphas:Array = [1, 0.4]; 
			var ratios:Array = [0, 255]; 
			var spreadMethod:String = SpreadMethod.PAD; 
			var interp:String = InterpolationMethod.LINEAR_RGB; 
			var focalPtRatio:Number = 0; 
			 
			var matrix:Matrix = new Matrix(); 
			var boxWidth:Number = 50; 
			var boxHeight:Number = 100; 
			var boxRotation:Number = Math.PI/2; // 90° 
			var tx:Number = 0; 
			var ty:Number = 0; 
			matrix.createGradientBox(boxWidth, boxHeight, boxRotation, tx, ty); 
			 
			var _Shadow:Shape = new Shape; 
				_Shadow.graphics.beginGradientFill(type ,  
												colors , 
												alphas , 
												ratios ,  
												matrix ,  
												spreadMethod ,  
												interp ,  
												focalPtRatio); 
				_Shadow.graphics.drawEllipse(0, 0, 120, 120); 
				
				_Shadow.name = "BodyShadow";
				_Shadow.x = 70;
				_Shadow.y = 160;
				//_Shadow.alpha = 0.6;
				
			_InputTarget.addChild( _Shadow );*/
				
			var _Shadow:Sprite = new ( MonsterUtilities._SourceProxy.GetMaterialSWP( "GUI00002_ANI" , "MonsterShadow" ) );
				_Shadow.name = "BodyShadow";
				_Shadow.x = 0;
				_Shadow.y = 120;
			//_InputTarget.addChild( _Shadow );
			_InputTarget.addChildAt( _Shadow , 0 );
		}
		
		public static function RemoveBodyShadow( _InputTarget:Sprite ):void {//身體陰影
			var _sp:DisplayObject = _InputTarget.getChildByName( "BodyShadow" );
			if ( _sp != null ) {
				_InputTarget.removeChild( _sp );
			}
			
		}
		
		
	}//end class
}//end package