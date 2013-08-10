package com.yourpalmark.chat.data
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
	import mx.core.Application;
	
	public class VideoMonitor extends Sprite
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
		public var inStream:String=new String();
		
		
		public function VideoMonitor(vidOut:VideoDisplay,vidIn:VideoDisplay)
		{
			this.vidIn=vidIn;
			this.vidOut=vidOut;					
			
			var rtmpNow:String="rtmp://localhost/oflaDemo";
			netconn=new NetConnection;
			netconn.connect(rtmpNow,"testName");
			netconn.addEventListener(NetStatusEvent.NET_STATUS,getStream);			
			super();
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
			// 创建回调函数的对象
			var customClient:Object= new Object();
			customClient.onMetaData = metaDataHandler;
			
			//Play streamed video
			netOut=new NetStream(netconn);
			netOut.client=customClient;
			vOut=new Video();
			vOut.width=vidOut.width;
			vOut.height=vidOut.height;			
			vOut.attachNetStream(netOut);
			vidOut.addChild(vOut);
			netOut.play(inStream);			
			//Play streamed video
			netIn=new NetStream(netconn);
			netIn.client=customClient;
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
		public function metaDataHandler(infoObject:Object):void 
		{ 
			         trace("metadata"); 
		}
	}
}