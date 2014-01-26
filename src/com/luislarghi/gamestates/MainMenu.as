package com.luislarghi.gamestates
{
	import com.luislarghi.Game;
	import com.luislarghi.R;
	import com.luislarghi.gui.GUI_Button;
	import com.luislarghi.gui.GUI_MainMenu;
	import com.luislarghi.myfirtsengine.Engine_Game;
	import com.luislarghi.myfirtsengine.Engine_GameState;
	import com.luislarghi.myfirtsengine.Engine_SpriteSheet;
	import com.luislarghi.myfirtsengine.Engine_States;
	
	import flash.desktop.NativeApplication;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	
	public class MainMenu extends Engine_GameState
	{
		private var bgImage:Engine_SpriteSheet;
		
		private var GUI_component:GUI_MainMenu;
		
		public static var guiContainer:Sprite;
		
		public function MainMenu(g:Game) { super(Main.mainStage, g); }
		
		protected override function Init(e:Event):void
		{
			super.Init(e);
			
			bgImage = new Engine_SpriteSheet(R.BM_MainMenu, false, 1280, 800);
			bgImage.drawTile(0);
			this.addChild(bgImage);
			
			guiContainer = new Sprite();
			this.addChild(guiContainer);
			
			if(Capabilities.cpuArchitecture == "ARM")
			{
				if(Capabilities.manufacturer.indexOf("Android") != -1)
				{
					NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, SoftKeyDown);
				}
			}
			
			GUI_component = new GUI_MainMenu(mainGame);
			GUI_component.Init();
			
			trace("Main Menu: "+this.width+", "+this.height+" | Game resolution: "+Engine_Game.orgGameRes);
			//trace("You are in the MAINMENU");
		}
		
		protected override function Clear(e:Event):void
		{
			super.Clear(e);
			
			if(Capabilities.cpuArchitecture == "ARM")
			{
				if(Capabilities.manufacturer.indexOf("Android") != -1)
				{
					NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, SoftKeyDown);
				}
			}
			
			GUI_component.Clear();
			GUI_component = null;
			
			this.removeChild(guiContainer);
			guiContainer = null;
			
			this.removeChild(bgImage);
			bgImage = null;
		}
		
		protected override function Draw():void
		{
			GUI_component.Draw();
		}
		
		private function SoftKeyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.BACK:
					mainGame.SetNextState(Engine_States.STATE_EXITAPP);
					break;
				
				case Keyboard.SEARCH:
					e.preventDefault();
					break;
				
				case Keyboard.MENU:
					e.preventDefault();
					break;
			}
		}
	}
}