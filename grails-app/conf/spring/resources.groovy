// Place your Spring DSL code here
beans = {
    groovySql(groovy.sql.Sql, ref('dataSource'))
    groovySql_mis(groovy.sql.Sql, ref('dataSource_mis'))

}
