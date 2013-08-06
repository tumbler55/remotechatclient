package com.yourpalmark.chat
{
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.Responder;
	
	import mx.controls.VideoDisplay;
	
	public class VideoConnect extends Sprite
	{
		private var netconn:NetConnection;
		private var good:Boolean;
		private var netIn:NetStream;
		private var netOut:NetStream;
		private var cam:Camera;
		private var mic:Microphone;
		private var responder:Responder;
		private var r:Responder;
		private var vidOut:VideoDisplay;
		private var vidIn:VideoDisplay;
		private var vOut:Video;
		private var vIn:Video;
		
		
		public var outStream:String=new String();
		public var inStream:String;
		
		public function VideoConnect(vidOut:VideoDisplay,vidIn:VideoDisplay)
		{
			this.vidIn=vidIn;
			this.vidOut=vidOut;		
			
			var rtmpNow:String="rtmp://localhost/oflaDemo";
			netconn=new NetConnection;
			netconn.connect(rtmpNow,"testName");
			netconn.addEventListener(NetStatusEvent.NET_STATUS,getStream);
		}
		
		private function getStream(e:NetStatusEvent):void
		{
			good=e.info.code == "NetConnection.Connect.Success";
			if(good)
			{
				streamNow(null);
			}else{
				//Alert.show("fail");
			}
		}
		
		private function adder (obj:Object):void{
			trace("Total = ",obj.toString());
		}
		
		private function streamNow(streamSelect:Object):void
		{
			//setVid();
			setCam();
			setMic();
			
			//Publish local video
			netOut=new NetStream(netconn);
			netOut.attachAudio(mic);
			netOut.attachCamera(cam);
			vidOut.attachCamera(cam);
			netOut.publish(outStream, "append");
			
			//Play streamed video
			netIn=new NetStream(netconn);
			vIn=new Video();
			vIn.width=vidIn.width;
			vIn.height=vidIn.height;			
			vIn.attachNetStream(netIn);
			vidIn.addChild(vIn);
			netIn.play(outStream);
		}
		
		private function setCam():void
		{
			cam=Camera.getCamera();
			cam.setMode(240,180,15);
			cam.setQuality(0,85);
		}
		
		private function setMic():void
		{
			mic=Microphone.getMicrophone();
			mic.rate=11;
			mic.setSilenceLevel(12,2000);
		}
		
		private function setVid():void
		{
			vidOut=new VideoDisplay();
			addChild(vidOut);
			vidOut.x=25;
			vidOut.y=110;
			vidOut.width=300;
			vidOut.height=300;
			
			vidIn=new VideoDisplay();
			addChild(vidIn);
			vidIn.x=vidOut.x+260;
			vidIn.y=110;
			
			vidIn.width=300;
			vidIn.height=300;
			
		}		
		public function onMetaData(infoObject:Object):void 
		{ 
			         trace("metadata"); 
		}
	}
}