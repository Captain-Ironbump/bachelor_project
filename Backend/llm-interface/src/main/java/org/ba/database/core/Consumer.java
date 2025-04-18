package org.ba.database.core;

import io.agroal.pool.DataSource;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

@ApplicationScoped
public class Consumer {
    @Inject
    DataSource dataSource;
}
