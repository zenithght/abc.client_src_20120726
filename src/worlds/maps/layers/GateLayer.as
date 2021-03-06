package worlds.maps.layers
{
	import worlds.maps.layers.gates.GateMediator;
	import flash.display.Sprite;
	import flash.display.DisplayObject;

	/**
	 * @author ZengFeng (Eamil:zengfeng75[AT])163.com 2012-5-22
	 */
	public class GateLayer
	{
		private var list : Vector.<DisplayObject>;
		private var container : Sprite;
		private var _numChild:int = 0;
		

		function GateLayer(container : Sprite) : void
		{
			this.container = container;
			list = new Vector.<DisplayObject>();
			GateMediator.addToLayer.register(addChild);
			GateMediator.removeFromLayer.register(removeChild);
		}

		public function addChild(child : DisplayObject) : DisplayObject
		{
			_numChild ++;
			list.push(child);
			return container.addChildAt(child, 1);
		}

		public function removeChild(child : DisplayObject) : DisplayObject
		{
			_numChild --;
			var index : int = list.indexOf(child);
			list.splice(index, 1);
			return container.removeChild(child);
		}
		
		public function get numChild():int
		{
			return _numChild;
		}
		
		
	}
}
