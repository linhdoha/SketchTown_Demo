package
{
	import com.greensock.TimelineLite;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class SnapShooter extends Sprite
	{
		private var data:ByteArray;
		private var imageBytes:ByteArray;
		private var saveImageWorker:Worker;
		private var wtm:MessageChannel;
		private var mtw:MessageChannel;
		private var timeline:TimelineLite;
		private var _target:DisplayObject;
		private var _imageFileType:String = "PNG";
		private var fileExtension:String;
		private var _imageFileQuality:int = 80;
		private var _prenameOfImage:String = "IMG_";
		private var _storageDir:String;
		private var bitmapData:BitmapData;
		private var _fileName:String;
		
		public function SnapShooter(target:DisplayObject, fileName:String=null, imageFileType:String = "PNG", imageFileQuality:int = 80, storageDir = "D:\\")
		{
			super();
			
			_target = target;
			_fileName = fileName;
			_imageFileType = imageFileType;
			_imageFileQuality = imageFileQuality;
			_storageDir = storageDir;
			
			initWorker();
		}
		
		private function initWorker():void
		{
			data = new ByteArray();
			data.shareable = true;
			
			imageBytes = new ByteArray();
			imageBytes.shareable = true;
			
			saveImageWorker = WorkerDomain.current.createWorker(Workers.SaveImageWorker, true);
			wtm = saveImageWorker.createMessageChannel(Worker.current);
			mtw = Worker.current.createMessageChannel(saveImageWorker);
			
			wtm.addEventListener(Event.CHANNEL_MESSAGE, onMessageFromWorker);
			
			saveImageWorker.setSharedProperty("wtm", wtm);
			saveImageWorker.setSharedProperty("mtw", mtw);
			saveImageWorker.setSharedProperty("sourceImage", imageBytes);
			saveImageWorker.setSharedProperty("data", data);
			saveImageWorker.start();
		}
		
		private function onMessageFromWorker(e:Event):void
		{
			var messageReceived:* = wtm.receive();
			if (messageReceived == "ENCODE_COMPLETED")
			{
				trace("ENCODE_COMPLETED");
			}
		}
		
		public function takeSnap():void
		{
			var w:Number = _target.getBounds(_target).width;
			var h:Number = _target.getBounds(_target).height;
			
			var targetCopy:BitmapData = new BitmapData(w, h, false);
			targetCopy.draw(_target);
			
			bitmapData = new BitmapData(w, h, false);
			bitmapData.copyPixels(targetCopy, new Rectangle(0, 0, w, h), new Point());
			
			imageBytes.length = 0;
			bitmapData.copyPixelsToByteArray(bitmapData.rect, imageBytes);
			
			if (_imageFileType == "PNG")
			{
				fileExtension = ".png";
			}
			else
			{
				fileExtension = ".jpg";
			}
			if (!_fileName) {
				_fileName = _prenameOfImage + String(new Date().time + fileExtension);
			} else {
				_fileName += fileExtension;
			}
			trace(_storageDir);
			var commandObj:Object = {command: "SAVE_IMAGE", width: bitmapData.rect.width, height: bitmapData.rect.height, encode: _imageFileType, quality: _imageFileQuality, filename: _fileName, dir: _storageDir}
			
			mtw.send(commandObj);
		}
	}

}