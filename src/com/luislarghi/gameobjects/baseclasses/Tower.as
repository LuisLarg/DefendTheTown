package com.luislarghi.gameobjects.baseclasses
{
	import com.luislarghi.R;
	import com.luislarghi.gamestates.Stage_1;
	import com.luislarghi.myfirtsengine.Engine_SpriteSheet;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import com.luislarghi.gameobjects.Stats;
	
	public class Tower extends Character
	{
		private var collitionArea:Sprite;
		protected var nearestEnemy:Enemy;
		protected var deployPoint:Point;
		private var aimDirection:Point;
		private var maxFramePerAnim:int;
		
		protected var shootRate:int;
		protected var counter:int;
		private var cost:int;
		
		public function Tower(tile:Point, data:XML)
		{
			this.deployPoint = tile;
			this.shootRate = data.@shootRate;
			this.cost = data.@cost;
			this.maxFramePerAnim = data.@framePerAnim;
			
			this.x = deployPoint.x + R.tileWidth / 2;
			this.y = deployPoint.y + R.tileHeight / 2;
		}
		
		public override function Init():void
		{
			super.Init();
			
			aimDirection = new Point(0, 1);
			
			if(!collitionArea) collitionArea = new Sprite();
			collitionArea.x = (this.x - (R.tileWidth / 2)) - R.tileWidth;
			collitionArea.y = (this.y - (R.tileHeight / 2)) -  R.tileHeight;
			collitionArea.graphics.beginFill(0xFFFFFF);
			collitionArea.graphics.drawRect(0, 0, R.tileWidth * 3, R.tileHeight * 3);
			collitionArea.visible = false;
			Stage_1.gameObjContainer.addChild(collitionArea);
			
			currentAnimTile = 0;
		}
		
		public override function Clear():void
		{
			Stage_1.gameObjContainer.removeChild(collitionArea);
			Stage_1.gameObjContainer.removeChild(SpriteSheet);
			
			SpriteSheet = null;		
			collitionArea = null;
			nearestEnemy = null;
		}
	
		public override function Logic():void
		{
			NearestEnemy();
			Aim();
			UpdateAnim();
			Shoot();
		}

		private function NearestEnemy():void
		{
			for(var i:int = 0; i < R.waves[Stats.currentWave].length; i++)
			{
				if(collitionArea.hitTestObject(R.waves[Stats.currentWave][i]))
				{
					nearestEnemy = R.waves[Stats.currentWave][i];
					return;
				}
			}
			
			nearestEnemy = null;
		}
		
		private function Aim():void
		{
			if(nearestEnemy)
			{
				this.rotation = Math.atan2(nearestEnemy.y - this.y, nearestEnemy.x - this.x) * 180 / Math.PI;
			}
			
			if((this.rotation > 135 && this.rotation <= 180) || (this.rotation < 0 && this.rotation >= -45)) //Aim Left
			{
				aimDirection.x = -1;
				aimDirection.y = 0;
				
				currentAnimTile = 0;
				SpriteSheet.scaleX = -1;
				SpriteSheet.x = this.x + R.tileWidth / 2;
			}
			else if(this.rotation < -45 && this.rotation >= -135) //Aim Up
			{
				aimDirection.x = 0;
				aimDirection.y = -1;
				
				currentAnimTile = maxFramePerAnim * 2;
				SpriteSheet.scaleX = 1;
				SpriteSheet.x = this.x - R.tileWidth / 2;
			}
			else if((this.rotation < -135 && this.rotation >= -180) || (this.rotation > 0 && this.rotation <= 45)) //Aim Right
			{
				aimDirection.x = 1;
				aimDirection.y = 0;
				
				currentAnimTile = 0;
				SpriteSheet.scaleX = 1;
				SpriteSheet.x = this.x - R.tileWidth / 2;
			}
			else if(this.rotation > 45 && this.rotation >= 135) //Aim Down
			{
				aimDirection.x = 0;
				aimDirection.y = 1;
				
				currentAnimTile = maxFramePerAnim;
				SpriteSheet.scaleX = 1;
				SpriteSheet.x = this.x - R.tileWidth / 2;
			}
		}
		
		protected override function UpdateAnim():void
		{
			if(aimDirection.x == 1 && aimDirection.y == 0) //Right
			{
				if(nearestEnemy)
				{
					currentAnimTile++;
					
					if(currentAnimTile > maxFramePerAnim - 1) currentAnimTile = 0;
				}
				else
					currentAnimTile = 0;
			}
			else if(aimDirection.x == 0 && aimDirection.y == 1) //Down
			{
				if(nearestEnemy)
				{
					currentAnimTile++;
					
					if(currentAnimTile > (maxFramePerAnim * 2) - 1) currentAnimTile = maxFramePerAnim;
				}
				else
					currentAnimTile = maxFramePerAnim;
			}
			else if(aimDirection.x == -1 && aimDirection.y == 0) //Left
			{
				if(nearestEnemy)
				{
					currentAnimTile++;
					
					if(currentAnimTile > maxFramePerAnim - 1) currentAnimTile = 0;
				}
				else
					currentAnimTile = 0;
			}
			else if(aimDirection.x == 0 && aimDirection.y == -1) //Up
			{
				if(nearestEnemy)
				{
					currentAnimTile++;
					
					if(currentAnimTile > (maxFramePerAnim * 3) - 1) currentAnimTile = maxFramePerAnim * 2;
				}
				else
					currentAnimTile = maxFramePerAnim * 2;
			}
		}
		
		protected function Shoot():void { }
		
		public function get BuildCost():int { return cost; }
	}
}