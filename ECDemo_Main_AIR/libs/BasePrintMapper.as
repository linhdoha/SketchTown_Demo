package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class BasePrintMapper extends Sprite 
	{
		private var imgList:Vector.<BaseImg>;
		public function BasePrintMapper() 
		{
			super();
			
			
		}
		
		public function applyTexture(filePath:String):void {
			imgList = new Vector.<BaseImg>;
			findImgInside(this);
			
			for each(var img:BaseImg in imgList) {
				img.loadImage(filePath);
				img.addEventListener(Event.COMPLETE, onCompleted);
			}
		}
		
		private function onCompleted(e:Event):void 
		{
			BaseImg(e.currentTarget).removeEventListener(Event.COMPLETE, onCompleted);
			
			var isAllCompleted:Boolean = true;
			for each(var img:BaseImg in imgList) {
				isAllCompleted = isAllCompleted && img.isCompleted;
			}
			if (isAllCompleted) dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function findImgInside(node:DisplayObjectContainer):void {
			
			for (var i:int = 0; i < node.numChildren; i++) {
				var child:DisplayObject = node.getChildAt(i);
				if (child is BaseImg) {
					imgList.push(child);
				}
				if (child is DisplayObjectContainer) {
					var doc:DisplayObjectContainer = child as DisplayObjectContainer;
					findImgInside(doc);
				}
			}
		}
		
		public function snapshot(w:Number,h:Number):Sprite {
			var bitmapData:BitmapData = new BitmapData(w, h);
			bitmapData.draw(this);
			
			var snapshotRs:Sprite = new Sprite();
			var bitmap:Bitmap = new Bitmap(bitmapData);
			snapshotRs.addChild(bitmap);
			
			addChild(snapshotRs);
			return snapshotRs;
		}
	}

}