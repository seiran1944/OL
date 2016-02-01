package MVCprojectOL.ViewOL.CrewView.EditBoard
{
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Andrew
		@SparkEngine beta1
		@version #12.05.21.17.25
		@documentation to use this Class....
	 */
	public class TeamHeadBox  
	{
		
		private var _currentOL:String="";
		private var _currentHead:Sprite;
		private var _targetBox:Sprite;
		private var _addMember:String = "";//初始化後新增的怪物
		private var _removeMember:String = "";//初始化後移除的怪物
		
		private var _preRemove:String = "";
		
		public function TeamHeadBox(targetBox:Sprite):void
		{
			this._targetBox = targetBox;
		}
		
		
		public function SetHeadIn(head:Sprite,guid:String,setInit:Boolean=false,handable:Boolean=false):void 
		{
			//非首次配置預設成員(編輯中狀態)
			//成員變動紀錄
			if (!setInit) {
				if (guid != this._removeMember) {
					this._addMember = guid;
				}else {
					this._addMember = "";
					this._removeMember = "";
				}
			}
			
			this._currentOL = guid;
			this._currentHead = head;
			this._targetBox.addChild(head);
			if(!handable) this._targetBox.buttonMode = true;
			//頭像校正
			head.width = 48;
			head.height = 48;
			head.x = 2;
			head.y = 8;
		}
		
		public function RemoveHead():void
		{
			//成員變動紀錄
			if (this._currentOL != "" && this._addMember=="") {//移除到初始設定的成員(期間的變化不需處理)
				this._removeMember = this._currentOL;
			}
			
			//避免新增之後就移除同一隻的狀況
			if (this._removeMember =="" && this._currentOL == this._addMember) {
				this._addMember = "";
				this._removeMember = "";
			}
			
			//20130523 預設成員交換後又移除的狀況 會同時有ADD & REMOVE 資料的避免
			if (this._removeMember != "" && (this._currentOL == this._addMember)) {
				this._addMember = "";
			}
			
			
			this._currentOL = "";
			if (_targetBox.contains(this._currentHead)) {
				this._targetBox.removeChild(this._currentHead);
			}
			this._targetBox.buttonMode = false;
			this._currentHead = null;
		}
		
		public function ResetValue():void 
		{
			this._addMember = "";
			this._currentOL = "";
			this._removeMember = "";
		}
		
		public function ShineTheTarget():void
		{
			this.effectComplete(false,0);
		}
		private function effectComplete(isNormal:Boolean,count:int):void
		{
			count++;
			var param:Object = { onComplete:this.effectComplete, onCompleteParams:[!isNormal ,count] };
			param.glowFilter = isNormal ? { color:0xFFFF22, alpha:1, blurX:0, blurY:0 } : { color:0xFFFF22, alpha:.5, blurX:10, blurY:10 } ;
			(count < 3) ? TweenMax.to(this._targetBox, .5, param) : this.headBoxDeshine();
		}
		private function headBoxDeshine():void
		{
			TweenMax.killTweensOf(this._targetBox);
			this._targetBox.filters = [];
		}
		
		public function get HasHead():Boolean
		{
			return this._currentHead == null ? false : true;
		}
		
		public function get CurrentOL():String
		{
			return this._currentOL;
		}
		
		public function get CurrentHead():Sprite
		{
			return this._currentHead;
		}
		
		//有變更才有值否則為空
		public function get AddMember():String 
		{
			return this._addMember;
		}
		//有變更才有值否則為空
		public function get RemoveMember():String 
		{
			return this._removeMember;
		}
		
		public function get TargetBox():Sprite 
		{
			return this._targetBox;
		}
		
		public function Destroy():void 
		{
			this.headBoxDeshine();//避免在閃爍時就關閉
			this._currentHead = null;
			this._targetBox = null;
		}
		
	}
	
}