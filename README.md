# What does it do?
This package produces ManagedObjects for Aqueduct ORM. Aqueduct ORM uses PostgreSQL database and it is a very good ORM tool written for it. If you create ManagedObjects yourself, you can create and update tables in your database. But a lot of people like me like to design the database first and then create the ORM classes. Therefore, I developed this package.

<br/>

# How do you set it?
It uses the database information from the config.yaml file as in Aqueduct projects. In addition to these settings, there are a few other settings that are necessary for the package to work. For example, you can change the output location of the generated files and the database schema.

```
# config.yaml

outputPath: lib/model
dbSchema: public
database:
  username: postgres
  password: postgres
  host: localhost
  port: 5432
  databaseName: orm_test

```
<br>

# How can you run it?
After adding the package into dev dependencies in the pubspec.yaml file of your project, simply run the following code in the terminal.

`pub run postgres_to_orm:main`
