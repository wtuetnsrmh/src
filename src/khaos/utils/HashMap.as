package khaos.utils
{
	import flash.utils.Dictionary;
	
	public class HashMap 
	{
		protected var map:Dictionary = null;

		public function HashMap(useWeakReferences:Boolean = false)
		{
			map = new Dictionary( useWeakReferences );
		}
		
		
		public function put(key:*, value:*) : void
		{
			map[key] = value;
		}
		
	
		public function putAll(table:Dictionary) : void
		{
			for ( var prop:* in table )
			{
				put( prop, table[prop] );
			}
		}
	
		
	
		public function remove(key:*) : void
		{
			map[ key ] = undefined;
			delete map[ key ];
		}
		
	
		public function containsKey(key:*) : Boolean
		{
			return map.hasOwnProperty( key );
		}
		
		
		public function containsValue(value:*) : Boolean
		{
			for ( var key:* in map )
			{
				if ( map[ key ] == value )
				{
					return true;
				}
			}
			return false;
		}
		
		
		public function getKey(value:*) : *
		{
			var identifier:* = undefined;
			
			for ( var key:* in map )
			{
				if ( map[ key ] == value )
				{
					identifier = key;
					break;
				}
			}
			return identifier;
		}
		
		
		public function getKeys() : Array
		{
			var keys:Array = [];
			
			for ( var key:* in map )
			{
				keys.push( key );
			}
			return keys;
		}
		
		
		public function getValue(key:*) : *
		{
			return map[key];
		}
		
	
		public function getValues() : Array
		{
			var values:Array = [];
			
			for (var key:* in map){
				values.push( map[key] );
			}
			return values;
		}
		
		
		public function size() : int
		{
			var length:int = 0;
			
			for ( var key:* in map )
			{
				length++;
			}
			return length;
		}
		
		
		public function isEmpty() : Boolean
		{
			return size() <= 0;
		}
	
		public function reset() : void
		{
			for ( var key:* in map )
			{
				map[ key ] = undefined;
			}
		}
		
	
		public function resetAllExcept(keyId:*) : void
		{
			for ( var key:* in map )
			{
				if ( key != keyId )
				{
					map[ key ] = undefined;
				}
			}
		}
		
		
		public function clear() : void
		{
			for ( var key:* in map )
			{
				remove( key );
			}
		}
		
		
		public function clearAllExcept(keyId:*) : void
		{
			for ( var key:* in map )
			{
				if ( key != keyId )
				{
					remove( key );
				}
			}
		}

	}
}