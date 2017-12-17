package 
{
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.printing.PrintJob;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	 public class PrinterSelectionBox extends Sprite 
	{
		 static public const ON_SELECTED:String = "onSelected";
		private var box:DeviceSelectionBox_asset;
		
		public function PrinterSelectionBox() 
		{
			super();
			box = new DeviceSelectionBox_asset();
			addChild(box);
			
			box.label.text = "Select printer:";
			
			for (var i:int = 0; i < PrintJob.printers.length; i++ ) {
				var button:DeviceButton_asset = new DeviceButton_asset();
				button.label.text = PrintJob.printers[i];
				button.addEventListener(MouseEvent.CLICK, onClick);
				button.y = i * 30;
				box.list.addChild(button);
			}
			box.list.x = box.space.x + box.space.width / 2 - box.list.width / 2;
			box.list.y = box.space.y + box.space.height / 2 - box.list.height / 2;
		}
		
		private function onClick(e:MouseEvent):void 
		{
			this.hide();
			//
			dispatchEvent(new DataEvent(ON_SELECTED,false,false,DeviceButton_asset(e.currentTarget).label.text));
		}
		
		public function show():void {
			this.visible = true;
		}
		
		public function hide():void {
			this.visible = false;
		}
	}

}