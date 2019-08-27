# Esup-Dining

This portlet aims to deliver to student the meals available in dining halls.

You will be able to :
+ Display dining hall in differents area
+ See meals and dishes form each dining halls
+ Nutrition information about dishes
+ Your user can have specific configuration such as favorite dining hall or nutrition preferences

## Datas

You will need to insert JSON data for this portlet to work, you can watch the [JSON schema](https://github.com/gsouquet/esup-dining/blob/master/src/main/resources/schema/portlet-schema.json) to see how you will need to format your datas.

## Testing

You can test this portlet with Pluto portlet prototyping which is a jetty plugin.

Please use HSQL for test purpose, in `src/main/resources/defaults.properties` use this configuration

```
auth.bean=OfflineFixedUserAuthenticationService

[...]

db.driver=org.hsqldb.jdbcDriver
db.infos=jdbc:hsqldb:file:restaurant
db.username=sa
db.password=
```

Then just type in a command line interface 

```
mvn clean package portlet-prototyping:run
```

The server will be launched and available at `http://localhost:8080/pluto`

## Deployment and configuration

### System configuration

To use the google maps, you must indicate an API key in `src/main/webapp/WEB-INF/jsp/header.jsp`

```
<script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=GOOGLE_MAP_KEY&callback=initMap"></script>
```

Replace `GOOGLE_MAP_KEY` by your API key. If you don't have a such key, refer to https://developers.google.com/maps/documentation/javascript/get-api-key


### Deployment

This portlet is made to run in uPortal 4, to do so just run in your portal

```
ant deployPortletApp -DportletApp=path/to/[...]/target/esup-dining.war
```

And then register the portlet

### Database

Configure your database as said in the Testing chapter. 

You can perform multiple actions on the database using a maven goal,

```
mvn exec:java -Dexec.args="database" -Dexec.args="[arg]"
```

`[arg]` can take this values `create`, `update`, `delete`, `drop`

Each of these arguments refers to a `*.sql` file located in `src/main/resources/database/*.sql`

### Configuration in your portal

Add your portlet to the dashboard and go in *EDIT mode* , to configure the portlet the user will to have `diningPortletAdmin` role. Default Everyone has this role, you can update this by changing the following lines in `src/main/webapp/WEB-INF/portlet.xml`

```
<security-role-ref>
    <role-name>diningPortletAdmin</role-name>
    <role-link>Everyone</role-link>
</security-role-ref>
```

Then you will see an `Administrator configuration` link, just click it and type in the input your feed URL.
After that select the default area for your users, and that's it. All done.
