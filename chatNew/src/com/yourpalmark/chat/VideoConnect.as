package com.yourpalmark.chat
{
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.Responder;
	
	import mx.controls.Alert;
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
		public var inStream:String=new String();
		
		public function VideoConnect(vidOut:VideoDisplay,vidIn:VideoDisplay)
		{
			if((vidOut==null)||(vidIn==null))
			{
				return;
			}
			this.vidIn=vidIn;
			this.vidOut=vidOut;		
			var rtmpNow:String="rtmp://localhost/oflaDemo";
			netconn=new NetConnection;
			netconn.connect(rtmpNow,"testName");
			netconn.client=this;
			netconn.addEventListener(NetStatusEvent.NET_STATUS,getStream);                 
			netconn.addEventListener(AsyncErrorEvent.ASYNC_ERROR,onAsyncErrorHandler);  
			netconn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
		private function getStream(e:NetStatusEvent):void
		{
			switch (e.info.code) 
			{ 
				case "NetConnection.Connect.Success": 
					streamNow(null);
					break; 
				case "NetConnection.Connect.Rejected": 
					Alert.show("访问FMS服务器权限不足,连接被拒绝"); 
					break; 
				case "NetConnection.Connect.InvalidApp":
					Alert.show("指定的应用程序名称没有找到")
					break; 
				case "NetConnection.Connect.Failed": 
					Alert.show("连接失败！");
					break; 
				case "NetConnection.Connect.AppShutDown": 
					Alert.show("服务器端应用程序已经关闭(由于资源耗用过大等原因)或者服务器已经关闭!")
					break; 
				case "NetConnection.Connect.Closed": 
					Alert.show("与FMS的连接中断！")
					break; 
			} 
		}
		private function onAsyncErrorHandler(evt:AsyncErrorEvent):void   
		{
			trace( "AsyncErrorEvent: "+ evt.text);         
		}  
		private function onSecurityError(evt:SecurityErrorEvent):void   
		{
			trace( "SecurityErrorEvent: "+ evt.text);         
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
			customClient.onMetaData = onMetaData;
			try{
				//Publish local video
				netOut=new NetStream(netconn);
				netOut.client=customClient;
				netOut.attachAudio(mic);
				netOut.attachCamera(cam);
				vidOut.attachCamera(cam);
				netOut.publish(outStream, "append");
				
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
			catch(e:Error)
			{
				trace(e);
			}
		}
		
		private function setCam():void
		{
			cam=Camera.getCamera();
			if(!cam)
			{
				Alert.show("没有获取到摄像头","提示");
				return;
			}
			cam.setMode(240,180,15);
			cam.setQuality(0,85);
			cam.setLoopback(true);
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