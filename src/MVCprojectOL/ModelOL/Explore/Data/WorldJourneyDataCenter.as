package MVCprojectOL.ModelOL.Explore.Data {
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import MVCprojectOL.ModelOL.DataCenter.PlayerDataCenter;
	import MVCprojectOL.ModelOL.Explore.Vo.ExploreReport;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterDisplay;
	import MVCprojectOL.ModelOL.SkillData.SkillDataCenter;
	import MVCprojectOL.ModelOL.Vo.Explore.ExploreArea;
	import MVCprojectOL.ModelOL.Vo.Explore.ExploreChapter;
	import MVCprojectOL.ModelOL.Vo.ItemDrop;
	import MVCprojectOL.ModelOL.Vo.PlayerMonster;
	//import MVCprojectOL.ModelOL.Vo.RouteNode;
	import MVCprojectOL.ModelOL.Vo.Skill;
	//import MVCprojectOL.ModelOL.Vo.Skill;
	//import MVCprojectOL.ModelOL.Vo.SkillEffect;
	
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	
	import MVCprojectOL.ModelOL.Explore.Display.ChapterDisplay;
	import MVCprojectOL.ModelOL.Explore.Data.ExploreDataCenter;
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.05.23.11.09
	 */
	
	 
	public final class WorldJourneyDataCenter {
		private static var _WorldJourneyDataCenter:WorldJourneyDataCenter;//singleton pattern
		public static const _BuildScheduleCode:String = "explore";//singleton pattern
		
		public var _ExploreDataCenter:ExploreDataCenter = ExploreDataCenter.GetInstance();
		
		public var _ExploreChapterList:Array;//ExploreChapter
		public var _ExploreChapterDisplayList:Array;//ChapterDisplay
		public var _ExploreChapterDisplayList_Hash:Dictionary;//ChapterDisplay 以_guid為索引
		
		public var _ExploreAreaIndex:Dictionary = new Dictionary();//以_guid為索引 查詢所有節點
		
		private var _currentSelectedExploreArea:ExploreArea;//當前所選擇的節點
		public var _currentSelectedDifficulty:uint = 1;
		
		public var _ExploreAreaToChapterReverseLookupList:Dictionary;
		
		
		public static function GetInstance():WorldJourneyDataCenter {//IfProxy
			//return WorldJourneyDataCenter._WorldJourneyDataCenter = ( WorldJourneyDataCenter._WorldJourneyDataCenter == null ) ? new WorldJourneyDataCenter() : WorldJourneyDataCenter._WorldJourneyDataCenter; //singleton pattern
			return WorldJourneyDataCenter._WorldJourneyDataCenter ||= new WorldJourneyDataCenter(); //singleton pattern
		}
		
		public function WorldJourneyDataCenter() {
			WorldJourneyDataCenter._WorldJourneyDataCenter = this;
			
			trace( "啟動王國資訊中心" );
		}
		
		public function Terminate():void {
			WorldJourneyDataCenter._WorldJourneyDataCenter = null;
			
			this._ExploreChapterList = null;
			this._ExploreChapterDisplayList = null;
			this._ExploreChapterDisplayList_Hash = null;
			this._currentSelectedExploreArea = null;
			
			this._ExploreDataCenter.Terminate();
			this._ExploreDataCenter = null;
		}
		
		//=========================================================================Majidan Datas
		public function DeserializeExploreChapterList( _InputChapterList:Array , _InputReadyNotifyAddress:Function = null ):Vector.<String> {
			/*this._ExploreChapterArray = _InputChapterList;
			var _Length:uint = this._ExploreChapterArray.length;
			var _CurrentTarget:ExploreChapter;
			for (var i:int = 0 ; i < _Length ; i++) {
				_CurrentTarget = this._ExploreChapterArray[ i ];
				this.CreateExploreArea( _CurrentTarget );
				trace( this._ExploreChapterArray[ i ]._name , this._ExploreChapterArray[ i ]._guid, "<<<<<========From :" , this );
			}*/
			this._ExploreAreaToChapterReverseLookupList ||= new Dictionary();
			
			var _KeyList:Vector.<String> = new Vector.<String>();
			this._ExploreChapterList = _InputChapterList;
			this._ExploreChapterDisplayList = this.ChapterDisplayFactory( this._ExploreChapterList , _InputReadyNotifyAddress );
			
			for (var k:int = 0; k < this._ExploreChapterList.length ; k++) {
				_KeyList.push( ExploreChapter( this._ExploreChapterList[ k ] )._picItem );
			}
			
			//this._ExploreAreaIndex ||= new Dictionary( true );
			
			
			//--------------------------------------------------dealing with ExploreArea Datas
			//building up index
			var _length:uint = this._ExploreChapterList.length;
			var _length2:uint;
			var _currentChapterTarget:ExploreChapter;
			var _currentAreaTarget:ExploreArea;
			var _ListTarget:Array;
			
			for ( var i:int = 0 ; i < _length ; i++ ) {
				_currentChapterTarget = this._ExploreChapterList[ i ];
				_ListTarget = _currentChapterTarget._areaList;
				_length2 = _ListTarget.length;
				for ( var j:int = 0 ; j < _length2 ; j++ ) {
					_currentAreaTarget = _ListTarget[ j ] as ExploreArea;
					//this._ExploreAreaIndex[ _currentAreaTarget._guid ] = _currentAreaTarget;
					//_currentAreaTarget.GetCoolDownStatus();//叫物件向排程中心確認自己的排程是否存在 130510
					this._ExploreDataCenter.CreateExploreArea( _currentAreaTarget );
					this._ExploreAreaToChapterReverseLookupList[ _currentAreaTarget._guid ] = _currentChapterTarget._guid;	//建立反查表 由AreaID 找 ChapterID 
				}
			}
			this._ExploreAreaIndex = this._ExploreDataCenter.ExploreAreaList;
			//-----------------------------------------END------dealing with ExploreArea Datas
			
			
			return _KeyList;
		}
		
		
		public function ChapterDisplayFactory( _InputExploreChapterList:Array , _InputReadyNotifyAddress:Function = null ):Array {
			this._ExploreChapterDisplayList_Hash ||= new Dictionary( true );
			
			
			var _DisplayList:Array = [ ];
			var _Length:uint = _InputExploreChapterList.length;
			var _CurrentTarget:ExploreChapter;
			var _CurrentDisplayTarget:ChapterDisplay;
			for (var i:int = 0 ; i < _Length ; i++) {
				_CurrentTarget = _InputExploreChapterList[ i ];
				_CurrentDisplayTarget = this._ExploreChapterDisplayList_Hash[ _CurrentTarget._guid ];
				
				_CurrentDisplayTarget != null ? 
					_CurrentDisplayTarget.UpdateItemValue( _CurrentTarget )
					:
					_CurrentDisplayTarget = new ChapterDisplay( _CurrentTarget , _InputReadyNotifyAddress );
					
				_CurrentDisplayTarget.ShowContent();
				this._ExploreChapterDisplayList_Hash[ _CurrentTarget._guid ] = _CurrentDisplayTarget;
				_DisplayList.push( _CurrentDisplayTarget );
				
				//trace( this._InputChapterDisplayList[ i ]._name , this._InputChapterDisplayList[ i ]._guid, "<<<<<========From :" , this );
			}
			return _DisplayList;
		}
		
		
		
		public function GetChapterDisplayByID( _InputGuid:String ):ChapterDisplay {
			return this._ExploreChapterDisplayList_Hash[ _InputGuid ];
		}
		
		
		public function LocateChapterID_ByAreaID( _InputAreaID:String ):String {
			return this._ExploreAreaToChapterReverseLookupList[ _InputAreaID ];
		}
		
		
		private function MakeClone( _InputSource:Object ):Object {
				var _Clone:ByteArray = new ByteArray();
					_Clone.writeObject( _InputSource );
					_Clone.position = 0;
				return ( _Clone.readObject() );
		}
		
		
		/*public function get currentSelectedExploreArea():ExploreArea {
			return this._currentSelectedExploreArea;
		}*/
		
		public function set currentSelectedExploreArea( value:ExploreArea ):void {
			this._currentSelectedExploreArea = value;
			this._currentSelectedDifficulty = this._currentSelectedExploreArea._defaultDifficulty;
			this._ExploreDataCenter._currentSelectedAreaKey = this._currentSelectedExploreArea._guid;
		}
		
		public function SetSelectedExploreArea( _InputSelectedAreaGuid:String , _InputSelectedStar:uint ):void {
			this._currentSelectedExploreArea = this._ExploreAreaIndex[ _InputSelectedAreaGuid ];
			this._currentSelectedExploreArea._defaultDifficulty = _InputSelectedStar;
			this._currentSelectedDifficulty = this._currentSelectedExploreArea._defaultDifficulty;
			this._ExploreDataCenter._currentSelectedAreaKey = this._currentSelectedExploreArea._guid;
			
		}
		
		
		
		
		/*private function MakeListClone( _InputList:Dictionary ):Array {
			var _CloneList:Array = [];
			for (var i:* in _InputList ) {
				_CloneList.push( this.MakeClone( Object( _InputList[ i ] ) ) );
			}
			return _CloneList;
		}*/
		
		
	}//end class
}//end package