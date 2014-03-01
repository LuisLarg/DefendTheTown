package com.luislarghi.gameobjects.towers
{
	import com.luislarghi.R;
	import com.luislarghi.gameobjects.baseclasses.Bullet;
	import com.luislarghi.gameobjects.baseclasses.Tower;
	import com.luislarghi.gameobjects.bullets.Dog;
	import com.luislarghi.gamestates.Stage_1;
	import com.luislarghi.managers.AssetsManager;
	import com.luislarghi.myfirtsengine.Engine_SoundManager;
	import com.luislarghi.myfirtsengine.Engine_SpriteSheet;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Dogman extends Tower
	{
		public function Dogman(tile:Point, data:XML, stage:Stage_1) { super(tile, data, stage); }
		
		public override function Init():void
		{
			super.Init();
			
			SpriteSheet = new Engine_SpriteSheet(AssetsManager.BM_Perrero, false, R.tileWidth, R.tileHeight * 2);
			SpriteSheet.y = -R.tileHeight;
			this.addChild(SpriteSheet);
		}
		
		protected override function Shoot():void
		{
			if(nearestEnemy)
			{
				counter += Main.mainStage.frameRate * shootRate / 1000;
				
				if(counter >= shootRate)
				{
					var bullet:Bullet = new Dog(this.x, this.y, aimSight.rotation);
					mainStage.gameObjContainer.addChild(bullet);
					mainStage.bullets.push(bullet);
					bullet.Init();
					
					Engine_SoundManager.PlaySound(AssetsManager.SND_DogBark);
					counter = 0;
				}
			}
		}
	}
}