package com.luislarghi.gui
{
	import com.luislarghi.R;
	import com.luislarghi.gameobjects.baseclasses.Tower;
	import com.luislarghi.gamestates.Stage_1;
	import com.luislarghi.myfirtsengine.Engine_GUIButton;
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
	
	public class GUI_Button extends Engine_GUIButton
	{
		private var TF_Label:TextField;
		private var TF_Format:TextFormat;
		
		public function GUI_Button(label:String, w:int, h:int, g:Engine_Game, bM:Bitmap, s:int = Engine_States.STATE_NULL)
		{
			super(label, w, h, bM, s, g);
		}

		protected override function Init(e:Event):void
		{
			super.Init(e);
			
			this.addEventListener(MouseEvent.CLICK, ButtonPressed);
			this.addChild(TF_Label);
		}
		
		protected override function Clear(e:Event):void
		{
			super.Clear(e);
			
			this.removeEventListener(MouseEvent.CLICK, ButtonPressed);
			this.removeChild(TF_Label);
			
			TF_Label = null;
			TF_Format = null;
		}

		protected override function InstantiateAllTF():void
		{
			if(!TF_Label)
			{
				TF_Label = new TextField();
				TF_Label.text = text;
				TF_Label.x = (btWidth / 2) - (TF_Label.width / 2);
				TF_Label.y = (btHeight / 2) - 30;
				TF_Label.selectable = TF_Label.mouseEnabled = false;
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
					
					case 100:
						Stage_1.changingLevel = true;
						break;
				}
			}
			else
				Stage_1.SetPause(false);
			
			Engine_SoundManager.PlaySound(R.SND_Click);
		}
	}
}