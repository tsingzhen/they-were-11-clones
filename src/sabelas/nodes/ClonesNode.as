package sabelas.nodes
{
	import sabelas.components.CloneMember;
	import sabelas.components.Collision;
	import sabelas.components.Energy;
	import sabelas.components.Motion;
	import sabelas.components.Position;
	import ash.core.Node;
	
	/**
	 * Node for a clone component
	 * @author Abiyasa
	 */
	public class ClonesNode extends Node
	{
		public var cloneMember:CloneMember;
		public var collision:Collision;
		public var position:Position;
		public var motion:Motion;
		public var energy:Energy;
	}

}
