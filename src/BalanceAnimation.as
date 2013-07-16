package {
	
	import flash.utils.setTimeout;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.pixelmask.PixelMaskDisplayObject;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class BalanceAnimation extends Sprite {
		
		[Embed(source="../assets/blurNums.png"), mimeType="image/png")]
		private static const NumClass:Class;
		
		[Embed(source="../assets/stardustCoin.png")]
		private static const CoinClass:Class;
		
		private const START_BALANCE:String = "123,456,013";
		private const FINISH_BALANCE:String = "3,523";
		
		private var balance:TextField;
		private var balanceString:String;
		private var balanceLength:int;
		
		private var maskedObj:PixelMaskDisplayObject;
		private var blurContainer:Sprite;
		private var blurNumArr:Array = [];
		private var blurTexture:Texture;
		
		private var charXPos:int;
		private var charYPos:int;
		private var blurYPos:int;
		private var charDowncount:int;
		
		private var coinContainer:Sprite;
		private var coinTexture:Texture;
		private var coinImg:Image;

		public function BalanceAnimation() {
			var balanceContainer:Sprite = new Sprite();
			balance = new TextField(200, 25, START_BALANCE, "Calibri", 19, 0xffffff, true);
			balance.hAlign = "right";
			balanceContainer.addChild(balance);
			
			addCoin();
			
			if (START_BALANCE.length > FINISH_BALANCE.length) {
				this.balanceString = START_BALANCE;
			} else {
				this.balanceString = FINISH_BALANCE;
			}
			
			this.addChild(balanceContainer);
			
			setTimeout(startEff, 2000);
		}
		
		public function clear():void {
			this.blurTexture.dispose();
			this.blurTexture.base.dispose();
			
			for (var i:int = 0; i < this.blurNumArr.length; i++) {
				this.maskedObj.removeChild(this.blurNumArr[i]);
				this.blurNumArr[i].clear();
				this.blurNumArr[i].dispose;
			}
			
			this.removeChild(this.maskedObj);
			this.maskedObj.dispose();
			
			this.addChild(this.coinContainer);
		}
		
		private function addCoin():void {
			this.coinContainer = new Sprite();
			
			this.coinTexture = Texture.fromBitmap(new CoinClass());
			this.coinImg = new Image(this.coinTexture);
			
			updateCoinPosition();
			
			this.coinContainer.addChild(this.coinImg);
			this.addChild(this.coinContainer);
		}
		
		private function updateCoinPosition():void {
			var xPos:int = this.balance.width - this.balance.textBounds.width;
			this.coinContainer.x = xPos - coinImg.width - 10;
			this.coinContainer.y = 0;
			
			this.coinContainer.pivotX = this.coinImg.width >> 1;
			this.coinContainer.pivotY = this.coinImg.height >> 1;
			this.coinContainer.x += this.coinImg.width >> 1;
			this.coinContainer.y += this.coinImg.height >> 1;
		}
		
		private function startEff():void {
			this.blurContainer = new Sprite();
			
			this.maskedObj = new PixelMaskDisplayObject();
			this.maskedObj.y = 6;
			var mask:Quad = new Quad(200, 15, 0xff0000, false);
			this.maskedObj.mask = mask;
			
			this.blurTexture = Texture.fromBitmap(new NumClass());
			
			this.blurContainer.addChild(maskedObj);
			this.addChild(this.blurContainer);
			
			this.balanceLength = this.balanceString.length;
			
			this.charDowncount = this.balanceLength;
			this.charXPos = this.balance.bounds.width;
			this.charYPos = -1 * blurTexture.height + 20;
			this.blurYPos = -1 * blurTexture.height + 20;
			
			addBlurChar();
			removeCoinAnim();
			
			this.addEventListener(Event.ENTER_FRAME, tweenProgress);
		}
		
		private function removeCoinAnim():void {
			var tween:Tween = new Tween(this.coinContainer, .3, Transitions.EASE_IN_BACK);
			tween.animate("scaleX", 0);
			tween.animate("scaleY", 0);
			tween.animate("rotation", -2 * Math.PI);
			
			Starling.juggler.add(tween);
		}
		
		private function addCoinAnim():void {
			updateCoinPosition();
			
			var tween:Tween = new Tween(this.coinContainer, .3, Transitions.EASE_OUT_BACK);
			tween.animate("scaleX", 1);
			tween.animate("scaleY", 1);
			Starling.juggler.add(tween);
		}
		
		private function addBlurChar():void {
			var currentCharWidth:int = getWidth(this.balanceString.charAt(this.charDowncount));
			this.charXPos -= currentCharWidth;
			
			var effBalanceNum:BalanceNum = new BalanceNum(blurTexture, currentCharWidth, blurYPos, this.charYPos);
			effBalanceNum.x = this.charXPos;
			
			maskedObj.addChild(effBalanceNum);
			this.blurNumArr.push(effBalanceNum);
			
			charYPos += blurTexture.height * (1 / balanceLength);
			
			if (--this.charDowncount) {
				setTimeout(addBlurChar, 30);
			} else {
				balance.text = "" + FINISH_BALANCE;
			}
		}
		
		private function getWidth(char:String):int {
			var result:int = 10;
			
			if (char == "3") {
				result = 9;
			} else if (char == "4") {
				result = 11;
			} else if (char == ",") {
				result = 6;
			}
			
			return result;
		}
		
		private function tweenProgress(e:Event):void {
			var left:int = 0;
			for (var i:int = 0; i < this.blurNumArr.length; i++) {
				var balanceNum:BalanceNum = this.blurNumArr[i] as BalanceNum;
				
				if (balanceNum.updateAnim(3)) {
					left++;
				}
			}
			
			if (left == 0) {
				this.removeEventListener(Event.ENTER_FRAME, tweenProgress);
				clear();
				
				addCoinAnim();
			}
		}
	}
}