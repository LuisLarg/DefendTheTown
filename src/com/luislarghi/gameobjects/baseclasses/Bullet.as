package com.luislarghi.gameobjects.baseclasses
{
	import com.luislarghi.Game;
	import com.luislarghi.R;
	import com.luislarghi.myfirtsengine.Engine_Game;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Bullet extends Character
	{
		private var speed:Number = 10;
		private var dead:Boolean = false;
		private var damage:int = 1;
		
		public var collitionBox:Sprite;
		private var rot:Number;
		
		protected var minAnimFrame:int = 0;
		private var maxAnimFrame:int = 40;
		
		function Bullet(posX:int, posY:int, rot:Number)
		{
			this.x = posX;
			this.y = posY;
			this.rot = rot;
		}
		
		public override function Init():void
		{
			super.Init();
			
			this.addChild(SpriteSheet);
			SpriteSheet.x = -(R.tileWidth / 2);
			SpriteSheet.y = -(R.tileHeight * 2 / 2);
			
			collitionBox = new Sprite();
			this.addChild(collitionBox);
			collitionBox.graphics.beginFill(0x00FF00);
			collitionBox.graphics.drawRect(0, 0, 10, 10);
			collitionBox.visible = false;
		}
		
		public override function Clear():void
		{
			this.removeChild(collitionBox);
			this.removeChild(SpriteSheet);
			
			SpriteSheet = null;
			collitionBox = null;
		}
		
		public override function Logic():void
		{
			if(!dead)
			{
				Move();
				UpdateAnim();
				CheckIfDead();
			}
		}
		
		private function Move():void
		{
			this.x += speed * Math.cos(rot * (Math.PI / 180));
			this.y += speed * Math.sin(rot * (Math.PI / 180));
		}
		
		private function CheckIfDead():void
		{
			if(this.x < 0 || this.x > Engine_Game.orgGameRes.x ||
				this.y < 0 || this.y > Engine_Game.orgGameRes.y)
				dead = true;
		}
		
		protected override function UpdateAnim():void
		{
			currentAnimTile++;
			
			if(currentAnimTile < minAnimFrame || currentAnimTile > (minAnimFrame + maxAnimFrame)) 
				currentAnimTile = minAnimFrame;
		}

		public function get Dead():Boolean { return dead; }
		public function get Damage():int { return damage; }
	}
}