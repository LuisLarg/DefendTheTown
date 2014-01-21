package com.luislarghi.gui
{
	import com.luislarghi.R;
	import com.luislarghi.gamestates.Stage_1;
	import com.luislarghi.myfirtsengine.Engine_Game;
	import com.luislarghi.myfirtsengine.Engine_SoundManager;
	import com.luislarghi.myfirtsengine.Engine_SpriteSheet;
	import com.luislarghi.myfirtsengine.Engine_States;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class GUI_Button extends Sprite
	{
		private var spriteSheet:Engine_SpriteSheet;
		private var currentSpriteS:Bitmap;
		private var currentAnimFrame:int = 0;
		
		private var TF_Label:TextField;
		private var TF_Format:TextFormat;
		
		private var mainGame:Engine_Game;
		
		private var text:String;
		private var btWidth:int;
		private var btHeight:int;
		private var state:int;
		
		public function GUI_Button(label:String, w:int, h:int, g:Engine_Game, bM:Bitmap, s:int = Engine_States.STATE_NULL)
		{
			btWidth = w;
			btHeight = h;		
			text = label;
			mainGame = g;
			state = s;
			currentSpriteS = bM;
			
			this.addEventListener(Event.ADDED_TO_STAGE, Init);
			this.addEventListener(Event.REMOVED_FROM_STAGE, Clear);
			
			InstantiateAllTF();
		}

		private function Init(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, Init);
			
			this.addEventListener(MouseEvent.CLICK, ButtonPressed);
			
			spriteSheet = new Engine_SpriteSheet(currentSpriteS, false, btWidth, btHeight);
			this.addChild(spriteSheet);
			
			this.addChild(TF_Label);
		}
		
		private function Clear(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, Clear);
			
			this.removeEventListener(MouseEvent.CLICK, ButtonPressed);
			
			this.removeChild(spriteSheet);
			this.removeChild(TF_Label);
			
			spriteSheet = null;
			TF_Label = null;
			TF_Format = null;
		}
		
		public function Draw():void { spriteSheet.drawTile(currentAnimFrame); }
		
		private function InstantiateAllTF():void
		{
			if(!TF_Label)
			{
				TF_Label = new TextField();
				TF_Label.text = text;
				TF_Label.x = (btWidth / 2) - (TF_Label.width / 2);
				TF_Label.y = (btHeight / 2) - 30;
				TF_Label.selectable = false;
				TF_Label.mouseEnabled = false;
			}
			
			if(!TF_Format)
			{
				TF_Format = new TextFormat();
				TF_Format.size = 40;
				TF_Format.font = "Arial";
			}
			
			TF_Label.setTextFormat(TF_Format, 0, TF_Label.length);
			TF_Label.autoSize = TextFieldAutoSize.CENTER;
		}
		
		public function ButtonPressed(e:MouseEvent):void
		{
			if(state != Engine_States.STATE_NULL)
			{
				switch(state)
				{
					case Engine_States.STATE_INGAME:
						mainGame.SetNextState(Engine_States.STATE_INGAME);
						break;
					
					case Engine_States.STATE_MAINMENU:
						mainGame.SetNextState(Engine_States.STATE_MAINMENU);
						break;
					
					case Engine_States.STATE_CREDITS:
						mainGame.SetNextState(Engine_States.STATE_CREDITS);
						break;
					
					case Engine_States.STATE_EXITAPP:
						mainGame.SetNextState(Engine_States.STATE_EXITAPP);
						break;
					
					case R.PIROMODE:
						Stage_1.currentBuildMode = R.PIROMODE;
						break;
					
					case R.PERROMODE:
						Stage_1.currentBuildMode = R.PERROMODE;
						break;
					
					case R.CURAMODE:
						Stage_1.currentBuildMode = R.CURAMODE;
						break;
				}
			}
			else
				Stage_1.SetPause(false);
			
			Engine_SoundManager.PlaySound(R.SND_Click);
		}
		
		public function Size():Point { return new Point(btWidth, btHeight); }
		public function ChangeAnimation(v:int):void { currentAnimFrame = v; }
	}
}