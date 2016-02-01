package MVCprojectOL.ViewOL.MonsterView 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.SkillDisplayModel.SkillDisplay;
	import MVCprojectOL.ViewOL.MallBtn.MallBtn;
	import MVCprojectOL.ViewOL.SharedMethods.TipsView;
	import Spark.Utils.Text;
	/**
	 * ...
	 * @author brook
	 */
	public class AssemblyMonsterInfo 
	{
		private var _TipsView:TipsView = new TipsView("MonsterInfo");//---tip---
		private var _MallBtn:MallBtn = new MallBtn ();
		private var _CurrentMonster:MonsterDisplay;
		private var _DetailBoard:Sprite;
		public function AddMonsterInfo (_GlobalObj:Object, _InputMD:MonsterDisplay = null , _InputWeapon:ItemDisplay = null, _InputArmor:ItemDisplay = null, _InputAccessories:ItemDisplay = null, _InputSkill:Vector.<SkillDisplay> = null):Sprite
		{
			var _BGObj:Object = _GlobalObj;
			this._CurrentMonster = _InputMD;
			if (this._CurrentMonster != null) { 
				this._CurrentMonster.ShowContent();
				this._CurrentMonster.Alive = false;
			}
			
			this._DetailBoard = new (_BGObj.DetailBoard as Class);
			if (this._CurrentMonster != null) { 
				var _MonsterBody:Sprite = this._CurrentMonster.MonsterBody;
					_MonsterBody.x = 45;
					_MonsterBody.y = 65;
				this._DetailBoard .addChild(_MonsterBody);
			}
			
			var _OptionsBg:Sprite = new (_BGObj.OptionsBg as Class);
				_OptionsBg.x = 25;
				_OptionsBg.y = 230;
				_OptionsBg.width = 180;
				_OptionsBg.height = 25;
			this._DetailBoard .addChild(_OptionsBg);
			
			var _ProfessionBg:Bitmap = new Bitmap(BitmapData(new(_BGObj.ProfessionBg as Class)));
				_ProfessionBg.x = 175;
				_ProfessionBg.y = 225;
			this._DetailBoard .addChild(_ProfessionBg);
			if (this._CurrentMonster != null) { 
				var _Job:MovieClip = new (_BGObj.Job as Class);
					//trace(this._CurrentMonster.MonsterData._jobPic,"@@@@@");
					if (this._CurrentMonster.MonsterData._jobPic == "JOB00005_ICO") _Job.gotoAndStop(5);
					if (this._CurrentMonster.MonsterData._jobPic == "JOB00001_ICO") _Job.gotoAndStop(2);
					if (this._CurrentMonster.MonsterData._jobPic == "JOB00002_ICO") _Job.gotoAndStop(1);
					if (this._CurrentMonster.MonsterData._jobPic == "JOB00004_ICO") _Job.gotoAndStop(3);
					if (this._CurrentMonster.MonsterData._jobPic == "JOB00006_ICO") _Job.gotoAndStop(4);
					_Job.x = 179;
					_Job.y = 229;
				//---tip---
					_Job.name = this._CurrentMonster.MonsterData._jobPic;
				this._TipsView.MouseEffect(_Job);
				//---tip---
				this._DetailBoard .addChild(_Job);
			}
			
			var _TextObj:Object = { _str:"", _wid:50, _hei:15, _wap:false, _AutoSize:"LEFT", _col:0xFFFFFF, _Size:12, _bold:true, _font:"Times New Roman", _leading:null };
				(this._CurrentMonster == null)?_TextObj._str = "":_TextObj._str = this._CurrentMonster.MonsterData._showName;
			var _PropertyText:Text;
				_PropertyText = new Text(_TextObj);
				_PropertyText.x = 30;
				_PropertyText.y = 235;
			this._DetailBoard .addChild(_PropertyText);
			
				(this._CurrentMonster == null)?_TextObj._str = "Lv." + "0":_TextObj._str = "Lv." + this._CurrentMonster.MonsterData._lv;
				_TextObj._col = 0x99FF00;
			var _LVText:Text;
				_LVText = new Text(_TextObj);
				_LVText.x = 140;
				_LVText.y = 235;
			this._DetailBoard .addChild(_LVText);
			
				_TextObj._col = 0x000000;
				_TextObj._AutoSize = "LEFT";
			var _NameText:Text;
			for (var i:int = 0; i < 3; i++) 
			{
				if (i == 0)_TextObj._str = "HP";
				if (i == 1)_TextObj._str = "ENG";
				if (i == 2)_TextObj._str = "EXP";
				_NameText = new Text(_TextObj);
				_NameText.x = 243;
				_NameText.y = 122 + i * 20;
				this._DetailBoard .addChild(_NameText);
			}
			
			var _MonsterAtk:TextField = TextField(this._DetailBoard .getChildByName("Attack"));
				(this._CurrentMonster == null)?_MonsterAtk.text = "0":_MonsterAtk.text = this._CurrentMonster.MonsterData._atk;
			var _MonsterDef:TextField = TextField(this._DetailBoard .getChildByName("Defence"));
				(this._CurrentMonster == null)?_MonsterDef.text = "0":_MonsterDef.text = this._CurrentMonster.MonsterData._def;
			var _MonsterSpd:TextField = TextField(this._DetailBoard .getChildByName("Speed"));
				(this._CurrentMonster == null)?_MonsterSpd.text = "0":_MonsterSpd.text = this._CurrentMonster.MonsterData._speed;
			var _MonsterInt:TextField = TextField(this._DetailBoard .getChildByName("Intel"));
				(this._CurrentMonster == null)?_MonsterInt.text = "0":_MonsterInt.text = this._CurrentMonster.MonsterData._Int;
			var _MonsterMnd:TextField = TextField(this._DetailBoard .getChildByName("Spirit"));
				(this._CurrentMonster == null)?_MonsterMnd.text = "0":_MonsterMnd.text = this._CurrentMonster.MonsterData._mnd;
			
			var _HPNum:TextField = TextField(this._DetailBoard .getChildByName("HPnum"));
				(this._CurrentMonster == null)?_HPNum.text = "0" + "/" + "0":_HPNum.text = this._CurrentMonster.MonsterData._nowHp + "/" + this._CurrentMonster.MonsterData._maxHP;
			var _ENGNum:TextField = TextField(this._DetailBoard .getChildByName("ENGnum"));
				(this._CurrentMonster == null)?_ENGNum.text = "0" + "/" + "0":_ENGNum.text = (this._CurrentMonster.MonsterData._maxEng - this._CurrentMonster.MonsterData._nowEng) + "/" + this._CurrentMonster.MonsterData._maxEng;
			var _EXPNum:TextField = TextField(this._DetailBoard .getChildByName("EXPnum"));
				(this._CurrentMonster == null)?_EXPNum.text = "0" + "/" + "0":_EXPNum.text = this._CurrentMonster.MonsterData._nowExp + "/" + this._CurrentMonster.MonsterData._maxExp;
			
			var _DiamondBtn:Sprite;
			var _Diamond:Bitmap;
			//---tip---
			if (this._CurrentMonster != null) {
				var _Value:Sprite;
				var _HpNum:int = this._CurrentMonster.MonsterData._maxHP - this._CurrentMonster.MonsterData._nowHp;
				for (var l:int = 0; l < 3; l++) 
				{
					if (l == 0 && _HpNum != 0) { 
						_DiamondBtn = new Sprite();
						_Diamond = new Bitmap(BitmapData(new (_BGObj.Diamond as Class)));
						_DiamondBtn.addChild(_Diamond);
						_DiamondBtn.scaleX = 0.5;
						_DiamondBtn.scaleY = 0.5;
						_DiamondBtn.x = 385;
						_DiamondBtn.y = 118 + l * 20;
						_DiamondBtn.name = "hp";
						this._DetailBoard .addChild(_DiamondBtn);
						this._MallBtn.AddMallBtn(_DiamondBtn, this._CurrentMonster.MonsterData._guid, _HpNum);
					}
				
				if (l == 1 && this._CurrentMonster.MonsterData._nowEng != 0) {
					_DiamondBtn = new Sprite();
					_Diamond = new Bitmap(BitmapData(new (_BGObj.Diamond as Class)));
					_DiamondBtn.addChild(_Diamond);
					_DiamondBtn.scaleX = 0.5;
					_DiamondBtn.scaleY = 0.5;
					_DiamondBtn.x = 385;
					_DiamondBtn.y = 118 + l * 20;
					_DiamondBtn.name = "fatigue";
					this._DetailBoard .addChild(_DiamondBtn);
					this._MallBtn.AddMallBtn(_DiamondBtn, this._CurrentMonster.MonsterData._guid, _HpNum, this._CurrentMonster.MonsterData._nowEng);
				}
				
					_Value = this.DrawRect(0, 0, 150, 17);
					_Value.x = 240;
					_Value.y = 125 + l * 20;
					_Value.alpha = 0;
					_Value.name = "Value" + l;
					this._DetailBoard .addChild(_Value);
					this._TipsView.MouseEffect(_Value);
				}
			}
			
			//---tip---
			
			var _HPBar:Sprite = Sprite(this._DetailBoard .getChildByName("HPbar"));
				(this._CurrentMonster == null)?_HPBar.scaleX = 0:(this._CurrentMonster.MonsterData._maxHP == 0)? _HPBar.scaleX = 0:_HPBar.scaleX = (this._CurrentMonster.MonsterData._nowHp / this._CurrentMonster.MonsterData._maxHP);
			var _ENGBar:Sprite = Sprite(this._DetailBoard .getChildByName("ENGbar"));
				(this._CurrentMonster == null)?_ENGBar.scaleX = 0:_ENGBar.scaleX = ((this._CurrentMonster.MonsterData._maxEng - this._CurrentMonster.MonsterData._nowEng) / this._CurrentMonster.MonsterData._maxEng);
			var _EXPBar:Sprite = Sprite(this._DetailBoard .getChildByName("EXPbar"));
				(this._CurrentMonster == null)?_EXPBar.scaleX = 0:_EXPBar.scaleX = (this._CurrentMonster.MonsterData._nowExp / this._CurrentMonster.MonsterData._maxExp);
			
			var _AttackMC:MovieClip = MovieClip(this._DetailBoard .getChildByName("Attack_mc"));
				(this._CurrentMonster == null)?null:_AttackMC.gotoAndStop(this._CurrentMonster.MonsterData._learnSkill[0] + 1);
			//var _GuardMC:MovieClip = MovieClip(this._DetailBoard .getChildByName("Guard_mc"));
				//(this._CurrentMonster == null)?null:_GuardMC.gotoAndStop(this._CurrentMonster.MonsterData._learnSkill[1] + 1);
			var _GainMC:MovieClip = MovieClip(this._DetailBoard .getChildByName("Gain_mc"));
				(this._CurrentMonster == null)?null:_GainMC.gotoAndStop(this._CurrentMonster.MonsterData._learnSkill[1] + 1);
			var _DebuffMC:MovieClip = MovieClip(this._DetailBoard .getChildByName("Debuff_mc"));
				(this._CurrentMonster == null)?null:_DebuffMC.gotoAndStop(this._CurrentMonster.MonsterData._learnSkill[3] + 1);
			//var _DotMC:MovieClip = MovieClip(this._DetailBoard .getChildByName("Dot_mc"));
				//(this._CurrentMonster == null)?null:_DotMC.gotoAndStop(this._CurrentMonster.MonsterData._learnSkill[4] + 1);
			var _RecoveryMC:MovieClip = MovieClip(this._DetailBoard .getChildByName("Recovery_mc"));
				(this._CurrentMonster == null)?null:_RecoveryMC.gotoAndStop(this._CurrentMonster.MonsterData._learnSkill[2] + 1);
			//var _ControlMC:MovieClip = MovieClip(this._DetailBoard .getChildByName("Control_mc"));
				//(this._CurrentMonster == null)?null:_ControlMC.gotoAndStop(this._CurrentMonster.MonsterData._learnSkill[6] + 1);
				
			//---tip---
			this._TipsView.MouseEffect(_AttackMC);
			this._TipsView.MouseEffect(_GainMC);
			this._TipsView.MouseEffect(_DebuffMC);
			this._TipsView.MouseEffect(_RecoveryMC);
			//---tip---
				
			if (_InputWeapon != null) {
				_InputWeapon.ShowContent();
				var _Weapon:Sprite = _InputWeapon.ItemIcon;
					_Weapon.x = 31;
					_Weapon.y = 255;
					_Weapon.width = 48;
					_Weapon.height = 48;
					_Weapon.name = "Weapon";
				this._DetailBoard .addChild(_Weapon);
			}
			if (_InputArmor != null) {
				_InputArmor.ShowContent();
				var _Armor:Sprite = _InputArmor.ItemIcon;
					_Armor.x = 91;
					_Armor.y = 255;
					_Armor.width = 48;
					_Armor.height = 48;
					_Armor.name = "Armor";
				this._DetailBoard .addChild(_Armor);
			}
			if (_InputAccessories != null) {
				_InputAccessories.ShowContent();
				var _Accessories:Sprite = _InputAccessories.ItemIcon;
					_Accessories.x = 151;
					_Accessories.y = 255;
					_Accessories.width = 48;
					_Accessories.height = 48;
					_Accessories.name = "Accessories";
				this._DetailBoard .addChild(_Accessories);
			}
				
				_TextObj._Size = 14;
				_TextObj._col = 0xFFFFFF;
			var _currentTarget:SkillDisplay;
			for (var j:String in _InputSkill) {
				_currentTarget = _InputSkill[j];
				if (_currentTarget == null) continue;
				_currentTarget.ShowContent();
				var _Skill:Sprite = _currentTarget.Icon;
					_Skill.x = 245;
					_Skill.y = 190 + int(j) * 30;
					_Skill.width = 24;
					_Skill.height = 24;
					_Skill.name = "Skill" + j;
				this._DetailBoard .addChild(_Skill);
					
				_TextObj._str =  _currentTarget.Data._name;
				var _SkillText:Text = new Text(_TextObj); 
					_SkillText.x = 275;
					_SkillText.y =  190 + int(j) * 30;
					_SkillText.name = "SkillText" + j;
				this._DetailBoard .addChild(_SkillText);
			}
			
			if (this._DetailBoard.getChildByName("Skill1") != null) {
				_DiamondBtn = new Sprite();
				_Diamond = new Bitmap(BitmapData(new (_BGObj.Diamond as Class)));
				_DiamondBtn.addChild(_Diamond);
				_DiamondBtn.scaleX = 0.5;
				_DiamondBtn.scaleY = 0.5;
				_DiamondBtn.x = _SkillText.x + _SkillText.width;
				_DiamondBtn.y = _SkillText.y - 3;
				_DiamondBtn.name = "Skill";
				this._DetailBoard .addChild(_DiamondBtn);
				this._MallBtn.AddMallBtn(_DiamondBtn, this._CurrentMonster.MonsterData._guid, _HpNum, this._CurrentMonster.MonsterData._nowEng);
			}
			
			var _StoneBar:MovieClip = MovieClip(this._DetailBoard .getChildByName("StoneBar"));
				_StoneBar.gotoAndStop(11);
			if (this._CurrentMonster != null) { 
				var _StoneBarNum:int = int(this._CurrentMonster.MonsterData._eatStoneRange);
				(_StoneBarNum == 0)?_StoneBar.gotoAndStop(11):_StoneBar.gotoAndStop(_StoneBarNum);
			}
			var _StoneSon:TextField = TextField(this._DetailBoard .getChildByName("StoneSon"));
				(this._CurrentMonster == null)?_StoneSon.text = "0":_StoneSon.text = this._CurrentMonster.MonsterData._eatStoneRange;
			var _StoneMon:TextField = TextField(this._DetailBoard .getChildByName("StopnMon"));
				(this._CurrentMonster == null)?_StoneMon.text = "0":_StoneMon.text = this._CurrentMonster.MonsterData._lv;
				
			//---tip---	
			var _Property:Sprite;
			for (var k:int = 0; k < 5; k++) 
			{
				_Property = this.DrawRect(0, 0, 18, 18);
				_Property.x = 241 + k * 35 - k * 2;
				_Property.y = 268;
				_Property.alpha = 0;
				_Property.name = "" + k;
				this._DetailBoard .addChild(_Property);
				this._TipsView.MouseEffect(_Property);
			}
			//---tip---
			
			return this._DetailBoard ;
		}
		
		public function UpdataMonster(_Value:int, _Type:int):void 
		{
			if (_Type == 2) {
				var _HPBar:Sprite = Sprite(this._DetailBoard .getChildByName("HPbar"));
					_HPBar.scaleX = (_Value / this._CurrentMonster.MonsterData._maxHP);
				var _HPNum:TextField = TextField(this._DetailBoard .getChildByName("HPnum"));
					_HPNum.text = _Value + "/" + this._CurrentMonster.MonsterData._maxHP;
			}else {
				var _ENGBar:Sprite = Sprite(this._DetailBoard .getChildByName("ENGbar"));
					_ENGBar.scaleX = (_Value / this._CurrentMonster.MonsterData._maxEng);
				var _ENGNum:TextField = TextField(this._DetailBoard .getChildByName("ENGnum"));
					_ENGNum.text = _Value + "/" + this._CurrentMonster.MonsterData._maxEng;
			}
		}
		
		public function UpdataSkill(_Skill:SkillDisplay):void 
		{
			if (this._DetailBoard.getChildByName("Skill1") != null) this._DetailBoard.removeChild(this._DetailBoard.getChildByName("Skill1"));
			var _NewSkill:Sprite = _Skill.Icon;
				_NewSkill.x = 245;
				_NewSkill.y = 220;
				_NewSkill.width = 24;
				_NewSkill.height = 24;
				_NewSkill.name = "Skill1";
			this._DetailBoard.addChild(_NewSkill);
			var _SkillText:Text = Text(this._DetailBoard.getChildByName("SkillText1"));
				_SkillText.ReSetString(_Skill.Data._name);
			var _DiamondBtn:Sprite = this._DetailBoard.getChildByName("Skill") as Sprite;
				_DiamondBtn.x = _SkillText.x + _SkillText.width;
				_DiamondBtn.y = _SkillText.y - 3;
		}
		/*public function RemoveSkill(_CtrlBoolean:Boolean):void 
		{
			if (this._DetailBoard.getChildByName("Skill1") != null) this._DetailBoard.removeChild(this._DetailBoard.getChildByName("Skill1"));
			Text(this._DetailBoard.getChildByName("SkillText1")).ReSetString("");
		}*/
		
		public function DrawRect(_LocationX:int, _LocationY:int, _Width:int, _Height:int):Sprite 
		{
			var _sp:Sprite = new Sprite ();
				_sp.graphics.beginFill(0xFFFFFF);
				_sp.graphics.drawRect(_LocationX,_LocationY,_Width,_Height);
			return _sp;
		}
		
	}
}