package MVCprojectOL.ViewOL.MainView
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import MVCprojectOL.ViewOL.AllinOnePanel;
	import strLib.commandStr.PVECommands;
	import strLib.commandStr.ViewSystem_BuildCommands;
	import strLib.vewStr.ViewStrLib;
	
	/**
	 * ...
	 * @author EricHuang
	 * ----共用view元件---
	 */
	public class MainSystemPanel extends AllinOnePanel
	{
		private var _displayLayer:DisplayObjectContainer
		private var _conterBox:MainViewBGSystem;
		private var _sprBgConter:Sprite;
		public function MainSystemPanel(_viewConter:DisplayObjectContainer) 
		{
			this._sprBgConter = new Sprite();
			this._conterBox = new MainViewBGSystem(_viewConter);
			super(_sprBgConter, ViewStrLib.Panel_Main);
			
		}
		
		override public function AddBG(_pic:*):void 
		{
			this._conterBox.AddBG(_pic);
			this._conterBox.AddSystemSpr(this._sprBgConter);	
		}
		
		public function ResetBg(_pic:*):void 
		{
		  //this._conterBox.ResetBG(_pic);	
		}
		
		public function AddVaule(_vaules:*):void 
		{
			this.AddvauleHandler(_vaules);
		}
		
		//----you can do anything-------
		override protected function PublicSystemHandler(_key:String,_obj:Object=null):void 
		{
			
			switch(_key) {
			   case "Exit":
				   //---use exit system-------
				   trace("---use Remove---");
				   this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SWICH,{_btnName:"EXIT"});
				   if (this.getClassLen() > 0 ) {
					 //this.RemoveClass();  
					   }else {
						   
					 this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_CREAT);
					}
					
					
				   //this.SendNotify(PVECommands.CHANGE_MOTIONCMD,_obj);
				  
				   
			   break;
			   
			   
			   case "Back":
				   //---use exit system-------
				   //trace("---use Other Class---");
				   
				   
				   
				   
			   break;
			   //---探索移除該面板的功能按鈕
			   
			   //----className--- 
		       case "ExploreBack":
			    this.SendNotify(ViewSystem_BuildCommands.MAINVIEW_SWICH,{_btnName:"buildUP"});
			    //if (this.getClassLen() > 0 ) this.RemoveClass();  
			    
				
				/*
			    if (getQualifiedClassName(this.)) {
				
					
				}*/
            	//var _strTest:String = this.GetClassName();
				//trace("hello");
			   break;
			}
			
		}
		//--0516佔代---
		public function UseprotectedFunction(_str:String):void 
		{
			this.PublicSystemHandler(_str);
		}
		
		/*
		public function RemoveClassAry():void 
		{
			if (this.getClassLen()>0) {
				this.RemoveClass();
				
			}	
		}*/
		
		//-----change/switch--allinone---
		public function SwitchMotion(_str:String,_pic:Class=null):void 
		{
			this._conterBox.SwitchMotion(_str,_pic);
		}
		
		//---init Star-----
		public function StarShow():void 
		{
			this._conterBox.StarShow();
		}
		override public function onRemoved():void 
		{ 
			if (this.getClassLen()>0) {
				this.RemoveClass();
			}	
		};
		
	}
	
}