package {
	
	import flash.utils.clearTimeout;
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
		
		private var balanceField:TextField;// main textfield
		private var checkChar:TextField;// textfield for char width checking
		
		private var startBalance:String;
		private var finishBalance:String;  
		private var balanceString:String;
		private var balanceLength:int;
		
		private var isAnimated:Boolean;
		
		private var maskedObj:PixelMaskDisplayObject;
		private var mask:Quad;
		
		private var blurContainer:Sprite;
		private var blurNumArr:Vector.<BlurChar>;
		private var blurTexture:Texture;
		private var addBlurCharTimer:int;
		
		private var charXPos:int;
		private var blurYPos:int;
		private var blurStartYPos:int;// 
		private var charDowncount:int;
		
		private var coinContainer:Sprite;
		private var coinImg:Image;

		public function BalanceAnimation(balance:TextField, startBalance:String) {
			this.startBalance = startBalance;
			this.balanceField = balance;
			
			var balanceContainer:Sprite = new Sprite();
			balanceContainer.addChild(balance);
			this.addChild(balanceContainer);
			
			checkChar = new TextField(200, 25, startBalance, "Calibri", 19, 0xffffff, true);
			this.blurNumArr = new Vector.<BlurChar>();
		}
		
		public function addCoin(coin:Image):void {
			this.coinContainer = new Sprite();
			
			this.coinImg = coin;
			
			updateCoinPosition();
			
			this.coinContainer.addChild(this.coinImg);
			this.addChild(this.coinContainer);
		}
		
		public function showAnimation(finishBalance:String):void {
			if (this.isAnimated) {
				clear();
			}
			
			this.finishBalance = finishBalance;
			
			selectBiggestString();
			
			craeteBlurTexture();
			createMaskObject();
			createBlurContainer();
			
			setStartValues();
			addBlurChar();
			hideCoinAnim();
			
			this.isAnimated = true;
			this.addEventListener(Event.ENTER_FRAME, tweenProgress);
		}
		
		private function selectBiggestString():void {
			if (this.startBalance.length > this.finishBalance.length) {
				this.balanceString = startBalance;
			} else {
				this.balanceString = finishBalance;
			}
		}

		private function craeteBlurTexture():void {
			this.blurTexture = Texture.fromBitmap(new NumClass());
		}
		
		private function createMaskObject():void {
			this.maskedObj = new PixelMaskDisplayObject();
			this.maskedObj.y = 6;
			this.mask = new Quad(this.balanceField.width, 15, 0xff0000, false);
			this.maskedObj.mask = this.mask;
		}
		
		private function createBlurContainer():void {
			this.blurContainer = new Sprite();
			this.blurContainer.addChild(maskedObj);
			this.addChild(this.blurContainer);			
		}
		
		private function setStartValues():void {
			this.balanceLength = this.balanceString.length;
			
			this.charDowncount = this.balanceLength - 1;
			this.charXPos = this.balanceField.bounds.width - 3;
			
			this.blurYPos = this.blurStartYPos = -1 * blurTexture.height + 20;
		}
		
		private function updateCoinPosition():void {
			var xPos:int = this.balanceField.width - this.balanceField.textBounds.width;
			this.coinContainer.x = xPos - coinImg.width - 10;
			this.coinContainer.y = 0;
			
			this.coinContainer.pivotX = this.coinImg.width >> 1;
			this.coinContainer.pivotY = this.coinImg.height >> 1;
			this.coinContainer.x += this.coinImg.width >> 1;
			this.coinContainer.y += this.coinImg.height >> 1;
		}
		
		private function hideCoinAnim():void {
			var tween:Tween = new Tween(this.coinContainer, .3, Transitions.EASE_IN_BACK);
			tween.animate("scaleX", 0);
			tween.animate("scaleY", 0);
			tween.animate("rotation", -2 * Math.PI);
			
			Starling.juggler.add(tween);
		}
		
		private function showCoinAnim():void {
			updateCoinPosition();
			
			var tween:Tween = new Tween(this.coinContainer, .3, Transitions.EASE_OUT_BACK);
			tween.animate("scaleX", 1);
			tween.animate("scaleY", 1);
			Starling.juggler.add(tween);
		}
		
		private function addBlurChar():void {
			var currentCharWidth:int = getWidth(this.balanceString.charAt(this.charDowncount));
			this.charXPos -= currentCharWidth;
			
			var effBalanceNum:BlurChar = new BlurChar(this.blurTexture, currentCharWidth, this.blurStartYPos, this.blurYPos);
			effBalanceNum.x = this.charXPos;
			
			maskedObj.addChild(effBalanceNum);
			this.blurNumArr.push(effBalanceNum);
			
			blurYPos += blurTexture.height * (1 / balanceLength);
			
			if (this.charDowncount--) {
				this.addBlurCharTimer = setTimeout(addBlurChar, 30);
			} else {
				this.startBalance = this.finishBalance;
				balanceField.text = "" + finishBalance;
			}
		}
		
		private function getWidth(char:String):int {
			this.checkChar.text = char;
			return this.checkChar.textBounds.width;
		}
		
		private function clear():void {
			this.blurTexture.dispose();
			this.blurTexture.base.dispose();
			
			for (var i:int = 0; i < this.blurNumArr.length; i++) {
				this.maskedObj.removeChild(this.blurNumArr[i]);
				this.blurNumArr[i].clear();
				this.blurNumArr[i].dispose;
			}
			
			this.removeChild(this.maskedObj);
			
			while (this.maskedObj.numChildren) {
				this.maskedObj.removeChildAt(0).dispose();
			}
			
			this.checkChar.dispose();
			
			this.maskedObj.mask = null;
			this.maskedObj.dispose();
			
			this.blurContainer.dispose();
			this.removeChild(this.blurContainer);
			
			clearTimeout(this.addBlurCharTimer);
			this.removeEventListener(Event.ENTER_FRAME, tweenProgress);
		}
		
		private function tweenProgress(e:Event):void {
			var updateCount:int = 0;
			for (var i:int = 0; i < this.blurNumArr.length; i++) {
				var balanceNum:BlurChar = this.blurNumArr[i] as BlurChar;
				
				if (balanceNum.updateAnim(3)) {
					updateCount++;
				}
			}
			
			if (updateCount == 0) {
				this.isAnimated = false;
				this.removeEventListener(Event.ENTER_FRAME, tweenProgress);
				
				showCoinAnim();
				clear();
			}
		}
	}
}