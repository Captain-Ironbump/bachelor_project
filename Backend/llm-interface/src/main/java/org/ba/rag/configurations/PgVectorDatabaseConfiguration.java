package org.ba.rag.configurations;

import org.eclipse.microprofile.config.inject.ConfigProperties;

import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
@ConfigProperties(prefix = "pgvector.database")
public class PgVectorDatabaseConfiguration {
    private String host = "localhost";
    private int port = 5432;
    private String user;
    private String password;
    private String table = "embeddings";
    
    public String getHost() {
        return host;
    }
    public void setHost(String host) {
        this.host = host;
    }
    public int getPort() {
        return port;
    }
    public void setPort(int port) {
        this.port = port;
    }
    public String getUser() {
        return user;
    }
    public void setUser(String user) {
        this.user = user;
    }
    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    public String getTable() {
        return table;
    }
    public void setTable(String table) {
        this.table = table;
    }
    
    @Override
    public String toString() {
        return "PgVectorDatabaseConfiguration [host=" + host + ", port=" + port + ", user=" + user + ", password="
                + password + ", table=" + table + "]";
    }
}
