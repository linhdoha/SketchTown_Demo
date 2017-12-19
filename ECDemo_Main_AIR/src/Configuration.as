package
{
	import flash.filesystem.File;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class Configuration
	{
		static public const BACKGROUND_WINDOW_TITLE:String = "EliteCity wallscreen";
		static public const BACKGROUND_WINDOW_POS_X:int = 500;
		static public const BACKGROUND_WINDOW_POS_Y:int = 200;
		static public const BACKGROUND_WIDTH:int = 1080;
		static public const BACKGROUND_HEIGHT:int = 720;
		
		static public const TEMP_DIR:String = File.applicationStorageDirectory.nativePath;
		
		static public const IMAGE02_WIDTH:int = 1500;
		static public const IMAGE02_HEIGHT:int = 2176;
		static public const IMAGE03_WIDTH:int = 1500;
		static public const IMAGE03_HEIGHT:int = 1500;
		static public const IMAGE04_WIDTH:int = 435;
		static public const IMAGE04_HEIGHT:int = 730;
		
		
		static private var scanStorageDir:String;
		static private var sampleFile:String;
		static private var printStorageDir:String;
		
		public function Configuration()
		{
		
		}
		
		public static function get SCAN_STORAGE_DIR():String
		{
			scanStorageDir = File.desktopDirectory.resolvePath("scanFiles").nativePath;
			if (!File.desktopDirectory.resolvePath("scanFiles").exists)
			{
				File.desktopDirectory.resolvePath("scanFiles").createDirectory();
			}
			return scanStorageDir;
		}
		
		public static function get SAMPLE_FILE():String
		{
			sampleFile = File.applicationDirectory.resolvePath("car_sample.png").nativePath;
			return sampleFile;
		}
		
		public static function get PRINT_STORAGE_DIR():String
		{
			printStorageDir = File.desktopDirectory.resolvePath("printFiles").nativePath;
			if (!File.desktopDirectory.resolvePath("printFiles").exists)
			{
				File.desktopDirectory.resolvePath("printFiles").createDirectory();
			}
			return printStorageDir;
		}
	
	}

}