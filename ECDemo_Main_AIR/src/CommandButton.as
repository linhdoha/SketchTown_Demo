package 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class CommandButton extends Sprite 
	{
		private var asset:CommandButton_asset;
		private var _commandName:String;
		private var _keyCode:uint;
		
		public function CommandButton(commandName:String, label:String="", keyCode:uint=0,visible=true) 
		{
			super();
			asset = new CommandButton_asset();
			addChild(asset);
			
			this.commandName = commandName;
			this.label = label;
			this.keyCode = keyCode;
		}
		
		public function set label(s:String):void {
			asset.label.text = s;
		}
		
		public function get commandName():String 
		{
			return _commandName;
		}
		
		public function set commandName(value:String):void 
		{
			_commandName = value;
		}
		
		public function get keyCode():uint 
		{
			return _keyCode;
		}
		
		public function set keyCode(value:uint):void 
		{
			_keyCode = value;
		}
	}

}