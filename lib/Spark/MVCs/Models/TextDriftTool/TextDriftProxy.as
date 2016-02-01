package Spark.MVCs.Models.TextDriftTool
{
	import flash.utils.Dictionary;
	import Spark.CommandsStrLad;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.11.08.10.23
		@documentation 數字躍動工具
	 */
	public class TextDriftProxy extends ProxY
	{
		
		private var _textCtrl:TextDriftControl;
		private static var _textDriftProxy:TextDriftProxy;
		
		public function TextDriftProxy(name:String,key:TextDriftKey):void 
		{
			super(name, this);
			if (TextDriftProxy._textDriftProxy != null || key == null) throw new Error("'MathDrift' can't be construct");
			TextDriftProxy._textDriftProxy = this;
			this._textCtrl = new TextDriftControl();
		}
		
		public static function GetInstance():TextDriftProxy
		{
			if (TextDriftProxy._textDriftProxy == null) TextDriftProxy._textDriftProxy = new TextDriftProxy(CommandsStrLad.TEXTDRIFT_SYSTEM, new TextDriftKey());
			return TextDriftProxy._textDriftProxy;
		}
		
		/**
		 * 註冊群組名稱取得文字框調用槽
		 * @param	name 自定義群組名稱
		 */
		public function RegisterTextPool(name:String):TextDriftPool
		{
			return this._textCtrl.InDriftPool(name);
		}
		
		/**
		 * 移除群組註冊,並會釋放所有文字框關聯 ( 整群移除 )
		 * @param	name 已註冊的自定義名稱
		 */
		public function ReleaseTextPool(name:String):void 
		{
			this._textCtrl.OutDriftPool(name);
		}
		
		/**
		 * 取得已註冊的群組
		 * @param	name 已註冊的自定義名稱
		 */
		public function GetTextPool(name:String):TextDriftPool
		{
			return this._textCtrl.GetDriftPool(name);
		}
		
		
		
	}
	
}

class TextDriftKey 
{
	
}