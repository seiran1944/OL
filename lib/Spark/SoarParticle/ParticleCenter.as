package Spark.SoarParticle
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import Spark.coreFrameWork.ProxyMode.ProxY;
	import Spark.ErrorsInfo.MessageTool;
	import Spark.SoarParticle.basic.IEffect;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #13.03.14.17.53
		@documentation 特效調用中心
	 */
	public class ParticleCenter
	{
		
		//public static const PARTICLE_SYSTEM:String = "particleSystem";//註冊系統
		public static const PARTICLE_COMPLETE:String = "particleComplete";//SendNotify 通知呼叫初始化完成
		private var _dicParticle:Dictionary;
		//private var _dicCatch:Dictionary;
		private var _list:ParticleList;
		private var _vecInit:Vector.<String>;
		private static var _particleCenter:ParticleCenter;
		
		
		public function ParticleCenter():void 
		{
			if (ParticleCenter._particleCenter) throw new Error("ParticleCenter can't be construct");
			this._dicParticle = new Dictionary(true);
			//this._dicCatch = new Dictionary(true);
			ParticleCenter._particleCenter = this;
			//super(ParticleCenter.PARTICLE_SYSTEM, this);
			this._list = new ParticleList();
		}
		
		public static function GetInstance():ParticleCenter
		{
			if (ParticleCenter._particleCenter == null) ParticleCenter._particleCenter = new ParticleCenter();
			return ParticleCenter._particleCenter;
		}
		
		
		//註冊效果完畢後的運行位置 //有設置特效運行時間的註冊才會有通知反應//無限運行則否//調整了註冊方式取代掉原先的名稱註冊
		public function RegisterParticle(particle:IEffect,endProcess:Function):void
		{
			this._dicParticle[particle] = endProcess;
		}
		
		//特效發出終了通知(特效內部的操作)
		public function EffectNotify(target:IEffect):void
		{
			if (target in this._dicParticle) {
				try {
					this._dicParticle[target].apply(null, [target]);
					delete this._dicParticle[target];
				}catch (e:Error){
					MessageTool.InputMessageKey(012);//註冊的function需要接一個參數(IEffect)
					trace("The IEffect is End of playing>>" + e);
				}
			}
			target.Destroy();
		}
		
		//目前只有 惡魔炸裂 / 模糊扭曲 效果需要圖像素材
		//藉由Key撈取對應particle與素材
		public function GetParticleByKey(key:String,sourceNeeded:BitmapData=null):IEffect
		{
			return this._list.GetParticle(key,sourceNeeded);
		}
		
		
		
		
		
		
		
		
		
	}
	
}