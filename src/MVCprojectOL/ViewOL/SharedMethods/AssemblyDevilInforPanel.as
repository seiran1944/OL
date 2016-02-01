package MVCprojectOL.ViewOL.SharedMethods 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author brook
	 */
	public class AssemblyDevilInforPanel 
	{
		private var _TxtFormat:TextFormat = new TextFormat();
		//組裝惡魔資訊面板
		public function MonsterInformationPage(_InputSp:Sprite,_InputName:String,_InputLV:String,_InputAtk:String,_InputDef:String,_InputSpd:String,_InputInt:String,_InputMnd:String,_InputMeltLv:String,_NowHP:int,_MaxHP:int,_NowENG:int,_MaxENG:int,_NowEXP:int,_MaxEXP:int):Sprite
		{
			this._TxtFormat.bold = true;
			
			//trace(_MonsterInformation.getChildAt(13).name);
			var _MonsterInformation:Sprite = _InputSp;
			var _MonsterName:TextField = TextField(_MonsterInformation.getChildByName("name_txt"));
				_MonsterName.text = _InputName;
				_MonsterName.mouseEnabled = false;
			var _MonsterLV:TextField = TextField(_MonsterInformation.getChildByName("lv_txt"));
				_MonsterLV.defaultTextFormat = this._TxtFormat;
				_MonsterLV.text = _InputLV;
				_MonsterLV.mouseEnabled = false;
			var _MonsterAtk:TextField = TextField(_MonsterInformation.getChildByName("atk_txt"));
				_MonsterAtk.text = _InputAtk;
				_MonsterAtk.mouseEnabled = false;
			var _MonsterDef:TextField = TextField(_MonsterInformation.getChildByName("def_txt"));
				_MonsterDef.text = _InputDef;
				_MonsterDef.mouseEnabled = false;
			var _MonsterSpd:TextField = TextField(_MonsterInformation.getChildByName("agi_txt"));
				_MonsterSpd.text = _InputSpd;
				_MonsterSpd.mouseEnabled = false;
			var _MonsterInt:TextField = TextField(_MonsterInformation.getChildByName("int_txt"));
				_MonsterInt.text = _InputInt;
				_MonsterInt.mouseEnabled = false;
			var _MonsterMnd:TextField = TextField(_MonsterInformation.getChildByName("mnd_txt"));
				_MonsterMnd.text = _InputMnd;
				_MonsterMnd.mouseEnabled = false;
			//var _MeltLv:TextField = TextField(_MonsterInformation.getChildByName("MeltLv"));
				//_MeltLv.text = _InputMeltLv;
				//_MeltLv.mouseEnabled = false;
			var _HPBar:Sprite = Sprite(_MonsterInformation.getChildByName("hp_bar"));
				_HPBar.scaleX = (_NowHP / _MaxHP);
			var _ENGBar:Sprite = Sprite(_MonsterInformation.getChildByName("eng_bar"));
				_ENGBar.scaleX = (_NowENG / _MaxENG);
			var _EXPBar:Sprite = Sprite(_MonsterInformation.getChildByName("exp_bar"));
				_EXPBar.scaleX = (_NowEXP / _MaxEXP);
				
			var _HPtxt:TextField = TextField(_MonsterInformation.getChildByName("hp_txt"));
				_HPtxt.mouseEnabled = false;
			var _EXPtxt:TextField = TextField(_MonsterInformation.getChildByName("exp_txt"));
				_EXPtxt.mouseEnabled = false;
			var _ENGtxt:TextField = TextField(_MonsterInformation.getChildByName("eng_txt"));
				_ENGtxt.mouseEnabled = false;
			var _ATKtxt:TextField = TextField(_MonsterInformation.getChildByName("atk_title_txt"));
				_ATKtxt.mouseEnabled = false;
			var _DEFtxt:TextField = TextField(_MonsterInformation.getChildByName("def_title_txt"));
				_DEFtxt.mouseEnabled = false;
			var _INTtxt:TextField = TextField(_MonsterInformation.getChildByName("int_title_txt"));
				_INTtxt.mouseEnabled = false;
			var _MNDtxt:TextField = TextField(_MonsterInformation.getChildByName("luk_title_txt"));
				_MNDtxt.mouseEnabled = false;
			var _AGItxt:TextField = TextField(_MonsterInformation.getChildByName("agi_title_txt"));
				_AGItxt.mouseEnabled = false;
			return _MonsterInformation;
		}
		
	}
}