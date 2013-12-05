package project.view.module.feed
{
    import project.config.*;
    import project.core.*;
    import project.model.*;
    import project.view.artplug.*;
    import project.view.base.*;
    import project.view.module.cell.*;
    import project.view.module.lotterypane.*;
    import project.view.module.playerinfo.*;
    
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    public class FeedIcoBox extends BaseSpritePane
    {
        private var timeText:TextField;
        private var feedText:TextField;
        private var watchFightBtn:MovieClipButton;
        private var lotteryBtn:MovieClipButton;
        private var lotterId:String;
        private var battleId:String;
        private var opUId:int;
        private var icoBox:BaseIcoCell;
        private var feedMc:MovieClip;
        private var icoFeedData:Object;

        public function FeedIcoBox()
        {
            setSpriteInstance("FeedIcoBox");
            this.icoBox = new BaseIcoCell();
            this.icoBox.showBg = false;
            addChild(this.icoBox);
            this.configerUIInstance();
            this.clearStatus();
            return;
        }// end function

        private function configerUIInstance() : void
        {
            this.timeText = getChild("time") as TextField;
            this.feedText = getChild("battle") as TextField;
            this.watchFightBtn = getChild("watch") as MovieClipButton;
            this.lotteryBtn = getChild("lottery") as MovieClipButton;
            this.feedMc = getChild("ftm") as MovieClip;
            this.feedMc.gotoAndStop(1);
            this.watchFightBtn.addEventListener(MouseEvent.CLICK, this.watchFight);
            this.lotteryBtn.addEventListener(MouseEvent.CLICK, this.showLotteryPane);
            this.feedText.addEventListener(TextEvent.LINK, this.onTextLink);
            return;
        }// end function

        public function setData(param1:Object) : void
        {
            this.icoFeedData = param1;
            this.timeText.htmlText = param1.eventTime;
            this.feedText.htmlText = param1.feed;
            this.feedMc.gotoAndStop(int(param1.groupId) + 2);
            if (param1.type == 11)
            {
                if (param1.lottery && param1.lottery > 0)
                {
                    this.lotterId = param1.lottery;
                    this.lotteryBtn.visible = true;
                }
            }
            if (param1.battleId && param1.battleId > 0)
            {
                this.battleId = param1.battleId;
                this.watchFightBtn.visible = true;
            }
            return;
        }// end function

        public function clearStatus() : void
        {
            this.feedMc.gotoAndStop(1);
            this.timeText.text = "";
            this.feedText.text = "";
            this.lotterId = "0";
            this.battleId = "0";
            this.opUId = 0;
            this.lotteryBtn.visible = false;
            this.watchFightBtn.visible = false;
            this.icoFeedData = null;
            return;
        }// end function

        private function onTextLink(event:TextEvent) : void
        {
            var _loc_2:* = event.text;
            PlayerSimplePane.getInstance().show(false);
            PlayerSimplePane.getInstance().setTipData(this.icoFeedData.opUId);
            return;
        }// end function

        private function watchFight(event:MouseEvent) : void
        {
            trace(this.icoFeedData);
            SMZTUIManager.getInstance().mainPane.switchToPlayerMode();
            SMZTPlayer.getInstance().show(true);
            var _loc_2:* = this.icoFeedData.multi == 1 ? (ModelLocator.getInstance().staticURL + "singleplayer_pve.xml") : (ModelLocator.getInstance().staticURL + "singleplayer_pve.xml");
            var _loc_3:* = ModelLocator.getInstance().dynamicURL + ServerParse.FIGHT_HISTORY + "?id=" + this.battleId;
            var _loc_4:* = ModelLocator.getInstance().staticURL + "crossdomain.xml";
            var _loc_5:* = this.icoFeedData.multi;
            SMZTPlayer.getInstance().playerFight(this.battleId, _loc_2, _loc_3, _loc_4, "", _loc_5, 4);
            hide();
            return;
        }// end function

        private function showLotteryPane(event:MouseEvent) : void
        {
            if (this.battleId != "0" && this.lotterId != "0")
            {
                LotteryPane.getInstance().fightId = this.battleId;
                LotteryPane.getInstance().lotteryId = this.lotterId;
                LotteryPane.getInstance().show(true);
            }
            return;
        }// end function

    }
}
