package MVCprojectOL.ControllOL.SoundControlCenter {
	
	import flash.utils.setTimeout;
	import Spark.coreFrameWork.commands.CatchCommands;
	import Spark.coreFrameWork.commands.Commands;
	import Spark.coreFrameWork.Interface.IfNotifyInfo;
	import Spark.coreFrameWork.Interface.IfProxy;
	import Spark.Utils.KeyCodeInfo.UrlKeeper;
	//import strLib.commandStr.SoundEventStrLib;
	import MVCprojectOL.ControllOL.SoundControlCenter.SoundEventStrLib;

	import strLib.proxyStr.ProxyNameLib;
	
	import ProjectOLFacade;
	
	import Spark.MVCs.Models.SoundPlayer.BgmPlayer;
	import Spark.MVCs.Models.SoundPlayer.SoundEffect;
	
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.04.23.14.25
	 */
	public class CatchSoundControlCenter extends CatchCommands {
		
		private const _SoundEffect:SoundEffect = SoundEffect.GetInstance();
		private const _BgmPlayer:BgmPlayer = BgmPlayer.GetInstance();
		
		
		public function CatchSoundControlCenter() {
			trace( "SoundController is on duty !! Waiting for command.------" ); 
			//UrlKeeper.init();
			//this._SoundEffect.Play( "SND_0" );
			//setTimeout( this._SoundEffect.Play , 5000 , "SND_0" );
			
			//this._BgmPlayer.SwitchTo( "SND_0" );
		}
		
		/*private function Ignite():void {
			
			
			
		}*/
		
		
		
		
		/*private function TerminateThis():void {
			
		}*/
		
		
		
		//----------------------------------------------------------------------------------Command Router
		override public function ExcuteCommand( _obj:IfNotifyInfo ):void {
			
			var _Signal:String = _obj.GetName() as String;
			switch ( _Signal ) {
				
				case ( SoundEventStrLib.PlaySoundEffect ) :	//播放音效
						this._SoundEffect.Play( _obj.GetClass() as String );
					break;
					
				case ( SoundEventStrLib.StopSoundEffect ) :	//停止播放音效
						this._SoundEffect.Stop();
					break;
					
				case ( SoundEventStrLib.PlayBGM ) :
						//this._BgmPlayer.SwitchTo( _obj.GetClass() as String , uint.MAX_VALUE );
						//this._BgmPlayer.SwitchTo( _obj.GetClass() as String , 10000 );
					break;
					
				case ( SoundEventStrLib.PlayBgmSync ) :
						//this._BgmPlayer.ParallelSwitchTo( _obj.GetClass() as String , uint.MAX_VALUE );
						//this._BgmPlayer.ParallelSwitchTo( _obj.GetClass() as String , 10000 );
					break;
					
				case ( SoundEventStrLib.StopBGM ) :
						this._BgmPlayer.Stop();
					break;
					
					
					
					
				case ( SoundEventStrLib.NoSound ) :
						this._SoundEffect.setMute();
					break;	
					
				case ( SoundEventStrLib.NoMusic ) :
						this._BgmPlayer.Stop();
					break;
				
				case ( SoundEventStrLib.Mute ) :
						this._SoundEffect.setMute();
						this._BgmPlayer.Stop();
					break;
					
				default:
					break;
			}
		}
		//------------------------------------------------------------------------END-------Command Router
		
		
		
		
		override public function GetListRegisterCommands():Array {
			return [ SoundEventStrLib.PlaySoundEffect,
					 SoundEventStrLib.StopSoundEffect,
					 SoundEventStrLib.PlayBGM,
					 SoundEventStrLib.PlayBgmSync,
					 SoundEventStrLib.StopBGM,
					 SoundEventStrLib.NoSound,
					 SoundEventStrLib.NoMusic,
					 SoundEventStrLib.Mute
					];
		}
		
	}//end class
}//end package