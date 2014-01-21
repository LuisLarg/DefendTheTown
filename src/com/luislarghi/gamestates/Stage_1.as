package com.luislarghi.gamestates
{
	import com.luislarghi.Game;
	import com.luislarghi.R;
	import com.luislarghi.gameobjects.Bullet;
	import com.luislarghi.gameobjects.Enemy;
	import com.luislarghi.gameobjects.Stats;
	import com.luislarghi.gameobjects.Tower;
	import com.luislarghi.gui.GUI_Button;
	import com.luislarghi.gui.GUI_Stage1;
	import com.luislarghi.myfirtsengine.Engine_Game;
	import com.luislarghi.myfirtsengine.Engine_GameState;
	import com.luislarghi.myfirtsengine.Engine_SpriteSheet;
	import com.luislarghi.myfirtsengine.Engine_States;
	
	import flash.desktop.NativeApplication;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	public class Stage_1 extends Engine_GameState
	{
		private var currentBGimg:Engine_SpriteSheet;
		public static var currentMap:Array;
		
		private var keysMapper:Array;

		public static var currentBuildMode:int = R.NULLMODE;
		private static var towers:Vector.<Tower> = new Vector.<Tower>;
		public static var bullets:Vector.<Bullet> = new Vector.<Bullet>;
		
		private var enemySpanwRate:int = 2000;
		private var counter:int = 0;
		private var GUI_component:GUI_Stage1;
		
		public static var gameObjContainer:Sprite;
		public static var guiContainer:Sprite;
		
		public function Stage_1(g:Game) { super(Main.mainStage, g); }
		
		protected override function Init(e:Event):void
		{
			super.Init(e);
			
			Stats.Reset();
			
			ChangeLevel();
			
			this.addChild(currentBGimg);
			
			if(!gameObjContainer) gameObjContainer = new Sprite();
			if(!guiContainer) guiContainer = new Sprite();
			
			this.addChild(gameObjContainer);
			this.addChild(guiContainer);
			
			for(var row:int = 0; row < R.waves.length; row++) 
			{
				for (var col:int = 0; col < R.waves[row].length; col++) 
				{
					gameObjContainer.addChild(R.waves[row][col]);
				}
			}
			
			if(Capabilities.cpuArchitecture == "ARM")
			{
				if(Capabilities.manufacturer.indexOf("Android") != -1)
				{
					NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, OnDeactivate, false, 0, true);
					NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, SoftKeyDown);
				}
			}
			else
			{
				if(!keysMapper) keysMapper = new Array();
				
				mainStage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDown);
				mainStage.addEventListener(KeyboardEvent.KEY_UP, KeyUp);
			}
			
			mainStage.addEventListener(MouseEvent.CLICK, CheckClick);

			if(!GUI_component) GUI_component = new GUI_Stage1(mainGame);
			GUI_component.Init();
			
			trace("In Game: "+mainStage.stageWidth+", "+mainStage.stageHeight+" | Game resolution: "+Engine_Game.orgGameRes);
			//trace("You are INGAME");
		}
		
		protected override function Clear(e:Event):void
		{
			super.Clear(e);
			
			R.ResetWaves();
			
			this.removeChild(currentBGimg);
			currentBGimg = null;
			currentMap = null;
			
			for(var t:int = 0; t < towers.length; t++) gameObjContainer.removeChild(towers[t]);
			for(var b:int = 0; b < bullets.length; b++) gameObjContainer.removeChild(bullets[b]);
			for(var row:int = 0; row < R.waves.length; row++) 
			{
				for (var col:int = 0; col < R.waves[row].length; col++) 
				{
					gameObjContainer.removeChild(R.waves[row][col]);
				}
			}
			
			this.removeChild(gameObjContainer);
			this.removeChild(guiContainer);
			
			towers.length = bullets.length = 0;
			
			if(Capabilities.cpuArchitecture == "ARM")
			{
				if(Capabilities.manufacturer.indexOf("Android") != -1)
				{
					NativeApplication.nativeApplication.removeEventListener(KeyboardEvent.KEY_DOWN, SoftKeyDown);
				}
			}
			else
			{
				keysMapper = null;
				
				mainStage.removeEventListener(KeyboardEvent.KEY_DOWN, KeyDown);
				mainStage.removeEventListener(KeyboardEvent.KEY_UP, KeyUp);
			}
			
			mainStage.removeEventListener(MouseEvent.CLICK, CheckClick);
			
			GUI_component.Clear();
			GUI_component = null;
		}
		
		protected override function Draw():void
		{
			if(!pause && R.xmlReady && !gameOver)
			{
				for(var t:int = 0; t < towers.length; t++) towers[t].Draw();
				for(var b:int = 0; b < bullets.length; b++) bullets[b].Draw();
				for(var w:int = 0; w < R.waves[Stats.currentWave].length; w++) R.waves[Stats.currentWave][w].Draw();
			}
			
			GUI_component.Draw();
			
			//trace("Towers = " + towers.length + " | Bullets = " + bullets.length + " | Enemies = " + enemies.length + " | Tiles = " + tiles.length);
			//trace("Money = " + Stats.Money + " | Score = " + Stats.Score);
		}
		
		public override function Logic():void
		{
			if(!pause && R.xmlReady &&!gameOver)
			{	
				CheckForDeadBullets();
	
				SpawnEnemy();
				
				for(var t:int = 0; t < towers.length; t++) towers[t].Logic();
				for(var b:int = 0; b < bullets.length; b++) bullets[b].Logic();
				for(var w:int = 0; w < R.waves[Stats.currentWave].length; w++) R.waves[Stats.currentWave][w].Logic();
				
				CheckForBulletsCollition();
				CheckForTownAttack();
				
				if(CheckForNextWave())
				{
					if(Stats.currentWave < Stats.maxWaveCant - 1)
					{
						Stats.currentWave++;
					}
					else
						gameOver = true;
				}
			}
			
			GUI_component.Logic();
			
			trace("Build mode=" + currentBuildMode);
		}
		
		private function CheckForNextWave():Boolean
		{
			for(var i:int = 0; i < R.waves[Stats.currentWave].length; i++)
			{
				if(!R.waves[Stats.currentWave][i].Dead)
				{
					return false;
				}
			}

			return true;
		}
		
		private function CheckForTownAttack():void
		{
			for(var i:int = 0; i < R.waves[Stats.currentWave].length; i++)
			{
				if(R.waves[Stats.currentWave][i].Survivor && !R.waves[Stats.currentWave][i].Dead && R.waves[Stats.currentWave][i].Active)
				{
					R.waves[Stats.currentWave][i].Kill();
					Stats.townHealth -= 1;
				}
			}
			
			if(Stats.townHealth <= 0) gameOver = true;
		}
		
		private function SpawnEnemy():void
		{
			counter += mainStage.frameRate * enemySpanwRate / 1000;
			
			if(counter >= enemySpanwRate)
			{
				for (var i:int = 0; i <R.waves[Stats.currentWave].length; i++) 
				{
					if(!R.waves[Stats.currentWave][i].Active && !R.waves[Stats.currentWave][i].Survivor) 
					{
						R.waves[Stats.currentWave][i].Activate();
						break;
					}
				}
				
				counter = 0;
			}		
		}
		
		private function CheckForDeadBullets():void
		{
			for(var b:int = 0; b < bullets.length; b++)
			{
				if(bullets[b].Dead)
				{
					gameObjContainer.removeChild(bullets[b]);
					bullets.splice(b, 1);
					break;
				}
			}
		}
		
		private function CheckForBulletsCollition():void
		{
			for(var b:int = 0; b < bullets.length; b++)
			{
				for(var i:int = 0; i < R.waves[Stats.currentWave].length; i++)
				{
					if(bullets[b].hitTestObject(R.waves[Stats.currentWave][i]))
					{
						R.waves[Stats.currentWave][i].Hit(bullets[b].Damage);
						
						gameObjContainer.removeChild(bullets[b]);
						bullets.splice(b, 1);
						
						if(R.waves[Stats.currentWave][i].Life <= 0)
						{
							Stats.score += R.waves[Stats.currentWave][i].PointsWorth;
							Stats.money += R.waves[Stats.currentWave][i].MoneyDropped;
							R.waves[Stats.currentWave][i].Kill();
						}
						
						break;
					}
				}
			}
		}
		
		private function ChangeLevel():void
		{
			switch(Stats.currentStage)
			{
				case 1:
					currentBGimg = new Engine_SpriteSheet(R.BM_Map, false, 1280, 768);
					currentBGimg.drawTile(0);
					currentMap = new Array();
					currentMap = R.CopyMultiDArray(R.map);
					break;
				
				case 2:
					currentBGimg = new Engine_SpriteSheet(R.BM_Map, false, 1280, 768);
					currentBGimg.drawTile(0);
					currentMap = new Array();
					currentMap = R.CopyMultiDArray(R.map);
					break;
				
				case 3:
					currentBGimg = new Engine_SpriteSheet(R.BM_Map, false, 1280, 768);
					currentBGimg.drawTile(0);
					currentMap = new Array();
					currentMap = R.CopyMultiDArray(R.map);
					break;
			}
			
			Stats.currentStage++;
			Stats.currentWave = 0;
			R.ResetWaves();
			ResetObjects();
			gameOver = false;
		}
		
		private function ResetObjects():void
		{
			for(var t:int = 0; t < towers.length; t++) gameObjContainer.removeChild(towers[t]);
			for(var b:int = 0; b < bullets.length; b++) gameObjContainer.removeChild(bullets[b]);
			
			towers.length = bullets.length = 0;
		}
		
		private function CheckClick(e:MouseEvent):void
		{
			// If the game is not paused or finnished
			if(!pause && !gameOver)
			{
				// and if the position clicked is not a non-HUD Button Object
				if(!(e.target.parent is GUI_Button) && currentBuildMode != R.NULLMODE)
				{
					var clickPoint:Point = R.ScreenToMap(new Point(e.stageX, e.stageY));
					
					// check first if the position clicked is buildable
					if(currentMap[clickPoint.y][clickPoint.x] == 0)
					{
						var towerType:int = 0;
						
						if(currentBuildMode == R.PIROMODE) towerType = 0;
						else if(currentBuildMode == R.PERROMODE) towerType = 1;
						else if(currentBuildMode == R.CURAMODE) towerType = 2;
						
						//then create the tower object in that position, updating the game stats as wells
						var tmpTower:Tower = new Tower(R.MapToScreen(clickPoint.x, clickPoint.y), R.towerTypes.tower[towerType]);
						
						if(Stats.money >= tmpTower.BuildCost)
						{
							gameObjContainer.addChild(tmpTower);
							towers.push(tmpTower);
							
							Stats.money -= tmpTower.BuildCost;
							
							currentMap[clickPoint.y][clickPoint.x] = -3;
							
							currentBuildMode = R.NULLMODE;
						}
					}
				}
			}
		}
		
		private function SoftKeyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case Keyboard.BACK:
					e.preventDefault();
					pause = !pause;
					break;
					
				case Keyboard.MENU:
					e.preventDefault();
					break;
				
				case Keyboard.SEARCH:
					e.preventDefault();
					break;
			}
		}
		
		private function KeyDown(e:KeyboardEvent):void { keysMapper[e.keyCode] = true; }
		private function KeyUp(e:KeyboardEvent):void
		{
			keysMapper[e.keyCode] = false;
			
			if(e.keyCode == Keyboard.L || e.keyCode == Keyboard.BACK)
			{
				pause = !pause;
			}
			else if(e.keyCode == Keyboard.BACKSPACE)
			{
				if(pause) mainGame.SetNextState(Engine_States.STATE_MAINMENU);
			}
		}
		
		private function OnDeactivate(e:Event):void { pause = true; }		
		public static function GetPause():Boolean { return pause; }
		public static function SetPause(v:Boolean):void { pause = v; }		
		public static function GetGameOver():Boolean { return gameOver; }
	}
}