package 
{
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowRenderMode;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class BackgroundWindow extends NativeWindow 
	{
		private var bg:Background;
		
		public function BackgroundWindow(owner:NativeWindow) 
		{
			var options:NativeWindowInitOptions = new NativeWindowInitOptions();
			
			options.systemChrome = NativeWindowSystemChrome.STANDARD;
			options.type = NativeWindowType.NORMAL;
			options.renderMode = NativeWindowRenderMode.AUTO;
			options.owner = owner;
			options.maximizable = false;
			options.minimizable = false;
			options.resizable = false;
			options.transparent = false;
			
			super(options);
			
			this.title = Configuration.BACKGROUND_WINDOW_TITLE;
			this.alwaysInFront = false;
			this.x = Configuration.BACKGROUND_WINDOW_POS_X;
			this.y = Configuration.BACKGROUND_WINDOW_POS_Y;
			this.width = Configuration.BACKGROUND_WIDTH;
			this.height = Configuration.BACKGROUND_HEIGHT;
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			
			bg = new Background();
			this.stage.addChild(bg);
		}
		
		public function applyToHouseSlot(textureFile:String):void {
			bg.applyToHouseSlot(textureFile);
		}
	}

}