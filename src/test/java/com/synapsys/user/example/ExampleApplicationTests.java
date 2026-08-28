package com.synapsys.user.example;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

// A dead address on purpose. The context still starts, the starter still
// registers and validates every process, and nothing reaches a real Core —
// otherwise every CI run would register a worker against live infrastructure
// and heartbeat at it for the duration of the build.
@SpringBootTest(properties = "synapsys.core-url=http://127.0.0.1:1")
class ExampleApplicationTests {

	@Test
	void contextLoads() {
	}

}
