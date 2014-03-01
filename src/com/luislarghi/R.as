package com.luislarghi
{
	import com.luislarghi.gameobjects.Stats;
	import com.luislarghi.gameobjects.baseclasses.Enemy;
	import com.luislarghi.gameobjects.enemies.Mummy;
	import com.luislarghi.gameobjects.enemies.Vampire;
	import com.luislarghi.gameobjects.enemies.Zomby;
	import com.luislarghi.myfirtsengine.Engine_Game;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.system.Capabilities;

	public final class R
	{
		//External embeded sounds
		[Embed(source="sounds/DayofChaos.mp3")] public static const SNDFILE_BackGMusic:Class;
		[Embed(source="sounds/click.mp3")] public static const SNDFILE_Click:Class;
		[Embed(source="sounds/Dog.mp3")] public static const SNDFILE_DogB:Class;
		[Embed(source="sounds/GlintLight.mp3")] public static const SNDFILE_GlintL:Class;
		[Embed(source="sounds/Torch.mp3")] public static const SNDFILE_Torch:Class;
		[Embed(source="sounds/ZombyDeath.mp3")] public static const SNDFILE_ZombyD:Class;
		[Embed(source="sounds/MummyDeath.mp3")] public static const SNDFILE_MummyD:Class;
		[Embed(source="sounds/VampireDeath.mp3")] public static const SNDFILE_VampireD:Class;
		
		//External embeded images
		[Embed(source="images/map.png")] public static const BG_Map:Class;
		[Embed(source="images/map2.png")] public static const BG_Map2:Class;
		[Embed(source="images/map3.png")] public static const BG_Map3:Class;
		[Embed(source="images/Cura_SpriteSheet.png")] public static const SS_Cura:Class;
		[Embed(source="images/Perrero_SpriteSheet.png")] public static const SS_Perrero:Class;
		[Embed(source="images/Piromano_SpriteSheet.png")] public static const SS_Piromano:Class;
		[Embed(source="images/Momia_SpriteSheet.png")] public static const SS_Momia:Class;
		[Embed(source="images/Vampiro_SpriteSheet.png")] public static const SS_Vampiro:Class;
		[Embed(source="images/Zomby_SpriteSheet.png")] public static const SS_Zomby:Class;		
		[Embed(source="images/thumnails.png")] public static const SS_HUD:Class;
		[Embed(source="images/boton.png")] public static const SS_Button:Class;
		[Embed(source="images/mainmenu.png")] public static const BG_MainMenu:Class;

		//Map tile size
		public static const tileHeight:int = 64;
		public static const tileWidth:int = 64;
		
		//Tower build modes
		public static const NULLMODE:int = -1;
		public static const PIROMODE:int = -2;
		public static const PERROMODE:int = -3;
		public static const CURAMODE:int = -4;
		
		//Map grid arrays
		public static const map:Array = new Array([ -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3],
 												  [ -3, -3,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0],
												  [ -1,  1,  1,  1,  1,  1,  1,  2,  0,  1,  1,  1,  2,  0,  1,  1,  1,  1,  2,  0],
												  [ -3,  0,  0,  0,  0,  0,  0,  2,  0,  4,  0,  0,  2, -3,  4,  0,  0,  0,  2,  0],
												  [  0,  2,  3,  3,  3,  3,  3,  3,  0,  4,  0,  0,  2,  0,  4,  0, -3,  0,  2,  0],
												  [  0,  2,  0,  0,  0,  0,  0,  0, -3,  4,  0,  0,  2,  0,  4,  0,  0,  0,  2,  0],
												  [  0,  1,  1,  2,  0,  1,  1,  2,  0,  4,  0,  0,  2,  0,  4,  0,  2,  3,  3,  0],
												  [  0,  0,  0,  2,  0,  4,  0,  2,  0,  4,  0,  0,  1,  1,  4,  0,  2,  0,  0, -3],
												  [  0, -3,  0,  1,  1,  4,  0,  1,  1,  4,  0, -3,  0,  0,  0,  0,  1,  1,  1, -2],
												  [  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, -3, -3],
												  [ -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3],
												  [ -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3]);
		
		public static const map2:Array = new Array([ -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3],
												   [ -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3],
												   [ -3, -3,  0, -3,  0, -3,  0, -3, -3, -3,  0,  0,  0, -3, -3,  0, -3,  1,  1, -2],
												   [ -3, -3, -3,  1,  1,  1,  1,  1,  1,  2, -3,  1,  2, -3,  0,  0,  0,  4, -3, -3],
												   [ -3, -3,  0,  4,  0,  0,  0, -3,  0,  2,  0,  4,  2,  0,  1,  1,  1,  4, -3, -3],
												   [ -3, -3,  0,  4,  0,  2,  3,  3,  3,  3,  0,  4,  2,  0,  4,  0,  0, -3, -3, -3],
												   [ -3, -3,  0,  4, -3,  2,  0,  0,  0,  0, -3,  4,  2,  0,  4,  3,  3,  0, -3, -3],
												   [ -3, -3,  0,  4,  0,  2,  0,  0,  0,  0, -3,  4,  2,  0, -3, -3,  4,  0, -3, -3],
												   [ -3, -3,  0,  4,  0,  1,  1,  1,  1,  1,  1,  4,  1,  1,  1,  1,  4,  0, -3, -3],
												   [ -1,  1,  1,  4, -3,  0, -3,  0,  0, -3,  0, -3, -3, -3,  0,  0,  0,  0, -3, -3],
												   [ -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3],
												   [ -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3]);
		
		public static const map3:Array = new Array([ -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3],
											       [ -3, -3,  1,  1,  1,  2, -3,  1,  1,  1,  1,  2,  0,  1,  1,  2, -3, -3, -3, -3],
												   [ -3, -3,  4, -3,  0,  2,  0,  4, -3,  0,  0,  2,  0,  4,  0,  2, -3, -3, -3, -2],
												   [ -3, -3,  4,  0,  0,  2, -3,  4,  0, -3,  0,  1,  1,  4,  0,  1,  2, -3, -3, -3],
												   [ -3, -3,  4,  0, -3,  2,  0,  4,  3,  3,  3,  0,  1,  1,  2,  0,  2, -3, -3, -3],
												   [ -3, -3,  4, -3,  0,  2,  0, -3,  0,  0,  4,  0,  4,  0,  2,  0,  1,  1,  1, -2],
												   [ -1,  1, -4,  0,  0,  1,  1,  1,  1,  1, -5,  1,  4, -3,  1,  1,  4, -3, -3, -3],
												   [ -3, -3,  2,  0, -3,  0,  1,  1,  2,  1,  2,  0,  1,  2,  0,  1,  4, -3, -3, -3],
												   [ -3, -3,  2,  0,  0,  0,  4,  0,  2,  4,  2, -3,  4,  2,  0,  4,  0, -3, -3, -3],
												   [ -3, -3,  2,  0,  0, -3,  4,  0,  2,  4,  2,  0,  4,  2,  0,  4,  0, -3, -3, -3],
												   [ -3, -3,  1,  1,  1,  1,  4, -3,  1,  4,  1,  1,  4,  1,  1,  4, -3, -3, -3, -3],
												   [ -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3]);
		
		//Helper functions
		public static function ScreenToMap(screen:Point):Point
		{
			return new Point(int(screen.x / (tileWidth * Engine_Game.newScaleX)), int(screen.y / (tileHeight * Engine_Game.newScaleY)));
		}
		
		public static function MapToScreen(col:int, row:int):Point
		{
			return new Point(col * tileWidth, row * tileHeight);
		}
		
		public static function CopyMultiDArray(arrayToCopy:Array):Array
		{
			var tmpArray:Array = new Array();
			for (var i:int = 0; i < arrayToCopy.length; i++) tmpArray[i] = arrayToCopy[i].slice();
			return tmpArray;
		}
		
		public static function RandomBetween(min:Number, max:Number, exclusively:Boolean = false):Number
		{
			if(exclusively)
			{
				var randValue:int = int(RandomBetween(0, 1));
				
				if(randValue) return min;
				else return max;
			}
			else return Math.floor(Math.random() * (1 + max - min) + min);
		}
		
		public static function isAndroid():Boolean { return (Capabilities.manufacturer.indexOf("Android") != -1); }
		public static function isIOS():Boolean { return (Capabilities.manufacturer.indexOf("IOS") != -1); }
	}
}