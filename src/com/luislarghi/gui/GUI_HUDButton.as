package com.luislarghi.gui
{
	import com.luislarghi.R;
	import com.luislarghi.gameobjects.Stats;
	import com.luislarghi.gamestates.Stage_1;
	import com.luislarghi.managers.AssetsManager;
	import com.luislarghi.managers.XmlManager;
	import com.luislarghi.myfirtsengine.Engine_GUIButton;
	import com.luislarghi.myfirtsengine.Engine_Game;
	import com.luislarghi.myfirtsengine.Engine_SoundManager;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class GUI_HUDButton extends Engine_GUIButton
	{
		private var TF_TowerCost:TextField;
		private var TF_Format:TextFormat;
		
		private var clickable:Boolean = false;
		
		public function GUI_HUDButton(w:int, h:int, g:Engine_Game, bM:Bitmap, s:int)
		{
			super(" ", w, h, bM, s, g);
		}
		
		protected override function Init(e:Event):void
		{
			super.Init(e);
			
			this.addEventListener(MouseEvent.CLICK, ButtonPressed);
			this.addChild(TF_TowerCost);
		}
		
		protected override function Clear(e:Event):void
		{
			super.Clear(e);
			
			this.removeEventListener(MouseEvent.CLICK, ButtonPressed);
			this.removeChild(TF_TowerCost);
			
			TF_TowerCost = null;
			TF_Format = null;
		}
		
		protected override function InstantiateAllTF():void
		{
			if(!TF_TowerCost)
			{
				TF_TowerCost = new TextField();
				if(state == R.PIROMODE) TF_TowerCost.text = XmlManager.towerTypes.tower[0].@cost;
				else if(state == R.PERROMODE) TF_TowerCost.text = XmlManager.towerTypes.tower[1].@cost;
				else if(state == R.CURAMODE) TF_TowerCost.text = XmlManager.towerTypes.tower[2].@cost;
				TF_TowerCost.x = btWidth - 75;
				TF_TowerCost.y = btHeight - 20;
				TF_TowerCost.selectable = TF_TowerCost.mouseEnabled = false;
			}
			
			if(!TF_Format)
			{
				TF_Format = new TextFormat();
				TF_Format.size = 20 * (Engine_Game.newScaleX / Engine_Game.newScaleY);
				TF_Format.color = 0xFFFFFF;
				TF_Format.font = "Arial";
			}
			
			TF_TowerCost.setTextFormat(TF_Format, 0, TF_TowerCost.length);
			TF_TowerCost.autoSize = TextFieldAutoSize.CENTER;
		}
		
		public override function Draw():void
		{
			CheckIfClickable();
			
			super.Draw();
		}
		
		private function ButtonPressed(e:MouseEvent):void
		{
			if(state != R.NULLMODE && clickable)
			{
				switch(state)
				{
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
				
				Engine_SoundManager.PlaySound(AssetsManager.SND_Click);
			}
		}
		
		private function CheckIfClickable():void
		{
			var towerType:int = 0;
			
			if(state == R.PIROMODE) towerType = 0;
			else if(state == R.PERROMODE) towerType = 1;
			else if(state == R.CURAMODE) towerType = 2;
			
			if(Stats.money < XmlManager.towerTypes.tower[towerType].@cost) 
			{
				clickable = false;
				spriteSheet.alpha = 0.5;
			}
			else 
			{
				clickable = true;
				spriteSheet.alpha = 1;
			}
		}
	}
}