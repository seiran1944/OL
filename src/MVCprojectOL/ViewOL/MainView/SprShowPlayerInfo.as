package MVCprojectOL.ViewOL.MainView
{
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	//import MVCprojectOL.ModelOL.ShowSideSys.SendTips;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import MVCprojectOL.ViewOL.TipsView.TipsCenterView;
	import strLib.commandStr.PVECommands;
	import strLib.commandStr.UserInfoStr;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.proxyStr.ProxyPVEStrList;
	import strLib.vewStr.ViewStrLib;
	//import flash.utils;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class SprShowPlayerInfo 
	{
		
		
		private var _safeView:DisplayObjectContainer;
	    private var _funText:Function;
		private var _sprMain:Sprite;
		private var _sendNotify:Function
		private var _aryInfo:Array;
		private var _arySingleText:Array;
		private var _bgFlagFrame:int = 1;
		private var _setInterval:uint;
		private var _tweening:Boolean = false;
		private var _tweenMotion:Boolean = false;
		private const _aryTips:Array = ["SysTip_PI1", "SysTip_PI2", "SysTip_PI3", "SysTip_PI4", "SysTip_PI5"];
		private const _tipsKey:String = "PlayerData";
		public function SprShowPlayerInfo(_conter:DisplayObjectContainer,_proxyFun:Function,_send:Function) 
		{
			this._safeView = _conter;
			//---註冊文字框
			this._funText = _proxyFun;
			this._sendNotify = _send;
			this._aryInfo = [];
			this._arySingleText = [UserInfoStr.CHANGE_WOOD,UserInfoStr.CHANGE_STONE,UserInfoStr.CHANGE_FUR,UserInfoStr.CHANGE_SOUL,UserInfoStr.CHANGE_MONEY];
			if(this._sprMain==null)this._sprMain=new Sprite();
		}
		
		public function AddSource(_source:Class):void 
		{
			
			for (var i:int = 0; i < 5;i++ ) {
			  var _spr:Sprite = new _source();
			  //_spr.buttonMode = true;
			  _spr.mouseChildren = false;
			  _spr.name = "btn" + i;
			  //var _mc:MovieClip=_spr.getChildAt(2) as MovieClip;	
			  var _mc:MovieClip=_spr.getChildByName("showItem_mc") as MovieClip;	
			  var _textField:TextField = _spr.getChildByName("player_text") as TextField;
			  var _bgItem:MovieClip = _spr.getChildByName("bgItem_mc") as MovieClip;
			  _bgItem.gotoAndStop(1);
			  //var _str:String = this._arySingleText[i];
			  this._funText(this._arySingleText[i],_textField);
			  _mc.gotoAndStop(i + 1);
			   var _index:int = 0; 
			   if (i<=1) {
					
					_index = i * _spr.width;
					
					} else {
				  if (i == 2)_index = this._sprMain.width + 5;
				  if (i >= 3)_index = this._sprMain.width;
				  //if (i == 4)_index = this._sprMain.width;
				  
			   }
			   _spr.x = _index;
			   _spr.y = -_spr.height;
			   _spr.addEventListener(MouseEvent.ROLL_OVER,onClickHandler);
			   _spr.addEventListener(MouseEvent.ROLL_OUT, onClickHandler);
			   _spr.addEventListener(MouseEvent.MOUSE_MOVE, onClickHandler);
			   this._sprMain.addChild(_spr);
			   this._aryInfo.push(_spr);
			   
			}
			
			//this._sprMain.addChild(_spr);
			
			this._safeView.addChild(this._sprMain);
			var _point:Point = ProjectOLFacade.GetFacadeOL().GetStageInfo();
			this._sprMain.x = (_point.x - this._sprMain.width) / 2;
			//this._sprMain.y = -this._sprMain.height;
			this._sendNotify(ViewSystem_BuildCommands.USERINFO_COMPLETE);
			
		}
		
		private function onClickHandler(e:MouseEvent):void 
		{
			//var _target:String = ;
			switch(e.type) {
			
			   	
			    case "rollOver":
				//----2013/1/11---tipsTEST---
				//this._sendNotify(PVECommands.TimeLineCOmelete_TipCMD,{_change:"",_strTips:'<br>建築效果: <b><font color="#65FF56">士兵全屬性抵抗</font>+%d</b>',_guid:"",_mouseX:this._safeView.mouseX,_mouseY:this._safeView.mouseY,_system:""});
				//this._sendNotify(PVECommands.TimeLineCOmelete_TipCMD,new SendTips("MainViewSpr",ProxyPVEStrList.TIP_STRBASIC,"","",this._safeView.mouseX,this._safeView.mouseY,'<br>建築效果: <b><font color="#65FF56">士兵全屬性抵抗</font>+%d</b>',""));
				var _indexStr:int = int(e.currentTarget.name.substr(3,1));
				
				
				
				this._sendNotify(PVECommands.TimeLineCOmelete_TipCMD,new SendTips("MainViewSpr",ProxyPVEStrList.TIP_STRBASIC,this._aryTips[_indexStr],this._tipsKey,{},this._safeView.mouseX,this._safeView.mouseY));
				break;
				
			    case "rollOut":
				TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).CloseTips();
				break;
				
			    case"mouseMove":
				TipsCenterView(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.TIP_VIEWCTRL)).TipsMove(this._safeView.mouseX,this._safeView.mouseY);
				
				break;
				
				
			}
		}
		
		//---進場------
		public function StartInStage():void 
		{
			
			var _len:int = this._aryInfo.length;
			TweenMax.allTo( this._aryInfo, 1,
			 {
			 y:( -(this._aryInfo[0].height) / 2) + 10,
			 ease:Bounce.easeOut
			 }, 
			 .2,
			 this.SendNotifyChange
			 )
		    
			 //---12/24_check----
			for (var i:* in this._aryInfo) {
				
				trace("this._aryInfo>>>>"+this._aryInfo[i].y);
			} 
			trace("this._sprMain___"+this._sprMain.y);
			trace("hello"); 
		}
		
		
		
		
		//---判定影格數
		private function CheckFarme(_flag:int):void 
		{
			
		   
			for (var i:* in this._aryInfo) {
			   this._aryInfo[i].y =-this._aryInfo[i].height;	
			   if (this._bgFlagFrame != _flag && _flag>=1) {
				 var _bgItem:MovieClip = this._aryInfo[i].getChildByName("bgItem_mc") as MovieClip;	   
				 _bgItem.gotoAndStop(_flag); 
			   }
			} 
			this._sprMain.y = 0;
			this._tweening = false;
			if (this._bgFlagFrame != _flag) this._bgFlagFrame = _flag;
			if (this._tweenMotion == true) {
				this._tweenMotion = false;
				this.MotionCommand("OPEN");
			}
			//this._setInterval=setTimeout(MotionCommand,1000);
		}
		
		//----------------------------_str=移動指令字串/_flag=變更圖案的指令
		public function MotionCommand(_str:String="OPEN",_flag:int=-1):void 
		{
			/*if (this._setInterval!= null)*/// clearTimeout(this._setInterval);
		  	//TweenLite.killTweensOf(this._sprMain);
			if (TweenMax.isTweening(this._sprMain)) TweenMax.killAll();
			if (_str=="CLOSE") {	
		        //this._tweening = true;
				TweenMax.to(this._sprMain,.5, { 
			    y:-this._sprMain.height, 
				ease:Circ.easeIn
				//onComplete:CheckFarme,
				//onCompleteParams:[_flag]
			  } );
					
			 }else{
				//---down----
				//this.StartInStage();
				TweenMax.to(this._sprMain,.5, { 
			    y:0, 
				ease:Circ.easeOut } );
			//}else {
				//this._tweenMotion = true;
			}
			
		}
		
		
		private function SendNotifyChange():void 
		{
		   //--change User Info---
		   
		   var _sendAry:Array = [];
		   for (var i:int = 0; i < 5;i++ ) {
			  var _object:Object = { 
				  _name:this._arySingleText[i], 
				  _start:0,
				  _end:this.getPlayerDataVaule(this._arySingleText[i])
				}; 
			   _sendAry.push(_object);
			}
			var _sendObj:Object = {_ary:_sendAry};
		    //---完成初始建立玩家的值----
			this._sendNotify(UserInfoStr.CHANGE_USERINFO,_sendObj);
			
			trace("tweenMax_Complete");
		}
		
		
		private function getPlayerDataVaule(_str:String):int
		{
			var _int:int = 0;
			switch(_str) {
			   	case UserInfoStr.CHANGE_WOOD:
				_int = PlayerDataCenter.PlayerWood;	
				break;
				
			    case UserInfoStr.CHANGE_STONE:
				_int = PlayerDataCenter.PlayerStone;
				break;
				
			    case UserInfoStr.CHANGE_FUR:
				_int = PlayerDataCenter.PlayerFur;
				break;
				
			    case UserInfoStr.CHANGE_SOUL:
				_int = PlayerDataCenter.PlayerSoul;
				break;
				
			    case UserInfoStr.CHANGE_MONEY:
				_int = PlayerDataCenter.PlayerMony;
				break;
				
			}
			
			return _int;
		}
		
	}
	
}



