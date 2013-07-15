package {
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class Main extends Sprite {

		private var balanceAnimation:BalanceAnimation;
		
		public function Main() {
			this.balanceAnimation = new BalanceAnimation();
			this.balanceAnimation.x = this.balanceAnimation.y = 100;
			this.addChild(balanceAnimation);
			
			Starling.current.stage.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e:TouchEvent):void {
			if (e.touches[0].phase == TouchPhase.ENDED) {
//				this.removeChild(this.balanceAnimation);
				
				this.balanceAnimation = new BalanceAnimation();
				this.balanceAnimation.x = e.touches[0].globalX;
				this.balanceAnimation.y = e.touches[0].globalY;
//				this.balanceAnimation.x = this.balanceAnimation.y = 100;
				this.addChild(balanceAnimation);
			}
		}
	}
}