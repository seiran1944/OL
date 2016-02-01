package MVCprojectOL.ViewOL.MainView
{
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Elastic;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import strLib.vewStr.ViewStrLib;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class MainViewBGSystem extends Sprite 
	{
		private var _bg:Bitmap;
		private var _displayLayer:DisplayObjectContainer;
		private var _setTimeOut:uint;
		private var _constHeight:int = 0;
		private var _checkTween:Boolean = false;
		private var _nextMotion:Boolean = false;
		public function MainViewBGSystem(_conter:DisplayObjectContainer)
		{
		   this._displayLayer = _conter;
		}
		
		
		public function AddBG(_pic:Class):void 
		{
			
	        this._bg = new Bitmap(new _pic());
			this.addChild(this._bg);	
		}
		
		/*
		public function ResetBG(_pic:Class):void 
		{
			this._bg.bitmapData = (new _pic() );
		}
		*/
		
		public function AddSystemSpr(_spr:Sprite):void 
		{
			this.addChild(_spr);
		}
		
		
		private function checkChangeHandler(_pic:Class=null):void 
		{
			
			this._checkTween = false;
			if (_pic != null) this._bg.bitmapData = (new _pic());
			//this._setTimeOut = setTimeout(SwitchMotion,300);
			if (this._nextMotion==true) {
			 this._nextMotion = false;
			 this.SwitchMotion("OPEN");
			}
			
			
		}
		
		
		
		
		public function SwitchMotion(_str:String="OPEN",_pic:Class=null):void 
		{
			var _point:Point = ProjectOLFacade.GetFacadeOL().GetStageInfo();
			var _motion:Number = (_str=="CLOSE")?_point.y +this.height: _point.y - this.height;
			if (TweenMax.isTweening(this)) TweenMax.killTweensOf();
			if (_str=="CLOSE") {
				//this._checkTween = true;
				TweenMax.to(this,.3, { y:_motion, 
	            ease:Circ.easeIn
				//onComplete:checkChangeHandler,
			    //onCompleteParams:[_pic]
			    });
				
				} else{
				//clearTimeout(this._setTimeOut);
				//TweenMax.killAll();
				TweenMax.to(this, .3, { y:_motion,
				onComplete:getBtnUnLockHandler
	            //ease:Circ.easeOut
			    });
				
			  //}else {
				//this._nextMotion = true;
			}
			
		}
		
		private function getBtnUnLockHandler():void 
		{
			var _view:MainSystemPanel=MainSystemPanel(ProjectOLFacade.GetFacadeOL().GetRegisterViewCtrl(ViewStrLib.Panel_Main))
			var Panel:*= _view.GetConterClass();
			if (Panel is MainWall  && Panel != null) { 
				Panel.LockAndUnLock(true);	
			   trace("unLock LA");
			};
		}
		
		private var _checkHeight:int = 0;
		public function StarShow():void 
		{
		    this._displayLayer.addChild(this);
		    var _point:Point = ProjectOLFacade.GetFacadeOL().GetStageInfo();
			this.y =this.height;
			trace("YYY>>" + this.y);
			trace("this>>" + this.height);
			this._constHeight = _point.y - this.height;
			this._checkHeight = this.height;
			TweenLite.to(this, 1.5, {y:_point.y-this.height,ease:Elastic.easeOut});
		}
	}
	
}