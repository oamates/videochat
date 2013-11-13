package {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.H264VideoStreamSettings;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.filters.DropShadowFilter;
    
    import mx.core.UIComponent;
	
	public class Producer extends Sprite {
		
		private var inited:Boolean = false;
		private var nc:NetConnection;
		private var rtmpURL:String;
		private var nsOut:NetStream;
		private var cam:Camera;
		private var mic:Microphone;
		private var vidLocal:Video;
        private var selector:SelectDevice;
		
		private var host:String = "localhost";
		private var appName:String = "live";
		
		private var api:ServiceAPI = new ServiceAPI();

		public function Producer() {
			this.addEventListener(Event.ADDED, onAdded);
            //HTTPCookie.getCookies();
            //Log.trace(api.test());
		}
		
		public function onAdded(e:Event):void {
			
			if (inited) return;
			
			inited = true;
			
			if (root.loaderInfo.parameters["host"]) {
				host = stage.loaderInfo.parameters["host"]
			}
			if (root.loaderInfo.parameters["appName"]) {
				appName = stage.loaderInfo.parameters["appName"]
			}
			
			rtmpURL = "rtmp://" + host + "/" + appName;
			Log.trace("connect ", rtmpURL);
			
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, checkCon);
			nc.client = this;
			
			nc.connect(rtmpURL);
			
			setCam();
			setMic();
            setVideo();
		
            // info text
            var myformat:TextFormat = new TextFormat();
            myformat.size = 24;
            myformat.align="center";				
            myformat.font = "Wingdings";

            var fieldSpeed:TextField = new TextField();
            fieldSpeed.x = 5;
            fieldSpeed.y = 5;
            fieldSpeed.visible = true;
            fieldSpeed.text = "本地视频";
            fieldSpeed.textColor = 0x00FF00; 
            fieldSpeed.selectable = false;
            fieldSpeed.autoSize = TextFieldAutoSize.LEFT;
            fieldSpeed.setTextFormat(myformat);
            fieldSpeed.filters = [new DropShadowFilter()];
            fieldSpeed.filters[0].color = 0xFFFFFF
            addChild(fieldSpeed);
        }
		
		// bandwidth detection on the server
		public function onBWCheck(...arg):Number {
			return 0;
		}
		public function onBWDone(...arg):void {
			var p_bw:Number = -1; 
			if (arg.length > 0) p_bw = arg[0]; 
			Log.trace("bandwidth = ", p_bw, " Kbps."); 
		}
		
		private function checkCon(e:NetStatusEvent):void {
			
			var connected:Boolean = e.info.code == "NetConnection.Connect.Success";
			
			if (connected) {
				nsOut = new NetStream(nc);
				
				// H.264 codec setting
				var cameraSettings:H264VideoStreamSettings = new H264VideoStreamSettings(); 
				cameraSettings.setProfileLevel(H264Profile.BASELINE, H264Level.LEVEL_1_2);
				nsOut.videoStreamSettings = cameraSettings;
				
				nsOut.attachAudio(mic);
				nsOut.attachCamera(cam);
				nsOut.publish("user1", "live");
				
			}
			
			Log.trace("NetStatus: ", e.info.code);
		}
		
		private function setCam():void {
			
			cam = Camera.getCamera();
			cam.setKeyFrameInterval(10);
			cam.setMode(320,240,24);
			cam.setQuality(0,95);
			
		}
		
		private function setMic():void {
			
			mic = Microphone.getMicrophone();
			mic.codec = "Speex";
			mic.encodeQuality = 6;
			mic.gain = 85;
			mic.rate = 11;
			mic.setSilenceLevel(15,2000);
			
		}
		
		private function setVideo():void {
			
			var w:Number = stage.stageWidth;
			var h:Number = cam.height / cam.width * stage.stageWidth;
			
			vidLocal = new Video(w,h);
			vidLocal.x = 0;
			vidLocal.y = (stage.stageHeight - h) / 2;
			vidLocal.attachCamera(cam);
			addChild(vidLocal);
			
		}
	}
}