package modules 
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import Debug;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class CropNTurnConsole extends EventDispatcher 
	{
		public static const DONE:String = "done";
		private var nativeProcessStartupInfo:NativeProcessStartupInfo;
		private var process:NativeProcess;
		private var _bytes:ByteArray = new ByteArray();
		private var _bitmapData:BitmapData;
		
		public function CropNTurnConsole(target:flash.events.IEventDispatcher=null) 
		{
			super(target);
			if (NativeProcess.isSupported)
			{
				nativeProcessStartupInfo = new NativeProcessStartupInfo();
				var file:File = File.applicationDirectory.resolvePath("CropNTurnConsole\\scanner.exe");
				nativeProcessStartupInfo.executable = file;
				
				process = new NativeProcess();
				process.addEventListener(NativeProcessExitEvent.EXIT, onProcessExit);
				process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onStdOut);
				process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onStdErrorData);
				process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
				process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
			}
			else
			{
				Debug.trace("NativeProcess not supported.");
			}
		}
		
		private function onIOError(event:IOErrorEvent):void
		{
			dispatchEvent(event);
			Debug.trace(event.toString());
		}
		
		private function onStdErrorData(e:ProgressEvent):void
		{
			dispatchEvent(e);
			Debug.trace("CropNTurnConsole: ERROR - " + process.standardError.readUTFBytes(process.standardError.bytesAvailable));
		}
		
		private function onStdOut(e:ProgressEvent):void
		{
			var resultFile:String = process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable);
			Debug.trace("CropNTurnConsole: STDOUT - " + resultFile);
			dispatchEvent(new DataEvent(DONE, false, false, resultFile));
			
			//process.standardOutput.readBytes(bytes, 0, process.standardOutput.bytesAvailable);
			//convertBytesToBitmapData(bytes);
		}
		
		private function onProcessExit(e:NativeProcessExitEvent):void
		{
			Debug.trace("CropNTurnConsole process exited.");
		}
		
		public function get running():Boolean
		{
			if (NativeProcess.isSupported)
			{
				return process.running;
			}
			else
			{
				Debug.trace("NativeProcess is not supported.");
				return false;
			}
		}
		
		public function exit():void
		{
			if (NativeProcess.isSupported)
			{
				process.exit(true);
			}
			else
			{
				Debug.trace("NativeProcess is not supported.");
			}
		}
		
		public function processImage(sourceFile:String,saveFile:String, w:int, h:int):void
		{
			var processArgs:Vector.<String> = new Vector.<String>();
			processArgs.push(sourceFile);
			processArgs.push(saveFile);
			processArgs.push(w);
			processArgs.push(h);
			nativeProcessStartupInfo.arguments = processArgs;
			
			process.start(nativeProcessStartupInfo);
		}
		
		private function convertBytesToBitmapData(bytes:ByteArray):void {
			var loader:Loader = new Loader();
			loader.loadBytes(bytes);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
		}
		
		private function loaderComplete(e:Event):void 
		{
			var loaderInfo:LoaderInfo = LoaderInfo(e.target);
			bitmapData = new BitmapData(loaderInfo.width, loaderInfo.height, false, 0xFFFFFF);
			bitmapData.draw(loaderInfo.loader);
			dispatchEvent(new Event(DONE));
		}
		
		public function get bitmapData():BitmapData 
		{
			return _bitmapData;
		}
		
		public function set bitmapData(value:BitmapData):void 
		{
			_bitmapData = value;
		}
		
		private function get bytes():ByteArray 
		{
			return _bytes;
		}
		
		private function set bytes(value:ByteArray):void 
		{
			_bytes = value;
		}
	}

}