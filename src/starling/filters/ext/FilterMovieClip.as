package starling.filters.ext {
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.errors.MissingContextError;
	import starling.textures.Texture;
	import starling.utils.VertexData;


	/**
	 * @author emil
	 */
	public class FilterMovieClip extends MovieClip {
		private var mBlur : Number = 0;
		private var mFilter : Vector.<Number>;
		private var mSharpen : Number;
		
		public function FilterMovieClip(textures:Vector.<Texture>, fps:Number=12)
        {            
            super(textures,fps);
		}
		
		public function set blur(value:Number):void {
			mBlur = value;
			mFilter = ConvolutionFilter.blur(value);
		}
		
		public function get blur():Number { return mBlur; }
		
		public function set sharpen(value:Number):void {
			mSharpen = value;
			mFilter = ConvolutionFilter.sharpen(value);
		}
		public function get sharpen():Number { return mSharpen;}
		
		public override function render(support:RenderSupport, alpha:Number):void
        {
            alpha *= this.alpha;
         	
			if(!mFilter) mFilter = ConvolutionFilter.blur(0);   
            var pma:Boolean = super.texture.premultipliedAlpha;
            var context:Context3D = Starling.context;
            
            if (context == null) throw new MissingContextError();
            if (mVertexBuffer == null) createVertexBuffer();
            if (mIndexBuffer  == null) createIndexBuffer();
			
			var alphaVector:Vector.<Number> = pma ? new <Number>[alpha, alpha, alpha, alpha] :
	                                                    new <Number>[1.0, 1.0, 1.0, alpha];
			
            support.setDefaultBlendFactors(pma);
            context.setProgram(Starling.current.getProgram(ConvolutionFilter.name));
            context.setTextureAt(1, super.texture.base);
            context.setVertexBufferAt(0, mVertexBuffer, VertexData.POSITION_OFFSET, Context3DVertexBufferFormat.FLOAT_3); 
            context.setVertexBufferAt(1, mVertexBuffer, VertexData.COLOR_OFFSET,    Context3DVertexBufferFormat.FLOAT_4);
            context.setVertexBufferAt(2, mVertexBuffer, VertexData.TEXCOORD_OFFSET, Context3DVertexBufferFormat.FLOAT_2);
            context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, support.mvpMatrix, true);            
            context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, alphaVector, 1);
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, Vector.<Number>([mFilter[0],mFilter[1],mFilter[2], 1]));
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, Vector.<Number>([mFilter[3],mFilter[4],mFilter[5], 1]));
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, Vector.<Number>([mFilter[6],mFilter[7],mFilter[8], 1]));
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, Vector.<Number>([mFilter[9]*0.001,0,0,0]));
			 
            context.drawTriangles(mIndexBuffer, 0, 2);
            
            context.setTextureAt(1, null);
            context.setVertexBufferAt(0, null);
            context.setVertexBufferAt(1, null);
            context.setVertexBufferAt(2, null);
		}
		
		public static function registerPrograms(target:Starling):void
        {
			target.registerProgram(ConvolutionFilter.name, ConvolutionFilter.vertexProgram, ConvolutionFilter.fragmentProgram);
		}
	}
}
