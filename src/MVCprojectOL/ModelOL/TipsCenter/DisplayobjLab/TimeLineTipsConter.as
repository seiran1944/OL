package MVCprojectOL.ModelOL.TipsCenter.DisplayobjLab
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import MVCprojectOL.ModelOL.ServerSteps.ServerTimework;
	import MVCprojectOL.ModelOL.TipsCenter.Basic.BaseItemView;
	import MVCprojectOL.ModelOL.TipsCenter.Basic.ItemConter;
	import MVCprojectOL.ModelOL.TipsCenter.Basic.SkillPic;
	import MVCprojectOL.ModelOL.TipsCenter.Basic.TimerBar;
	import MVCprojectOL.ModelOL.TipsCenter.Basic.TipProperty;
	import MVCprojectOL.ModelOL.TipsCenter.SendTips;
	import Spark.Timers.TimeDriver;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class TimeLineTipsConter extends BaseItemView 
	{
		
		//private var _sendFun:Function;
		private var _aryTimeSource:Array;
		private var _arySkillSource:Array;
		private var _timerBar:TimerBar;
		private var _tipProperty:TipProperty;
		private var _tipSkill:SkillPic;
		private var _tipStatus:int = 0;
		
		public function TimeLineTipsConter(_bgSource:MovieClip,_group:String,_fun:Function=null) 
		{
			super(_bgSource,"",_group);
			//this._sendFun = _fun;
		}
		
		public function AddTimeSource(_ary:Array,_arySk:Array,_itemConter:ItemConter):void 
		{   
			this._aryTimeSource = _ary;
			//----技能圖示
			this._arySkillSource = _arySk;
			this.AddItemSource(_itemConter);
			this._item.x = this._item.y = 8;
		}
		//---{_bar:Sprite,_completeTime:int,_totalTime:int,_text:Object}
		public function AddBar(_infor:Object):void 
		{
			//var _starTime:uint = ServerTimework.GetInstance().ServerTime;		
			this._timerBar = new TimerBar(this);
            this._timerBar.AddSource(_infor._bar,this._aryTimeSource);
			
			this._bg.width = 300;
			//this._bg.height = (this._textShow.height - (80 - 6) <= 80)?80:this._textShow.height - (80 - 6);
			this._bg.height = 80; 
			
		}
		
		
		//---更新時間/更新數據/更新頭相圖片-----
		public function ResetInforTime(_obj:SendTips):void 
		{
			if (_obj.picItem != null && _obj.picItem != "") this._item.Reset(_obj.picItem);
			
			this._timerBar.SetHandler(_obj.nowTime, _obj.complete, _obj.total);
			this.resetViewHandler(_obj);
			/*
			if (_obj._system!=this._tipStatus) {
			   //---更換系統
				
			   }else {
				
				
			}*/
			
			
			/*
			if(_obj._text != null && _obj._text != undefined) {
				this._tipProperty.ReSetHandler(_obj._text);
				} else {
				this._tipProperty.AddNumerical(_infor._text);
			}
			*/
		}
		//--this._tipStatus=1.大廳（魔法陣）, 2.巢穴, 3.溶解所, 4.圖書館, 5.儲藏室, 6.煉金所, 7.牢房, 8.英靈室
		private function resetViewHandler(_obj:SendTips):void 
		{
			switch(_obj.buildType) {
				
			    case 3:
					//-----3.溶解所
					if (this._tipStatus != _obj.buildType && this._tipProperty==null) {
						this._tipProperty = new TipProperty(this);
						this._tipProperty.AddNumerical(_obj.scherObject);
						this._tipStatus = _obj.buildType;
						//-----移除舊的class----
						if (this._tipSkill != null) {
							this._tipSkill.Remove();
							this._tipSkill = null;
						}
						} else {
						this._tipProperty.ReSetHandler(_obj.scherObject);
					}
					
			    break;
				
			    case 4:
				//----4.圖書館
				if (this._tipStatus != _obj.buildType && this._tipSkill==null) {
						this._tipSkill = new SkillPic(this._arySkillSource,this);
						this._tipStatus = _obj.buildType;
						//-----移除舊的class----
						if (this._tipProperty != null) {
							this._tipProperty.RemoveNumerical();
							this._tipProperty = null;
						} 
						
					}
					//-----顯示學了啥小(技能類群圖片的顯示圖片)
					this._tipSkill.SetView(_obj.scherObject._index);
				
			    break;	
				
				
			    case 6:
				//-----6.煉金所
				if (this._tipStatus != _obj.buildType && this._tipProperty==null) {
						this._tipProperty = new TipProperty(this);
						this._tipProperty.AddNumerical(_obj.scherObject);
						this._tipStatus = _obj.buildType;
						//-----移除舊的class----
						if (this._tipSkill != null) {
							this._tipSkill.Remove();
							this._tipSkill = null;
						}
						} else {
						this._tipProperty.ReSetHandler(_obj.scherObject);
				}
			    break;	
				
			    case 7:
				//----牢房
			    break;
				
			  
			}
			
			
			
		}
		
		
		
		override public function OpenClose(_flag:Boolean):void 
		{
			
			if (_flag==true) {
				//----註冊----
				if (!TimeDriver.CheckRegister(this._timerBar.TimingHandler)) {
			     //----準備註冊阿翔的timer
			        TimeDriver.AddDrive(1000, 0, this._timerBar.TimingHandler);
					trace("register[TIPS]_timerDriver");
			     }
				} else {
				//---移除註冊
				if (TimeDriver.CheckRegister(this._timerBar.TimingHandler)) {
					TimeDriver.RemoveDrive(this._timerBar.TimingHandler);
					trace("remove[TIPS]_timerDriver");
				}
			}
			this.visible = _flag;
			this._timerBar.OpenCloseFlag(_flag);
		}
		
		
		override public function CleanALL():void 
		{
			
			
		}
		
		
	}
	
}