package    
{
	import com.luislarghi.Game;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	
	public class Main extends Sprite
	{
		private var mainGame:Game;
		public static var mainStage:Stage;
		
		public function Main()
		{
			mainStage = this.stage;
			
			mainGame = new Game();
		}
	}
}