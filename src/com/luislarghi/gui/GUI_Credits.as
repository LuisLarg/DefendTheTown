package com.luislarghi.gui
{
	import com.luislarghi.R;
	import com.luislarghi.gamestates.Credits;
	import com.luislarghi.managers.AssetsManager;
	import com.luislarghi.myfirtsengine.Engine_GUI;
	import com.luislarghi.myfirtsengine.Engine_Game;
	import com.luislarghi.myfirtsengine.Engine_States;
	
	import flash.display.Stage;
	
	public class GUI_Credits extends Engine_GUI
	{
		private var BT_Return:GUI_Button;
		
		public function GUI_Credits(g:Engine_Game) { super(Main.mainStage, g); }
		
		public override function Init():void
		{
			Credits.guiContainer.addChild(BT_Return);
		}
		
		public override function Clear():void
		{
			Credits.guiContainer.removeChild(BT_Return);
			
			BT_Return = null;
		}
		
		public override function Draw():void
		{
			BT_Return.Draw();
		}
		
		protected override function InstantiateAllTF():void
		{
			if(!BT_Return)
			{
				BT_Return = new GUI_Button("Return", 280, 97, mainGame, AssetsManager.BM_Button, Engine_States.STATE_MAINMENU);
				BT_Return.x = Engine_Game.orgGameRes.x / 2 - (BT_Return.Size().x / 2);
				BT_Return.y = Engine_Game.orgGameRes.y - BT_Return.Size().y * 2;
			}
		}
	}
}