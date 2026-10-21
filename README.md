# Data-Driven-Testing-for-Web-Systems


The primary objective of this dissertation is to design, implement, and experimentally validate a hybrid end-to-end framework capable of automatically catching, propagating, and asserting relational database constraints directly through the graphical user interface.
To demonstrate this approach, a web application named Subscription Tracker was engineered using a monolithic architecture with Spring Boot for the backend, React for the frontend, and an in-memory H2 database. On top of this infrastructure, a modular, Data-Driven testing suite was developed using Robot Framework and SeleniumLibrary. The experimental matrix was systematically divided into a replication study targeting single-entity integrity constraints, and an extension study evaluating multi-table interactions and concurrency tranzactional behavior.

The automated framework was rigorously evaluated using three specialized test suites (S1.robot, S2.robot, and S3.robot) fed by externalized matrix datasets. The empirical evaluation yielded a perfect Test Pass Rate (T P R) of 100%, successfully executing all 38 test cases. The framework demonstrated high stability in capturing relational anomalies, including PRIMARY KEY colisions, FOREIGN KEY and CHECK constraint violations, and critically, concurrency tranzaction conflicts (Race Conditions) by gracefully asserting lock violation states in asynchronous browser sessions.


The results prove that physical database layer rules can be seamlessly mapped onto user interface events without crashing the web client. The original contribution of this work bridges the gap found in recent literature by expanding automated database constraint testing from isolated, flat tables into complex multi-entity systems and concurrent data environments.
