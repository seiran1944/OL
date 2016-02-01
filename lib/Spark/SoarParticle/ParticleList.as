package Spark.SoarParticle
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import Spark.SoarParticle.basic.IEffect;
	import Spark.SoarParticle.filterEffect.CandleFire;
	import Spark.SoarParticle.filterEffect.Flutter;
	import Spark.SoarParticle.filterEffect.Smog;
	import Spark.SoarParticle.particleEffect.Beam;
	import Spark.SoarParticle.particleEffect.Blast;
	import Spark.SoarParticle.particleEffect.Boom;
	import Spark.SoarParticle.particleEffect.CircleWave;
	import Spark.SoarParticle.particleEffect.Concenter;
	import Spark.SoarParticle.particleEffect.Cure;
	import Spark.SoarParticle.particleEffect.Curve;
	import Spark.SoarParticle.particleEffect.ELightning;
	import Spark.SoarParticle.particleEffect.Explode;
	import Spark.SoarParticle.particleEffect.Light;
	import Spark.SoarParticle.particleEffect.Linear;
	import Spark.SoarParticle.particleEffect.Pulsation;
	import Spark.SoarParticle.particleEffect.Shine;
	import Spark.SoarParticle.particleEffect.Smash;
	import Spark.SoarParticle.particleEffect.Sparkler;
	import Spark.SoarParticle.particleEffect.Splash;
	import Spark.SoarParticle.particleEffect.Sun;
	import Spark.ErrorsInfo.MessageTool;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.12.06.14.50
		@documentation 特效回傳清單
	 */
	public class ParticleList
	{
		
		public var _defaultWidth:Number = 100; //預設標準寬
		public var _defaultHeight:Number = 100; //預設標準高
		public var _defaultCenter:Point; //預設中心點
		
		public function ParticleList():void
		{
			this._defaultCenter = new Point(this._defaultWidth >> 1 , this._defaultHeight >> 1);
		}
		
		//None of use
		//public function GetSource(key:String,source:BitmapData):Object
		//{
			//var objCatch:Object = { "_particle" : this.GetParticle(key, source),"_source" :this.GetMeterial(key) };
			//
			//return objCatch;
		//}
		
		public function GetParticle(key:String,source:BitmapData):IEffect
		{
			var particleEffect:Object;
			switch (key) 
			{
				case "0001"://聲納效果
					particleEffect = new Curve(key, this._defaultWidth, this._defaultHeight,0xFFF0F0F0);
					particleEffect.Init(this._defaultCenter);
				break;
				case "0002"://目標碎裂飛散
					if (source != null) {
						particleEffect = new Smash(key, source);
						particleEffect.Init(2.25);
					}else {
						MessageTool.InputMessageKey(003);//需要素材檔案
					}
				break;
				case "0003"://新星大爆炸貌
					particleEffect = new Explode(key,this._defaultWidth, this._defaultHeight, 0xFFF0F0F0);
					particleEffect.Init(this._defaultCenter);
				break;
				case "0004"://閃爍貌
					particleEffect = new Light(key, this._defaultWidth, this._defaultHeight, 0xFFF0F0F0);
					particleEffect.Init(this._defaultCenter);
				break;
				case "0005"://單線段
					particleEffect = new Linear(key, this._defaultWidth, this._defaultHeight, 0xFFF0F0F0);
					particleEffect.Init(new Point(50,10), new Point(50,150));//寬高設定100的狀況下
				break;
				case "0006"://水波貌波動
					particleEffect = new Pulsation(key, this._defaultWidth, this._defaultHeight, 0xFFF0F0F0);
					particleEffect.Init(this._defaultCenter);
				break;
				case "0007"://橢圓閃耀上升光點
					particleEffect = new Shine(key, this._defaultWidth, this._defaultWidth, 0xFFF0F0F0);
					particleEffect.Init(this._defaultCenter);
				break;
				case "0008"://液態疊加飛濺狀態
					particleEffect = new Splash(key, this._defaultWidth, this._defaultHeight, 0xFFF0F0F0);
					particleEffect.Init();
				break;
				case "0009"://傳送降落效果(點光柱)
					particleEffect = new Beam(key, this._defaultWidth, this._defaultHeight*2, 0xFFF0F0F0);
					particleEffect.Init(30);
				break;
				case "0010"://弧狀爪痕跳躍
					particleEffect = new Blast(key, this._defaultWidth, this._defaultHeight, 0xFFF0F0F0);
					particleEffect.Init(new Point(30,30), new Point(80, 80), 20);
				break;
				case "0011"://漩渦風暴
					particleEffect = new CircleWave(key, this._defaultWidth, this._defaultHeight, 0xFFF0F0F0);
					particleEffect.Init(this._defaultCenter);
				break;
				case "0012"://線條中心聚集
					particleEffect = new Concenter(key, this._defaultWidth, this._defaultHeight, 0xFFF0F0F0);
					particleEffect.Init(this._defaultCenter);
				break;
				case "0013"://衝擊波圓環隨機炸裂波動
					particleEffect = new Boom(key, this._defaultWidth, this._defaultHeight, 0xF0F0F0F0);
					particleEffect.Init();
				break;
				case "0014"://中心擴散粒子
					particleEffect = new Sun(key, this._defaultWidth, this._defaultHeight, 0xFFF0F0F0);
					particleEffect.Init(this._defaultCenter);
				break;
				case "0015"://煙火炸裂 (兩倍寬高)
					particleEffect = new Sparkler(key, 2*this._defaultWidth, 2*this._defaultHeight, 0xFFF0F0F0);
					particleEffect.Init(new Point(100,100));
				break;
				case "0016":
					particleEffect = new Cure(key, this._defaultWidth, this._defaultHeight, 0xFFF0F0F0);
					particleEffect.Init();
				break;
				case "0017"://閃電效果 ( 可調閃動或電流 參數內建調整在方法內)
					particleEffect = new ELightning(0xFFFFFFFF, 2, 0, key);
					particleEffect.Init();//躍動閃電模式
				break;
				//=======================================================================================↑ParticleEffect
				//=======================================================================================↓FilterEffect
				case "001"://燭火(SPRITE)
					particleEffect = new CandleFire(key);
				break;
				case "002"://煙霧效果
					particleEffect = new Smog(key, this._defaultWidth*2, this._defaultHeight*3);
					particleEffect.Init(this._defaultWidth , this._defaultHeight*2.5);
				break;
				case "003"://模糊扭曲效果
					if (source != null) {
						particleEffect = new Flutter(key, source);
						particleEffect.Init();
					}else {
						MessageTool.InputMessageKey(003);//需要素材檔案
					}
				break;
			default:
				//MessageTool.InputMessageKey(001);//找無key
				particleEffect = null;
			}
			
			return particleEffect as IEffect;
		}
		
		//撈取素材類型//None of use
		//public function GetMeterial(key:String):Object
		//{
			//素材初始化撈取後,再次由key去素材庫兌換
			//var source:Object;
			//switch (key) 
			//{
				//case "001":
					//
				//break;
			//default:
				//source = null;
			//}
			//
			//return source;
		//}
		
		
		
		
	}
	
}