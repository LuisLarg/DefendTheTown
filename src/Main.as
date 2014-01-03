package    
{
	import com.luislarghi.Game;
	import com.luislarghi.R;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	public class Main extends Sprite
	{
		private var mainGame:Game;
		public static var mainStage:Stage;
		
		public function Main()
		{
			mainStage = this.stage;

			mainStage.scaleMode = StageScaleMode.NO_SCALE;
			mainStage.align = StageAlign.TOP_LEFT;
			
			R.LoadXML();
			
			mainGame = new Game();
		}
	}
}