package com.luislarghi.managers
{
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
		public static var levelWaves:XMLList;
		public static var towerTypes:XMLList;
		public static var enemyTypes:XMLList;
		
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
			
			levelWaves = xmlData.type.(@name=="waves");
			towerTypes = xmlData.type.(@name=="towers");
			enemyTypes = xmlData.type.(@name=="enemies");
			
			xmlReady = true;
			fileStream.close();
		}
	}
}