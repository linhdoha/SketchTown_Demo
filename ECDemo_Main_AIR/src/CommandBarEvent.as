package 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Linhdoha
	 */
	public class CommandBarEvent extends Event 
	{
		public static const COMMAND_TRIGGERED:String = "commandTriggered";
		
		private var _command:String;
		public function CommandBarEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false,command:String="") 
		{ 
			super(type, bubbles, cancelable);
			_command = command;
		} 
		
		public override function clone():Event 
		{ 
			return new CommandBarEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("CommandBarEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
		public function get command():String 
		{
			return _command;
		}
		
	}
	
}