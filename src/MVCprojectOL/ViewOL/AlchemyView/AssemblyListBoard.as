package MVCprojectOL.ViewOL.AlchemyView 
{
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import MVCprojectOL.ViewOL.SharedMethods.TipsView;
	import Spark.Utils.Text;
	/**
	 * ...
	 * @author brook
	 */
	public class AssemblyListBoard 
	{
		private var _TipsView:TipsView = new TipsView("Evolution");//---tip---
		public function AssemblyListBoardMenu(_InputSp:Sprite, _InputPic:Sprite, _InputData:Object, _BGObj:Object):Sprite
		{
			var _ListBoard:Sprite = _InputSp;
			var _ListBoardPic:Sprite = _InputPic;
				_ListBoardPic.width = 48;
				_ListBoardPic.height = 48;
				_ListBoardPic.x = 46;
				_ListBoardPic.y = 156;
			_ListBoard.addChild(_ListBoardPic);
			
			var _TextObj:Object = { _str:"", _wid:20, _hei:15, _wap:false, _AutoSize:"CENTER", _col:0xFFFFFF, _Size:12, _bold:true, _font:"Times New Roman", _leading:null };
			_TextObj._str = _InputData._showName;
			var _ShowNameText:Text = new Text(_TextObj);
				_ShowNameText.x = 95;
				_ShowNameText.y = 149;
			_ListBoard.addChild(_ShowNameText);
			
			_TextObj._str = "裝備限制 LV."+_InputData._lvEquipment;
			var LVText:Text = new Text(_TextObj);
				LVText.x = 150;
				LVText.y = 149;
			_ListBoard.addChild(LVText);
			
			//_TextObj._col = 0xa7866d;
			var _AryProperty:Array = _BGObj.PropertyImages;
			var _PropertyBit:Bitmap;
			var _Property:Sprite;
			var _PropertyText:Text;
			for (var i:int = 0; i < 6; i++) 
			{
				_Property = new Sprite();
				_PropertyBit = new Bitmap(_AryProperty[i]);
				_Property.addChild(_PropertyBit);
				
				if (i == 0) _TextObj._str = _InputData._HP;
				if (i == 1) _TextObj._str = _InputData._attack;
				if (i == 2) _TextObj._str = _InputData._defense;
				if (i == 3) _TextObj._str = _InputData._Int;
				if (i == 4) _TextObj._str = _InputData._mnd;
				if (i == 5) _TextObj._str = _InputData._speed;
				_Property.width = 18;
				_Property.height = 18;
				_Property.x = 95 + ( i % 3 ) * 50;
				_Property.y = 169 + ( int( i / 3 ) * 20);
				_Property.name = "" + i;
				_ListBoard.addChild(_Property);
				
				_PropertyText = new Text(_TextObj);
				_PropertyText.x = 120 + ( i % 3 ) * 50;
				_PropertyText.y = 168 + ( int( i / 3 ) * 20);
				_ListBoard.addChild(_PropertyText);
				
				this._TipsView.MouseEffect(_Property);
			}
			
			return _ListBoard;
		}
		
	}
}