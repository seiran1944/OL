package MVCprojectOL.ViewOL.MonsterView 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import MVCprojectOL.ViewOL.SharedMethods.TipsView;
	import Spark.Utils.Text;
	/**
	 * ...
	 * @author brook
	 */
	public class AssemblyMonsterMenu 
	{
		private var _BGObj:Object;
		private var _MonsterBody:Sprite;
		private var _MonsterData:Object;
		private var _DisplayMonsterMenu:Sprite;
		private var _Name:String;
		private var _olBoard:MovieClip;
		private var _TipsView:TipsView = new TipsView("MonsterMenu");//---tip---
		//private var _TipsView:Object;
		public function AddMonsterMenu(_InputBGObj:Object, _InputBody:Sprite = null, _InputData:Object = null, _InputName:String = ""):Sprite
		{
			this._BGObj = _InputBGObj;
			this._MonsterBody = _InputBody;
			this._MonsterData = _InputData;
			this._Name = _InputName;
			//this._TipsView = _TipsView;
			//this._TipsView.CurrentName("MonsterMenu");
			
			this._DisplayMonsterMenu = new Sprite();
			
			this._olBoard = new (this._BGObj.MonsterBg as Class);
			this._olBoard.x = 50;
			this._olBoard.y = 120;
			this._olBoard.width = 150;
			this._olBoard.height = 200;
			this._DisplayMonsterMenu.addChild(this._olBoard);
			
			if (this._MonsterBody != null) {
				this._DisplayMonsterMenu.buttonMode = true;
				this._DisplayMonsterMenu.name = this._MonsterBody.name;
				this.AddMonsterData();
			}
			
			return this._DisplayMonsterMenu;
		}
		
		public function ButtonMode():void 
		{
			this._DisplayMonsterMenu.buttonMode = false;
		}
		
		private function AddMonsterData():void
		{
			if (this._MonsterData._rank == 2) this._olBoard.gotoAndStop(2);
			if (this._MonsterData._rank == 3 || this._MonsterData._rank == 4 || this._MonsterData._rank == 5 || this._MonsterData._rank == 6) this._olBoard.gotoAndStop(3);
			if (this._MonsterData._rank == 7) this._olBoard.gotoAndStop(4);
			if (this._MonsterData._rank == 8) this._olBoard.gotoAndStop(5);
			
			var _MonsterBody:Sprite = this._MonsterBody;
				_MonsterBody.x = 50;
				_MonsterBody.y = 120;
			this._DisplayMonsterMenu.addChild(_MonsterBody);
			
			var _OptionsBg:Sprite = new (this._BGObj.OptionsBg as Class);
				_OptionsBg.x = 50;
				_OptionsBg.y = 250;
				_OptionsBg.width = 150;
				_OptionsBg.height = 25;
			this._DisplayMonsterMenu.addChild(_OptionsBg);
			
			var _ProfessionBg:Bitmap = new Bitmap(BitmapData(new(this._BGObj.ProfessionBg as Class)));
				_ProfessionBg.x = 170;
				_ProfessionBg.y = 245;
			this._DisplayMonsterMenu.addChild(_ProfessionBg);
			var _Job:MovieClip = new (this._BGObj.Job as Class);
				if (this._MonsterData._jobPic == "JOB00005_ICO") _Job.gotoAndStop(5);
				if (this._MonsterData._jobPic == "JOB00001_ICO") _Job.gotoAndStop(2);
				if (this._MonsterData._jobPic == "JOB00002_ICO") _Job.gotoAndStop(1);
				if (this._MonsterData._jobPic == "JOB00004_ICO") _Job.gotoAndStop(3);
				if (this._MonsterData._jobPic == "JOB00006_ICO") _Job.gotoAndStop(4);
				_Job.x = 174;
				_Job.y = 249;
			//---tip---
				_Job.name = this._MonsterData._jobPic;
			this._TipsView.MouseEffect(_Job);
			//---tip---
			this._DisplayMonsterMenu.addChild(_Job);
				
			var _TextObj:Object = { _str:"", _wid:20, _hei:15, _wap:false, _AutoSize:"CENTER", _col:0xFFFFFF, _Size:12, _bold:true, _font:"Times New Roman", _leading:null };
				_TextObj._str = this._MonsterData._showName;
			var _PropertyText:Text;
				_PropertyText = new Text(_TextObj);
				_PropertyText.x = 55;
				_PropertyText.y = 255;
			this._DisplayMonsterMenu.addChild(_PropertyText);
			
				_TextObj._str = "Lv." + this._MonsterData._lv;
				_TextObj._col = 0x99FF00;
			var _LVText:Text;
				_LVText = new Text(_TextObj);
				_LVText.x = 135;
				_LVText.y = 255;
			this._DisplayMonsterMenu.addChild(_LVText);
			
			var _AryProperty:Array = this._BGObj.PropertyImages;
			var _PropertyBit:Bitmap;
			var _Property:Sprite;
			var _LayoutX:int;
			var _LayoutY:int;
				_TextObj._col = 0xFFFFFF;
			for (var i:int = 0; i < 6; i++) 
			{
				_LayoutX = ( i % 3 ) * 50;
				_LayoutY = ( int( i / 3 ) * 25);
				_Property = new Sprite();
				_PropertyBit = new Bitmap(_AryProperty[i]);
				_Property.addChild(_PropertyBit);
				if (i == 0) (this._Name == "")?_TextObj._str = this._MonsterData._nowHp:_TextObj._str = this._MonsterData._maxHP;
				if (i == 1) _TextObj._str = this._MonsterData._atk;
				if (i == 2) _TextObj._str = this._MonsterData._def;
				if (i == 3) _TextObj._str = this._MonsterData._Int;
				if (i == 4) _TextObj._str = this._MonsterData._mnd;
				if (i == 5) _TextObj._str = this._MonsterData._speed;
				_Property.width = 18;
				_Property.height = 18;
				_Property.x = 55 + _LayoutX;
				_Property.y = 275 + _LayoutY;
				//---tip---
				_Property.name = "" + i;
				this._TipsView.MouseEffect(_Property);
				//---tip---
				this._DisplayMonsterMenu.addChild(_Property);
				
				_PropertyText = new Text(_TextObj);
				_PropertyText.x = 72 + _LayoutX;
				_PropertyText.y = 273 + _LayoutY;
				_PropertyText.name = "PropertyText" + i;
				this._DisplayMonsterMenu.addChild(_PropertyText);
			}	
		}
		
		//更新血量
		public function UpdataMonster(_Value:int, _MonsterMenu:Sprite):void 
		{
			Text(_MonsterMenu.getChildByName("PropertyText0")).ReSetString(String(_Value));
		}
		
	}
}