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
	public class ImageMagickConsole extends EventDispatcher 
	{
		public static const DONE:String = "done";
		public static const NORMALIZE_COMMAND:String = "normalize_command";
		public static const RESIZE_COMMAND:String = "resize_command";
		private var nativeProcessStartupInfo:NativeProcessStartupInfo;
		private var process:NativeProcess;
		private var _saveFile:String;
		private var _lastCommand:String;
		
		public function ImageMagickConsole(target:flash.events.IEventDispatcher=null) 
		{
			super(target);
			if (NativeProcess.isSupported)
			{
				nativeProcessStartupInfo = new NativeProcessStartupInfo();
				var file:File = File.applicationDirectory.resolvePath("ImageMagickConsole\\magick.exe");
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
			Debug.trace("ImageMagickConsole: ERROR - " + process.standardError.readUTFBytes(process.standardError.bytesAvailable-2));
		}
		
		private function onStdOut(e:ProgressEvent):void
		{
			var result:String = process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable-2);
			Debug.trace("ImageMagickConsole: STDOUT - " + result);
		}
		
		private function onProcessExit(e:NativeProcessExitEvent):void
		{
			Debug.trace("ImageMagickConsole process exited.");
			dispatchEvent(new DataEvent(DONE, false, false, _saveFile));
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
		
		public function get lastCommand():String 
		{
			return _lastCommand;
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
		
		public function normalize(sourceFile:String, saveFile:String):void
		{
			_saveFile = saveFile;
			
			Debug.trace("Start normalize");
			
			var processArgs:Vector.<String> = new Vector.<String>();
			processArgs.push(sourceFile);
			processArgs.push("-normalize");
			processArgs.push(saveFile);
			nativeProcessStartupInfo.arguments = processArgs;
			
			process.start(nativeProcessStartupInfo);
			
			_lastCommand = NORMALIZE_COMMAND;
		}
		
		public function resize(sourceFile:String, saveFile:String):void {
			_saveFile = saveFile;
			
			Debug.trace("Start resize to box 1500x1500");
			
			var processArgs:Vector.<String> = new Vector.<String>();
			processArgs.push(sourceFile);
			processArgs.push("-resize");
			processArgs.push("1500x1500");
			processArgs.push(saveFile);
			nativeProcessStartupInfo.arguments = processArgs;
			
			process.start(nativeProcessStartupInfo);
			
			_lastCommand = RESIZE_COMMAND;
		}
	}

}