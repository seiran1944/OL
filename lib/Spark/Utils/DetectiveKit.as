package Spark.Utils
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	import Spark.Utils.GlobalEvent.EventExpress;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.08.08.17.17
		@documentation 針對FPS的變化作記錄圖示 , 並當FPS進入 '節流狀態' 或是 '回復正常' 狀態時 發送通知
	 */
	public class DetectiveKit extends Sprite
	{
		public static const EVENT_NOTIFY:String = "freezeNotify";					//接收註冊名稱
		public static const STATUS_FREEZE:String = "statusFreeze";					//節流狀態
		public static const STATUS_UNFREEZE:String = "statusUnfreeze";		//一般狀態
		protected var _showInfo:ShowInfo;
		protected var _fps:int;
		protected var _ms:int;
		protected var _preMs:int;
		protected var _freezeLimit:int;
		protected var _freeze:String = "statusUnfreeze";
		
		
		/**
		 * 需註冊事件DetectiveKit.EVENT_NOTIFY , 變更狀態下會發出DetectiveKit.STATUS_FREEZE / STATUS_UNFREEZE 
		 * @param	freezeLimit 低於此FPS之下會發出通知訊號
		 * @param	backColor 背景顏色設定
		 * @param	dotColor 標記點顏色設定
		 */
		public function DetectiveKit(freezeLimit:int=5):void
		{
			this._freezeLimit = freezeLimit;
			
		}
		
		/**
		 * 起始運行
		 * @param	show 是否開啟顯示
		 * @param	backColor 背景顏色
		 * @param	dotColor 點示顏色
		 */
		public function Start(show:Boolean=false,backColor:uint=0,dotColor:uint=0xFFFF00):void
		{
			
			if (show) {
				if(this._showInfo==null) this._showInfo = new ShowInfo(backColor, dotColor);
				this.graphics.beginFill(backColor);
				this.graphics.drawRect(0, 0, this._showInfo.WIDTH, this._showInfo.HEIGHT);
				this.graphics.endFill();
				addChild(this._showInfo);
				this._showInfo.Show();
			}else {
				this._showInfo = null;
			}
			
			this._preMs = getTimer();
			addEventListener(Event.ENTER_FRAME, running);
			
		}
		
		/**
		 * 停止運行
		 */
		public function Stop():void 
		{
			if (this._showInfo != null) {
				this.graphics.clear();
				removeChild(this._showInfo);
				this._showInfo.Stop();
			}
			removeEventListener(Event.ENTER_FRAME, running);
			
		}
		
		/**
		 * 註銷工具
		 */
		public function Destroy():void 
		{
			if (hasEventListener(Event.ENTER_FRAME)) {
				this.Stop();
			}
			
			if (this._showInfo != null) {
				this._showInfo.Destroy();
			}
		}
		
		/**
		 * 取得當前FPS值
		 */
		public function get FPS():int 
		{
			return this._fps;
		}
		
		
		//運行偵測
		private function running(e:Event):void
		{
			this._fps++;
			this._ms = getTimer();
			
			if (this._ms - 1000  >= this._preMs ) {
				this._preMs = getTimer();
				
				if(this._showInfo!=null) this._showInfo.updateShow(this._fps);
				
				this.freezeNotify(this._fps < this._freezeLimit ? DetectiveKit.STATUS_FREEZE : DetectiveKit.STATUS_UNFREEZE);
				this._fps = 0;
			}
		}
		
		//發送通知
		private function freezeNotify(status:String):void 
		{
			if (this._freeze != status) {
				EventExpress.DispatchGlobalEvent(DetectiveKit.EVENT_NOTIFY, status, null, "DetectiveKit");
				this._freeze = status;
			}
		}
		
		
		
	}
	
}
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFormat;

class ShowInfo extends Sprite
{
	public const WIDTH:int = 100;	//顯示寬
	public const HEIGHT:int = 50;	//顯示高
	public var _bgcolor:uint;
	public var _dotColor:uint;
	public var _retDraw:Rectangle;
	public var _txtShow:TextField;
	public var _bmChart:Bitmap;
	
	public function ShowInfo(bgColor:uint,dotColor:uint):void 
	{
		this._bgcolor = bgColor;
		this._dotColor = dotColor;
		this.SetMap();
		this.SetTangle();
		this.SetTxt();
	}
	
	public function SetMap():void 
	{
		this._bmChart = new Bitmap();
		this._bmChart.y = this.HEIGHT * .5;
		this._bmChart.bitmapData = new BitmapData(this.WIDTH, this.HEIGHT *.5, false, this._bgcolor);
	}
	
	public function SetTxt():void 
	{
		this._txtShow = new TextField();
		this._txtShow.width = this.WIDTH;
		this._txtShow.height = 30;
		this._txtShow.selectable = false;
		this._txtShow.mouseEnabled = false;
		this._txtShow.defaultTextFormat = new TextFormat("Tahoma", 14, 0x00FF00, true);
		this._txtShow.text = "FPS : " ;
	}
	
	public function SetTangle():void 
	{
		this._retDraw = new Rectangle(this.WIDTH - 1, 0, 1, this.HEIGHT * .5 );
	}
	
	public function updateShow(fps:int):void 
	{
		var value:Number = fps / stage.frameRate;
		value = (value > 1 ? 1 : value) * this._bmChart.height;
		this._bmChart.bitmapData.scroll( -1, 0 );
		this._bmChart.bitmapData.fillRect( this._retDraw , this._bgcolor );
		this._bmChart.bitmapData.setPixel( this._bmChart.width - 1, this._bmChart.height - value, this._dotColor);
		this._txtShow.text = "FPS : " + fps +"/" + stage.frameRate;
	}
	
	public function Show():void 
	{
		addChild(this._txtShow);
		addChild(this._bmChart);
	}
	
	
	public function Stop():void 
	{
		removeChild(this._bmChart);
		removeChild(this._txtShow);
		
	}
	//移除時處理
	public function Destroy():void
	{
		this._bmChart.bitmapData.dispose();
		this._bmChart.bitmapData = null;
		this._txtShow = null;
		this._retDraw = null;
		
	}
	
}