package MVCprojectOL.ViewOL.TurntableView 
{
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Sine;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import MVCprojectOL.ModelOL.SkillDisplayModel.SkillDisplay;
	import MVCprojectOL.ViewOL.SharedMethods.SharedEffect;
	import Spark.coreFrameWork.View.ViewCtrl;
	import Spark.Utils.Text;
	import strLib.commandStr.UICmdStrLib;
	/**
	 * ...
	 * @author brook
	 */
	public class TurntableViewCtrl extends ViewCtrl
	{
		private var _SharedEffect:SharedEffect = new SharedEffect();
		private var _BGObj:Object;
		private var _TurntableObj:Object;
		private var _Inform:Sprite = new Sprite();
		private var _TurnNum:int;
		private var _Speed:Number;
		private var _ItemLength:int;
		private var _CurrentListPanel:Sprite;
		private var _CtrlMove:Boolean;
		private var _AnsListPanel:Sprite;
		private var _StopTurnNum:int;
		private var _blurNum:int;
		private var _Random:int;
		private var _StopTurnNumOne:int;
		private var _StopTurnNumTwo:int;
		private var _StopTurnNumThr:uint;
		private var _StopNum:int;
		private var _SkillDisplay:Vector.<SkillDisplay>;
		private var _TextObj:Object = { _str:"", _wid:0, _hei:0, _wap:false, _AutoSize:"CENTER", _col:0xFFFFFF, _Size:16, _bold:true, _font:"Times New Roman", _leading:null };
		
		private var _WorkBoolean:Boolean = false;
		
		public function TurntableViewCtrl(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			super( _InputViewName , _InputConter );
			this._viewConterBox.addEventListener(MouseEvent.CLICK, playerClick);
		}
		
		public function AddElement(_InputObj:Object, _TurntableObj:Object):void
		{
			this._BGObj = _InputObj;
			this._TurntableObj = _TurntableObj;
		}
		
		public function AddPanel():void 
		{
			var _AlphaBox:Sprite; 
				_AlphaBox = this._SharedEffect.DrawRect(0, 0, 1000, 700);
				_AlphaBox.name = "TurnBox";
				_AlphaBox.alpha = 0;
			this._viewConterBox.addChild(_AlphaBox );
			
			this._Inform.x = 412;
			this._Inform.y = 255;
			this._Inform.scaleX = 0.5;
			this._Inform.scaleY = 0.5;
			this._Inform.name = "TurnInform";
			this._viewConterBox.addChild(this._Inform);
			
			var _BgB:Sprite = new (this._BGObj.BgB as Class);
				_BgB.width = 430;
				_BgB.height = 280;
			this._Inform.addChild(_BgB);
			
			var _DemonAvatar:Bitmap = new Bitmap(BitmapData(new ( this._BGObj.DemonAvatar as Class)));
				_DemonAvatar.x = _BgB.width / 2 - _DemonAvatar.width / 2;
				_DemonAvatar.y = -30;
			this._Inform.addChild(_DemonAvatar);
			
			var _EdgeBg:Sprite = new (this._BGObj.EdgeBg as Class);
				_EdgeBg.y = _BgB.height - 25;
				_EdgeBg.x = _BgB.width / 2 + _BgB.x;
			this._Inform.addChild(_EdgeBg);
			
			var _BrickBg:Bitmap = new Bitmap(BitmapData(new ( this._TurntableObj.BrickBg as Class)));
				_BrickBg.x = 20;
				_BrickBg.y = 25;
			this._Inform.addChild(_BrickBg);
			
			var _ContentBg:Bitmap = new Bitmap(BitmapData(new ( this._TurntableObj.ContentBg as Class)));
				_ContentBg.x = 97;
				_ContentBg.y = 25;
			this._Inform.addChild(_ContentBg);
			
			//this.AddMaterialNumber();
			
			var _List:Bitmap = new Bitmap(BitmapData(new ( this._TurntableObj.List as Class)));
				_List.x = 107;
				_List.y = 98;
				_List.name = "List";
			this._Inform.addChild(_List);
				
			var _CheckBtn:MovieClip;
			var _CheckBtnText:Text;
			for (var i:int = 0; i < 3; i++) 
			{
				_CheckBtn = new (this._BGObj.CheckBtn as Class);
				_CheckBtn.width = 85;
				_CheckBtn.x = 325;
				_CheckBtn.y = 200;
				_CheckBtn.name = "Turn" + i;
				_CheckBtn.buttonMode = true;
				this._Inform.addChild(_CheckBtn);
				this._SharedEffect.MovieClipMouseEffect(_CheckBtn);
				if (i == 0) { 
					this._TextObj._str = "開始";
					_CheckBtnText = new Text(_TextObj);
					_CheckBtn.addChild(_CheckBtnText);
				}else if (i == 1) { 
					this._TextObj._str = "停止";
					_CheckBtnText = new Text(_TextObj);
					_CheckBtn.addChild(_CheckBtnText);
				}else  if (i == 2) { 
					this._TextObj._str = "確認";
					_CheckBtnText = new Text(_TextObj);
					_CheckBtn.addChild(_CheckBtnText);
				}
				_CheckBtnText.x = 35;
				_CheckBtnText.y = 10;
			}
			
			this._SharedEffect.ZoomIn(this._Inform, this._Inform.width * 2, this._Inform.height * 2, .5);
		}
		
		public function AddMaterialNumber(_SkillDisplay:Vector.<SkillDisplay>, _CtrlBoolean:Boolean):void 
		{
			this._WorkBoolean = true;
			if (_CtrlBoolean == true) {
				var _CheckBtn:Sprite = this._Inform.getChildByName("Turn1") as Sprite;
				this._viewConterBox.setChildIndex(this._viewConterBox.getChildByName("TurnBox"), this._viewConterBox.numChildren - 1);
				this._viewConterBox.setChildIndex(this._Inform, this._viewConterBox.numChildren - 1);
				this._SharedEffect.ZoomIn(this._Inform, this._Inform.width * 2, this._Inform.height * 2, .5);
				_CheckBtn.filters = [];
				_CheckBtn.buttonMode = true;
			}
			
			this._SkillDisplay = _SkillDisplay;
			this._ItemLength = _SkillDisplay.length;
			
			var _CurrentSkill:SkillDisplay;
			var _SkillIcon:Sprite;
			var _SkillText:Text;
			var _Mask:Sprite;
			var _ListBg:Bitmap;
			var _ListPanel:Sprite;
			for (var i:int = 0; i < this._ItemLength; i++) 
			{
				_CurrentSkill = _SkillDisplay[i];
				_CurrentSkill.ShowContent();
				
				_ListPanel = new Sprite();
				_ListBg = new Bitmap(BitmapData(new ( this._TurntableObj.ListBg as Class)));
				//_ListBg.x = 115
				//_ListBg.y = 170 - i * 65;
				_ListPanel.x = 115;
				_ListPanel.y = 170 - i * 65;
				_ListPanel.name = "ListPanel" + i;
				//trace(i, _ListPanel.y);
				_ListPanel.addChild(_ListBg);
				
				_SkillIcon = _CurrentSkill.Icon;
				_SkillIcon.width = 48;
				_SkillIcon.height = 48;
				_SkillIcon.x = 5;
				_SkillIcon.y = 7;
				_ListPanel.addChild(_SkillIcon);
				
				this._TextObj._str = _CurrentSkill.Data._name;
				_SkillText = new Text(this._TextObj);
				_SkillText.x = 70;
				_SkillText.y = 20;
				_ListPanel.addChild(_SkillText);
				
				this._Inform.addChild(_ListPanel);
				
				_Mask = this._SharedEffect.DrawRect(0, 0, 210, 195);
				_Mask.x = 110;
				_Mask.y = 40;
				//_Mask.name = "Mask" + i;
				_Mask.alpha = 0;
				this._Inform.addChild(_Mask);
				_ListPanel.mask = _Mask;
				
			}
			this._Inform.setChildIndex(this._Inform.getChildByName("List"), this._Inform.numChildren - 1);
			this._Inform.setChildIndex(this._Inform.getChildByName("Turn0"), this._Inform.numChildren - 1);
			
			this._AnsListPanel = this._Inform.getChildByName("ListPanel10") as Sprite;
			trace(_SkillDisplay[10].Data._name,"+++++++++++");
		}
		
		private function StartListPanelMove(_Speed:Number, _blurNum:int):void 
		{
			var _ListPanel:Sprite;
			for (var i:int = 0; i < this._ItemLength; i++) 
			{
				_ListPanel = this._Inform.getChildByName("ListPanel" + i) as  Sprite;
				TweenLite.to(_ListPanel, _Speed, { y:_ListPanel.y + 65, alpha:1, onComplete:this.ListBgMove, onCompleteParams : [_ListPanel], ease:Sine.easeInOut, blurFilter: { blurY:_blurNum } } );
			}
		}
		
		private function ListBgMove(_ListPanel:Sprite):void 
		{
			//trace(_ListPanel.name,_ListPanel.y,"@@@@");
			//this._CurrentListPanel = _ListPanel;
			if (_ListPanel.y == 235) _ListPanel.y = -415;
			if (this._CtrlMove == true) { 
				if (_ListPanel.name == "ListPanel0") this._TurnNum++;
				if (_ListPanel.name == this._AnsListPanel.name && this._Speed != 0) this.StartListPanelMove(this._Speed, this._blurNum);
			}else {
				if (_ListPanel.name == this._AnsListPanel.name) this._TurnNum++;
				this.StopListPanelMove(_ListPanel);
			}
		}
		
		private function StopListPanelMove(_ListPanel:Sprite):void 
		{
			//trace(_ListPanel.name, this._TurnNum, this._StopTurnNum );
			if (this._TurnNum == this._StopTurnNum + this._Random && this._StopNum == 0) {   
				this._Speed = 0.25;
				this._blurNum = 5;
				this._StopTurnNumOne = this._TurnNum;
				this._Random = 5 + int(Math.random() * 5);
				this._StopNum = 1;
			}
			if (this._TurnNum == this._StopTurnNumOne  + this._Random && this._StopNum == 1) { 
				this._Speed = 0.6;
				this._blurNum = 0;
				this._StopTurnNumTwo = this._TurnNum;
				this._Random = 2 + int(Math.random() * 5);
				this._StopNum = 2;
			}
			if (this._TurnNum == this._StopTurnNumTwo + this._Random && this._StopNum == 2) { 
				//trace(_ListPanel.name, _ListPanel.y);
				this._Speed = 1;
				this._StopTurnNumThr = this._TurnNum;
				this._Random = (_ListPanel.y - 105) / 65;
				(this._Random < 0)?this._Random = this._Random * -1:this._Random = this._Random;
				this._StopNum = 3;
				//trace();
			}
			if (this._TurnNum == this._StopTurnNumThr + this._Random && this._StopNum == 3) this._Speed = 0;
			if (_ListPanel.name == this._AnsListPanel.name && this._Speed != 0) this.StartListPanelMove(this._Speed, this._blurNum);
			if (this._Speed == 0) {
				this._Inform.setChildIndex(this._Inform.getChildByName("Turn2"), this._Inform.numChildren - 1);
				//trace(_ListPanel.name,"@@@@@");
			}
		}
		
		private function RemoveListPanel():void 
		{
			this._WorkBoolean = false;
			this._viewConterBox.setChildIndex(this._viewConterBox.getChildByName("TurnBox"), 0);
			this._viewConterBox.setChildIndex(this._Inform, 0);
			
			var _ListPanel:Sprite;
			for (var i:int = 0; i < this._ItemLength; i++) 
			{
				_ListPanel = this._Inform.getChildByName("ListPanel" + i) as  Sprite;
				this._Inform.removeChild(_ListPanel);
			}
		}
		
		private function playerClick(e:MouseEvent):void 
		{
			var _Current:Sprite = e.target as Sprite;
			switch (_Current.name) 
			{
				case "Turn0":
					this._TurnNum = 1;
					this._Speed = 0.0001;
					this._blurNum = 10;
					this._StopTurnNum = 0;
					this._StopTurnNumOne = 0;
					this._StopTurnNumTwo = 0;
					this._StopTurnNumThr = 0;
					this._StopNum = 0;
					this._CtrlMove = true;
					this.StartListPanelMove(this._Speed, this._blurNum);
					this._Inform.setChildIndex(this._Inform.getChildByName("Turn1"), this._Inform.numChildren - 1);
				break;
				case "Turn1":
					if (this._CtrlMove == true) { 
						this._CtrlMove = false;
						this._StopTurnNum = this._TurnNum;
						this._Random = 5 + int(Math.random() * 5);
						_Current.buttonMode = false;
						TweenLite.to(_Current, .5, { colorMatrixFilter: { matrix : [0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0] }} );
					}
				break;
				case "Turn2":
					this.RemoveListPanel();
					TweenLite.to(this._Inform, 0.5, { x:412, y:225, scaleX:.5, scaleY:.5 } );
					var _Skill:Object = { Skill:this._SkillDisplay[10] };
					this.SendNotify(UICmdStrLib.ChangeSkill, _Skill);
				break;
			}
		}
		//true 運作中 
		public function JudgeWork():Boolean 
		{
			return this._WorkBoolean;
		}
		
		override public function onRemoved():void 
		{
			this._viewConterBox.removeEventListener(MouseEvent.CLICK, playerClick);
			this._viewConterBox.removeChild(this._viewConterBox.getChildByName("TurnBox"));
			this._viewConterBox.removeChild(this._Inform);
		}
		
	}
}