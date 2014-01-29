package com.luislarghi.gameobjects.bullets
{
	import com.luislarghi.gameobjects.baseclasses.Bullet;
	import com.luislarghi.gamestates.Stage_1;

	public class Dog extends Bullet
	{
		public function Dog(posX:int, posY:int, rot:Number)
		{
			super(posX, posY, rot);
		}
	}
}