package {
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class Main extends Sprite {
		
		[Embed(source="../assets/stardustCoin.png")]
		private static const CoinClass:Class;
		
		private var START_BALANCE:String = "99'512'456'013";
		private var FINISH_BALANCE:String = "312'456'013";
		
		private var balanceAnimation:BalanceAnimation;
		
		public function Main() {
			this.balanceAnimation = new BalanceAnimation(START_BALANCE);
			this.balanceAnimation.x = this.balanceAnimation.y = 100;
			this.addChild(balanceAnimation);
			
			var coin:Image = new Image(Texture.fromBitmap(new CoinClass()));
			this.balanceAnimation.addCoin(coin);
			
			Starling.current.stage.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(e:TouchEvent):void {
			if (e.touches[0].phase == TouchPhase.ENDED) {
				FINISH_BALANCE = "" + int(Math.random() * 10000000000);
				this.balanceAnimation.showAnimation(FINISH_BALANCE);
//				this.removeChild(this.balanceAnimation);
				
				/*this.balanceAnimation = new BalanceAnimation();
				this.balanceAnimation.x = e.touches[0].globalX;
				this.balanceAnimation.y = e.touches[0].globalY;
//				this.balanceAnimation.x = this.balanceAnimation.y = 100;
				this.addChild(balanceAnimation);*/
			}
		}
	}
}