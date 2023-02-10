package org.jvnet.jaxb.test.plugin.foo.tests;

import java.io.File;
import java.util.Collections;
import java.util.List;

import org.jvnet.jaxb.test.RunXJC3Mojo;

public class RunFooPlugin extends RunXJC3Mojo {

	@Override
	public File getSchemaDirectory() {
		return new File(getBaseDir(), "src/test/resources");
	}

	@Override
	public List<String> getArgs() {
		return Collections.singletonList("-Xfoo");
	}

}
