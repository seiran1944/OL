package MVCprojectOL.ControllOL.TurntableCtrl 
{
	import flash.display.Sprite;
	import MVCprojectOL.ModelOL.SkillData.SkillDataCenter;
	import MVCprojectOL.ModelOL.SkillDisplayModel.SkillDisplay;
	import MVCprojectOL.ModelOL.SkillDisplayModel.SkillDisplayProxy;
	import MVCprojectOL.ModelOL.ViewSharedModel.ViewSharedModel;
	import MVCprojectOL.ViewOL.TurntableView.TurntableViewCtrl;
	import Spark.coreFrameWork.commands.CatchCommands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	import strLib.commandStr.UICmdStrLib;
	import strLib.GameSystemStrLib;
	import strLib.proxyStr.ProxyNameLib;
	import strLib.vewStr.ViewNameLib;
	/**
	 * ...
	 * @author brook
	 */
	public class CatchTurntableControl extends CatchCommands
	{
		private var _SourceProxy:SourceProxy;
		private var _ViewSharedModel:ViewSharedModel;
		private var _TurntableViewCtrl:TurntableViewCtrl;
		private var _SkillDisplayProxy:SkillDisplayProxy;
		
		private const _GlobalComponentPackKey:String = "GUI00002_ANI";//公用素材包KEY碼
		private const _GlobalComponentClasses:Vector.<String> = new < String >  [  "BgB" , "CheckBtn", "DemonAvatar", "EdgeBg", "CheckBtn"];
		private var _ComponentClasses:Object;
		
		public var _SharedKey:String = "GUI00015_ANI";// 素材包KEY碼
		public var _SharedClasses:Vector.<String> = new < String > ["ContentBg", "BrickBg", "ListBg", "List"];
		private var _SharedComponentClasses:Object;
		
		private var _Guid:String;
		
		public function CatchTurntableControl() 
		{
			
		}
		
		private function initTurntableCore():void 
		{
			this._SourceProxy = SourceProxy.GetInstance();
			var _ComponentExist:Boolean = this._SourceProxy.CheckMaterialDepot( this._GlobalComponentPackKey );
			
			if ( _ComponentExist == true ) {
				this._ComponentClasses = this._SourceProxy.GetMaterialSWP( this._GlobalComponentPackKey , this._GlobalComponentClasses );
				
				this._ViewSharedModel = ViewSharedModel.GetInstance();
				this._facaed.RegisterProxy( this._ViewSharedModel );
				this._ViewSharedModel._SharedKey = this._SharedKey;
				this._ViewSharedModel._SharedClasses = this._SharedClasses;
				this._ViewSharedModel.StartLoad( this._SharedKey );
				
				trace("素材OK !!");
			}else {
				trace("素材不OK !!");
				this.TerminateThis();
			}
		}
		
		private function TerminateThis():void 
		{
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_SharedUIproxy );
			this._facaed.RemoveProxy( ProxyNameLib.Proxy_SkillDisplayProxy );
			this._facaed.RemoveRegisterViewCtrl( ViewNameLib.View_Turntable );
			
			this._ViewSharedModel = null;
			this._SkillDisplayProxy = null;
			this._TurntableViewCtrl = null;
			
			this.SendNotify( UICmdStrLib.Terminate_Turntable );
		}
		
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void 
		{
			var _Signal:String = _obj.GetName() as String;
			switch ( _Signal ) 
			{
				case UICmdStrLib.Init_TurntableCatch:
					this._Guid = _obj.GetClass()._Guid;
					this.initTurntableCore();
				break;
				case this._SharedKey :
					this._SharedComponentClasses = _obj.GetClass();
					this.OnTurntable();
				break;
				case UICmdStrLib.StartTurntable :
					this._Guid = _obj.GetClass()._Guid;
					this.GetMaterial(true);
				break;
				case UICmdStrLib.RemoveTurntable :
					this.TerminateThis();
				break;
			}
		}
		
		private function OnTurntable():void 
		{
			this._SkillDisplayProxy = SkillDisplayProxy.GetInstance();
			this._facaed.RegisterProxy( this._SkillDisplayProxy );
			
			var _DisplayConter:Sprite = ProjectOLFacade.GetFacadeOL().GetDisplayConter( GameSystemStrLib.GameSystemView );
			this._TurntableViewCtrl = new TurntableViewCtrl ( ViewNameLib.View_Turntable , _DisplayConter );
			this._facaed.RegisterViewCtrl( this._TurntableViewCtrl );//註冊溶解所ViewCtrl
			
			this._TurntableViewCtrl.AddElement(this._ComponentClasses, this._SharedComponentClasses);
			this._TurntableViewCtrl.AddPanel();
			
			this.GetMaterial(false);
		}
		
		private function GetMaterial(_CtrlBoolean:Boolean):void 
		{
			var _ary:Array = SkillDataCenter.GetInstance().GetRandomSkillInfo(10);
			var _aryLength:int = _ary.length;
			var _SkillDisplay:Vector.<SkillDisplay> = new Vector.<SkillDisplay>;
			var _SkillStr:Vector.<String> = new Vector.<String>;
			for (var i:int = 0; i < _aryLength; i++) 
			{	
				_SkillStr.push( _ary[i]._guid);
			}
			_SkillStr.push(this._Guid);
			//trace(this._Guid,"@@@@@@@@@@@@@@@");
			this._SkillDisplayProxy.GetSkillDisplayList(_SkillStr);
			for (var j:int = 0; j < _SkillStr.length; j++) 
			{
				_SkillDisplay.push(this._SkillDisplayProxy.GetSkillDisplayClone(_SkillStr[j]));
			}
			this._TurntableViewCtrl.AddMaterialNumber(_SkillDisplay, _CtrlBoolean);
		}
		
		override public function GetListRegisterCommands():Array {
			return [UICmdStrLib.Init_TurntableCatch,
					this._SharedKey,
					UICmdStrLib.StartTurntable,
					UICmdStrLib.RemoveTurntable
					];
		}
		
	}
}