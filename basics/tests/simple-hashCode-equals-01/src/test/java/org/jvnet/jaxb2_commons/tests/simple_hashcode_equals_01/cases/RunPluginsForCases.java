package org.jvnet.jaxb2_commons.tests.simple_hashcode_equals_01.cases;

import java.io.File;
import java.net.URL;

import org.junit.Before;
import org.junit.Test;

import com.sun.codemodel.JCodeModel;
import com.sun.tools.xjc.ConsoleErrorReporter;
import com.sun.tools.xjc.ModelLoader;
import com.sun.tools.xjc.Options;
import com.sun.tools.xjc.model.Model;

public class RunPluginsForCases {

	@Before
	public void setUp() {
		System.setProperty("javax.xml.accessExternalSchema", "all");
	}

	@Test
	public void compilesSchema() throws Exception {

		new File("target/generated-sources/xjc").mkdirs();

		URL schema = getClass().getResource("/cases.xsd");
		// URL binding = getClass().getResource("/cases.xjb");
		final String[] arguments = new String[] { "-xmlschema",
				schema.toExternalForm(),
				// "-b", binding.toExternalForm(),
				"-d", "target/generated-sources/xjc", "-extension",
				"-XsimpleHashCode", "-XsimpleEquals",
		// "-XsimpleToString"

		};

		Options options = new Options();
		options.parseArguments(arguments);
		ConsoleErrorReporter receiver = new ConsoleErrorReporter();
		Model model = ModelLoader.load(options, new JCodeModel(), receiver);
		model.generateCode(options, receiver);
		com.sun.codemodel.CodeWriter cw = options.createCodeWriter();
		model.codeModel.build(cw);
	}
}