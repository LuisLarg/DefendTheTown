package com.luislarghi.gamestates
{
	import com.luislarghi.Game;
	import com.luislarghi.R;
	import com.luislarghi.gameobjects.Stats;
	import com.luislarghi.gameobjects.baseclasses.Bullet;
	import com.luislarghi.gameobjects.baseclasses.Enemy;
	import com.luislarghi.gameobjects.baseclasses.Tower;
	import com.luislarghi.gameobjects.bullets.Dog;
	import com.luislarghi.gameobjects.bullets.GlintLight;
	import com.luislarghi.gameobjects.bullets.Torch;
	import com.luislarghi.gameobjects.enemies.Mummy;
	import com.luislarghi.gameobjects.enemies.Vampire;
	import com.luislarghi.gameobjects.enemies.Zomby;
	import com.luislarghi.gameobjects.towers.Dogman;
	import com.luislarghi.gameobjects.towers.Monk;
	import com.luislarghi.gameobjects.towers.TorchThrower;
	import com.luislarghi.gui.GUI_Button;
	import com.luislarghi.gui.GUI_HUDButton;
	import com.luislarghi.gui.GUI_Stage1;
	import com.luislarghi.managers.AssetsManager;
	import com.luislarghi.managers.GameObjectsManager;
	import com.luislarghi.managers.XmlManager;
	import com.luislarghi.myfirtsengine.Engine_GUIButton;
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
	import flash.system.System;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	public class Stage_1 extends Engine_GameState
	{
		private var currentBGimg:Engine_SpriteSheet;
		public static var currentMap:Array;
		public static var changingLevel:Boolean;
		
		private var keysMapper:Array;

		public static var currentBuildMode:int = R.NULLMODE;
		private var towers:Vector.<Tower> = new Vector.<Tower>;
		public var bullets:Vector.<Bullet> = new Vector.<Bullet>;
		public var waves:Vector.<Enemy> = new Vector.<Enemy>;
		
		private var enemySpanwRate:int = 2000;
		private var enemySpawned:int = 0;
		private var counter:int = 0;
		private var GUI_component:GUI_Stage1;
		
		public var gameObjContainer:Sprite;
		public var guiContainer:Sprite;
		private var levelContainer:Sprite;
		
		public function Stage_1(g:Game) { super(Main.mainStage, g); }
		
		protected override function Init(e:Event):void
		{
			super.Init(e);
			
			GameObjectsManager.CreateWave(waves, this);
			
			Stats.Reset();
			
			changingLevel = true;
			
			gameObjContainer = new Sprite();
			guiContainer = new Sprite();
			levelContainer = new Sprite();
			
			this.addChildAt(levelContainer, 0);
			this.addChildAt(gameObjContainer, 1);
			this.addChildAt(guiContainer, 2);			
			
			for(var row:int = 0; row < waves.length; row++) 
			{
				gameObjContainer.addChild(waves[row]);
				waves[row].Init();
			}
			
			// If running on mobile
			if(R.isAndroid() || R.isIOS())
			{
				// If the OS is Android
				if(R.isAndroid())
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

			GUI_component = new GUI_Stage1(mainGame, this);
			GUI_component.Init();
			
			trace("In Game: ("+this.width+", "+this.height+") | Scale: ("+this.scaleX+", "+this.scaleY+")");
			//trace("You are INGAME");
		}
		
		protected override function Clear(e:Event):void
		{
			super.Clear(e);
			
			GameObjectsManager.ResetWaves(waves);
			
			levelContainer.removeChild(currentBGimg);
			currentBGimg = null;
			currentMap = null;
			
			for(var t:int = 0; t < towers.length; t++) gameObjContainer.removeChild(towers[t]);
			for(var b:int = 0; b < bullets.length; b++) gameObjContainer.removeChild(bullets[b]);
			for(var row:int = 0; row < waves.length; row++) 
			{
				gameObjContainer.removeChild(waves[row]);
				waves[row].Clear();
			}
			
			this.removeChild(gameObjContainer);
			this.removeChild(guiContainer);
			this.removeChild(levelContainer);
			
			towers.length = bullets.length = waves.length = 0;
			
			// If running on mobile
			if(R.isAndroid() || R.isIOS())
			{
				// If the OS is Android
				if(R.isAndroid())
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
			if(!pause && XmlManager.xmlReady && !gameOver)
			{
				for(var t:int = 0; t < towers.length; t++) towers[t].Draw();
				for(var b:int = 0; b < bullets.length; b++) bullets[b].Draw();
				for(var w:int = 0; w < waves.length; w++) if(waves[w].Active) waves[w].Draw();
			}
			
			GUI_component.Draw();
			
			//trace("Towers = " + towers.length + " | Bullets = " + bullets.length + " | Enemies = " + enemies.length + " | Tiles = " + tiles.length);
			//trace("Money = " + Stats.Money + " | Score = " + Stats.Score);
		}
		
		public override function Logic():void
		{
			if(changingLevel)
			{
				if(currentBGimg != null && levelContainer.contains(currentBGimg)) levelContainer.removeChild(currentBGimg);
				ChangeLevel();
				levelContainer.addChild(currentBGimg);
				changingLevel = false;
			}
			
			if(!pause && XmlManager.xmlReady &&!gameOver)
			{	
				CheckForDeadBullets();
	
				SpawnEnemy();
				
				GameObjectsManager.SpriteDepthBubbleSort(gameObjContainer);
				
				for(var t:int = 0; t < towers.length; t++) towers[t].Logic();
				for(var b:int = 0; b < bullets.length; b++) bullets[b].Logic();
				for(var w:int = 0; w < waves.length; w++) if(waves[w].Active) waves[w].Logic();
				
				CheckForBulletsCollition();
				CheckForTownAttack();
				
				if(GameObjectsManager.CheckForNextWave(waves))
				{
					if(enemySpawned >= XmlManager.levelWaves.level[Stats.currentLevel - 1].wave[Stats.currentWave].@enemiesCant)
					{
						if(Stats.currentWave < XmlManager.levelWaves.level[Stats.currentLevel - 1].wave.length() - 1) 
							Stats.currentWave++;	
						else gameOver = true;
						
						enemySpawned = 0;
					}
				}
			}
			
			GUI_component.Logic();
		}

		private function CheckForTownAttack():void
		{
			for(var i:int = 0; i < waves.length; i++)
			{
				if(waves[i].Survivor && waves[i].Active)
				{
					waves[i].Deactivate();
					Stats.townHealth -= 1;
				}
			}
			
			if(Stats.townHealth <= 0) gameOver = true;
		}
		
		private function SpawnEnemy():void
		{
			counter += mainStage.frameRate * enemySpanwRate / 1000;
			
			if(counter >= enemySpanwRate && enemySpawned < int(XmlManager.levelWaves.level[Stats.currentLevel - 1].wave[Stats.currentWave].@enemiesCant))
			{
				for (var i:int = 0; i < waves.length; i++) 
				{
					if(!waves[i].Active && !waves[i].Survivor) 
					{
						waves[i].Activate();
						enemySpawned++;
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
					bullets[b].Clear();
					bullets.splice(b, 1);
					break;
				}
			}
		}
		
		private function CheckForBulletsCollition():void
		{
			// For each active bullet
			for(var b:int = 0; b < bullets.length; b++)
			{
				// search each enemy
				for(var i:int = 0; i < waves.length; i++)
				{
					// and if the current bullet collides with an active enemy
					if(waves[i].Active && bullets[b].collitionBox.hitTestObject(waves[i].collitionBox))
					{
						// verify if get a special attack or not
						if((bullets[b] is Torch && waves[i] is Zomby) ||
						   (bullets[b] is GlintLight && waves[i] is Vampire) ||
						   (bullets[b] is Dog && waves[i] is Mummy))
						{
							waves[i].Hit(bullets[b].Damage * 2);
						}
						else 
						{
							waves[i].Hit(bullets[b].Damage);
						}

						
						// deactivate the bullet
						gameObjContainer.removeChild(bullets[b]);
						bullets.splice(b, 1);
						
						// and if the current enemy dies
						if(waves[i].Life <= 0)
						{
							// increase the points and money stats
							Stats.score += waves[i].PointsWorth;
							Stats.money += waves[i].MoneyDropped;
							// then kill that enemy 
							waves[i].DeathSound();
							waves[i].Deactivate();
						}
						
						break;
					}
				}
			}
		}
		
		public function ChangeLevel():void
		{
			switch(Stats.currentLevel)
			{
				case 0:
					currentBGimg = new Engine_SpriteSheet(AssetsManager.BM_Map, false, 1280, 768);
					currentBGimg.drawTile(0);
					currentMap = new Array();
					currentMap = R.CopyMultiDArray(R.map);
					break;
				
				case 1:
					currentBGimg = new Engine_SpriteSheet(AssetsManager.BM_Map2, false, 1280, 768);
					currentBGimg.drawTile(0);
					currentMap = new Array();
					currentMap = R.CopyMultiDArray(R.map2);
					break;
				
				case 2:
					currentBGimg = new Engine_SpriteSheet(AssetsManager.BM_Map3, false, 1280, 768);
					currentBGimg.drawTile(0);
					currentMap = new Array();
					currentMap = R.CopyMultiDArray(R.map3);
					break;
			}
			
			Stats.currentLevel++;
			Stats.currentWave = 0;
			GameObjectsManager.ResetWaves(waves);
			ResetObjects();
			gameOver = false;
			changingLevel = true;
		}
		
		private function ResetObjects():void
		{
			for(var t:int = 0; t < towers.length; t++) { gameObjContainer.removeChild(towers[t]); towers[t].Clear(); }
			for(var b:int = 0; b < bullets.length; b++) { gameObjContainer.removeChild(bullets[b]); bullets[b].Clear(); }
			
			towers.length = bullets.length = 0;
		}
		
		private function CheckClick(e:MouseEvent):void
		{
			// If the game is not paused or finnished
			if(!pause && !gameOver)
			{
				// and if the position clicked is a map tile or a HUD Button Object
				if((!(e.target.parent is Engine_GUIButton) || !(e.target.parent is GUI_HUDButton)) && currentBuildMode != R.NULLMODE)
				{
					var clickPoint:Point = R.ScreenToMap(new Point(e.stageX, e.stageY));
					
					// check first if the position clicked is buildable
					if(currentMap[clickPoint.y][clickPoint.x] == 0)
					{
						var tmpTower:Tower;
						
						if(currentBuildMode == R.PIROMODE) tmpTower = new TorchThrower(R.MapToScreen(clickPoint.x, clickPoint.y), XmlManager.towerTypes.tower[0], this);
						else if(currentBuildMode == R.PERROMODE) tmpTower = new Dogman(R.MapToScreen(clickPoint.x, clickPoint.y), XmlManager.towerTypes.tower[1], this);
						else if(currentBuildMode == R.CURAMODE) tmpTower = new Monk(R.MapToScreen(clickPoint.x, clickPoint.y), XmlManager.towerTypes.tower[2], this);
						
						gameObjContainer.addChild(tmpTower);
						tmpTower.Init();
						towers.push(tmpTower);
						
						// and update stats and stuff
						Stats.money -= tmpTower.BuildCost;
						currentMap[clickPoint.y][clickPoint.x] = -3;
						currentBuildMode = R.NULLMODE;
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