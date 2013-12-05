package project.view.module.enhance
{
    import project.controller.*;
    
    import project.model.item.*;
    import project.view.artplug.*;
    import project.view.base.*;
    import flash.events.*;

    public class DigStonePane extends BaseTitleWindow
    {
        private var _index:int = 0;
        private var _weapon:ItemModel;
        private static var dsp:DigStonePane;

        public function DigStonePane(param1:Boolean = true)
        {
            super(param1);
            if (dsp)
            {
                throw new Error("Error");
            }
            setSpriteInstance("DigStonePane");
            (getChild("dg") as MovieClipButton).onClick = this.removeBys;
            (getChild("ds") as MovieClipButton).onClick = this.removeByg;
            return;
        }// end function

        private function removeByg(event:MouseEvent) : void
        {
            SMZTController.getInstance().discardWeaponStone(this._weapon as EquipItem, this._index, 1, this.onDiscard);
            return;
        }// end function

        private function onDiscard(param1:XML) : void
        {
            hide();
            StoneBagPane.getInstance().mosaicPane["dig" + this._index.toString()].gotoAndPlay(2);
            return;
        }// end function

        private function removeBys(event:MouseEvent) : void
        {
            SMZTController.getInstance().discardWeaponStone(this._weapon as EquipItem, this._index, 0, this.onDiscard);
            return;
        }// end function

        public function get weapon() : ItemModel
        {
            return this._weapon;
        }// end function

        public function set weapon(param1:ItemModel) : void
        {
            this._weapon = param1;
            return;
        }// end function

        public function get index() : int
        {
            return this._index;
        }// end function

        public function set index(param1:int) : void
        {
            this._index = param1;
            return;
        }// end function

        public static function getInstance() : DigStonePane
        {
            if (!dsp)
            {
                dsp = new DigStonePane;
            }
            return dsp;
        }// end function

    }
}
