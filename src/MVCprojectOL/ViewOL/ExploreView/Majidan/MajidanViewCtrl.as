package MVCprojectOL.ViewOL.ExploreView.Majidan 
{
	import com.greensock.easing.Elastic;
	import com.greensock.plugins.GlowFilterPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Vo.Explore.ExploreArea;
	import Spark.coreFrameWork.View.ViewCtrl;
	import strLib.commandStr.MajidanStrLib;
	import strLib.commandStr.ViewSystem_BuildCommands;
	/**
	 * ...
	 * @author brook
	 * @version 13.03.04.17.25
	 */
	public class MajidanViewCtrl extends ViewCtrl
	{
		private var _BGObj:Object;
		private var _MajidanObj:Object;
		private var _NodeInfo:Dictionary;
		public function MajidanViewCtrl(_InputViewName:String , _InputConter:DisplayObjectContainer) 
		{
			TweenPlugin.activate([GlowFilterPlugin]);
			super( _InputViewName , _InputConter );
			this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_REMOVE); 
			//this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SwitchReady);
		}
		
		public function AddElement(_InputMajidanObj:Object, _InputObj:Object):void
		{
			this._BGObj = _InputObj;
			this._MajidanObj = _InputMajidanObj;
			//this._viewConterBox.addEventListener(MouseEvent.CLICK, playerClickProcess);
		}
		
		public function RefreshMapNode( _InputNodeInfo:Dictionary ):void {
			//_InputNodeInfo = 地圖節點資訊清單 內裝ExploreArea物件  以ExploreArea._guid為索引
			this._NodeInfo = null;
			this._NodeInfo = _InputNodeInfo;
			//for (var i:* in _InputNodeInfo ) trace( i , ExploreArea( _InputNodeInfo[ i ] )._accessible );//地圖區域開關控制
			trace( "Majidan View Ctrl is refreshing map display" );
			this.OneLayer();
		}
		
		//魔神殿第一層
		private function OneLayer():void
		{
			trace("魔神殿第一層");
			
			var _MajidanView:Sprite = new ( this._MajidanObj[ "MajidanView" ] as Class );
				_MajidanView.name = "MajidanView";
			this._viewConterBox.addChild(_MajidanView);
			
			var _CastleTownBG:Sprite = Sprite(_MajidanView.getChildByName("MSA00001"));
				var _CastleTown:MovieClip = MovieClip(_CastleTownBG.getChildByName("_CastleTown"));
				if (ExploreArea( this._NodeInfo[ "MSA00001" ] )._accessible == true) {
					_CastleTownBG.buttonMode = true;
					this.MouseEffect(_CastleTownBG);
				}else {
					_CastleTown.gotoAndStop(2);
				}
				var _MountainG:Sprite = Sprite(_CastleTownBG.getChildByName("_MountainG"));
					_MountainG.scaleX = 0.5;
					_MountainG.scaleY = 0.5;
			TweenLite.to(_MountainG, 1, { scaleX:1, scaleY:1 , ease:Elastic.easeOut } );
			
			var _IronBridgeBG:Sprite = Sprite(_MajidanView.getChildByName("MSA00002"));
				_IronBridgeBG.buttonMode = true;
				var _IronBridge:MovieClip = MovieClip(_IronBridgeBG.getChildByName("_IronBridge"));
				if (ExploreArea( this._NodeInfo[ "MSA00002" ] )._accessible == true) {
					_IronBridgeBG.buttonMode = true;
					this.MouseEffect(_IronBridgeBG);
				}else {
					_IronBridge.gotoAndStop(2);
				}
			
			var _EntranceBG:Sprite = Sprite(_MajidanView.getChildByName("MSA00003"));
				var _Entrance:MovieClip = MovieClip(_EntranceBG.getChildByName("_Entrance"));
					if (ExploreArea( this._NodeInfo[ "MSA00003" ] )._accessible == true) {
						_EntranceBG.buttonMode = true;
						this.MouseEffect(_EntranceBG);
					}else {
						_Entrance.gotoAndStop(2);
					}
			
			var _StorageLibraryBG:Sprite = Sprite(_MajidanView.getChildByName("MSA00005"));
				var _StorageLibrary:MovieClip = MovieClip(_StorageLibraryBG.getChildByName("_StorageLibrary"));
					if (ExploreArea( this._NodeInfo[ "MSA00005" ] )._accessible == true) {
						_StorageLibraryBG.buttonMode = true;
						this.MouseEffect(_StorageLibraryBG);
					}else {
						_StorageLibrary.gotoAndStop(2);
					}
			
			var _FateBG:Sprite = Sprite(_MajidanView.getChildByName("MSA00004"));
				var _Fate:MovieClip = MovieClip(_FateBG.getChildByName("_Fate"));
					if (ExploreArea( this._NodeInfo[ "MSA00004" ] )._accessible == true) {
						_FateBG.buttonMode = true;
						this.MouseEffect(_FateBG);
					}else {
						_Fate.gotoAndStop(2);
					}
				var _MountainB:Sprite = Sprite(_FateBG.getChildByName("_MountainB"));
					_MountainB.scaleX = 0.5;
					_MountainB.scaleY = 0.5;
			TweenLite.to(_MountainB, 1, { scaleX:1, scaleY:1 , ease:Elastic.easeOut } );
			
			var _WhiteTowerBG:Sprite = Sprite(_MajidanView.getChildByName("MSA00006"));
				var _WhiteTower:MovieClip = MovieClip(_WhiteTowerBG.getChildByName("_WhiteTower"));
					if (ExploreArea( this._NodeInfo[ "MSA00006" ] )._accessible == true) {
						_WhiteTowerBG.buttonMode = true;
						this.MouseEffect(_WhiteTowerBG);
					}else {
						_WhiteTower.gotoAndStop(2);
					}
				var _MountainD:Sprite = Sprite(_WhiteTowerBG.getChildByName("_MountainD"));
					_MountainD.scaleX = 0.5;
					_MountainD.scaleY = 0.5;
			TweenLite.to(_MountainD, 1, { scaleX:1, scaleY:1 , ease:Elastic.easeOut } );
			
			var _TortureChamberBG:Sprite = Sprite(_MajidanView.getChildByName("MSA00007"));
				var _TortureChamber:MovieClip = MovieClip(_TortureChamberBG.getChildByName("_TortureChamber"));
					if (ExploreArea( this._NodeInfo[ "MSA00007" ] )._accessible == true) {
						_TortureChamberBG.buttonMode = true;
						this.MouseEffect(_TortureChamberBG);
					}else {
						_TortureChamber.gotoAndStop(2);
					}
			
			var _CollectionStackBG:Sprite = Sprite(_MajidanView.getChildByName("MSA00009"));
				var _CollectionStack:MovieClip = MovieClip(_CollectionStackBG.getChildByName("_CollectionStack"));
					if (ExploreArea( this._NodeInfo[ "MSA00009" ] )._accessible == true) {
						_CollectionStackBG.buttonMode = true;
						this.MouseEffect(_CollectionStackBG);
					}else {
						_CollectionStack.gotoAndStop(2);
					}
			
			var _MudBG:Sprite = Sprite(_MajidanView.getChildByName("MSA00008"));
				var _Mud:MovieClip = MovieClip(_MudBG.getChildByName("_Mud"));
					if (ExploreArea( this._NodeInfo[ "MSA00008" ] )._accessible == true) {
						_MudBG.buttonMode = true;
						this.MouseEffect(_MudBG);
					}else {
						_Mud.gotoAndStop(2);
					}
				var _MountainP:Sprite = Sprite(_MudBG.getChildByName("_MountainP"));
					_MountainP.scaleX = 0.5;
					_MountainP.scaleY = 0.5;
			TweenLite.to(_MountainP, 1, { scaleX:1, scaleY:1 , ease:Elastic.easeOut } );
			
			var _PracticingChurchBG:Sprite = Sprite(_MajidanView.getChildByName("MSA00010"));
				var _PracticingChurch:MovieClip = MovieClip(_PracticingChurchBG.getChildByName("_PracticingChurch"));
					if (ExploreArea( this._NodeInfo[ "MSA00010" ] )._accessible == true) {
						_PracticingChurchBG.buttonMode = true;
						this.MouseEffect(_PracticingChurchBG);
					}else {
						_PracticingChurch.gotoAndStop(2);
					}
			
			var _FlameBG:Sprite = Sprite(_MajidanView.getChildByName("MSA00011"));
				var _Flame:MovieClip = MovieClip(_FlameBG.getChildByName("_Flame"));
					if (ExploreArea( this._NodeInfo[ "MSA00011" ] )._accessible == true) {
						_FlameBG.buttonMode = true;
						this.MouseEffect(_FlameBG);
					}else {
						_Flame.gotoAndStop(2);
					}
				var _MountainP2:Sprite = Sprite(_FlameBG.getChildByName("_MountainD"));
					_MountainP2.scaleX = 0.5;
					_MountainP2.scaleY = 0.5;
			TweenLite.to(_MountainP2, 1, { scaleX:1, scaleY:1 , ease:Elastic.easeOut } );
			
			var _TimepieceTowerBG:Sprite = Sprite(_MajidanView.getChildByName("MSA00012"));
				var _TimepieceTower:MovieClip = MovieClip(_TimepieceTowerBG.getChildByName("_TimepieceTower"));
					if (ExploreArea( this._NodeInfo[ "MSA00012" ] )._accessible == true) {
						_TimepieceTowerBG.buttonMode = true;
						this.MouseEffect(_TimepieceTowerBG);
					}else {
						_TimepieceTower.gotoAndStop(2);
					}
			
			var _ExitBtn:MovieClip =  MovieClip(_MajidanView.getChildByName("ExitBtn"));
				_ExitBtn.buttonMode = true;
			this.MouseEffect(_ExitBtn);
		}
		
		private function playerClickProcess(e:MouseEvent):void
		{
			
		}
		
		//滑鼠效果
		private function MouseEffect(btn:*):void{
			btn.addEventListener(MouseEvent.CLICK, BtnEffect);
			btn.addEventListener(MouseEvent.ROLL_OVER, BtnEffect);
			btn.addEventListener(MouseEvent.ROLL_OUT, BtnEffect);
		}
		private function BtnEffect(e:MouseEvent):void {
			switch (e.type) {
				case "click":
					(e.target.name != "ExitBtn")?this.SendNotify( MajidanStrLib.ExploreAreaSelected, e.currentTarget.name):this.SendNotify( MajidanStrLib.Exit);
					break;
				
				case "rollOver":
					(e.target.name != "ExitBtn")?TweenLite.to(e.target, 0, { glowFilter: { color:0xfff983, blurX:17, blurY:17, strength:3, alpha:.7 }} ):MovieClip(e.target).gotoAndStop(2);
					
					break;
				case "rollOut":
					(e.target.name != "ExitBtn")?TweenLite.to(e.target, 0, { glowFilter: { blurX:0, blurY:0, strength:0, alpha:0 }} ):MovieClip(e.target).gotoAndStop(1);
					break;
			}
		}
		//移除滑鼠效果
		private function RemoveMouseEffect(btn:*):void
		{
			btn.removeEventListener(MouseEvent.CLICK, BtnEffect);
			btn.removeEventListener(MouseEvent.ROLL_OVER, BtnEffect);
			btn.removeEventListener(MouseEvent.ROLL_OUT, BtnEffect);
		}
		
		override public function onRemoved():void 
		{	
			//記得移除現存的所有監聽器  KJ 130208
			for (var i:int = 1; i < 13; i++) (i < 10)?this.RemoveMouseEffect(Sprite(Sprite(this._viewConterBox.getChildByName("MajidanView")).getChildByName("MSA0000" + i))):this.RemoveMouseEffect(Sprite(Sprite(this._viewConterBox.getChildByName("MajidanView")).getChildByName("MSA000" + i)));
			this._viewConterBox.removeChild(this._viewConterBox.getChildByName("MajidanView"));
		}
		
	}
}