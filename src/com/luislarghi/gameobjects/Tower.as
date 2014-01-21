package com.luislarghi.gameobjects
{
	import com.luislarghi.R;
	import com.luislarghi.gamestates.Stage_1;
	import com.luislarghi.myfirtsengine.Engine_SpriteSheet;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Tower extends Character
	{
		private var collitionArea:Sprite;
		private var nearestEnemy:Enemy;
		private var deployPoint:Point;
		private var aimDirection:Point = new Point(0, 1);
		private var towerType:String;
		private var maxFramePerAnim:int;
		
		private var shootRate:int;
		private var counter:int;
		private var cost:int;
		
		public function Tower(tile:Point, data:XML)
		{
			super();
			
			this.deployPoint = tile;
			this.towerType = data.@name;
			this.shootRate = data.@shootRate;
			this.cost = data.@cost;
			this.maxFramePerAnim = data.@framePerAnim;
			
			this.x = deployPoint.x + R.tileWidth / 2;
			this.y = deployPoint.y + R.tileHeight / 2;
		}
		
		protected override function Init(e:Event):void
		{
			super.Init(e);
			
			if(!collitionArea) collitionArea = new Sprite();
			collitionArea.x = (this.x - (R.tileWidth / 2)) - R.tileWidth;
			collitionArea.y = (this.y - (R.tileHeight / 2)) -  R.tileHeight;
			collitionArea.graphics.beginFill(0xFFFFFF);
			collitionArea.graphics.drawRect(0, 0, R.tileWidth * 3, R.tileHeight * 3);
			collitionArea.visible = false;
			Stage_1.gameObjContainer.addChild(collitionArea);
			
			switch(towerType)
			{
				case "cura":
					SpriteSheet = new Engine_SpriteSheet(R.BM_Cura, false, R.tileWidth, R.tileHeight * 2);
					break;
					
				case "perrero":
					SpriteSheet = new Engine_SpriteSheet(R.BM_Perrero, false, R.tileWidth, R.tileHeight * 2);
					break;
				
				case "piromano":
					SpriteSheet = new Engine_SpriteSheet(R.BM_Piromano, false, R.tileWidth, R.tileHeight * 2);
					break;
			}
			
			SpriteSheet.x = deployPoint.x;
			SpriteSheet.y = deployPoint.y - R.tileHeight;
			Stage_1.gameObjContainer.addChild(SpriteSheet);
			currentAnimTile = 0;
		}
		
		protected override function Clear(e:Event):void
		{
			super.Clear(e);
			
			Stage_1.gameObjContainer.removeChild(collitionArea);
			Stage_1.gameObjContainer.removeChild(SpriteSheet);
			
			SpriteSheet = null;		
			collitionArea = null;
			nearestEnemy = null;
			towerType = null;
		}
		
		public override function Draw():void { SpriteSheet.drawTile(currentAnimTile); }
		
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
				this.scaleX = -1;
			}
			else if(this.rotation < -45 && this.rotation >= -135) //Aim Up
			{
				aimDirection.x = 0;
				aimDirection.y = -1;
				
				currentAnimTile = maxFramePerAnim * 2;
				this.scaleX = 1;
			}
			else if((this.rotation < -135 && this.rotation >= -180) || (this.rotation > 0 && this.rotation <= 45)) //Aim Right
			{
				aimDirection.x = 1;
				aimDirection.y = 0;
				
				currentAnimTile = 0;
				this.scaleX = 1;
			}
			else if(this.rotation > 45 && this.rotation >= 135) //Aim Down
			{
				aimDirection.x = 0;
				aimDirection.y = 1;
				
				currentAnimTile = maxFramePerAnim;
				this.scaleX = 1;
			}
		}
		
		protected override function UpdateAnim():void
		{
			if(aimDirection.x == 1 && aimDirection.y == 0) // Right
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
		
		private function Shoot():void
		{
			if(nearestEnemy)
			{
				counter += Main.mainStage.frameRate * shootRate / 1000;
				
				if(counter >= shootRate)
				{
					var bullet:Bullet = new Bullet(this.x, this.y, this.rotation);
					Stage_1.gameObjContainer.addChild(bullet);
					Stage_1.bullets.push(bullet);
					counter = 0;
				}
			}
		}
		
		public function get BuildCost():int { return cost; }
	}
}