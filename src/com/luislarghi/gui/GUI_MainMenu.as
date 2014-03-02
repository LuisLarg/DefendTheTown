package com.luislarghi.gui
{
	import com.luislarghi.Game;
	import com.luislarghi.R;
	import com.luislarghi.gamestates.MainMenu;
	import com.luislarghi.managers.AssetsManager;
	import com.luislarghi.myfirtsengine.Engine_GUI;
	import com.luislarghi.myfirtsengine.Engine_Game;
	import com.luislarghi.myfirtsengine.Engine_GameState;
	import com.luislarghi.myfirtsengine.Engine_States;
	
	import flash.display.Stage;
	
	public class GUI_MainMenu extends Engine_GUI
	{
		private var BT_Play:GUI_Button;
		private var BT_Credits:GUI_Button;
		private var BT_Exit:GUI_Button;
		
		public function GUI_MainMenu(g:Engine_Game) { super(Main.mainStage, g); }
		
		public override function Init():void
		{
			MainMenu.guiContainer.addChild(BT_Play);
			MainMenu.guiContainer.addChild(BT_Credits);
			MainMenu.guiContainer.addChild(BT_Exit);
		}
		
		public override function Clear():void
		{
			MainMenu.guiContainer.removeChild(BT_Play);
			MainMenu.guiContainer.removeChild(BT_Credits);
			MainMenu.guiContainer.removeChild(BT_Exit);
			
			BT_Play = null;
			BT_Credits = null;
			BT_Exit = null;
		}
		
		public override function Draw():void 
		{ 
			BT_Play.Draw();
			BT_Credits.Draw();
			BT_Exit.Draw();
		}
		
		protected override function InstantiateAllTF():void
		{
			if(!BT_Play)
			{
				BT_Play = new GUI_Button("Play", 280, 97, mainGame, AssetsManager.BM_Button, Engine_States.STATE_INGAME);
				BT_Play.x = Engine_Game.orgGameRes.x - BT_Play.Size().x - 100;
				BT_Play.y = (Engine_Game.orgGameRes.y / 2) + 30;
			}
			
			if(!BT_Credits)
			{
				BT_Credits = new GUI_Button("Credits", 280, 97, mainGame, AssetsManager.BM_Button, Engine_States.STATE_CREDITS);
				BT_Credits.x = Engine_Game.orgGameRes.x - BT_Credits.Size().x - 100;
				BT_Credits.y = (Engine_Game.orgGameRes.y / 2) + BT_Credits.Size().y + 50;
			}
			
			if(!BT_Exit)
			{
				BT_Exit = new GUI_Button("Exit", 280, 97, mainGame, AssetsManager.BM_Button, Engine_States.STATE_EXITAPP);
				BT_Exit.x = Engine_Game.orgGameRes.x - BT_Play.Size().x - 100;
				BT_Exit.y = (Engine_Game.orgGameRes.y / 2) + BT_Exit.Size().y * 2 + 70;
			}
		}
	}
}