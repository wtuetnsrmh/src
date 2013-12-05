package project.view.module.scene.longbao 
{
	/**
	 * ...
	 * @author bbjxl 2013
	 * 此类中记录了所有可选的角色类型 
	 *
	 * 
	 */	
	public class RoleType
	{
		/** 玩家 */
		public static const USER:String = "user";
		
		/** 中立角色 */
		public static const ROLE:String = "role";
		
		/** 敌人 */
		public static const ENEMY:String = "enemy";
		
		/** 对每种角色类型的描述文字 */
		public static const TypeDescription:Object = {user:"玩家", role:"角色", enemy:"敌人"};
		
		/** 对每种角色类型的描述文字 */
		public static const TYPE_COLOR:Object = {user:0x00ff00, role:0x06fcff, enemy:0xff0000};
	}
}