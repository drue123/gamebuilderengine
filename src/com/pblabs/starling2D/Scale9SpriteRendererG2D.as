/*******************************************************************************
 * GameBuilder Studio
 * Copyright (C) 2012 GameBuilder Inc.
 * For more information see http://www.gamebuilderstudio.com
 *
 * This file is licensed under the terms of the MIT license, which is included
 * in the License.html file at the root directory of this SDK.
 ******************************************************************************/
package com.pblabs.starling2D
{
	import com.pblabs.engine.PBUtil;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;

	public final class Scale9SpriteRendererG2D extends SpriteRendererG2D
	{
		private var _scale9Region : Rectangle = new Rectangle(5,5,5,5);
		
		public function Scale9SpriteRendererG2D()
		{
			super();
		}
		
		public function get scale9Region():Rectangle
		{
			return _scale9Region
		}
		public function set scale9Region(region : Rectangle):void
		{
			if(region && !_scale9Region.equals(region))
				_imageDataDirty = true;
			_scale9Region = region;
		}

		
		override public function updateTransform(updateProps:Boolean = false):void
		{
			if(!gpuObject){
				super.updateTransform(updateProps);
				return;
			}
			
			if(updateProps)
				updateProperties();
			
			var tmpScale : Point = combinedScale;
			_transformMatrix.identity();
			//_transformMatrix.scale(tmpScale.x, tmpScale.y);
			//_transformMatrix.translate(-_registrationPoint.x * tmpScale.x, -_registrationPoint.y * tmpScale.y);
			_transformMatrix.translate(-_registrationPoint.x, -_registrationPoint.y);
			_transformMatrix.rotate(PBUtil.getRadiansFromDegrees(_rotation + _rotationOffset));
			_transformMatrix.translate((_position.x + _positionOffset.x), (_position.y + _positionOffset.y));
			
			gpuObject.transformationMatrix = _transformMatrix;
			gpuObject.width = (this._size.x * this._scale.x);
			gpuObject.height = (this._size.y * this._scale.y);
			gpuObject.alpha = this._alpha;
			gpuObject.blendMode = this._blendMode;
			gpuObject.visible = (alpha > 0);
			gpuObject.touchable = _mouseEnabled;
			
			_transformDirty = false;
		}

		override protected function buildG2DObject(skipCreation : Boolean = false):void
		{
			if(!Starling.context && !skipCreation){
				InitializationUtilG2D.initializeRenderers.add(buildG2DObject);
				return;
			}
			
			if(!skipCreation){
				if(!resource || !_scale9Region){
					super.buildG2DObject();
					return;
				}else{
					var texture : Texture = ResourceTextureManagerG2D.getTextureForResource(resource);
					if(texture){
						if(!gpuObject){
							gpuObject = new Image( texture );
						}else{
							if((gpuObject as Image).texture)
								( gpuObject as Image).texture.dispose();
							(gpuObject as Image).texture = texture;
						}
						(gpuObject as Image).scale9Grid = _scale9Region;
						(gpuObject as Image).readjustSize();
					}
				}
				smoothing = _smoothing;
				skipCreation = true;
				_imageDataDirty = false;
			}
			super.buildG2DObject(skipCreation);
		}
	}
}