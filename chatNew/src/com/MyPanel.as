package com
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Panel;
	import mx.controls.Image;
	import mx.effects.Resize;
	import mx.effects.easing.Bounce;
	
	public class MyPanel extends Panel
	{
		public var _minbtn:Image ;
		
		public var _closebtn:Image ;
		
		private var eff:Resize = new Resize();
		
		public function MyPanel()
		{
			super();
			
			eff.heightTo=this.maxHeight;
			
			eff.easingFunction=Bounce.easeOut;
			
		}
		
		protected override function createChildren(): void {
			super.createChildren();
			
			_minbtn = new Image();
			_minbtn.source="assets/icons/check.png";
			_minbtn.height=15;
			_minbtn.width=15;
			_minbtn.addEventListener(MouseEvent.CLICK,resizeHandler);
			
			this.rawChildren.addChild(_minbtn);
			
			
			_closebtn = new Image();
			_closebtn.height=15;
			_closebtn.width=15;
			//_minbtn.source="assets/icons/delete.png";
			this.rawChildren.addChild(_closebtn);
		}
		
		protected override function layoutChrome(unscaledWidth: Number, unscaledHeight:Number):void {
			super.layoutChrome(unscaledWidth, unscaledHeight);
			
			_minbtn.move(this.width-_minbtn.width-45,6);
			
			_closebtn.move(this.width-_minbtn.width-23,6);
		}
		
		private function resizeHandler(evt:MouseEvent):void{
			
			
			eff.heightTo=eff.heightTo==this.titleBar.height?300:this.titleBar.height;
			eff.duration=1000;
			eff.easingFunction = eff.easingFunction==Bounce.easeOut?Bounce.easeIn:Bounce.easeOut;
			eff.target=this;
			eff.play();
			
		}
	}
}