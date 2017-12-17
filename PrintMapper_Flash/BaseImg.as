package 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class BaseImg extends Sprite 
	{
		private var _isCompleted:Boolean;
		
		public function BaseImg() 
		{
			super();
			
			
		}
		
		public function loadImage(imageURL:String) {
			isCompleted = false;
			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded); // event listener which is fired when loading is complete
			imageLoader.load(new URLRequest(imageURL));
		}

		private function imageLoaded(e:Event) {
			e.target.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imageLoaded);
			this.addChild(e.target.loader.content); // loaded content is stored in e.target.loader.content variable
			isCompleted = true;
			dispatchEvent(e);
		}
		
		public function get isCompleted():Boolean 
		{
			return _isCompleted;
		}
		
		public function set isCompleted(value:Boolean):void 
		{
			_isCompleted = value;
		}
	}

}