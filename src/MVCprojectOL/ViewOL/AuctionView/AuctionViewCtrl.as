package MVCprojectOL.ViewOL.AuctionView 
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ViewOL.MainView.MianViewCenter;
	import MVCprojectOL.ViewOL.SharedMethods.AskPanel;
	import MVCprojectOL.ViewOL.SharedMethods.BasisPanel;
	import MVCprojectOL.ViewOL.SharedMethods.SharedEffect;
	import MVCprojectOL.ViewOL.SharedMethods.SlidingControl;
	import MVCprojectOL.ViewOL.SharedMethods.SplitPageMethod;
	import MVCprojectOL.ViewOL.SharedMethods.TipsView;
	import MVCprojectOL.ViewOL.TipsView.TipsCenterView;
	import Spark.coreFrameWork.View.ViewCtrl;
	import Spark.Utils.Text;
	import strLib.commandStr.PVECommands;
	import strLib.commandStr.UICmdStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewStrLib;
	/**
	 * ...
	 * @author brook
	 */
	public class AuctionViewCtrl extends ViewCtrl
	{
		private var _TextObj:Object = { _str:"", _wid:0, _hei:0, _wap:false, _AutoSize:"LEFT", _col:0xFFFFFF, _Size:12, _bold:true, _font:"Times New Roman", _leading:null };
		private var _SharedEffect:SharedEffect = new SharedEffect();
		private var _BGObj:Object;
		private var _AuctionObj:Object;
		private var _Panel:Sprite;
		private var _BasisPanel:BasisPanel;
		private var _onTabElement:Vector.<MovieClip>;
		private var _CurrentTabM:int;
		private var _AryProperty:Array;
		private var _TextStyle:TextFormat = new TextFormat();
		private var _ClickBoolean:Boolean = false;
		private var _CurrentInputName:String = "";
		private var _CurrentInputNumber:String = "";
		private var _PatternName:RegExp =/^[\u4e00-\u9fa5]{1,}/;
		private var _PatternNumber:RegExp =/[\w]+/g;
		private var _SetSearch:Object = { };
		private var _GoodsData:Vector.<ItemDisplay>;
		private var _ListBoard:Vector.<Sprite>;
		private var _SellCtrl:Boolean = true;
		private var _SplitPageMethod:SplitPageMethod = new SplitPageMethod();
		private var _SlidingControl:SlidingControl;
		private var _PageList:Array;
		private var _CtrlPageNum:int;
		private var _SellListBoard:Vector.<Sprite>;
		private var _CurrentInputPrice:String;
		private var _CtrlPriceBtn:Boolean = false;
		private var _BuyData:Object = new Object();
		private var _CurrentListBoard:Sprite;
		private var _SortBtnName:Vector.<String> = new < String > ["level", "health", "attack", "defence", "speed", "intelligence", "spirit", "money"];
		private var _Sort:Vector.<Boolean> = new < Boolean > [false, false, false, false, false, false, false, false];
		private var _CurrentPropertyField:String;
		private var _BuyCurrentGoods:ItemDisplay;
		private var _CurrentQBtn:int;
		private var _QBtnBoolean:Boolean;
		private var _QBtnClick:Boolean = true;
		private var _QBtnColor:Vector.<int> = new <int>[0xFFFFFF,0xFFFFFF,0xA5E51A,0x7FDDDC,0xFFC600];
		private var _MonstrtBtnColor:Vector.<int> = new <int>[0xFFFFFF,0xFFFFFF,0x7FFF00,0x98F5FF,0x63B8FF,0x4876FF,0x1C86EE,0xFFBBFF,0xFFFF00];
		private var _QBtnLength:int;
		private var _AskPanel:AskPanel = new AskPanel();
		private var _TipsView:TipsView = new TipsView("Auction");//---tip---
		private var _CurrentIconNum:int;
		
		public function AuctionViewCtrl(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			super( _InputViewName , _InputConter );
			this._viewConterBox.addEventListener(MouseEvent.CLICK, playerClick);
		}
		
		public function AddElement(_InputObj:Object, _AuctionObj:Object):void 
		{
			this._BGObj = _InputObj;
			this._AuctionObj = _AuctionObj;
			
			this._AskPanel.AddElement(this._viewConterBox, this._BGObj);
			
			this._CurrentListBoard = new Sprite();
			this._CurrentListBoard.name = "";
			
			var _AlphaBox:Sprite; 
				_AlphaBox = this._SharedEffect.DrawRect(0, 0, 1000, 700);
				_AlphaBox.name = "AuctionBox";
				_AlphaBox.alpha = 0;
			this._viewConterBox.addChild(_AlphaBox );
			
			this._Panel = new Sprite();
			this._Panel.x = 240;
			this._Panel.y = 127;
			this._Panel.scaleX = 0.5;
			this._Panel.scaleY = 0.5;
			this._Panel.name = "AuctionPanel";
			this._viewConterBox.addChild(this._Panel);
			this._BasisPanel = new BasisPanel(this._BGObj, this._Panel);
			this._BasisPanel.AddBasisPanel("交易黑市", 960, 510, 400);
			
			var _SaleBg:Bitmap = new Bitmap(BitmapData(new (this._AuctionObj.SaleBg as Class)));
				_SaleBg.x = 38;
				_SaleBg.y = 150;
			this._Panel.addChild(_SaleBg);
			
			var _BgM:Sprite;
			for (var j:int = 0; j < 7; j++) 
			{
				_BgM = new (this._BGObj.BgM as Class);
				_BgM.width = 760;
				_BgM.height = 55;
				_BgM.x = 190;
				_BgM.y = 170 + j * 52;
				_BgM.name = "BgM" + j;
				this._Panel.addChild(_BgM);
			}
			
			var _TitleBtnText:Text;
			var _TitleBtn:Sprite;
				_TitleBtn = new (this._BGObj.TitleBtn as Class);
				_TitleBtn.width = 50;
				_TitleBtn.height = 25;
				_TitleBtn.x = 195;
				_TitleBtn.y = 145;
			this._Panel.addChild(_TitleBtn);
			this._TextObj._str = "圖      示";
				_TitleBtnText = new Text(this._TextObj);
				_TitleBtnText.x = 5;
				_TitleBtnText.y = 3;
			_TitleBtn.addChild(_TitleBtnText);
			
				_TitleBtn = new (this._BGObj.TitleBtn as Class);
				_TitleBtn.width = 150;
				_TitleBtn.height = 25;
				_TitleBtn.x = 248;
				_TitleBtn.y = 145;
			this._Panel.addChild(_TitleBtn);
			this._TextObj._str = "名               稱";
				_TitleBtnText = new Text(this._TextObj);
				_TitleBtnText.x = 25;
				_TitleBtnText.y = 3;
			_TitleBtn.addChild(_TitleBtnText);
			
			this._AryProperty = this._BGObj.PropertyImages;
			var _PropertyBit:Bitmap;
			var _SortBtn:MovieClip;
			
			for (var i:int = 0; i < 8; i++) 
			{
				_TitleBtn = new (this._BGObj.TitleBtn as Class);
				(i != 7)?_TitleBtn.width = 50:_TitleBtn.width = 100;
				_TitleBtn.height = 25;
				_TitleBtn.x = 401 + i * 53;
				_TitleBtn.y = 145;
				_TitleBtn.name = "TitleBtn" + i;
				this._Panel.addChild(_TitleBtn);
				
				_SortBtn = new (this._BGObj.SortBtn as Class);
				(i != 7)?_SortBtn.x = 430 + i * 53:_SortBtn.x = 830;
				_SortBtn.y = 151;
				_SortBtn.name = this._SortBtnName[i];
				_SortBtn.buttonMode = true;
				_SortBtn.visible = false;
				this._Panel.addChild(_SortBtn);
				this._SharedEffect.MovieClipMouseEffect(_SortBtn);
				this._TipsView.MouseEffect(_SortBtn);
				
				if (i != 7) {
					if (i == 0) _PropertyBit = new Bitmap(this._AryProperty[0]);
					if (i == 1) _PropertyBit = new Bitmap(this._AryProperty[1]);
					if (i == 2) _PropertyBit = new Bitmap(this._AryProperty[2]);
					if (i == 3) _PropertyBit = new Bitmap(this._AryProperty[5]);
					if (i == 4) _PropertyBit = new Bitmap(this._AryProperty[3]);
					if (i == 5) _PropertyBit = new Bitmap(this._AryProperty[4]);
					if (i == 6) _PropertyBit = new Bitmap(this._AryProperty[6]);
					_PropertyBit.width = 18;
					_PropertyBit.height = 18;
					_PropertyBit.name = "PropertyBit" + i;
					(i == 6)?_PropertyBit.x = 407:_PropertyBit.x = 460 + i * 53;
					_PropertyBit.y = 148;
					this._Panel.addChild(_PropertyBit);
				}
				
			}
			this._SlidingControl = new SlidingControl( this._Panel );
			
			this._BasisPanel.AddFatigue(0.4, 0.4, 800, 148);
			
			this._BasisPanel.AddPageBtn(460);
			
			this._BasisPanel.AddGrayCheckBtn("搜尋", 77, 475, 85,"NoSearch");
			this._BasisPanel.AddCheckBtn("搜尋", 77, 475, 85, "Search");
			this._TipsView.MouseEffect(this._Panel.getChildByName("Search"));
			
			this._BasisPanel.AddGrayCheckBtn("購買", 870, 530, 85, "NoBuy");
			this._TipsView.MouseEffect(this._Panel.getChildByName("NoBuy"));
			this._BasisPanel.AddCheckBtn("購買", 870, 530, 85, "Buy");
			this._Panel.getChildByName("Buy").visible = false;
			this._TipsView.MouseEffect(this._Panel.getChildByName("Buy"));
			
			this.AddText();
			
			this.AddPropertyField();
			
			this.Tab();
			
			var _SellBtn:MovieClip = new  (this._BGObj.Tab as Class);
				_SellBtn.x = 890;
				_SellBtn.y = 130;
				_SellBtn.buttonMode = true;
				_SellBtn.name = "Sell";
			this._SharedEffect.MovieClipMouseEffect(_SellBtn);
			this._Panel.addChild(_SellBtn);
			this._TipsView.MouseEffect(_SellBtn);
			this._TextObj._col = 0xFFFFFF;
			this._TextObj._Size = 14;
			this._TextObj._str = "掛賣";
			var _SellText:Text = new Text(this._TextObj);
				_SellText.x = 15;
				_SellText.y = 4;
				_SellText.name = "SellText";
			_SellBtn.addChild(_SellText);
		}
		
		private function AddText():void 
		{
			this._TextStyle.bold = true;
			this._TextStyle.color = 0xF4F0C1;
			var _TextBitmap:Bitmap;
			var _TextInput:TextField;
			for (var i:int = 0; i < 2; i++) 
			{
				_TextBitmap = new Bitmap( BitmapData( new (this._AuctionObj.SearchBox as Class)));
				_TextBitmap.width = 130;
				_TextBitmap.height = 20;
				_TextBitmap.x = 55;
				_TextBitmap.y = 180 + i * 30;
				this._Panel.addChild(_TextBitmap);
				
				_TextInput = new TextField();
				_TextInput.type = TextFieldType.INPUT;
				(i == 0)?_TextInput.restrict = "\u4e00-\u9fa5":_TextInput.restrict = "0-9";//輸入中文  數字
				_TextInput.maxChars = 9;
				_TextInput.width = _TextBitmap.width;
				_TextInput.height = _TextBitmap.height;
				(i == 0)?_TextInput.text = "請輸入搜尋名稱":_TextInput.text = "請輸入價格上限";
				_TextInput.x = _TextBitmap.x;
				_TextInput.y = _TextBitmap.y;
				_TextInput.name = "TextInput" + i;
				_TextInput.setTextFormat(this._TextStyle);
				this._Panel.addChild(_TextInput);
				_TextInput.addEventListener(Event.CHANGE, preventChange);
				this._TipsView.MouseEffect(_TextInput);
			}
		}
		
		private function preventChange(e:Event):void 
		{
			var _CurrentText:TextField = TextField(e.target);
			if (e.target.name == "TextInput0" /*&& _PatternName.test(_CurrentText.text) == true*/) {
				this._CurrentInputName = _CurrentText.text;
				this._SetSearch["EXCHANGE"] = ProxyPVEStrList.EXCHANGE_SEA_NAME;
				this._SetSearch["NAMEONE"] = this._CurrentInputName;
				this.SendNotify(UICmdStrLib.SetSearch, this._SetSearch);
			}
			if (e.target.name == "TextInput1" /*&& _PatternNumber.test(_CurrentText.text) == true*/) {
				this._CurrentInputNumber = _CurrentText.text;
				this._SetSearch["EXCHANGE"] = ProxyPVEStrList.EXCHANGE_SEA_MONEY;
				this._SetSearch["NAMEONE"] = this._CurrentInputNumber;
				this.SendNotify(UICmdStrLib.SetSearch, this._SetSearch);
			}
			//trace(this._CurrentInputName,_CurrentText.text,this._CurrentInputNumber,"@@@@@");
			if (this._CurrentInputName != "" && this._CurrentInputNumber != "") this._Panel.getChildByName("Search").visible = true;
			//if (_CurrentText.name == "TextInput0") ;
			//if (_CurrentText.text == "") this._Panel.getChildByName("Search").visible = false;
		}
		
		private function AddPropertyField():void
		{
			var _PropertyField:Sprite;
			var _PropertyBit:Bitmap;
			var _Hyphen:Bitmap;
			var _TextBitmap:Bitmap;
			var _PropertyTextInput:TextField;
			for (var i:int = 0; i < 7; i++) 
			{
				_PropertyField = new Sprite();
				_PropertyField.name = "PropertyField" + i;
				_PropertyField.x = 50;
				(i != 6)?_PropertyField.y = 300 + i * 30:_PropertyField.y = 270;
				this._Panel.addChild(_PropertyField);
				this._TipsView.MouseEffect(_PropertyField);
				
				if (i == 0) _PropertyBit = new Bitmap(this._AryProperty[0]);
				if (i == 1) _PropertyBit = new Bitmap(this._AryProperty[1]);
				if (i == 2) _PropertyBit = new Bitmap(this._AryProperty[2]);
				if (i == 3) _PropertyBit = new Bitmap(this._AryProperty[5]);
				if (i == 4) _PropertyBit = new Bitmap(this._AryProperty[3]);
				if (i == 5) _PropertyBit = new Bitmap(this._AryProperty[4]);
				if (i == 6) _PropertyBit = new Bitmap(this._AryProperty[6]);
				_PropertyBit.width = 18;
				_PropertyBit.height = 18;
				_PropertyField.addChild(_PropertyBit);
				
				_Hyphen = new Bitmap( BitmapData( new (this._AuctionObj.Hyphen as Class)));
				_Hyphen.x = 73;
				_Hyphen.y = 7;
				_PropertyField.addChild(_Hyphen);
				
				for (var j:int = 0; j < 2; j++) 
				{
					_TextBitmap = new Bitmap( BitmapData( new (this._AuctionObj.SearchBox as Class)));
					_TextBitmap.width = 50;
					_TextBitmap.height = 20;
					_TextBitmap.x = 20 + j * 65;
					_TextBitmap.y = 0;
					_PropertyField.addChild(_TextBitmap);
					
					_PropertyTextInput = new TextField();
					_PropertyTextInput.type = TextFieldType.INPUT;
					_PropertyTextInput.restrict = "0-9";//輸入數字
					_PropertyTextInput.maxChars = 3;
					_PropertyTextInput.width = _TextBitmap.width;
					_PropertyTextInput.height = _TextBitmap.height;
					//(j == 0)?_PropertyTextInput.text = "1":_PropertyTextInput.text = "999";
					_PropertyTextInput.text = "0";
					_PropertyTextInput.x = _TextBitmap.x;
					_PropertyTextInput.y = _TextBitmap.y;
					_PropertyTextInput.name = "PropertyTextInput" + j;
					_PropertyTextInput.setTextFormat(this._TextStyle);
					_PropertyField.addChild(_PropertyTextInput);
					_PropertyTextInput.addEventListener(Event.CHANGE, PropertyChange);
					this._TipsView.MouseEffect(_PropertyTextInput);
				}
			}
			this.AddQBtn(5);
		}
		
		private function AddQBtn(_Num:int):void 
		{
			this._TextObj._Size = 12;
			var _TitleBtn:Sprite;
			var _TitleBtnText:Text;
			var _TitleBtnStr:Vector.<String> = new < String > ["全 部", "普 通", "良 品", "稀 有", "極 品"];
			var _MonsterStr:Vector.<String> = new < String > ["全 部", "白", "綠", "藍", "藍+1", "藍+2", "藍+3", "粉紅", "金"];
			this._QBtnLength = _Num;
			for (var i:int = 0; i < this._QBtnLength; i++) 
			{
				_TitleBtn = new  (this._BGObj.TitleBtn as Class);
				_TitleBtn.width = 85;
				_TitleBtn.x = 77;
				_TitleBtn.y = 235;
				_TitleBtn.buttonMode = true;
				_TitleBtn.name = "QBtn" + i;
				_TitleBtn.addEventListener(MouseEvent.CLICK, QBtnClick);
				if (i != 0) _TitleBtn.alpha = 0;
				this._Panel.addChild(_TitleBtn);
				this._SharedEffect.MouseEffect(_TitleBtn);
					
				(_Num == 5)?this._TextObj._col = this._QBtnColor[i]:this._TextObj._col = this._MonstrtBtnColor[i];
				(_Num == 5)?this._TextObj._str = _TitleBtnStr[i]:this._TextObj._str = _MonsterStr[i];
				_TitleBtnText = new Text(this._TextObj);
				_TitleBtnText.x = 20;
				_TitleBtnText.y = 3;
				_TitleBtn.addChild(_TitleBtnText);
			}
			this._Panel.setChildIndex(this._Panel.getChildByName("QBtn0"), this._Panel.numChildren - 1);
				
			var _SortBtn:MovieClip = new (this._BGObj.SortBtn as Class);
				_SortBtn.x = 130;
				_SortBtn.y = 240;
				_SortBtn.buttonMode = true;
				(this._CurrentTabM == 4)?_SortBtn.name = "QualityM":_SortBtn.name = "QualityS";
			this._SharedEffect.MovieClipMouseEffect(_SortBtn);
			this._Panel.addChild(_SortBtn);
			this._TipsView.MouseEffect(_SortBtn);
		}
		private function RemoveQBtn():void 
		{
			for (var i:int = 0; i < this._QBtnLength; i++) 
			{
				this._Panel.removeChild(this._Panel.getChildByName("QBtn" + i));
			}
			(this._CurrentTabM == 4)?this._Panel.removeChild(this._Panel.getChildByName("QualityM")):this._Panel.removeChild(this._Panel.getChildByName("QualityS"));
		}
		
		private function PropertyChange(e:Event):void 
		{
			var _CurrentText:TextField = TextField(e.currentTarget);
			var _PropertyField:Sprite = _CurrentText.parent as Sprite;
			if (this._CurrentPropertyField != _PropertyField.name) { 
				this._SetSearch["NAMEONE"] = "";
				this._SetSearch["NAMETOW"] = "";
				this._CurrentPropertyField = _PropertyField.name;
			}
			var _Str:String;
			if (_PropertyField.name == "PropertyField6") _Str = ProxyPVEStrList.EXCHANGE_SEA_LV;
			if (_PropertyField.name == "PropertyField0") _Str = ProxyPVEStrList.EXCHANGE_SEA_HP;
			if (_PropertyField.name == "PropertyField1") _Str = ProxyPVEStrList.EXCHANGE_SEA_ATK;
			if (_PropertyField.name == "PropertyField2") _Str = ProxyPVEStrList.EXCHANGE_SEA_DEF;
			if (_PropertyField.name == "PropertyField3") _Str = ProxyPVEStrList.EXCHANGE_SEA_SPD;
			if (_PropertyField.name == "PropertyField4") _Str = ProxyPVEStrList.EXCHANGE_SEA_INT;
			if (_PropertyField.name == "PropertyField5") _Str = ProxyPVEStrList.EXCHANGE_SEA_MND;
			this._SetSearch["EXCHANGE"] = _Str;
			if (_CurrentText.name == "PropertyTextInput0") {
				this._SetSearch["NAMEONE"] = _CurrentText.text;
				 this._SetSearch["NAMETOW"] = -1;
			}
			if (_CurrentText.name == "PropertyTextInput1") this._SetSearch["NAMETOW"] = _CurrentText.text;
			//trace(_Str,this._SetSearch["NAMEONE"], this._SetSearch["NAMETOW"], "!!!!!");
			this.SendNotify(UICmdStrLib.SetSearch, this._SetSearch);
		}
		
		private function Tab():void
		{
			var _Magic:MovieClip = new (this._AuctionObj.Magic as Class);
				_Magic.name = "Magic";
			this._TipsView.MouseEffect(_Magic);
			var _Weapon:MovieClip = new (this._AuctionObj.Weapon as Class);
				_Weapon.name = "Weapon";
			this._TipsView.MouseEffect(_Weapon);
			var _Armor:MovieClip = new (this._AuctionObj.Armor as Class);
				_Armor.name = "Armor";
			this._TipsView.MouseEffect(_Armor);
			var _Accessories:MovieClip = new (this._AuctionObj.Accessories as Class);
				_Accessories.name = "Accessories";
			this._TipsView.MouseEffect(_Accessories);
			var _Monster:MovieClip = new (this._AuctionObj.Moster as Class);
				_Monster.name = "Monster";
			this._TipsView.MouseEffect(_Monster);
			
			this._onTabElement = new <MovieClip>[_Magic, _Weapon, _Armor, _Accessories, _Monster];
			this._CurrentTabM = 0;
			
			this.TabMFactory(this._onTabElement[this._CurrentTabM], this._CurrentTabM);
			
			//if (this._CurrentTabM == 0) this.PropertyMove(this._CurrentTabM, false);
		}
		private function TabMFactory(_InputSP:MovieClip,InputNum:int):void
		{
			var _TabElement:MovieClip = _InputSP;
				_TabElement.x = 12;
				_TabElement.y = -15;
				_TabElement.scaleX = 0.8;
				_TabElement.scaleY = 0.8;
				_TabElement.gotoAndStop(3);
				this._SharedEffect.RemoveMovieClipMouseEffect(_TabElement);
			var _TabM:MovieClip = new  (this._BGObj.Tab as Class);
				_TabM.x = 50 + InputNum * 62;//160 + InputNum * 97;
				_TabM.y = 120;
				_TabM.gotoAndStop(2);
				_TabM.buttonMode = false;
				_TabM.name = "Tam" + InputNum;
				_TabM.addChild(_TabElement);
			this._Panel.addChild(_TabM);
			for (var i:int = 0; i < 5; i++)(i == this._CurrentTabM)?null:this.TabSFactory(this._onTabElement[i], i);
		}
		private function TabSFactory(_InputSP:MovieClip,InputNum:int):void
		{
			var _TabElement:MovieClip = _InputSP;
				_TabElement.x = 12;
				_TabElement.y = -10;
				_TabElement.name = this._onTabElement[InputNum].name;
				_TabElement.scaleX = 0.8;
				_TabElement.scaleY = 0.8;
				_TabElement.gotoAndStop(1);
				_TabElement.name = "Tab" + InputNum;
				this._SharedEffect.MovieClipMouseEffect(_TabElement);
			var _TabS:MovieClip = new  (this._BGObj.Tab as Class);
				_TabS.scaleX = 0.6;
				_TabS.scaleY = 0.6;
				(this._CurrentTabM < InputNum)?_TabS.x = this._Panel.getChildByName("Tam" + this._CurrentTabM).x + (InputNum - this._CurrentTabM) * 50:_TabS.x = this._Panel.getChildByName("Tam" + this._CurrentTabM).x - (this._CurrentTabM - InputNum) * 50;
				_TabS.y = 125;
				_TabS.buttonMode = true;
				_TabS.name = "Tam" + InputNum;
				_TabS.addChild(_TabElement);
			this._Panel.addChild(_TabS);
			this.move(_TabS, InputNum);
		}
		private function move(_InputSP:Sprite,InputNum:int):void
		{
			if (InputNum == this._CurrentTabM ) {
				//this.removebtnFactory(_InputSP);
				this._Panel.removeChild(_InputSP);
				this.TabMFactory(this._onTabElement[InputNum], InputNum);
			}else if (InputNum != this._CurrentTabM&&this._CurrentTabM > -1 ){
				TweenLite.to(_InputSP, 0.2, { x:50 + InputNum * 62, y:120, scaleX:1, scaleY:1/*,onComplete:btnFactoryHandler,onCompleteParams:[_InputSP]*/ } );
			}
		}
		private function TabClick(_Num:String):void 
		{
			if (this._CurrentTabM != int(_Num)) { 
				this.RemoveListBoard();
				this._BasisPanel.IntPageData(0, 0);
				var _Tab:MovieClip;
				var _TabS:MovieClip;
				//if (this._CurrentTabM == 0) this.PropertyMove(this._CurrentTabM, true);
				for (var j:int = 0; j < 8; j++) 
				{
					this._Sort[i] = false;
					this.SortMove(j, this._Sort[i]);
					if (j < 7) { 
						_PropertyField = this._Panel.getChildByName("PropertyField" + j) as Sprite;
						_TextField = TextField(_PropertyField.getChildByName("PropertyTextInput0"));
						_TextField.text = "0";
						_TextField.setTextFormat(this._TextStyle);
						_TextField = TextField(_PropertyField.getChildByName("PropertyTextInput1"));
						_TextField.text = "0";
						_TextField.setTextFormat(this._TextStyle);
					}
				}
				
				if (this._QBtnBoolean == true) {
					this.QualityMove();
				}else {
					var _QBtn:Sprite = this._Panel.getChildByName("QBtn" + this._CurrentQBtn) as Sprite;
					_QBtn.alpha = 0;
					_QBtn = this._Panel.getChildByName("QBtn0") as Sprite;
					_QBtn.alpha = 1;
					this._Panel.setChildIndex(_QBtn, this._Panel.numChildren - 1);
					(this._CurrentTabM == 4)?this._Panel.setChildIndex(this._Panel.getChildByName("QualityM"), this._Panel.numChildren - 1):this._Panel.setChildIndex(this._Panel.getChildByName("QualityS"), this._Panel.numChildren - 1);
				}
				this._CurrentQBtn = 0;
				this.RemoveQBtn();
				
				this._CurrentTabM = int(_Num);
				this.TabMFactory(this._onTabElement[this._CurrentTabM], this._CurrentTabM);
				for (var i:int = 0; i < 5; i++) 
				{
					_Tab = this._Panel.getChildByName("Tam" + i) as MovieClip;
					_TabS = _Tab.getChildByName("Tab" + i) as MovieClip;
					if (_TabS != null) this._SharedEffect.RemoveMovieClipMouseEffect(_TabS);
					this._Panel.removeChild(_Tab);
				}
				//if (this._CurrentTabM == 0) this.PropertyMove(this._CurrentTabM, false);
				var _TextField:TextField;
				_TextField = TextField(this._Panel.getChildByName("TextInput0"));
				_TextField.text = "請輸入搜尋名稱";
				_TextField.setTextFormat(this._TextStyle);
				_TextField = TextField(this._Panel.getChildByName("TextInput1"));
				_TextField.text = "請輸入價格上限";
				_TextField.setTextFormat(this._TextStyle);
				var _PropertyField:Sprite;
				
				this.SendNotify(UICmdStrLib.ReSet);
				this._Panel.getChildByName("Buy").visible = false;
				
				(this._CurrentTabM == 4)?this.AddQBtn(9):this.AddQBtn(5);
				this.CtrlSortBtn(false);
			}
		}
		
		private function PropertyMove(_Num:int, _CtrlBoolean:Boolean):void 
		{
			this._ClickBoolean = false;
			var _Value:int;
			(_CtrlBoolean == false)?_Value = -53:_Value = 53;
			
			var _ValueNum:int;
			(_CtrlBoolean == false)?_ValueNum = -30:_ValueNum = 30; 
			var _PropertyField:Sprite = Sprite(this._Panel.getChildByName("PropertyField" + 6));
				_PropertyField.visible = _CtrlBoolean;
				
			var _TitleBtn:Sprite = Sprite(this._Panel.getChildByName("TitleBtn" + _Num));
				_TitleBtn.visible = _CtrlBoolean;
			var _SortBtn:Sprite = Sprite(this._Panel.getChildByName("SortBtn" + _Num));
				_SortBtn.visible = _CtrlBoolean;
			var _PropertyBit:Bitmap = Bitmap(this._Panel.getChildByName("PropertyBit" + 6));
				_PropertyBit.visible = _CtrlBoolean;
			for (var i:int = 0; i < 7; i++) 
			{
				_TitleBtn = Sprite(this._Panel.getChildByName("TitleBtn" + (i + 1)));
				TweenLite.to(_TitleBtn, 0.5, { x:_TitleBtn.x + _Value } );
				_SortBtn = Sprite(this._Panel.getChildByName("SortBtn" + (i + 1)));
				TweenLite.to(_SortBtn, 0.5, { x:_SortBtn.x + _Value } );
				if (i != 6) { 
					_PropertyBit = Bitmap(this._Panel.getChildByName("PropertyBit" + i));
					TweenLite.to(_PropertyBit, 0.5, { x:_PropertyBit.x + _Value } );
					
					_PropertyField = Sprite(this._Panel.getChildByName("PropertyField" + i));
					TweenLite.to(_PropertyField, 0.5, { y:_PropertyField.y + _ValueNum } );
				}
			}
			var _Fatigue:Bitmap = Bitmap(this._Panel.getChildByName("Fatigue"));
			TweenLite.to(_Fatigue, 0.5, { x:_Fatigue.x + _Value, onComplete:UpdataClick } );
		}
		private function UpdataClick():void 
		{
			this._ClickBoolean = true;
		}
		
		public function AddBuyMsg():void 
		{
			this._AskPanel.AddInform(0);
			this._AskPanel.AddMsgText("無拍賣商品資料", 0);
		}
		
		public function AddGoodsData(_GoodsData:Vector.<ItemDisplay>, _ValueMax:int, _CtrlPageNum:int):void 
		{
			this.CtrlSortBtn(true);
			this._CurrentListBoard.name = "";
			this._GoodsData = _GoodsData;
			var _Page:int = (_ValueMax / 7);
			if ((_ValueMax % 7) != 0) _Page = _Page + 1;
			var _PageList:int = _Page;
			var _CtrlPageNum:int = _CtrlPageNum;
			
			var _GoodsDataLength:int = _GoodsData.length;
			this._ListBoard = new Vector.<Sprite>;
			for (var i:int = 0; i < _GoodsDataLength; i++) 
			{
				this._ListBoard.push(this.ListBoardMenu(_GoodsData[i], i));
				this._ListBoard[i].x = 190;
				this._ListBoard[i].y = 170 + i * 52;
				this._Panel.addChild(this._ListBoard[i]);
				this._SharedEffect.MouseEffect(this._ListBoard[i]);
				this._ListBoard[i].addEventListener(MouseEvent.CLICK, ListBoardClick);
			}
			
			this._BasisPanel.IntPageData(_PageList, _CtrlPageNum);
		}
		
		//物件清單底板
		private function ListBoardMenu(_CurrentGoods:ItemDisplay = null, _Num:int = 0):Sprite
		{
				var _ListBoardMenu:Sprite = new Sprite();
					_ListBoardMenu.name = "List" + _Num;
					_ListBoardMenu.x = 190;
					_ListBoardMenu.y = 170;
					_ListBoardMenu.buttonMode = true;
				
				var _BgM:Sprite = new (this._BGObj.BgM as Class);
					_BgM.width = 760;
					_BgM.height = 55;
				_ListBoardMenu.addChild(_BgM);
				
				if (_CurrentGoods != null) { 
					_CurrentGoods.ShowContent();
					var _Icon:Sprite = _CurrentGoods.ItemIcon;
						_Icon.width = 48;
						_Icon.height = 48;
						_Icon.x = 5;
						_Icon.y = 3;
					_ListBoardMenu.addChild(_Icon);
					
					this._TextObj._col = this._QBtnColor[_CurrentGoods.ItemData._rank]; //0xFFFFFF;
					this._TextObj._AutoSize = "CENTER";
					this._TextObj._Size = 14;
					this._TextObj._str = _CurrentGoods.ItemData._showName;
					//trace(String(this._TextObj._str).length);
					var _GoodsName:Text = new Text(this._TextObj);
						_GoodsName.x = 133 - _GoodsName.width / 2;
						_GoodsName.y = 17;
					_ListBoardMenu.addChild(_GoodsName);
					
					this._TextObj._col = 0xFFFFFF;
					var _PropertyPanel:Sprite = new Sprite();
						//(this._CurrentTabM == 0)?_PropertyPanel.x = 177:_PropertyPanel.x = 230;
						_PropertyPanel.x = 230;
						_PropertyPanel.y = 17;
						_PropertyPanel.name = "PropertyPanel"+_Num;
					_ListBoardMenu.addChild(_PropertyPanel);
					
					//if (this._CurrentTabM != 0) {
						this._TextObj._str = "" + _CurrentGoods.ItemData._lv;
						var _lvText:Text = new Text(this._TextObj);
							_lvText.x = 4 - _lvText.width / 2;
						_PropertyPanel.addChild(_lvText);
					//}
					
					this._TextObj._str = "" + _CurrentGoods.ItemData._HP;
					var _HPText:Text = new Text(this._TextObj);
						_HPText.x = 57 - _HPText.width / 2;
					_PropertyPanel.addChild(_HPText);
					
					this._TextObj._str = "" + _CurrentGoods.ItemData._attack;
					var _attackText:Text = new Text(this._TextObj);
						_attackText.x = 110 - _attackText.width / 2;
					_PropertyPanel.addChild(_attackText);
					
					this._TextObj._str = "" + _CurrentGoods.ItemData._defense;
					var _defenseText:Text = new Text(this._TextObj);
						_defenseText.x = 163 - _defenseText.width / 2;
					_PropertyPanel.addChild(_defenseText);
					
					this._TextObj._str = "" + _CurrentGoods.ItemData._speed;
					var _speedText:Text = new Text(this._TextObj);
						_speedText.x = 216 - _speedText.width / 2;
					_PropertyPanel.addChild(_speedText);
					
					this._TextObj._str = "" + _CurrentGoods.ItemData._int;
					var _intText:Text = new Text(this._TextObj);
						_intText.x = 269 - _intText.width / 2;
					_PropertyPanel.addChild(_intText);
					
					this._TextObj._str = "" + _CurrentGoods.ItemData._mnd;
					var _mndText:Text = new Text(this._TextObj);
						_mndText.x = 322 - _mndText.width / 2;
					_PropertyPanel.addChild(_mndText);
					
					this._TextObj._str = "" + _CurrentGoods.ItemData._sellMoney;
					var _sellMoneyText:Text = new Text(this._TextObj);
						_sellMoneyText.x = 399 - _sellMoneyText.width / 2;
					_PropertyPanel.addChild(_sellMoneyText);
				}
				
				return _ListBoardMenu;
		}
		
		public function RemoveListBoard():void 
		{
			if (this._ListBoard != null) { 
				var _ListBoardLength:int = this._ListBoard.length;
				for (var i:int = 0; i < _ListBoardLength; i++) 
				{
					this._ListBoard[i].removeChildren();
					this._Panel.removeChild(this._ListBoard[i]);
				}
				this._ListBoard = null;
			}
		}
		
		private function AddSellPanel():void 
		{
			var _SaleBg:Bitmap = new Bitmap(BitmapData(new (this._AuctionObj.SaleBg as Class)));
				_SaleBg.x = 38;
				_SaleBg.y = 150;
				_SaleBg.name = "SaleBg";
				
			var _AlphaBox:Sprite; 
				_AlphaBox = this._SharedEffect.DrawRect(0, 0, _SaleBg.width, _SaleBg.height);
				_AlphaBox.x = _SaleBg.x ;
				_AlphaBox.y = _SaleBg.y ;
				_AlphaBox.name = "SellPanelBox";
				_AlphaBox.alpha = 0;
			this._Panel.addChild(_AlphaBox ); 
				
			this._Panel.addChild(_SaleBg);
			
			var _Box:Bitmap = new Bitmap(BitmapData(new (this._BGObj.Box as Class)));
				_Box.x = 95;
				_Box.y = 180;
				_Box.name = "BoxSell";
			this._Panel.addChild(_Box);
			var _BoxSell:Sprite = this._SharedEffect.DrawRect(0, 0, _Box.width, _Box.height);
				_BoxSell.x = _Box.x;
				_BoxSell.y = _Box.y;
				_BoxSell.name = "BoxSellBox";
				_BoxSell.alpha = 0;
			this._Panel.addChild(_BoxSell);
			this._TipsView.MouseEffect(_BoxSell);
			
			this._BasisPanel.AddFatigue(0.4, 0.4, 77, 450, "SellFatigue");
			
			var _TextBitmap:Bitmap = new Bitmap( BitmapData( new (this._AuctionObj.SearchBox as Class)));
				_TextBitmap.width = 60;
				_TextBitmap.height = 20;
				_TextBitmap.x = 95;
				_TextBitmap.y = 450;
				_TextBitmap.name = "TextBitmapSell";
			this._Panel.addChild(_TextBitmap);
			
			var _PriceTextInput:TextField;
				_PriceTextInput = new TextField();
				_PriceTextInput.type = TextFieldType.INPUT;
				_PriceTextInput.restrict = "0-9";//輸入數字
				_PriceTextInput.maxChars = 9;
				_PriceTextInput.width = _TextBitmap.width;
				_PriceTextInput.height = _TextBitmap.height;
				_PriceTextInput.text = "0";
				_PriceTextInput.x = _TextBitmap.x;
				_PriceTextInput.y = _TextBitmap.y;
				_PriceTextInput.name = "PriceTextInput";
				_PriceTextInput.setTextFormat(this._TextStyle);
			this._Panel.addChild(_PriceTextInput);
			_PriceTextInput.addEventListener(Event.CHANGE, PriceChange);
			this._TipsView.MouseEffect(_PriceTextInput);
			
			this._BasisPanel.AddCheckBtn("密室", 77, 240, 85, "Storage");
			this._TipsView.MouseEffect(this._Panel.getChildByName("Storage"));
			
			this._BasisPanel.AddGrayCheckBtn("掛賣", 77, 475, 85, "NoCheck");
			this._TipsView.MouseEffect(this._Panel.getChildByName("NoCheck"));
			this._BasisPanel.AddCheckBtn("掛賣", 77, 475, 85, "PriceCheck");
			this._Panel.getChildByName("PriceCheck").visible = false;
			this._TipsView.MouseEffect(this._Panel.getChildByName("PriceCheck"));
		}
		
		private function PriceChange(e:Event):void 
		{
			if (this._CtrlPriceBtn == true) {
				this._CurrentInputPrice = TextField(e.currentTarget).text;
				//trace(this._CurrentInputPrice, "@@@@");
				(TextField(e.currentTarget).text == "")?this._Panel.getChildByName("PriceCheck").visible = false:this._Panel.getChildByName("PriceCheck").visible = true;
			}
		}
		
		public function AddSellGoods(_CurrentSellGoods:ItemDisplay):void 
		{
			var _Icon:Sprite = _CurrentSellGoods.ItemIcon;
				_Icon.x = 95;
				_Icon.y = 180;
				_Icon.name = "Icon";
			this._Panel.addChild(_Icon);
			this._CtrlPriceBtn = true;
			
			var _Str:String = _ChangeValue.substr(0, 3);
			if ( _Str == "MSC") this._CurrentIconNum = 0;
			if (_Str == "WPN") this._CurrentIconNum = 1;
			if (_Str == "AMR") this._CurrentIconNum = 2;
			if (_Str == "ACY") this._CurrentIconNum = 3;
			if (_Str == "MOB") this._CurrentIconNum = 4;
			_Icon.addEventListener(MouseEvent.ROLL_OVER, MouseBtnEffect);
			_Icon.addEventListener(MouseEvent.ROLL_OUT, MouseBtnEffect);
		}
		private function MouseBtnEffect(e:MouseEvent):void 
		{
			switch (e.type) 
			{
				case "rollOver":
					if (this._CurrentIconNum == 0) this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Sell", ProxyPVEStrList.TIP_STRBASIC, "SysTip_MCS", PlaySystemStrLab.Package_Stone, { _guid:_CurrentItemDisplay.ItemData._guid }, _CurrentTarget.x + _Panel.x - 7, _CurrentTarget.y + _Panel.y + 27));
					if (this._CurrentIconNum == 1) this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Sell", ProxyPVEStrList.TIP_STRBASIC, "SysTip_WPN", PlaySystemStrLab.Package_Weapon, { _guid:_CurrentItemDisplay.ItemData._guid, _type:_CurrentItemDisplay.ItemData._type, _group:_CurrentItemDisplay.ItemData._gruopGuid }, _CurrentTarget.x + _Panel.x - 7, _CurrentTarget.y + _Panel.y + 27));
					if (this._CurrentIconNum == 2) this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Sell", ProxyPVEStrList.TIP_STRBASIC, "SysTip_AMR", PlaySystemStrLab.Package_Shield, { _guid:_CurrentItemDisplay.ItemData._guid, _type:_CurrentItemDisplay.ItemData._type, _group:_CurrentItemDisplay.ItemData._gruopGuid }, _CurrentTarget.x + _Panel.x - 7, _CurrentTarget.y + _Panel.y + 27));
					if (this._CurrentIconNum == 3) this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips("Sell", ProxyPVEStrList.TIP_STRBASIC, "SysTip_ACY", PlaySystemStrLab.Package_Accessories, { _guid:_CurrentItemDisplay.ItemData._guid, _type:_CurrentItemDisplay.ItemData._type, _group:_CurrentItemDisplay.ItemData._gruopGuid }, _CurrentTarget.x + _Panel.x - 7, _CurrentTarget.y + _Panel.y + 27));
					if (this._CurrentIconNum == 4) this.SendNotify(PVECommands.TimeLineCOmelete_TipCMD, new SendTips( "Sell", ProxyPVEStrList.TIP_STRBASIC,  "SysTip_AC_MOB", ProxyPVEStrList.EXCHANGE_MONSTER, { _guid:_CurrentItemDisplay.ItemData._guid },  _CurrentTarget.x + _Panel.x - 7, _CurrentTarget.y + _Panel.y + 27));
				break;
				case "rollOut":
					TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();
				break;
			}
		}
		
		public function RemoveSellGoods():void 
		{
			if (this._Panel.getChildByName("Icon") != null) this._Panel.removeChild(this._Panel.getChildByName("Icon"));
			TextField(this._Panel.getChildByName("PriceTextInput")).text = "";
			this._Panel.getChildByName("PriceCheck").visible = false;
			this._CtrlPriceBtn = false;
		}
		
		public function CurrentSellData(_CurrentSellData:Vector.<ItemDisplay>):void 
		{
			//this._SlidingControl.ClearStage(true);
			this.RemoveListBoard();
			this._PageList = this._SplitPageMethod.SplitPage(_CurrentSellData, 7);
			this.CtrlPage(this._CtrlPageNum, true);
		}
		public function CtrlPage( _InputPage:int , _CtrlBoolean:Boolean = true ):void
		{
			this._CtrlPageNum = _InputPage;
			var _MyPage:Array = this._PageList[_InputPage];
			var _MyPageLength:uint = (_MyPage == null)?0:_MyPage.length;
			this._ListBoard = new Vector.<Sprite>;
			
			for (var i:int = 0; i < _MyPageLength; i++) 
			{
				this._ListBoard.push(this.ListBoardMenu(_MyPage[i], i));
				this._ListBoard[i].x = 190;
				this._ListBoard[i].y = 170 + i * 52;
				this._Panel.addChild(this._ListBoard[i]);
				this._SharedEffect.MouseEffect(this._ListBoard[i]);
			}
			this._BasisPanel.PageData(this._PageList, this._CtrlPageNum);
		}
		
		private function ListBoardClick(e:MouseEvent):void 
		{
			if (this._CurrentListBoard.name != e.currentTarget.name) {
				TweenLite.to(this._CurrentListBoard, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
				this._SharedEffect.MouseEffect(this._CurrentListBoard);
				this._CurrentListBoard.buttonMode = true;
				
				this._CurrentListBoard = e.currentTarget as Sprite;
				this._CurrentListBoard.name = e.currentTarget.name;
				this._CurrentListBoard.buttonMode = false;
				this._SharedEffect.RemoveMouseEffect(this._CurrentListBoard);
				TweenLite.to( this._CurrentListBoard, 0, { glowFilter: { color:0x66FF66, blurX:17, blurY:17, strength:3, alpha:.7 }} );
				
				var _Num:String = String(e.currentTarget.name).substr(4, 1);
				this._BuyCurrentGoods = this._GoodsData[int(_Num)];
				this._BuyData = { sellMoney:this._BuyCurrentGoods.ItemData._sellMoney, guid:this._BuyCurrentGoods.ItemData._guid };
				this._Panel.getChildByName("Buy").visible = true;
			}
			
		}
		
		private function SortMove(_Num:int, _CtrlBoolean:Boolean):void 
		{
			var _SortBtn:Sprite = this._Panel.getChildByName(this._SortBtnName[_Num]) as Sprite;
			if (_CtrlBoolean == true) {
				_SortBtn.scaleY = -1;
				_SortBtn.y = 165;
			}else {
				_SortBtn.scaleY = 1;
				_SortBtn.y = 151;
			}
		}
		
		private function InitialSort():void 
		{
			for (var i:int = 0; i < 8; i++) 
			{
				this._Sort[i] = false;
				this.SortMove(i, this._Sort[i]);
			}
			this._BasisPanel.IntPageData(0, 0);
			//this.SendNotify(UICmdStrLib.ReSet);
		}
		
		public function AddSuccessBuyMsg(_CtrlBoolean:Boolean = true):void 
		{
			if (_CtrlBoolean == true) { 
				this.RemoveListBoard();
				this._AskPanel.AddInform(1);
				this._AskPanel.AddMsgText("已從交易黑市取得", 0, 80);
				var _Icon:Sprite = this._BuyCurrentGoods.ItemIcon;
					_Icon.width = 48;
					_Icon.height = 48;
					_Icon.x = 190;
					_Icon.y = 120;
				Sprite(this._viewConterBox.getChildByName("Inform")).addChild(_Icon);
			}else {
				this._AskPanel.AddInform(0);
				this._AskPanel.AddMsgText("金錢不足", 0);
			}
		}
		
		public function AddErrorMsg(_Msg:String):void 
		{
			this._AskPanel.AddInform(0);
			this._AskPanel.AddMsgText(_Msg, 0);
		}
		
		private function QualityMove():void 
		{
			var _QBtn:Sprite;
			for (var i:int = 0; i < this._QBtnLength; i++) 
			{
				_QBtn = this._Panel.getChildByName("QBtn" + i) as Sprite;
				TweenLite.to(_QBtn, 0.3, { y:(this._QBtnBoolean == true)?235:_QBtn.y + (i * 25), alpha:(this._QBtnBoolean == true)?(i != this._CurrentQBtn)?0:null:1 , delay: i * 0.05, onComplete:this.CtrlQuality, onCompleteParams:[(this._CurrentTabM == 4)?8:4, i] } );
			}
		}
		private function CtrlQuality(_Num:int, i:int):void 
		{
			if (i == _Num) { 
				(this._QBtnBoolean == true)?this._QBtnBoolean = false:this._QBtnBoolean = true;
				var _Quality:Sprite;
				(this._CurrentTabM == 4)?_Quality = Sprite(this._Panel.getChildByName("QualityM")):_Quality = Sprite(this._Panel.getChildByName("QualityS"));
				if (this._QBtnBoolean == false) {
					_Quality.scaleY = 1;
					_Quality.y = 240;
				}else {
					_Quality.scaleY = -1;
					_Quality.y = 255;
				}
				this._Panel.setChildIndex(this._Panel.getChildByName("QBtn" + this._CurrentQBtn), this._Panel.numChildren - 1);
				this._Panel.setChildIndex(_Quality, this._Panel.numChildren - 1);
				this._QBtnClick = true;
			}
		}
		
		private function CtrlSortBtn(_CtrlBoolean:Boolean):void 
		{
			for (var i:int = 0; i < 8; i++) 
			{
				this._Panel.getChildByName(this._SortBtnName[i]).visible = _CtrlBoolean;
			}
		}
		
		private function QBtnClick(e:MouseEvent):void 
		{
			if (this._QBtnClick == true) { 
				var _Num:int = int(String(e.currentTarget.name).substr(4, 1));
				this._CurrentQBtn = _Num;
				this._QBtnClick = false;
				this.QualityMove();
				
				this._SetSearch["EXCHANGE"] = ProxyPVEStrList.EXCHANGE_SEA_QUALITY;
				this._SetSearch["NAMEONE"] = _Num;
				this.SendNotify(UICmdStrLib.SetSearch, this._SetSearch);
			}
		}
		
		private function playerClick(e:MouseEvent):void 
		{
			var _CurrentName:String = e.target.name;
			var _Num:String;
			if (_CurrentName.substr(0, 1) == "S")  _Num = _CurrentName.substr(7, 1);
			if (_CurrentName.substr(0, 1) == "T") _Num = _CurrentName.substr(3, 1);
			
			if (this._SellCtrl == true) {
				for (var i:int = 0; i < 8; i++) 
				{
					var _Str:String = this._SortBtnName[i] as String;
					if (_Str == _CurrentName) { 
						var _upDown:String;
						(this._Sort[i] == true)?this._Sort[i] = false:this._Sort[i] = true;
						(this._Sort[i] == true)?_upDown = "desc":_upDown = "asc";
						var _SortData:Object = { type:_Str, upDown:_upDown };
						this.SendNotify(UICmdStrLib.Sort, _SortData);
						this.SortMove(i, this._Sort[i]);
						this.RemoveListBoard();
					}
				}
			}
			
			switch (_CurrentName) 
			{
				case "Tab"+ _Num:
				case "Tam"+ _Num:
					if (this._SellCtrl == true) this.TabClick(_Num);
				break;
				case "Search":
					var _SetSearch:Object = { };
						_SetSearch["CurrentTab"] = this._CurrentTabM;
					this.SendNotify(UICmdStrLib.StartSearch, _SetSearch);
					this.RemoveListBoard();
					this.InitialSort();
					this._QBtnBoolean = true;
					this.QualityMove();
				break; 
				case "Buy":
					this.SendNotify(UICmdStrLib.BuyGoods, this._BuyData);
				break; 
				case "BuySell":
				case "Sell":
					if (this._SellCtrl == true) { 
						if (this._Panel.getChildByName("SellPanelBox") == null) this.AddSellPanel();
						this.RemoveListBoard();
						this._BasisPanel.IntPageData(0, 0);
						this.SendNotify(UICmdStrLib.GetPlayerSellList);
						this._SellCtrl = false;
						Text(Sprite(this._Panel.getChildByName("Sell")).getChildByName("SellText")).ReSetString("交易");
						//if (this._CurrentTabM == 0) this.PropertyMove(1, true);
						this._Panel.getChildByName("Buy").visible = false;
						Sprite(this._Panel.getChildByName("Sell")).name = "BuySell";
						this.CtrlSortBtn(false);
					}else {
						this.RemoveListBoard();
						this._BasisPanel.IntPageData(0, 0);
						this._SellCtrl = true;
						Text(Sprite(this._Panel.getChildByName("BuySell")).getChildByName("SellText")).ReSetString("掛賣");
						Sprite(this._Panel.getChildByName("BuySell")).name = "Sell";
						this._Panel.removeChild(this._Panel.getChildByName("SellPanelBox"));
						this._Panel.removeChild(this._Panel.getChildByName("BoxSell"));
						this._Panel.removeChild(this._Panel.getChildByName("SaleBg"));
						this._Panel.removeChild(this._Panel.getChildByName("TextBitmapSell"));
						this._Panel.removeChild(this._Panel.getChildByName("PriceTextInput"));
						this._Panel.removeChild(this._Panel.getChildByName("Storage"));
						this._Panel.removeChild(this._Panel.getChildByName("NoCheck"));
						this._Panel.removeChild(this._Panel.getChildByName("PriceCheck"));
						this._Panel.removeChild(this._Panel.getChildByName("SellFatigue"));
						this._Panel.removeChild(this._Panel.getChildByName("BoxSellBox"));
						//if (this._CurrentTabM == 0) this.PropertyMove(this._CurrentTabM, false);
						this._Panel.getChildByName("Buy").visible = false;
						this._CtrlPriceBtn = false;
						if (this._Panel.getChildByName("Icon") != null) this._Panel.removeChild(this._Panel.getChildByName("Icon"));
					}
				break;
				case "Storage":
					var _GetPlayerSellGoods:Object = { PlayerSell:PlaySystemStrLab.Package_Stone, CtrlBoolean:true };
					this.SendNotify(UICmdStrLib.GetPlayerSellGoods, _GetPlayerSellGoods);
					TextField(this._Panel.getChildByName("PriceTextInput")).text = "0";
				break;
				case "PriceCheck":
					var _SellGoods:Object = { Money:this._CurrentInputPrice };
					this.SendNotify(UICmdStrLib.SellGoods, _SellGoods);
				break;
				
				case "TextInput0":
				case "TextInput1":
				case "PropertyTextInput0":
				case "PropertyTextInput1":
				case "PriceTextInput":
					TextField(e.target).text = "";
				break; 
				
				case "QualityM":
				case "QualityS":
					this.QualityMove();
				break;
				
				case "Make0":
					this._AskPanel.RemovePanel();
				break;
			}
			
		}
		
		override public function onRemoved():void 
		{
			this._viewConterBox.removeEventListener(MouseEvent.CLICK, playerClick);
			this._viewConterBox.removeChild(this._viewConterBox.getChildByName("AuctionBox"));
			this._viewConterBox.removeChild(this._Panel);
			//this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
			//MianViewCenter(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER)).LockAndUnlock(true);
		}
		
	}
}