package MVCprojectOL.ViewOL.SharedMethods 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import strLib.commandStr.UICmdStrLib;
	/**
	 * ...
	 * @author brook
	 */
	public class SchedulePanel 
	{
		private var _SharedEffect:SharedEffect = new SharedEffect();
		private	var _viewConterBox:DisplayObjectContainer;
		private var _BGObj:Object;
		private var _Panel:Sprite;
		private var _BasisPanel:BasisPanel;
		public function AddElement(_InputObj:Object, _viewConterBox:DisplayObjectContainer, _TitleName:String, _RemoveStr:String):void
		{
			this._BGObj = _InputObj;
			this._viewConterBox = _viewConterBox;
			
			var _AlphaBox:Sprite; 
				_AlphaBox = this._SharedEffect.DrawRect(0, 0, 1000, 700);
				_AlphaBox.name = "ScheduleBox";
				_AlphaBox.alpha = 0;
			this._viewConterBox.addChild(_AlphaBox );
			
			this._Panel = new Sprite();
			this._Panel.x = 293;
			this._Panel.y = 127;
			this._Panel.scaleX = 0.5;
			this._Panel.scaleY = 0.5;
			this._Panel.name = "SchedulePanel";
			this._viewConterBox.addChild(this._Panel);
			this._BasisPanel = new BasisPanel(this._BGObj, this._Panel, _RemoveStr);
			this._BasisPanel.AddBasisPanel(_TitleName, 750, 510, 400);
			
			var _EvolutionBg:Bitmap = new Bitmap(BitmapData(new (this._BGObj.EvolutionBg as Class)));
				_EvolutionBg.x = 240;
				_EvolutionBg.y = 95;
			this._Panel.addChild(_EvolutionBg);
			
			var _Tab:MovieClip = new (this._BGObj.Tab as Class);
				_Tab.x = 55;
				_Tab.y = 115;
				_Tab.gotoAndStop(2);
				_Tab.name = "Tab";
			this._Panel.addChild(_Tab);
			
			var _BgD:Sprite;
			for (var i:int = 0; i < 6; i++) 
			{
				_BgD = new (this._BGObj.BgM as Class);
				_BgD.width = 200;
				_BgD.height = 67;
				_BgD.x = 45;
				_BgD.y = 145 + i * 65;
				_BgD.name = "ListBoard" + i;
				this._Panel.addChild(_BgD);
			}
			
			this.AddTable();
		}
		
		private function AddTable():void 
		{
			var _TableBg:Bitmap;
			for (var i:int = 0; i < 6; i++) 
			{
				_TableBg = new Bitmap(BitmapData(new (this._BGObj.TableBg as Class)));
				_TableBg.x = 235 + (i % 3) * 165;
				_TableBg.y = 120 + int(i / 3) * 200;
				_TableBg.name = "TableBg" + i;
				this._Panel.addChild(_TableBg);
			}
		}
		
	}

}