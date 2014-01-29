package com.luislarghi.gameobjects.enemies
{
	import com.luislarghi.R;
	import com.luislarghi.gameobjects.baseclasses.Enemy;
	import com.luislarghi.gamestates.Stage_1;
	import com.luislarghi.myfirtsengine.Engine_SpriteSheet;
	
	import flash.events.Event;

	public class Mummy extends Enemy
	{
		public function Mummy(data:XML) { super(data); }
		
		public override function Init():void
		{
			super.Init();
			
			SpriteSheet = new Engine_SpriteSheet(R.BM_Momia, false, R.tileWidth, R.tileHeight * 2);
			SpriteSheet.y -= R.tileHeight;
			this.addChild(SpriteSheet);
		}
	}
}