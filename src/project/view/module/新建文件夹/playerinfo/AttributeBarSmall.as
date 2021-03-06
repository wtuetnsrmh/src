﻿package project.view.module.playerinfo
{
    import project.model.*;
    import project.utils.*;
    import project.view.base.*;
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;

    public class AttributeBarSmall extends BaseSprite
    {
        private var mask2:Sprite;
        private var mask1:Sprite;
        private var collumn2:MovieClip;
        private var collumn1:MovieClip;
        private var textMCs:Sprite;
        private var instance:Sprite;

        public function AttributeBarSmall()
        {
            this.instance = Reflection.createDisplayObjectInstance("AttributeBarSmall", ApplicationDomain.currentDomain) as Sprite;
            addChild(this.instance);
            this.mask2 = this.instance["mask_2"] as Sprite;
            this.mask1 = this.instance["mask_1"] as Sprite;
            this.collumn2 = this.instance["collumn_2"] as MovieClip;
            this.collumn1 = this.instance["collumn_1"] as MovieClip;
            this.textMCs = this.instance["textMC"] as Sprite;
            this.collumn1.stop();
            this.collumn2.stop();
            this.showCollumn();
            this.addEventListener(MouseEvent.MOUSE_OUT, this.mouseHandler);
            this.addEventListener(MouseEvent.MOUSE_OVER, this.mouseHandler);
            return;
        }// end function

        public function setDirectText(param1:String) : void
        {
            this.textMCs["valueTxt"].text = String(param1);
            return;
        }// end function

        public function setValue(param1:uint) : void
        {
            this.textMCs["valueTxt"].text = String(param1);
            var _loc_2:* = param1 / 100;
            var _loc_3:* = param1 % 100;
            if (_loc_2 >= 1)
            {
                (this.mask1 as MovieClip).gotoAndStop(100);
            }
            else
            {
                (this.mask1 as MovieClip).gotoAndStop(1);
            }
            (this.mask2 as MovieClip).gotoAndStop(int(_loc_3));
            this.collumn1.gotoAndStop(_loc_2);
            this.collumn2.gotoAndStop(Math.floor((_loc_2 + 1)));
            return;
        }// end function

        public function setPlus(param1:uint) : void
        {
            return;
        }// end function

        private function mouseHandler(event:MouseEvent) : void
        {
            if (event.type == MouseEvent.MOUSE_OVER)
            {
                this.showText();
            }
            else
            {
                this.showCollumn();
            }
            return;
        }// end function

        public function showText() : void
        {
            if (ModelLocator.getInstance().currentUId != ModelLocator.getInstance().uId)
            {
                return;
            }
            this.textMCs.visible = true;
            this.collumn1.visible = false;
            this.collumn2.visible = false;
            return;
        }// end function

        public function showCollumn() : void
        {
            this.textMCs.visible = false;
            this.collumn1.visible = true;
            this.collumn2.visible = true;
            return;
        }// end function

    }
}
