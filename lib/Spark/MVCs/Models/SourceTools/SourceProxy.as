package Spark.MVCs.Models.SourceTools
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.utils.Dictionary;
	import Spark.MVCs.Models.SourceTools.SourceEvt.SourceEvent;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import Spark.MVCs.Models.SourceTools.SourceTool;
	import Spark.coreFrameWork.Interface.IfNotify;
	import Spark.coreFrameWork.Interface.IfProxy;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.CommandsStrLad;
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	
	import Spark.MVCs.Models.SourceTools.Loader.LoadingBar;
	
	/**
	 * ...
	 * @Engine :SparkEngine beta 1
	 * @author :JerryKai
	 * @version :2012.10.31
	 * @Explain:SourceSystem 資源工具===>最上一層封裝
	 * @playerVersion:11.0
	 * 
	 * @Modifier :K.J. Aris
	 * @version :2012.12.04
	 */
	
	
	public class SourceProxy extends ProxY implements IfProxy,IfNotify
	{
		private static var _SourceProxy:SourceProxy;
		private var _SourceTool:SourceTool;
		
		private var _isReady:Dictionary;//121127
		
		public static function GetInstance():SourceProxy {
			return ( SourceProxy._SourceProxy == null ) ? new SourceProxy() : SourceProxy._SourceProxy;
		}
		
		public function SourceProxy(){
			SourceProxy._SourceProxy = this;
			super( CommandsStrLad.SourceSystem , this );
			this._isReady = new Dictionary();//121127
			trace("SourceProxy_init");
		}
		
		
		//==============================初始SourceTool工具=======================================
		public function InitSourceTool( _domain:String ):void {
			
			this._SourceTool = new SourceTool();
			EventExpress.AddEventRequest( SourceEvent.LoadToolEvt , this.LoadCompleteEvent , "SourceProxy" );
			this._SourceTool.InitSourceTool( _domain );
		}
		
		//==============================接收SourceTool事件=======================================
		private function LoadCompleteEvent( Evt:EventExpressPackage ):void //SourceTool事件流處理
		{	
			//載好回傳的key碼
			var _KeyCode:String;
			//載入的進度( 這裡指的是素材佔的總數量進度，不是單筆的進度 )
			var _Progress:uint; 
			//把所有素材資訊包裝後send出
			var _Obj:Object;
				
			
			switch( (Evt.Status)as String )
			{
				//素材載入完成
				case"MaterialComplete":
					
					_KeyCode = String( Evt.Content );
					_Progress = this.GetLoadProgress();
					_Obj = new Object();
					_Obj._KeyCode = _KeyCode;
					_Obj._Progress = _Progress;
					//trace("SendNotify!!" , "完成的KeyCode :" , _Obj._KeyCode , "    目前總進度: " , _Obj._Progress );
					this._isReady[ _KeyCode ] = true;//標註素材已完成121127
					EventExpress.DispatchGlobalEvent( CommandsStrLad.Source_Complete , _KeyCode , _Progress , this , false );
					this.SendNotify( CommandsStrLad.Source_Complete , _Obj );   //要更新Spark CommandsStrLad		
					break;
				
				//素材中斷載入
				case"MaterialInterrupt":
					
					//trace("被中斷的人: " , Evt.Content );
					//被中斷後移除素材註冊人員
					this._SourceTool.RemoveMaterailComponent( String( Evt.Content ) );
					
					break;
			}
		}
		
		
		//==============================素材載入系統==============================================
		//-------直接預載素材方法-----------( 注意使用:給了後面參數設定是中斷前一筆載入的動作 )
		//如果_Interrupt給true會發生中斷上一筆載入動作，然後進行當前給的素材清單載入
		
		/*public function PreloadMaterial( _InputKey:* , _Interrupt:Boolean = false ):Boolean //修改日期:20121113
		{
			( _Interrupt == true ) ? this._SourceTool.LoadInterrupt() : null;
			return this._SourceTool.PreloadMaterial( _InputKey );
		}*/
		public function PreloadMaterial( _InputKey:*  ):Boolean{ //修改日期:2012.11.27
			//( _Interrupt == true ) ? this._SourceTool.LoadInterrupt() : null;
			var _Check:Boolean = false
			if ( _InputKey is Array ) {
				for ( var i:uint = 0 ; i < _InputKey.length ; i++ ) {
					_Check = this.CheckExistOrLoad( _InputKey[ i ] );
				}
			}else {
				_Check = this.CheckExistOrLoad( _InputKey );
			}
			
			return _Check;
		}
		
		private function CheckExistOrLoad( _InputKey:String ):Boolean {
			if ( this._isReady[ _InputKey ] == null ) {
				this._isReady[ _InputKey ] = false;
				this._SourceTool.PreloadMaterial( _InputKey );
			}
			return this._isReady[ _InputKey ];
		}
		
		
		//-------中斷載入方法-------
		public function LoadInterrupt():void 
		{
			this._SourceTool.LoadInterrupt();
		}			
		//-------取得素材進度-------
		public function GetLoadProgress():uint 
		{
			return this._SourceTool.GetLoadProgress();
		}
		//-------拆解swf的class工具---
		public function GetDismantleSwf( _InputClassNameList:Vector.<String> ):Object
		{
			return this._SourceTool.DismantleSwpList( _InputClassNameList );
		}
		
		//==============================素材管理系統==============================================		
		//**************重點是使用者要知道想取得元件型態，不要耍白木亂使用方法，不然程式會爆給你看!!***********
		
		
		//--------------檢查素材庫裡是否有元件存在---------------   修改日期:20121113
		public function CheckMaterialDepot( _InputKeyCode:String ):Boolean 
		{
			return this._SourceTool.CheckMaterialDepot( _InputKeyCode ) && ( this._isReady[ _InputKeyCode ] == null ? false : this._isReady[ _InputKeyCode ] ) ;//121128 K.J. Aris
		}
		
		//--------------取得LoadingBar---------------   修改日期:20121115
		public function GetLoadingMark():Class {
			return LoadingBar;
		}
		
		//--------------取得靜態圖實體物件-----------------------
		public function GetImageSprite( _keyValue:String ):* 
		{
			return this._SourceTool.GetImageSprite( _keyValue );
		}
		
		//--------------取得靜態圖非實體物件--(因為第一次拿到LoadingBar是實體，第二次才取得BitmapData，所以才會使用任意型別回傳)
		public function GetImageBitmapData( _keyValue:String ):* 
		{
			return this._SourceTool.GetImageBitmapData( _keyValue );
		}
		
		//--------------取得SWF素材物件-------(回傳MovieClip)
		public function GetMaterialSWF( _keyValue:String ):MovieClip
		{
			return this._SourceTool.GetMaterialSWF( _keyValue );
		}
		
		//--------------取得SWP素材物件-------(注意使用:第三個參數是控制要不要實體化回傳，true實體化、false非實體化)
		//===========================>( 素材key碼 ， class名稱--可給一個或整張清單className ， 控制實體化開關 )
		public function GetMaterialSWP( _keyValue:String , _InputClassNameList:* , _NewComponent:Boolean = false ):* 
		{
			return this._SourceTool.GetMaterialSWP( _keyValue , _InputClassNameList , _NewComponent );
		}
		
		//--------------取得Sound載體-----------------------------
		public function GetMaterialSound( _keyValue:String ):Sound 
		{
			return this._SourceTool.GetMaterialSound( _keyValue );
		}
		
		
		//==============================影像處理系統==============================================
		//動畫影像拆解處理(回傳Array)裝的是BitmapData
		public function GetMovieClipHandler( _InputMc:MovieClip , _InputHorizontalReverse:Boolean = false , _InputKey:String = null ):Array 
		{
			return this._SourceTool.GetMovieClipHandler( _InputMc , _InputHorizontalReverse , _InputKey ) as Array;
		}
		
		//-----------靜態影像處理---------------
		//圖像截取功能(回傳BitMapData Array)
		public function CutImgaeHandler( _Bmd:BitmapData, _Width:uint, _Height:uint , _InputKey:String = null ):Array 
		{
			return this._SourceTool.CutImgaeHandler( _Bmd , _Width , _Height , _InputKey );
		}
		
		//---2013/05/27----ericHuang--
		public function  GetCutImageGroup(_InputKey:String):Array 
		{
			return this._SourceTool.GetSerialImage(_InputKey);
		}
		
		//取得截取的影像群組
		/*public function GetCutImageGroup( _Count:uint , _length:uint ):Array 
		{
			return this._SourceTool.GetCutImageGroup( _Count , _length );
		}*/
		
		
		//翻轉功能(回傳裝的是BitmapData)
		public function RotationImg( _InputBmp:Bitmap , _InBoolean:Boolean ):BitmapData 
		{
			return this._SourceTool.RotationImg( _InputBmp , _InBoolean );
		}
		
		//縮放功能(回傳裝的是BitmapData)
		public function ScaleImg( _target:DisplayObject , _tarW:int , _tarH:int ):BitmapData 
		{
			return this._SourceTool.ScaleImg( _target , _tarW , _tarH );
		}
		
		//畫圖功能(回傳Sprite)
		public function DrawSprite( _InputBmd:BitmapData ):Sprite 
		{
			return this._SourceTool.DrawSprite( _InputBmd );
		}
		
		
		
		
	}//end class
}//end package