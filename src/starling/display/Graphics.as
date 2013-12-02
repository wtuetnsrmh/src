package starling.display
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	import starling.display.graphics.Fill;
	import starling.display.graphics.Graphic;
	import starling.display.graphics.NGon;
	import starling.display.graphics.Plane;
	import starling.display.graphics.RoundedRectangle;
	import starling.display.graphics.Stroke;
	import starling.display.graphics.StrokeVertex;
	import starling.display.GraphicsPath;
	import starling.display.GraphicsPathCommands;
	import starling.display.IGraphicsData;
	
	import starling.display.materials.IMaterial;
	import starling.display.shaders.fragment.TextureFragmentShader;
	import starling.display.util.CurveUtil;
	import starling.textures.Texture;

	public class Graphics
	{
		// Shared texture fragment shader used across all graphics drawn via graphics API.
		protected static var textureFragmentShader	:TextureFragmentShader = new TextureFragmentShader();
		protected const BEZIER_ERROR:Number = 0.75;
		
		protected var _currentX				:Number;
		protected var _currentY				:Number;
		protected var _currentStroke		:Stroke;
		protected var _currentFill			:Fill;
		
		protected var _fillColor				:uint;
		protected var _fillAlpha				:Number;
		protected var _strokeThickness		:Number;
      	protected var _strokeColor			:uint;
		protected var _strokeAlpha			:Number;
		protected var _strokeTexture			:Texture;
		protected var _strokeMaterial			:IMaterial;
		
		protected var _container				:DisplayObjectContainer;
		protected var _strokeInterrupted		:Boolean;

		// used for geometry level hit tests. False gives boundingbox results, True gives geometry level results. 
		// True is a lot more exact, but also slower. 
     	protected var _precisionHitTest:Boolean = false;
		protected var _precisionHitTestDistance:Number = 0; 
		
		
        public function Graphics(displayObjectContainer:DisplayObjectContainer)
		{
			_container = displayObjectContainer;
		}
		
		public function clear():void
		{
			while ( _container.numChildren > 0 )
			{
				var child:DisplayObject = _container.getChildAt(0);
				child.dispose();
				if ( child is Graphic )
				{
					var graphic:Graphic = Graphic(child);
					if ( graphic.material )
					{
						graphic.material.dispose(true);
					}
				}
				_container.removeChildAt(0);
			}
			_currentX = NaN;
			_currentY = NaN;
			
			_fillColor 	= NaN;
			_fillAlpha 	= NaN;
			_currentFill= null;
			clearCurrentStroke();
         
        }
		
		public function beginFill(color:uint, alpha:Number = 1.0):void
		{
			_fillColor = color;
			_fillAlpha = alpha;
			
			createCurrentFill();
			_currentFill.material.alpha = _fillAlpha;
			_currentFill.material.color = color;
			_container.addChild(_currentFill);
		}
		
		/**
		 * Warning - this function will create a fresh texture for each bitmap.
		 * It is reccomended to use beginTextureFill to ensure texture re-use.
		 */
		public function beginBitmapFill(bitmap:BitmapData, uvMatrix:Matrix = null):void
		{
			_fillColor = 0xFFFFFF;
			_fillAlpha = 1;
			
			createCurrentFill();
			_currentFill.material.fragmentShader = textureFragmentShader;
			var texture:Texture = Texture.fromBitmapData( bitmap, false );
			_currentFill.material.textures[0] = texture;
			
			var m:Matrix = new Matrix();
			m.scale(1/texture.width, 1/texture.height);
			if ( uvMatrix )
			{
				m.concat(uvMatrix);
			}
			_currentFill.uvMatrix = m;
			
			_container.addChild(_currentFill);
		}
		
		public function beginTextureFill( texture:Texture, uvMatrix:Matrix = null ):void
		{
			_fillColor = 0xFFFFFF;
			_fillAlpha = 1;
			
			createCurrentFill();
			_currentFill.material.fragmentShader = textureFragmentShader;
			_currentFill.material.textures[0] = texture;
			
			var m:Matrix = new Matrix();
			m.scale(1/texture.width, 1/texture.height);
			if ( uvMatrix )
			{
				m.concat(uvMatrix);
			}
			_currentFill.uvMatrix = m;
			
			_container.addChild(_currentFill);
		}
		
		public function beginMaterialFill( material:IMaterial, uvMatrix:Matrix = null ):void
		{
			_fillColor = 0xFFFFFF;
			_fillAlpha = 1;
			
			createCurrentFill();
			_currentFill.material = material;
			
			var m:Matrix;
			if ( uvMatrix )
			{
				m = uvMatrix.clone();
				m.invert();
			}
			else
			{
				m = new Matrix();
			}
			if ( material.textures.length > 0 )
			{
				m.scale(1/material.textures[0].width, 1/material.textures[0].height);
			}
			
			_currentFill.uvMatrix = m;
			
			_container.addChild(_currentFill);
		}
		
		public function endFill():void
		{
			if ( _currentFill && _currentFill.numVertices < 3 ) {
				_container.removeChild(_currentFill);
			}
			
			_fillColor 	= NaN;
			_fillAlpha 	= NaN;
			_currentFill = null;
		}
		
		public function drawCircle(x:Number, y:Number, radius:Number):void
		{
			drawEllipse(x, y, radius*2, radius*2);
		}
		
		public function drawEllipse(x:Number, y:Number, width:Number, height:Number):void
		{
			// Calculate num-sides based on a blend between circumference of width and circumference of height.
			// Should provide good results for ellipses with similar widths/heights.
			// Will look bad on very thin ellipses.
			var numSides:int = Math.PI * ((width*0.5) + (height*0.5)) * 0.25;
			numSides = numSides < 6 ? 6 : numSides;
			
			// Use an NGon primitive instead of fill to bypass triangulation.
			var cachedFill:Fill = _currentFill;
			if ( _currentFill )
			{
				var nGon:NGon = new NGon(width*0.5, numSides);
				nGon.x = x;
				nGon.y = y;
				nGon.scaleY = height/width;
				nGon.material = _currentFill.material;
				nGon.material.color = _fillColor;
				nGon.alpha = _fillAlpha;
				var m:Matrix = new Matrix();
				m.scale(width, height);
				if ( cachedFill.uvMatrix )
				{
					m.concat(cachedFill.uvMatrix);
				}
				nGon.uvMatrix = m;
				
				_container.addChild(nGon);
				_currentFill = null;
			}
			
			
			// Draw the stroke
			if ( isNaN(_strokeThickness) == false )
			{
				var halfWidth:Number = width*0.5;
				var halfHeight:Number = height*0.5;
				var anglePerSide:Number = (Math.PI * 2) / numSides;
				var a:Number = Math.cos(anglePerSide);
				var b:Number = Math.sin(anglePerSide);
				var s:Number = 0.0;
				var c:Number = 1.0;
				
				for ( var i:int = 0; i <= numSides; i++ )
				{
					var sx:Number = s * halfWidth + x;
					var sy:Number = -c * halfHeight + y;
					if ( i == 0 )
					{
						moveTo(sx,sy);
					}
					else
					{
						lineTo(sx,sy);
					}
					
					const ns:Number = b*c + a*s;
					const nc:Number = a*c - b*s;
					c = nc;
					s = ns;
				}
			}
			
			_currentFill = cachedFill;
		}
		
		
		public function drawRect(x:Number, y:Number, width:Number, height:Number):void
		{
			var storedFill:Fill;
			
			// Use a Plane primitive instead of fill to side-step triangulation.
			if ( _currentFill )
			{
				// Store fill to we can draw stroke without fill.
				storedFill = _currentFill;
				_currentFill = null;
				
				var plane:Plane = new Plane(width, height);
				plane.material = storedFill.material;
				
				var m:Matrix = new Matrix();
				m.scale(width, height);
				if ( storedFill.uvMatrix )
				{
					m.concat(storedFill.uvMatrix);
				}
				plane.uvMatrix = m;
				plane.x = x;
				plane.y = y;
				_container.addChild(plane);
				
			}
			
			// Draw stroke
			moveTo(x, y);
			lineTo(x + width, y);
			lineTo(x + width, y + height);
			lineTo(x, y + height);
			lineTo(x, y - _strokeThickness/2);
			_currentFill = storedFill;
		}
		
		public function drawRoundRect( x:Number, y:Number, width:Number, height:Number, radius:Number ):void
		{
			drawRoundRectComplex(x,y,width,height,radius,radius,radius,radius);
		}
		
		public function drawRoundRectComplex( x:Number, y:Number, width:Number, height:Number, topLeftRadius:Number, topRightRadius:Number, bottomLeftRadius:Number, bottomRightRadius:Number ):void
		{
			if ( !_currentFill && _strokeThickness <= 0 ) return;
			
			var storedFill:Fill;
			var roundedRect:RoundedRectangle = new RoundedRectangle( width, height, topLeftRadius, topRightRadius, bottomLeftRadius, bottomRightRadius );
			
			// Draw fill
			if ( _currentFill )
			{
				// Store fill to we can draw stroke without fill.
				storedFill = _currentFill;
				_currentFill = null;
				roundedRect.material = storedFill.material;
				
				var m:Matrix = new Matrix();
				m.scale(width, height);
				if ( storedFill.uvMatrix )
				{
					m.concat(storedFill.uvMatrix);
				}
				roundedRect.uvMatrix = m;
				roundedRect.x = x;
				roundedRect.y = y;
				_container.addChild(roundedRect);
			}
			_currentFill = storedFill;
			
			// Draw stroke
			if ( _strokeTexture ) 
			{
				beginTextureStroke();
			} 
			else if ( _strokeMaterial )
			{
				beginMaterialStroke();
			}
			else if ( _strokeThickness > 0 )
			{  	
				beginStroke();
			}
			if ( _currentStroke )
			{
				var strokePoints:Vector.<Number> = roundedRect.getStrokePoints();
				for ( var i:int = 0; i < strokePoints.length; i+=2 )
				{
					_currentStroke.addVertex( x+strokePoints[i],y+strokePoints[i+1], _strokeThickness );
				}
			}
		}
		
		public function lineStyle(thickness:Number = NaN, color:uint = 0, alpha:Number = 1.0):void
		{
			_strokeThickness		= thickness;
			_strokeColor			= color;
			_strokeAlpha			= alpha;
			_strokeTexture 			= null;
			_strokeMaterial			= null;
			
			disposeCurrentStroke();
		}
		
		public function lineTexture(thickness:Number = NaN, texture:Texture = null):void
		{
         	_strokeThickness		= thickness;
			_strokeColor			= 0xFFFFFF;
			_strokeAlpha			= 1;
			_strokeTexture 			= texture;
			_strokeMaterial			= null;
			
			disposeCurrentStroke();
		}
		
		public function lineMaterial(thickness:Number = NaN, material:IMaterial = null):void
		{
			_strokeThickness		= thickness;
			_strokeColor			= 0xFFFFFF;
			_strokeAlpha			= 1;
			_strokeTexture			= null;
			_strokeMaterial			= material;
			
			disposeCurrentStroke();
		}
		
		public function moveTo(x:Number, y:Number):void
		{
			// Move to changed to add degenerates:
			// Degenerates allow for better performance as they do not terminate
			// the vertex buffer but instead use zero size polygons to translate
			// from the end point of the last section of the stroke to the
			// start of the new point.
			if ( _currentStroke && _strokeThickness > 0 )
			{
				_currentStroke.addDegenerates(x, y);
			}
			
			if (_currentFill) 
			{
				_currentFill.addDegenerates( x, y );
			}
			
			_currentX = x;
			_currentY = y;
			_strokeInterrupted = true;
		}
		
		public function lineTo(x:Number, y:Number):void
		{
			if (!_currentStroke && _strokeThickness > 0) 
			{
				if (_strokeTexture) 
				{
					beginTextureStroke();
				}
				else if ( _strokeMaterial )
				{
					beginMaterialStroke();
				}
				else
				{
					beginStroke();
				}
			}
			
			if ( _currentStroke && ( _strokeInterrupted || _currentStroke.numVertices == 0 ) && isNaN(_currentX) == false )
			{
                _currentStroke.addVertex( _currentX, _currentY, _strokeThickness );

				_strokeInterrupted  = false;
			}
			
			if ( isNaN(_currentX) )
			{
				moveTo(0,0);
			}
			
			if ( _currentStroke && _strokeThickness > 0 )
			{
               	_currentStroke.addVertex( x, y, _strokeThickness );
			}
			
			if (_currentFill) 
			{
				_currentFill.addVertex( x, y );
			}
			_currentX = x;
			_currentY = y;
		}
		
		public function curveTo(cx:Number, cy:Number, a2x:Number, a2y:Number, error:Number = BEZIER_ERROR ):void
		{
			var startX:Number = _currentX;
			var startY:Number = _currentY;
			
			if ( isNaN(startX) )
			{
				startX = 0;
				startY = 0;
			}
			
			var points:Vector.<Number> = CurveUtil.quadraticCurve(startX, startY, cx, cy, a2x, a2y, error);

            var L:int = points.length;
            for ( var i:int = 0; i < L; i+=2 )
            {
                var x:Number = points[i];
                var y:Number = points[i+1];

                if ( i == 0 && isNaN(_currentX) )
                {
                    moveTo( x, y );
                }
                else
                {
                    lineTo( x, y );
                }
            }

            _currentX = a2x;
			_currentY = a2y;
		}
		
		public function cubicCurveTo(c1x:Number, c1y:Number, c2x:Number, c2y:Number, a2x:Number, a2y:Number, error:Number = BEZIER_ERROR ):void
		{
			var startX:Number = _currentX;
			var startY:Number = _currentY;
			
			if ( isNaN(startX) )
			{
				startX = 0;
				startY = 0;
			}
			
			var points:Vector.<Number> = CurveUtil.cubicCurve(startX, startY, c1x, c1y, c2x, c2y, a2x, a2y, error);
			
			var L:int = points.length;
            for ( var i:int = 0; i < L; i+=2 )
    		{
	    		var x:Number = points[i];
		    	var y:Number = points[i+1];
				
			   	if ( i == 0 && isNaN(_currentX) )
			    {
				    moveTo( x, y );
			    }
			    else
			    {
                    lineTo( x, y );
                }
			}

			_currentX = a2x;
			_currentY = a2y;
		}

		protected function drawCommandInternal(command:int, data:Vector.<Number>, dataCounter:int, winding:String) : int
		{
		
			if ( command == GraphicsPathCommands.NO_OP )
			{
				return 0;
			}
			else if ( command == GraphicsPathCommands.MOVE_TO )
			{
				moveTo(data[dataCounter], data[dataCounter + 1]);
				return 2;
			}
			else if ( command == GraphicsPathCommands.LINE_TO )
			{
				lineTo(data[dataCounter], data[dataCounter + 1]);
				return 2;
			}
			else if ( command == GraphicsPathCommands.CURVE_TO )
			{
				curveTo(data[dataCounter], data[dataCounter + 1], data[dataCounter + 2], data[dataCounter + 3] );
				return 4;
			}
			else if ( command == GraphicsPathCommands.CUBIC_CURVE_TO )
			{
				cubicCurveTo(data[dataCounter], data[dataCounter + 1], data[dataCounter + 2], data[dataCounter + 3], data[dataCounter + 4], data[dataCounter + 5] );
				return 6;
			}
			else if ( command == GraphicsPathCommands.WIDE_MOVE_TO )
			{
				moveTo(data[dataCounter + 2 ], data[dataCounter + 3]); 
				return 4;
			}
			else if ( command == GraphicsPathCommands.WIDE_LINE_TO )
			{
				lineTo(data[dataCounter + 2], data[dataCounter + 3]);
				return 4;
			}
			return 0;

		}
		
		public function drawPath(commands:Vector.<int>, data:Vector.<Number>, winding:String = "evenOdd"):void
		{
			var i:int = 0;
			var commandLength:int = commands.length;
			var dataCounter : int = 0;
			for ( i = 0; i < commandLength; i++ )
			{
				var cmd:int = commands[i];
				dataCounter += drawCommandInternal(cmd, data, dataCounter, winding);
			}
		}
		
		
		public function drawGraphicsData(graphicsData:Vector.<IGraphicsData>):void
		{
			var i:int = 0;
			var vectorLength:int = graphicsData.length;
			for ( i = 0; i < vectorLength; i++ )
			{
				var gfxData:IGraphicsData = graphicsData[i];
				handleGraphicsDataType(gfxData);
			}
		}
		
		protected function handleGraphicsDataType(gfxData:IGraphicsData ) : void
		{
			if ( gfxData is GraphicsPath ) 
				drawPath(GraphicsPath(gfxData).commands, GraphicsPath(gfxData).data, GraphicsPath(gfxData).winding);
			else if ( gfxData is GraphicsEndFill )
				endFill();
			else if ( gfxData is GraphicsTextureFill )
				beginTextureFill(GraphicsTextureFill(gfxData).texture, GraphicsTextureFill(gfxData).matrix);
			else if ( gfxData is GraphicsBitmapFill )
				beginBitmapFill(GraphicsBitmapFill(gfxData).bitmapData, GraphicsBitmapFill(gfxData).matrix);
			else if ( gfxData is GraphicsMaterialFill ) 
				beginMaterialFill(GraphicsMaterialFill(gfxData).material, GraphicsMaterialFill(gfxData).matrix);
			else if ( gfxData is GraphicsLine )
				lineStyle(GraphicsLine(gfxData).thickness, GraphicsLine(gfxData).color, GraphicsLine(gfxData).alpha); // This isn't part of the proper Flash API. 
			
		}
		
		public function set precisionHitTest(value:Boolean) : void
		{
			_precisionHitTest = value;
			if ( _currentFill != null )
				_currentFill.precisionHitTest = value;
			if ( _currentStroke != null )
				_currentStroke.precisionHitTest = value;
				
		}
		public function get precisionHitTest() : Boolean 
		{
			return _precisionHitTest;
		}
		
		public function set precisionHitTestDistance(value:Number) : void
		{
			_precisionHitTestDistance = value;
			if ( _currentFill != null )
				_currentFill.precisionHitTestDistance = value;
			if ( _currentStroke != null )
				_currentStroke.precisionHitTestDistance = value;
		
		}
		public function get precisionHitTestDistance() : Number
		{
			return _precisionHitTestDistance;
		}
		
		////////////////////////////////////////
		// PROTECTED
		////////////////////////////////////////
		
	/*	protected function clearCurrentFill() : void
		{
			if ( _currentFill != null )
			{
				_currentFill.dispose();
				_currentFill = null;
			}	
		}
		*/
		protected function createCurrentFill() : void
		{
			// clearCurrentFill();
			_currentFill = new Fill();
			_currentFill.precisionHitTest = _precisionHitTest;
			_currentFill.precisionHitTestDistance = _precisionHitTestDistance;
			
		}
		
		
		protected function createStroke() : Stroke
		{ // Created to be able to extend class with different strokes for different folks.
			return new Stroke();
		}
		
		protected function clearCurrentStroke() : void
		{
			_currentStroke = null;
			/*if ( _currentStroke != null )
			{
				_currentStroke.dispose();
				_currentStroke = null;
			}*/
		}
		
		protected function beginStroke():void
		{
			disposeCurrentStroke();
			_currentStroke = createStroke();
			_currentStroke.precisionHitTest = _precisionHitTest;
			_currentStroke.precisionHitTestDistance = _precisionHitTestDistance;
			_currentStroke.material.color = _strokeColor;
			_currentStroke.material.alpha = _strokeAlpha;
			_container.addChild(_currentStroke);
		}
		
		
		
		protected function beginTextureStroke():void
		{
			disposeCurrentStroke();
			_currentStroke = createStroke();
			_currentStroke.precisionHitTest = _precisionHitTest;
			_currentStroke.precisionHitTestDistance = _precisionHitTestDistance;
			_currentStroke.material.fragmentShader = textureFragmentShader;
			_currentStroke.material.textures[0] = _strokeTexture;
			_currentStroke.material.color = _strokeColor;
			_currentStroke.material.alpha = _strokeAlpha;
			_container.addChild(_currentStroke);
		}
		
		protected function beginMaterialStroke():void
		{
			disposeCurrentStroke();
			_currentStroke = createStroke();
			_currentStroke.precisionHitTest = _precisionHitTest;
			_currentStroke.precisionHitTestDistance = _precisionHitTestDistance;
			_currentStroke.material = _strokeMaterial;
			_container.addChild(_currentStroke);
		}
		
		protected function disposeCurrentStroke():void
		{
			if ( _currentStroke )
			{
				if ( _currentStroke.numVertices < 2 )
				{
					_currentStroke.dispose();
					_container.removeChild(_currentStroke);
				}
				_currentStroke = null;
			}
		}

		

    }
}
