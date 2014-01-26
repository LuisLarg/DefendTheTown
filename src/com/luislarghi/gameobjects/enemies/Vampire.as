package com.luislarghi.gameobjects.enemies
{
	import com.luislarghi.R;
	import com.luislarghi.myfirtsengine.Engine_SpriteSheet;
	
	import flash.events.Event;
	import com.luislarghi.gameobjects.baseclasses.Enemy;

	public class Vampire extends Enemy
	{
		public function Vampire(data:XML) { super(data); }
		
		public override function Init():void
		{
			super.Init();
			
			SpriteSheet = new Engine_SpriteSheet(R.BM_Vampiro, false, R.tileWidth, R.tileHeight * 2);
			SpriteSheet.y -= R.tileHeight;
			this.addChild(SpriteSheet);
		}
	}
}