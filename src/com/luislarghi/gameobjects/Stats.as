package com.luislarghi.gameobjects
{
	public final class Stats
	{
		public static var score:int;
		public static var money:int;
		public static var townHealth:int;
		public static var currentWave:int;
		public static var currentLevel:int;
		public static var maxLevelCant:int;
		
		public static function Reset():void 
		{
			score = 0;
			money = 6;
			townHealth = 100;
			currentWave = 0;
			currentLevel = 0;
		}
	}
}