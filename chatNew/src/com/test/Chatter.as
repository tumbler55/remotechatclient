package com.test
{
		import flash.display.MovieClip;
		import flash.display.Sprite;
		import flash.events.NetStatusEvent;
		import flash.media.Camera;
		import flash.media.Microphone;
		import flash.media.Video;
		import flash.net.NetConnection;
		import flash.net.NetStream;
		import flash.net.Responder;
		
		import mx.controls.Alert;
		import mx.controls.VideoDisplay;
		
		public class Chatter extends Sprite
		{
			private var nc:NetConnection;
			private var good:Boolean;
			private var netOut:NetStream;
			private var netIn:NetStream;
			private var cam:Camera;
			private var mic:Microphone;
			private var responder:Responder;
			private var r:Responder;
			private var vidOut:VideoDisplay;
			private var vidIn:VideoDisplay;
			
			
			private var vOut:Video;
			private var vIn:Video;
			
			
			private var outStream:String;
			private var inStream:String;
			
			public function Chatter(vidOut:VideoDisplay,vidIn:VideoDisplay)
			{
				this.vidIn=vidIn;
				this.vidOut=vidOut;			
				var rtmpNow:String="rtmp://localhost/oflaDemo";
				nc=new NetConnection;
				nc.connect(rtmpNow,"testName");
				nc.addEventListener(NetStatusEvent.NET_STATUS,getStream);
			}
			
			private function getStream(e:NetStatusEvent):void
			{
				good=e.info.code == "NetConnection.Connect.Success";
				if(good)
				{
					streamNow(null);
					Alert.show("ok");
				}else{
					Alert.show("fail");
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

				//trace("We've got our object",streamSelect.toString());
				
				//Publish local video
				netOut=new NetStream(nc);
				netOut.attachAudio(mic);
				netOut.attachCamera(cam);
				vidOut.attachCamera(cam);
				netOut.publish("test", "append");
				
				//Play streamed video
				netIn=new NetStream(nc);
				vIn=new Video();
				vIn.height=500;
				vIn.width=500;
				vIn.attachNetStream(netIn);
				vidIn.addChild(vIn);
				netIn.play("test");
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