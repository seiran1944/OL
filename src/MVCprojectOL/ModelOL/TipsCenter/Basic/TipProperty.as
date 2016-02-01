package MVCprojectOL.ModelOL.TipsCenter.Basic 
{
	import flash.display.Sprite;
	import Spark.Utils.Text;
	/**
	 * ...
	 * @author brook
	 */
	public class TipProperty 
	{
		private var _MainContainer:Sprite;
		
		private var _AdmittanceX:int = 90;//x軸位置
		private var _AdmittanceY:int = 30;//y軸位置 
		
		public function TipProperty(_InputContainer:Sprite) 
		{
			this._MainContainer = _InputContainer;
		}
		//位置設定
		public function SetInfo(_AdmittanceX:int, _AdmittanceY:int):void
		{
			this._AdmittanceX = _AdmittanceX;
			this._AdmittanceY = _AdmittanceY;
		}
		
		//屬性數值
		public function AddNumerical(_InputStoneObj:Object):void
		{
			var _Panel:Sprite = new Sprite();
				_Panel.x = this._AdmittanceX;
				_Panel.y = this._AdmittanceY;
				_Panel.name = "Panel";
			var _TextObj:Object = { _str:"", _wid:40, _hei:10, _wap:false, _AutoSize:"CENTER", _col:0xFFFFFF, _Size:10, _bold:true, _font:"Times New Roman", _leading:null };
				
				_TextObj._str = "HP";
			var _HPText:Text = new Text(_TextObj);
				_HPText.x = 0;
				_HPText.y = 0;
				_HPText.mouseEnabled = false;
				_Panel.addChild(_HPText);
				
				_TextObj._str = "ATK";
			var _ATKText:Text = new Text(_TextObj);
				_ATKText.x = 0;
				_ATKText.y = 20;
				_ATKText.mouseEnabled = false;
				_Panel.addChild(_ATKText);
				
				_TextObj._str = "DEF";
			var _DEFText:Text = new Text(_TextObj);
				_DEFText.x = 50;
				_DEFText.y = 0;
				_DEFText.mouseEnabled = false;
				_Panel.addChild(_DEFText);
				
				_TextObj._str = "INT";
			var _INTText:Text = new Text(_TextObj);
				_INTText.x = 50;
				_INTText.y = 20;
				_INTText.mouseEnabled = false;
				_Panel.addChild(_INTText);
				
				_TextObj._str = "SPD";
			var _SPDText:Text = new Text(_TextObj);
				_SPDText.x = 100;
				_SPDText.y = 0;
				_SPDText.mouseEnabled = false;
				_Panel.addChild(_SPDText);
				
				_TextObj._str = "MND";
			var _MNDText:Text = new Text(_TextObj);
				_MNDText.x = 100;
				_MNDText.y = 20;
				_MNDText.mouseEnabled = false;
				_Panel.addChild(_MNDText);
				
				_TextObj._col = 0x66CC33;
				_TextObj._Size = 12;
				_TextObj._str = _InputStoneObj._HP;
			var _HPNumText:Text = new Text(_TextObj);
				_HPNumText.x = 25;
				_HPNumText.y = -2;
				_HPNumText.mouseEnabled = false;
				_HPNumText.name = "HPNumText";
				_Panel.addChild(_HPNumText);
				
				_TextObj._str = _InputStoneObj._attack;
			var _ATKNumText:Text = new Text(_TextObj);
				_ATKNumText.x = 25;
				_ATKNumText.y = 18;
				_ATKNumText.mouseEnabled = false;
				_ATKNumText.name = "ATKNumText";
				_Panel.addChild(_ATKNumText);
				
				_TextObj._str = _InputStoneObj._defense;
			var _DEFNumText:Text = new Text(_TextObj);
				_DEFNumText.x = 75;
				_DEFNumText.y = -2;
				_DEFNumText.mouseEnabled = false;
				_DEFNumText.name = "DEFNumText";
				_Panel.addChild(_DEFNumText);
				
				_TextObj._str = _InputStoneObj._int;
			var _INTNumText:Text = new Text(_TextObj);
				_INTNumText.x = 75;
				_INTNumText.y = 18;
				_INTNumText.mouseEnabled = false;
				_INTNumText.name = "INTNumText";
				_Panel.addChild(_INTNumText);
				
				_TextObj._str = _InputStoneObj._speed;
			var _SPDNumText:Text = new Text(_TextObj);
				_SPDNumText.x = 125;
				_SPDNumText.y = -2;
				_SPDNumText.mouseEnabled = false;
				_SPDNumText.name = "SPDNumText";
				_Panel.addChild(_SPDNumText);
				
				_TextObj._str = _InputStoneObj._mnd;
			var _MNDNumText:Text = new Text(_TextObj);
				_MNDNumText.x = 125;
				_MNDNumText.y = 18;
				_MNDNumText.mouseEnabled = false;
				_MNDNumText.name = "MNDNumText";
				_Panel.addChild(_MNDNumText);
				
			this._MainContainer.addChild(_Panel);
		}
		
		
		//----2013/1/22---erichuang
		protected function addConter(_spr:Sprite,_x:Number=0,_y:Number=0):void 
		{
			this._MainContainer.addChild(_spr);
			_spr.x = _x;
			_spr.y = _y;
			
		}
		
		//更新數據
		public function ReSetHandler(_InputStoneObj:Object):void
		{
			Text(Sprite(this._MainContainer.getChildByName("Panel")).getChildByName("HPNumText")).ReSetString( _InputStoneObj._HP);
			Text(Sprite(this._MainContainer.getChildByName("Panel")).getChildByName("ATKNumText")).ReSetString (_InputStoneObj._attack) ;
			Text(Sprite(this._MainContainer.getChildByName("Panel")).getChildByName("DEFNumText")).ReSetString (_InputStoneObj._defense);
			Text(Sprite(this._MainContainer.getChildByName("Panel")).getChildByName("INTNumText")).ReSetString ( _InputStoneObj._int);
			Text(Sprite(this._MainContainer.getChildByName("Panel")).getChildByName("SPDNumText")).ReSetString (_InputStoneObj._speed);
			Text(Sprite(this._MainContainer.getChildByName("Panel")).getChildByName("MNDNumText")).ReSetString ( _InputStoneObj._mnd);
		}
		//----2013/1/23---erichuang
		protected function RemoveConter(_spr:Sprite):void 
		{
			this._MainContainer.removeChild(_spr);
		}
		
		//移除
		public function RemoveNumerical():void
		{
			this._MainContainer.removeChild(this._MainContainer.getChildByName("Panel"));
		}
	}

}