package com.luislarghi.gameobjects
{
	import com.luislarghi.R;
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
		
		public function Character()
		{
			this.scaleX = this.scaleY = Engine_Game.newScale;
			
			this.addEventListener(Event.ADDED_TO_STAGE, Init);
			this.addEventListener(Event.REMOVED_FROM_STAGE, Clear);
		}
		
		protected function Init(e:Event):void { this.removeEventListener(Event.ADDED_TO_STAGE, Init); }
		protected function Clear(e:Event):void { this.removeEventListener(Event.ADDED_TO_STAGE, Clear); }
		protected function UpdateAnim():void {}
		public function Logic():void {}
		public function Draw():void {}
	}
}