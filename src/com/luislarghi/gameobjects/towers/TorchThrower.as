package com.luislarghi.gameobjects.towers
{
	import com.luislarghi.R;
	import com.luislarghi.gameobjects.baseclasses.Bullet;
	import com.luislarghi.gameobjects.baseclasses.Tower;
	import com.luislarghi.gameobjects.bullets.Torch;
	import com.luislarghi.gamestates.Stage_1;
	import com.luislarghi.managers.AssetsManager;
	import com.luislarghi.myfirtsengine.Engine_SpriteSheet;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	public class TorchThrower extends Tower
	{
		public function TorchThrower(tile:Point, data:XML, stage:Stage_1) { super(tile, data, stage); }
		
		public override function Init():void
		{
			super.Init();
			
			SpriteSheet = new Engine_SpriteSheet(AssetsManager.BM_Piromano, false, R.tileWidth, R.tileHeight * 2);
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
					var bullet:Bullet = new Torch(this.x, this.y, aimSight.rotation);
					mainStage.gameObjContainer.addChild(bullet);
					mainStage.bullets.push(bullet);
					bullet.Init();
					counter = 0;
				}
			}
		}
	}
}