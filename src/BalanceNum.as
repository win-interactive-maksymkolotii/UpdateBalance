package {
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class BalanceNum extends Sprite {

		private var numBG:Quad;

		private var blurNumImg:Image;
		private var startYPos:int;
		private var yPos:int;
		
		private var totalAnim:int; // total anim moving
		private var finalAnim:int; // when we'd stop
		
		public function BalanceNum(texture:Texture, charWidth:int, startYPos:int, yPos:int) {
			this.startYPos = startYPos;
			this.yPos = yPos;
			this.finalAnim = 2 * texture.height + this.yPos;
			
			this.blurNumImg = new Image(texture);
			this.blurNumImg.y = yPos;
			
			numBG = new Quad(charWidth, 25, 0x000000, true);
			this.numBG.x = blurNumImg.x;
			
			this.addChild(this.numBG);
			this.addChild(this.blurNumImg);
		}
		
		public function updateAnim(delY:int):Boolean {
			this.blurNumImg.y += delY;
			this.totalAnim += delY;
			
			if (this.blurNumImg.y > 10) {
				this.blurNumImg.y = startYPos;
			}
			
			if (this.totalAnim > this.finalAnim) {
				hideBG();
				hideNum();
				
				return false;
			}
			
			return true;
		}
		
		public function hideBG():void {
			this.numBG.visible = false;
		}
		
		public function hideNum():void {
			this.blurNumImg.visible = false;
		}
	}
}