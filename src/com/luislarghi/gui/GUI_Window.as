package com.luislarghi.gui
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class GUI_Window extends Sprite
	{
		private var text:String;
		private var winWidth:int;
		private var winHeight:int;
		
		private var TF_Label:TextField;
		private var TF_Format:TextFormat;
		
		private var visible:Boolean = false;
		
		public function GUI_Window(label:String, w:int, h:int)
		{
			text = label;
			winWidth = w;
			winHeight = h;
			
			this.addEventListener(Event.ADDED_TO_STAGE, Init);
			this.addEventListener(Event.REMOVED_FROM_STAGE, Clear);
			
			InstantiateAllTF();
		}
		
		private function Init(e:Event):void
		{
			this.addChild(TF_Label);
		}
		
		public function Clear(e:Event):void
		{
			this.removeChild(TF_Label);
			
			TF_Label = null;
			TF_Format = null;
		}
		
		public function Draw():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(0, 0, winWidth, winHeight);
			this.graphics.endFill();
		}
		
		private function InstantiateAllTF():void
		{
			if(!TF_Label)
			{
				TF_Label = new TextField();
				TF_Label.text = text;
				TF_Label.x = (winWidth / 2) - (TF_Label.width / 2);
				TF_Label.selectable = false;
				TF_Label.mouseEnabled = false;
			}
			
			if(!TF_Format)
			{
				TF_Format = new TextFormat;
				TF_Format.size = 20;
				TF_Format.font = "Arial";
			}
			
			TF_Label.setTextFormat(TF_Format, 0, TF_Label.length);
			TF_Label.autoSize = TextFieldAutoSize.CENTER;
		}
		
		public function set Visible(v:Boolean):void { }
	}
}