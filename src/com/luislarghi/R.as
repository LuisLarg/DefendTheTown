package com.luislarghi
{
	import com.luislarghi.gameobjects.Enemy;
	import com.luislarghi.gameobjects.Stats;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.utils.ByteArray;

	public final class R
	{
		//External embeded sounds
		[Embed(source="sounds/DayofChaos.mp3")] private static const SNDFILE_BackGMusic:Class;
		[Embed(source="sounds/click.mp3")] private static const SNDFILE_Click:Class;
		
		//Instances of each sound
		public static var SND_Music:Sound = new SNDFILE_BackGMusic();
		public static var SND_Click:Sound = new SNDFILE_Click();
		
		//External embeded images
		[Embed(source="images/map.png")] private static const BG_Map:Class;
		[Embed(source="images/cura.png")] private static const SS_Cura:Class;
		[Embed(source="images/perrero.png")] private static const SS_Perrero:Class;
		[Embed(source="images/piromano.png")] private static const SS_Piromano:Class;
		[Embed(source="images/momia.png")] private static const SS_Momia:Class;
		[Embed(source="images/vampiro.png")] private static const SS_Vampiro:Class;
		[Embed(source="images/zomby.png")] private static const SS_Zomby:Class;		
		[Embed(source="images/thumnails.png")] private static const SS_HUD:Class;
		[Embed(source="images/boton.png")] private static const SS_Button:Class;
		[Embed(source="images/mainmenu.png")] private static const BG_MainMenu:Class;
		
		//Instances of each image
		public static var BM_Map:Bitmap = new BG_Map();
		public static var BM_MainMenu:Bitmap = new BG_MainMenu();
		public static var BM_Cura:Bitmap = new SS_Cura();
		public static var BM_Perrero:Bitmap = new SS_Perrero();
		public static var BM_Piromano:Bitmap = new SS_Piromano();
		public static var BM_Vampiro:Bitmap = new SS_Vampiro();
		public static var BM_Momia:Bitmap = new SS_Momia();
		public static var BM_Zomby:Bitmap = new SS_Zomby();
		public static var BM_HUD:Bitmap = new SS_HUD();
		public static var BM_Button:Bitmap = new SS_Button();

		//Map tile size
		public static const tileHeight:int = 64;
		public static const tileWidth:int = 64;
		
		//Tower build modes
		public static const CURAMODE:int = -1;
		public static const PIROMODE:int = -2;
		public static const PERROMODE:int = -3;
		public static const NULLMODE:int = 0;
		
		//Map grid array
		public static const map:Array = new Array([-3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3],
 												  [-3, -3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
												  [-1, 1, 1, 1, 1, 1, 1, 2, 0, 1, 1, 1, 2, 0, 1, 1, 1, 1, 2, 0],
												  [-3, 0, 0, 0, 0, 0, 0, 2, 0, 4, 0, 0, 2, -3, 4, 0, 0, 0, 2, 0],
												  [0, 2, 3, 3, 3, 3, 3, 3, 0, 4, 0, 0, 2, 0, 4, 0, -3, 0, 2, 0],
												  [0, 2, 0, 0, 0, 0, 0, 0, -3, 4, 0, 0, 2, 0, 4, 0, 0, 0, 2, 0],
												  [0, 1, 1, 2, 0, 1, 1, 2, 0, 4, 0, 0, 2, 0, 4, 0, 2, 3, 3, 0],
												  [0, 0, 0, 2, 0, 4, 0, 2, 0, 4, 0, 0, 1, 1, 4, 0, 2, 0, 0, -3],
												  [0, -3, 0, 1, 1, 4, 0, 1, 1, 4, 0, -3, 0, 0, 0, 0, 1, 1, 1, -2],
												  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -3, -3],
												  [-3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3],
												  [-3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3, -3]);
		
		//Helper functions
		public static function ScreenToMap(screen:Point):Point
		{
			return new Point(int(screen.x / tileWidth), int(screen.y / tileHeight));
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
		
		private static var fileStream:FileStream;
		private static var bytes:ByteArray;
		private static var content:String = "";
		public static var xmlReady:Boolean = false;
		public static var xmlData:XML;
		public static var waveEnemies:XMLList;
		public static var towerTypes:XMLList;
		public static var waves:Vector.<Vector.<Enemy>> = new Vector.<Vector.<Enemy>>;
		
		public static function LoadXML():void
		{		
			var file:File = File.applicationDirectory.resolvePath("data.xml");
			fileStream = new FileStream();
			fileStream.addEventListener(Event.COMPLETE, xmlLoadComplete);
			fileStream.openAsync(file, FileMode.READ);
		}
		
		private static function xmlLoadComplete(e:Event):void
		{		
			xmlData = XML(fileStream.readMultiByte(fileStream.bytesAvailable, "iso-8859-1"));
			fileStream.removeEventListener(Event.COMPLETE, xmlLoadComplete);
			xmlReady = true;
			fileStream.close();
			
			CreateWave();
		}
		
		private static function CreateWave():void
		{
			waveEnemies = R.xmlData.type.(@name=="waves").level.(@id=="1");
			towerTypes = R.xmlData.type.(@name=="towers");
			Stats.maxWaveCant = waveEnemies.wave.length();
			
			var waveCounter:int = 0;
			var enemy:Enemy;
			var enemyCounter:int = 0;
			for (var w:int = 0; w < Stats.maxWaveCant; w++) 
			{
				waves[waveCounter] = new Vector.<Enemy>;
				
				for (var i:int = 0; i < waveEnemies.wave.(@id==String(waveCounter + 1)).enemy.length(); i++) 
				{
					enemy = new Enemy(waveEnemies.wave.(@id==String(waveCounter + 1)).enemy[enemyCounter]);
					waves[waveCounter].push(enemy);
					
					enemyCounter++;
				}
				
				//trace(waves[waveCounter].length + " enemies in wave " + (waveCounter + 1));
				
				waveCounter++;
				enemyCounter = 0;
			}
		}
		
		public static function ResetWaves():void
		{
			for(var row:int = 0; row < waves.length; row++) 
			{
				for (var col:int = 0; col < waves[row].length; col++) 
				{
					waves[row][col].Deactivate();
				}
			}
		}
	}
}