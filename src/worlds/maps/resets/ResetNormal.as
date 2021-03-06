package worlds.maps.resets
{
	import worlds.apis.MapUtil;
	import worlds.apis.MWorld;
	import worlds.mediators.MapMediator;
	import worlds.mediators.NpcMediator;
	import worlds.mediators.PlayerMediator;
	import worlds.players.PlayerControl;
	import worlds.players.SelfManager;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-22
	 */
	public class ResetNormal  implements IReset
	{
		/** 单例对像 */
		private static var _instance : ResetNormal;

		/** 获取单例对像 */
		public static function get instance() : ResetNormal
		{
			if (_instance == null)
			{
				_instance = new ResetNormal();
			}
			return _instance;
		}

		// ---------------------------------- 我是优美的长分隔线 ---------------------------------- //
		protected var playerControl : PlayerControl = PlayerControl.instance;
		protected var selfManager : SelfManager = SelfManager.instance;

		public function ResetNormal()
		{
		}

		/** 卸载 */
		public function uninstall() : void
		{
			MapMediator.cMouseEnabled.call(false);
			MapMediator.cBindScorll.call(false);

			MapMediator.pauseInstall.remove(removeSignals);
			NpcMediator.uninstall.dispatch();
			playerControl.uninstallSelf();
			playerControl.unstallOtherPlayers();
			MWorld.needSendWalk = true;
		}

		/** 开始安装 */
		public function startInstall() : void
		{
			MapMediator.pauseInstall.add(removeSignals);
			NpcMediator.startInstall.dispatch();
			playerControl.isLimitPlayer = MapUtil.isLimitPlayer();
			addSignals();
			playerControl.installSelf();
			playerControl.installOtherPlayers();

			MapMediator.cMouseEnabled.call(true);
			MapMediator.cBindScorll.call(true);
			MWorld.needSendWalk = true;
		}

		/** 添加监听信息 */
		protected function addSignals() : void
		{
			PlayerMediator.selfWaitInstall.add(playerControl.installSelf);
			PlayerMediator.playerWaitInstalled.add(playerControl.installPlayer);
			PlayerMediator.playerLeave.add(playerControl.uninstallPlayer);
			PlayerMediator.walkTo.add(playerControl.playerWalk);
			PlayerMediator.transportTo.add(playerControl.playerTransport);
			PlayerMediator.changeCloth.add(playerControl.changeCloth);
			PlayerMediator.changeRide.add(playerControl.changeRide);
			PlayerMediator.sitDown.add(playerControl.sitDown);
			PlayerMediator.sitUp.add(playerControl.sitUp);
			if (MapUtil.isLimitPlayer())
			{
				PlayerMediator.MODEL_IN.add(playerControl.modelIn);
				PlayerMediator.MODEL_OUT.add(playerControl.modelOut);
			}
		}

		/** 移除监听信息 */
		protected function removeSignals() : void
		{
			playerControl.clearInstallWaitPlayer();
			PlayerMediator.selfWaitInstall.remove(playerControl.installSelf);
			PlayerMediator.playerWaitInstalled.remove(playerControl.installPlayer);
			PlayerMediator.playerLeave.remove(playerControl.uninstallPlayer);
			PlayerMediator.walkTo.remove(playerControl.playerWalk);
			PlayerMediator.transportTo.remove(playerControl.playerTransport);
			PlayerMediator.changeCloth.remove(playerControl.changeCloth);
			PlayerMediator.changeRide.remove(playerControl.changeRide);
			PlayerMediator.sitDown.remove(playerControl.sitDown);
			PlayerMediator.sitUp.remove(playerControl.sitUp);
			PlayerMediator.MODEL_IN.remove(playerControl.modelIn);
			PlayerMediator.MODEL_OUT.remove(playerControl.modelOut);
		}
	}
}