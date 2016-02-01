package  MVCprojectOL.ViewOL.MainView
{
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import MVCprojectOL.ControllOL.Mail.MailStrLib;
	import MVCprojectOL.ControllOL.SoundControlCenter.SoundEventStrLib;
	import MVCprojectOL.ModelOL.Building.BuildingProxy;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.Exchange.ExchangeProxy;
	import MVCprojectOL.ModelOL.MissionCenter.MissionProxy;
	import MVCprojectOL.ModelOL.Monster.PlayerMonsterDataCenter;
	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import MVCprojectOL.ModelOL.MonsterEvolution.EvolutionProxy;
	import MVCprojectOL.ModelOL.ShopMall.ShopMallData;
	//import MVCprojectOL.ModelOL.ShowSideSys.PreviewBox;
	//import MVCprojectOL.ModelOL.ShowSideSys.PreviewSysBox;
	//import MVCprojectOL.ModelOL.ShowSideSys.SendTips;
	//import MVCprojectOL.ModelOL.ShowSideSys.ShowTipsInfoProxy;
	//import MVCprojectOL.ModelOL.ShowSideSys.TipCreatCenter;
	import MVCprojectOL.ModelOL.TimeLine.TimeLineObject;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	//import MVCprojectOL.ModelOL.Vo.Get.Get_Mission;
	//import MVCprojectOL.ModelOL.Vo.MissionVO.Mission;
	import MVCprojectOL.ViewOL.IfMenuConter;
	import MVCprojectOL.ViewOL.TipsView.TipsCenterView;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import strLib.commandStr.MajidanStrLib;
	import strLib.commandStr.PVECommands;
	import strLib.commandStr.UICmdStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.commandStr.WorldJourneyStrLib;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewStrLib;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class MainWall extends Sprite implements IfMenuConter 
	{
		private var _aryPic:Array;
		private var _sendFun:Function;
		private var _publicFun:Function;
		private var _showConter:DisplayObjectContainer;
		private var _boxConter:Sprite;
	    private var _scaleMax:Number = 52 * 1.4;
		private var _ratio:Number = 0.5;
		//----所空的間距--
		private var _space:Number = 5;
		private var _btnNum:int = 0;
		private var _btnBoxConter:Sprite;
		//---測試用--
		//private var _PreviewSysBox:PreviewSysBox
		public function MainWall()
		{
			this._aryPic = [];
		}
		
		public function AddVaules(_vaules:*):void{};
		
		public function onCreat(_notifyfun:Function,_publicFun:Function,_spr:DisplayObjectContainer):void 
		{
			this._sendFun = _notifyfun;
			this._publicFun = _publicFun;
			this._showConter = _spr;
			this._btnBoxConter = new Sprite();
			
			
			
		}
		
		
		public function AddSource(_key:String,_obj:*):void 
		{
		   var _test:Sprite;
			if (_key=="" && _obj!=null) {
			    this._boxConter = new Sprite(); 
			    this._btnNum= _obj.length - 2;
				//this._btnNum = _len;
				for (var i:int = 0; i < this._btnNum;i++ ) {
					//var _index:int = (i<1)?i:i+1;
					var _spr:Sprite = new Sprite();
					_spr.name = "item" + i;
					var _bitmap:Bitmap = new Bitmap(_obj[i]);
					//var _bitmap:Bitmap = new Bitmap(_obj[_index]);
					_spr.addChild(_bitmap);
					_spr.x = i * (_spr.width + this._space);
					//_spr.x = _index * (_spr.width + this._space);
					_spr.addEventListener(MouseEvent.CLICK, mouseEventHandler);
					_spr.addEventListener(MouseEvent.ROLL_OVER, mouseEventHandler);
					_spr.addEventListener(MouseEvent.ROLL_OUT, mouseEventHandler);
					_spr.addEventListener(MouseEvent.MOUSE_MOVE, mouseEventHandler);
					_spr.buttonMode = true;
					this._boxConter.addChild(_spr);
				    //if (i == 3)_test = _spr;
				}
				var _shape:Shape = new Shape();
				_shape.graphics.beginFill(0);
				_shape.graphics.drawRect(0, 0, this._boxConter.width+100,this._boxConter.height+10);
				 _shape.alpha = 0;
				 this._btnBoxConter.addChild(_shape);
				 
				 this._btnBoxConter.addChild(this._boxConter);
				 this._boxConter.x = this._btnBoxConter.width - this._boxConter.width >> 1;
				 this._boxConter.y = this._btnBoxConter.height - this._boxConter.height >> 1;
				 //this._showConter.addChild(this._boxConter);
				 //var _width:Number = this._showConter.width;
				 this._btnBoxConter.name = "btmWallConter";
				 this._showConter.addChild(this._btnBoxConter);
				 this._btnBoxConter.x = 580;
				 this._btnBoxConter.y = 65;
				 //this._btnBoxConter.x = this._showConter.width-this._btnBoxConter.width;
				 //this._btnBoxConter.y = this._showConter.height-this._btnBoxConter.height>>1;
				 
				 /*
				 this._boxConter.x = 650;
				 this._boxConter.y = 65;
				 */
				  //var _index:Number=this._showConter.numChildren;
				 this._btnBoxConter.addEventListener(MouseEvent.ROLL_OVER, onOverHandler);				
				 this._btnBoxConter.addEventListener(MouseEvent.ROLL_OUT, onOverHandler);
				 //this.ShineTheTarget(_test);
				 if (MissionProxy(ProjectOLFacade.GetFacadeOL().GetProxy(ProxyPVEStrList.MISSION_PROXY))!=null) {
					 
					var _missionCheck:Array = MissionProxy(ProjectOLFacade.GetFacadeOL().GetProxy(ProxyPVEStrList.MISSION_PROXY)).GetMissionCompleteWall();
					 if (_missionCheck.length>0 && _missionCheck!=null) { 
						this.ShineTheTarget(_missionCheck[0]);
						MissionProxy(ProjectOLFacade.GetFacadeOL().GetProxy(ProxyPVEStrList.MISSION_PROXY)).SetMissionCompleteWall([]);
						_missionCheck = null;
					 } 
					 
				}
				 
				 
				 
			}
			
		}
		
		
		//---閃爍
		public function ShineTheTarget(_flag:Boolean):void
		{
			var _target:Sprite = Sprite(this._boxConter.getChildByName("item1"));
			if (_flag==false) {
				this.removeheadBoxDeshine(_target);
				} else {
				if(!TweenMax.isTweening(_target))this.effectComplete(_target,false,0);
			}
			
			//target = (target!=null)?target:_target;
		}

		private function effectComplete(target:DisplayObject,isNormal:Boolean,count:int):void
		{
			if (target!=null) {
				
			count++;
			var param:Object = { onComplete:this.effectComplete, onCompleteParams:[target,!isNormal ,count] };
			param.glowFilter = isNormal ? { color:0x40E0D0, alpha:0, blurX:0, blurY:0 } : { color:0x40E0D0, alpha:1, blurX:10, blurY:10 } ;
			TweenMax.to(target, .5, param) 
			//(count % 2 !=0) ? TweenMax.to(target, .5, param) : this.RemoveheadBoxDeshine(target);	
			}
			
		}

		private function removeheadBoxDeshine(target:DisplayObject):void
		{
			//var _target:Sprite = Sprite(this._boxConter.getChildByName("item3"));
			//target = (target!=null)?target:_target;
			if (TweenMax.isTweening(target)==true) {
				TweenMax.killTweensOf(target);
				target.filters = [];
			}
			
		}
		
		//---閃爍
		
		
		private function onOverHandler(e:MouseEvent):void 
		{
			
			if (e.type=="rollOver") { 
				if(this._boxConter.hasEventListener(Event.ENTER_FRAME)==false)this._boxConter.addEventListener(Event.ENTER_FRAME,onEnterHandler);
				
				} else {
				if (this._boxConter.hasEventListener(Event.ENTER_FRAME)) {
				  this._boxConter.removeEventListener(Event.ENTER_FRAME, onEnterHandler);
				  for (var i:int = 0; i < this._btnNum ;i++ ) {
					var _spr:Sprite = this._boxConter.getChildByName("item" + i) as Sprite;
					_spr.scaleX = _spr.scaleY = 1;
					_spr.x = i * (_spr.width + this._space);
				 }
				}
				
			}
		}
		
		
		public function LockAndUnLock(_flag:Boolean):void 
		{
			
			for (var i:int = 0; i < this._btnNum;i++ ) {
				var _Sprite:Sprite = this._boxConter.getChildByName("item"+i) as Sprite;
				_Sprite.mouseEnabled = _flag;
			}
			//this._btnBoxConter.mouseEnabled = _flag;
			if (_flag==false ) {
				 this._btnBoxConter.removeEventListener(MouseEvent.ROLL_OVER, onOverHandler);				
				 this._btnBoxConter.removeEventListener(MouseEvent.ROLL_OUT, onOverHandler);
				if (this._boxConter.hasEventListener(Event.ENTER_FRAME) == true) {
				   this._boxConter.removeEventListener(Event.ENTER_FRAME,onEnterHandler);	
					for (var j:int = 0; j < this._btnNum ;j++ ) {
					var _spr:Sprite = this._boxConter.getChildByName("item" + j) as Sprite;
					_spr.scaleX = _spr.scaleY = 1;
					_spr.x = j * (_spr.width + this._space);
				 }
					
				}
				 
				} else {
				 this._btnBoxConter.addEventListener(MouseEvent.ROLL_OVER, onOverHandler);				
				 this._btnBoxConter.addEventListener(MouseEvent.ROLL_OUT, onOverHandler);
				if(this._boxConter.hasEventListener(Event.ENTER_FRAME)==false)this._boxConter.addEventListener(Event.ENTER_FRAME,onEnterHandler);
			}
			
			if(_flag==true)MianViewCenter(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER)).LockAndUnlock(true);
			
			
			//this._btnBoxConter.	mouseEnabled= _flag;		
			
		}
		
		
		private function mouseEventHandler(e:MouseEvent):void {
			var _type:String = e.currentTarget.name.substr(4, 1);
			//var _conter:Sprite = this._boxConter.getChildByName(e.currentTarget.name) as Sprite;
			//var _conter:Sprite=ProjectOLFacade.GetFacadeOL().GetDisplayConter(GameSystemStrLib.GameUiView);
			//var point:Point=_conter.localToGlobal(new Point(e.currentTarget.x,e.currentTarget.y));   
			switch(e.type) {
				case "click":
					this.LockAndUnLock(false);
					MianViewCenter(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER)).LockAndUnlock(false);
					this.onClickHandler(_type);
					//this._sendFun(PVECommands.TimeLineCOmelete_TipCMD,new SendTips("MainWall",ProxyPVEStrList.TIP_STRBASIC,"Index_"+_type,"strpur",null,point.x,point.y));
				break;
				
			    case "rollOver":
				this._sendFun(PVECommands.TimeLineCOmelete_TipCMD, 
				new SendTips(
				"MainWall",
				ProxyPVEStrList.TIP_STRBASIC,
				"Index_" + _type,
				"",
				null,
				this.mouseX,this.mouseY));
				//this._sendFun(PVECommands.TimeLineCOmelete_TipCMD,new SendTips("MainWall",ProxyPVEStrList.TIP_STRBASIC,"TipsShow","",{_guid:"Index_"+_type},this._btnBoxConter.mouseX,this._btnBoxConter.mouseY));
				
				break;
				
			   
				case "rollOut":
				   TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();
				
				break;
				
			   case "mouseMove":
				TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).TipsMove(this.mouseX,this.mouseY);
				break;
				
			}
		}
		
		//---跳系統--------
		//---1>建築物升級/2>任務/3>郵件/4>交易/5>戰報
		private function onClickHandler(_type:String):void 
		{
			AmfConnector.GetInstance().SendVoGroup();
			//var _type:String = e.currentTarget.name.substr(4, 1);
			this._sendFun(ViewSystem_BuildCommands.MAINVIEW_SWICH,{_btnName:"buildUP"});	
			switch(_type) {
				
				//---建築物升級系統
				case "0":
					//----測試建築物升級-----
					//--建築種類：0.建築物__1.大廳（魔法陣）, 2.巢穴, 3.溶解所, 4.圖書館, 5.儲藏室, 6.煉金所, 7.牢房, 8.英靈室
					//var _testGuid:String = BuildingProxy.GetInstance().GetBuildingGuid(5);
					//BuildingProxy.GetInstance().CheckUpgradable(_testGuid,true);	
					//this._publicFun("Exit");
					//--0513先行關閉以下[建築物升級系統]
					
					//this._sendFun(ViewSystem_BuildCommands.MAINVIEW_SWICH,{_btnName:"buildUP"});	
				    this._sendFun(UICmdStrLib.Init_BuildingUp);
                    
					/*
					var _test:ExchangeProxy = ExchangeProxy(ProjectOLFacade.GetFacadeOL().GetProxy(ProxyPVEStrList.EXCHANGE_PROXY));
					_test.StartSearch();
					*/
				break;
				
				//--mission----
				case "1":
				//this._sendFun(ViewSystem_BuildCommands.MAINVIEW_SWICH,{_btnName:"buildUP"});
				this._sendFun( UICmdStrLib.Init_TaskList ); //任務
				
				 
				break;
				
				//---郵件
			    case "2":
				//var _test:ExchangeProxy = ExchangeProxy(ProjectOLFacade.GetFacadeOL().GetProxy(ProxyPVEStrList.EXCHANGE_PROXY)); 
				//_test.SellGoods(5000, PlaySystemStrLab.Package_Weapon,"WPN137095105361780", "WPN00050");
				//_test.GetPlayerSellList();
				//var _flag:Boolean = _test.BuyGoods("EXC137093912511886", 45);
				//this._sendFun(ViewSystem_BuildCommands.MAINVIEW_SWICH,{_btnName:"buildUP"});
				//this._sendFun( UICmdStrLib.Init_TaskList ); //任務
				
				//this._sendFun(ViewSystem_BuildCommands.MAINVIEW_SWICH,{_btnName:"buildUP"});
				this._sendFun(MailStrLib.OpenMailSys); 
				
				  
				break;
				//---拍賣
			    case "3":
				//this._sendFun(ViewSystem_BuildCommands.MAINVIEW_SWICH,{_btnName:"buildUP"});
				this._sendFun( UICmdStrLib.Init_Auction ); //拍賣
				/*
				var _ary:Array = PlayerMonsterDataCenter.GetMonsterData().GetSellMonste(); 
				this._sendFun(PVECommands.TimeLineCOmelete_TipCMD, 
				 new SendTips(
				 "自己的系統名稱",
				 ProxyPVEStrList.TIP_STRBASIC,
				 "SysTip_AC_MOB",
				 ProxyPVEStrList.EXCHANGE_MONSTER,
				 { _guid:怪獸的_guid}, 
				 座標X,
				 座標Y)
				 );
				
				*/
				
				
				//---任務 
				//var _MissionProxy:MissionProxy = MissionProxy(ProjectOLFacade.GetFacadeOL().GetProxy(ProxyPVEStrList.MISSION_PROXY));
				//_MissionProxy.GetMissionReward("MIS136850002815964");
				//var _view:MainSystemPanel=MainSystemPanel(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.Panel_Main))
				//var _strRR:String=_view.GetClassName();
				//this._sendFun(PVECommands.MISSION_COM_COMPLETE,false);
				
				/*
				var _MissionProxy:MissionProxy = MissionProxy(ProjectOLFacade.GetFacadeOL().GetProxy(ProxyPVEStrList.MISSION_PROXY));
				var _singleMission:Mission = _MissionProxy.GetSingleMission("MIS136850002815964");
				
				this._sendFun(PVECommands.TimeLineCOmelete_TipCMD,
				new SendTips(
						  "MissionList",
						   ProxyPVEStrList.TIP_COMPLETE,
						   PlayerDataCenter.missionItem,
						  "MIS136850002815964",
						  -10,
						  -1,
						  "",
						  -10,
						  _singleMission._title
						)
				
				);*/
				
				//---任務0520---
				//this._sendFun(ViewSystem_BuildCommands.MAINVIEW_SWICH,{_btnName:"buildUP"});
				//this._sendFun( UICmdStrLib.Init_TaskList ); //任務
                //--任務0520---
				/*
				var _ShowTipsInfoProxy:ShowTipsInfoProxy = ShowTipsInfoProxy(ProjectOLFacade.GetFacadeOL().GetProxy(ProxyPVEStrList.TIP_PROXY));
				var _equPre:PreviewBox=_ShowTipsInfoProxy.GetTips("TESTPREVIEW",
				
				new SendTips(
				"MainWall",
				"TESTPREVIEW",
				"WPN136903731740504",
				"WPN00001",
				"MOB136878731816695",
				"SysTip_EQUPRE",
				"WPN00001_ICO"
				
				)
				
				
				);
				trace("hello");
				 this._showConter.addChild(_equPre);
				*/
				//var _list:Vector.<Mission> = _MissionProxy.GetMission();
				//trace("hello");
				//---測試ItemTIPS
				 /*
				 this._PreviewSysBox=TipCreatCenter.GetTipsData().GetTips(ProxyPVEStrList.TIP_PreViewTest,new SendTips("MainViewSpr",ProxyPVEStrList.TIP_PreViewTest,"WPN136755229236166","WPN00001","MOB136754917548782"));
				 this._PreviewSysBox.addEventListener(MouseEvent.CLICK,onTipsClickHandler);
				 this._showConter.addChild(_PreviewSysBox);
				*/
				break;
				//---戰報
			    case "4":
				  this._sendFun( UICmdStrLib.Init_BattleReport ); //戰報 
				
				break;
				
				
			}
			
			//this._sendFun( SoundEventStrLib.PlaySoundEffect , "GUI00045_SND" );//130603 for test
		}
		/*
		private function onTipsClickHandler(e:MouseEvent):void 
		{
			if (this._PreviewSysBox!=null) {
				this._PreviewSysBox.removeEventListener(MouseEvent.CLICK, onTipsClickHandler);
			   	this._PreviewSysBox.OnRemove();
				this._showConter.removeChild(this._PreviewSysBox);
				this._PreviewSysBox = null;
			}
			
		}
	  */	
		
		
		public function onEnterHandler(e:Event=null):void 
		{
			
			var _mc:Sprite;
			var nScale:Number;
			var nX:Number = 0;
			for (var i:int = 0; i < this._btnNum; i++) {
				
				_mc = this._boxConter.getChildByName("item" + i) as Sprite;
				if (this._boxConter.mouseX > 0 && this._boxConter.mouseX < this._boxConter.width) {
					var sX:Number = this._boxConter.mouseX-(_mc.x+_mc.width/2);
					var sY:Number = this._boxConter.mouseY-(_mc.y);
					nScale = Math.sqrt(Math.pow(sX, 2) + Math.pow(sY, 2));
					nScale = nScale > this._scaleMax ? this._scaleMax:nScale;
					nScale = this._scaleMax - nScale;
					nScale = 1 + nScale / 100;
				} else {
					nScale = 1;
				}
				_mc.scaleY += (nScale - _mc.scaleY) * this._ratio;
				_mc.scaleX=_mc.scaleY;
				_mc.x=nX;
			    //trace("_mc.x>>"+_mc.x);
				nX+=_mc.width+this._space;
			}
			
			this._boxConter.width=nX;
			//this._conter.x = (this._showConter-this._boxConter.width)/2;
		}
		
		
		public function onRemove():void 
		{
			for (var i:int = 0; i < this._btnNum;i++ ) {
				var _spr:Sprite=this._boxConter.getChildByName("item" + i) as Sprite
				_spr.removeEventListener(MouseEvent.CLICK, onClickHandler);
				this._boxConter.removeChild(_spr);
			}
			if(this._boxConter.hasEventListener(Event.ENTER_FRAME))this._boxConter.removeEventListener(Event.ENTER_FRAME,onEnterHandler);
			//this._showConter.removeChild(this._boxConter);
			this._showConter.removeChildren();
		}
		
	}
	
	
	
}