package Spark.ErrorsInfo
{
	
	
	import flash.display.*;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;            //文字大小
	import flash.text.TextFormat;                   //文字格式
	import flash.text.TextFormatAlign;
	import flash.events.*;
	import flash.utils.*; 
	import flash.filters.*;
	
	import caurina.transitions.Tweener;
	import flash.utils.Timer;
	
	
	
	
	/**
	 * ...
	 * @Engine :SparkEngine beta 1
	 * @author :JerryKai
	 * @version :2012.07.11
	 * @Explain:MessageUI 訊息介面
	 * @playerVersion:11.0
	 */
	
	public class MessageUI {
		
		//Package Info for debug
		private const _PackageInf:String = " * From Package MessageBox.as ";
		private const _ActionMessage:String = "#ver 12.02.15.10.45 : ";
		
		private var _DisplayArea:Sprite;
		
		private var _StageWidth:Number;
		private var _StageHeight:Number;
		
		private var _TextFilter:DropShadowFilter;
		
		private var _Format:TextFormat = new TextFormat();
		
		//private var _MessageOnStageTimer:Timer;
		
		private const _MessageStayStillPeriod:int = 2000;//ms
		private const _MessageFadeInDuration:int = 1;//s
		private const _MessageFadeOutDuration:int = 3;//s
		
		private var _MessageRecordList:Vector.<TextField> = new Vector.<TextField>();
		
		private const _YHeight:Number = 50;
		
		private var _MessageBoxInitWidth:Number;//先記錄初始的對齊位置  避免MessageBox長高後  文字位置跑掉   
		private var _MessageBoxInitHeight:Number;
		
		public dynamic function MessageUI( _InputParentContainer:* , _InputStageWidth:Number , _InputStageHeight:Number , _InputWidth:Number = 1000 , _InputHeight:Number = 150 ) {
			// constructor code
			//_TextFilter = _InputTextFilter;
			
			with( _Format ){
         		border = true;
         		size = 20;
         		color ="0xFF0000";
				bold = true;//粗體
         		//font="黑體";
			}
			
			setupBlock( _InputParentContainer , _InputStageWidth , _InputStageHeight , _InputWidth , _InputHeight );
			
			//trace( "容器寬度: " + _InputStageWidth + "容器長度: " + _InputStageHeight );
		}//end function
		
		
		private dynamic function setupBlock( _InputParentContainer:* , _InputStageWidth:Number , _InputStageHeight:Number , _InputWidth:Number = 300 , _InputHeight:Number = 150 ):void{
				this._DisplayArea = new Sprite();
				this._DisplayArea.graphics.beginFill( 0x000000 , 0);
				this._DisplayArea.graphics.drawRect( 0 , 0 , _InputWidth , _InputHeight );
				this._DisplayArea.graphics.endFill();
			_InputParentContainer.addChild( _DisplayArea );
				this._DisplayArea.x = _InputStageWidth/2 - this._DisplayArea.width/2;
				this._DisplayArea.y = _YHeight;//_InputStageHeight/2 - this._DisplayArea.height/2;
				this._DisplayArea.name = "DisplayArea";
				this._DisplayArea.mouseEnabled = false;
				_MessageBoxInitWidth = this._DisplayArea.width;
				_MessageBoxInitHeight = this._DisplayArea.height;
		}//end function
		
		
		
		public dynamic function resizeAdjust(_InputWidth:Number , _InputHeight:Number):void {
			
			this._StageWidth = _InputWidth;
			this._StageHeight = _InputHeight;
			
			this._DisplayArea.x = _StageWidth/2 - this._DisplayArea.width/2;
			this._DisplayArea.y = _YHeight;//_StageHeight/2 - this._DisplayArea.height/2;
			
			//////trace(this._DisplayArea.width , this._DisplayArea.height);
			//this._DisplayArea.width = _MessageBoxInitWidth;//將Box大小設回原始大小
			//this._DisplayArea.height = _MessageBoxInitHeight;
		}//end function
		
		
		public dynamic function BumpMessage( _InputMessage:String ):void{
			//this.resizeAdjust( _InputStageWidth , _InputStageHeight );
			var _MessageText:TextField = new TextField();
				
			this._DisplayArea.addChild(_MessageText);
				with(_MessageText){
					autoSize = TextFieldAutoSize.CENTER;
         			//wordWrap = true;//自動換行
         			defaultTextFormat = _Format;//
					alpha = 0;
					htmlText = _InputMessage;//指定為新輸入字串
					//width = _TextField_Width;
					x = this._MessageBoxInitWidth/2 - width/2;
					y = this._MessageBoxInitHeight/2 - height/2;
					//filters = [_TextFilter];
					//name = "MessageText";
					name = String( y - height );
					//////trace(width , x , height);
					mouseEnabled = false;
				}
				//_MessageText.name = String(_MessageText.y);
				this._DisplayArea.setChildIndex( _MessageText , this._DisplayArea.numChildren-1 );
				
				Tweener.addTween( _MessageText, { alpha:1 , time:this._MessageFadeInDuration  , onComplete:MessageStayOnStage(_MessageText) }    );
				
				
				this._MessageRecordList.push( _MessageText );
				PriorityPos( this._MessageRecordList );
		}//end function
		
		
		private dynamic function MessageStayOnStage( _InputTarget:TextField ):void{
			//Tweener.removeTweens( _InputTarget );
			
			/*var _MessageOnStageTimer:Timer = new Timer( _MessageStayStillPeriod , 1 );
				_MessageOnStageTimer.addEventListener(TimerEvent.TIMER , function (EVT:TimerEvent){ 
												  			EVT.currentTarget.stop();
															EVT.currentTarget.removeEventListener( TimerEvent.TIMER , arguments.callee );
												  			MessageFadeOut( EVT , _InputTarget); 
															delete Timer( EVT.currentTarget );
												  }  );
				_MessageOnStageTimer.start();*/
				
			setTimeout( MessageFadeOut , _MessageStayStillPeriod , _InputTarget );
				
		}//end function
		
		private dynamic function MessageFadeOut( _InputTarget:TextField ):void{
			//Tweener.removeTweens( _InputTarget );
			Tweener.addTween( _InputTarget, { alpha:0  , time:this._MessageFadeOutDuration , onComplete:function ():void{
							 														Tweener.removeTweens( _InputTarget );
							 														_InputTarget = null;
																					_MessageRecordList.shift();
							 												}
							 }    );
		}//end function
		
		private dynamic function PriorityPos( _InputMessageRecordList:Vector.<TextField> ):void{
			if( _InputMessageRecordList.length > 1 ){
				var _TargetNextPosY:int = 0;
				//////trace( _MessageRecordList.length );
				for( var i:int = 0 ; i < _InputMessageRecordList.length - 1 ; i++ ){
					//_TargetNextPosY = _InputMessageRecordList[i].y - ( _InputMessageRecordList[i].height );
					//Tweener.removeTweens( _InputMessageRecordList[i] );
					_TargetNextPosY = Number( _InputMessageRecordList[i].name );
					_InputMessageRecordList[i].name = String( Number(_InputMessageRecordList[i].name) - ( _InputMessageRecordList[i].height ) );
					Tweener.addTween( _InputMessageRecordList[i] , {y:_TargetNextPosY , time:0.5 }  );
				}

			}//end if
			
		}//end function
		
		

	}//end class
	
}//end package
