package 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class Background extends Sprite 
	{
		private var bgAsset:Background_asset;
		
		public function Background() 
		{
			super();
			bgAsset = new Background_asset();
			addChild(bgAsset);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			
			
			this.mouseChildren = false;
			this.doubleClickEnabled = true;
			this.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);
		}
		
		private function onDoubleClick(e:MouseEvent):void 
		{
			toggleFullscreen();
		}
		
		
		private function toggleFullscreen():void {
			if (stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE) {
				stage.displayState = StageDisplayState.NORMAL;
			} else {
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}
		}
		
		public function applyToHouseSlot(textureFile:String):void {
			bgAsset.houseSlot.applyTexture(textureFile);
		}
	}

}