package 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.printing.PrintJob;
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class PrinterManager 
	{
		static private var _currentPrinter:String;
		static private var _printerSelectionBox:PrinterSelectionBox;
		static private var _so:SharedObject;
		
		public function PrinterManager() 
		{
			
			
		}
		
		static public function get currentPrinter():String 
		{
			return _currentPrinter;
		}
		
		static public function set currentPrinter(value:String):void 
		{
			_currentPrinter = value;
			Debug.trace("Current printer is: "+_currentPrinter);
		}
		
		static public function get printerSelectionBox():PrinterSelectionBox 
		{
			if (!_printerSelectionBox) {
				_printerSelectionBox = new PrinterSelectionBox();
				_printerSelectionBox.addEventListener(PrinterSelectionBox.ON_SELECTED, onSelected);
				_printerSelectionBox.addEventListener(Event.ADDED_TO_STAGE, onBoxAdded);
				_printerSelectionBox.visible = false;
			}
			return _printerSelectionBox;
		}
		
		static private function onBoxAdded(e:Event):void 
		{
			printerSelectionBox.removeEventListener(Event.ADDED_TO_STAGE, onBoxAdded);
			printerSelectionBox.stage.addEventListener(Event.RESIZE, onStageResize);
			printerSelectionBox.x = printerSelectionBox.stage.stageWidth / 2 - printerSelectionBox.width / 2;
			printerSelectionBox.y = printerSelectionBox.stage.stageHeight / 2 - printerSelectionBox.height / 2;
		}
		
		static private function onStageResize(e:Event):void 
		{
			printerSelectionBox.x = printerSelectionBox.stage.stageWidth / 2 - printerSelectionBox.width / 2;
			printerSelectionBox.y = printerSelectionBox.stage.stageHeight / 2 - printerSelectionBox.height / 2;
		}
		
		static public function get so():SharedObject 
		{
			if (!_so) {
				_so = SharedObject.getLocal("Paper_Toy_Maker");
			}
			return _so;
		}
		
		static public function set so(value:SharedObject):void 
		{
			_so = value;
		}
		
		static private function onSelected(e:DataEvent):void 
		{
			currentPrinter = e.data;
			so.data.printerId = e.data;
			so.flush();
		}
		
		static public function checkPrinter():void {
			var isFound:Boolean = false;
			for each (var printer:String in PrintJob.printers) {
				if (so.data.printerId == printer) {
					isFound = true;
				}
			}
			
			
			if (so.data.printerId != null && so.data.printerId != "" && isFound && PrintJob.printers.length >0) {
				currentPrinter = so.data.printerId;
				//Debug.trace("PrinterManager: Found prev settings '"+so.data.printerId+"'.");
			} else {
				//Debug.trace("PrinterManager: No setting, no printer.");
				printerSelectionBox.show();
			}
		}
		
		static public function reselectPrinter():void {
			
		}
		
		static public function openPrinterSelectionBox():void {
			printerSelectionBox.show();
		}
		
		static public function wipeSetting():void {
			Debug.trace("Wipe printer settings.");
			so.clear();
		}
		
		
	}

}