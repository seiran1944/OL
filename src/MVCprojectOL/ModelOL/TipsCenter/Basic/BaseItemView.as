package MVCprojectOL.ModelOL.TipsCenter.Basic
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import Spark.MVCs.Models.SourceTools.Loader.LoadingBar;
	
	/**
	 * ...
	 * @author EricHuang
	 * 12/26---showComplete_BASIC-----
	 */
	public class BaseItemView extends Sprite 
	{
		
		//------targetGUID----
		public var _guid:String = "";
		
		public var _showName:String = "";
		public var _groupName:String = "";
		
		protected var _bg:MovieClip;
		protected var _item:ItemConter;
		public function BaseItemView(_source:MovieClip,_guid:String,_group:String) 
		{
			this._bg = _source;
			this._guid = _guid;
			this._groupName = _group;
			this.addChild(_bg);
		}
		
		public function AddItemSource(_spr:ItemConter):void 
		{
			this._item = _spr;
			this.addChild(this._item);
			this._item.StarLoading();
			this.setChildIndex( this._item , this.numChildren - 1 );
		}
		//---override this-----
	    public function CleanALL():void { };
		
		protected function CleaN():void 
		{
			if (this._item != null) this._item.Clean();
			while (this.numChildren>0) {
				this.removeChildAt(0);
			}
		}
		
		public function OpenClose(_flag:Boolean):void 
		{
			
		}
		
	}
	
}