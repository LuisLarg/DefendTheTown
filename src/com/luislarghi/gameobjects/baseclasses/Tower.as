package com.luislarghi.gameobjects.baseclasses
{
	import com.luislarghi.R;
	import com.luislarghi.gameobjects.Stats;
	import com.luislarghi.gamestates.Stage_1;
	import com.luislarghi.myfirtsengine.Engine_SpriteSheet;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Tower extends Character
	{
		protected var mainStage:Stage_1;
		
		private var collitionArea:Sprite;
		protected var aimSight:Sprite;
		
		protected var nearestEnemy:Enemy;
		private var aimDirection:Point;
		private var maxFramePerAnim:int;
		
		//protected var shootRate:int;
		protected var isAnimating:Boolean;
		//protected var counter:int;
		private var cost:int;
		
		public function Tower(tile:Point, data:XML, stage:Stage_1)
		{
			mainStage = stage;
			
			//this.shootRate = data.@shootRate;
			isAnimating = false;
			this.cost = data.@cost;
			this.maxFramePerAnim = data.@framePerAnim;
			
			this.x = tile.x;
			this.y = tile.y;
		}
		
		public override function Init():void
		{
			super.Init();
			
			aimDirection = new Point(0, 1);
			currentAnimTile = maxFramePerAnim;
			
			aimSight = new Sprite();
			aimSight.x = R.tileWidth / 2;
			aimSight.y = R.tileHeight / 2;
			this.addChild(aimSight);
			
			collitionArea = new Sprite();
			collitionArea.x = (aimSight.x - (R.tileWidth / 2)) - R.tileWidth;
			collitionArea.y = (aimSight.y - (R.tileHeight / 2)) -  R.tileHeight;
			collitionArea.graphics.beginFill(0xFFFFFF);
			collitionArea.graphics.drawRect(0, 0, R.tileWidth * 3, R.tileHeight * 3);
			collitionArea.graphics.endFill();
			collitionArea.visible = false;
			this.addChild(collitionArea);
		}
		
		public override function Clear():void
		{
			this.removeChild(collitionArea);
			this.removeChild(SpriteSheet);
			
			SpriteSheet = null;		
			collitionArea = null;
			nearestEnemy = null;
		}
	
		public override function Logic():void
		{
			NearestEnemy();
			Aim();
			UpdateAnim();
		}

		private function NearestEnemy():void
		{
			if(!nearestEnemy || !collitionArea.hitTestObject(nearestEnemy))
			{
				for(var i:int = 0; i < mainStage.waves.length; i++)
				{
					if(mainStage.waves[i].Active && collitionArea.hitTestObject(mainStage.waves[i]))
					{
						nearestEnemy = mainStage.waves[i];
						return;
					}
				}
				
				nearestEnemy = null;
			}
		}
		
		private function Aim():void
		{
			if(nearestEnemy)
			{
				aimSight.rotation = Math.atan2(nearestEnemy.y - this.y, nearestEnemy.x - this.x) * 180 / Math.PI;
			
				if(!isAnimating)
				{
					if((aimSight.rotation > 135 && aimSight.rotation <= 180) || (aimSight.rotation > -180 && aimSight.rotation <= -135)) //Aim Left
					{
						aimDirection.x = -1;
						aimDirection.y = 0;
						
						currentAnimTile = 0;
						SpriteSheet.scaleX = -1;
						SpriteSheet.x = R.tileWidth;
					}
					else if(aimSight.rotation > -135 && aimSight.rotation <= -45) //Aim Up
					{
						aimDirection.x = 0;
						aimDirection.y = -1;
						
						currentAnimTile = maxFramePerAnim * 2;
						SpriteSheet.scaleX = 1;
						SpriteSheet.x = 0;
					}
					else if((aimSight.rotation > -45 && aimSight.rotation <= 0) || (aimSight.rotation > 0 && aimSight.rotation <= 45)) //Aim Right
					{
						aimDirection.x = 1;
						aimDirection.y = 0;
						
						currentAnimTile = 0;
						SpriteSheet.scaleX = 1;
						SpriteSheet.x = 0;
					}
					else if(aimSight.rotation > 45 && aimSight.rotation <= 135) //Aim Down
					{
						aimDirection.x = 0;
						aimDirection.y = 1;
						
						currentAnimTile = maxFramePerAnim;
						SpriteSheet.scaleX = 1;
						SpriteSheet.x = 0;
					}
					
					Shoot();
					isAnimating = true;
				}
			}
		}
		
		protected override function UpdateAnim():void
		{
			if(isAnimating)
			{
				if(aimDirection.x == 1 && aimDirection.y == 0) //Right
				{
					currentAnimTile++;
					
					if(currentAnimTile > maxFramePerAnim - 1) 
					{
						currentAnimTile = 0;
						isAnimating = false;
					}
				}
				else if(aimDirection.x == 0 && aimDirection.y == 1) //Down
				{
					currentAnimTile++;
					
					if(currentAnimTile > (maxFramePerAnim * 2) - 1) 
					{
						currentAnimTile = maxFramePerAnim;
						isAnimating = false;
					}
				}
				else if(aimDirection.x == -1 && aimDirection.y == 0) //Left
				{
					currentAnimTile++;
						
					if(currentAnimTile > maxFramePerAnim - 1) 
					{
						currentAnimTile = 0;
						isAnimating = false;
					}
				}
				else if(aimDirection.x == 0 && aimDirection.y == -1) //Up
				{
					currentAnimTile++;
						
					if(currentAnimTile > (maxFramePerAnim * 3) - 1) 
					{
						currentAnimTile = maxFramePerAnim * 2;
						isAnimating = false;
					}
				}
			}
		}
		
		protected function Shoot():void { }
		
		public function get BuildCost():int { return cost; }
	}
}