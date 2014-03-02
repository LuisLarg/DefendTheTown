package com.luislarghi.gameobjects.bullets
{
	import com.luislarghi.R;
	import com.luislarghi.gameobjects.baseclasses.Bullet;
	import com.luislarghi.gamestates.Stage_1;
	import com.luislarghi.managers.AssetsManager;
	import com.luislarghi.managers.XmlManager;
	import com.luislarghi.myfirtsengine.Engine_SpriteSheet;

	public class Torch extends Bullet
	{
		public function Torch(posX:int, posY:int, rot:Number) { super(posX, posY, rot); }
		
		public override function Init():void 
		{
			SpriteSheet = new Engine_SpriteSheet(AssetsManager.BM_Piromano, false, R.tileWidth, R.tileHeight * 2);
			
			super.Init();
			
			minAnimFrame = int(XmlManager.towerTypes.tower[0].@framePerAnim) * 3;
		}
	}
}