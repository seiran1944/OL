package MVCprojectOL.ModelOL.TipsCenter.TipsLab
{
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.Vo.Tip;
	import strLib.proxyStr.ProxyPVEStrList;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class TipsDataLab
	{
		//private var _dicTips:Dictionary;
		private var _vecTips:Vector.<Tip>;
		private static var _TipsData:TipsDataLab;
		private var _sendFunction:Function;
		private var _flag:Boolean = false;
		
		public function TipsDataLab (_fun:Function) 
		{
			//this._dicTips = new Dictionary(true);
			this._vecTips = new Vector.<Tip>();
			this._sendFunction = _fun;
			//this._aryChangeTypeStr = [_aryQuaTxt,_arySkiClass,_arySkiLaunch,_arySkiExecute];
			
		}
		
		public static function GetTipsData(_fun:Function=null):TipsDataLab 
		{
			if (TipsDataLab._TipsData == null && _fun!=null) {
				
				TipsDataLab._TipsData  = new TipsDataLab(_fun);
			} 
		    return TipsDataLab._TipsData ;
		}
		
		
		public function AddTips(_ary:Array):void 
		{
			
			if (_ary.length>0 || _ary!=null) {
				var _len:int = _ary.length;
				for (var i:int = 0; i < _len;i++ ) {
					if (_ary[i] is Tip)this._vecTips.push(_ary[i]);
						
					
					/*
					if (this._dicTips[_ary[i]._keyVaule]==null || this._dicTips[_ary[i]._keyVaule]==undefined) {
						this._dicTips[_ary[i]._keyVaule] = _ary[i]._tips;
						
					}*/
					
				}
				
			}
			var _sendStr:String;
			if (this._flag==false) {
				this._flag = true;
				_sendStr = ProxyPVEStrList.TIP_PROXYReady;
				//} else {
				//_sendStr = ProxyPVEStrList.TIPSDATA_COMPLETE;
				
			}
			//this._aryQuaColor=PlayerDataCenter.GetQuaColor();
			//---sends----
			this._sendFunction(_sendStr);
			
		}
		
		
		public function GetTipsGroup(_ary:Array):Vector.<Tip> 
		{
			var _vec:Vector.<Tip> = new Vector.<Tip>();
			var _len:int = _ary.length;
			var _vecLen:int = this._vecTips.length;
			for (var i:int = 0; i < _len;i++ ) {

				for (var j:int = 0; j < _vecLen;j++ ) {
					if (_ary[i]==this._vecTips[j]._keyVaule) {
						var _tips:Tip = new Tip();
						_tips._keyVaule=this._vecTips[j]._keyVaule
						_tips._tips = this._vecTips[j]._tips;
						_vec.push(_tips);
						break;
					}
					
					
				}
				
			}
			return _vec;
			
		}
		
		//--取得單一TIPS----
		public function GetTipsDate(_key:String):String 
		{
			var _str:String = "";
			var _len:int = this._vecTips.length;
			for (var i:int = 0; i < _len;i++ ) {
				if (this._vecTips[i]._keyVaule==_key) {
					_str = this._vecTips[i]._tips;
					break;
				}
			}
			/*
			if (this._dicTips[_key]!=null && this._dicTips[_key]!=undefined) {
				_str = this._dicTips[_key];
			}
			*/
			return _str;
			
		}
		
	  
		
		public function GetColorChange(_int:int):String 
		{
			var _return:String = "";
			var _index:String = "";
			var _end:String = this.GetTipsDate("SysTip_QUACOLOR_END");
			//this._dicTips["SysTip_QUACOLOR_END"];
			if (_int>0) {
				_index = this.GetTipsDate("SysTip_EquPreColor1");
				//this._dicTips["SysTip_EquPreColor1"];
				_return = _index + " +"+_int+ _end;
				} else if(_int<0) {
				_index =  this.GetTipsDate("SysTip_EquPreColor2");
				//this._dicTips["SysTip_EquPreColor2"];
				_return = _index + " -"+_int+ _end;
				
			}
			
			return _return;
		}
		
		
	
		
		
		
	}
	
}