package MVCprojectOL.ModelOL.TipsCenter.Basic 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import Spark.Utils.Text;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class SkillPic extends Sprite
	{
		
		private var _arySkillPIC:Array;
		private const _arySkillStr:Array = ["ATTACK", "GUARD", "GAIN", "DEBUFF", "DOT", "RECOVERY", "CONTROL"];
        private var _picItem:Bitmap;
		private var _textShow:Text
		private var _DisplayObjectContainer:DisplayObjectContainer;
		public function SkillPic(_ary:Array,_dis:DisplayObjectContainer) 
		{
			if (_ary != null) this._arySkillPIC = _ary;
			this._DisplayObjectContainer = _dis;
			this._DisplayObjectContainer.addChild(this);
		}
		
		public function SetView(_index:int):void 
		{
			if (this._picItem == null) {
				this._picItem = new Bitmap();
				this.addChild(this._picItem);
				this._picItem.x= 90;
				this._picItem .y = 40;
			}
			this._picItem.bitmapData = this._arySkillPIC[_index-1];
			if (this._textShow == null) {
				this._textShow = new Text({_str:"",_wid:286,_hei:20,_wap:false,_AutoSize:"LEFT",_col:0xffffff,_Size:12,_bold:true});
				this.addChild(this._textShow);
				this._textShow.x = (this._picItem.x + this._picItem.width) + 10;
				this._textShow.y = 42;
			}
			this._textShow.ReSetString(this._arySkillStr[_index-1]);
			
		}
		
		
		public function Remove():void 
		{
			while (this.numChildren>0) {
				this.removeChildAt(0);
			}
			this._DisplayObjectContainer.removeChild(this);
			this._picItem = null;
			this._textShow = null;
		}
		
	}
	
}