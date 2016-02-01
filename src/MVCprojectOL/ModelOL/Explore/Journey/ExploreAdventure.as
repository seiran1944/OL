package MVCprojectOL.ModelOL.Explore.Journey {
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.05.23.11.09
	 */
	
	import flash.net.registerClassAlias;
	import MVCprojectOL.ModelOL.Explore.Data.ExploreDataCenter;
	import MVCprojectOL.ModelOL.Monster.MonsterProxy;
	import MVCprojectOL.ModelOL.Vo.Explore.Get_NewRoute;
	import MVCprojectOL.ModelOL.Vo.Explore.RouteNode;
	import Spark.coreFrameWork.Interface.IfProxy;
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.MVCs.Models.NetWork.NetEvent;
	import Spark.MVCs.Models.NetWork.NetResultPack;
	import strLib.commandStr.ExploreAdventureStrLib;
	 
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.CommandsStrLad;
		
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
		
	//import MVCprojectOL.ModelOL.Explore.ExploreEvent;
		
	//----------------------------------------------------------------------VOs
	//import MVCprojectOL.ModelOL.Vo.Get.Get_ExploreFightResult; //wasted 121009
	
		
	//import MVCprojectOL.ModelOL.Vo.Get.Get_NewRoute;
	//import MVCprojectOL.ModelOL.Vo.RouteNode;
		
	//import MVCprojectOL.ModelOL.Vo.Get.Get_ExploreData;
	import MVCprojectOL.ModelOL.Vo.ExploreData;
		
	import MVCprojectOL.ModelOL.Vo.Set.Set_RouteChoice;
	import MVCprojectOL.ModelOL.Vo.ExploreFightResult;
	//-------------------------------------------------------------END------VOs
	
	import MVCprojectOL.ModelOL.GameInfomation.PlayerNotifyCenter;
	
	import strLib.proxyStr.ProxyNameLib;
		
	public class ExploreAdventure extends ProxY{//extends ProxY
		private static var _ExploreAdventure:ExploreAdventure;
		
		private var _CurrentAreaID:String;
		private var _CurrentTeamID:String;
		
		private var _CurrentSceneData:ExploreData;
		private var _CurrentRoute:RouteNode;
		
		private var _CurrentFightResult:ExploreFightResult;
		
		
		//private var _PlayerNotifyCenter:PlayerNotifyCenter = PlayerNotifyCenter.GetInstance();
		private var _Net:AmfConnector = AmfConnector.GetInstance();
		
		private var _ExploreDataCenter:ExploreDataCenter = ExploreDataCenter.GetInstance();
		
		private var _MonsterProxy:MonsterProxy;
		
		private var _serverCurrentStatus:String;
		
		public static function GetInstance():ExploreAdventure {
			return ExploreAdventure._ExploreAdventure = ( ExploreAdventure._ExploreAdventure == null ) ? new ExploreAdventure() : ExploreAdventure._ExploreAdventure; //singleton pattern
		}
		
		public function ExploreAdventure() {
			//constructor
			super( ProxyNameLib.Proxy_ExploreAdventure , this );
			ExploreAdventure._ExploreAdventure = this;
			EventExpress.AddEventRequest( NetEvent.NetResult , this.onNetResult , this );//建立連線事件接收
			trace( "ExploreAdventure constructed !!" );
		}
		
		public function InitModule( _InputAreaGuid:String , _InputTeamGuid:String , _InputMonsterProxy:IfProxy ):void {
			this._CurrentAreaID = _InputAreaGuid;
			this._CurrentTeamID = _InputTeamGuid;
			
			trace( "Explore Adventure initing" , this._CurrentAreaID , this._CurrentTeamID );
			//在這裡發送LOADING指令	130218
			
			
			//--------------------------------------------------------------------設定怪物疲勞
			this._MonsterProxy = _InputMonsterProxy as MonsterProxy;
			
			var _TeamMemberKeys:Object = this._ExploreDataCenter._currentSelectedTeamMember;
			var _TeamFatigueValuePack:Object;
			var _FatigueValuePackList:Array = [];
			for (var i:* in _TeamMemberKeys) {
				_TeamFatigueValuePack = { };
				_TeamFatigueValuePack[ "_key" ] = _TeamMemberKeys[ i ];
				_TeamFatigueValuePack[ "_vaule" ] = 1;
				_FatigueValuePackList.push( _TeamFatigueValuePack );
			}
			
			this._MonsterProxy.SetFatigueValue( _FatigueValuePackList );
			//-----------------------------------------------------------END------設定怪物疲勞
			
			//this.GetExploreData( this._CurrentAreaID , this._CurrentTeamID );//取得探索場景資料
		}
		
		private function TerminateModule():void {
			//EventExpress.RevokeEventRequest( NetEvent.NetResult , this.onNetResult );//終結連線事件接收
			EventExpress.RevokeAddressRequest( this.onNetResult );//終結連線事件接收
			ExploreAdventure._ExploreAdventure = null;
		}
		
		public override function onRemovedProxy():void {
			this.TerminateModule();
			//this._serverCurrentStatus != "503" ? this.EndExploreRoute() : null;
		}
		
		//=========================================================================Actions
		/*private function GetExploreData( _InputAreaGuid:String , _InputTeamGuid:String ):void {
			//this._Net.VoCall( new Get_ExploreData( _InputAreaGuid ) );
			this._Net.Call( "new Get_ExploreData( _InputAreaGuid )" );//取得總探索場景資料
		}*/
		
		public function GetNewRoute( _InputCurrentRouteNode:RouteNode = null ):void {//0.沒事, 1.惡魔, 2.寶箱, 3.安全, 4.魔王
			//this._Net.VoCall( new Get_NewRoute( this._CurrentAreaID , this._CurrentTeamID , this._ExploreDataCenter._currentUsingSceneKey ) );//取得新節點
			//this._Net.VoCall( new Get_NewRoute( this._ExploreDataCenter._histroy , _InputCurrentRouteNode ) );//取得新節點
			//registerClassAlias( "Get_NewRoute" , Get_NewRoute );//取得NewRoute資訊
			//registerClassAlias( "RouteNode" , RouteNode );//
			//_InputCurrentRouteNode != null ? this._ExploreDataCenter._stepHistory.push( _InputCurrentRouteNode._type ) : null;//更新歷史資訊
			
			var _QQ:Get_NewRoute = new Get_NewRoute( this._ExploreDataCenter._stepHistory , _InputCurrentRouteNode );
			//var _QQ:Get_NewRoute = new Get_NewRoute( );
			/*trace( "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 節點資訊" );
			trace( _QQ._areaID );
			trace( _QQ._teamID );
			trace( _QQ._playerID );
			trace( _QQ._replyDataType );
			trace( _QQ._step );
			trace( _QQ._token );
			trace( _QQ._type );
			trace( _QQ._stepHistory );
			trace( "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" );*/
			
			this._Net.VoCall( _QQ );//取得新節點
		}
		
		private function EndExploreRoute():void {
			var _QQ:Get_NewRoute = new Get_NewRoute( this._ExploreDataCenter._stepHistory );
				_QQ._type = -1;
			this._Net.VoCall( _QQ );//取得新節點
		}
		/*public function SetRouteChoice():void {
			this._Net.Call( "new Set_RouteChoice( _InputNodeGuid:String )" );//回報玩家選擇之路徑  ( 並同時回傳戰鬥結果 )//"ExploreFightResult"
			this.GetNewRoute();//同時取得新路徑節點
		}*/
		
		/*public function GetExploreResult( _InputNodeID:String , _InputTeamID:String ):void {
			this._Net.Call( "new Get_ExploreResult( _InputNodeID , _InputTeamID )" );//Get_ExploreFightResult
		}*/
		
		/*public function UseRecoveryItem():void {//探索中使用道具 ( 回復血量 ) //扣台錢
			//前串 流程		//wasted 121009
				//當有道具時 開啟道具選單(外部道具控制器的工作)//wasted 121009
				//當無道具時 開啟道具商城(外部道具控制器的工作)//wasted 121009
				
				
			//this._CurrentScene._RecoveryCost //須先檢查遊戲幣是否足夠
				//this.SendNotification( "UseItem" , _InputItemKey );//通知View顯示使用道具的動態 _InputItemKey 用來決定施放動態的種類
			
		}*/
		
		public function EndExplore():void {//結束&退出探索
			//發出中途結束訊號
			
			this.SendQuitExploreNotify();
			
		}
		
		/*public function FeedbackMonsterValue():void {//回寫資料回怪物數值中心
			
		}*/
		
		//================================================================END======Actions
		
		
		
		//=====================================================================Net message transport router
		private function onNetResult( _Result:EventExpressPackage ):void {
			var _NetResultPack:NetResultPack =  _Result.Content as NetResultPack;
			//EventExpress.RevokeEventRequest( NetEvent.NetResult , this.onNetResult );
			switch ( _Result.Status ) {
				
				case "ExploreData" ://場景資訊
						this._CurrentSceneData = _NetResultPack._result as ExploreData;
						this.SendExploreStartedNotify( this._CurrentSceneData );
						this.GetNewRoute();	//場景初始後 取得第一個路徑節點
					break;
					
				case "RouteNode" ://新路徑 取得
						trace( "已取得新路徑" );
						this._serverCurrentStatus = _NetResultPack._serverStatus;
						this._CurrentRoute = _NetResultPack._result as RouteNode;	// this.DeserializeRouteData( _NetResultPack._Result );
						//this._CurrentRoute._itemDrop != null ? this._ExploreDataCenter.AddToExploreReport( this._CurrentRoute._itemDrop ) : null;//若有掉落物則加入報告清單內
						//尚缺掉落通知
						this.SendNewRouteNotify( { "NewNode" : this._CurrentRoute } );
					break;
					
				case "ExploreFightResult" ://戰鬥結果
						this._CurrentFightResult = _NetResultPack._result as ExploreFightResult;
						this.SendFightResult( this._CurrentFightResult );	//發送戰鬥結果
						this.JudgeMissionEnd( this._CurrentFightResult , this._CurrentSceneData );	//檢查結束階段
					break;
					
				default :
					break;
				
			}
		}
		//=============================================================END=====Net message transport router
		
		
		
		//======================================================================Condition judges
		
		private function JudgeMissionEnd( _InputExploreFightResult:ExploreFightResult , _InputExploreData:ExploreData ):void {
			//判斷探索是否到達終點
				//已到達終點則發出完成訊號
			( _InputExploreFightResult._CurrentStep >= _InputExploreData._TotalLevel ) ? this.SendExploreCompleteNotify() : null;
			
		}
		
		public function AllyCasualtiesCheck():Array {//我方戰損狀態判斷  RouteNode._valuePack
			var _InputValuePack:Object = this._ExploreDataCenter._currentRouteNode._valuePack;
			var _CasualtyList:Array = [ ];
			for ( var i:* in _InputValuePack ) {
				if ( _InputValuePack[ i ]._hp <= 0) {//將沒血的惡魔挑出來
					_CasualtyList.push( this._ExploreDataCenter._currentSelectedTeamMemberPos[ i ] );
				}
			}
			this._ExploreDataCenter._currentCasualtiesList[ "left" ] = _CasualtyList;
			return _CasualtyList;//在清單內的人代表已陣亡
		}
		
		public function NewCasualties():void {
			//_CasualtyList.indexOf
		}
		
		
		//=============================================================END======Condition judges
		
		
		
		
		
		
		//====================================================================================Send message    這些應該要在控制器中聽 並做出對應動作 130205
		
		private function SendFightResult( _InputFightResult:ExploreFightResult ):void { //_InputExploreFightResult:ExploreFightResult
			//發送戰鬥結果
			//this.SendNotification( "FightResult" , _InputExploreFightResult );
			//Note : 需註冊CommandsStrLad.as的事件通知
				//@mediator 的作法
					// 1.Command由已註冊的mediator 中介者收到訊息通知 後 將組隊怪物的資料回填怪物狀態列表
					// 2.View由已註冊的mediator 中介者收到訊息通知 後 更新探索介面上的怪物狀態 (血量、死亡狀態)
					
				//@Singleton 調用的做法
					//調用怪物數值寫入控制器，將物件塞入，由控制器寫入並通知View更新探索介面上的怪物狀態 (血量、死亡狀態)
					
					
			//Note : 安全路徑回血、寶箱、使用商城幣回血、怪物戰鬥，皆視為戰鬥
			//ExploreEvent.Explore_FightResult;
		}
		
		private function SendNewRouteNotify( _InputRouteWrap:Object ):void {
			this.SendNotify( ExploreAdventureStrLib.ExploreAdventure_NewRouteNode , _InputRouteWrap );//傳送新的路徑節點通知外部更新
			//Note : 需註冊CommandsStrLad.as的事件通知
			//ExploreEvent.Explore_NewRouteNotify;
		}
		
		/*private function SendEngageNotify():void {
			//Note : 需註冊CommandsStrLad.as的事件通知
		}
		
		private function SendBountyNotify():void {
			//Note : 需註冊CommandsStrLad.as的事件通知
		}
		
		private function SendSafeNotify():void {
			//Note : 需註冊CommandsStrLad.as的事件通知
		}*/
		
		private function SendExploreStartedNotify( _InputExploreData:ExploreData ):void {
			//發送訊息通知該場探索已開始(資料已備妥)
			//this.SendNotification( "ExploreStarted" , _InputExploreData );//傳送新的路徑節點通知外部更新
			//Note : 需註冊CommandsStrLad.as的事件通知
			//ExploreEvent.Explore_ExploreStartedNotify;
		}
		
		private function SendQuitExploreNotify():void {
			//發送訊息通知該場探索已"中離"
			//Note : 需註冊CommandsStrLad.as的事件通知
			//ExploreEvent.Explore_QuitExploreNotify;
			
			this.TerminateModule();//終結這個類別
		}
		
		private function SendExploreCompleteNotify():void {
			//發送訊息通知該場探索已"完成"
			//Note : 需註冊CommandsStrLad.as的事件通知
			//終結時 必須刷新探索區域資訊  或是不刷新 待由下次模組啟動時刷新
			//ExploreEvent.Explore_ExploreCompleteNotify;
			
			this.TerminateModule();//終結這個類別
		}
		//==========================================================================END=======Send message
		
		
		
		
		
		
		
		
		
		
	}//end class

}//end package