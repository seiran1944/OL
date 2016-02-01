package MVCprojectOL.ViewOL.ExploreView.ExplorationReport 
{
	import com.greensock.easing.Elastic;
	import com.greensock.TweenLite;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import MVCprojectOL.ModelOL.Explore.Vo.ExploreReport;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import Spark.coreFrameWork.observer.Notify;
	import Spark.Utils.Text;
	import strLib.commandStr.ExploreAdventureStrLib;
	/**
	 * ...
	 * @author brook
	 * @version 13.06.17.16.30
	 */
	public class AssemblyPanel extends Notify
	{
		private var _BGObj:Object;
		private var _Panel:Sprite;
		private var _ExploreReport:ExploreReport;
		private var _LvUpData:Array;
		public function AssemblyPanel(_InputObj:Object, _InputPanel:Sprite, _ExploreReport:ExploreReport, _LvUpData:Array = null) 
		{
			this._BGObj = _InputObj;
			this._Panel = _InputPanel;
			this._ExploreReport = _ExploreReport;
			this._LvUpData = _LvUpData;
			
			var _BgB:Sprite = new (this._BGObj.BgB as Class);
				_BgB.width = 430;
				_BgB.height = 510;
				_BgB.x = 20;
				_BgB.y = 70;
			this._Panel.addChild(_BgB);
			
			var _Title:Sprite = new (this._BGObj.Title as Class);
				_Title.x = 110;
				_Title.y = 85;
			this._Panel.addChild(_Title);
			var _TextObj:Object = { _str:"", _wid:40, _hei:20, _wap:false, _AutoSize:"CENTER", _col:0xF4F0C1, _Size:16, _bold:true, _font:"Times New Roman", _leading:null };
				_TextObj._str = "探索報告";
			var _TitleText:Text = new Text(_TextObj);
				_TitleText.x = 200;
				_TitleText.y = _Title.y + 7;
				_TitleText.mouseEnabled = false;
			this._Panel.addChild(_TitleText);
			
			var _EdgeBg:Sprite;
			for (var k:int = 0; k < 2; k++) 
			{
				_EdgeBg = new (this._BGObj.EdgeBg as Class);
				(k == 0)?_EdgeBg.scaleY = -1:_EdgeBg.scaleY = 1;
				(k == 0)?_EdgeBg.y =  90:_EdgeBg.y = _BgB.height + 40;
				_EdgeBg.x = _BgB.width / 2 + _BgB.x;
				this._Panel.addChild(_EdgeBg);
			}
				
			var _ReportBg:Sprite;
			for (var j:int = 0; j < 2; j++) 
			{
				_ReportBg = new (this._BGObj.ReportBg as Class);
				_ReportBg.x = 43;
				(j == 0)?_ReportBg.y = 115:_ReportBg.y = 140;
				this._Panel.addChild(_ReportBg);
			}
			
			var _ExplainBtn:MovieClip = new (this._BGObj.ExplainBtn as Class);
				_ExplainBtn.x = 30;
				_ExplainBtn.y = 80;
				_ExplainBtn.name = "ExplainBtn";
				_ExplainBtn.buttonMode = true;
			this._Panel.addChild(_ExplainBtn);
			this.MouseEffect(_ExplainBtn);
			
			var _CloseBtn:MovieClip = new (this._BGObj.CloseBtn as Class);
				_CloseBtn.x = 415;
				_CloseBtn.y = 80;
				_CloseBtn.name = "CloseBtn";
				_CloseBtn.buttonMode = true;
			this._Panel.addChild(_CloseBtn);
			this.MouseEffect(_CloseBtn);
			
			var _CheckBtn:MovieClip = new (this._BGObj.CheckBtn as Class);
				_CheckBtn.width = 85;
				_CheckBtn.x = 194;
				_CheckBtn.y = 520;
				_CheckBtn.name = "CheckBtn";
				_CheckBtn.buttonMode = true;
			this._Panel.addChild(_CheckBtn);
			_TextObj._str = "確認";
			var _CheckBtnText:Text = new Text(_TextObj);
				_CheckBtnText.x = 47;
				_CheckBtnText.y = 10;
			_CheckBtn.addChild(_CheckBtnText);
			this.MouseEffect(_CheckBtn);
			
			var _BgM:Sprite
			var _TitleBtn:Sprite;
			var _TitleBtnText:Text;
				_TextObj._Size = 12; 
				_TextObj._col = 0x5F6061;
			for (var i:int = 0; i < 3; i++) 
			{
				_BgM = new (this._BGObj.BgM as Class);
				_BgM.width = 380;
				_BgM.x = 43;
				_TitleBtn = new (this._BGObj.TitleBtn as Class);
				_TitleBtn.width = 360;
				_TitleBtn.height = 20;
				_TitleBtn.x = 53;
				if (i == 0) {
					_BgM.height = 140;
					_BgM.y = 165;
					_TextObj._str = "戰鬥隊伍最終狀態";
				}
				if (i == 1) {
					_BgM.height = 140;
					_BgM.y = 300;
					_TextObj._str = "招募惡魔";
				}
				if (i == 2) {
					_BgM.height = 80;
					_BgM.y = 435;
					_TextObj._str = "獲得素材";
				}
				_TitleBtn.y = _BgM.y + 5;
				_TitleBtnText = new Text(_TextObj);
				(i == 0)?_TitleBtnText.x = 177:_TitleBtnText.x = 203;
				_TitleBtnText.y = _TitleBtn.y;
				this._Panel.addChild(_BgM);
				this._Panel.addChild(_TitleBtn);
				this._Panel.addChild(_TitleBtnText);
			}
			
			this.ExploreArea();
			this.MyMonsterTeam();
			this.RecruitMonster();
			this.AccessMaterial();
		}
		//區域 成敗
		private function ExploreArea():void
		{
			var _TextObj:Object = { _str:"", _wid:40, _hei:20, _wap:false, _AutoSize:"CENTER", _col:0xD0CEBC, _Size:12, _bold:true, _font:"Times New Roman", _leading:null };
				_TextObj._str = "探索區域" +" : ";
			var _ExploreAreaText:Text = new Text(_TextObj);
				_ExploreAreaText.x = 55;
				_ExploreAreaText.y = 145;
			this._Panel.addChild(_ExploreAreaText);
				_TextObj._str = "探索結果" + " : ";
			var _ExploreAreaResultText:Text = new Text(_TextObj);
				_ExploreAreaResultText.x = 320;
				_ExploreAreaResultText.y = 145;
			this._Panel.addChild(_ExploreAreaResultText);
				_TextObj._col = 0xFF9C00;
				_TextObj._str = this._ExploreReport._exploreArea._name;
			var _ExploreAreaName:Text = new Text(_TextObj);
				_ExploreAreaName.x = 120;
				_ExploreAreaName.y = 145;
			this._Panel.addChild(_ExploreAreaName);
				_TextObj._col = 0xA5E51A;
			(this._ExploreReport._success == true)?_TextObj._str = "成功":_TextObj._str = "失敗";
			var _ExploreAreaResult:Text = new Text(_TextObj);
				_ExploreAreaResult.x = 385;
				_ExploreAreaResult.y = 145;
			this._Panel.addChild(_ExploreAreaResult);
		}
		//己方惡魔資訊 //血量顏色--0:紅 1:綠 2:白  MonsterDisplay.MonsterData._HpColorKey
		private function MyMonsterTeam():void
		{
			var _CurrentMonster:MonsterDisplay;
			var _MonsterHead:Sprite;
			var _CtrlNum:int = 0;
			var _Property:Sprite;
			var _MonsterHP:Text;
			var _Exp:Text;
			var _X:int;
			var _Y:int;
			var _TextObj:Object = { _str:"", _wid:40, _hei:20, _wap:false, _AutoSize:"CENTER", _col:0xFFFFFF, _Size:14, _bold:true, _font:"Times New Roman", _leading:null };
			for ( var i:* in this._ExploreReport._teamMonsterDisplays ) 
			{
				_X=( _CtrlNum % 3 ) * (130);
				_Y=( int( _CtrlNum / 3 ) * (55));
				_CurrentMonster = this._ExploreReport._teamMonsterDisplays[i];
				_CurrentMonster.ShowContent();
				_MonsterHead = _CurrentMonster.MonsterHead;
				_MonsterHead.width = 48;
				_MonsterHead.height = 48;
				_MonsterHead.x = 55 + _X;
				_MonsterHead.y = 190 + _Y;
				this._Panel.addChild(_MonsterHead);
				
				_Property = new (this._BGObj.Property as Class);
				_Property.width = 18;
				_Property.height = 18;
				_Property.x = 105 + _X;
				_Property.y = 197+ _Y;
				this._Panel.addChild(_Property);
				//trace(_CurrentMonster.MonsterData._HpColorKey);
				if (_CurrentMonster.MonsterData._HpColorKey == 0) _TextObj._col = 0xE35B25;
				if (_CurrentMonster.MonsterData._HpColorKey == 1) _TextObj._col = 0x81B31C;
				if (_CurrentMonster.MonsterData._HpColorKey == 2) _TextObj._col = 0xD0CEBC;
				_TextObj._str = _CurrentMonster.MonsterData._nowHp + " ";
				_MonsterHP = new Text(_TextObj);
				_MonsterHP.x = 130 + _X;
				_MonsterHP.y = 195 + _Y;
				this._Panel.addChild(_MonsterHP);
				
				
				
				_TextObj._Size = 12;
				_TextObj._col = 0x767676;
				_TextObj._str = "EXP +" + _CurrentMonster.MonsterData._aquiredExp + " ";
				for (var j:int = 0; j < _LvUpData.length; j++) 
				{
					if (_CurrentMonster.MonsterData._guid == _LvUpData[j]) _TextObj._str = "Level Up!!";
				}
				_Exp = new Text(_TextObj);
				_Exp.x = 105 + _X;
				_Exp.y = 215 + _Y;
				this._Panel.addChild(_Exp);
				
				_CtrlNum++;
			}
		}
		//招募惡魔
		private function RecruitMonster():void
		{
			var _CurrentMonster:MonsterDisplay;
			var _MonsterHead:Sprite;
			var _TextObj:Object = { _str:"", _wid:40, _hei:20, _wap:false, _AutoSize:"CENTER", _col:0xFFFFFF, _Size:12, _bold:true, _font:"Times New Roman", _leading:null };
			var _CurrentMonsterName:Text;
			for (var i:int = 0; i < this._ExploreReport._acquiredMonsterDisplays.length; i++) 
			{
				_CurrentMonster = this._ExploreReport._acquiredMonsterDisplays[i];
				_CurrentMonster.ShowContent();
				_MonsterHead = _CurrentMonster.MonsterHead;
				_MonsterHead.width = 48;
				_MonsterHead.height = 48;
				_MonsterHead.x = 55 + ( i % 3 ) * (130);
				_MonsterHead.y = 325 + ( int( i / 3 ) * (55));
				this._Panel.addChild(_MonsterHead);
				
				_TextObj._str = _CurrentMonster.MonsterData._showName;
				_CurrentMonsterName = new Text(_TextObj);
				_CurrentMonsterName.x = 105 + ( i % 3 ) * (130);
				_CurrentMonsterName.y = 340 + ( int( i / 3 ) * (55));
				this._Panel.addChild(_CurrentMonsterName);
			}
		}
		//獲得素材
		private function AccessMaterial():void
		{
			var _CurrentItem:ItemDisplay;//_number
			var _CurrentItemIcon:Sprite;
			var _TextObj:Object = { _str:"", _wid:60, _hei:20, _wap:false, _AutoSize:"LEFT", _col:0xD0CEBC, _Size:14, _bold:true, _font:"Times New Roman", _leading:null };
			var _CurrentItemNum:Text;
			for (var i:int = 0; i < this._ExploreReport._acquiredMaterialDisplays.length; i++) 
			{
				_CurrentItem = this._ExploreReport._acquiredMaterialDisplays[i];
				_CurrentItem.ShowContent();
				_CurrentItemIcon = _CurrentItem.ItemIcon;
				if (_CurrentItem.ItemData._buildSourceType == -1) {
					_CurrentItemIcon.width = 36;
					_CurrentItemIcon.height = 36;
				}else {
					_CurrentItemIcon.scaleX = 0.6;
					_CurrentItemIcon.scaleY = 0.6;
				}
				_CurrentItemIcon.x = 55 + i * 60;
				(_CurrentItem.ItemData._buildSourceType == 3)?_CurrentItemIcon.y = 469:_CurrentItemIcon.y = 465;
				this._Panel.addChild(_CurrentItemIcon);
				
				_TextObj._str = _CurrentItem.ItemData._number;
				_CurrentItemNum = new Text(_TextObj);
				_CurrentItemNum.x = _CurrentItemIcon.x + _CurrentItemIcon.height - 10;
				_CurrentItemNum.y = _CurrentItemIcon.y + _CurrentItemIcon.height - 20;
				this._Panel.addChild(_CurrentItemNum);
			}
			this.ZoomIn(this._Panel, 430, 510, 0.5);
		}
		
		private function ZoomIn(_InputSp:Sprite,_OriginalWidth:int,_OriginalHeight:int,_Proportion:Number):void
		{
			var _NewX:int = _InputSp.x - ((_OriginalWidth * _Proportion)) * _Proportion;
			var _NewY:int = _InputSp.y - ((_OriginalHeight * _Proportion)) * _Proportion;
			TweenLite.to(_InputSp, 1, { x:_NewX, y:_NewY, scaleX:1, scaleY:1 , ease:Elastic.easeOut } );
		}
		
		//滑鼠效果
		private function MouseEffect(btn:*):void
		{
			btn.addEventListener(MouseEvent.ROLL_OVER, BtnEffect);
			btn.addEventListener(MouseEvent.ROLL_OUT, BtnEffect);
			btn.addEventListener(MouseEvent.CLICK, BtnEffect);
		}
		private function BtnEffect(e:MouseEvent):void 
		{
			switch (e.type) 
			{
				case "rollOver":
					MovieClip(e.target).gotoAndStop(2);
					//TweenLite.to(e.target, 0, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }} );
				break;
				case "rollOut":
					MovieClip(e.target).gotoAndStop(1);
					//TweenLite.to(e.target, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
				break;
				case "click":
					if (e.target.name == "CloseBtn" || e.target.name == "CheckBtn" ) TweenLite.to(this._Panel, 0.3, { x:373, y:153, scaleX:0.5, scaleY:0.5 , onComplete:RemovePanel } );
				break;
			}
		}
		private function RemoveMouseEffect(btn:*):void
		{
			btn.removeEventListener(MouseEvent.ROLL_OVER, BtnEffect);
			btn.removeEventListener(MouseEvent.ROLL_OUT, BtnEffect);
			btn.removeEventListener(MouseEvent.CLICK, BtnEffect);
		}
		
		private function RemovePanel():void
		{
			this.SendNotify(ExploreAdventureStrLib.RemoveALL);
		}
		
	}
}