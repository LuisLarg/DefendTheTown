package com.luislarghi.gameobjects.baseclasses
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
		private var speed:int;
		private var currentDirection:Point;
		private const deadPoint:Point = new Point(-999, -999);
		private var points:int;
		private var money:int;
		private var maxFramesPerAnim:int;
		private var survivor:Boolean;
		private var active:Boolean;
		
		private var lifeBar:Sprite;
		private var originalLife:int;
		private var currentLife:int;
		private var lifeBarScale:int;
		
		private var currentMP:Point;
		private var currentPivot:Point;
		private var multipleChoiceTile:Boolean;
		
		private var spawnPoint:Point;
		public var collitionBox:Sprite;
		
		private var directionChanged:Boolean;
		private var lastDir:int;
		
		function Enemy(data:XML)
		{
			this.speed = data.@speed;
			this.originalLife = data.@life;
			this.points = data.@points;
			this.money = data.@money;
			this.maxFramesPerAnim = data.@framePerAnim;
		}
		
		public override function Init():void 
		{
			super.Init();
			
			collitionBox = new Sprite();
			collitionBox.graphics.beginFill(0xFFFFFF);
			collitionBox.graphics.drawRect(R.tileWidth / 4, 0, R.tileWidth / 2, R.tileHeight);
			collitionBox.graphics.endFill();
			collitionBox.visible = false;
			this.addChild(collitionBox);
			
			lifeBar = new Sprite();
			this.addChild(lifeBar);
			
			Deactivate();
		}
		
		public override function Clear():void 
		{ 
			this.removeChild(SpriteSheet);
			this.removeChild(collitionBox);
			this.removeChild(lifeBar);
			
			lifeBar = null;
			collitionBox = null;
			SpriteSheet = null;
		}
		
		public override function Logic():void
		{
			if(active)
			{
				this.x += speed * currentDirection.x;
				this.y += speed * currentDirection.y;
				
				CheckDirection();
				UpdateAnim();
				
				lifeBarScale = R.tileWidth - (currentLife * R.tileWidth / originalLife);
			}
		}
		
		public override function Draw():void
		{
			if(active)
			{
				super.Draw();
				
				lifeBar.graphics.clear();
				lifeBar.graphics.beginFill(0xFF0000);
				lifeBar.graphics.drawRect(lifeBarScale, -(R.tileHeight / 2), R.tileWidth - lifeBarScale, R.tileHeight / 8);
				lifeBar.graphics.endFill();
			}
		}
		
		protected override function UpdateAnim():void
		{
			if(currentDirection.x == 1 && currentDirection.y == 0) // Right
			{
				currentAnimTile++;
				
				if(currentAnimTile > maxFramesPerAnim - 1) currentAnimTile = 0;
			}
			else if(currentDirection.x == 0 && currentDirection.y == 1) //Down
			{
				currentAnimTile++;
				
				if(currentAnimTile > (maxFramesPerAnim * 2) - 1) currentAnimTile = maxFramesPerAnim;
			}
			else if(currentDirection.x == -1 && currentDirection.y == 0) //Left
			{
				currentAnimTile++;
				
				if(currentAnimTile > maxFramesPerAnim - 1) currentAnimTile = 0;
			}
			else if(currentDirection.x == 0 && currentDirection.y == -1) //Up
			{
				currentAnimTile++;
				
				if(currentAnimTile > (maxFramesPerAnim * 3) - 1) currentAnimTile = maxFramesPerAnim * 2;
			}
		}
		
		private function CheckDirection():void
		{
			currentMP = R.ScreenToMap(localToGlobal(currentPivot));
			
			var newDir:int = Stage_1.currentMap[currentMP.y][currentMP.x];
			
			if(newDir == -4 && !multipleChoiceTile) 
			{
				newDir = int(R.RandomBetween(2, 4, true));
				multipleChoiceTile = true;
			}
			else if(newDir == -5 && !multipleChoiceTile)
			{
				newDir = int(R.RandomBetween(1, 4, true));
				multipleChoiceTile = true;
			}
			else if(newDir > -3) multipleChoiceTile = false;
			
			if(lastDir != newDir) directionChanged = true;
			else directionChanged = false;
			
			switch(newDir)
			{
				case 1: // Right
					currentDirection.x = 1;
					currentDirection.y = 0;
					currentPivot.x = 0;
					currentPivot.y = R.tileHeight / 2;
					SpriteSheet.scaleX = 1;
					SpriteSheet.x = 0;
					if(directionChanged) currentAnimTile = 0;
					break;
					
				case 2: // Down
					currentDirection.x = 0;
					currentDirection.y = 1;
					currentPivot.x = R.tileWidth / 2;
					currentPivot.y = 0;
					SpriteSheet.scaleX = 1;
					SpriteSheet.x = 0;
					if(directionChanged) currentAnimTile = maxFramesPerAnim;
					break;
					
				case 3: //Left
					currentDirection.x = -1;
					currentDirection.y = 0;
					currentPivot.x = R.tileWidth;
					currentPivot.y = R.tileHeight / 2;
					SpriteSheet.scaleX = -1;
					SpriteSheet.x = R.tileWidth;
					if(directionChanged) currentAnimTile = 0;
					break;
					
				case 4: //Up
					currentDirection.x = 0;
					currentDirection.y = -1;
					currentPivot.x = R.tileWidth / 2;
					currentPivot.y = R.tileHeight;
					SpriteSheet.scaleX = 1;
					SpriteSheet.x = 0;
					if(directionChanged) currentAnimTile = maxFramesPerAnim * 2;
					break;
				
				case -2: //Destination Reached
					survivor = true;
					break;
			}
			
			lastDir = newDir;
		}
		
		public function Activate():void 
		{
			active = true;
			
			for(var row:int = 0; row < Stage_1.currentMap.length; row++)
			{
				for(var col:int = 0; col < Stage_1.currentMap[row].length; col++)
				{
					if(Stage_1.currentMap[row][col] == -1)
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
			survivor = false;		
			multipleChoiceTile = false;
			directionChanged = false;
			lastDir = 1;
			
			this.x = deadPoint.x;
			this.y = deadPoint.y;
			currentPivot = new Point(0, R.tileHeight / 2);
			currentDirection = new Point(1, 0);
			currentLife = originalLife;
		}
		
		public function Hit(damage:int):void 
		{ 
			currentLife -= damage; 
			if(currentLife < 1) currentLife = 0; 
		}
		
		public function get Life():int { return currentLife; }
		public function get PointsWorth():int { return points; }
		public function get MoneyDropped():int { return money; }
		public function get Survivor():Boolean { return survivor; }
		public function get Active():Boolean { return active; }
	}
}