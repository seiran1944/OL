package MVCprojectOL.ModelOL
{
	import Spark.MVCs.Models.NetWork.AmfConnector;
	import Spark.Timers.TimeDriver;
	
	/**
	 * ...
	 * @author EricHuang
	 *定時連線器(轉跳系統也會用到)
	 * 2013/2/20
	 *  
	 */
	public class  VoGroupCallCenter
	{
		
		private static var _VoGroupCallCenter:VoGroupCallCenter;
		
		public function VoGroupCallCenter() 
		{
		   if (VoGroupCallCenter._VoGroupCallCenter != null) throw Error("[VoGroupCallCenter] build illegal!!!please,use [Singleton]");
		}
		
		public static function GetVoGroupCallCenter():VoGroupCallCenter
		{
		  return VoGroupCallCenter._VoGroupCallCenter = (VoGroupCallCenter._VoGroupCallCenter==null)?new VoGroupCallCenter():VoGroupCallCenter._VoGroupCallCenter;
		}
		
		
		public function ToRun():void 
		{
			if (!TimeDriver.CheckRegister(this.voGroupHandler)) {
			  //----準備註冊阿翔的timer
			  TimeDriver.AddDrive(300000,0,this.voGroupHandler);	
			}
			
		}
		
		//----轉跳系統專用的連線----
		public function VoGroupCall():void 
		{
			this.voGroupHandler();
		}
		
		private function voGroupHandler():void 
		{
			if (this.checkVoCallHandler()==true) {
				
				AmfConnector.GetInstance().SendVoGroup();
			  }else{
			 return;	
			}
		}
		
		
		private function checkVoCallHandler():Boolean 
		{
			//var _ary:Array = AmfConnector.GetInstance().currentGroupRequestingList;
			var _return:Boolean=(AmfConnector.GetInstance().currentGroupRequestingList==null)?false:true;
			return _return;
		}
		
		
	}
	
}