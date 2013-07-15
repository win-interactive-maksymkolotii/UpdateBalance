package {
	
	import flash.display.Sprite;
	
	import starling.core.Starling;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="0x000000")]
	public class BalanceAnim extends Sprite {
		
		public function BalanceAnim() {
			var _st:Starling = new Starling(Main, stage);
			_st.start();
		}
	}
}