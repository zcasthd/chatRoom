package Model
{
	import MyEvent.NetEventList;
	
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mx.core.FlexGlobals;
	import mx.utils.ObjectUtil;

	public class FMSservice
	{
		private var cam:Camera;
		private var mic:Microphone;
		
		public var nc_Publisher:NetConnection;
		public var ns_Publisher:NetStream;
		public var nc_Receiver:NetConnection;
		public var ns_Receiver:NetStream;
		
		private var showlog:Boolean = true;
		public function FMSservice()
		{
			cam = Camera.getCamera();
			mic = Microphone.getMicrophone();
			
			nc_Publisher = new NetConnection();
			nc_Publisher.connect("rtmp://fms.2be.com.tw/live");
			nc_Publisher.client = this;
			nc_Publisher.addEventListener( NetStatusEvent.NET_STATUS, connectHandler);
			
			nc_Receiver = new NetConnection();
			nc_Receiver.connect("rtmp://fms.2be.com.tw/live");
			nc_Receiver.client = this;
			nc_Receiver.addEventListener( NetStatusEvent.NET_STATUS, connectHandler);
		}
		
		private function connectHandler(e:NetStatusEvent) : void 
		{
			trace(ObjectUtil.toString(e));
			//			trace(e.info.code);
			switch (e.info.code)
			{
				case NetEventList.NETCONNECTION_CONNECT_CLOSED:
//					onReconnect();
					break;
				case NetEventList.NETCONNECTION_CONNECT_FAILED:
				case NetEventList.NETCONNECTION_CONNECT_REJECTED:
				case NetEventList.NETCONNECTION_CONNECT_APPSHUTDOWN:
				case NetEventList.NETCONNECTION_CONNECT_INVALIDAPP:
//					onDisconnect();
					break; 
				case NetEventList.NETCONNECTION_CONNECT_SUCCESS:
//					onConnect();
					break;
				case NetEventList.NETSTREAM_CONNECT_SUCCESS:
//					onNetStreamConnect();
					break;
				case NetEventList.NETSTREAM_CONNECT_REJECTED:
					break;
				case NetEventList.NETCONNECTION_CONNECT_FAILED:
//					doDisconnect();
					break;
				case NetEventList.NETSTREAM_CONNECT_CLOSED:
					break;
				case NetEventList.NETSTREAM_MULTICASTSTREAM_RESET:
					break;
				case NetEventList.NETSTREAM_BUFFER_FULL:
					break;
				case NetEventList.NETGROUP_CONNECT_SUCCESS:
//					onNetGroupConnect();
					break;
				case NetEventList.NETGROUP_CONNECT_REJECTED:
					break;
				case NetEventList.NETGROUP_CONNECT_FAILED:
					break;
//				doDisconnect();
				break;
				case NetEventList.NETGROUP_POSTING_NOTIFY:
					break;
				case NetEventList.NETGROUP_LOCALCOVERAGE_NOTIFY:
				case NetEventList.NETGROUP_NEIGHBOR_CONNECT:
				case NetEventList.NETGROUP_NIEGHBOR_DISCONNECT:
				case NetEventList.NETGROUP_SENDTO_NOTIFY:
				case NetEventList.NETGROUP_MULTICASTSTREAM_PUBLISHNOTIFY:
				case NetEventList.NETGROUP_MULTICASTSTREAM_UNPUBLISHNOTIFY:
				case NetEventList.NETGROUP_REPLICATION_FETCH_SENDNOTIFY:
				case NetEventList.NETGROUP_REPLICATION_FETCH_FAILED:
				case NetEventList.NETGROUP_REPLICATION_FETCH_RESULT:
				case NetEventList.NETGROUP_REPLICATION_REQUEST:
					break;
			}
		}
		
		public function publish(e:*=null):void
		{
			if ( nc_Publisher.connected) {
				ns_Publisher = new NetStream( nc_Publisher );
				ns_Publisher.attachCamera( cam );
				ns_Publisher.attachAudio( mic );
				trace("publish", UserModel.instance.self.name);
				ns_Publisher.publish(UserModel.instance.self.name);
			}
		}
		
//		public function play(streamKey:String):void
		public function play(e:*):void
		{
			if (nc_Receiver.connected) {
				trace("stream play", e.user.name+"!");
//				trace(ObjectUtil.toString(e));
				ns_Receiver = new NetStream( nc_Receiver );
				
				FlexGlobals.topLevelApplication.videoPlayer.attachStream(ns_Receiver);
				ns_Receiver.play( e.user.name );
			}
		}
		
		public function closeCameraStream():void
		{
			ns_Publisher.attachCamera( null );
		}
		
		
		public function onBWDone(...rest):void
		{
			trace('onBWDone();'+ rest, rest.length);
			if (showlog == false) {
				return;
			}
			for (var i:int=0; i<rest.length; ++i) {
				trace("\t"+i+":"+rest[i]);
			}
		}
		public function onMetaData(info:Object):void
		{
			trace('onMetaData');
			if (showlog == false) {
				return;
			}
			for( var p:String in info)
			{
				trace(p, info[p]);
			}
		}
		public function onPlayStatus(info:Object):void
		{
			trace('onPlayStatus');
			if (showlog == false) {
				return;
			}
			for( var p:String in info)
			{
				trace('*', p, info[p]);
			}
		}
		public function onXMPData(...rest):void
		{
			if (showlog == false) {
				return;
			}
			trace('onXMPData:'+ rest, rest.length);
			for (var i:int=0; i<rest.length; ++i) {
				trace("\t"+i+":"+rest[i]);
			}
		}
	}
}