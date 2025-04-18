package org.ba.database.core;

import io.quarkus.agroal.DataSource;
import io.quarkus.arc.InjectableInstance;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.inject.Produces;
import jakarta.inject.Inject;

public class Producer {
    @Inject
    @DataSource("core")
    InjectableInstance<DataSource> coreMySqlSourceBean;

    @Produces
    @ApplicationScoped
    public DataSource dataSource() {
        if (coreMySqlSourceBean.getHandle().getBean().isActive()) {
            return coreMySqlSourceBean.get();
        } else {
            throw new RuntimeException("No active datasource!");
        }
    }
}
