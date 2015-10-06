Cloud Foundry Meteor Buildpack
==============================

##Why this Buildpack?

This buildpack was modified and tested on _IBM Bluemix_. It uses the latest meteor available at https://install.meteor.com/

##Run apps easily with 'meteor' using MongoDB and/or Cloudant NoSQL 

No need to specify ENV_VARIABLES before Deployment or before runtime, just ensure the services are bound to your application at runtime.

##What variables does this specify?

There are 3 variables that are gathered from VCAP_* prior to runtime.
There are 2 variables that are set if constraints are met

###ROOT_URL

Required by meteor apps to start. Parsed from VCAP_APPLICATION prior to runtime. If you are using an alternate ROOT_URL instead of the appname.domain standard, specify this manually on your application or in your manifest.yml to override

###MONGO_URL

As with ROOT_URL this is parsed prior to runtime from VCAP_SERVICES, if you wish to override this option, specify the value in your manifest.yml or manually against your application.

###COUCHDB_URL

As with MONGO_URL this is parsed prior to runtime from VCAP_SERVICES, if you wish to override this option, specify the value in your manifest.yml or manually against your application.

###KADIRA_APP_* (meteorhacks:kadira)

KADIRA_APP_ID and KADIRA_APP_SECRET are parsed from ./kadira.settings if the file exists and "meteorhacks:kadira" package is installed. This is the case unless they are explicitly defined on the application or in the manifest

####kadira.settings should look like; 
```
KADIRA_APP_ID=<appid>
KADIRA_APP_SECRET=<appsecret>
```

###CLUSTER_WORKERS_COUNT (meteorhacks:cluster)

CLUSTER_WORKERS_COUNT=auto is set if the "meteorhacks:cluster" package is installed. This is the case unless they are explicitly defined on the application or in the manifest.
