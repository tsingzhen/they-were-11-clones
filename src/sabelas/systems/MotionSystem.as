package mobi.papatong.sabelas.systems
{
	import mobi.papatong.sabelas.components.Motion;
	import mobi.papatong.sabelas.components.Position;
	import mobi.papatong.sabelas.nodes.MotionNode;
	import ash.tools.ListIteratingSystem;
	
	/**
	 * System for updating object position based on its motion data
	 *
	 * @author Abiyasa
	 */
	public class MotionSystem extends ListIteratingSystem
	{
		
		public function MotionSystem()
		{
			super(MotionNode, updateNode);
		}
		
		private function updateNode(node:MotionNode, time:Number):void
		{
			var motion:Motion = node.motion;
			
			// calculate speed
			var position:Position = node.position;
			position.position.x += motion.calculateDeltaX(time);
			position.position.y += motion.calculateDeltaY(time);
			
			motion.resetForce();
		}
	}

}