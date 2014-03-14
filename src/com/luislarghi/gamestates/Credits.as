package com.luislarghi.gamestates
{
	import com.luislarghi.R;
	import com.luislarghi.gui.GUI_Credits;
	import com.luislarghi.managers.AssetsManager;
	import com.luislarghi.myfirtsengine.Engine_Game;
	import com.luislarghi.myfirtsengine.Engine_GameState;
	import com.luislarghi.myfirtsengine.Engine_SoundManager;
	import com.luislarghi.myfirtsengine.Engine_SpriteSheet;
	import com.luislarghi.myfirtsengine.Engine_States;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	
	public class Credits extends Engine_GameState
	{
		private var bgImage:Engine_SpriteSheet;
		
		private var GUI_component:GUI_Credits;
		
		public static var guiContainer:Sprite;
		
		public function Credits(g:Engine_Game) { super(Main.mainStage, g); }
		
		protected override function Init(e:Event):void
		{
			super.Init(e);
			
			bgImage = new Engine_SpriteSheet(AssetsManager.BM_MainMenu, false, 1280, 800);
			bgImage.drawTile(0);
			this.addChild(bgImage);
			
			guiContainer = new Sprite();
			this.addChild(guiContainer);
			
			if(R.isAndroid() || R.isIOS())
			{
				if(R.isAndroid())
				{
					NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, OnActivate);
					NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, OnDeactivate);
					NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, SoftKeyDown);
				}
			}
			
			GUI_component = new GUI_Credits(mainGame);
			GUI_component.Init();
			
			trace("Credits: ("+this.width+", "+this.height+") | Scale: ("+this.scaleX+", "+this.scaleY+")");
		}
		
		protected override function Clear(e:Event):void
		{
			super.Clear(e);
			
			if(R.isAndroid() || R.isIOS())
			{
				if(R.isAndroid())
				{
					NativeApplication.nativeApplication.removeEventListener(Event.ACTIVATE, OnActivate);
					NativeApplication.nativeApplication.removeEventListener(Event.DEACTIVATE, OnDeactivate);
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
					e.preventDefault();
					mainGame.SetNextState(Engine_States.STATE_MAINMENU);
					break;
				
				case Keyboard.SEARCH:
					e.preventDefault();
					break;
				
				case Keyboard.MENU:
					e.preventDefault();
					break;
			}
		}
		
		private function OnActivate(e:Event):void
		{
			Engine_SoundManager.PlayMusic(AssetsManager.SND_Music);
		}
		
		private function OnDeactivate(e:Event):void
		{
			Engine_SoundManager.StopMusic();
		}
	}
}