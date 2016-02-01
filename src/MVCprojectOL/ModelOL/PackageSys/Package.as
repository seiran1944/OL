package MVCprojectOL.ModelOL.PackageSys
{
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.Equipment.EquipmentDataCenter;
	import MVCprojectOL.ModelOL.Monster.PlaySystemStrLab;
	import MVCprojectOL.ModelOL.SourceData.UserSourceCenter;
	import MVCprojectOL.ModelOL.Stone.StoneDataCenter;
	
	/**
	 * ...
	 * @author EricHuang
	 */
	public class Package  
	{
		//----10/02新增>>_style判斷是否為同一種的裝備/素材
		private static var _Package:Package;
		public function Package() 
		{
			
		}
		
		
		public static function GetPackag():Package
		{
			return Package._Package = (Package._Package==null)?new Package():Package._Package;
		}
		
		
		//----回傳整個背包(分類過的)
		public function GetALLPackage():Dictionary 
		{
		    var _dic:Dictionary = new Dictionary(true); 
			//-----<裝備>裡面裝ary----
			var _Equ:Dictionary =EquipmentDataCenter.GetEquipment().GetEquAllPackage();
			var _source:Array = UserSourceCenter.GetUserSourceCenter().GetAllUserSource();
			var _stone:Array = StoneDataCenter.GetStoneDataControl().GetAllStone();
			_dic[PlaySystemStrLab.Package_Weapon] = _Equ[PlaySystemStrLab.Package_Weapon];
			_dic[PlaySystemStrLab.Package_Shield]=_Equ[PlaySystemStrLab.Package_Shield];
			_dic[PlaySystemStrLab.Package_Accessories]=_Equ[PlaySystemStrLab.Package_Accessories];
			_dic[PlaySystemStrLab.Package_Source] = _source;
			_dic[PlaySystemStrLab.Package_Stone] = _stone;
			
			//-----剩下道具類型的東西尚未製作------
		    return _dic; 
		}
		
		//---取得該品項有多少數量----
		public function GetSingleNumber(_type:String):int 
		{
			var _return:int = 0;
			switch(_type) {
				
				case PlaySystemStrLab.Package_Source:
				_return=UserSourceCenter.GetUserSourceCenter().GetNowNumber();
				break;
				
			    case PlaySystemStrLab.Package_Stone:
				_return = StoneDataCenter.GetStoneDataControl().GetNowNumber();
				break;
				
			   default:
				_return=EquipmentDataCenter.GetEquipment().GetNowNumber(this.getsingleType(_type));   
			   break;	
			}
			
			return _return;
		}
		
		/*
		public function GetSingleData(): 
		{
			
		}*/
		
		//---取得單一的頁籤內容---
		public function GetSingleGoods(_str:String):Array 
		{
			var _type:int = this.getsingleType(_str);
			var _returnAry:Array;
			if (_type>=0) { 
				_returnAry = EquipmentDataCenter.GetEquipment().GetSingleTypeEqu(_type);
				} else {
				_returnAry = (_type==-1)?UserSourceCenter.GetUserSourceCenter().GetAllUserSource():StoneDataCenter.GetStoneDataControl().GetAllStone();
			}
			
			
		   return _returnAry;	
		}
		
		
		//----取得單一交易所玩家目前背包中可交易的品項----
		
		public function GetSingleSell(_str:String):Array 
		{
			var _type:int = this.getsingleType(_str);
			var _returnAry:Array;
			if (_type>=0) { 
				_returnAry = EquipmentDataCenter.GetEquipment().GetSingleSellEqu(_type);
				} else {
				//_returnAry = (_type==-1)?UserSourceCenter.GetUserSourceCenter().GetAllUserSource():StoneDataCenter.GetStoneDataControl().GetAllStone();
				//_returnAry = (_type==-2)?UserSourceCenter.GetUserSourceCenter().GetAllUserSource():StoneDataCenter.GetStoneDataControl().GetAllStone();
			    
				if(_type==-2)_returnAry=StoneDataCenter.GetStoneDataControl().GetSellStone();
				
			}
			
			
		   return _returnAry;
			
		}
		
		
		
		private function getsingleType(_str:String):int 
		{
			var _type:int = -1;
			if (_str == PlaySystemStrLab.Package_Weapon)_type = 0;
			if (_str == PlaySystemStrLab.Package_Shield)_type = 1;
			if (_str == PlaySystemStrLab.Package_Accessories)_type = 2;
			if (_str == PlaySystemStrLab.Package_Source)_type = -1;
			if (_str == PlaySystemStrLab.Package_Stone)_type = -2;
			return _type;
		}
		
		
		public function RemoveEqu(_index:String,_id:String,_type:int,_group:String=""):void 
		{
			if (_id!="") {
				
			 switch(_type) {
			  case PlaySystemStrLab.Package_Weapon || PlaySystemStrLab.Package_Shield || PlaySystemStrLab.Package_Accessories:	
				EquipmentDataCenter.GetEquipment().RemoveEquipment(_group, _id, _type); 
			  break;	
			  
			  
		     case PlaySystemStrLab.Package_Source:	
			   UserSourceCenter.GetUserSourceCenter().RemoveSingleAllSource(_id);
			  break;
			  
		      case PlaySystemStrLab.Package_Stone:	
			    StoneDataCenter.GetStoneDataControl().RemoveStone(_id);
			  break;
			  
			  
			}
			}
			
			
		}
		
		
		/*
		public function SellEqu(_type:String,_id:String):void 
		{
			 switch(_type) {
			  case PlaySystemStrLab.Package_Weapon:	
			  break;	
			  
			  case PlaySystemStrLab.Package_Shield:	
			  break;
			  
			  
			  case PlaySystemStrLab.Package_Accessories:	
			  break;
			  
			  
			  case PlaySystemStrLab.Package_Source:	
			  break;
			  
			  case PlaySystemStrLab.Package_Stone:	
			  break;
			  
			  
			}
		}*/
		
	}
	
}