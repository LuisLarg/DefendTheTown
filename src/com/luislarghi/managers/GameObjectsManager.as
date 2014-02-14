package com.luislarghi.managers
{
	import com.luislarghi.gameobjects.Stats;
	import com.luislarghi.gameobjects.baseclasses.Enemy;
	import com.luislarghi.gameobjects.enemies.Mummy;
	import com.luislarghi.gameobjects.enemies.Vampire;
	import com.luislarghi.gameobjects.enemies.Zomby;
	import com.luislarghi.gamestates.Stage_1;
	
	import flash.display.Sprite;

	public final class GameObjectsManager
	{
		private static var biggestEnemyCant:int = 0;
		
		private static function FindBiggestWave():void
		{
			for (var i:int = 0; i < XmlManager.levelWaves.level.length(); i++) 
			{
				for (var j:int = 0; j < XmlManager.levelWaves.level[i].wave.length(); j++) 
				{
					if(XmlManager.levelWaves.level[i].wave[j].@enemiesCant > biggestEnemyCant)
						biggestEnemyCant = XmlManager.levelWaves.level[i].wave[j].@enemiesCant;
				}
			}
		}
		
		public static function CreateWave(waves:Vector.<Enemy>, stage:Stage_1):void
		{
			var enemy:Enemy;
			var enemyCounter:int = 0;
			
			Stats.maxLevelCant = XmlManager.levelWaves.length();
			
			FindBiggestWave();
			
			for (var j:int = 0; j < biggestEnemyCant; j++) 
			{
				if(enemyCounter > 2) enemyCounter = 0;
				
				if(enemyCounter == 0) enemy = new Zomby(XmlManager.enemyTypes.enemy[enemyCounter]);
				else if(enemyCounter == 1) enemy = new Mummy(XmlManager.enemyTypes.enemy[enemyCounter]);
				else if(enemyCounter == 2) enemy = new Vampire(XmlManager.enemyTypes.enemy[enemyCounter]);
				
				waves.push(enemy);
				enemyCounter++;
			}
			
		}
		
		public static function CheckForNextWave(waves:Vector.<Enemy>):Boolean
		{
			// Check for at least one active enemy
			for(var i:int = 0; i < waves.length; i++)
			{
				if(waves[i].Active) return false;
			}
	
			return true;
		}
		
		public static function ResetWaves(waves:Vector.<Enemy>):void
		{
			for(var row:int = 0; row < waves.length; row++) 
				waves[row].Deactivate();
		}
		
		public static function SpriteDepthBubbleSort(container:Sprite):void
		{
			for (var i:int = 0; i < container.numChildren-1; i++) 
			{
				for (var j:int = i+1; j < container.numChildren; j++) 
				{
					if(container.getChildAt(i).y > container.getChildAt(j).y)
						container.swapChildrenAt(i, j);
				}
			}		
		}
	}
}