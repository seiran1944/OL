package MVCprojectOL.ViewOL.CrewView.DefaultBoard
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import MVCprojectOL.ModelOL.Vo.Troop;
	import MVCprojectOL.ViewOL.CrewView.EditBoard.TeamShowView;
	import MVCprojectOL.ViewOL.MainView.MianViewCenter;
	import MVCprojectOL.ViewOL.SharedMethods.BasisPanel;
	import Spark.coreFrameWork.View.ViewCtrl;
	import Spark.SoarVision.single.BitmapVision;
	import Spark.SoarVision.VisionCenter;
	import strLib.vewStr.ViewStrLib;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class  CrewDefaultView extends ViewCtrl
	{
		
		private var _panel:CrewDefaultBackground;
		private var _panelConter:Sprite;
		private var _vecBoard:Vector.<TeamShowView>;
		private var _vecLamp:Vector.<BitmapVision>;
		private var _lampWidGap:int = 222;
		private var _tsvWidGap:int = -20;
		private var _pTsvStart:Point = new Point(32, 140);
		private var _aryDefaultNum:Array;//PVP[0]  /  PVE[1]隊伍
		//
		private var _objNotify:Object;
		
		public function CrewDefaultView(name:String,conter:DisplayObjectContainer):void 
		{
			super(name, conter);
		}
		
		public function SetNotifyInfo(objNotify:Object):void 
		{
			this._objNotify = objNotify;
		}
		
		//導入素材
		public function AddSource(objSource:Object):void 
		{
			this._panelConter = new Sprite();//systemLayer >> singleLayer(for crew use)  >> panelConter
			this._viewConterBox.addChild(this._panelConter);
			this._panelConter.x = 313;
			this._panelConter.y = 125;
			this._panel = new CrewDefaultBackground(objSource, this._panelConter);
			
		}
		
		private function addLampShow():void 
		{
			//Lamp
			this._vecLamp = new Vector.<BitmapVision>(4);
			var bmVision:BitmapVision;
			for (var i:int = 0; i < 4; i++) 
			{
				bmVision = new BitmapVision("CrewLamp" + String(i));
				bmVision.x = (this._pTsvStart.x -25) + i * this._lampWidGap;
				bmVision.y = this._pTsvStart.y -15;
				this._panelConter.addChild(bmVision);
				VisionCenter.GetInstance().AddSinglePlay(bmVision, this._panel.ObjSource.aryLamp, true,false,false,200);
				this._vecLamp[i] = bmVision;
			}
		}
		private function removeAllLamp():void 
		{
			for (var i:int = 0; i < 4; i++) 
			{
				VisionCenter.GetInstance().MovieRemove("CrewLamp" + String(i));
				this._panelConter.removeChild(this._vecLamp[i]);
			}
		}
		
		//顯示UI底版面
		public function ShowInstance(title:String="預設隊伍",intro:String="由此可以設定出征預設隊伍與編輯隊伍成員"):void 
		{
			this._panel.AddBasisPanel(title, 740, 520, 400);
			this._panel.AddBottomPaper(intro);
			this.addLampShow();
		}
		
		//初始化隊伍顯示板
		public function AddBoardMixed(vecBoard:Vector.<TeamShowView>):void 
		{
			this._vecBoard = vecBoard;
			
			var tsView:TeamShowView;
			for (var i:int = 0; i < 3; i++) 
			{
				tsView = vecBoard[i];
				tsView.Content.alpha = 0;
				tsView.Content.x = this._pTsvStart.x + i * this._tsvWidGap + i * tsView.Content.width;
				tsView.Content.y = this._pTsvStart.y;
				this._panelConter.addChild(tsView.Content);
				TweenLite.to(tsView.Content, 2, { alpha:1 } );
			}
			
		}
		
		//初始化隊伍資料
		public function SetTroopData(aryTroop:Array,aryDefaultNum:Array=null):void 
		{
			if(aryDefaultNum) this._aryDefaultNum = aryDefaultNum;
			var leng:int = aryTroop.length;
			var tp:Troop;
			for (var i:int = 0; i < leng; i++) 
			{
				tp = aryTroop[i];
				this._vecBoard[tp._teamNum].InitTeamGroup(tp,true);
			}
		}
		
		public function CancelTroopByNum(num:int):void 
		{
			this._vecBoard[num].CleanTroopShow();
		}
		
		//改變預設按鈕顯示與紀錄(回歸先前點選的顯示)
		public function ChangeDefaultBtn(num:int,btnName:String):void 
		{
			var checkNum:int = btnName == "PVP" ? 0 : 1 ;
			
			var preBoardNum:int = this._aryDefaultNum[checkNum];
			this._aryDefaultNum[checkNum] = num;
			
			this._vecBoard[preBoardNum].ReverseDefaultBtn(btnName);
		}
		
		override public function onRemoved():void 
		{
			this.Destroy();
		}
		
		public function Destroy():void 
		{
			trace(this._viewConterBox.parent.name,"name is >>>>>>>>>>>>><<<<<<<<<<<<" , this._viewConterBox.name);
			this.removeAllLamp();
			this._vecLamp.length = 0;
			this._vecLamp = null;
			this._viewConterBox.parent.removeChild(this._viewConterBox);
			this._viewConterBox.removeChild(this._panelConter);
			//20130606
			for (var i:int = 0; i < 3; i++) 
			{
				this._vecBoard[i].Destroy();
			}
			//----eric huang-0613--
			//var _mianViewCenter:MianViewCenter = MianViewCenter(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.MAIN_VIEWCENTER));
			//if(_mianViewCenter!=null)_mianViewCenter.LockAndUnlock(true);
			
		}
		
		
		public function get NotifyInfo():Object 
		{
			return this._objNotify;
		}
		
		
	}
	
}