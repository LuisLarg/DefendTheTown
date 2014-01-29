package com.luislarghi.managers
{
	import com.luislarghi.gameobjects.Stats;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public final class XmlManager
	{
		private static var fileStream:FileStream;
		private static var bytes:ByteArray;
		private static var content:String = "";
		public static var xmlReady:Boolean = false;
		public static var xmlData:XML;
		public static var waveEnemies:XMLList;
		public static var towerTypes:XMLList;
		
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
			
			waveEnemies = xmlData.type.(@name=="waves").level.(@id=="1");
			towerTypes = xmlData.type.(@name=="towers");
			Stats.maxWaveCant = waveEnemies.wave.length();
			
			xmlReady = true;
			fileStream.close();
		}
	}
}