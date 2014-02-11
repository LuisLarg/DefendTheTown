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
		public static function CreateWave(waves:Vector.<Vector.<Enemy>>, stage:Stage_1):void
		{
			var waveCounter:int = 0;
			var enemy:Enemy;
			var enemyCounter:int = 0;
			
			for (var w:int = 0; w < Stats.maxWaveCant; w++) 
			{
				waves[waveCounter] = new Vector.<Enemy>;
				
				for (var i:int = 0; i < XmlManager.waveEnemies.wave.(@id==String(waveCounter + 1)).enemy.length(); i++) 
				{
					if(XmlManager.waveEnemies.wave.(@id==String(waveCounter + 1)).enemy[enemyCounter].@name == "zomby")
						enemy = new Zomby(XmlManager.waveEnemies.wave.(@id==String(waveCounter + 1)).enemy[enemyCounter]);
					else if(XmlManager.waveEnemies.wave.(@id==String(waveCounter + 1)).enemy[enemyCounter].@name == "mummy")
						enemy = new Mummy(XmlManager.waveEnemies.wave.(@id==String(waveCounter + 1)).enemy[enemyCounter]);
					else if(XmlManager.waveEnemies.wave.(@id==String(waveCounter + 1)).enemy[enemyCounter].@name == "vampire")
						enemy = new Vampire(XmlManager.waveEnemies.wave.(@id==String(waveCounter + 1)).enemy[enemyCounter]);
					
					waves[waveCounter].push(enemy);
					enemyCounter++;
				}

				waveCounter++;
				enemyCounter = 0;
			}
		}
		
		public static function CheckForNextWave(waves:Vector.<Vector.<Enemy>>):Boolean
		{
			// Check all active enemies in the current wave
			for(var i:int = 0; i < waves[Stats.currentWave].length; i++)
				// if at least one enemy is not dead...
				if(!waves[Stats.currentWave][i].Dead) return false;
	
			return true;
		}
		
		public static function ResetWaves(waves:Vector.<Vector.<Enemy>>):void
		{
			for(var row:int = 0; row < waves.length; row++) 
			{
				for (var col:int = 0; col < waves[row].length; col++) 
				{
					waves[row][col].Deactivate();
				}
			}
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