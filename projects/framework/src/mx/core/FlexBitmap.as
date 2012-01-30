////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2006 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package mx.core
{

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.geom.Matrix;

import mx.utils.NameUtil;

/**
 *  FlexBitmap is a subclass of the Player's Bitmap class.
 *  It overrides the <code>toString()</code> method
 *  to return a string indicating the location of the object
 *  within the hierarchy of DisplayObjects in the application.
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class FlexBitmap extends Bitmap
{
    include "../core/Version.as";

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

    /**
     *  Constructor.
	 *
	 *  <p>Sets the <code>name</code> property to a string
	 *  returned by the <code>createUniqueName()</code>
	 *  method of the mx.utils.NameUtils class.
	 *  This string is the name of the object's class concatenated
	 *  with an integer that is unique within the application,
	 *  such as <code>"FlexBitmap12"</code>.</p>
	 *
	 *  @param bitmapData The data for the bitmap. 
	 *
	 *  @param pixelSnapping Whether or not the bitmap is snapped
	 *  to the nearest pixel.
	 *
	 *  @param smoothing Whether or not the bitmap is smoothed when scaled. 
	 *
	 *  @see flash.display.DisplayObject#name
	 *  @see mx.utils.NameUtil#createUniqueName()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function FlexBitmap(bitmapData:BitmapData = null,
							   pixelSnapping:String = "auto",
							   smoothing:Boolean = false)
	{
		super(bitmapData, pixelSnapping, smoothing);

		try
		{
			name = NameUtil.createUniqueName(this);
		}
		catch(e:Error)
		{
			// The name assignment above can cause the RTE
			//   Error #2078: The name property of a Timeline-placed
			//   object cannot be modified.
			// if this class has been associated with an asset
			// that was created in the Flash authoring tool.
			// The only known case where this is a problem is when
			// an asset has another asset PlaceObject'd onto it and
			// both are embedded separately into a Flex application.
			// In this case, we ignore the error and toString() will
			// use the name assigned in the Flash authoring tool.
		}
		
		if (FlexVersion.compatibilityVersion >= FlexVersion.VERSION_4_0)
			this.addEventListener(Event.ADDED, addedHandler);
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden Properties
	//
	//--------------------------------------------------------------------------
	
	private var mirror:Boolean = false;
	
	//----------------------------------
	//  x
	//----------------------------------
	
	private var _x:Number = 0;
	
	/**
	 *  @private
	 */
	override public function set x(value:Number):void
	{
		_x = value;
		super.x = value;
		if (mirror)
			validateTransformMatrix();
	}
	
	/**
	 *  @private
	 */
	override public function get x():Number
	{
		// FIXME(hmuller): by default get x returns transform.matrix.tx rounded to the nearest 20th.
		// should do the same here, if we're returning _x.
		return (mirror) ? _x : super.x;
	}

	//----------------------------------
	//  width
	//----------------------------------
	
	/**
	 *  @private
	 */
	override public function set width(value:Number):void  
	{
		super.width = value;
		if (mirror)
			validateTransformMatrix();
	}
	
	//----------------------------------
	//  height
	//----------------------------------
	
	/**
	 *  @private
	 *  We must override height as well because setting
	 *  height will reset scaleX in the transform
	 *  matrix.
	 * 
	 */
	override public function set height(value:Number):void  
	{
		super.height = value;
		if (mirror)
			validateTransformMatrix();
	}

	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------

    /**
	 *  Returns a string indicating the location of this object
	 *  within the hierarchy of DisplayObjects in the Application.
	 *  This string, such as <code>"MyApp0.HBox5.FlexBitmap12"</code>,
	 *  is built by the <code>displayObjectToString()</code> method
	 *  of the mx.utils.NameUtils class from the <code>name</code>
	 *  property of the object and its ancestors.
	 *  
	 *  @return A String indicating the location of this object
	 *  within the DisplayObject hierarchy. 
	 *
	 *  @see flash.display.DisplayObject#name
	 *  @see mx.utils.NameUtil#displayObjectToString()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function toString():String
	{
		return NameUtil.displayObjectToString(this);
	}
	
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
	/**
	 *  @private
	 *  We check the closest parent's layoutDirection property
	 *  whenever we change parents and set our mirror property
	 *  and transform matrix accordingly.
	 */
	private function addedHandler(event:Event):void
	{
		// FIXME (klin): Is this necessary? Will it have a big impact on performance?
		var p:DisplayObjectContainer = this.parent;
		
		while (p)
		{
			if (p is IVisualElement)
			{
				mirror = IVisualElement(p).layoutDirection == "rtl";
				validateTransformMatrix();
				break;
			}
			
			p = p.parent;
		}
	}
	
	/**
	 *  @private
	 *  Modifies the transform matrix so that this bitmap
	 *  will not be mirrored regardless of whether the closest
	 *  parent is mirrored.
	 */
	private function validateTransformMatrix():void
	{
		if (mirror)
		{
			const mirrorMatrix:Matrix = transform.matrix;
			if (mirrorMatrix.a > 0)
				mirrorMatrix.a *= -1;
			mirrorMatrix.tx = _x + width;
			transform.matrix = mirrorMatrix;
		}
		else // layoutDirection changed, mirror=false, reset transform.matrix to its default
		{
			const defaultMatrix:Matrix = new Matrix();
			defaultMatrix.tx = _x;
			defaultMatrix.ty = y;
			transform.matrix = defaultMatrix;
		}
	}
}

}
