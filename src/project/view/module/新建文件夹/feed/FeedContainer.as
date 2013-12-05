package project.view.module.feed
{
    import __AS3__.vec.*;
    import project.view.base.*;
    import project.view.layout.*;

    public class FeedContainer extends BaseSprite
    {
        private var feedContainer:BaseGridContainer;
        private var _boxVector:Vector.<FeedIcoBox>;

        public function FeedContainer()
        {
            this._boxVector = new Vector.<FeedIcoBox>;
            this.feedContainer = new BaseGridContainer(5, 1, 5, 400, 50);
            addChild(this.feedContainer);
            this.draw();
            return;
        }// end function

        private function draw() : void
        {
            var _loc_2:FeedIcoBox = null;
            var _loc_1:int = 0;
            while (_loc_1 < 5)
            {
                
                _loc_2 = new FeedIcoBox();
                _loc_2.name = "fib" + _loc_1;
                this._boxVector.push(_loc_2);
                this.feedContainer.appendChild(_loc_2);
                _loc_1++;
            }
            return;
        }// end function

        public function setFeedData(param1:Object) : void
        {
            return;
        }// end function

        public function refreshFeedData(param1:int, param2:Array) : void
        {
            var _loc_3:int = 0;
            while (_loc_3 < this._boxVector.length)
            {
                
                this._boxVector[_loc_3].clearStatus();
                _loc_3++;
            }
            var _loc_4:* = param1;
            while (_loc_4 < param1 + 5)
            {
                
                if (_loc_4 > (param2.length - 1))
                {
                    return;
                }
                this._boxVector[_loc_4 - param1].setData(param2[_loc_4]);
                _loc_4++;
            }
            return;
        }// end function

        public function get boxVector() : Vector.<FeedIcoBox>
        {
            return this._boxVector;
        }// end function

        public function set boxVector(param1:Vector.<FeedIcoBox>) : void
        {
            this._boxVector = param1;
            return;
        }// end function

    }
}
