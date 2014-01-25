package com.luislarghi.gui
{
	import com.luislarghi.Game;
	import com.luislarghi.R;
	import com.luislarghi.gameobjects.Stats;
	import com.luislarghi.gamestates.Stage_1;
	import com.luislarghi.myfirtsengine.Engine_GUI;
	import com.luislarghi.myfirtsengine.Engine_Game;
	import com.luislarghi.myfirtsengine.Engine_GameState;
	import com.luislarghi.myfirtsengine.Engine_States;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class GUI_Stage1 extends Engine_GUI
	{
		private var TF_Score:TextField;
		private var TF_Money:TextField;
		private var TF_TownH:TextField;
		private var TF_Format:TextFormat;
		
		private var window:Sprite;
		private var TF_WinLabel:TextField;
		private var BT_Resume:GUI_Button;
		private var BT_Menu:GUI_Button;
		private var BT_Replay:GUI_Button;
		private var BT_Next:GUI_Button;
		private var BT_Exit:GUI_Button;
		
		private var BT_CuraIcon:GUI_HUDButton;
		private var BT_PiroIcon:GUI_HUDButton;
		private var BT_PerroIcon:GUI_HUDButton;
		
		public function GUI_Stage1(g:Engine_Game) { super(Main.mainStage, g); }
		
		public override function Init():void
		{
			CreateWindow();
			CreateHUD();
			
			Stage_1.guiContainer.addChild(TF_Score);
			Stage_1.guiContainer.addChild(TF_Money);
			Stage_1.guiContainer.addChild(TF_TownH);
			Stage_1.guiContainer.addChild(BT_CuraIcon);
			Stage_1.guiContainer.addChild(BT_PiroIcon);
			Stage_1.guiContainer.addChild(BT_PerroIcon);
			Stage_1.guiContainer.addChild(window);
			Stage_1.guiContainer.addChild(TF_WinLabel);
			Stage_1.guiContainer.addChild(BT_Resume);
			Stage_1.guiContainer.addChild(BT_Menu);
			Stage_1.guiContainer.addChild(BT_Replay);
			Stage_1.guiContainer.addChild(BT_Next);
			Stage_1.guiContainer.addChild(BT_Exit);
		}
		
		public override function Clear():void
		{
			Stage_1.guiContainer.removeChild(TF_Score);
			Stage_1.guiContainer.removeChild(TF_Money);
			Stage_1.guiContainer.removeChild(TF_TownH);
			Stage_1.guiContainer.removeChild(BT_CuraIcon);
			Stage_1.guiContainer.removeChild(BT_PiroIcon);
			Stage_1.guiContainer.removeChild(BT_PerroIcon);
			Stage_1.guiContainer.removeChild(window);
			Stage_1.guiContainer.removeChild(TF_WinLabel);
			Stage_1.guiContainer.removeChild(BT_Resume);
			Stage_1.guiContainer.removeChild(BT_Menu);
			Stage_1.guiContainer.removeChild(BT_Replay);
			Stage_1.guiContainer.removeChild(BT_Next);
			Stage_1.guiContainer.removeChild(BT_Exit);
		}
		
		private function CreateWindow():void
		{
			if(!window) window = new Sprite();
			
			window.graphics.beginFill(0x000000);
			window.graphics.drawRect(0, 0, Engine_Game.orgGameRes.x - (Engine_Game.orgGameRes.x / 3), Engine_Game.orgGameRes.y - (Engine_Game.orgGameRes.y / 3));
			window.graphics.endFill();
			
			window.x = (Engine_Game.orgGameRes.x / 2) - (window.width / 2);
			window.y = (Engine_Game.orgGameRes.y / 2) - (window.height / 2);
			
			window.visible = false;
			
			if(!TF_WinLabel)
			{
				TF_WinLabel = new TextField();
				TF_WinLabel.text = "Pause";
				TF_WinLabel.x = (Engine_Game.orgGameRes.x / 2) - (TF_WinLabel.width / 2);
				TF_WinLabel.y = window.y + TF_WinLabel.height / 2;
				TF_WinLabel.selectable = false;
				TF_WinLabel.mouseEnabled = false;
				TF_WinLabel.visible = false;
			}
			
			if(!BT_Resume)
			{
				BT_Resume = new GUI_Button("Resume", 280, 97, mainGame, R.BM_Button);
				BT_Resume.x = Engine_Game.orgGameRes.x / 2 - BT_Resume.Size().x - 5;
				BT_Resume.y = (Engine_Game.orgGameRes.y / 2)- (BT_Resume.Size().y / 2);
				BT_Resume.visible = false;
			}
			
			if(!BT_Menu)
			{
				BT_Menu = new GUI_Button("Exit", 280, 97, mainGame, R.BM_Button, Engine_States.STATE_MAINMENU);	
				BT_Menu.x = Engine_Game.orgGameRes.x / 2 + 5;
				BT_Menu.y = (Engine_Game.orgGameRes.y / 2) - (BT_Menu.Size().y / 2);
				BT_Menu.visible = false;
			}
			
			if(!BT_Replay)
			{
				BT_Replay = new GUI_Button("Replay", 280, 97, mainGame, R.BM_Button, Engine_States.STATE_INGAME);					
				BT_Replay.x = Engine_Game.orgGameRes.x / 2 - BT_Replay.Size().x - 5;
				BT_Replay.y = (Engine_Game.orgGameRes.y / 2)- (BT_Replay.Size().y / 2);
				BT_Replay.visible = false;
			}
			
			if(!BT_Next)
			{
				BT_Next = new GUI_Button("Next", 280, 97, mainGame, R.BM_Button, 100);					
				BT_Next.x = Engine_Game.orgGameRes.x / 2 - BT_Next.Size().x - 5;
				BT_Next.y = (Engine_Game.orgGameRes.y / 2)- (BT_Next.Size().y / 2);
				BT_Next.visible = false;
			}
			
			if(!BT_Exit) 
			{
				BT_Exit = new GUI_Button("Exit", 280, 97, mainGame, R.BM_Button, Engine_States.STATE_MAINMENU);			
				BT_Exit.x = Engine_Game.orgGameRes.x / 2 + 5;
				BT_Exit.y = (Engine_Game.orgGameRes.y / 2) - (BT_Exit.Size().y / 2);
				BT_Exit.visible = false;
			}
		}

		protected override function InstantiateAllTF():void
		{
			if(!TF_Score)
			{
				TF_Score = new TextField();
				TF_Score.text = "Score = " + Stats.score;
				TF_Score.x = 20;
				TF_Score.selectable = false;
				TF_Score.mouseEnabled = false;
			}
			
			if(!TF_Money)
			{
				TF_Money = new TextField();
				TF_Money.text = "Money = " + Stats.money;
				TF_Money.x = Engine_Game.orgGameRes.x - TF_Money.width - 20;
				TF_Money.selectable = false;
				TF_Money.mouseEnabled = false;
			}
			
			if(!TF_TownH)
			{
				TF_TownH = new TextField();
				TF_TownH.text = "Town = " + Stats.townHealth;
				TF_TownH.x = (Engine_Game.orgGameRes.x / 2) - (TF_TownH.width / 2);
				TF_TownH.selectable = false;
				TF_TownH.mouseEnabled = false;
			}
			
			if(!TF_Format)
			{
				TF_Format = new TextFormat();
				TF_Format.size = 40 * Engine_Game.newScale;
				TF_Format.font = "Feast of Flesh BB";
				TF_Format.color = 0xFFFFFF;
			}
		}
		
		private function CreateHUD():void
		{
			if(!BT_CuraIcon)
			{
				BT_CuraIcon = new GUI_HUDButton(" ", 128, 128, mainGame, R.BM_HUD, R.CURAMODE);
				BT_CuraIcon.x = (Engine_Game.orgGameRes.x / 2) + BT_CuraIcon.Size().x;
				BT_CuraIcon.y = Engine_Game.orgGameRes.y - (BT_CuraIcon.Size().y / 2) - BT_CuraIcon.Size().y;
				BT_CuraIcon.ChangeAnimation(1);
			}
			
			if(!BT_PiroIcon)
			{
				BT_PiroIcon = new GUI_HUDButton(" ", 128, 128, mainGame, R.BM_HUD, R.PIROMODE);
				BT_PiroIcon.x = (Engine_Game.orgGameRes.x / 2) - (BT_PiroIcon.Size().x * 2);
				BT_PiroIcon.y = Engine_Game.orgGameRes.y - (BT_PiroIcon.Size().y / 2) - BT_PiroIcon.Size().y;
				BT_PiroIcon.ChangeAnimation(2);
			}
			
			if(!BT_PerroIcon)
			{
				BT_PerroIcon = new GUI_HUDButton(" ", 128, 128, mainGame, R.BM_HUD, R.PERROMODE);
				BT_PerroIcon.x = (Engine_Game.orgGameRes.x / 2) - (BT_PerroIcon.Size().x / 2);
				BT_PerroIcon.y = Engine_Game.orgGameRes.y - (BT_PerroIcon.Size().y / 2) - BT_PerroIcon.Size().y;
				BT_PerroIcon.ChangeAnimation(0);
			}
		}
		
		public override function Logic():void
		{
			TF_Score.text = "Score = " + Stats.score;
			TF_Money.text = "Money = " + Stats.money;
			TF_TownH.text = "Town = " + Stats.townHealth;
		}
		
		public override function Draw():void
		{
			TF_Score.setTextFormat(TF_Format, 0, TF_Score.length);
			TF_Score.autoSize = TextFieldAutoSize.CENTER;
			
			TF_Money.setTextFormat(TF_Format, 0, TF_Money.length);
			TF_Money.autoSize = TextFieldAutoSize.CENTER;
			
			TF_TownH.setTextFormat(TF_Format, 0, TF_TownH.length);
			TF_TownH.autoSize = TextFieldAutoSize.CENTER;
			
			BT_CuraIcon.Draw();
			BT_PerroIcon.Draw();
			BT_PiroIcon.Draw();
			
			if(Stage_1.GetPause())
			{
				TF_WinLabel.text = "Pause";
				window.visible = BT_Resume.visible = BT_Menu.visible = TF_WinLabel.visible = true;
				
				TF_WinLabel.setTextFormat(TF_Format, 0, TF_WinLabel.length);
				TF_WinLabel.autoSize = TextFieldAutoSize.CENTER;
			}
			else if(Stage_1.GetGameOver())
			{
				if(Stats.townHealth > 0)
				{
					TF_WinLabel.text = "You Win!";
					BT_Next.visible = true;
				}
				else 
				{
					TF_WinLabel.text = "You Lose!";
					BT_Replay.visible = true;
				}
				
				window.visible = BT_Exit.visible = TF_WinLabel.visible = true;
				
				TF_WinLabel.setTextFormat(TF_Format, 0, TF_WinLabel.length);
				TF_WinLabel.autoSize = TextFieldAutoSize.CENTER;
			}
			else
			{
				window.visible = BT_Resume.visible = BT_Next.visible = BT_Menu.visible = false;
				BT_Replay.visible = BT_Exit.visible = TF_WinLabel.visible = false;
			}			
		}
	}
}