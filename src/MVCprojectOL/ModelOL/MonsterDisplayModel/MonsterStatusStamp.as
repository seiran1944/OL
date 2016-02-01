import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.Sprite;
import com.greensock.TweenMax;
import flash.filters.ColorMatrixFilter;
import flash.utils.clearTimeout;
import flash.utils.Dictionary;
import flash.utils.setTimeout;
	/**
	 * ...
	 * @author K.J. Aris
	 * @version 13.02.05.14.00
	 */
import MVCprojectOL.ModelOL.MonsterDisplayModel.MonsterUtilities;
	 
	 
//private const MonsterUtilities._PublicComponentKey:String = "GUI00002_ANI";
//private const MonsterUtilities._StampClassName:String = "DemonState";

private var _DefaultStampCondition:Vector.<String>;//預設的條件指令集
private var _StampCondition:Vector.<String>;//實際的條件指令集
private var _ConditionPool:Dictionary;

//private var _CurrentStamp:String = "";//當前蓋章狀態


private function initStampSetting():void {
	this._DefaultStampCondition = MonsterUtilities._DefaultStampCondition;//預設的條件指令集  new < String > [ "Learn" , "Battle" , "Group" , "Exhaust" ];
	this._StampCondition = this._DefaultStampCondition;
	
	this._ConditionPool = new Dictionary();
	this._ConditionPool["Learn"] = this.Learn;
	this._ConditionPool["Battle"] = this.Battle;
	this._ConditionPool["Group"] = this.Group;
	this._ConditionPool["Exhaust"] = this.Exhaust;
	//this._ConditionPool["Default"] = this.RemoveStatusStamp;
}

private function clearStampSetting():void {
	this._DefaultStampCondition = null;
	this._StampCondition = null;
	this._ConditionPool = null;
}

//-----------------------------------------------------------------------------------------------------Public Methods
		public function resetStampSetting():void {
			this._ConditionPool == null ? this.initStampSetting() : null;//檢查是否初始化
			this._StampCondition = this._DefaultStampCondition;//刷成初始值
			
			this.JudgeStampStatus();//當有重新設定時 都將其更新
		}

		public function setStampSetting( _InputConditionSetting:Vector.<String> ):void {
			this._ConditionPool == null ? this.initStampSetting() : null;//檢查是否初始化
			this._StampCondition = _InputConditionSetting;//刷成設定值
			//this._StampCondition.push( "Default" );
			
			this.JudgeStampStatus();//當有重新設定時 都將其更新
		}

		public function inquiryStampSetting():void {//查詢當前Stamp條件設定狀態
			trace( this._MonsterID , "=======Stamp Condition Setting========" );
			trace( this._StampCondition );
		}
//-----------------------------------------------------------------------------------------END---------Public Methods



private function JudgeStampStatus():void {
	//( this._AddStamp == true ) ? this.OpenStampMode() : this.CloseStampMode();//檢查是否開啟郵票
	( this._AddStamp == true ) ? this.OpenStampMode() : this.RemoveStatusStamp();//檢查是否開啟郵票
}


//=========================================================================================Stamp Judge & Add
private function OpenStampMode():void {
	if ( this._InnerBody != null && this.MonsterData._useing != null && this.MonsterData._teamGroup != null && this.MonsterData._nowEng != null && this.MonsterData._maxEng != null ) {
		this._ConditionPool == null ? this.initStampSetting() : null;//檢查是否初始化
	
		var _Leagth:uint = this._StampCondition.length;
		var _CurrentCommand:Function;
		for (var i:int = 0; i < _Leagth; i++) {
			_CurrentCommand = this._ConditionPool[ this._StampCondition[ i ] ];
			if ( _CurrentCommand != null ) {
				_CurrentCommand();//當有相關的條件指令時便執行
				return;
			}
		}
		this.RemoveStatusStamp();//當沒有任何條件被執行時便執行預設
		this._CurrentStamp = "";
	}
	
}

/*private function OpenStampMode():void {
		//檢查Stamp狀態
		//----使用狀態-0.刪除, 1.閒置（在巢穴）, 2.溶解中, 3.學習中, 4.戰鬥中, 5.掛賣中
				//public var _useing:int = 0;
				//_teamGroup:String = ""
				//_nowfatigueValue
				//_maxfatigueValue
				
				
				
		//this._MonsterBody
		//trace( this.MonsterData._useing , "GGWQGWGWGGGW" );
		//trace( this._InnerBody != null  );
		//
		//GUI00002_ANI class name DemonState  1疲勞 2組隊 3學習 4戰鬥
		if ( this._InnerBody != null && this.MonsterData._useing != null && this.MonsterData._teamGroup != null && this.MonsterData._nowfatigueValue != null && this.MonsterData._maxfatigueValue != null ) {
			
			//var _Frame:uint = 0;
			switch( true ) {
				case ( this.MonsterData._useing == 3 ) ://學習中
				case ( this.MonsterData._useing == 4 ) ://戰鬥返回中
						this.AddStatusStamp( this.MonsterData._useing );
						//trace( this.MonsterData._useing , "學習中戰鬥返回中" );
					break;
					
				case ( this.MonsterData._teamGroup != "" ) ://組隊中
						this.AddStatusStamp( 2 );
						//trace( this.MonsterData._useing , "組隊中" );
					break;
					
				case ( this.MonsterData._nowfatigueValue >= this.MonsterData._maxfatigueValue ) ://疲勞上限
						this.AddStatusStamp( 1 );
						//trace( this.MonsterData._useing , "疲勞上限" );
					break;
					
				default :
						this.RemoveStatusStamp();
						//trace( this.MonsterData._useing , "賣假，什麼都沒有" );
					break;
			}//end switch
			
			
		}//end if
}//end function StatusCheckAndAdd*/

/*private function CloseStampMode():void {
	this.RemoveStatusStamp();		
}*/

//==================================================================================END====Stamp Judge & Add


//================================================================================Conditions
private function Learn():void {
	if ( this.MonsterData._useing == 3 ) {//Learn
		this.AddStatusStamp( 2 );
		this._CurrentStamp = this._DefaultStampCondition[ 0 ];
		return;
	}
	this.Default();
	//trace( this.MonsterData._useing , "學習中" );
}

private function Battle():void {
	if ( this.MonsterData._useing == 4 ) {//Battle
		this.AddStatusStamp( 3 );
		this._CurrentStamp = this._DefaultStampCondition[ 1 ];
		return;
	}
	this.Default();
	//trace( this.MonsterData._useing , "戰鬥返回中" );
}

private function Group():void {
	/*if ( this.MonsterData._teamGroup != "" ) {
		this.AddStatusStamp( 2 );
		this._CurrentStamp = this._DefaultStampCondition[ 2 ];
	}else {
		this.Default();
	}*/
	//trace( this.MonsterData._teamGroup , "組隊中" );
	if ( this.MonsterData._teamGroup != "" && this.MonsterData._TeamFlag != -1 ) {
		this.AddStatusStamp( 4 + this.MonsterData._TeamFlag );//從第4格開始為組隊FLAG
		this._CurrentStamp = this._DefaultStampCondition[ 2 ];
	}else {
		this.Default();
	}
}

private function Exhaust():void {
	if ( this.MonsterData._nowEng >= this.MonsterData._maxEng ) {
		this.AddStatusStamp( 1 );
		this._CurrentStamp = this._DefaultStampCondition[ 3 ];
	}else {
		this.Default();
	}
	//trace( this.MonsterData._useing , "疲勞上限" );
}

private function Default():void {
	this.RemoveStatusStamp();
	this._CurrentStamp = "";
}

//=======================================================================END======Conditions




//==================================================================================Actions
private function AddStatusStamp(  _InputFrame:uint ):void {
	//加入Stamp
	var _Target:Sprite = this._MonsterBody;
	this.RemoveStatusStamp();
	var _Stamp:MovieClip = new ( this._SourceProxy.GetMaterialSWP( MonsterUtilities._PublicComponentKey , MonsterUtilities._StampClassName ) as Class );
	//var _StampSource:MovieClip = this._MonsterClipDepot.Inquiry( this._SourceProxy.GetMaterialSWP( this.MonsterUtilities._PublicComponentKey , this.MonsterUtilities._StampClassName ) as Class , MovieClip );
	//var _GraphicSeries:Array = this._SourceProxy.GetMovieClipHandler( _StampSource , false , this.MonsterUtilities._StampClassName );
		
		_Stamp.name = MonsterUtilities._StampClassName;
		_Stamp.gotoAndStop( _InputFrame );
		//_Stamp.y = this._BodySize - _Stamp.height + 25;
		_Stamp.scaleX = 64 / _Stamp.width;
		_Stamp.scaleY = _Stamp.scaleX;
		_Stamp.x = this._BodySize - _Stamp.width;
	/*var _GraphicData:BitmapData = _GraphicSeries[ _InputFrame - 1 ];
	_Target.graphics.beginBitmapFill( _GraphicData );
	_Target.graphics.drawRect( 0 , 0 , _GraphicData.width , _GraphicData.height );
	_Target.graphics.endFill();*/
	//this._MonsterBody.addChild( _Stamp );
	_Target.addChild( _Stamp );
	_Target.setChildIndex( _Stamp , _Target.numChildren - 1 );
	//var _TempTimeout:uint = setTimeout( this.DelayAddStamp , 500 , _Stamp , _TempTimeout );
	
	//this._InnerBody != null ? this.MakeGray( this._InnerBody ) : null;//不需要灰階 130205
}

/*private function DelayAddStamp( _InputStamp:Sprite , _InputTimeoutID:uint):void {
	this._MonsterBody.addChild( _InputStamp );
	clearTimeout( _InputTimeoutID );
}*/

private function RemoveStatusStamp():void {
	//移除Stamp
	var _Stamp:DisplayObject = this._MonsterBody.getChildByName( MonsterUtilities._StampClassName );
	( _Stamp != null ) ? this._MonsterBody.removeChild( _Stamp ) : null;
	
	( this._InnerBody != null ) ? this.MakeNormal( this._InnerBody ) : null;
}




private function MakeGray( _InputTarget:DisplayObjectContainer ):void {
	//TweenMax.to( _InputTarget , 0.5 , { colorMatrixFilter: { matrix:[0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0] }} );
	_InputTarget.filters = null;
	var _ColorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter( [0.3086, 0.6094, 0.082, 0, 
																	0, 0.3086, 0.6094, 0.082, 
																	0, 0, 0.3086, 0.6094, 
																	0.082, 0, 0, 0, 
																	0, 0, 1, 0]
																);
	_InputTarget.filters = [ _ColorMatrixFilter ];
}

private function MakeNormal( _InputTarget:DisplayObjectContainer ):void {
	//TweenMax.to( _InputTarget , 0.5 , { colorMatrixFilter: { matrix:[0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0] }} );
	_InputTarget.filters = null;
}

//=====================================================================END==========Actions
