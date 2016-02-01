package MVCprojectOL.ViewOL.MainView
{
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Alchemy.AlchemyDataCenter;
	import MVCprojectOL.ModelOL.Building.BuildingProxy;
	import MVCprojectOL.ModelOL.DataRecovery.DataRecoveryCenter;
	import MVCprojectOL.ModelOL.Library.LibraryProxy;
	import MVCprojectOL.ModelOL.Monster.PlayerMonsterDataCenter;
	import MVCprojectOL.ModelOL.MonsterRecovery.MonsterRecoveryProxy;
	import strLib.commandStr.WorldJourneyStrLib;
	//import MVCprojectOL.ModelOL.ShowSideSys.SendTips;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import strLib.proxyStr.ArchivesStr;
	//import MVCprojectOL.ModelOL.TimeLine.TestTimeLineCommands;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineObject;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineProxy;
	import MVCprojectOL.ModelOL.VoGroupCallCenter;
	import MVCprojectOL.ViewOL.TipsView.TipsCenterView;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.commandStr.DissolveStrLib;
	import strLib.commandStr.PVECommands;
	import strLib.commandStr.StorageStrLib;
	import strLib.commandStr.UICmdStrLib;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewStrLib;
	//import MonsterCage.Command.CatchMonsterCageControl;
	import Spark.coreFrameWork.observer.Observer;
	import strLib.commandStr.MonsterCageStrLib;
	import strLib.commandStr.TeamCmdStr;
	import strLib.commandStr.ViewSystem_BuildCommands;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class MainViewSpr extends Sprite
	{
		
		private var _funSendNotify:Function;
		private var _safeConter:DisplayObjectContainer;
		//private var _indexX:Array = [0,62,740,534,180,0,0,511];
		//private var _indexY:Array = [0, 98, 137, 254, 269, 0, 201, 392];
		
	
		//private var _indexX:Array = [0,11,774,506,194,733,5,493];
		//private var _indexY:Array = [0, 76, 128, 214, 223, 301, 307, 402];
		
		//-----new----
		//---順序(0是背景)>組隊/進化/煉金/熔解/PVP/惡魔/背包/圖書館
		private var _indexX:Array = [0,756,523,359,190,-29,463,662,768,4];
		private var _indexY:Array = [0,24,72,99,149,107,296,353,357,367];
		private var _buildType:Array = [];
		//private var _vectorBuildTips:Vector.<String> = new Vector.<String>();
		private var _dicTips:Dictionary;
		private const _tipsKey:String = "SysTip_BLD";
		public function MainViewSpr(_conter:DisplayObjectContainer,_send:Function) 
		{
			this._funSendNotify = _send;
			this._safeConter = _conter;
			this._dicTips = new Dictionary(true);
			TweenPlugin.activate([GlowFilterPlugin]);
		}
		
		
		public function AddSource(_ary:Array):void 
		{
			trace("getMainView_Source");
		    for (var i:int = 0; i < 10;i++ ) {
			    //if (i!= 5) {
					var _class:Class = _ary[i];
					//var _class:Class = (i==8)?null:_ary[i];
					//var _pic:Bitmap = (_class != null)?new Bitmap(new _class()):null; 
					var _pic:Bitmap = new Bitmap(new _class()); 
					if (i!=0) {
						/*
						if (i==8 && _pic==null) {	
							var _picBitmap:Bitmap = new Bitmap(new _ary[7]);
							_pic = new Bitmap(SourceProxy.GetInstance().RotationImg(_picBitmap, true));
						}*/
						
						var _sprPic:HouseStatus = new HouseStatus();
						_sprPic.addChild(_pic);
						_sprPic.buttonMode = true;
						_sprPic.name = "btn" + i;
						_sprPic._guid = this.getBuilGuidHandler(i);
						//_sprPic._tips = BuildingProxy.GetInstance().GetBuildingInfo(_sprPic._guid);
						trace("NAME___"+_sprPic.name);
						_sprPic.addEventListener(MouseEvent.CLICK,onClickHandler);
						_sprPic.addEventListener(MouseEvent.ROLL_OVER,onClickHandler);
						_sprPic.addEventListener(MouseEvent.ROLL_OUT, onClickHandler);
						_sprPic.addEventListener(MouseEvent.MOUSE_MOVE, onClickHandler);
						_sprPic.mouseEnabled = false;
						//_sprPic.x =(i==8)?200:_indexX[i];
				        //_sprPic.y = (i == 8)?402:_indexY[i];
						
						_sprPic.x =_indexX[i];
				        _sprPic.y =_indexY[i];
						this.addChild(_sprPic);
					
				}else {
					
					this.addChild(_pic);
				}
				
				
				
			}	
			//this.mouseEnabled = false;
			this._funSendNotify(ViewSystem_BuildCommands.MAINVIEW_COMPLETE);
		
		}
		
		//---素材順序>//---順序(0是背景)>組隊/進化/煉金/熔解/PVP/惡魔/背包/圖書館
		//--建築種類：1.大廳（魔法陣）, 2.巢穴, 3.溶解所, 4.圖書館, 5.儲藏室, 6.煉金所, 7.牢房, 8.英靈室9.進化室 10.PVP 11.探索
		private function getBuilGuidHandler(_id:int):String
		{
			
			var _type:int;
			switch(_id) {
				case 1:
					//_type = 7;
				//-------佔代
				_type = 11;
				break;
				
				case 2:
				//_type = 8;
				//---佔代
				_type = 9;
				break;
				
				case 3:
				_type =6;
				break;
				
				case 4:
				_type = 3;
				break;
				
			    case 5:
				_type = 1;
				break;
				
			    case 6:
				_type = 10;
				break;
				
			    case 7:
				//_type = 2;
				_type = 5;
				break;
				
			   case 8:
				_type = 2;
				//_type = 4;
				break;
				
				case 9:
				_type = 4;
				break;
				
			}
			
			var _guid:String = BuildingProxy.GetInstance().GetBuildingGuid(_type);
			return _guid;
		}
		
		
		private function initAddEventListener():void 
		{
			this._safeConter.addChild(this);
			//this.alpha = .5;
			//this.addEventListener(MouseEvent.CLICK,onClickHandler);
			//this.addEventListener(MouseEvent.ROLL_OVER,onClickHandler,true);
			//this.addEventListener(MouseEvent.ROLL_OUT, onClickHandler, true);
			//this.addEventListener(MouseEvent.MOUSE_MOVE, onClickHandler, true);
			
			for (var i:int = 1; i <= 9;i++ ) {
				//var _index:int = (i >= 4)?i + 2:i + 1;
				var _spr:HouseStatus = this.getChildByName("btn"+i) as HouseStatus;
				_spr.mouseEnabled = true;
			}
			
			
			
			
			/*
			var _text:TextField = new TextField();
			_text.textColor = 0xffffff;
			_text.text = TimeLineObject.GetTimeLineObject().CheckTime();
			this.addChild(_text);
			_text.y = 80;
			_text.width = 400;
			*/
			//----get tween--------
		}
		
		public function LockAndUnlock(_flag:Boolean):void 
		{
			for (var i:int = 1; i <= 9;i++ ) {
				//var _index:int = (i >= 4)?i + 2:i + 1;
				var _spr:HouseStatus = this.getChildByName("btn"+i) as HouseStatus;
				_spr.mouseEnabled = _flag;
			}
			
		}
		
		public function InitShow():void 
		{
			this.initAddEventListener();
			
		}
		
		
		private function onClickHandler(e:MouseEvent):void 
		{
			//trace("MainView>>" + e.type);
			
			switch(e.type) {
				case "click":
					//var _name:String = e.currentTarget.name;
					//trace("hello");
					this.clickHandler(e.currentTarget.name,e.currentTarget._guid);	
				break;	
			   	
			    case "rollOver":
				
				TweenLite.to(e.currentTarget, 0, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }} );
				//----2013/1/11---tipsTEST---
			    this._funSendNotify(PVECommands.TimeLineCOmelete_TipCMD,new SendTips("MainViewSpr",ProxyPVEStrList.TIP_STRBASIC,this._tipsKey,"buildTips",{_guid:e.currentTarget._guid},this.mouseX,this.mouseY));
				
			
				break;
				
			    case "rollOut":
				//TweenLite.to(e.target, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
				TweenLite.to(e.currentTarget, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} );
				TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();
				break;
				
			    case"mouseMove":
				TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).TipsMove(this.mouseX,this.mouseY);
				
				break;
				
				
			}
			
			
		}
		
		/*
		private function getTipsKey(_id:String):String 
		{
			switch() {
				
				
				
			}
			
			
			
		}
		*/
		
		private function clickHandler(_str:String,_guid:String=""):void 
		{
			
			trace("click>" + _str);
			
			
			var _buildGuid:String = _guid;
			this.LockAndUnlock(false);
			if (BuildingProxy.GetInstance().GetBuildingEnable(_buildGuid)) {
				
				//if (_str != "btn1" ) {
				  //---2013/2/20---系統交換的時後重整要傳送的資訊----
				  DataRecoveryCenter.GetDataRecoveryCenter().ResetGlobalTimes();
				  DataRecoveryCenter.GetDataRecoveryCenter().AddVoGroup(this);
				  VoGroupCallCenter.GetVoGroupCallCenter().VoGroupCall();
				  this._funSendNotify(ViewSystem_BuildCommands.MAINVIEW_SWICH,{_btnName:_str});	
				
			    //}
				
				switch(_str) {
				//----王國探索------
				case "btn1":
				  
				  this._funSendNotify( WorldJourneyStrLib.InitWorldJourneyCommand ); 
				 
				break;	
			   
			    case "btn2":
				//----進化------
				this._funSendNotify( UICmdStrLib.Init_Evolution );


				break;
				//----煉金
			    case "btn3":
				//--Alchemy system-----
				  this._funSendNotify( UICmdStrLib.Init_Alchemy );
				
				break;
				
				//----熔解所---
			    case "btn4":
				//----熔解所---
				this._funSendNotify(DissolveStrLib.Init_DissolveCatch);
				break;
				
				
				//---組隊
			    case "btn5":
				this._funSendNotify(ArchivesStr.CREW_DEFAULT_SHOW);
			
				break;
				//--PVP---
			    case "btn6":
				
				//--PVP---
				this._funSendNotify( UICmdStrLib.Init_PVP ); //PVP
				
				
				break;
				
			   //---儲藏室	
			    case "btn7":
				//---儲藏室
				this._funSendNotify(StorageStrLib.Init_StorageCatch);
				
				
			   break;
			   
			   //----monster 
		       case "btn8":
			    
				//---monster
				this._funSendNotify(MonsterCageStrLib.init_MonsterCatchCore);	
			   
			   break;
			   
			   
			   case "btn9":
			    //----Library system----
				this._funSendNotify( UICmdStrLib.Init_Library );	
			   
			   break;
				
			 }
	
			}
	
			//if(_str!="btn5")this._funSendNotify(ViewSystem_BuildCommands.MAINVIEW_REMOVE); 
		
		}
		
		public function RemoveHandler():void 
		{
			this.removeEventListener(MouseEvent.CLICK,onClickHandler);
			this.removeEventListener(MouseEvent.ROLL_OVER,onClickHandler,true);
			this.removeEventListener(MouseEvent.ROLL_OUT, onClickHandler, true);
			
			while (this.numChildren > 0) { this.removeChildAt(0) };
			this._safeConter.removeChild(this);
			trace("removeMain_view");
		}
		
		
		
	}
	
}
import flash.display.Sprite;

class HouseStatus extends Sprite {
	
	//public var _id:int = 0;
	public var _guid:String = "";
	public var _tips:String = "";
	
	

}
