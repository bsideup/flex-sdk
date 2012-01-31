////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2008 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package spark.components.supportClasses
{
    
import mx.events.FlexEvent;

/**
 *  The Range class holds a value and an allowed range for that 
 *  value, defined by a <code>minimum</code> and <code>maximum</code> properties. 
 *  The <code>value</code> property 
 *  is always constrained to be between the current <code>minimum</code> and
 *  <code>maximum</code>, and the <code>minimum</code>,
 *  and <code>maximum</code> are always constrained
 *  to be in the proper numerical order such that
 *  (minimum &lt;= value &lt;= maximum) is <code>true</code>. 
 *  If <code>snapInterval</code> is not 0, 
 *  then <code>value</code> is also constrained to be a multiple of 
 *  <code>snapInterval</code>.
 * 
 *  <p>Range is a base class for various controls that require range
 *  functionality, including TrackBase and Spinner.</p>
 * 
 *  @see mx.components.baseClasses.TrackBase
 *  @see mx.components.Spinner
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */  
public class Range extends SkinnableComponent
{
    include "../../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor. 
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function Range():void
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //---------------------------------
    // maximum
    //---------------------------------   
    
    private var _maximum:Number = 100;
    
    private var maxChanged:Boolean = false;
    
    /**
     *  The maximum valid <code>value</code>.
     * 
     *  <p>Changes to the value property are constrained
     *  by commitProperties() to be less than or equal to
     *  maximum with the nearestValidValue() method.</p> 
     *
     *  @default 100
     *  @see #nearestValidValue
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get maximum():Number
    {
        return _maximum;
    }

    public function set maximum(value:Number):void
    {
        if (value == _maximum)
            return;

        _maximum = value;
        maxChanged = true;

        invalidateProperties();
    }
    
    //---------------------------------
    // minimum
    //---------------------------------
    
    private var _minimum:Number = 0;
    
    private var minChanged:Boolean = false;
    
    /**
     *  The minimum valid <code>value</code>.
     * 
     *  <p>Changes to the value property are constrained
     *  by commitProperties() to be greater than or equal to
     *  minimum with the nearestValidValue() method.</p> 
     *
     *  @default 0
     *  @see #nearestValidValue
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get minimum():Number
    {
        return _minimum;
    }
    
    public function set minimum(value:Number):void
    {
        if (value == _minimum)
            return;
        
        _minimum = value;
        minChanged = true;
        
        invalidateProperties();
    }

    //---------------------------------
    // stepSize
    //---------------------------------    
    
    private var _stepSize:Number = 1;
    
    private var stepSizeChanged:Boolean = false;

    /**
     *  The amount that the <code>value</code> property 
     *  changes when the <code>changeValueByStep()</code> method is called. It must
     *  be a multiple of <code>snapInterval</code> unless 
     *  <code>snapInterval</code> is 0. 
     *  If <code>stepSize</code>
     *  is not a multiple, it is rounded to the nearest 
     *  multiple &gt;= <code>snapInterval</code>.
     *
     *  @default 1
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get stepSize():Number
    {
        return _stepSize;
    }

    public function set stepSize(value:Number):void
    {
        if (value == _stepSize)
            return;
            
        _stepSize = value;
        stepSizeChanged = true;
        
        invalidateProperties();       
    }

    //---------------------------------
    // value
    //---------------------------------   
     
    private var _value:Number = 0;
    private var _changedValue:Number = 0;
    private var valueChanged:Boolean = false;
    
    [Bindable(event="valueCommit")]

    /**
     *  The current value for this range.
     *  
     *  <p>Changes to the value property are constrained
     *  by commitProperties() to be greater than or equal to
     *  minimum, less than or equal to the maximum, and a
     *  multiple of snapInterval with the nearestValidValue() 
     *  method.</p> 
     * 
     *  @default 0
     *  @see #setValue
     *  @see #nearestValidValue
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get value():Number
    {
        return (valueChanged) ? _changedValue : _value;
    }


    /**
     *  @private
     *  Implementation note: we temporarily store the new value in
     *  _changedValue and then update _value, by calling setValue()
     *  in commitProperties().  Only one "valueCommit" event is
     *  dispatched, even if this property has effectively changed
     *  twice per nearestValidValue().
     */    
    public function set value(newValue:Number):void
    {
        if (newValue == _value)
            return;
        _changedValue = newValue;
        valueChanged = true;
        invalidateProperties();
    }
    
    //---------------------------------
    // snapInterval
    //---------------------------------   
     
    private var _snapInterval:Number = 1;

    private var snapIntervalChanged:Boolean = false;

    /**
     *  If non-zero, valid values must be an integer multiple of this property,
     *  or equal to the minimum or the maximum.
     *  
     *  <p>If the value of this property is zero, then valid values are only constrained
     *  to be between minimum and maximum inclusive.</p>
     * 
     *  <p>This property also constrains valid values for the stepSize property.</p>
     *  
     *  @default 1
     *  @see #nearestValidValue
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get snapInterval():Number
    {
        return _snapInterval;
    }

    public function set snapInterval(value:Number):void
    {
        if (value == _snapInterval)
            return;
        
        _snapInterval = value;
        snapIntervalChanged = true;
        
        stepSizeChanged = true;
        
        invalidateProperties();
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function commitProperties():void
    {
        super.commitProperties();

        if (minimum > maximum)
        {
            // Check min <= max
            if (!maxChanged)
                _minimum = _maximum;
            else
                _maximum = _minimum;
        }

        if (valueChanged || maxChanged || minChanged || snapIntervalChanged)
        {
            var currentValue:Number = (valueChanged) ? _changedValue : _value;
            valueChanged = false;
            maxChanged = false;
            minChanged = false;
            snapIntervalChanged = false;
            setValue(nearestValidValue(currentValue, snapInterval));
        }
        
        if (stepSizeChanged)
        {
            _stepSize = nearestValidSize(_stepSize);
            stepSizeChanged = false;
        }
    }

    /**
     *  @private
     *  Returns the integer multiple of snapInterval that's closest to size.
     * 
     *  <p>If snapInterval is 0, which means that values are only constrained
     *  by the minimum and maximum properties, then size is returned unchanged.</p>
     * 
     *  <p>This method is used by commitProperties() to validate the 
     *  stepSize.</p>
     * 
     *  @param size The input size.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    private function nearestValidSize(size:Number):Number
    {
        var interval:Number = snapInterval;
        if (interval == 0)
            return size;
        
        var validSize:Number = Math.round(size / interval) * interval
        return (Math.abs(validSize) < interval) ? interval : validSize;
    }
    
    /**
     *  Returns the integer multiple of interval that's closest to value, unless
     *  value is closer to either the minimum or the maximum limit, in which
     *  case the corresponding limit is returned.
     * 
     *  <p>If interval=0 then the value is just clipped to the minimum, maximum 
     *  limits.</p>
     * 
     *  <p>The valid values for a range are minimum, maximum, and the multiples
     *  of interval in between. 
     * 
     *  The minimum and maximum need not be a multiple of snapInterval.</p>
     * 
     *  <p>For example if minimum=1, maximum=5, and snapInterval=2, the valid
     *  values for the Range are 1, 2, 4, 5.
     * 
     *  Similarly, if minimum=2, maximum=8, and snapInterval=1.5, the valid
     *  values for the Range are 2, 3, 4.5. 6, 7.5, 8.</p>
     * 
     *  @param value The input value.
     *  @param interval Must be snapInterval or an integer multiple of snapInterval.
     *  @return The valid value that's closest to the input.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    protected function nearestValidValue(value:Number, interval:Number):Number
    { 
        if (interval == 0)
            return Math.max(minimum, Math.min(maximum, value));

        var lower:Number = Math.max(minimum, Math.floor(value / interval) * interval);
        var upper:Number = Math.min(maximum, Math.floor((value + interval) / interval) * interval);
        return ((value - lower) >= ((upper - lower) / 2)) ? upper : lower;
    }
    
    /**
     *  Sets the backing store for the <code>value</code> property and 
     *  dispatches a <code>valueCommit</code> event if the property changes.  
     * 
     *  <p>All updates to the value property cause a call to this method.</p>
     * 
     *  <p>This method assumes that the caller has already used nearestValidValue() 
     *  to constrain the value parameter</p>
     * 
     *  @param value The new value of the <code>value</code> property.
     *  @see #nearestValidValue
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    protected function setValue(value:Number):void
    {
        if (_value == value)
            return;
        if (!isNaN(maximum) && !isNaN(minimum) && (maximum > minimum))
            _value = Math.min(maximum, Math.max(minimum, value));
        else
            _value = value;
        dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
    }
    
    /**
     *  Increase or decrease <code>value</code> by <code>stepSize</code>.
     *
     *  @param increase If true, add stepSize to value, otherwise subtract it.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function changeValueByStep(increase:Boolean = true):void
    {
    	if (stepSize == 0)
            return;

        var newValue:Number = (increase) ? value + stepSize : value - stepSize;
        setValue(nearestValidValue(newValue, snapInterval));
    }
}

}