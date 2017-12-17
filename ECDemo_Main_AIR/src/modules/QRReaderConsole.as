package modules 
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.DataEvent;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import Debug;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class QRReaderConsole extends EventDispatcher 
	{
		public static const DONE:String = "done";
		private var nativeProcessStartupInfo:NativeProcessStartupInfo;
		private var process:NativeProcess;
		
		public function QRReaderConsole(target:flash.events.IEventDispatcher=null) 
		{
			super(target);
			if (NativeProcess.isSupported)
			{
				nativeProcessStartupInfo = new NativeProcessStartupInfo();
				var file:File = File.applicationDirectory.resolvePath("QRReaderConsole\\qrReader.exe");
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
			Debug.trace("QRReaderConsole: ERROR - " + process.standardError.readUTFBytes(process.standardError.bytesAvailable-2));
		}
		
		private function onStdOut(e:ProgressEvent):void
		{
			var result:String = process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable-2);
			Debug.trace("QRReaderConsole: STDOUT - " + result);
			dispatchEvent(new DataEvent(DONE, false, false, result));
		}
		
		private function onProcessExit(e:NativeProcessExitEvent):void
		{
			Debug.trace("QRReaderConsole process exited.");
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
		
		public function readQR(filePath:String):void
		{
			var processArgs:Vector.<String> = new Vector.<String>();
			processArgs.push(filePath);
			nativeProcessStartupInfo.arguments = processArgs;
			
			process.start(nativeProcessStartupInfo);
		}
	}

}