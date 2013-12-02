package starling.filters.ext {
	import flash.utils.ByteArray;
	import com.adobe.utils.AGALMiniAssembler;

	import flash.display3D.Context3DProgramType;
	/**
	 * @author emil
	 */
	public class ConvolutionFilter {
		public static var name:String = "CONVOLUTION_FILTER";
		public static function blur(blurValue:Number):Vector.<Number> {
			var filter:Vector.<Number> = new <Number>[1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0];
			var sum:Number = 0;
			for(var i:int = 0 ; i < filter.length; i++){
				sum += filter[i];
			}
			for(i = 0 ; i < filter.length; i++){
				if(filter[i] != 0 && sum != 0)filter[i] /= sum;
			}
			filter.push(blurValue);
			return filter;
		}
		
		public static function sharpen(amount:Number):Vector.<Number> {
			var filter:Vector.<Number> = new <Number>[	0.0,-1.0,0.0,
														-1.0,5.0,-1.0,
														0.0,-1.0,0.0 ];
			var sum:Number = 0;
			for(var i:int = 0 ; i < filter.length; i++){
				sum += filter[i];
			}
			for(i = 0 ; i < filter.length; i++){
				if(filter[i] != 0 && sum != 0)filter[i] /= sum;
			}
			filter.push(amount);
			return filter;
		}
		
		public static function get vertexProgram():ByteArray {
			var vertexProgramCode:String =
                "m44 op, va0, vc0 \n" +
				"mov v0, va1 \n" + 
				"mov v1, va2 \n";
			var vertexProgramAssembler:AGALMiniAssembler = new AGALMiniAssembler();
            vertexProgramAssembler.assemble(Context3DProgramType.VERTEX, vertexProgramCode);
			return vertexProgramAssembler.agalcode;
		}
		
		public static function get fragmentProgram():ByteArray {
			var fragmentProgramCode:String =
			"mov ft3, fc4.y \n" +
			"mov ft4 v1 \n" +
			"add ft4.y ft4.y fc4.x \n" +
			"sub ft4.x ft4.x fc4.x \n" +
			"tex ft4 ft4 fs1 <2d,clamp,linear> \n" +
			"mul ft4 ft4 fc1.x \n" +
			"add ft3 ft3 ft4 \n" +
			"mov ft4 v1 \n" +
			"add ft4.y ft4.y fc4.x \n" +
			"tex ft4 ft4 fs1 <2d,clamp,linear> \n" +
			"mul ft4 ft4 fc1.y \n" +
			"add ft3 ft3 ft4 \n" +
			"mov ft4 v1 \n" +
			"add ft4.y ft4.y fc4.x \n" +
			"add ft4.x ft4.x fc4.x \n" +
			"tex ft4 ft4 fs1 <2d,clamp,linear> \n" +
			"mul ft4 ft4 fc1.z \n" +
			"add ft3 ft3 ft4 \n" +
			"mov ft4 v1 \n" +
			"sub ft4.x ft4.x fc4.x \n" +
			"tex ft4 ft4 fs1 <2d,clamp,linear> \n" +
			"mul ft4 ft4 fc2.x \n" +
			"add ft3 ft3 ft4 \n" +
			"mov ft4 v1 \n" +
			"tex ft4 ft4 fs1 <2d,clamp,linear> \n" +
			"mul ft4 ft4 fc2.y \n" +
			"add ft3 ft3 ft4 \n" +
			"mov ft4 v1 \n" +
			"add ft4.x ft4.x fc4.x \n" +
			"tex ft4 ft4 fs1 <2d,clamp,linear> \n" +
			"mul ft4 ft4 fc2.z \n" +
			"add ft3 ft3 ft4 \n" +
			"mov ft4 v1 \n" +
			"sub ft4.y ft4.y fc4.x \n" +
			"sub ft4.x ft4.x fc4.x \n" +
			"tex ft4 ft4 fs1 <2d,clamp,linear> \n" +
			"mul ft4 ft4 fc3.x \n" +
			"add ft3 ft3 ft4 \n" +
			"mov ft4 v1 \n" +
			"sub ft4.y ft4.y fc4.x \n" +
			"tex ft4 ft4 fs1 <2d,clamp,linear> \n" +
			"mul ft4 ft4 fc3.y \n" +
			"add ft3 ft3 ft4 \n" +
			"mov ft4 v1 \n" +
			"sub ft4.y ft4.y fc4.x \n" +
			"add ft4.x ft4.x fc4.x \n" +
			"tex ft4 ft4 fs1 <2d,clamp,linear> \n" +
			"mul ft4 ft4 fc3.z \n" +
			"add ft3 ft3 ft4 \n" +
			"mul ft3, ft3, fc0  \n" +
			"mov oc, ft3";
			
			var vertexProgramAssembler:AGALMiniAssembler = new AGALMiniAssembler();
            vertexProgramAssembler.assemble(Context3DProgramType.FRAGMENT, fragmentProgramCode);
			return vertexProgramAssembler.agalcode;
		}
	}
}
