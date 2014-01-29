package com.luislarghi.gameobjects.bullets
{
	import com.luislarghi.gameobjects.baseclasses.Bullet;
	import com.luislarghi.gamestates.Stage_1;

	public class Torch extends Bullet
	{
		public function Torch(posX:int, posY:int, rot:Number)
		{
			super(posX, posY, rot);
		}
	}
}