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
	import MVCprojectOL.ModelOL.Vo.RouteNode;
	import MVCprojectOL.ModelOL.Vo.Skill;
	//import MVCprojectOL.ModelOL.Vo.Skill;
	//import MVCprojectOL.ModelOL.Vo.SkillEffect;
	
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	
	import MVCprojectOL.ModelOL.SkillDisplayModel.CombatSkillDisplay;
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.04.03.14.36
	 */
	public final class ExploreDataCenter {
		private static var _ExploreDataCenter:ExploreDataCenter;//singleton pattern
		
		
		private var _ExploreAreaList:Dictionary;
		private var _ExploreAreaArray:Array;//可能為有序清單
		
		private var _ExploreChapterArray:Array;//可能為有序清單
		
		public var _currentSelectedAreaKey:String;
		public var _currentSelectedTeamKey:String;
		
		private var _currentAvailableScenes:Dictionary;
		public var _currentUsingSceneKey:String;
		public var _currentNodeScene:BitmapData;
		
		public var _uiKey:String;
		
		//------------------己方怪物資料
		public var _currentSelectedTeamMember:Object = { };//以陣形KEY值為索引	 怪物_guid
		public var _currentSelectedTeamMemberPos:Object = { };//以怪物_guid為索引	陣形KEY值  //GUID反查清單
		
		public var _currentSelectedTeamMemberDisplays:Object = { };//以陣形KEY值為索引  MonsterDisplay
		public var _currentSelectedTeamMemberDisplayIDDictionary:Object = { };//以怪物_guid為索引	MonsterDisplay ( MonsterDisplay.MonsterData 可尋怪物資料)
		private var _currentSelectedTeamMemberPrimitiveData:Object = { };//以怪物_guid為索引	Object (怪物VO)
		
		public var _currentCasualtiesList:Object = { };//戰損清單
		//------------------敵方怪物資料
		public var _currentEnemyTeamMemberDisplays:Object;
		
		
		public var _currentRouteNode:RouteNode;
		
		public var _stepHistory:Array = [];//選擇的歷史記錄	//uint  0.沒事 , 1.惡魔 , 2.寶箱 , 3.安全 , 4.魔王
		
		//--------------------------------素材
		private var _SourceProxy:SourceProxy = SourceProxy.GetInstance();
		
		
		public var _GlobalClasses:Object;
		public var _MajidanClasses:Object;
		//------------------------END-----素材
		
		//--------------------------------掉落
		public var _currentDropList:ItemDrop;
		public var _ExploreReport:ItemDrop = new ItemDrop();
		public var _FinalExploreReport:ExploreReport;
		//-------------------------END----掉落
		
		//private const _BattleComponentPackKey:String = "GUI00010_ANI";//戰鬥素材包KEY碼
		public var _HealSkill:Skill = SkillDataCenter.GetInstance().GetSkill( PlayerDataCenter.HealKey );
		private var _SkillSplit:uint = 0;
		
		public var _success:Boolean = false;
		
		public static function GetInstance():ExploreDataCenter {//IfProxy
			return ExploreDataCenter._ExploreDataCenter = ( ExploreDataCenter._ExploreDataCenter == null ) ? new ExploreDataCenter() : ExploreDataCenter._ExploreDataCenter; //singleton pattern
		}
		
		public function ExploreDataCenter() {
			ExploreDataCenter._ExploreDataCenter = this;
			this._ExploreAreaList = new Dictionary();
			
			this._currentAvailableScenes = new Dictionary();
			
			this._ExploreReport._items = [ ];
			this._ExploreReport._monsters = [ ];
			this._ExploreReport._material = { };
			this._ExploreReport._prisoners = [ ];
			
			
		}
		
		public function Terminate():void {
			ExploreDataCenter._ExploreDataCenter = null;
			this._ExploreAreaList = null;
			this._ExploreAreaArray = null;
			this._currentAvailableScenes = null;
			this._currentNodeScene = null;
			this._currentSelectedTeamMember = null;
			this._currentSelectedTeamMemberDisplays = null;
			this._currentSelectedTeamMemberDisplayIDDictionary = null;
			this._currentSelectedTeamMemberPrimitiveData = null;
			
			this._currentEnemyTeamMemberDisplays = null;
			
			this._currentRouteNode = null;
			this._stepHistory = null;
			this._SourceProxy = null;
			this._GlobalClasses = null;
			this._MajidanClasses = null;
			this._HealSkill = null;
			
			this._ExploreReport = null;
			this._FinalExploreReport = null;
		}
		
		//=========================================================================Majidan Datas
		public function DeserializeExploreChapterList( _InputChapterList:Array ):void {
			/*this._ExploreChapterArray = _InputChapterList;
			var _Length:uint = this._ExploreChapterArray.length;
			var _CurrentTarget:ExploreChapter;
			for (var i:int = 0 ; i < _Length ; i++) {
				_CurrentTarget = this._ExploreChapterArray[ i ];
				this.CreateExploreArea( _CurrentTarget );
				trace( this._ExploreChapterArray[ i ]._name , this._ExploreChapterArray[ i ]._guid, "<<<<<========From :" , this );
			}*/
			this._ExploreChapterArray = _InputChapterList;
			
		}
		
		
		public function DeserializeExploreAreaList( _InputAreaList:Array ):void {
			this._ExploreAreaArray = _InputAreaList;
			var _Length:uint = this._ExploreAreaArray.length;
			var _CurrentTarget:ExploreArea;
			for (var i:int = 0 ; i < _Length ; i++) {
				_CurrentTarget = this._ExploreAreaArray[ i ];
				this.CreateExploreArea( _CurrentTarget );
				trace( this._ExploreAreaArray[ i ]._name , this._ExploreAreaArray[ i ]._guid, "<<<<<========From :" , this );
			}
			
		}
		
		
		
		public function CreateExploreArea( _InputExploreArea:ExploreArea ):void {
			//寫入魔神殿區域資料
			this._ExploreAreaList[ _InputExploreArea._guid ] = _InputExploreArea;
			
			trace( _InputExploreArea._guid , _InputExploreArea._exploreSceneKey , "<<<<========================魔神殿結點資料" );
			
		}
		
		public function GetExploreArea( _InputKey:String ):ExploreArea {	// Vo ExploreArea
			//讀取魔神殿區域資料
			this._uiKey = this._ExploreAreaList[ _InputKey ]._uiKey;
			return this._ExploreAreaList[ _InputKey ];
		}
		
		public function GetExploreAreaByIndex( _InputIndex:uint ):ExploreArea {	// Vo ExploreArea
			//以有序編號讀取魔神殿區域資料
			return _InputIndex < this._ExploreAreaArray.length ? this._ExploreAreaArray[ _InputIndex ] : null;
		}
		
		public function get ExploreAreaList():Dictionary {
			return this._ExploreAreaList;
		}
		
		public function get ExploreAreaArray():Array {
			return this._ExploreAreaArray;
		}
		
		public function GetExploreAreaSceneKeys( _InputAreaKey:String ):Array {//
			//讀取魔神殿區域資料
			return ExploreArea( this.GetExploreArea( _InputAreaKey ) )._exploreSceneKey as Array;
		}
		
		/*public function GetExploreAreaRandomSceneKey( _InputAreaKey:String = "" ):String {//改由SERVER RANDOM
			//讀取魔神殿區域資料
			_InputAreaKey = ( _InputAreaKey == "" ) ? this._currentSelectedAreaKey : _InputAreaKey;
			var _SceneList:Array = ExploreArea( this.GetExploreArea( _InputAreaKey ) )._exploreSceneKey as Array;
			var _RandomSeed:uint = Math.round(Math.random() * ( _SceneList.length - 1 ) );
			
			this._currentUsingSceneKey = _SceneList[ _RandomSeed ];//儲存目前亂數地圖KEY
			return this._currentUsingSceneKey;
		}*/
		//================================================================END======Majidan Datas
		
		
		
		
		//=========================================================================Journey Datas
		public function AddSceneMap( _InputKey:String ):void {
			this._currentAvailableScenes[ _InputKey ] = this._SourceProxy.GetImageBitmapData( _InputKey ) as BitmapData;
		}
		
		public function GetSceneMap( _InputKey:String ):BitmapData {
			return this._currentAvailableScenes[ _InputKey ];
		}
		
		public function UpdateCurrentRouteNode( _InputRouteNode:RouteNode ):void {//更新當前節點
			_InputRouteNode.Track();
			this._currentRouteNode = _InputRouteNode;
			this._currentUsingSceneKey = _InputRouteNode._picKey;
			this._currentNodeScene = this._SourceProxy.GetImageBitmapData( this._currentUsingSceneKey );
			//( this._currentRouteNode != null && this._currentRouteNode._type != 0 ) ? this._stepHistory.push( this._currentRouteNode._type ) : null;//更新歷史資訊   // 在點選時就做歷史記錄 移至ExploreAdventure 130225
		
			//-------------------掉落
			/*if ( _InputRouteNode._itemDrop != null ) {
				this._currentDropList = _InputRouteNode._itemDrop;
				this.AddToExploreReport( _InputRouteNode._itemDrop );
			}*/

			
		}
		//================================================================END======Journey Datas
		
		
		//=========================================================================Monster Datas
		public function UpdateMonstersValues( _InputValuePack:Object ):void {
			var _currentValuePack:Object;
			var _currentTarget:MonsterDisplay;
			for ( var i:* in _InputValuePack ) {
				_currentTarget = this._currentSelectedTeamMemberDisplayIDDictionary[ i ];
				if ( _currentTarget != null ) {
					_currentValuePack = _InputValuePack[ i ];
					_currentTarget.MonsterData._nowHp = _currentValuePack._hp;
					//_currentTarget.MonsterData._nowExp = _currentValuePack._exp;
					//_currentTarget.MonsterData._lv = _currentValuePack._lv;
				}
			}
		}
		
		public function SetMonsterPrimitiveValue( _InputGuid:String , _InputMonsterVO:Object ):void {//記錄惡魔原始數值資料
			var _currentTarget:MonsterDisplay = this._currentSelectedTeamMemberDisplayIDDictionary[ _InputGuid ]; 
			if ( _currentTarget != null ) {
				this._currentSelectedTeamMemberPrimitiveData[ _InputGuid ] = this.MakeClone( _currentTarget.MonsterData );
			}
		}
		//=================================================================END=====Monster Datas
		
		
		//=========================================================================Explore Report
		public function AddToExploreReport( _InputItemDrop:ItemDrop ):void {	//取得探索報表
			this._currentDropList = _InputItemDrop;
			//this._ExploreReport._teamMonsterDisplays = this._currentSelectedTeamMemberDisplayIDDictionary;
				_InputItemDrop._monsters != null ? this._ExploreReport._monsters.concat( _InputItemDrop._monsters ) : null;
				//_InputItemDrop._material != null ? this._ExploreReport._material.concat( _InputItemDrop._material ) : null;
				_InputItemDrop._material != null ? this.MaterialCounter( _InputItemDrop._material ) : null;//PlayerSource
				_InputItemDrop._items != null ? this._ExploreReport._items.concat( _InputItemDrop._items ) : null;
				_InputItemDrop._prisoners != null ? this._ExploreReport._prisoners.concat( _InputItemDrop._prisoners ) : null;
		}
		
		private function MaterialCounter( _InputMaterialList:Object ):void {	//掉落的材料 以GUID為索引  以量計
			//PlayerSource
			for (var i:* in _InputMaterialList ) {
				this._ExploreReport._material[ i ] != null ? this._ExploreReport._material[ i ]._number += _InputMaterialList[ i ]._number : this._ExploreReport._material[ i ] = _InputMaterialList[ i ];//PlayerSource
			}
			
		}
		
		public function GetFinalReport( ):ExploreReport {
			var _InputItemDrop:ItemDrop = this._ExploreReport;
			this._FinalExploreReport = this._FinalExploreReport == null ? new ExploreReport() : this._FinalExploreReport;
			this._FinalExploreReport._exploreArea = this.GetExploreArea( this._currentSelectedAreaKey );
			this._FinalExploreReport._success = this._success;//探索成功或失敗
			this._FinalExploreReport._teamMonsterDisplays = this._currentSelectedTeamMemberDisplayIDDictionary;	//對伍怪物資料	MonsterDisplay
			
			this.JudgeAllyHealthStatus( this._FinalExploreReport._teamMonsterDisplays );//辨識血量顏色顯示
			
			this._FinalExploreReport._acquiredMonsterDisplays = this.MonsterDisplayFactory( _InputItemDrop._monsters );	//獲得的怪物資料	MonsterDisplay
			this._FinalExploreReport._acquiredMaterialDisplays = this.ItemDisplayFactory( _InputItemDrop._material );	//獲得的素材資料	ItemDisplay
			this._FinalExploreReport._acquiredItemsDisplays = this.ItemDisplayFactory( _InputItemDrop._items );	//獲得的道具資料	ItemDisplay
			this._FinalExploreReport._acquiredPrisonersDisplays = this.MonsterDisplayFactory( _InputItemDrop._prisoners );	//取得的俘虜怪物資料 MonsterDisplay
			
			return this._FinalExploreReport;
			
			//UserSourceCenter.GetUserSourceCenter().AddSource(_ary:Array)
		}
		
		public function GetDropReport( ):Array {//ItemDisplay
			var _InputItemDrop:ItemDrop = this._currentDropList;
			//var _DropReport:ExploreReport = new ExploreReport();
			var _DropDisplayList:Array;
			
			//this._FinalExploreReport._acquiredMonsterDisplays = this.MonsterDisplayFactory( _InputItemDrop._monsters );	//獲得的怪物資料	MonsterDisplay
				_DropDisplayList = this.ItemDisplayFactory( _InputItemDrop._material );	//獲得的素材資料	ItemDisplay
				_DropDisplayList.concat( this.ItemDisplayFactory( _InputItemDrop._items ) );	//獲得的道具資料	ItemDisplay
			//this._FinalExploreReport._acquiredPrisonersDisplays = this.MonsterDisplayFactory( _InputItemDrop._prisoners );	//取得的俘虜怪物資料 MonsterDisplay
			return _DropDisplayList;
		}
		
		private function MonsterDisplayFactory( _InputVoData:Array ):Array {
			var _DisplayList:Array = [ ];
			if ( _InputVoData != null ) {
				var _CurrentTarget:MonsterDisplay;
				var _length:uint = _InputVoData.length;
				for ( var i:int = 0; i < _length ; i++ ) {
					_CurrentTarget = new MonsterDisplay( _InputVoData[ i ] );
					//_CurrentTarget.ShowContent();
					_DisplayList.push( _CurrentTarget );
				}
			}
			
			
			return _DisplayList;
		}
		
		private function ItemDisplayFactory( _InputVoData:* ):Array {
			var _DisplayList:Array = [ ];
			if ( _InputVoData != null ) {
				var _CurrentTarget:ItemDisplay;
				if ( _InputVoData is Array ) {
					var _length:uint = _InputVoData.length;
					for ( var i:int = 0; i < _length ; i++ ) {
						_CurrentTarget = new ItemDisplay( _InputVoData[ i ] );
						//_CurrentTarget.ShowContent();
						_DisplayList.push( _CurrentTarget );
					}
				}
				
				if ( _InputVoData is Object ) {
					for ( var j:* in _InputVoData ) {
						_CurrentTarget = new ItemDisplay( _InputVoData[ j ] );
						//_CurrentTarget.ShowContent();
						_DisplayList.push( _CurrentTarget );
					}
				}
				
			}
			
			
			return _DisplayList;
		}
		
		private function JudgeAllyHealthStatus( _InputAllyMonsterDisplayList:Object ):void {
			var _currentTarget:MonsterDisplay;
			var _currentTargetPrimitiveData:Object;
			/*
			 * _guid
			 * _hp
			*/
			
			//血量顏色--0:紅 1:綠 2:白
			
			var _HpColorKey:uint;
			for (var i:* in _InputAllyMonsterDisplayList ) {
				_currentTarget = _InputAllyMonsterDisplayList[ i ];
				_currentTargetPrimitiveData = this._currentSelectedTeamMemberPrimitiveData[ i ];
				switch ( true ) {
					case _currentTarget.MonsterData._nowHp > _currentTargetPrimitiveData._nowHp ://血量大於初始值顯示綠色
							_HpColorKey = 1;
						break;
						
					case _currentTarget.MonsterData._nowHp < _currentTargetPrimitiveData._nowHp ://血量小於初始值顯示紅色
							_HpColorKey = 0;
						break;
						
					default:////血量等於初始值顯示白色
							_HpColorKey = 2;
						break;
				}
				
				
				_currentTarget.MonsterData._HpColorKey = _HpColorKey;//新增 動態屬性  血量顏色 
			}
			
			
			
			
		}
		
		
		//================================================================END======Explore Report
		
		
		
		
		
		
		
		//==========================================================================Heal Effect
		public function GetHealEffect():CombatSkillDisplay {
			this._SkillSplit++;
			var _CombatSkillDisplay:CombatSkillDisplay = new CombatSkillDisplay( this._HealSkill , this._SkillSplit += Math.random() ) ;
				_CombatSkillDisplay.ShowContent();
			return _CombatSkillDisplay;
		}
		//================================================================END======Heal Effect
		
		private function MakeClone( _InputSource:Object ):Object {
				var _Clone:ByteArray = new ByteArray();
					_Clone.writeObject( _InputSource );
					_Clone.position = 0;
				return ( _Clone.readObject() );
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