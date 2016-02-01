package MVCprojectOL.ModelOL.MotionSettings {
	/**
	 * ...
	 * @author K.J. Aris
	 * 
	 * 130110
	 */
	//import Spark.coreFrameWork.ProxyMode.ProxY;
	 
	//import Spark.MVCs.Models.NetWork.AmfConnector;
	//import Spark.MVCs.Models.NetWork.NetEvent;
	//import Spark.MVCs.Models.NetWork.NetResultPack;
	 
	import Spark.Utils.GlobalEvent.EventExpress;
	import Spark.Utils.GlobalEvent.EventExpressPackage;
	 
	//-----------------------------VOs
	//-----------------------------VOs

	//import Spark.CommandsStrLad;
	 
	 
	public final class MotionValue {//extends ProxY
		public static const MonsterMotionValueChanged:String = "MonsterMotionValueChanged";
		public static const SkillMotionValueChanged:String = "SkillMotionValueChanged";
		
		private static var _MotionValue:MotionValue;
		
		
		public const _DefaultFrameRate:uint = 100;
		public const _SkillTotalFrame:uint = 5;//技能動畫總頁數
		
		//----------Monster Motion
		private var _MonsterFrameRate:uint;//怪物動態播放速率
		private var _MonsterStunnedBlingTimes:uint = 2;//怪物受創閃爍次數
		private var _MonsterStunnedDuration:uint;//怪物受創定格時間
		private var _MonsterStunnedBlingInterv:Number;//怪物受創閃爍間隔
		
		//public var _MonsterExtraHurtGraphics:Array;//怪物額外動作圖列
		
		//----------Skill Motion
		private var _SkillFrameRate:uint;//技能動態播放速率
		
		
		public static function GetInstance():MotionValue {
			return MotionValue._MotionValue = ( MotionValue._MotionValue == null ) ? new MotionValue() : MotionValue._MotionValue; //singleton pattern
		}
		
		public function MotionValue() {
			MotionValue._MotionValue = this;
			this.Reset();
			//EventExpress.AddEventRequest( NetEvent.NetResult , this.onNetResult , this );//建立連線事件接收
		}
		
		private function SendNotify( _InputValueName:String , _InputValue:uint ):void {
			EventExpress.DispatchGlobalEvent( _InputValueName , null , _InputValue , this , false );
		}
		
		private function ConculateMonsterStunnedTime():uint {
			//怪物受攻擊陣和時間是由技能施放維持時間決定
			return this._SkillTotalFrame * this._SkillFrameRate;
		}
		
		private function ConculateMonsterStunnedBlingInterv():Number {
			//怪物受攻擊的閃爍是由技能施放維持時間決定每次閃動的間隔時間
			return ( this._MonsterStunnedDuration / (this._MonsterStunnedBlingTimes << 1) ) / 1000;
		}
		
		/**
		* 重設參數為預設值
		*/
		public function Reset():void {
			this.MonsterFrameRate = this._DefaultFrameRate;
			this.SkillFrameRate = this._DefaultFrameRate;
			
			this._MonsterStunnedDuration = this.ConculateMonsterStunnedTime();
			this._MonsterStunnedBlingInterv = this.ConculateMonsterStunnedBlingInterv();
		}
		
		
		
		
		//-------------------------------------------Getters
		/**
		* 怪物動畫速率
		*/
		public function get MonsterFrameRate():uint {
			return this._MonsterFrameRate;
		}
		
		/**
		* 技能動畫速率
		*/
		public function get SkillFrameRate():uint {
			return this._SkillFrameRate;
		}
		
		public function get MonsterStunnedBlingTimes():uint {
			return this._MonsterStunnedBlingTimes;
		}
		
		public function get MonsterStunnedDuration():uint {
			return this._MonsterStunnedDuration;
		}
		
		public function get MonsterStunnedBlingInterv():Number {
			return this._MonsterStunnedBlingInterv;
		}
		//-----------------------------------END-----Getters
		
		
		
		//-------------------------------------------Setters
		/**
		* 怪物動畫速率
		*/
		public function set MonsterFrameRate(value:uint):void {
			this._MonsterFrameRate = value;
			this.SendNotify( MotionValue.MonsterMotionValueChanged , this._MonsterFrameRate );
		}
		
		/**
		* 技能動畫速率
		*/
		public function set SkillFrameRate(value:uint):void {
			this._SkillFrameRate = value;
			this._MonsterStunnedDuration = this.ConculateMonsterStunnedTime();//怪物受創定格時間
			this._MonsterStunnedBlingInterv = this.ConculateMonsterStunnedBlingInterv();//怪物受創閃爍間隔
			this.SendNotify( MotionValue.SkillMotionValueChanged , this._SkillFrameRate );
		}
		
		
		
		
		
		
		//-----------------------------------END-----Setters
		
		
	}//end class
}//end package