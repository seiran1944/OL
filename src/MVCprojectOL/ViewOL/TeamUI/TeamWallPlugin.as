package MVCprojectOL.ViewOL.TeamUI
{
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import MVCprojectOL.ViewOL.IfMenuConter;
	import strLib.commandStr.TeamCmdStr;
	import strLib.commandStr.ViewSystem_BuildCommands;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class TeamWallPlugin extends Sprite implements IfMenuConter
	{
		
		private var _funNotify:Function;
		private var _funBackDo:Function;
		private var _container:DisplayObjectContainer;
		private const HEI:int = 130;
		
		public function TeamWallPlugin():void 
		{
			//trace("I AM BUILD TeamWallPlugin");
			//TweenPlugin.activate([GlowFilterPlugin]);
		}
		
		public function onCreat(_notifyfun:Function, _publicFun:Function, _spr:DisplayObjectContainer):void
		{
			//trace("I GOT CREATE SELF");
			//this.graphics.beginFill(0xFF0000);
			//this.graphics.drawCircle(0, 0, 200);
			//this.graphics.endFill();
			this._container = _spr;
			_spr.addChild(this);
			//var stageInfo:Point = ProjectOLFacade.GetFacadeOL().GetStageInfo();
			//this.y = stageInfo.y - this.HEI;
			//trace("MY SELF Y>>", this.y, this.x);
			
			this._funNotify = _notifyfun;
			this._funBackDo = _publicFun;
			this.addEventListener(MouseEvent.CLICK, userMouseProcess);
			this.addEventListener(MouseEvent.ROLL_OVER, userMouseProcess,true);
			this.addEventListener(MouseEvent.ROLL_OUT, userMouseProcess,true);
		}
		
		private function userMouseProcess(e:MouseEvent):void 
		{
			//trace("Wall OBJECT USER　ＴＯＵＣＨ", e.target.name, e.currentTarget.name, e.type);
			var name:String = e.target.name;
			
			switch (e.type) 
			{
				case "rollOver":
					if (name == "exitBtn") {
						//trace("got TWEEN THIS ");
						//TweenLite.to(e.target, .8,{ glowFilter :{ color:0xF0F0F0, alpha : 1,blurX:20, blurY:20 } });
						e.target.gotoAndStop(2);
						if (!TweenMax.isTweening(e.target)) this.onCompleteShake(e.target , true , 4);
					}
				break;
				case "rollOut":
					if (name == "exitBtn") {
						//TweenLite.killTweensOf(e.target);
						//e.target.rotation = 0;
						e.target.gotoAndStop(1);
						//e.target.filters = [];
					}
				break;
				case "click":
					if (name == "exitBtn") {//觸發關閉效果 通知systemPanel移除動作 與 UI 移除動作
						this._funNotify(TeamCmdStr.TEAM_CMD_PROCESS, { _Status :TeamViewCtrl.TEAM_DESTROY , _Content : {_status : "Click"} } );
						this.BreakTheWall();
						
					}
				break;
			}
		}
		
		//留給外部呼叫使用(出征時點選隊伍後的關閉UI選項)
		public function BreakTheWall(isExplorer:Boolean=false):void 
		{
			//this._funBackDo("Exit");
			//this._funNotify(ViewSystem_BuildCommands.MAINVIEW_SWICH,{_btnName:"EXIT"});
			this.Destroy(isExplorer);
			//---0506---
			//this.Destroy(true);
		}
		
		private function onCompleteShake(target:Object,isLeft:Boolean,times:int):void 
		{
			if (times > 0) {
				TweenLite.to(target, .15, { rotation:isLeft ? -25 : 25 , onComplete:this.onCompleteShake , onCompleteParams : [target, !isLeft, times-1] } );
			}else {
				TweenLite.to(target, .15, { rotation:0 } );
			}
		}
		
		public function AddSource(_key:String, _obj:*):void
		{
			//None
			//trace("MY SOURCE IS BUILD");
			var exitBtn:MovieClip = new _obj["exitBtn"]();
			exitBtn.mouseChildren = false;
			exitBtn.buttonMode = true;
			//exitBtn.graphics.beginFill(0,0);
			//exitBtn.graphics.drawCircle(0, 0, 50);
			//exitBtn.graphics.endFill();
			exitBtn.name = "exitBtn";
			this.addChild(exitBtn);
			exitBtn.x = 50;
			exitBtn.y = 124;
			//字型要替換成系統屬性值******************
			//var format:TextFormat = new TextFormat("微軟正黑體", 20, 0xFF0011, true);
			//var txt:TextField = new TextField();
			//txt.selectable = false;
			//txt.defaultTextFormat = format;
			//txt.text = "EXIT";
			//txt.x = -15;
			//txt.y = -10;
			//exitBtn.addChild(txt);
			
			
			
		}
		
		
		public function onRemove():void
		{
			//this.Destroy();
		}
		
		public function Destroy(isExplorer:Boolean):void 
		{
			
			this._container.removeChild(this);
			/*
			while (this._container.numChildren>0) 
			{
				this._container.removeChildAt(0);
				
			}*/
			//this._container = null;
			var _index:Number = this._container.numChildren;
			this.removeEventListener(MouseEvent.CLICK, userMouseProcess);
			this.removeEventListener(MouseEvent.ROLL_OVER, userMouseProcess,true);
			this.removeEventListener(MouseEvent.ROLL_OUT, userMouseProcess, true);
			
			//補發一個訊號通知移除完畢可以進行配置(系統操作用)
			//if (!isExplorer) {
			//探索狀態切換過程中不經過		
			//this._funNotify(ViewSystem_BuildCommands.MAINVIEW_CREAT);
			//}
			//trace("WALLＰＬＵＧＩＮ呼叫到onRemove");
			this._funBackDo = null;
			this._funNotify = null;
		}
		
		
		public function AddVaules(_vaules:*):void { };

		
	}
	
}