package project.view.module.bagpanel
{
	import project.config.ItemCategory;
	import project.config.SpecialItemIdConfig;
	import project.controller.NewBieControler;
	import project.controller.SMZTController;
	import project.core.SMZTUIManager;
	import project.debug.Debug;
	import project.model.data.BagData;
	import project.model.data.PlayerData;
	import project.model.friends.BonusModel;
	import project.model.item.ItemModel;
	import project.model.longBao.LongBaoModel;
	import project.model.newBie.NewBieModelId;
	import project.model.shop.GoodsModel;
	import project.model.shop.PurchaseType;
	import project.model.shop.ShopModel;
	import project.model.tavern.TavernModel;
	import project.model.training.TrainingModel;
	import project.utils.Browser;
	import project.view.controls.ManageShowBonus;
	import project.view.MainPane;
	import project.view.module.cell.Card;
	import project.view.module.loading.LockScreen;
	import project.view.module.scene.main.MainScene;
	import project.view.module.shop.PurchasePanel;
	import project.view.module.shop.SellPanel;
	
	/**
	 * 使用道具控制类
	 * @author bbjxl 2012
	 */
	public class UseItemControler
	{
		private static var _bonusModle:BonusModel = new BonusModel();
		
		public function UseItemControler()
		{
		
		}
		
		/**
		 * 出售道具
		 * @param	itemId
		 */
		public static function sellItem(item:ItemModel):void
		{
			SellPanel.getInstance().itemModel = item;
			SellPanel.getInstance().show(true);
		}
		
		/**
		 * 显示购买窗口
		 * @param	itemId
		 */
		public static function showBuyWin(itemId:int):void
		{
			//如果商场中没有数据则先加载商场数据
			var temp:PurchasePanel = PurchasePanel.getInstance();
			var tempGoodModel:GoodsModel;
			if (!ShopModel.getInstance().list.length > 0)
			{
				SMZTController.getInstance().getShopGoods(function():void
					{
						tempGoodModel = ShopModel.getInstance().findGoodModelByItemid(itemId);
						if (tempGoodModel == null)
						{
							Debug.log("商场里没有物品：" + itemId);
							return
						}
						;
						tempGoodModel.autoSetPriceType();
						if (tempGoodModel.priceType == PurchaseType.CRYSTAL) {
							//是水晶则直接调JS
							Browser.buyItem(tempGoodModel.id);
							return;
							}else {
								temp.show(true);
								temp.goodModel = tempGoodModel;
								temp = null;
								tempGoodModel = null;
								}
						
					}, true);
			}
			else
			{
				
				tempGoodModel = ShopModel.getInstance().findGoodModelByItemid(itemId);
				if (tempGoodModel == null)
				{
					Debug.log("商场里没有物品：" + itemId);
					return
				}
				;
				tempGoodModel.autoSetPriceType();
				if (tempGoodModel.priceType == PurchaseType.CRYSTAL) {
					//是水晶则直接调JS
					Browser.buyItem(tempGoodModel.id);
					return;
					}else {
						temp.show(true);
						temp.goodModel = tempGoodModel;
						temp = null;
						tempGoodModel = null;
						}
			}
		}
		
		/**
		 * 使用道具前先判断背包中是否有物品，如果没有就提示购买，如果有就回调方法
		 * @param	itemId
		 */
		public static function judgestItemExist(itemId:int, callback:Function = null, noItemCallBack:Function = null):void
		{
			var tempItem:ItemModel = BagData.getInstance().findBagItemById(itemId);
			if (tempItem)
			{
				if (callback != null)
				{
					callback.call(null, tempItem);
				}
			}
			else
			{
				if (noItemCallBack != null)
				{
					noItemCallBack.call(null);
				}
				showBuyWin(itemId);
			}
			tempItem = null;
		}
		
		/**
		 * 判断商店中是否可以购买这个物品
		 * @param	e
		 */
		public static function judgestExistAtShop(itemId:int,callBack:Function):void {
			var tempGoodModel:GoodsModel;
			if (!ShopModel.getInstance().list.length > 0)
			{
				SMZTController.getInstance().getShopGoods(function():void
					{
						tempGoodModel = ShopModel.getInstance().findGoodModelByItemid(itemId);
						if (tempGoodModel == null)
						{
							callBack.call(null, false);
						}else {
							callBack.call(null, true);
							}
					}, true);
			}
			else
			{
				
				tempGoodModel = ShopModel.getInstance().findGoodModelByItemid(itemId);
				if (tempGoodModel == null)
				{
					callBack.call(null, false);
				}else {
					callBack.call(null, true);
					}
			}
			
			}
		
		/**
		 * 使用道具前先判断背包中是否有物品，如果没有就回调方法，如果有就回调方法
		 * @param	itemId
		 */
		public static function judgestItemExistAndCallBack(itemId:int, callback:Function = null, noItemCallBack:Function = null):void
		{
			var tempItem:ItemModel = BagData.getInstance().findBagItemById(itemId);
			if (tempItem)
			{
				if (callback != null)
				{
					callback.call(null, tempItem);
				}
			}
			else
			{
				if (noItemCallBack != null)
				{
					noItemCallBack.call(null);
				}
				
			}
			tempItem = null;
		}
		
		/**
		 * 使用时先判断是否背包中有物品，如果没有提示购买
		 * @param	value
		 */
		public static function userItemNew(itemId:int, callBack:Function = null):void
		{
			var tempItem:ItemModel = BagData.getInstance().findBagItemById(itemId);
			if (tempItem)
			{
				UseItemControler.userItem(tempItem);
			}
			else
			{
				if (callBack != null)
				{
					callBack.call(null);
				}
				showBuyWin(itemId);
			}
			tempItem = null;
		}
		
		/**
		 *批量实用道具
		 * @param	value
		 * 如果是推图药水批量,则没有BONUS返回
		 */
		public static function batUserItem(value:ItemModel,num:int=0, cb:Function = null):void
		{
			LockScreen.getInstance().show(true);
			var temp:int = (num == 0)?value.number:num;
			//trace("temp=" + temp)
			var tempFun:Function = function():void
			{
				temp--;
				if (temp <= 0)
				{
					if (cb != null)
					{
						
						cb.call(null);
						LockScreen.getInstance().hide();
						
						if (SMZTUIManager.getInstance().mainPane.currentSceneId == MainScene.EXPEDITOIN_SCENE && value.itemId==SpecialItemIdConfig.STORY_ITEM) {
							//推图时刷新
							LongBaoModel.getInstance().getInfo();
							}
						
					}
				}
				else
				{
					useItemBat(value, tempFun,(value.itemId==SpecialItemIdConfig.STORY_ITEM)?true:false);
				}
			}
			useItemBat(value, tempFun,(value.itemId==SpecialItemIdConfig.STORY_ITEM)?true:false);
		}
		
		private static function useItemBat(value:ItemModel, cb:Function = null,special:Boolean=false):void
		{
			BagData.getInstance().itemUsedReduceNum(value.id, 1);
			SMZTController.getInstance().useItem(value.id, value.itemId, function(param:Object):void
				{
					if (special) {
						
						if (cb != null)
						{
							cb.call(null);
						}
						
						return;
						}
						
					if (param.bonus)
					{
						_bonusModle.setData(param.bonus);
						SMZTUIManager.getInstance().manageShowBonus.showBonus(_bonusModle);
						if (cb != null)
						{
							cb.call(null);
						}
					}
				});
		}
		
		/**
		 * 使用道具
		 * id	int	包裹格子编号
		   itemId	int	物品编号
		
		 */
		public static function userItem(value:ItemModel):void
		{
			BagData.getInstance().itemUsedReduceNum(value.id, 1);
			SMZTController.getInstance().useItem(value.id, value.itemId, function(param:Object):void
				{
					
					if (param.bonus)
					{
						_bonusModle.setData(param.bonus);
						if (_bonusModle.gold != 0)
						{
							//更新金币数
							PlayerData.getInstance().gold += _bonusModle.gold;
							SMZTUIManager.getInstance().manageShowBonus.showBonusNoData(_bonusModle, ManageShowBonus.GOLD);
						}
						if (_bonusModle.honor != 0)
						{
							//更新荣誉
							PlayerData.getInstance().honor += _bonusModle.honor;
							SMZTUIManager.getInstance().manageShowBonus.showBonusNoData(_bonusModle, ManageShowBonus.HONOR);
						}
						if (_bonusModle.crystal != 0)
						{
							PlayerData.getInstance().crystal += _bonusModle.crystal;
							SMZTUIManager.getInstance().manageShowBonus.showBonusNoData(_bonusModle, ManageShowBonus.CRYSTAL);
						}
						if (_bonusModle.exp != 0)
						{
							PlayerData.getInstance().expGain += _bonusModle.exp;
							SMZTUIManager.getInstance().manageShowBonus.showBonusNoData(_bonusModle, ManageShowBonus.EXP);
						}
						if (_bonusModle.items && _bonusModle.items.length > 0)
						{
							SMZTUIManager.getInstance().manageShowBonus.showBonusNoData(_bonusModle, ManageShowBonus.ITEM);
							SMZTController.getInstance().getBagData(false);
						}
						if (_bonusModle.cards && _bonusModle.cards.length > 0)
						{
							for (var i:String in _bonusModle.cards)
							{
								for (var n:int = 0; n < _bonusModle.cards[i].number; n++)
								{
									PlayerData.getInstance().addOneCard(_bonusModle.cards[i].id);
								}
							}
							//OpenCardsBagPanel.getInstance().show(true);
							//开卡包
							if (BagPanel.getInstance().isOpened)
							{
								SMZTController.getInstance().getBagData(false, function():void
									{
										if (value.category != ItemCategory.GIFT)
										{
											//开卡包
											OpenCardsBagPanel.getInstance().showCards(_bonusModle.cards, value);
											if (SMZTUIManager.getInstance().mainPane.currentSceneId == MainScene.CULTIVATION_SCENE)
											{
												//修炼馆里刷新界面
												SMZTUIManager.getInstance().mainPane.refreshCurrentScene();
											}
										}
										else
										{
											//-------------------新手引导用---新手礼包--------------------
											if (!NewBieControler.getInstance().finishDic[NewBieModelId.FISET])
											{
												NewBieControler.getInstance().nextStep();
												SMZTController.getInstance().SetNext(NewBieModelId.FISET);
											}
											//--------------------end--------------------
											
											//表示是新手礼包,显示卡名到舞台中间
											SMZTUIManager.getInstance().manageShowBonus.showBonusNoData(_bonusModle, ManageShowBonus.CARD);
										}
										PlayerData.getInstance().updataTotalType();
									});
							}
						}
						if (_bonusModle.achievements && _bonusModle.achievements.length > 0)
						{
							//增加成就
							
						}
						//更新背包数据(卡包开包里和有物品奖励时,不用在这里更新)
						if (!(_bonusModle.cards && _bonusModle.cards.length > 0) && !(_bonusModle.items && _bonusModle.items.length > 0))
						{
							SMZTController.getInstance().getBagData(false);
						}
					}
					else
					{
						//如使用招募令这种没有返回值时
						switch (value.itemId)
						{
							case SpecialItemIdConfig.RecruitItemId: 
								//招募令使用成功
								SMZTController.getInstance().getTavernData(function(param:Object):void
									{
										TavernModel.getInstance().setData(param);
									}, true);
								break;
							case SpecialItemIdConfig.TRAINING: 
								//学院券
								if (SMZTUIManager.getInstance().mainPane.currentSceneId == MainScene.TRAINING_SCENE)
								{
									SMZTController.getInstance().getTrainingData(function(param:Object):void
										{
											TrainingModel.getInstance().setData(param.training);
										}); //获取战争学院信息
								}
								break;
							case SpecialItemIdConfig.DYNAMIC2: 
							case SpecialItemIdConfig.DYNAMIC5: 
								//增加活力
								if (SMZTUIManager.getInstance().mainPane.currentSceneId == MainScene.CRYSTAL_HOLE_SCENE)
								{
									SMZTController.getInstance().getMyMine(); //刷新我的活力值
								}
								break;
							case SpecialItemIdConfig.STORY_ITEM: 
								//增加体力(龙宝)
								if (SMZTUIManager.getInstance().mainPane.currentSceneId == MainScene.EXPEDITOIN_SCENE)
								{
									LongBaoModel.getInstance().getInfo();
								}
								break;
						}
						
						//更新背包数据
						SMZTController.getInstance().getBagData(false);
					}
				});
		}
	
	}

}