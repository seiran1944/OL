package MVCprojectOL.ViewOL.MonsterCage 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.SkillDisplayModel.SkillDisplay;
	import Spark.Utils.Text;
	/**
	 * ...
	 * @author brook
	 */
	public class AssemblyElement 
	{
		//組裝惡魔資訊面板
		public function MonsterInformationPage(_InputSp:Sprite, _InputBody:Sprite, _InputName:String, _InputLV:String, _InputAtk:String, _InputDef:String, _InputSpd:String, _InputInt:String, _InputMnd:String, _InputMeltLv:String, _NowHP:int, _MaxHP:int, _NowENG:int, _MaxENG:int, _NowEXP:int, _MaxEXP:int, _Attack:int, _Guard:int, _Gain:int, _Debuff:int, _Dot:int, _Recovery:int, _Control:int, _StoneSonNum:String, _StoneMonNum:String,
											_InputWeapon:ItemDisplay = null, _InputArmor:ItemDisplay = null, _InputAccessories:ItemDisplay = null, _InputSkill:Vector.<SkillDisplay> = null):Sprite
		{
			//trace(_MonsterInformation.getChildAt(13).name);
			var _BarScale :Number = 2.75;
			var _MonsterInformation:Sprite = _InputSp;
			var _MonsterBody:Sprite = _InputBody;
				_MonsterBody.x = 75;
				_MonsterBody.y = 140;
			var _MonsterName:TextField = TextField(_MonsterInformation.getChildByName("Name"));
				_MonsterName.text = _InputName;
				_MonsterName.selectable = false;
			var _MonsterLV:TextField = TextField(_MonsterInformation.getChildByName("LV"));
				_MonsterLV.text = _InputLV;
				_MonsterLV.selectable = false;
			var _MonsterAtk:TextField = TextField(_MonsterInformation.getChildByName("Attack"));
				_MonsterAtk.text = _InputAtk;
				_MonsterAtk.selectable = false;
			var _MonsterDef:TextField = TextField(_MonsterInformation.getChildByName("Defence"));
				_MonsterDef.text = _InputDef;
				_MonsterDef.selectable = false;
			var _MonsterSpd:TextField = TextField(_MonsterInformation.getChildByName("Speed"));
				_MonsterSpd.text = _InputSpd;
				_MonsterSpd.selectable = false;
			var _MonsterInt:TextField = TextField(_MonsterInformation.getChildByName("Intel"));
				_MonsterInt.text = _InputInt;
				_MonsterInt.selectable = false;
			var _MonsterMnd:TextField = TextField(_MonsterInformation.getChildByName("Spirit"));
				_MonsterMnd.text = _InputMnd;
				_MonsterMnd.selectable = false;
			var _HPNum:TextField = TextField(_MonsterInformation.getChildByName("HPnum"));
				_HPNum.text = _NowHP + "/" + _MaxHP;
				_HPNum.selectable = false;
			var _ENGNum:TextField = TextField(_MonsterInformation.getChildByName("ENGnum"));
				_ENGNum.text = _NowENG + "/" + _MaxENG;	
				_ENGNum.selectable = false;
			var _EXPNum:TextField = TextField(_MonsterInformation.getChildByName("EXPnum"));
				_EXPNum.text = _NowEXP + "/" + _MaxEXP;
				_EXPNum.selectable = false;
			//var _MeltLv:TextField = TextField(_MonsterInformation.getChildByName("MeltLv"));
				//_MeltLv.text = _InputMeltLv;
				//_MeltLv.selectable = false;
			var _HPBar:Sprite = Sprite(_MonsterInformation.getChildByName("HPbar"));
				_HPBar.scaleX = (_NowHP / _MaxHP) * _BarScale;
			var _ENGBar:Sprite = Sprite(_MonsterInformation.getChildByName("ENGbar"));
				_ENGBar.scaleX = (_NowENG / _MaxENG) * _BarScale;
			var _EXPBar:Sprite = Sprite(_MonsterInformation.getChildByName("EXPbar"));
				_EXPBar.scaleX = (_NowEXP / _MaxEXP) * _BarScale;
			
			var _AttackMC:MovieClip = MovieClip(_MonsterInformation.getChildByName("Attack_mc"));
				_AttackMC.gotoAndStop(_Attack + 1);
			var _ControlMC:MovieClip = MovieClip(_MonsterInformation.getChildByName("Control_mc"));
				_ControlMC.gotoAndStop(_Control + 1);
			var _RecoveryMC:MovieClip = MovieClip(_MonsterInformation.getChildByName("Recovery_mc"));
				_RecoveryMC.gotoAndStop(_Recovery+1)
			var _GuardMC:MovieClip = MovieClip(_MonsterInformation.getChildByName("Guard_mc"));
				_GuardMC.gotoAndStop(_Guard + 1);
			var _DebuffMC:MovieClip = MovieClip(_MonsterInformation.getChildByName("Debuff_mc"));
				_DebuffMC.gotoAndStop(_Debuff + 1);
			var _DotMC:MovieClip = MovieClip(_MonsterInformation.getChildByName("Dot_mc"));
				_DotMC.gotoAndStop(_Dot + 1);
			var _GainMC:MovieClip = MovieClip(_MonsterInformation.getChildByName("Gain_mc"));
				_GainMC.gotoAndStop(_Gain + 1);
				
			var _StoneBar:MovieClip = MovieClip(_MonsterInformation.getChildByName("StoneBar"));
				var _StoneBarNum:int = int(_StoneSonNum);
				(_StoneBarNum == 0)?_StoneBar.gotoAndStop(11):_StoneBar.gotoAndStop(_StoneBarNum);
			var _StoneSon:TextField = TextField(_MonsterInformation.getChildByName("StoneSon"));
				_StoneSon.text = _StoneSonNum;
			var _StoneMon:TextField = TextField(_MonsterInformation.getChildByName("StopnMon"));
				_StoneMon.text = _StoneMonNum;
				
				
			if (_InputWeapon != null) {
				_InputWeapon.ShowContent();
				var _Weapon:Sprite = _InputWeapon.ItemIcon;
					_Weapon.x = 76;
					_Weapon.y = 353;
					_Weapon.width = 32;
					_Weapon.height = 32;
				_InputSp.addChild(_Weapon);
			}
			if (_InputArmor != null) {
				_InputArmor.ShowContent();
				var _Armor:Sprite = _InputArmor.ItemIcon;
					_Armor.x = 132;
					_Armor.y = 353;
					_Armor.width = 32;
					_Armor.height = 32;
				_InputSp.addChild(_Armor);
			}
			if (_InputAccessories != null) {
				_InputAccessories.ShowContent();
				var _Accessories:Sprite = _InputAccessories.ItemIcon;
					_Accessories.x = 188;
					_Accessories.y = 353;
					_Accessories.width = 32;
					_Accessories.height = 32;
				_InputSp.addChild(_Accessories);
			}
			
			var _TextObj:Object = { _str:"", _wid:40, _hei:20, _wap:false, _AutoSize:"LEFT", _col:0x5135e2, _Size:14, _bold:true, _font:"Times New Roman", _leading:null };	
			var _currentTarget:SkillDisplay;
			for (var i:String in _InputSkill) {
				trace(i,"@@@@@@@@@@");
				_currentTarget = _InputSkill[i];
				_currentTarget.ShowContent();
				var _Skill:Sprite = _currentTarget.Icon;
					_Skill.x = 335;
					_Skill.y = 210 + int(i) * 35;
					_Skill.width = 24;
					_Skill.height = 24;
				_InputSp.addChild(_Skill);
				
				
				_TextObj._str =  _InputSkill[i].Data._name;
				var _SkillText:Text = new Text(_TextObj); 
					_SkillText.x = 370;
					_SkillText.y =  210 + int(i) * 35;
				_InputSp.addChild(_SkillText);
			}
			
			
			
				_InputSp.addChild( _InputBody );
			return _MonsterInformation;
		}
		
	}

}