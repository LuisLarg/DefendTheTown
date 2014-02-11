package com.luislarghi.managers
{
	import com.luislarghi.R;
	
	import flash.display.Bitmap;
	import flash.media.Sound;
	
	public final class AssetsManager
	{
		//Instances of each sound
		public static var SND_Music:Sound;
		public static var SND_Click:Sound;
		
		//Instances of each image
		public static var BM_Map:Bitmap;
		public static var BM_Map2:Bitmap;
		public static var BM_Map3:Bitmap;
		public static var BM_MainMenu:Bitmap;
		public static var BM_Cura:Bitmap;
		public static var BM_Perrero:Bitmap;
		public static var BM_Piromano:Bitmap;
		public static var BM_Vampiro:Bitmap;
		public static var BM_Momia:Bitmap;
		public static var BM_Zomby:Bitmap;
		public static var BM_HUD:Bitmap;
		public static var BM_Button:Bitmap;
		
		public static function InstantiateAssets():void
		{
			SND_Music = new R.SNDFILE_BackGMusic();
			SND_Click = new R.SNDFILE_Click();
			
			BM_Map = new R.BG_Map();
			BM_Map2 = new R.BG_Map2();
			BM_Map3 = new R.BG_Map3();
			BM_MainMenu = new R.BG_MainMenu();
			BM_Cura = new R.SS_Cura();
			BM_Perrero = new R.SS_Perrero();
			BM_Piromano = new R.SS_Piromano();
			BM_Vampiro = new R.SS_Vampiro();
			BM_Momia = new R.SS_Momia();
			BM_Zomby = new R.SS_Zomby();
			BM_HUD = new R.SS_HUD();
			BM_Button = new R.SS_Button();
		}
		
		public static function DeallocateAsstes():void
		{
			SND_Music = SND_Click = null;
			
			BM_Map.bitmapData.dispose();
			BM_Map2.bitmapData.dispose();
			BM_Map3.bitmapData.dispose();
			BM_MainMenu.bitmapData.dispose();
			BM_Cura.bitmapData.dispose();
			BM_Perrero.bitmapData.dispose();
			BM_Piromano.bitmapData.dispose();
			BM_Vampiro.bitmapData.dispose();
			BM_Momia.bitmapData.dispose();
			BM_Zomby.bitmapData.dispose();
			BM_HUD.bitmapData.dispose();
			BM_Button.bitmapData.dispose();
		}
	}
}