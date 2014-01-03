package com.luislarghi.gameobjects
{
	import com.luislarghi.R;
	import com.luislarghi.gamestates.Stage_1;
	import com.luislarghi.myfirtsengine.Engine_SpriteSheet;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Enemy extends Character
	{
		private var enemyType:String;
		private var speed:int;
		private var originalDirection:Point = new Point(1, 0);
		private var currentDirection:Point = new Point();
		private var originalLife:int;
		private var currentLife:int;
		private var points:int;
		private var money:int;
		private var maxFramePerRow:int;
		private var dead:Boolean = false;
		private var survivor:Boolean = false;
		private var active:Boolean = false;
		
		private var currentMP:Point;
		private var originalPivot:Point = new Point(0, R.tileHeight / 2);
		private var currentPivot:Point = new Point();
		
		private var spawnPoint:Point;
		private var deadPoint:Point = new Point(999, 999);
		
		function Enemy(data:XML)
		{
			super();
			
			this.enemyType = data.@name;
			this.speed = data.@speed;
			this.originalLife = data.@life;
			this.points = data.@points;
			this.money = data.@money;
			this.maxFramePerRow = data.@framesPerRow;
		}
		
		protected override function Init(e:Event):void 
		{
			super.Init(e);
			
			Revive();
			
			switch(enemyType)
			{
				case "vampire":
					SpriteSheet = new Engine_SpriteSheet(R.BM_Vampiro, false, 64, 91);
					break;
				
				case "mummy":
					SpriteSheet = new Engine_SpriteSheet(R.BM_Momia, false, 70, 72);
					break;
				
				case "zomby":
					SpriteSheet = new Engine_SpriteSheet(R.BM_Zomby, false, 57, 85);
					break;
			}
			
			this.addChild(SpriteSheet);
			currentAnimTile = (maxFramePerRow * 2) - 1;
		}
		
		protected override function Clear(e:Event):void 
		{ 
			super.Clear(e);
			
			this.removeChild(SpriteSheet);
			
			SpriteSheet = null;
			enemyType = null;
		}
		
		public override function Draw():void { SpriteSheet.drawTile(currentAnimTile); }
		
		public override function Logic():void
		{
			if(!dead && active)
			{
				this.x += speed * currentDirection.x;
				this.y += speed * currentDirection.y;
				
				CheckDirection();
				UpdateAnim();
			}
		}
		
		protected override function UpdateAnim():void
		{
			if(currentDirection.x == 1 && currentDirection.y == 0) // Right
			{
				currentAnimTile++;
				
				if(currentAnimTile > (maxFramePerRow * 3) - 3) currentAnimTile = (maxFramePerRow * 2) - 1;
			}
			else if(currentDirection.x == 0 && currentDirection.y == 1) //Down
			{
				currentAnimTile++;
				
				if(currentAnimTile > (maxFramePerRow * 2) - 2) currentAnimTile = maxFramePerRow;
			}
			else if(currentDirection.x == -1 && currentDirection.y == 0) //Left
			{
				currentAnimTile++;
				
				if(currentAnimTile > (maxFramePerRow * 3) - 3) currentAnimTile = (maxFramePerRow * 2) - 1;
			}
			else if(currentDirection.x == 0 && currentDirection.y == -1) //Up
			{
				currentAnimTile++;
				
				if(currentAnimTile > maxFramePerRow - 1) currentAnimTile = 0;
			}
		}
		
		private function CheckDirection():void
		{
			currentMP = R.ScreenToMap(localToGlobal(currentPivot));
			
			switch(R.map[currentMP.y][currentMP.x])
			{
				case 1: // Right
					currentDirection.x = 1;
					currentDirection.y = 0;
					currentPivot.x = 0;
					currentPivot.y = R.tileHeight / 2;
					currentAnimTile = (maxFramePerRow * 2) - 1;
					break;
					
				case 2: // Down
					currentDirection.x = 0;
					currentDirection.y = 1;
					currentPivot.x = R.tileWidth / 2;
					currentPivot.y = 0;
					currentAnimTile = maxFramePerRow;
					break;
					
				case 3: //Left
					currentDirection.x = -1;
					currentDirection.y = 0;
					currentPivot.x = R.tileWidth;
					currentPivot.y = R.tileHeight / 2;
					currentAnimTile = (maxFramePerRow * 2) - 1;
					break;
					
				case 4: //Up
					currentDirection.x = 0;
					currentDirection.y = -1;
					currentPivot.x = R.tileWidth / 2;
					currentPivot.y = R.tileHeight;
					if(currentAnimTile > maxFramePerRow - 1) currentAnimTile = 0;
					break;
				
				case -2: //Destination Reached
					survivor = true;
					break;
			}
		}
		
		private function Revive():void
		{
			dead = false;
			this.x = deadPoint.x;
			this.y = deadPoint.y;
			currentPivot.x = originalPivot.x;
			currentPivot.y = originalPivot.y;
			currentDirection.x = originalDirection.x;
			currentDirection.y = originalDirection.y;
			currentLife = originalLife;
		}
		
		public function Kill():void 
		{ 
			dead = true;
			this.x = deadPoint.x;
			this.y = deadPoint.y;
		}
		
		public function Activate():void 
		{
			active = true;
			
			for(var row:int = 0; row < Stage_1.currentMap.length; row++)
			{
				for(var col:int = 0; col < Stage_1.currentMap[row].length; col++)
				{
					if(R.map[row][col] == -1)
					{
						spawnPoint = R.MapToScreen(col, row);
						break;
					}
				}
			}
			
			this.x = spawnPoint.x;
			this.y = spawnPoint.y;
		}
		
		public function Deactivate():void
		{
			active = false;
			Revive();
			survivor = false;
		}
		
		public function get Life():int { return currentLife; }
		public function Hit(damage:int):void { currentLife -= damage; }
		public function get PointsWorth():int { return points; }
		public function get MoneyDropped():int { return money; }
		public function get Dead():Boolean { return dead; }
		public function get Survivor():Boolean { return survivor; }
		public function get Active():Boolean { return active; }
	}
}