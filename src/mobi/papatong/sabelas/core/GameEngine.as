package mobi.papatong.sabelas.core
{
	import away3d.core.managers.Stage3DProxy;
	import flash.events.EventDispatcher;
	import mobi.papatong.sabelas.core.EntityCreator;
	import mobi.papatong.sabelas.components.GameState;
	import mobi.papatong.sabelas.configs.GameConfig;
	import mobi.papatong.sabelas.systems.GameManager;
	import mobi.papatong.sabelas.systems.RenderSystem;
	import mobi.papatong.sabelas.systems.SystemPriorities;
	import mobi.papatong.sabelas.utils.Stage3DUtils;
	import net.richardlord.ash.core.Entity;
	import net.richardlord.ash.core.Game;
	import net.richardlord.ash.integration.starling.StarlingFrameTickProvider;
	import net.richardlord.ash.tick.TickProvider;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	
	/**
	 * The main game engine which will control the main game context.
	 * Will dispatch game events
	 *
	 * @author Abiyasa
	 */
	public class GameEngine extends EventDispatcher
	{
		public static const DEBUG_TAG:String = "GameEngine";
		
		private var _game:Game;
		private var _container:DisplayObjectContainer;
		private var _config:GameConfig;
		private var _entityCreator:EntityCreator;
		private var _tickProvider:TickProvider;
		private var _gameState:GameState;
		
		/**
		 * The shared Stage3D context
		 */
		private var _stage3dProxy:Stage3DProxy;
		
		
		public function GameEngine(container:DisplayObjectContainer)
		{
			super();
			
			_container = container;
		}
		
		public function init():void
		{
			_game = new Game();
			_entityCreator = new EntityCreator(_game);
			
			_config = new GameConfig();
			_config.width = _container.stage.stageWidth;
			_config.height = _container.stage.stageHeight;
			
			// TODO init input (keypoll)
			
			// get stage3d proxy for Away3D
			var activeStaring:Starling = Starling.current;
			_stage3dProxy = Stage3DUtils.getActiveStage3DProxy(activeStaring.nativeStage, activeStaring.stage3D);
			if (_stage3dProxy == null)
			{
				trace(DEBUG_TAG + "Error! Cannot found the stage3dproxy");
			}
			else
			{
				trace(DEBUG_TAG, 'getting stage3dproxy at index=' + _stage3dProxy.stage3DIndex);
			}
			
			// add systems
			_game.addSystem(new GameManager(_entityCreator, _config), SystemPriorities.PRE_UPDATE);
			_game.addSystem(new RenderSystem(_container), SystemPriorities.RENDER);
		
			// get the active game state
			var gameStateEntity:Entity = _entityCreator.createGameState();
			_gameState = gameStateEntity.get(GameState) as GameState;
		}
		
		private function destroy():void
		{
			_game.removeAllEntities();
			_game.removeAllSystems();
		}
		
		public function start():void
		{
			_tickProvider = new StarlingFrameTickProvider(Starling.current.juggler);
			_tickProvider.add(_game.update);
			_tickProvider.add(frameTick);
			_tickProvider.start();
		}
		
		public function stop():void
		{
			_tickProvider.stop();
			_tickProvider.remove(_game.update);

			destroy();
		}
		
		/**
		 * For controlling frame loop
		 * @param	time
		 */
		public function frameTick(time:Number):void
		{
			// TODO Is there any better way to notify game over?
			// 	Maybe use GameManager?
			/*
			switch (_gameState.status)
			{
			case GameState.STATUS_GAME_OVER:
				tickProvider.stop();
				
				container.dispatchEvent(new AsteroidsEvent(AsteroidsEvent.GAME_OVER));
				break;
			}
			*/
		}
	}

}