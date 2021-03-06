package worlds
{
	import worlds.apis.MTo;
	import worlds.apis.MModuleStartupExit;
	import worlds.mediators.MapMediator;

	import game.manager.SignalBusManager;
	import game.core.user.UserData;

	import worlds.roles.structs.PlayerStruct;
	import worlds.apis.MNpc;
	import worlds.apis.MWorld;
	import worlds.apis.MapUtil;
	import worlds.auxiliarys.EnterFrameListener;
	import worlds.auxiliarys.MapStage;
	import worlds.auxiliarys.mediators.MSignal;
	import worlds.maps.layers.LayerContainer;
	import worlds.maps.resets.MapReset;
	import worlds.npcs.NpcControl;
	import worlds.players.GlobalPlayers;
	import worlds.players.PlayerControl;

	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	// ============================
	// @author ZengFeng (zengfeng75[AT]163.com) 2012-6-4
	// 只有地图包内能使用，其他地方请不要使用
	// ============================
	public class WorldStartup
	{
		public static var userId : int;
		public static var loginMapId : int;
		public static var mapContainer : Sprite;
		public static var signalComplete : MSignal = new MSignal();
		public static var isInit:Boolean = false;
		public static var initFun:Function;
		

		public static function startup(userId : int, loginMapId : int, mapContainer : Sprite) : void
		{
			if (loginMapId == 0) loginMapId = 1;
			WorldStartup.userId = userId;
			WorldStartup.loginMapId = loginMapId;
			WorldStartup.mapContainer = mapContainer;

			MapStage.startup(mapContainer.stage);
			To.instance;
			GlobalPlayers.instance.init();
//			WorldProto.instance;
			EnterFrameListener.startup(mapContainer.stage);
			MapUtil.setStage(mapContainer.stage);
			MapUtil.setCurrentMapId(loginMapId);
			LayerContainer.instance.init();
			MapReset.instance;
			PlayerControl.instance;
			NpcControl.instance;
			signalComplete.dispatch();

			MWorld.sInstallReady.add(MNpc.initData);
			MapStage.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			initSelfPlayerStruct();
			SignalBusManager.battleStart.add(MapMediator.cHide.call);
			SignalBusManager.battleEnd.add(MapMediator.cShow.call);
			MapMediator.sChangeMapStart.add(changeMapStart);
			MapMediator.sChangeMapEnd.add(changeMapEnd);
			MapMediator.sInstallReady.add(MModuleStartupExit.changeMap);
			
			isInit = true;
			if(initFun != null) initFun();
			initFun = null;
		}

		private static function initSelfPlayerStruct() : void
		{
			var self : PlayerStruct = GlobalPlayers.instance.self;
			self.id = UserData.instance.playerId;
			self.name = UserData.instance.playerName;
			self.level = UserData.instance.level;
			self.heroId = UserData.instance.myHero.id;
			self.setPotential(UserData.instance.myHero.potential);
			self.avatarVer = 0;
		}

		private static function changeMapStart() : void
		{
			MWorld.isChangeMaping = true;
		}

		private static function changeMapEnd() : void
		{
			MWorld.isChangeMaping = false;
		}

		private static function onKeyDown(event : KeyboardEvent) : void
		{
			if (event.keyCode > Keyboard.NUMBER_0 && event.keyCode <= Keyboard.NUMBER_9)
			{
				var num : int = parseInt(String.fromCharCode(event.keyCode));
				if (event.ctrlKey)
				{
					MTo.clear();
					MWorld.csChangeMap(num);
				}
			}

			switch(event.keyCode)
			{
				case Keyboard.LEFT:
					speedX = -speed;
					break;
				case Keyboard.RIGHT:
					speedX = speed;
					break;
				case Keyboard.UP:
					speedY = -speed;
					break;
				case Keyboard.DOWN:
					speedY = speed;
					break;
				case Keyboard.SPACE:
					speedX = 0;
					speedY = 0;
					break;
			}

			// if (speedX != 0 || speedY != 0)
			// {
			// EnterFrameListener.add(onEnterFrame);
			// }
			// else
			// {
			// EnterFrameListener.remove(onEnterFrame);
			// }
		}

		private static var speed : Number = 4;
		private static var speedX : Number = 0;
		private static var speedY : Number = 0;
		private static var  mapX : int = 0;
		private static var  mapY : int = 0;

		private static function onEnterFrame() : void
		{
			mapX += speedX;
			mapY += speedY;
			trace(mapX, mapY);
			LayerContainer.instance.updatePosition(mapX, mapY);
		}
	}
}
