package
{
	import Debug;
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowRenderMode;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.printing.PrintJob;
	import flash.printing.PaperSize;
	import flash.printing.PrintJobOrientation;
	import flash.printing.PrintJobOptions;
	import flash.ui.Keyboard;
	import modules.CallScanConsole;
	import modules.CropNTurnConsole;
	import modules.ImageMagickConsole;
	import modules.QRReaderConsole;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class Main extends Sprite
	{
		private var callScanConsole:modules.CallScanConsole;
		private var qRReaderConsole:modules.QRReaderConsole;
		private var currentTemplateID:uint;
		private var cropNTurnConsole:modules.CropNTurnConsole;
		private var fileScanned:String;
		
		private var _bypassScanner:Boolean = false;
		private var imageMagickConsole:modules.ImageMagickConsole;
		private var penguinPrintMapper:PenguinPrintMapper;
		private var printJob:PrintJob;
		private var printingClip:Sprite;
		private var currentFileName:String;
		private var giraffePrintMapper:GiraffePrintMapper;
		private var isRunning:Boolean = false;
		private var carPrintMapper:CarPrintMapper;
		private var backgroundWindow:NativeWindow;
		
		private var SELECT_PRINTER_COMMAND:String = "selectPrinter";
		private var TOGGLE_FULLSCREEN_COMMAND:String = "toggleFullscreen";
		private var SCAN_COMMAND:String = "scan";
		private var TOGGLE_BACKGROUND_COMMAND:String = "toggleBG";
		private var housePrintMapper:HousePrintMapper;
		
		public function Main()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			//stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			
			addChild(Debug.textField);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onDown);
			initCallScanConsole();
			initQRReader();
			initCropNTurnConsole();
			initImageMagickConsole();
			
			penguinPrintMapper = new PenguinPrintMapper();
			giraffePrintMapper = new GiraffePrintMapper();
			carPrintMapper = new CarPrintMapper();
			housePrintMapper = new HousePrintMapper();
			
			
			
			var commandBar:CommandBar = new CommandBar();
			commandBar.addCommand(SELECT_PRINTER_COMMAND,"P - Select printer");
			commandBar.addCommand(TOGGLE_FULLSCREEN_COMMAND,"F11 - Fullscreen on/off");
			commandBar.addCommand(SCAN_COMMAND,"Space - Scan");
			//commandBar.addCommand(TOGGLE_BACKGROUND_COMMAND, "G - Background on/off");
			commandBar.addEventListener(CommandBarEvent.COMMAND_TRIGGERED, onCommandClick);
			addChild(commandBar);
			
			PrinterManager.checkPrinter();
			addChild(PrinterManager.printerSelectionBox);
			
			
			addBackgroundWindow();
			stage.nativeWindow.activate();
		}
		
		private function onCommandClick(e:CommandBarEvent):void 
		{
			trace(e.command);
			
			switch(e.command) {
				case SELECT_PRINTER_COMMAND:
					PrinterManager.openPrinterSelectionBox();
					break;
					
				case TOGGLE_FULLSCREEN_COMMAND:
					toggleFullscreen();
					break;
					
				case SCAN_COMMAND:
					startScan();
					break;
			}
		}
		
		private function addBackgroundWindow():void {
			var bg:Background = new Background();
			
			var options:NativeWindowInitOptions = new NativeWindowInitOptions();
			
			options.systemChrome = NativeWindowSystemChrome.STANDARD;
			options.type = NativeWindowType.NORMAL;
			options.renderMode = NativeWindowRenderMode.AUTO;
			options.owner = this.stage.nativeWindow;
			options.maximizable = false;
			options.minimizable = false;
			options.resizable = false;
			options.transparent = false;
			
			
			backgroundWindow = new NativeWindow(options);
			backgroundWindow.title = Configuration.BACKGROUND_WINDOW_TITLE;
			backgroundWindow.alwaysInFront = false;
			backgroundWindow.x = Configuration.BACKGROUND_WINDOW_POS_X;
			backgroundWindow.y = Configuration.BACKGROUND_WINDOW_POS_Y;
			backgroundWindow.width = Configuration.BACKGROUND_WIDTH;
			backgroundWindow.height = Configuration.BACKGROUND_HEIGHT;
			backgroundWindow.stage.align = StageAlign.TOP_LEFT;
			backgroundWindow.stage.scaleMode = StageScaleMode.NO_SCALE;
			
			backgroundWindow.stage.addChild(bg);
			backgroundWindow.visible = true;
			//backgroundWindow.activate();
			
		}
		
		private function onDown(e:KeyboardEvent):void
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
				case Keyboard.W:
					PrinterManager.wipeSetting();
					break;
				case Keyboard.B:
					bypassScanner = !bypassScanner;
					break;
			}
		}
		
		private function startScan():void {
			callScanConsole.run(bypassScanner);
		}
		
		private function toggleFullscreen():void {
			if (stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE) {
				stage.displayState = StageDisplayState.NORMAL;
			} else {
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			}
		}
		
		private function initCallScanConsole():void
		{
			callScanConsole = new modules.CallScanConsole();
			callScanConsole.addEventListener(modules.CallScanConsole.DONE, onCallScanDone);
		}
		
		private function onCallScanDone(e:DataEvent):void
		{
			fileScanned = e.data;
			
			var file:File = new File(e.data);
			currentFileName = file.name.substr(0, file.name.length - file.type.length);
			
			
			Debug.trace("CurrentFileName: " + currentFileName);
			
			var saveFile:String = new File(Configuration.SCAN_STORAGE_DIR).resolvePath(currentFileName+".png").nativePath;
			imageMagickConsole.resize(e.data,saveFile);
		}
		
		private function initQRReader():void {
			qRReaderConsole = new modules.QRReaderConsole();
			qRReaderConsole.addEventListener(modules.QRReaderConsole.DONE, onQRReaderDone);
		}
		
		private function onQRReaderDone(e:DataEvent):void 
		{
			//Debug.trace("onQRReaderDone: " + e.data);
			
			var saveFile:String = new File(Configuration.TEMP_DIR).resolvePath(currentFileName+"_processed.png").nativePath;
			
			switch (e.data) {
				case "01":
					currentTemplateID = 1;
					cropNTurnConsole.processImage(fileScanned, saveFile, Configuration.IMAGE01_WIDTH, Configuration.IMAGE01_HEIGHT);
					break;
				case "02":
					currentTemplateID = 2;
					cropNTurnConsole.processImage(fileScanned, saveFile, Configuration.IMAGE02_WIDTH, Configuration.IMAGE02_HEIGHT);
					break;
				case "03":
					currentTemplateID = 3;
					cropNTurnConsole.processImage(fileScanned, saveFile, Configuration.IMAGE03_WIDTH, Configuration.IMAGE03_HEIGHT);
					break;
				case "04":
					currentTemplateID = 4;
					cropNTurnConsole.processImage(fileScanned, saveFile, Configuration.IMAGE04_WIDTH, Configuration.IMAGE04_HEIGHT);
					break;
			}
			
			
		}
		
		private function initCropNTurnConsole():void {
			cropNTurnConsole = new modules.CropNTurnConsole();
			cropNTurnConsole.addEventListener(modules.CropNTurnConsole.DONE, onCropNTurnDone);
		}
		
		private function onCropNTurnDone(e:DataEvent):void 
		{
			//Debug.trace("CROP SUCCESSS!!!"+ e.data);
			var saveFile:String = new File(Configuration.TEMP_DIR).resolvePath(currentFileName+"_normalized.png").nativePath;
			imageMagickConsole.normalize(e.data,saveFile);
		}
		
		private function initImageMagickConsole():void {
			imageMagickConsole = new modules.ImageMagickConsole();
			imageMagickConsole.addEventListener(modules.ImageMagickConsole.DONE, onNormalizeDone);
		}
		
		private function onNormalizeDone(e:DataEvent):void 
		{
			if (imageMagickConsole.lastCommand == ImageMagickConsole.NORMALIZE_COMMAND) {
				Debug.trace("Normalized: " + e.data);
				makePrintMapper(e.data);
			} else 
			
			if (imageMagickConsole.lastCommand == ImageMagickConsole.RESIZE_COMMAND) {
				Debug.trace("Resized: " + e.data);
				qRReaderConsole.readQR(e.data);
			}
			
		}
		
		private function makePrintMapper(filePath:String):void {
			switch (currentTemplateID) {
				case 1:
					penguinPrintMapper.applyTexture(filePath);
					penguinPrintMapper.addEventListener(Event.COMPLETE, onMappingCompleted);
					break;
				case 2:
					giraffePrintMapper.applyTexture(filePath);
					giraffePrintMapper.addEventListener(Event.COMPLETE, onMappingCompleted);
					break;
				case 3:
					carPrintMapper.applyTexture(filePath);
					carPrintMapper.addEventListener(Event.COMPLETE, onMappingCompleted);
					break;
				case 4:
					housePrintMapper.applyTexture(filePath);
					housePrintMapper.addEventListener(Event.COMPLETE, onMappingCompleted);
					break;
			}
			
		}
		
		private function onMappingCompleted(e:Event):void 
		{
			BasePrintMapper(e.currentTarget).removeEventListener(Event.COMPLETE, onMappingCompleted);
			Debug.trace("CALL PRINT!!!!");
			
			switch (currentTemplateID) {
				case 1:
					printingClip = penguinPrintMapper.snapshot(penguinPrintMapper.bg.width, penguinPrintMapper.bg.height);
					break;
				case 2:
					printingClip = giraffePrintMapper.snapshot(giraffePrintMapper.bg.width, giraffePrintMapper.bg.height);
					break;
				case 3:
					printingClip = carPrintMapper.snapshot(carPrintMapper.bg.width, carPrintMapper.bg.height);
					break;
				case 4:
					printingClip = housePrintMapper.snapshot(housePrintMapper.bg.width, housePrintMapper.bg.height);
					break;
			}
			
			
			//save file
			var snapShooter:SnapShooter = new SnapShooter(printingClip, currentFileName+"_print", "PNG", 100, Configuration.PRINT_STORAGE_DIR);
			snapShooter.takeSnap();
			Debug.trace("Print file: "+Configuration.PRINT_STORAGE_DIR+"\\"+currentFileName+"_print.png");
			print();
		}
		
		
		private function initPrintJob():void
		{
			if (printJob == null)
			{
				printJob = new PrintJob();
				
				
				
			}
			printJob.printer = PrinterManager.currentPrinter;
			printJob.selectPaperSize(PaperSize.A4);
			printJob.copies = 1;
			printJob.orientation = PrintJobOrientation.LANDSCAPE;
			printJob.jobName = currentFileName;
		}
		
		private function print():void
		{
			initPrintJob();
			
			var clip:Sprite = printingClip;
			if (clip)
			{
				if (printJob.start2(null, false))
				{
					
					//resize to fit with page width
					if (clip.width != printJob.pageWidth)
					{
						clip.width = printJob.pageWidth;
						clip.scaleY = clip.scaleX;
					}
					
					try
					{
						printJob.addPage(clip, null, new PrintJobOptions(true));
					}
					catch (e:Error)
					{
						//error
					}
					printJob.send();
				}
				else
				{
					trace("Print job terminated.");
					printJob.terminate();
				}
			}
		
		}
		
		public function get bypassScanner():Boolean 
		{
			return _bypassScanner;
		}
		
		public function set bypassScanner(value:Boolean):void 
		{
			_bypassScanner = value;
			Debug.trace("Bypass scanner: "+_bypassScanner);
		}
	}

}