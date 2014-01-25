package com.luislarghi.gameobjects
{
	import com.luislarghi.R;
	import com.luislarghi.gamestates.Stage_1;
	import com.luislarghi.myfirtsengine.Engine_SpriteSheet;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Monk extends Tower
	{
		public function Monk(tile:Point, data:XML) { super(tile, data); }
		
		public override function Init():void
		{
			super.Init();
			
			SpriteSheet = new Engine_SpriteSheet(R.BM_Cura, false, R.tileWidth, R.tileHeight * 2);
			SpriteSheet.x = deployPoint.x;
			SpriteSheet.y = deployPoint.y - R.tileHeight;
			Stage_1.gameObjContainer.addChild(SpriteSheet);
		}
		
		protected override function Shoot():void
		{
			if(nearestEnemy)
			{
				counter += Main.mainStage.frameRate * shootRate / 1000;
				
				if(counter >= shootRate)
				{
					var bullet:Bullet = new GlintLight(this.x, this.y, this.rotation);
					Stage_1.gameObjContainer.addChild(bullet);
					Stage_1.bullets.push(bullet);
					counter = 0;
				}
			}
		}
	}
}