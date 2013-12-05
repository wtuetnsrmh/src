package project.view.module.playerinfo
{
	/*
	* 描述：修改属性面板
	* 
	*/
    import project.config.*;
    import project.controller.*;
    import project.model.*;
    import project.model.data.*;
    import project.model.item.*;
    import project.view.artplug.*;
    import project.view.base.*;
    import project.view.module.shop.*;
    import flash.display.*;
    import flash.events.*;

    public class ModifyElementPane extends BaseTitleWindow
    {
        private var currentSelectedEle:int = -1;
        private var confirmBtn:MovieClipButton;
        private var cancelBtn:MovieClipButton;
        private var ele0:MovieClip;
        private var ele1:MovieClip;
        private var ele2:MovieClip;
        private var ele3:MovieClip;
        private var ele4:MovieClip;
        private var arr0:MovieClip;
        private var arr1:MovieClip;
        private var arr2:MovieClip;
        private var arr3:MovieClip;
        private var arr4:MovieClip;
        private var circleMc:MovieClip;
        private static var modifyElementPane:ModifyElementPane;

        public function ModifyElementPane()
        {
            if (modifyElementPane != null)
            {
                throw new Error("Error");
            }
            setSpriteInstance("ModifyElementPane");
            this.configerUIInstance();
            dragable = false;
            this.initFirst();
            return;
        }// end function

        override protected function onRemoveFromStage(event:Event) : void
        {
            this.currentSelectedEle = -1;
            this.ele0.gotoAndStop(1);
            this.ele1.gotoAndStop(1);
            this.ele2.gotoAndStop(1);
            this.ele3.gotoAndStop(1);
            this.ele4.gotoAndStop(1);
            this.arr0.visible = false;
            this.arr1.visible = false;
            this.arr2.visible = false;
            this.arr3.visible = false;
            this.arr4.visible = false;
            this.circleMc.gotoAndStop(1);
            return;
        }// end function

        override protected function onAddToStage(event:Event) : void
        {
            this.initFirst();
            return;
        }// end function

        private function configerUIInstance() : void
        {
            this.ele0 = getChild("e0") as MovieClip;
            this.ele1 = getChild("e1") as MovieClip;
            this.ele2 = getChild("e2") as MovieClip;
            this.ele3 = getChild("e3") as MovieClip;
            this.ele4 = getChild("e4") as MovieClip;
            this.ele0.gotoAndStop(1);
            this.ele1.gotoAndStop(1);
            this.ele2.gotoAndStop(1);
            this.ele3.gotoAndStop(1);
            this.ele4.gotoAndStop(1);
            this.ele0.addEventListener(MouseEvent.CLICK, this.elementClick);
            this.ele1.addEventListener(MouseEvent.CLICK, this.elementClick);
            this.ele2.addEventListener(MouseEvent.CLICK, this.elementClick);
            this.ele3.addEventListener(MouseEvent.CLICK, this.elementClick);
            this.ele4.addEventListener(MouseEvent.CLICK, this.elementClick);
            this.ele0.addEventListener(MouseEvent.MOUSE_OUT, this.starMCRoll);
            this.ele1.addEventListener(MouseEvent.MOUSE_OUT, this.starMCRoll);
            this.ele2.addEventListener(MouseEvent.MOUSE_OUT, this.starMCRoll);
            this.ele3.addEventListener(MouseEvent.MOUSE_OUT, this.starMCRoll);
            this.ele4.addEventListener(MouseEvent.MOUSE_OUT, this.starMCRoll);
            this.ele0.addEventListener(MouseEvent.MOUSE_OVER, this.starMCRoll);
            this.ele1.addEventListener(MouseEvent.MOUSE_OVER, this.starMCRoll);
            this.ele2.addEventListener(MouseEvent.MOUSE_OVER, this.starMCRoll);
            this.ele3.addEventListener(MouseEvent.MOUSE_OVER, this.starMCRoll);
            this.ele4.addEventListener(MouseEvent.MOUSE_OVER, this.starMCRoll);
            this.ele0.buttonMode = true;
            this.ele1.buttonMode = true;
            this.ele2.buttonMode = true;
            this.ele3.buttonMode = true;
            this.ele4.buttonMode = true;
            this.arr0 = getChild("a0") as MovieClip;
            this.arr1 = getChild("a1") as MovieClip;
            this.arr2 = getChild("a2") as MovieClip;
            this.arr3 = getChild("a3") as MovieClip;
            this.arr4 = getChild("a4") as MovieClip;
            this.arr0.visible = false;
            this.arr1.visible = false;
            this.arr2.visible = false;
            this.arr3.visible = false;
            this.arr4.visible = false;
            this.circleMc = getChild("sc") as MovieClip;
            this.circleMc.gotoAndStop(1);
            this.confirmBtn = getChild("confirm") as MovieClipButton;
            this.cancelBtn = getChild("cancel") as MovieClipButton;
            this.confirmBtn.addEventListener(MouseEvent.CLICK, this.onRefreshElClick);
            this.cancelBtn.addEventListener(MouseEvent.CLICK, hide);
            return;
        }// end function

        private function starMCRoll(event:MouseEvent) : void
        {
            if (event.type == MouseEvent.MOUSE_OUT)
            {
            }
            return;
        }// end function

        private function initFirst() : void
        {
            switch(PlayerData.getInstance().element)
            {
                case 0:
                {
                    this.currentSelectedEle = 0;
                    this.ele0.gotoAndStop(2);
                    this.ele1.gotoAndStop(1);
                    this.ele2.gotoAndStop(1);
                    this.ele3.gotoAndStop(1);
                    this.ele4.gotoAndStop(1);
                    this.arr0.visible = true;
                    this.arr1.visible = false;
                    this.arr2.visible = false;
                    this.arr3.visible = false;
                    this.arr4.visible = false;
                    break;
                }
                case 1:
                {
                    this.currentSelectedEle = 1;
                    this.ele0.gotoAndStop(1);
                    this.ele1.gotoAndStop(2);
                    this.ele2.gotoAndStop(1);
                    this.ele3.gotoAndStop(1);
                    this.ele4.gotoAndStop(1);
                    this.arr0.visible = false;
                    this.arr1.visible = true;
                    this.arr2.visible = false;
                    this.arr3.visible = false;
                    this.arr4.visible = false;
                    break;
                }
                case 2:
                {
                    this.currentSelectedEle = 2;
                    this.ele0.gotoAndStop(1);
                    this.ele1.gotoAndStop(1);
                    this.ele2.gotoAndStop(2);
                    this.ele3.gotoAndStop(1);
                    this.ele4.gotoAndStop(1);
                    this.arr0.visible = false;
                    this.arr1.visible = false;
                    this.arr2.visible = true;
                    this.arr3.visible = false;
                    this.arr4.visible = false;
                    break;
                }
                case 3:
                {
                    this.currentSelectedEle = 3;
                    this.ele0.gotoAndStop(1);
                    this.ele1.gotoAndStop(1);
                    this.ele2.gotoAndStop(1);
                    this.ele3.gotoAndStop(2);
                    this.ele4.gotoAndStop(1);
                    this.arr0.visible = false;
                    this.arr1.visible = false;
                    this.arr2.visible = false;
                    this.arr3.visible = true;
                    this.arr4.visible = false;
                    break;
                }
                case 4:
                {
                    this.currentSelectedEle = 4;
                    this.ele0.gotoAndStop(1);
                    this.ele1.gotoAndStop(1);
                    this.ele2.gotoAndStop(1);
                    this.ele3.gotoAndStop(1);
                    this.ele4.gotoAndStop(2);
                    this.arr0.visible = false;
                    this.arr1.visible = false;
                    this.arr2.visible = false;
                    this.arr3.visible = false;
                    this.arr4.visible = true;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function elementClick(event:MouseEvent) : void
        {
            trace(event.currentTarget);
            switch(event.currentTarget)
            {
                case this.ele0:
                {
                    this.currentSelectedEle = 0;
                    this.ele0.gotoAndStop(2);
                    this.ele1.gotoAndStop(1);
                    this.ele2.gotoAndStop(1);
                    this.ele3.gotoAndStop(1);
                    this.ele4.gotoAndStop(1);
                    this.arr0.visible = true;
                    this.arr1.visible = false;
                    this.arr2.visible = false;
                    this.arr3.visible = false;
                    this.arr4.visible = false;
                    break;
                }
                case this.ele1:
                {
                    this.currentSelectedEle = 1;
                    this.ele0.gotoAndStop(1);
                    this.ele1.gotoAndStop(2);
                    this.ele2.gotoAndStop(1);
                    this.ele3.gotoAndStop(1);
                    this.ele4.gotoAndStop(1);
                    this.arr0.visible = false;
                    this.arr1.visible = true;
                    this.arr2.visible = false;
                    this.arr3.visible = false;
                    this.arr4.visible = false;
                    break;
                }
                case this.ele2:
                {
                    this.currentSelectedEle = 2;
                    this.ele0.gotoAndStop(1);
                    this.ele1.gotoAndStop(1);
                    this.ele2.gotoAndStop(2);
                    this.ele3.gotoAndStop(1);
                    this.ele4.gotoAndStop(1);
                    this.arr0.visible = false;
                    this.arr1.visible = false;
                    this.arr2.visible = true;
                    this.arr3.visible = false;
                    this.arr4.visible = false;
                    break;
                }
                case this.ele3:
                {
                    this.currentSelectedEle = 3;
                    this.ele0.gotoAndStop(1);
                    this.ele1.gotoAndStop(1);
                    this.ele2.gotoAndStop(1);
                    this.ele3.gotoAndStop(2);
                    this.ele4.gotoAndStop(1);
                    this.arr0.visible = false;
                    this.arr1.visible = false;
                    this.arr2.visible = false;
                    this.arr3.visible = true;
                    this.arr4.visible = false;
                    break;
                }
                case this.ele4:
                {
                    this.currentSelectedEle = 4;
                    this.ele0.gotoAndStop(1);
                    this.ele1.gotoAndStop(1);
                    this.ele2.gotoAndStop(1);
                    this.ele3.gotoAndStop(1);
                    this.ele4.gotoAndStop(2);
                    this.arr0.visible = false;
                    this.arr1.visible = false;
                    this.arr2.visible = false;
                    this.arr3.visible = false;
                    this.arr4.visible = true;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onRefreshElClick(event:MouseEvent) : void
        {
            if (this.currentSelectedEle < 0 || PlayerData.getInstance().element == this.currentSelectedEle)
            {
                hide();
                return;
            }
            SMZTController.getInstance().checkHasItem(PropConfig["REFRESH_ELEMENT_" + this.currentSelectedEle], this.onCheckBack);
            return;
        }// end function

        private function onCheckBack(param1:XML) : void
        {
            var _loc_2:ItemModel = null;
            var _loc_3:ItemModel = null;
            if (param1.hasOwnProperty("UserPackage"))
            {
                _loc_2 = ItemBuilder.createItem(ItemCategory.ITEM, param1.UserPackage.@ItemId, 0, param1.UserPackage.@ItemId);
                _loc_2.itemId = param1.UserPackage.@ItemId;
                _loc_2.sId = param1.UserPackage.@Id;
                QuickPurchasePane.getInstance().mode = 1;
                QuickPurchasePane.getInstance().itemModel = _loc_2;
                QuickPurchasePane.getInstance().show(true);
            }
            else
            {
                _loc_3 = ItemBuilder.createItem(ItemCategory.ITEM, param1.Offer.@PropId, 0, param1.Offer.@PropId);
                _loc_3.sId = param1.Offer.@Id;
                _loc_3.shopPrice = param1.Offer.@Silver;
                _loc_3.shopPriceRMB = param1.Offer.@Gold;
                if (param1.Offer.@VipSale > 0)
                {
                    _loc_3.shopDiscountRMB = param1.Offer.@VipSale;
                }
                QuickPurchasePane.getInstance().mode = 0;
                QuickPurchasePane.getInstance().itemModel = _loc_3;
                QuickPurchasePane.getInstance().show(true);
            }
            hide();
            return;
        }// end function

        public static function getInstance() : ModifyElementPane
        {
            if (modifyElementPane == null)
            {
                modifyElementPane = new ModifyElementPane;
            }
            return modifyElementPane;
        }// end function

    }
}
