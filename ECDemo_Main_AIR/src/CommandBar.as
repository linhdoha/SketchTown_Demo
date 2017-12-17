package 
{
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class CommandBar extends Sprite 
	{
		public function CommandBar() 
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		public function addCommand(commandName:String, label:String, keyCode:uint=0, visible:Boolean=true):void {
			var commandButtonTemp:CommandButton = new CommandButton(commandName,label);
			commandButtonTemp.addEventListener(MouseEvent.CLICK, onClick);
			addChild(commandButtonTemp);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			dispatchEvent(new CommandBarEvent(CommandBarEvent.COMMAND_TRIGGERED,false,false,CommandButton(e.currentTarget).commandName));
		}
		
		private function onAdded(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			stage.addEventListener(Event.RESIZE, onResize);
			//stage.addEventListener(KeyboardEvent.KEY_DOWN, onDown);
		}
		
		/*private function onDown(e:KeyboardEvent):void 
		{
			switch (e.keyCode) {
				case Keyboard.SPACE:
					startScan();
					break;
				case Keyboard.F11:
					toggleFullscreen();
					break;
				case Keyboard.P:
					PrinterManager.openPrinterSelectionBox();
					break;
			}
		}*/
		
		private function onResize(e:Event):void 
		{
			redraw();
		}
		
		private function redraw():void {
			for (var i:int = 0; i < this.numChildren; i++) {
				this.getChildAt(i).x = stage.stageWidth - 140 * (i+1);
			}
		}
	}

}