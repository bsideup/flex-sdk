/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package macromedia.asc.parser;

import macromedia.asc.util.*;
import macromedia.asc.semantics.*;

/**
 * Node
 *
 * @author Jeff Dyer
 */
public class ForStatementNode extends Node
{
	public Node initialize;
	public Node test;
	public Node increment;
	public Node statement;
	public boolean is_forin;

    public ForStatementNode(Node initialize, Node test, Node increment, Node statement, boolean is_forin)
	{
		loop_index = 0;
		this.initialize = initialize;
		this.test = test;
		this.increment = increment;
		this.statement = statement;
        this.is_forin = is_forin;
    }

	public Value evaluate(Context cx, Evaluator evaluator)
	{
		if (evaluator.checkFeature(cx, this))
		{
			return evaluator.evaluate(cx, this);
		}
		else
		{
			return null;
		}
	}

	public void expectedType(TypeValue type)
	{
		statement.expectedType(type);
	}

	public int loop_index;

	public boolean isBranch()
	{
		return true;
	}

	public boolean isDefinition()
	{
		return initialize != null ? initialize.isDefinition() : false;
	}

	public int countVars()
	{
		return (initialize != null ? initialize.countVars() : 0) + (statement != null ? statement.countVars() : 0);
	}

	public String toString()
	{
		return "ForStatement";
	}
}
