package MVCprojectOL.ModelOL.TipsCenter.Basic
{
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import MVCprojectOL.ModelOL.ItemDisplayModel.ItemDisplay;
	import MVCprojectOL.ModelOL.LoadingCache.DisplayCache;
	import Spark.MVCs.Models.SourceTools.SourceProxy;
	
	/**
	 * ...
	 * @author EricHuang
	 * (用於更輕量的ITEM縮圖)
	 */
	public final class  ItemConter extends Sprite
	{
		private var _itemKey:String = "";
		private var _itemWidth:int = 0;
		private var _itemHeight:int = 0;
		//private var _disPlayCatch:DisplayCache;
		private var _disPlayCatch:ItemDisplay;
		//private var _sourceTools:SourceProxy;
		//private var _checkSource:Boolean = false;
		public function ItemConter(_key:String,_width:int,_height:int) 
		{
			this._itemKey = _key;
			this.name = _key;
			this._itemWidth = _width;
			this._itemHeight = _height;
			var _shape:Shape = new Shape();
			//this._sourceTools= SourceProxy.GetInstance();
			_shape.graphics.beginFill(0x000000);
			_shape.name = "bgItem";
			this.addChild(_shape);
		}
		
		
		public function StarLoading():void 
		{
			if (this._disPlayCatch == null) {
				//this._disPlayCatch = new ItemDisplay(this._itemKey, this, this.SourceBackHandler, this._itemWidth);
			    this._disPlayCatch = new ItemDisplay({_picItem:this._itemKey,_guid:this._itemKey});
				//this._disPlayCatch.StartLoad();
				this.addChild(this._disPlayCatch.ItemIcon);
				this._disPlayCatch.ShowContent();
			}
		}
		
		/*
		private function SourceBackHandler(_key:String):void 
		{
			if (this._checkSource==false) {
				var _item:Bitmap = new Bitmap(BitmapData(this._sourceTools.GetImageBitmapData(_key)));
				_item.alpha = 0;
				this.addChild(_item);
				TweenLite.to( _item , 1 , { alpha:1 , ease:Quad.easeOut } );
				this._checkSource = true;
				this._disPlayCatch.Clear();
				this._disPlayCatch = null;
			}
		}
		*/
		
		public function Reset(_key:String):void 
		{
			this._disPlayCatch.Clear();
			this._disPlayCatch.UpdateItemValue( { _picItem:_key, _guid:_key } );
			this._disPlayCatch.ShowContent();
		}
		
		public function Clean():void 
		{
			while ( this.numChildren > 0 ) {
				this.removeChildAt( 0 );
			}
		}
		
	}
	
}