package MVCprojectOL.ViewOL.PVPView 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.Vo.Battle.BattleResult;
	import Spark.Utils.Text;
	/**
	 * ...
	 * @author brook
	 */
	public class ReportPanel 
	{
		private var _BGObj:Object;
		private var _Panel:Sprite;
		private var _DataObj:Object;
		private var _TextObj:Object = { _str:"", _wid:0, _hei:0, _wap:false, _AutoSize:"LEFT", _col:0xF4F0C1, _Size:12, _bold:true, _font:"Times New Roman", _leading:null };
		
		public function AddReportPanel(_InputObj:Object, _InputPanel:Sprite, _DataObj:BattleResult) 
		{
			this._BGObj = _InputObj;
			this._Panel = _InputPanel;
			this._DataObj = _DataObj;
			
			var _ReportBg:Sprite;
			for (var j:int = 0; j < 2; j++) 
			{
				_ReportBg = new (this._BGObj.ReportBg as Class);
				_ReportBg.x = 43;
				(j == 0)?_ReportBg.y = 115:_ReportBg.y = 140;
				this._Panel.addChild(_ReportBg);
			}
			
			var _BgM:Sprite
			var _TitleBtn:Sprite;
			var _TitleBtnText:Text;
			this._TextObj._Size = 12;
			this._TextObj._col = 0x767676;
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
					this._TextObj._str = "我方隊伍最終狀態";
				}
				if (i == 1) {
					_BgM.height = 140;
					_BgM.y = 300;
					(this._DataObj._battleType == 2)?this._TextObj._str = "敵方隊伍最終狀態":this._TextObj._str = "招募惡魔";
				}
				if (i == 2) {
					_BgM.height = 80;
					_BgM.y = 435;
					this._TextObj._str = "獲得素材";
				}
				_TitleBtn.y = _BgM.y + 5;
				_TitleBtnText = new Text(this._TextObj);
				(i != 2)?_TitleBtnText.x = 177:_TitleBtnText.x = 203;
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
			var _infoTitleText:TextField = new TextField();
				_infoTitleText.width = 250;
				_infoTitleText.height = 20;
				_infoTitleText.x = 55;
				_infoTitleText.y = 120;
				_infoTitleText.mouseEnabled = false;
				_infoTitleText.htmlText = this._DataObj._infoTitle;
			this._Panel.addChild(_infoTitleText);
			
			var _dateTitleText:TextField = new TextField();
				_dateTitleText.width = 100;
				_dateTitleText.height = 20;
				_dateTitleText.x = 320;
				_dateTitleText.y = 120;
				_dateTitleText.mouseEnabled = false;
				_dateTitleText.htmlText =this._DataObj._dateTitle;
			this._Panel.addChild(_dateTitleText);
			
			var _typeTitleText:TextField = new TextField();
				_typeTitleText.width = 170;
				_typeTitleText.height = 20;
				_typeTitleText.x = 55;
				_typeTitleText.y = 145;
				_typeTitleText.mouseEnabled = false;
				_typeTitleText.htmlText =this._DataObj._typeTitle;
			this._Panel.addChild(_typeTitleText);
			
			var _resultTitleText:TextField = new TextField();
				_resultTitleText.width = 100;
				_resultTitleText.height = 20;
				_resultTitleText.x = 320;
				_resultTitleText.y = 145;
				_resultTitleText.mouseEnabled = false;
				_resultTitleText.htmlText =this._DataObj._resultTitle;
			this._Panel.addChild(_resultTitleText);
			
			/*this._TextObj._str = this._DataObj._infoTitle;
			var _AreaText:Text = new Text(this._TextObj);
				_AreaText.x = 55;
				_AreaText.y = 120;
			this._Panel.addChild(_AreaText);*/
			
			/*this._TextObj._str = this._DataObj._dateTitle;
			var _TimerText:Text = new Text(this._TextObj);
				_TimerText.x = 320;
				_TimerText.y = 120;
			this._Panel.addChild(_TimerText);*/
			
			/*this._TextObj._str = "戰鬥區域" + " : ";
			var _FightAreaText:Text = new Text(this._TextObj);
				_FightAreaText.x = 55;
				_FightAreaText.y = 145;
			this._Panel.addChild(_FightAreaText);*/
			
			/*this._TextObj._str = "戰鬥結果" + " : ";
			var _ExploreAreaResultText:Text = new Text(this._TextObj);
				_ExploreAreaResultText.x = 320;
				_ExploreAreaResultText.y = 145;
			this._Panel.addChild(_ExploreAreaResultText);*/
			
			/*_TextObj._col = 0xCA800C;
			this._TextObj._str = String(this._DataObj._infoTitle).substr(0, String(this._DataObj._infoTitle).length - 4);
			var _FightAreaName:Text = new Text(this._TextObj);
				_FightAreaName.x = 120;
				_FightAreaName.y = 145;
			this._Panel.addChild(_FightAreaName);*/
			
			/*_TextObj._col = 0xA5E51A;
			this._TextObj._str = this._DataObj._resultTitle;
			var _ResultText:Text = new Text(this._TextObj);
				_ResultText.x = 382;
				_ResultText.y = 145;
			this._Panel.addChild(_ResultText);*/
		}
		
		//己方惡魔資訊
		private function MyMonsterTeam():void
		{
			var _CurrentMonster:ItemDisplay;
			var _MonsterHead:Sprite;
			var _CtrlNum:int = 0;
			var _Property:Sprite;
			var _MonsterHP:Text;
			var _Exp:Text;
			var _X:int;
			var _Y:int;
			for ( var i:* in this._DataObj._aryArmy ) 
			{
				_X=( _CtrlNum % 3 ) * (130);
				_Y=( int( _CtrlNum / 3 ) * (55));
				_CurrentMonster = this._DataObj._aryArmy[i];
				_CurrentMonster.ShowContent();
				_MonsterHead = _CurrentMonster.ItemIcon;
				_MonsterHead.width = 48;
				_MonsterHead.height = 48;
				_MonsterHead.x = 55 + _X;
				_MonsterHead.y = 190 + _Y;
				this._Panel.addChild(_MonsterHead);
				
				_Property = new (this._BGObj.Property as Class);
				_Property.width = 18;
				_Property.height = 18;
				_Property.x = 105 + _X;
				_Property.y = 195+ _Y;
				this._Panel.addChild(_Property);
				
				this._TextObj._Size = 14;
				this._TextObj._col = 0xE35B25;
				this._TextObj._str = _CurrentMonster.ItemData._nowhpValue;
				_MonsterHP = new Text(this._TextObj);
				_MonsterHP.x = 130 + _X;
				_MonsterHP.y = 193 + _Y;
				this._Panel.addChild(_MonsterHP);
				
				this._TextObj._Size = 12;
				this._TextObj._col = 0x767676;
				this._TextObj._str = "EXP +" + _CurrentMonster.ItemData._addExp;
				_Exp = new Text(this._TextObj);
				_Exp.x = 105 + _X;
				_Exp.y = 218 + _Y;
				this._Panel.addChild(_Exp);
				
				_CtrlNum++;
			}
		}
		
		//敵方惡魔資訊
		private function RecruitMonster():void
		{
			var _CurrentMonster:ItemDisplay;
			var _MonsterHead:Sprite;
			var _CtrlNum:int = 0;
			var _Property:Sprite;
			var _MonsterHP:Text;
			var _X:int;
			var _Y:int;
			for ( var i:* in this._DataObj._aryEnemy ) 
			{
				_X=( _CtrlNum % 3 ) * (130);
				_Y=( int( _CtrlNum / 3 ) * (55));
				_CurrentMonster = this._DataObj._aryEnemy[i];
				_CurrentMonster.ShowContent();
				_MonsterHead = _CurrentMonster.ItemIcon;
				_MonsterHead.width = 48;
				_MonsterHead.height = 48;
				_MonsterHead.x = 55 + _X;
				_MonsterHead.y = 325 + _Y;
				this._Panel.addChild(_MonsterHead);
				
				if (this._DataObj._battleType == 2) {
					_Property = new (this._BGObj.Property as Class);
					_Property.width = 18;
					_Property.height = 18;
					_Property.x = 105 + _X;
					_Property.y = 340+ _Y;
					this._Panel.addChild(_Property);
				}
				
				this._TextObj._Size = 14;
				(this._DataObj._battleType == 2)?this._TextObj._col = 0xE35B25:this._TextObj._col = 0xFFFFFF;
				(this._DataObj._battleType == 2)?this._TextObj._str = _CurrentMonster.ItemData._nowhpValue:this._TextObj._str = _CurrentMonster.ItemData._showName;
				_MonsterHP = new Text(this._TextObj);
				(this._DataObj._battleType == 2)?_MonsterHP.x = 130 + _X:_MonsterHP.x = 105 + _X;
				(this._DataObj._battleType == 2)?_MonsterHP.y = 338 + _Y:_MonsterHP.y = 340 + _Y;
				this._Panel.addChild(_MonsterHP);
				
				_CtrlNum++;
			}
		}
		
		//獲得素材
		private function AccessMaterial():void
		{
			var _CurrentItem:ItemDisplay;
			var _CurrentItemIcon:Sprite;
			var _CtrlNum:int = 0;
			var _CurrentItemNum:Text;
			for ( var i:* in this._DataObj._aryDrop ) 
			{
				_CurrentItem = this._DataObj._aryDrop[i];
				_CurrentItem.ShowContent();
				_CurrentItemIcon = _CurrentItem.ItemIcon;
				
				this._TextObj._col = 0xD0CEBC;
				_TextObj._str = _CurrentItem.ItemData._number;
				_CurrentItemNum = new Text(_TextObj);
				
				if (this._DataObj._battleType == 1) {
					if (_CurrentItem.ItemData._buildSourceType == -1) {
						_CurrentItemIcon.width = 36;
						_CurrentItemIcon.height = 36;
					}else {
						_CurrentItemIcon.scaleX = 0.6;
						_CurrentItemIcon.scaleY = 0.6;
					}
					_CurrentItemIcon.x = 55 + i * 60;
					(_CurrentItem.ItemData._buildSourceType == 3)?_CurrentItemIcon.y = 469:_CurrentItemIcon.y = 465;
					
					_CurrentItemNum.x = _CurrentItemIcon.x + _CurrentItemIcon.height - 10;
					_CurrentItemNum.y = _CurrentItemIcon.y + _CurrentItemIcon.height - 20;
				}else {
					_CurrentItemIcon.x = 360;
					_CurrentItemIcon.y = 465;
					
					_CurrentItemNum.x = _CurrentItemIcon.x + 30;
					_CurrentItemNum.y = _CurrentItemIcon.y + 5;
				}
				this._Panel.addChild(_CurrentItemIcon);
				this._Panel.addChild(_CurrentItemNum);
				
				_CtrlNum++;
			}
		}
		
	}
}