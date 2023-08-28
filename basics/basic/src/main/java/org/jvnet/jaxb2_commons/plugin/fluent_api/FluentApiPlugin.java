/*
 * Copyright 2006 The Apache Software Foundation.
 *
 * Licensed under the Apache License, Version 2.0 (the "License")
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.jvnet.jaxb2_commons.plugin.fluent_api;

import static org.jvnet.jaxb2_commons.plugin.fluent_api.FluentMethodType.FLUENT_COLLECTION_SETTER;
import static org.jvnet.jaxb2_commons.plugin.fluent_api.FluentMethodType.FLUENT_LIST_SETTER;
import static org.jvnet.jaxb2_commons.plugin.fluent_api.FluentMethodType.FLUENT_SETTER;
import static org.jvnet.jaxb2_commons.plugin.fluent_api.FluentMethodType.GETTER_METHOD_PREFIX;
import static org.jvnet.jaxb2_commons.plugin.fluent_api.FluentMethodType.GETTER_METHOD_PREFIX_LEN;
import static org.jvnet.jaxb2_commons.plugin.fluent_api.FluentMethodType.PARAMETERIZED_LIST_PREFIX;
import static org.jvnet.jaxb2_commons.plugin.fluent_api.FluentMethodType.SETTER_METHOD_PREFIX;
import static org.jvnet.jaxb2_commons.plugin.fluent_api.FluentMethodType.SETTER_METHOD_PREFIX_LEN;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.xml.sax.ErrorHandler;

import com.sun.codemodel.JClass;
import com.sun.codemodel.JCodeModel;
import com.sun.codemodel.JDefinedClass;
import com.sun.codemodel.JMethod;
import com.sun.codemodel.JMod;
import com.sun.codemodel.JType;
import com.sun.codemodel.JVar;
import com.sun.tools.xjc.Plugin;
import com.sun.tools.xjc.Options;
import com.sun.tools.xjc.outline.ClassOutline;
import com.sun.tools.xjc.outline.Outline;

/**
 * Support a fluent api in addition to the default (JavaBean) setter methods.<br>
 * <p>
 * The initial idea is simply to add a "with*" method to the generated class
 * for every "set*" method encountered,
 * with the only functional difference of returning the class instance, instead of void.
 * <p>
 * <strong>Enhancement on 11 June 2006:</strong><br>
 * Provide fluent setter api for Lists, with support of variable arguments.
 *
 * This enhancement was suggested by <a href="mailto:kennym@kizoom.com">Kenny MacLeod</a>,
 * and endorsed by <a href="mailto:Kohsuke.Kawaguchi@sun.com">Kohsuke Kawaguchi</a>
 * Here is quoted from the original request:
 * <p>
 * By default, XJC represents Lists by generating a getter method, but no setter.
 * This is impossible to chain with fluent-api.
 * How about the plugin generates a withXYZ() method for List properties,
 * taking as it's parameters a vararg list.  For example:<blockquote><pre>
 * // This method is generated by vanilla XJC
 * public List&lt;OtherType&gt; getMyList() {
 *   if (myList == null) {
 *     myList = new ArrayList&lt;OtherType&gt;();
 *   }
 *   return myList;
 * }
 *
 * // This would be generated by fluent-api
 * public MyClass withMyList(OtherType... values) {
 *   if (values!= null) {
 *       for(OtherType value : values) {
 *         getMyList().add(value);
 *       }
 *   }
 *   return this;
 * }
 *</pre></blockquote>
 * <strong>Enhancement on 11 Oct 2008:</strong><br>
 * Provide fluent setter api for Lists, with support of Collection argument in addition to varargs arguments.
 *
 * This enhancement was suggested by <a href="mailto:ozgwei@dev.java.net">Alex Wei</a> with patch submitted.  See
 * <a href="https://jaxb2-commons.dev.java.net/issues/show_bug.cgi?id=12">Jira Issue 12</a> for more details.
 *<p>
 * @author Hanson Char
 */
public class FluentApiPlugin extends Plugin
{
    @Override
    public String getOptionName()
    {
        return "Xfluent-api";
    }

    @Override
    public String getUsage()
    {
        return "  -Xfluent-api        :  enable fluent api for generated code";
    }

    @Override
    public boolean run(Outline outline,
        @SuppressWarnings("unused") Options opt,
        @SuppressWarnings("unused") ErrorHandler errorHandler)
    {
        final JType voidType = outline.getCodeModel().VOID;
        // Process every pojo class generated by jaxb
        for (ClassOutline classOutline : outline.getClasses()) {
            final JDefinedClass targetImplClass = classOutline.implClass;
            Collection<FluentMethodInfo> fluentMethodInfoList = new ArrayList<FluentMethodInfo>();
            Set<String> methodNames = new HashSet<String>();
            boolean isOverride = false;

            for (;;) {
                JDefinedClass implClass = classOutline.implClass;
	            // Collect the methods we are interested in
	            // but defer the respective fluent methods creation
	            // to avoid ConcurrentModificationException
	            for (JMethod jmethod : implClass.methods())
	            {
            		if (methodNames.contains(jmethod.name()))
            			continue;
	            	if (isSetterMethod(jmethod, voidType)) {
            			fluentMethodInfoList.add(new FluentMethodInfo(jmethod, FLUENT_SETTER, isOverride));
            			methodNames.add(jmethod.name());
	            	}
	            	else if (isListGetterMethod(jmethod)) {
	            		fluentMethodInfoList.add(new FluentMethodInfo(jmethod, FLUENT_LIST_SETTER, isOverride));
	            		// Originally proposed by Alex Wei ozgwei@dev.java.net:
	            		// https://jaxb2-commons.dev.java.net/issues/show_bug.cgi?id=12
	            		fluentMethodInfoList.add(new FluentMethodInfo(jmethod, FLUENT_COLLECTION_SETTER, isOverride));
            			methodNames.add(jmethod.name());
	            	}
	            }
	            // Let's climb up the class hierarchy
	            classOutline = classOutline.getSuperClass();

	            if (classOutline == null)
	            	break;
	            isOverride = true;
            }
            // Generate a respective fluent method for each setter method
            for (FluentMethodInfo fluentMethodInfo : fluentMethodInfoList)
            	fluentMethodInfo.createFluentMethod(targetImplClass);
        }
        return true;
    }

    /**
     * Returns true if the given method is a public non-static setter method that follows
     * the JavaBean convention; false otherwise.
     * The setter method can either be a simple property setter method or
     * an indexed property setter method.
     */
    private boolean isSetterMethod(JMethod jmethod, final JType VOID)
    {
        // Return type of a setter method is expected to be void.
        if (jmethod.type() == VOID) {
            JVar[] jvars = jmethod.listParams();

            switch(jvars.length) {
                case 2:
                    // could be an indexed property setter method.
                    // if so, the first argument must be the index (a primitive int).
                    if (!isInt(jvars[0].type()))
                        return false;
                    // drop thru.
                case 1:
                    // or could be a simple property setter method
                    int mods = jmethod.mods().getValue();

                    if ((mods & JMod.STATIC) == 0
                    &&  (mods & JMod.PUBLIC) == 1)
                    {
                        String methodName = jmethod.name();
                        return methodName.length() > SETTER_METHOD_PREFIX_LEN
                            && methodName.startsWith(SETTER_METHOD_PREFIX);
                    }
                    break;
            }
        }
        return false;
    }

    /**
     * Returns true if the given method is a public non-static getter method that returns
     * a List<T>; false otherwise.
     *
     * @param jmethod given method
     */
    private boolean isListGetterMethod(JMethod jmethod)
    {
        int mods = jmethod.mods().getValue();
        // check if it is a non-static public method
        if ((mods & JMod.STATIC) == 1
        ||  (mods & JMod.PUBLIC) == 0)
        	return false;
        String methodName = jmethod.name();
        // See if the method name looks like a getter method
        if (methodName.length() <= GETTER_METHOD_PREFIX_LEN
        || !methodName.startsWith(GETTER_METHOD_PREFIX))
        	return false;
        // A list getter method will have no argument.
    	if (jmethod.listParams().length > 0)
    		return false;
    	// See if the return type of the method
    	// is a List<T>
   		JType jtype = jmethod.type();

    	if (jtype instanceof JClass)
    	{
    		JClass jclass = JClass.class.cast(jtype);
    		List<JClass> typeParams = jclass.getTypeParameters();

    		if (typeParams.size() != 1)
    			return false;
    		return jclass.fullName().startsWith(PARAMETERIZED_LIST_PREFIX);
    	}
    	return false;
    }

    /** Returns true if the given type is a primitive int; false otherwise. */
    private boolean isInt(JType type)
    {
        JCodeModel codeModel = type.owner();
        return type.isPrimitive()
            && codeModel.INT.equals(
                JType.parse(codeModel, type.name()));
    }
}
