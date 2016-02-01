package MVCprojectOL.ViewOL.SharedMethods 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import Spark.Utils.Text;
	/**
	 * ...
	 * @author brook
	 */
	public class AtkNineGrid extends Sprite
	{
		
		public function AtkNineGrid() 
		{
			var _Ground:Shape = this.DrawRect(0x000000, 0, 0, 64, 64);
			this.addChild(_Ground);
			
			var _TextObj:Object = { _str:"", _wid:10, _hei:10, _wap:false, _AutoSize:"CENTER", _col:0x000000, _Size:10, _bold:true, _font:"Times New Roman", _leading:null };
			var _Text:Text;
			for (var i:int = 0; i < 9; i++) 
			{
				_Ground = this.DrawRect(0xFFFFFF, 0, 0, 20, 20);
				_Ground.x = 1 + int(i / 3 ) * 21;
				_Ground.y = 1 + i % 3  * 21;
				_Ground.alpha = 1;
				_Ground.name = "" + i;
				this.addChild(_Ground);
				
				_TextObj._str = _Ground.name;
				_Text = new Text(_TextObj);
				_Text.x = 6+ int(i / 3 ) * 21;
				_Text.y = 1 + i % 3  * 21;
				this.addChild(_Text);
			}
		}
		//輸入範圍
		public function SetRange(_InputAry:Array):void
		{
			var _RangeBox:Shape;
			for (var i:int = 0; i < _InputAry.length; i++) 
			{
				if (_InputAry[i] == this.getChildByName("" + _InputAry[i]).name)
				{
					_RangeBox = this.DrawRect(0xFF0000, 0, 0, 20, 20);
					_RangeBox.x = this.getChildByName("" + _InputAry[i]).x;
					_RangeBox.y = this.getChildByName("" + _InputAry[i]).y;
					_RangeBox.alpha = 0.5;
					this.addChild(_RangeBox);
				}
			}
		}
		//移除
		public function onRemove():void 
		{
			while (this.numChildren>0) 
			{
				this.removeChildAt(0);
			}
		}
		
		private function DrawRect(_Color:int,_LocationX:int, _LocationY:int, _Width:int, _Height:int):Shape 
		{
			var _sp:Shape = new Shape ();
				_sp.graphics.beginFill(_Color);
				_sp.graphics.drawRect(_LocationX,_LocationY,_Width,_Height);
			return _sp;
		}
		
	}
}