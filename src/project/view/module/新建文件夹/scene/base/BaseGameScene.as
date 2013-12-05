package project.view.module.scene.base
{
    import project.config.*;
    import project.controller.*;
    import project.core.*;
    import project.model.*;
    import project.model.item.*;
    import project.view.base.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class BaseGameScene extends BaseSpritePane
    {
        private var _sceneId:int = -1;//场景ID
        protected var rubishMc:MovieClip;//要动态显示的模块
        protected var rubishPosArr:Array;//模块坐标数据

        public function BaseGameScene(param1:DisplayObjectContainer = null)
        {
            this.rubishPosArr = [[30, 0], [0, 0], [0, 0]];
            super(param1);
            return;
        }// end function

        protected function refreshRubish(param1:int = 0) : void
        {
            /*var _loc_2:int = 1;
            if (param1 == 1 || param1 == 3)
            {
                _loc_2 = 1;
            }
            if (param1 == 5 || param1 == 7)
            {
                _loc_2 = 2;
            }
            if (param1 == 9)
            {
                _loc_2 = 3;
            }
            var _loc_3:String = "HD_0_0";
            this.checkRubishPosition(_loc_2);
            this.addRubish(_loc_3);
            return;*/
        }// end function

        protected function checkRubishPosition(param1:int = 0) : void
        {
            return;
        }// end function

        protected function addRubish(param1:String) : void
        {
            /*this.clearRubish();
            var _loc_2:* = SMZTResourceManager.getInstance().getRes(param1);
            this.rubishMc.addChild(_loc_2);
            return;*/
        }// end function

        protected function clearRubish() : void
        {
			if (!rubishMc) return;
            while (this.rubishMc.numChildren)
            {
                
                this.rubishMc.removeChildAt(0);
            }
            return;
        }// end function

        private function gatherRubish(event:MouseEvent) : void
        {
            /*if ((this.rubishMc.getChildAt(0) as MovieClip).currentFrame != 1)
            {
                return;
            }
            SMZTController.getInstance().friendGather(ModelLocator.getInstance().currentUId, this._sceneId, this.gatherCallBack);
            (this.rubishMc.getChildAt(0) as MovieClip).gotoAndPlay(2);
            this.playUISound("TREASURE_BOX");
            return;*/
        }// end function

        /*private function gatherCallBack(param1:XML) : void
        {
            var xd:XML;
            var pId:int;
            var value:int;
            var sName:String;
            var itemId:int;
            var category:int;
            var im:ItemModel;
            var callBackXML:* = param1;
            var str:String;
            var _loc_3:int = 0;
            var _loc_4:* = callBackXML.Items.Item;
            while (_loc_4 in _loc_3)
            {
                
                xd = _loc_4[_loc_3];
                pId = xd.@PropId;
                value = xd.@Amount;
                sName;
                if (pId < 0)
                {
                    if (pId == -1)
                    {
                        sName;
                        str = str + (" " + sName + " " + value + "点 ");
                        SMZTUIManager.getInstance().mainPane.playExpGetAnime(value, 360, 400);
                    }
                    if (pId == -2)
                    {
                        sName;
                        str = str + (" " + sName + " " + value + "枚 ");
                        SMZTUIManager.getInstance().mainPane.playSilverGetAnime(value, 360, 400);
                    }
                    continue;
                }
                var _loc_6:int = 0;
                var _loc_7:* = ItemConfig.ITEM_CONFIG.Prop;
                var _loc_5:* = new XMLList("");
                for each (_loc_8 in _loc_7)
                {
                    
                    var _loc_9:* = _loc_7[_loc_6];
                    with (_loc_7[_loc_6])
                    {
                        if (@Id == pId)
                        {
                            _loc_5[_loc_6] = _loc_8;
                        }
                    }
                }
                itemId = _loc_5.@Addon;
                var _loc_6:int = 0;
                var _loc_7:* = ItemConfig.ITEM_CONFIG.Prop;
                var _loc_5:* = new XMLList("");
                for each (_loc_8 in _loc_7)
                {
                    
                    var _loc_9:* = _loc_7[_loc_6];
                    with (_loc_7[_loc_6])
                    {
                        if (@Id == pId)
                        {
                            _loc_5[_loc_6] = _loc_8;
                        }
                    }
                }
                category = _loc_5.@Type;
                if (category > 3)
                {
                    category;
                    itemId = pId;
                }
                im = ItemBuilder.createItem(category, itemId, 0, itemId);
                sName = im.name;
                str = str + (" " + sName + "×" + value);
                im.number = value;
                GetPrizePane.getInstance().showItem(im, new Point(350, 400));
            }
            return;
        }// end function*/

        public function get sceneId() : int
        {
            return this._sceneId;
        }// end function

        public function set sceneId(param1:int) : void
        {
            this._sceneId = param1;
            return;
        }// end function

        override public function setSpriteInstance(param1:String) : void
        {
            while (instanceLayer.numChildren > 0)
            {
                
                instanceLayer.removeChildAt(0);
            }
            _spriteInstance = SMZTResourceManager.getInstance().getRes(param1, SMZTDomainManager.getInstance().currentUIAppDomain) as Sprite;
            instanceLayer.addChild(_spriteInstance);
            helpBtn = getChild("helpb") as MovieClip;
            if (helpBtn != null)
            {
                helpBtn.gotoAndStop(1);
                helpBtn.buttonMode = true;
                helpBtn.addEventListener(MouseEvent.MOUSE_OVER, showHelp);
                helpBtn.addEventListener(MouseEvent.MOUSE_OUT, showHelp);
            }
            this.rubishMc = getChild("rb") as MovieClip;
            if (this.rubishMc)
            {
                this.rubishMc.buttonMode = true;
                this.rubishMc.addEventListener(MouseEvent.CLICK, this.gatherRubish);
            }
            return;
        }// end function

    }
}
