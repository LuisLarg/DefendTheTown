package com.luislarghi.gui
{
	import com.luislarghi.R;
	import com.luislarghi.gamestates.Credits;
	import com.luislarghi.managers.AssetsManager;
	import com.luislarghi.myfirtsengine.Engine_GUI;
	import com.luislarghi.myfirtsengine.Engine_Game;
	import com.luislarghi.myfirtsengine.Engine_States;
	
	import flash.display.Stage;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class GUI_Credits extends Engine_GUI
	{
		private var TF_Credits:TextField;
		private var TF_Format:TextFormat;
		private var BT_Return:GUI_Button;
		
		public function GUI_Credits(g:Engine_Game) { super(Main.mainStage, g); }
		
		public override function Init():void
		{
			Credits.guiContainer.addChild(TF_Credits);
			Credits.guiContainer.addChild(BT_Return);
		}
		
		public override function Clear():void
		{
			Credits.guiContainer.removeChild(TF_Credits);
			Credits.guiContainer.removeChild(BT_Return);
			
			TF_Credits = null;
			BT_Return = null;
		}
		
		public override function Draw():void
		{
			BT_Return.Draw();
		}
		
		protected override function InstantiateAllTF():void
		{
			if(!TF_Credits)
			{
				TF_Credits = new TextField();
				TF_Credits.text = "Creador por Paula Gonzales y Luis Larghi";
				TF_Credits.x = (Engine_Game.orgGameRes.x / 2) - (TF_Credits.width / 2);
				TF_Credits.y = (Engine_Game.orgGameRes.y / 2) + (TF_Credits.height / 2);
				TF_Credits.selectable = false;
				TF_Credits.mouseEnabled = false;
			}
			
			if(!TF_Format)
			{
				TF_Format = new TextFormat();
				TF_Format.size = 60 * (Engine_Game.newScaleX / Engine_Game.newScaleY);
				TF_Format.font = "Arial";
				TF_Format.color = 0xFFFFFF;
			}
			
			if(!BT_Return)
			{
				BT_Return = new GUI_Button("Return", 280, 97, mainGame, AssetsManager.BM_Button, Engine_States.STATE_MAINMENU);
				BT_Return.x = (Engine_Game.orgGameRes.x / 2) - (BT_Return.Size().x / 2);
				BT_Return.y = (Engine_Game.orgGameRes.y / 2) + BT_Return.Size().y * 2;
			}
			
			TF_Credits.setTextFormat(TF_Format, 0, TF_Credits.length);
			TF_Credits.autoSize = TextFieldAutoSize.CENTER;
			TF_Credits.gridFitType = GridFitType.NONE;
		}
	}
}