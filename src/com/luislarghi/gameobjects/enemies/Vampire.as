package com.luislarghi.gameobjects.enemies
{
	import com.luislarghi.R;
	import com.luislarghi.gameobjects.baseclasses.Enemy;
	import com.luislarghi.gamestates.Stage_1;
	import com.luislarghi.managers.AssetsManager;
	import com.luislarghi.myfirtsengine.Engine_SoundManager;
	import com.luislarghi.myfirtsengine.Engine_SpriteSheet;
	
	import flash.events.Event;

	public class Vampire extends Enemy
	{
		public function Vampire(data:XML) 
		{ 
			super(data);
			
			SpriteSheet = new Engine_SpriteSheet(AssetsManager.BM_Vampiro, false, R.tileWidth, R.tileHeight * 2);
			SpriteSheet.y -= R.tileHeight;
			this.addChild(SpriteSheet);
		}
		
		public override function DeathSound():void { Engine_SoundManager.PlaySound(AssetsManager.SND_VampireDeath); }
	}
}