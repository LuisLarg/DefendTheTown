package com.luislarghi.gameobjects.baseclasses
{
	import com.luislarghi.R;
	import com.luislarghi.gamestates.Stage_1;
	import com.luislarghi.myfirtsengine.Engine_Game;
	import com.luislarghi.myfirtsengine.Engine_SpriteSheet;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	
	public class Character extends Sprite
	{
		protected var SpriteSheet:Engine_SpriteSheet;
		protected var currentAnimTile:int;

		public function Init():void { currentAnimTile = 0; }
		public function Clear():void { }
		protected function UpdateAnim():void {}
		public function Logic():void {}
		public function Draw():void { SpriteSheet.drawTile(currentAnimTile); }
	}
}